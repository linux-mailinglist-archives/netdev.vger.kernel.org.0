Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B816E224B2B
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 14:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGRMaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 08:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgGRMaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 08:30:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F653C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 05:30:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jwlyg-0001ti-VK; Sat, 18 Jul 2020 14:30:07 +0200
Date:   Sat, 18 Jul 2020 14:30:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     fw@strlen.de, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: act_ct: fix restore the qdisc_skb_cb
 after defrag
Message-ID: <20200718123006.GW32005@breakpoint.cc>
References: <1595072073-6268-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595072073-6268-1-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The fragment packets do defrag in tcf_ct_handle_fragments
> will clear the skb->cb which make the qdisc_skb_cb clear
> too. So the qdsic_skb_cb should be store before defrag and
> restore after that.
> It also update the pkt_len after all the
> fragments finish the defrag to one packet and make the
> following actions counter correct.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Looks ok to me.  One question:

> @@ -1014,6 +1017,7 @@ static int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
>  
>  out:
>  	tcf_action_update_bstats(&c->common, skb);
> +	qdisc_skb_cb(skb)->pkt_len = skb->len;
>  	return retval;

This appears to be unconditional, I would have expected that
this only done for reassembled skbs?

Otherwise we will lose the value calculated by core via
qdisc_calculate_pkt_len().
