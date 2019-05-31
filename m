Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63F0316DF
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfEaWBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57336 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfEaWBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 18:01:13 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDEB3A3B7C;
        Fri, 31 May 2019 22:01:12 +0000 (UTC)
Received: from ovpn-204-40.brq.redhat.com (ovpn-204-40.brq.redhat.com [10.40.204.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 266805C7B3;
        Fri, 31 May 2019 22:01:05 +0000 (UTC)
Message-ID: <739e0a292a31b852e32fb1096520bb7d771f8579.camel@redhat.com>
Subject: Re: [PATCH net v3 0/3] net/sched: fix actions reading the network
 header in case of QinQ packets
From:   Davide Caratti <dcaratti@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Shuang Li <shuali@redhat.com>,
        Eli Britstein <elibr@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
In-Reply-To: <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
References: <cover.1559322531.git.dcaratti@redhat.com>
         <CAM_iQpWir7R3AQ7KSeFA5QNXSPHGK-1Nc7WsRM1vhkFyxB5ekA@mail.gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Sat, 01 Jun 2019 00:01:04 +0200
Mime-Version: 1.0
User-Agent: Evolution 3.30.3 (3.30.3-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 31 May 2019 22:01:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2019-05-31 at 11:42 -0700, Cong Wang wrote:
> On Fri, May 31, 2019 at 10:26 AM Davide Caratti <dcaratti@redhat.com> wrote:
> > 'act_csum' was recently fixed to mangle the IPv4/IPv6 header if a packet
> > having one or more VLAN headers was processed: patch #1 ensures that all
> > VLAN headers are in the linear area of the skb.
> > Other actions might read or mangle the IPv4/IPv6 header: patch #2 and #3
> > fix 'act_pedit' and 'act_skbedit' respectively.
> 
> Maybe, just maybe, vlan tags are supposed to be handled by act_vlan?
> Which means maybe users have to pipe act_vlan to these actions.

but it's not possible with the current act_vlan code.
Each 'vlan' action pushes or pops a single tag, so:

1) we don't know how many vlan tags there are in each packet, so I should
put an (enough) high number of "pop" operations to ensure that a 'pedit'
rule correctly mangles the TTL in a IPv4 packet having 1 or more 802.1Q
tags in the L2 header.

2) after a vlan is popped with act_vlan, the kernel forgets about the VLAN
ID and the VLAN type. So, if I want to just mangle the TTL in a QinQ
packet, I need to reinject it in a place where both tags (including VLAN
type *and* VLAN id) are restored in the packet.

Clearly, act_vlan can't be used as is, because 'push' has hardcoded VLAN
ID and ethertype. Unless we change act_vlan code to enable rollback of
previous 'pop' operations, it's quite hard to pipe the correct sequence of
vlan 'pop' and 'push'.

> From the code reuse perspective, you are adding TCA_VLAN_ACT_POP
> to each of them.

No, these patches don't pop VLAN tags. All tags are restored after the
action completed his work, before returning a->tcfa_action.

May I ask you to read it as a followup of commit 2ecba2d1e45b ("net:
sched: act_csum: Fix csum calc for tagged packets"), where the 'csum'
action was modified to mangle the checksum of IPv4 headers even when
multiple 802.1Q tags were present?
With this series it becomes possible to mangle also the TTL field (with
pedit), and assign the diffserv bits to skb->priority (with skbedit).

> Thanks.

Thanks for reviewing, I look forward to see more comments from you.


