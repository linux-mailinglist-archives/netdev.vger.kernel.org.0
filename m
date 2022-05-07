Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DECB51E515
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 09:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiEGHU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiEGHUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 03:20:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F6A5711D
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 00:16:39 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x23so8024234pff.9
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 00:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wc+Pzw5WJzuJkTg1VyadgGNpiXQTyoKFmajO+S2SY/8=;
        b=KDKe0msYq3tjpMu0fikbwQCADIBzBa22jnW6bVimKTt2Yf2vUTwDFO3ackM1ofKqxe
         P7w6TYZ1kq6HMFLgwxKXmausFRaRO0UV8dz7m7AJm98cG9GmrgRQhOEJOoLn5biFX1jG
         e/1yfLNpYSrqNdOSxv03YdUVuIAOiDt6Rxvgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wc+Pzw5WJzuJkTg1VyadgGNpiXQTyoKFmajO+S2SY/8=;
        b=Wrrn0B6T9GX7WGUUNQdQ6/u4ZkpF36ImjzBjm+68eW0nqz77OE6O/PCC7Sf7nG9IRr
         a/HmMgWzhUW1e8tiDu0Hj/QEqSYYGz/Ujf1GJ9eN6/Qw2IqcIAJPh0j1aAvRT1AqpBWc
         Snm/DPUA6oMGWgAbzTjMGQ8VaoNrSQMZziOqIpovs8RyC2J4tQvId2na1b8ReEpsmbzF
         O33nqqk8+sGLDDLIH9zzhWkI4pg6/Rluan629JC72zu5U+xCNMnfeD3lm6KwEGBjhjuR
         qO17hzjnbAHg3BOHB52jVCRVkR3szSsFy5ole1s0Y4WVUO/cijgTN36g4+uyzW1zbjtZ
         1d3A==
X-Gm-Message-State: AOAM531ESf4+x9ow/pCwDqA9fJLVfpzfVGJBJCWm3zhQq8lw0h3/rydx
        9tqu/o16Jn5yF8+cZfet2xzMtg==
X-Google-Smtp-Source: ABdhPJy//vPUh4uhMJ6pJaJG2Xx06vy2HlKgAD3QNAWiAgqh0t9ibfqqOZPr4uHyDpopyFZrq8/giA==
X-Received: by 2002:a05:6a00:88f:b0:510:7a49:b72f with SMTP id q15-20020a056a00088f00b005107a49b72fmr6926325pfj.21.1651907799119;
        Sat, 07 May 2022 00:16:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902f14200b0015e8d4eb1efsm2903058plb.57.2022.05.07.00.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 00:16:38 -0700 (PDT)
Date:   Sat, 7 May 2022 00:16:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <202205070000.031D2D4@keescook>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com>
 <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org>
 <CANn89iKQtn0a-Etk-tBrwafbe6dkBz=d3=bkwd8j8_Ed+kiCPQ@mail.gmail.com>
 <20220506193734.408c2a0d@kernel.org>
 <CANn89iLZJpTgnaEVxWvEaObrebvwivAmX+DGPGeibq5R0BKOBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iLZJpTgnaEVxWvEaObrebvwivAmX+DGPGeibq5R0BKOBg@mail.gmail.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 07:43:13PM -0700, Eric Dumazet wrote:
> On Fri, May 6, 2022 at 7:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 6 May 2022 19:10:48 -0700 Eric Dumazet wrote:
> > > On Fri, May 6, 2022 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
> > > > cleanly. Gotta be the new W=1 filed overflow warnings, let's bother
> > > > Kees.
> > >
> > > Note that inline_hdr.start is a 2 byte array.
> > >
> > > Obviously mlx5 driver copies more than 2 bytes of inlined headers.
> > >
> > > mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs)
> > > is called already with attr->ihs > 2
> > >
> > > So it should already complain ?
> >
> > It's a static checker, I presume it ignores attr->ihs because
> > it can't prove its value is indeed > 2. Unpleasant :/
> 
> Well, the unpleasant thing is that I do not see a way to get rid of
> this warning.
> Networking is full of variable sized headers.

So... this _is_ supposed to be copying off the end of struct vlan_ethhdr?
In that case, either don't use the vhdr cast, or add a flex array to
the end of the header. e.g. (untested):

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2dc48406cd08..990476b2e595 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -94,13 +94,18 @@ static inline u16 mlx5e_calc_min_inline(enum mlx5_inline_modes mode,
 static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 {
 	struct vlan_ethhdr *vhdr = (struct vlan_ethhdr *)start;
-	int cpy1_sz = 2 * ETH_ALEN;
-	int cpy2_sz = ihs - cpy1_sz;
+	void *data = skb->data;
+	const u16 cpy1_sz = sizeof(vhdr->addrs);
+	const u16 cpy2_sz = sizeof(vhdr->h_vlan_encapsulated_proto);
+	const u16 cpy3_sz = ihs - cpy1_sz - cpy2_sz;
 
-	memcpy(&vhdr->addrs, skb->data, cpy1_sz);
+	memcpy(&vhdr->addrs, data, cpy1_sz);
+	data += sizeof(cpy1_sz);
 	vhdr->h_vlan_proto = skb->vlan_proto;
 	vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
-	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
+	memcpy(&vhdr->h_vlan_encapsulated_proto, data, cpy2_sz);
+	data += sizeof(cpy2_sz);
+	memcpy(&vhdr->h_vlan_contents, data, cpy3_sz);
 }
 
 static inline void
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 2be4dd7e90a9..8178e20ce5b3 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -44,6 +44,7 @@ struct vlan_hdr {
  *	@h_vlan_proto: ethernet protocol
  *	@h_vlan_TCI: priority and VLAN ID
  *	@h_vlan_encapsulated_proto: packet type ID or len
+ *	@h_vlan_contents: The rest of the packet
  */
 struct vlan_ethhdr {
 	struct_group(addrs,
@@ -53,6 +54,7 @@ struct vlan_ethhdr {
 	__be16		h_vlan_proto;
 	__be16		h_vlan_TCI;
 	__be16		h_vlan_encapsulated_proto;
+	u8		h_vlan_contents[];
 };
 
 #include <linux/skbuff.h>


I'm still learning the skb helpers, but shouldn't this be using something
similar to skb_pull() that would do bounds checking, etc? Open-coded
accesses of skb->data have shown a repeated pattern of being a source
of flaws:
https://github.com/KSPP/linux/issues/140

And speaking to the existing code, even if skb->data were
bounds-checked, what are the bounds of "start"?

-- 
Kees Cook
