Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ABC523B7C
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245049AbiEKR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237350AbiEKR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:27:55 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD41506E4
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:27:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso2661007pjb.5
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5rpgo0awo8ANF1HeJdH17TV2msyuI5Ev0xvnKhXTIBc=;
        b=XiNa6Za60ujlCTyYswlSmfuFYyZd/+bFsTqr+7enQ0udBNjRLPZ0hSWO6tcrDsSKvJ
         vYM/0UYsuCNqdFHMVBi2WrbYcCn/EYV9Mvbxp8VasoXqlKX8hG6+4bPPjftwGayoOmRg
         7lPhcRQ6qzpGcUNjlYYYRW7+6PgdyaApcE110=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5rpgo0awo8ANF1HeJdH17TV2msyuI5Ev0xvnKhXTIBc=;
        b=NlZvxoK02yEaxbVmEZ/ILYJRGZOR/afG+HE/Oo2mnygXsBu/HcqlPpwLNoYNmJu/Ew
         XR9YGevcOBfD7wKG3FqJ6bYryHiy0NJGzIWB9+qvk7CBRt+Tu+MApvYNRGEL+OFyPxDU
         goV7V9PgkkBw9eDLIVuxz/V2sn2VOgekK2n77nZzNx4331dhIG7o9B5oXROT9uSqDqMb
         Xx2+4BckWmdik579SabJcHNSTm4wOMYaKRH7aORn2wqcwL6zBahPbF3CAWGRhuLQKslI
         SkJM8Oc9gPn6KOtE1xv5juxINAWbpLHBPT29166EedJRJl3r2bj23K13B7WDB0qGVV7F
         33mg==
X-Gm-Message-State: AOAM532jSRa1tOXoTF1CPfI06P64PiQ9FwrwfZD+7s0JjoKjZAAd9F7z
        XNSvZT+dRLycRgdEMrxMOcPEpw==
X-Google-Smtp-Source: ABdhPJy5itp8ONhb2BJXah3IjmH/Q/xv8vWqigArqg71QPLEg1QTSaVvroPB2ZHcXVe5LxCy7R567A==
X-Received: by 2002:a17:902:e811:b0:15e:b27b:92ef with SMTP id u17-20020a170902e81100b0015eb27b92efmr27462267plg.142.1652290073719;
        Wed, 11 May 2022 10:27:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z9-20020aa79e49000000b0050dc762813csm2107948pfq.22.2022.05.11.10.27.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 10:27:53 -0700 (PDT)
Date:   Wed, 11 May 2022 10:27:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v5 net-next 13/13] mlx5: support BIG TCP packets
Message-ID: <202205111016.8CE00EED8C@keescook>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
 <20220509222149.1763877-14-eric.dumazet@gmail.com>
 <20220509183853.23bd409d@kernel.org>
 <202205101953.3C76196@keescook>
 <20220511092648.145be621@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511092648.145be621@kernel.org>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 09:26:48AM -0700, Jakub Kicinski wrote:
> On Tue, 10 May 2022 19:55:16 -0700 Kees Cook wrote:
> > On Mon, May 09, 2022 at 06:38:53PM -0700, Jakub Kicinski wrote:
> > > So we're leaving the warning for Kees to deal with?
> > > 
> > > Kees is there some form of "I know what I'm doing" cast 
> > > that you could sneak us under the table?  
> > 
> > Okay, I've sent this[1] now. If that looks okay to you, I figure you'll
> > land it via netdev for the coming merge window?
> 
> I was about to say "great!" but perhaps given we're adding an unsafe_
> flavor of something a "it is what it is" would be a more appropriate
> reaction.

Heh, well, I think it's just calling a spade a spade: plain memcpy is
already unsafe. The goal is for the kernel's (fortified) memcpy to be
"provably" safe. :) But yeah, I get what you mean. I'm sad that I don't
yet have a workable way to deal with this code pattern, but I'm getting
close, I think. My random notes currently are:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2dc48406cd08..595d0db4e97a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -386,6 +386,14 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			stats->added_vlan_packets++;
 		} else {
 			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
+/* interface could take:
+	fas: wqe
+	dst: eth.inline_hdr.start
+	src: skb->data
+	bytes: attr->ihs
+	elements member: data
+	elements_count value: wqe_attr->ds_cnt_inl
+*/
 			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
 		}
 		dseg += wqe_attr->ds_cnt_inl;

There's a similar case with how netlink constructs things (i.e.
performing a memcpy across some of the trailing header members and then
into the flex array) that may share this code pattern, and at least one
patch to mlx5 I'd sent before could be refactored back into this to
unsplit the memcpy there.

Anyway, I'll continue to chip away at it.

-- 
Kees Cook
