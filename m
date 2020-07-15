Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BB72216DC
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGOVRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOVRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:17:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E74AC061755;
        Wed, 15 Jul 2020 14:17:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jvomA-0004YJ-VR; Wed, 15 Jul 2020 23:17:15 +0200
Date:   Wed, 15 Jul 2020 23:17:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     wenxu@ucloud.cn, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, fw@strlen.de,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net-next v2 0/3] make nf_ct_frag/6_gather elide the skb
 CB clear
Message-ID: <20200715211714.GR32005@breakpoint.cc>
References: <1594097711-9365-1-git-send-email-wenxu@ucloud.cn>
 <20200715132659.34fa0e14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715132659.34fa0e14@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue,  7 Jul 2020 12:55:08 +0800 wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > Add nf_ct_frag_gather and Make nf_ct_frag6_gather elide the CB clear 
> > when packets are defragmented by connection tracking. This can make
> > each subsystem such as br_netfilter, openvswitch, act_ct do defrag
> > without restore the CB. 
> > This also avoid serious crashes and problems in  ct subsystem.
> > Because Some packet schedulers store pointers in the qdisc CB private
> > area and parallel accesses to the SKB.
> > 
> > This series following up
> > http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
> > 
> > patch1: add nf_ct_frag_gather elide the CB clear
> > patch2: make nf_ct_frag6_gather elide the CB clear
> > patch3: fix clobber qdisc_skb_cb in act_ct with defrag
> > 
> > v2: resue some ip_defrag function in patch1
> 
> Florian, Cong - are you willing to venture an ack on these? Anyone?

Nope, sorry.  Reason is that I can't figure out the need for this series.
Taking a huge step back:

http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/

That patch looks ok to me:
I understand the problem statement/commit message and I can see how its addressed.

I don't understand why the CB clearing must be avoided.

defrag assumes skb ownership -- e.g. it may realloc skb->data
(calls pskb_may_pull), it calls skb_orphan(), etc.

AFAICS, tcf_classify makes same assumption -- exclusive ownership
and no parallel skb accesses.

So, if in fact the "only" problem is the loss of
qdisc_skb_cb(skb)->pkt_len, then the other patch looks ok to me.

If we indeed have parallel access, then I do not understand how
avoiding the memsets in the defrag path makes things any better
(see above wrt. skb pull and the like).

As for these patches here:

- if (!(IPCB(skb)->flags & IPSKB_FRAG_COMPLETE) &&
+ if ((ignore_skb_cb || !(IPCB(skb)->flags & IPSKB_FRAG_COMPLETE)) &&

This is very questionable, we take different code path depending
on call site.

Why is it okay to unconditionally take this branch for act_ct case (ignore_skb_cb set)?
