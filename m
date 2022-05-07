Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C234351E4FF
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 08:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445927AbiEGHBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359576AbiEGHBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 03:01:03 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CAF5DA4E
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 23:57:17 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x23so7998418pff.9
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 23:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ofqOYWzFm1+8QkTYUFBWiva6kDC1LMhuvEpR1Jhkfe4=;
        b=CavoxqxvNbQ2bd5LFSXCtaS6FJnae0Kqvhe1fCMGvocSAceWynDPkHdgGRZC6YgicZ
         uTb9ktrCmv3bQ9FJuiaSAXP0gzIVErsHUQ+EWpzR4IaNHGskfBcwUKrEdeh9MDVj9ZdV
         fZFSawQdwbTMh02uBHnu87sRo+go5XM9gnPmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ofqOYWzFm1+8QkTYUFBWiva6kDC1LMhuvEpR1Jhkfe4=;
        b=YoW7JdixseoGwjg6JEEX7+f++WOZHohkYWq+JcFbPBOKms9q7qpE0wWKL+gvFUMXgh
         7aCJrTR1FyuZjkruNVbD7GZeuypyzim1gkbslBQjAK1v6WaC84lx8RB1dmwQmvm5paDj
         d3XW6JbwQcmSMk0F2a8uDlmxgsO5+CwtG2YMo99osrYHyCELLnRxENMPmXVcmNmPuxEN
         YlQs0RC9E1OWTdYtfiuxwJER1rnuWTyTfTxjSt6zMuP7pM8tfpUTRiEQeuyp9j/2Xn+0
         e67qMLk20vLM+F8SrsmQl4i8y26MDSuGyvx1rachxeHT9pKdPzUL8KOEJitociayL9th
         Hx+A==
X-Gm-Message-State: AOAM5333GB9qLdJGhmT+fJmMy/TzcJtsqsvtHWP9AjB0IB9099OlKGWl
        +k4NqUIPlVoaRZwoBHuQegFCKg==
X-Google-Smtp-Source: ABdhPJyoGRq2cbSlZYYC0YXn3R//CflxAA7xPCmlA7jpzoBkfYo3byHT4L08Hq34NIYNKsBWlpOrLg==
X-Received: by 2002:a65:5181:0:b0:3aa:3668:26a9 with SMTP id h1-20020a655181000000b003aa366826a9mr5761509pgq.184.1651906637110;
        Fri, 06 May 2022 23:57:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v184-20020a6389c1000000b003c14af505fbsm4365659pgd.19.2022.05.06.23.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 23:57:16 -0700 (PDT)
Date:   Fri, 6 May 2022 23:57:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v4 net-next 12/12] mlx5: support BIG TCP packets
Message-ID: <202205062344.BB945AD3@keescook>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-13-eric.dumazet@gmail.com>
 <20220506153414.72f26ee3@kernel.org>
 <CANn89iJDP1aSwsCyVVq_qjVY8OZjg-vWULR=GN-WQV6FpLz+Mg@mail.gmail.com>
 <20220506185405.527a79d4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220506185405.527a79d4@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 06:54:05PM -0700, Jakub Kicinski wrote:
> On Fri, 6 May 2022 17:32:43 -0700 Eric Dumazet wrote:
> > On Fri, May 6, 2022 at 3:34 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Fri,  6 May 2022 08:30:48 -0700 Eric Dumazet wrote:  
> > > > From: Coco Li <lixiaoyan@google.com>
> > > >
> > > > mlx5 supports LSOv2.
> > > >
> > > > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > > > with JUMBO TLV for big packets.
> > > >
> > > > We need to ignore/skip this HBH header when populating TX descriptor.
> > > >
> > > > Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
> > > > layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.
> > > >
> > > > v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
> > > > v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y  
> > >
> > > In file included from ../include/linux/string.h:253,
> > >                  from ../arch/x86/include/asm/page_32.h:22,
> > >                  from ../arch/x86/include/asm/page.h:14,
> > >                  from ../arch/x86/include/asm/processor.h:19,
> > >                  from ../arch/x86/include/asm/timex.h:5,
> > >                  from ../include/linux/timex.h:65,
> > >                  from ../include/linux/time32.h:13,
> > >                  from ../include/linux/time.h:60,
> > >                  from ../include/linux/skbuff.h:15,
> > >                  from ../include/linux/tcp.h:17,
> > >                  from ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:33:
> > > In function ‘fortify_memcpy_chk’,
> > >     inlined from ‘mlx5e_insert_vlan’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:104:2,
> > >     inlined from ‘mlx5e_sq_xmit_wqe’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:404:5:
> > > ../include/linux/fortify-string.h:328:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > In function ‘fortify_memcpy_chk’,
> > >     inlined from ‘mlx5e_sq_xmit_wqe’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:408:5:
> > > ../include/linux/fortify-string.h:328:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > In function ‘fortify_memcpy_chk’,
> > >     inlined from ‘mlx5i_sq_xmit’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:962:4:
> > > ../include/linux/fortify-string.h:328:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
> > 
> > I guess these warnings show up before this BIG TCP patch ?
> > 
> > I do not see any struct_group() being used in mlx5
> > 
> > May I ask which compiler is used here, and what CONFIG_ option needs to be set ?
> > 
> > Thanks.
> 
> Without our patches drivers/net/ethernet/mellanox/mlx5/core/ builds
> cleanly. Gotta be the new W=1 filed overflow warnings, let's bother
> Kees.

Hello!

These aren't from W=1. The read overflows are hidden behind W=1. I
imagine this is due to gcc getting smarter and being able to introspect
the possible values of ihs during inlining.

> I believe this is the code in question:
> 
> @@ -379,15 +393,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
> 
> +		u8 *start = eseg->inline_hdr.start;
> +
> +		if (unlikely(attr->hopbyhop)) {
> +			/* remove the HBH header.
> +			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +			 */
> +			if (skb_vlan_tag_present(skb)) {
> +				mlx5e_insert_vlan(start, skb, ETH_HLEN + sizeof(*h6));
> 
> Unhappiness #1 ^^^
> 
> Where mlx5e_insert_vlan() is:
> 
> static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
> {
> 	struct vlan_ethhdr *vhdr = (struct vlan_ethhdr *)start;
> 	int cpy1_sz = 2 * ETH_ALEN;
> 	int cpy2_sz = ihs - cpy1_sz;

Why are these "int"? Seems like they should be u16?

> 
> 	memcpy(&vhdr->addrs, skb->data, cpy1_sz);
               ^^^^^ this line was actually fixed earlier.

> 	vhdr->h_vlan_proto = skb->vlan_proto;
> 	vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
> 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
               ^^^^^
This one, though, is the new problem. The lack of annotation in the
struct made me miss it -- this code is asking the compiler to
potentially copy beyond the end of the struct declaration. If this is
intentional, I could suggest a solution, but ...

> }
> 
> indeed ihs == ETH_HLEN + sizeof(*h6) will make cpy2_sz come out as something
> much bigger than the vhdr->h_vlan_encapsulated_proto field.

It sounds like it's not. In which case, I would ask: "what validates the
size of ihs?" because neither I nor the compiler can see it. :P If
nothing validates it, then this looks like a potential heap overflow,
though I haven't studied how these is laid out in memory. Maybe it's
harmless, but I never assume that. :)

-- 
Kees Cook
