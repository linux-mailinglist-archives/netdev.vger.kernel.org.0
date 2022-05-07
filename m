Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6D51E552
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 09:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383544AbiEGHuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 May 2022 03:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358709AbiEGHuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 May 2022 03:50:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACA453B55
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 00:46:18 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id t13so7889355pgn.8
        for <netdev@vger.kernel.org>; Sat, 07 May 2022 00:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bG1lfOw0gYB4Hj9EXFbaQ7U10hHdJO0es6gnE8C7D3A=;
        b=WWWqlrJLd5rQHmbPxI6mK8GX1j030cfHlBukVQfrR4KW72j3KaZ4jqjPojVpc9jPmB
         PI32OHaMSJNkFjg2IsDaGWjORdaWrBjgvsHMmdFiqq8a0ymJDR/S19Rpuw62QjOhMDLB
         XCH66b8op60ZS/sS7UVkTe/lTpe8i0ThLN//o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bG1lfOw0gYB4Hj9EXFbaQ7U10hHdJO0es6gnE8C7D3A=;
        b=tnqI9BlJSUW23vWRKK/4w+MH3j9TI0lh4FL/YXsAKSB67kCQ3j2u+XV4DabeAOwJ61
         1Eu2zS0ACxzMEKvtiv2dE4dsPB37lOa6Yufw+bXcPWU17kQ+TFxVSb+467/auo7EAVqk
         7qPBnxAfKYi804Bpi+0q6BspgONUQ0Dai7xzPN/E9tlkm5awA5/9do5rSr9gGsZow7jc
         Bl9KbCC+ZF325a3q4oL/8d1nbQAGovwy4R5vDoHezyLn9ekQbZaCBD8q1yOSOF+Nw74K
         PvHzdT4b2K1JTn9j29RfnzDmEzPErbK2N6zMmvqoH/KcSkpiqTqRR7wH6bBrhOA531gw
         Hntg==
X-Gm-Message-State: AOAM531QskYM0Rda37Sq0SUHALodZFjV289mveIRfZBnNSGcOX2n/Nt8
        +X8AMihE9ow5v7IVVBjIZMhPjA==
X-Google-Smtp-Source: ABdhPJyhkAysDB6RqgVWxk9976zbUNaF1SYtFT2gcnelJHCZBOospc0InSzSdZis10qeajcKfLSmXg==
X-Received: by 2002:a63:4e62:0:b0:398:cb40:19b0 with SMTP id o34-20020a634e62000000b00398cb4019b0mr5913006pgl.445.1651909578276;
        Sat, 07 May 2022 00:46:18 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d133-20020a621d8b000000b0050dc7628196sm4637796pfd.112.2022.05.07.00.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 May 2022 00:46:17 -0700 (PDT)
Date:   Sat, 7 May 2022 00:46:17 -0700
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
Message-ID: <202205070026.11B94DF@keescook>
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
> > > In function ‘fortify_memcpy_chk’,
> > >     inlined from ‘mlx5e_sq_xmit_wqe’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:408:5:
> > > ../include/linux/fortify-string.h:328:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Ah, my old friend, inline_hdr.start. Looks a lot like another one I fixed
earlier in ad5185735f7d ("net/mlx5e: Avoid field-overflowing memcpy()"):

        if (attr->ihs) {
                if (skb_vlan_tag_present(skb)) {
                        eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs + VLAN_HLEN);
                        mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
                        stats->added_vlan_packets++;
                } else {
                        eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
                        memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
			^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                }
                dseg += wqe_attr->ds_cnt_inl;

This is actually two regions, 2 bytes in eseg and everything else in
dseg. Splitting the memcpy() will work:

	memcpy(eseg->inline_hdr.start, skb->data, sizeof(eseg->inline_hdr.start));
	memcpy(dseg, skb->data + sizeof(eseg->inline_hdr.start), ihs - sizeof(eseg->inline_hdr.start));

But this begs the question, what is validating that ihs -2 is equal to
wqe_attr->ds_cnt_inl * sizeof(*desg) ?

And how is wqe bounds checked?


> > > In function ‘fortify_memcpy_chk’,
> > >     inlined from ‘mlx5i_sq_xmit’ at ../drivers/net/ethernet/mellanox/mlx5/core/en_tx.c:962:4:
> > > ../include/linux/fortify-string.h:328:25: warning: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribute-warning]
> > >   328 |                         __write_overflow_field(p_size_field, size);
> > >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

And moar inline_hdr.start:

	if (attr.ihs) {
		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
		eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
		dseg += wqe_attr.ds_cnt_inl;
	}

again, a split:

	memcpy(eseg->inline_hdr.start, skb->data, sizeof(eseg->inline_hdr.start));
	eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
	memcpy(dseg, skb->data + sizeof(eseg->inline_hdr.start), ihs - sizeof(eseg->inline_hdr.start));
	dseg += wqe_attr.ds_cnt_inl;

And the same bounds questions come up.

It'd be really nice to get some kind of generalized "copy out of
skb->data with bounds checking that may likely all get reduced to
constant checks".

-- 
Kees Cook
