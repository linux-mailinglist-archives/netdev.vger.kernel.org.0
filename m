Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C06EA39425
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbfFGSUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729474AbfFGSUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 14:20:25 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76147C1EB1F8;
        Fri,  7 Jun 2019 18:20:19 +0000 (UTC)
Received: from ovpn-204-78.brq.redhat.com (ovpn-204-78.brq.redhat.com [10.40.204.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94B9E6AD32;
        Fri,  7 Jun 2019 18:20:13 +0000 (UTC)
Message-ID: <f596bf75a8ed664291fa3a7b81a5693a14ae8f9e.camel@redhat.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eli Britstein <elibr@mellanox.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
In-Reply-To: <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
         <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
         <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
         <CAM_iQpUmuHH8S35ERuJ-sFS=17aa-C8uHSWF-WF7toANX2edCQ@mail.gmail.com>
         <82ec3877-8026-67f7-90d8-6e9988513fef@mellanox.com>
         <CAM_iQpXsGc2EpGkLq_3tcgiD+Mshe1GvGuURwcmeBEqpmQaiTw@mail.gmail.com>
         <d480caba-16e2-da3e-be33-ff4aeb5c6420@mellanox.com>
         <CAM_iQpXqQ_smFtY4E6Jefki=htih_jW+jNzB1XNuzY1BzWqveQ@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 07 Jun 2019 20:20:12 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 07 Jun 2019 18:20:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-05 at 18:42 -0700, Cong Wang wrote:
> On Tue, Jun 4, 2019 at 11:19 AM Eli Britstein <elibr@mellanox.com> wrote:

hello Cong and Eli,

and thanks for all the thoughts.

> > On 6/4/2019 8:55 PM, Cong Wang wrote:
> > > On Sat, Jun 1, 2019 at 9:22 PM Eli Britstein <elibr@mellanox.com> wrote:
> > > > I think that's because QinQ, or VLAN is not an encapsulation. There is
> > > > no outer/inner packets, and if you want to mangle fields in the packet
> > > > you can do it and the result is well-defined.
> > > Sort of, perhaps VLAN tags are too short to be called as an
> > > encapsulation, my point is that it still needs some endpoints to push
> > > or pop the tags, in a similar way we do encap/decap.
> > > 
> > > 
> > > > BTW, the motivation for my fix was a use case were 2 VGT VMs
> > > > communicating by OVS failed. Since OVS sees the same VLAN tag, it
> > > > doesn't add explicit VLAN pop/push actions (i.e pop, mangle, push). If
> > > > you force explicit pop/mangle/push you will break such applications.
> > >  From what you said, it seems act_csum is in the middle of packet
> > > receive/transmit path. So, which is the one pops the VLAN tags in
> > > this scenario? If the VM's are the endpoints, why not use act_csum
> > > there?
> > 
> > In a switchdev mode, we can passthru the VFs to VMs, and have their
> > representors in the host, enabling us to manipulate the HW eswitch
> > without knowledge of the VMs.
> > 
> > To simplify it, consider the following setup:
> > 
> > v1a <-> v1b and v2a <-> v2b are veth pairs.
> > 
> > Now, we configure v1a.20 and v2a.20 as VLAN devices over v1a/v2a
> > respectively (and put the "a" devs in separate namespaces).
> > 
> > The TC rules are on the "b" devs, for example:
> > 
> > tc filter add dev v1b ... action pedit ... action csum ... action
> > redirect dev v2b
> > 
> > Now, ping from v1a.20 to v1b.20. The namespaces transmit/receive tagged
> > packets, and are not aware of the packet manipulation (and the required
> > act_csum).
> 
> This is what I said, v1b is not the endpoint which pops the vlan tag,
> v1b.20 is. So, why not simply move at least the csum action to
> v1b.20? With that, you can still filter and redirect packets on v1b,
> you still even modify it too, just defer the checksum fixup to the
> endpoint.
> 
> And to be fair, if this case is a valid concern, so is VXLAN case,
> just replace v1a.20 and v2a.20 with VXLAN tunnels. If you modify
> the inner header, you have to fixup the checksum in the outer
> UDP header.

at least with single "accelerated" vlan tags, I think that users of
tc_skb_protocol() that explicitly access the IP header should be fixed the
same way that Eli did to 'csum'.

(note that 'pedit' is *not* among them, and that's why Eli only needed to
fix 'csum' in his setup :) )
 
Now I'm no more sure about what to do with the QinQ case, whether we
should:

a) fix missing skb_may_pull() in csum, and fix (a couple of) other actions
in the same way, 

or

b) rework act_csum when it wants to read the IP header, in a way that only
ip header is mangled only when there are only zero or a single
"accelerated" tag, and do the same for (a couple of) other actions.

The pop/push approach built in the action ( option a) ) fixes my
environment - but like Cong says, it only would work with VLANs, and not
with other encapsulations. Probably it really makes sense to see if it's
possible to extend act_vlan in a way that it reconstructs the packet after
an iteration of 'vlan pop'. This might not be easy, because even the above
command assumes that inner and outer tag have the same ethertype (which is
not generally true for QinQ).

But until then, we should assume that read/writes of the IP header are not
feasible for QinQ traffic, just like it's not possible for tunneled
packets, and adjust configuration accordingly.

WDYT?

-- 
davide

