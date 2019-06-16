Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F894769C
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 21:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfFPTpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 15:45:01 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48736 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfFPTpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 15:45:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hcb5G-0002aY-2r; Sun, 16 Jun 2019 21:44:58 +0200
Message-ID: <d16897007cee0561127c3155f90a83deb2853cfa.camel@sipsolutions.net>
Subject: Re: VLAN tags in mac_len
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        roopa@cumulusnetworks.com, jhs@mojatatu.com,
        David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        Simon Horman <simon.horman@netronome.com>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>
Date:   Sun, 16 Jun 2019 21:44:55 +0200
In-Reply-To: <9e3261a9-0fd2-aa36-d739-9f1adca1408b@cumulusnetworks.com> (sfid-20190616_105201_738030_DAEF0153)
References: <68c99662210c8e9e37f198ddf8cb00bccf301c4b.camel@sipsolutions.net>
         <20190615151913.cgrfyflwwnhym4u2@ast-mbp.dhcp.thefacebook.com>
         <e487656b854ca999d14eb8072e5553eb2676a9f4.camel@sipsolutions.net>
         <9e3261a9-0fd2-aa36-d739-9f1adca1408b@cumulusnetworks.com>
         (sfid-20190616_105201_738030_DAEF0153)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-06-16 at 11:51 +0300, Nikolay Aleksandrov wrote:

> > Thinking along those lines, I sort of ended up with the following scheme
> > (just for the skb head, not the frags/fraglist):
> > 
> >           +------------------+----------------+---------------+
> >  headroom | eth | vlan | ... | IP  | TCP      | payload       | tailroom
> >           +------------------+----------------+---------------+
> > ^ skb->head_ptr
> >           ^ skb->l2_ptr
> >                              ^ skb->l3_ptr == skb->l2_ptr + skb->l2_len
> >                                     ...
> >                                               ^ skb->payload_ptr
> >                                                               ^ skb->tail
[...]

> > (Now, if you wanted to implement this, you probably wouldn't have l2_ptr
> > but l2_offset etc. but that's an implementation detail.)
> > 
> 
> I do like the scheme outlined above, it makes it easier to reason about
> all of this, but obviously it'd require quite some changes.

Yeah. I'm not really ready to suggest something as radical.

But as you found out below, I even got confused *again* while
*carefully* looking at this, and messed up mac_len vs. mac_header_len.

In fact, even looking at it now, I'm not entirely sure I see the
difference. Why do we need both? They have different implementation
semantics, but shouldn't they sort of be the same?

> > > It breaks connectivity between bridge and
> > > members when vlans are used. The host generated packets going out of the bridge
> > > have mac_len = 0.
> > 
> > Which probably indicates that we're not even consistent with the egress
> > scheme I pointed out above, probably because we *also* have
> > hard_header_len?
> > 
> 
> IIRC, mac_len is only set on Rx, while on Tx it usually isn't. More below.

Yes, looks like.

> > I'm not even sure I understand the bug that Nikolay described, because
> > br_dev_xmit() does:
> > 
> >         skb_reset_mac_header(skb);
> >         eth = eth_hdr(skb);
> >         skb_pull(skb, ETH_HLEN);
> > 
> > so after this we *do* end up with an SKB that has mac_len == ETH_HLEN,
> > if it was transmitted out the bridge netdev itself, and thus how would
> > the bug happen?
> > 
> 
> I said *mac_len*. :) 

Yes, I confused myself here.

> The above sets mac_header, at that point you'll have
> the following values: mac_len = 0, mac_header_len = 14 (skb_mac_header_len
> uses network_header - mac_header which is set there), but that is easy
> to overcome and if you do go down the path of consistently using and updating
> mac_len it should work.

Yeah, so basically all we really need is to actually call
skb_reset_mac_len() in addition to skb_reset_mac_header().

Which, is, "slightly" confusing (to say the least) - why are mac_len and
mac_header two completely separate concepts? It almost seems like they
should be two sides of the same coin (len/ptr) but we also have
mac_header_len...

Oh well.

So maybe we should go back to square 1 and resend the patches Zahari had
originally, but with the added skb_reset_mac_len()?

johannes

