Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1F56610CA
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 19:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjAGSZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 13:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjAGSZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 13:25:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829213E867
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 10:25:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45A7AB803F5
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 18:25:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53F1C433EF;
        Sat,  7 Jan 2023 18:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673115905;
        bh=HxM5jgIKgIGw/TbKfOPSvHJFIxcFUoes7uYc6tovmxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hbhSIvHsFn2ERlq0vT7wU08Ni0XA8X8Z41ZKaKlTsE1RUWgrpND4t1Cw1r7oEPZiS
         dko/DabBZ0vZo4O8R2T8Kb8ldFwUX7mm+sSuSdpJWZyybGBgrkKw0g5TeRna1fqJYt
         2qFfU7gHW37xk1lwUXzKRNm1ZHxRqme0HJl0W8NNuX6C0Zaz6mi1DKjWbViaH1/kuQ
         4SrEJylPAJ5algYUtAFNwfKQ4u5syLykVZ4SdtIN7CcHf8ebhnMj5H0jiQJxutcoRW
         RsankferDk/FUEgNQ8fQKmSnHBBnMd5uW9j5FfOsoF72CblmXS32WULtM+SQrKG0CS
         LwNoLvDW3x3bw==
Date:   Sat, 7 Jan 2023 10:25:04 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, g.nault@alphalink.fr,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <Y7m5AKECbfk0Mq0K@x130>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230105191339.506839-2-xiyou.wangcong@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jan 11:13, Cong Wang wrote:
>From: Cong Wang <cong.wang@bytedance.com>
>
>l2tp uses l2tp_tunnel_list to track all registered tunnels and
>to allocate tunnel ID's. IDR can do the same job.
>
>More importantly, with IDR we can hold the ID before a successful
>registration so that we don't need to worry about late error
>hanlding, it is not easy to rollback socket changes.
>
>This is a preparation for the following fix.
>
>Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>Cc: Guillaume Nault <g.nault@alphalink.fr>
>Cc: Jakub Sitnicki <jakub@cloudflare.com>
>Cc: Eric Dumazet <edumazet@google.com>
>Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>---
> net/l2tp/l2tp_core.c    | 93 ++++++++++++++++++++++-------------------
> net/l2tp/l2tp_core.h    |  3 +-
> net/l2tp/l2tp_netlink.c |  3 +-
> net/l2tp/l2tp_ppp.c     |  3 +-
> 4 files changed, 57 insertions(+), 45 deletions(-)
>
>diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>index 9a1415fe3fa7..570249a91c6c 100644
>--- a/net/l2tp/l2tp_core.c
>+++ b/net/l2tp/l2tp_core.c
>@@ -104,9 +104,9 @@ static struct workqueue_struct *l2tp_wq;
> /* per-net private data for this module */
> static unsigned int l2tp_net_id;
> struct l2tp_net {
>-	struct list_head l2tp_tunnel_list;
>-	/* Lock for write access to l2tp_tunnel_list */
>-	spinlock_t l2tp_tunnel_list_lock;
>+	/* Lock for write access to l2tp_tunnel_idr */
>+	spinlock_t l2tp_tunnel_idr_lock;
>+	struct idr l2tp_tunnel_idr;
> 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
> 	/* Lock for write access to l2tp_session_hlist */
> 	spinlock_t l2tp_session_hlist_lock;
>@@ -208,13 +208,10 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
> 	struct l2tp_tunnel *tunnel;
>
> 	rcu_read_lock_bh();
>-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
>-		if (tunnel->tunnel_id == tunnel_id &&
>-		    refcount_inc_not_zero(&tunnel->ref_count)) {
>-			rcu_read_unlock_bh();
>-
>-			return tunnel;
>-		}
>+	tunnel = idr_find(&pn->l2tp_tunnel_idr, tunnel_id);
>+	if (tunnel && refcount_inc_not_zero(&tunnel->ref_count)) {
>+		rcu_read_unlock_bh();
>+		return tunnel;
> 	}
> 	rcu_read_unlock_bh();
>
>@@ -224,13 +221,14 @@ EXPORT_SYMBOL_GPL(l2tp_tunnel_get);
>
> struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth)
> {
>-	const struct l2tp_net *pn = l2tp_pernet(net);
>+	struct l2tp_net *pn = l2tp_pernet(net);

Any reason to remove the const keyword ? 

Other than that LGTM:
Reviewed-by: Saeed Mahameed <saeed@kernel.org>

