Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0D8661165
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 20:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjAGTsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 14:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjAGTsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 14:48:19 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E4A4166F
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 11:48:18 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id t17so3387751qvw.6
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 11:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p0bzO6pvxcDBf8YDAy+2XT/75jkz2eDm5OTJLF2eqBE=;
        b=SKrSQSd4v2wht7C8oGaIKUh0mIcOwgeBrT/iQGOdYLv1KA0Zf1ajs5Bf3g9Kt/bBAf
         mTpOwRipaLTsZrkNJVD5w5ia/6kAeV3XKXpOFqCbhNJ1Jh+maXberA859XmbOAxn+GpS
         iXpfBfz8KmcVhj2n49UI0Xi14o9KwPgd9lYpX/RqD8hwcSZ5ldV75HlgROxg/4VjSFL8
         od5nKmoWf976/T8t6pk2y1ikbn5Ig8628x6uXsoIQnStEixIbYcmdjg15I4YygSM7UlX
         pCaWfFd6+2wH0FvLu8Cd+zig7/JelYmLeZ8pAUJqdsXJjvrFox5CwpvTEWjotwkzpiVx
         wbhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0bzO6pvxcDBf8YDAy+2XT/75jkz2eDm5OTJLF2eqBE=;
        b=pzq6a9H5TlfnGEOGiIpfBkdZp1aHbFRBwXvVSUQgTRQemKz5mHXvuZQvRbL+Z/7umz
         1/dx0lnyA89LGhKQkv2lrl64Fy2nHH6iz8sGfB2IyeBPUzVGeV9i/golW4kz0xSDrzL/
         wyZq0h1Zyeet07YsA8cA9JrO9Y9ojd3ENCCn0WuWnBUf/Yl+GUB0sfFCGM1ARCrWF/CG
         11VdblxQn4Ib4GQuoc68h+MGQGAJA2dKcdNxj9KurSqIEvCrBI3adN+X4udWw4ddbfds
         pSphXabfrNEPVv8yvs/6dW5X9NUyy+q3fhz/qNX68gJ/1zCwaBDM6QRWj6S7w9HWN6v/
         /WrQ==
X-Gm-Message-State: AFqh2kqdqLOcN0u29DoxZ7J6Wv+5V7reB+QBwDW1Opy+XgRz60S3poKI
        HHd7O4VmXj/qR6nAhalgQT0=
X-Google-Smtp-Source: AMrXdXvtlUk0IuhO+u32nxyXiFNdMBuxkgIH7QnEUHyVPGfzOwbi1+UFiUDJEiki53hwHD8CHhCR/g==
X-Received: by 2002:a05:6214:330e:b0:532:1250:9bb7 with SMTP id mo14-20020a056214330e00b0053212509bb7mr15268525qvb.34.1673120897507;
        Sat, 07 Jan 2023 11:48:17 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:d403:a631:b9f0:eacb])
        by smtp.gmail.com with ESMTPSA id bq35-20020a05620a46a300b00704c9015e68sm2627518qkb.116.2023.01.07.11.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 11:48:16 -0800 (PST)
Date:   Sat, 7 Jan 2023 11:48:15 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, g.nault@alphalink.fr,
        Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [Patch net 1/2] l2tp: convert l2tp_tunnel_list to idr
Message-ID: <Y7nMf2TuV8GS8xII@pop-os.localdomain>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
 <20230105191339.506839-2-xiyou.wangcong@gmail.com>
 <Y7m5AKECbfk0Mq0K@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7m5AKECbfk0Mq0K@x130>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 10:25:04AM -0800, Saeed Mahameed wrote:
> On 05 Jan 11:13, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > l2tp uses l2tp_tunnel_list to track all registered tunnels and
> > to allocate tunnel ID's. IDR can do the same job.
> > 
> > More importantly, with IDR we can hold the ID before a successful
> > registration so that we don't need to worry about late error
> > hanlding, it is not easy to rollback socket changes.
> > 
> > This is a preparation for the following fix.
> > 
> > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Cc: Guillaume Nault <g.nault@alphalink.fr>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> > net/l2tp/l2tp_core.c    | 93 ++++++++++++++++++++++-------------------
> > net/l2tp/l2tp_core.h    |  3 +-
> > net/l2tp/l2tp_netlink.c |  3 +-
> > net/l2tp/l2tp_ppp.c     |  3 +-
> > 4 files changed, 57 insertions(+), 45 deletions(-)
> > 
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index 9a1415fe3fa7..570249a91c6c 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> > @@ -104,9 +104,9 @@ static struct workqueue_struct *l2tp_wq;
> > /* per-net private data for this module */
> > static unsigned int l2tp_net_id;
> > struct l2tp_net {
> > -	struct list_head l2tp_tunnel_list;
> > -	/* Lock for write access to l2tp_tunnel_list */
> > -	spinlock_t l2tp_tunnel_list_lock;
> > +	/* Lock for write access to l2tp_tunnel_idr */
> > +	spinlock_t l2tp_tunnel_idr_lock;
> > +	struct idr l2tp_tunnel_idr;
> > 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
> > 	/* Lock for write access to l2tp_session_hlist */
> > 	spinlock_t l2tp_session_hlist_lock;
> > @@ -208,13 +208,10 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
> > 	struct l2tp_tunnel *tunnel;
> > 
> > 	rcu_read_lock_bh();
> > -	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
> > -		if (tunnel->tunnel_id == tunnel_id &&
> > -		    refcount_inc_not_zero(&tunnel->ref_count)) {
> > -			rcu_read_unlock_bh();
> > -
> > -			return tunnel;
> > -		}
> > +	tunnel = idr_find(&pn->l2tp_tunnel_idr, tunnel_id);
> > +	if (tunnel && refcount_inc_not_zero(&tunnel->ref_count)) {
> > +		rcu_read_unlock_bh();
> > +		return tunnel;
> > 	}
> > 	rcu_read_unlock_bh();
> > 
> > @@ -224,13 +221,14 @@ EXPORT_SYMBOL_GPL(l2tp_tunnel_get);
> > 
> > struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth)
> > {
> > -	const struct l2tp_net *pn = l2tp_pernet(net);
> > +	struct l2tp_net *pn = l2tp_pernet(net);
> 
> Any reason to remove the const keyword ?

Yes, GCC complained about discarding const in idr_for_each_entry_ul().

Thanks.
