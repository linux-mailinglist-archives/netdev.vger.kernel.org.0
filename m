Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4832F2115C2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgGAWVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGAWVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:21:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929BCC08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 15:21:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 13C0B149591E6;
        Wed,  1 Jul 2020 15:21:17 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:21:16 -0700 (PDT)
Message-Id: <20200701.152116.1519098438346883237.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     paulb@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net/sched: act_ct: fix restore the
 qdisc_skb_cb after defrag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
References: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:21:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Mon, 29 Jun 2020 17:16:17 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> The fragment packets do defrag in tcf_ct_handle_fragments
> will clear the skb->cb which make the qdisc_skb_cb clear
> too and set the pkt_len to 0. The bytes always 0 when dump
> the filter. And it also update the pkt_len after all the
> fragments finish the defrag to one packet and make the
> following action counter correct.
> 
> filter protocol ip pref 2 flower chain 0 handle 0x2
>   eth_type ipv4
>   dst_ip 1.1.1.1
>   ip_flags frag/firstfrag
>   skip_hw
>   not_in_hw
>  action order 1: ct zone 1 nat pipe
>   index 2 ref 1 bind 1 installed 11 sec used 11 sec
>  Action statistics:
>  Sent 0 bytes 11 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
>  cookie e04106c2ac41769b278edaa9b5309960
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

This is a much larger and serious problem IMHO.  And this fix is
not sufficient.

Nothing can clobber the qdisc_skb_cb like this in these packet flows
otherwise we will have serious crashes and problems.  Some packet
schedulers store pointers in the qdisc CB private area, for example.

We need to somehow elide the CB clear when packets are defragmented by
connection tracking.
