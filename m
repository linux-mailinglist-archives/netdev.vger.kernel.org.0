Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87D7587B17
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236553AbiHBKy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBKy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:54:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC24724F05
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 03:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659437666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GbunHbjLgd8X2E4/jPPBGUMIk6VWiCbgUbifli2jRQ=;
        b=h04fROZd8gkA5O8BqsTaeLwUC1ivPq9muzwMVDyxWykmHOInj8lTmXQzFLk41SMIGkdKPe
        gT203Fz3Ufo5kc3hZRX7ADI5eaG3CcEBpP8jIpCYFYISDF7Pldp9PRJ0IdUAj1d36fqumz
        zlQ8ywmRxOOoNUBsYaNFW4KJoZWV/eA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-PBhRIuhXMcKZH1A-LdsJ0Q-1; Tue, 02 Aug 2022 06:54:20 -0400
X-MC-Unique: PBhRIuhXMcKZH1A-LdsJ0Q-1
Received: by mail-qt1-f197.google.com with SMTP id a18-20020a05622a02d200b0031ed7ae9abeso8689512qtx.8
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 03:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=2GbunHbjLgd8X2E4/jPPBGUMIk6VWiCbgUbifli2jRQ=;
        b=IZ5KoVBSqwugNkKP3rjIioozx8I1fWj/Y8x3k/3j2iyLibjy4HlLWOCsBQe3KQ7QF6
         hkJT2HkdCuZwjW4R3VJOLKhx+27GDNm9IDjB7+sHgRIIdIVkT7UTchSuglPDsRmia8Gu
         FI2MwX4W7Ys0EhP4QGYGRVWIY+LA5zagG8WnipJifP9ZVdcewWphq2xjeWlikHiniuyQ
         3xRIaKbmPL3otcYoiNSZQeHXMKPVgXnTLkrAIFUbazDe0wIefxZdXm0OaChsYMhEPMif
         6dwm6BEJSXH9U6eAM2UURgHM0v5W3qTojTTAYKGK1F6tOYFEf0BMlubiq3NWn5LeWm2Q
         ki1Q==
X-Gm-Message-State: AJIora/EKm0Ir9eGQTW81FniSdXcoxu7sk93ChTEQEa2S36ttWIGm+kt
        AOr5riZowuR90/7kl4GutDsNnhoo1FdxmUCDpnIemjtHfoy1ppmFS/T8t4j585LdtPDAcjktE1k
        oD6hy+6fB48/51bYv
X-Received: by 2002:ac8:5b93:0:b0:31e:f963:4f4b with SMTP id a19-20020ac85b93000000b0031ef9634f4bmr17876518qta.461.1659437660259;
        Tue, 02 Aug 2022 03:54:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sPPu70bGd+GSm3Wkqf1BrKfmNVyC1+9x3vBiis3PNz9noftOBtQ5l6b7bhHhPjZ9aFRMGC6A==
X-Received: by 2002:ac8:5b93:0:b0:31e:f963:4f4b with SMTP id a19-20020ac85b93000000b0031ef9634f4bmr17876507qta.461.1659437660002;
        Tue, 02 Aug 2022 03:54:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id bq11-20020a05620a468b00b006b5d9a1d326sm10282268qkb.83.2022.08.02.03.54.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:54:19 -0700 (PDT)
Message-ID: <d57971bf4ff780782e68ccb1d9fd0c5bb1577ea9.camel@redhat.com>
Subject: Re: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
From:   Paolo Abeni <pabeni@redhat.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>
Cc:     "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>
Date:   Tue, 02 Aug 2022 12:54:15 +0200
In-Reply-To: <e87bd57d938ff840b567a05ceb1417cfb9f623e1.camel@nvidia.com>
References: <20220729121356.3990867-1-maximmi@nvidia.com>
         <YufYFQ6JN91lQbso@boxer>
         <e87bd57d938ff840b567a05ceb1417cfb9f623e1.camel@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-08-01 at 15:49 +0000, Maxim Mikityanskiy wrote:
> First of all, this patch is a temporary kludge. I found a bug in the
> current implementation of the unaligned mode: frames not aligned at
> least to 8 are misplaced. There is a proper fix in the driver, but it
> will be pushed to net-next, because it's huge. In the meanwhile, this
> workaround that drops packets not aligned to 8 will go to stable
> kernels.
> 
> On Mon, 2022-08-01 at 15:41 +0200, Maciej Fijalkowski wrote:
> > On Fri, Jul 29, 2022 at 03:13:56PM +0300, Maxim Mikityanskiy wrote:
> > > Striding RQ uses MTT page mapping, where each page corresponds to an XSK
> > > frame. MTT pages have alignment requirements, and XSK frames don't have
> > > any alignment guarantees in the unaligned mode. Frames with improper
> > > alignment must be discarded, otherwise the packet data will be written
> > > at a wrong address.
> > 
> > Hey Maxim,
> > can you explain what MTT stands for?
> 
> MTT is Memory Translation Table, it's a mechanism for virtual mapping
> in the NIC. It's essentially a table of pages, where each virtual page
> maps to a physical page.
> 
> > 
> > > 
> > > Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
> > > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > > Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> > > ---
> > >  .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    | 14 ++++++++++++++
> > >  include/net/xdp_sock_drv.h                         | 11 +++++++++++
> > >  2 files changed, 25 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> > > index a8cfab4a393c..cc18d97d8ee0 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
> > > @@ -7,6 +7,8 @@
> > >  #include "en.h"
> > >  #include <net/xdp_sock_drv.h>
> > >  
> > > +#define MLX5E_MTT_PTAG_MASK 0xfffffffffffffff8ULL
> > 
> > What if PAGE_SIZE != 4096 ? Is aligned mode with 2k frame fine for MTT
> > case?
> 
> PAGE_SIZE doesn't affect this value. Aligned mode doesn't suffer from
> this bug, because 2k or bigger frames are all aligned to 8.
> 
> > 
> > > +
> > >  /* RX data path */
> > >  
> > >  struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
> > > @@ -21,6 +23,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
> > >  static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
> > >  					    struct mlx5e_dma_info *dma_info)
> > >  {
> > > +retry:
> > >  	dma_info->xsk = xsk_buff_alloc(rq->xsk_pool);
> > >  	if (!dma_info->xsk)
> > >  		return -ENOMEM;
> > > @@ -32,6 +35,17 @@ static inline int mlx5e_xsk_page_alloc_pool(struct mlx5e_rq *rq,
> > >  	 */
> > >  	dma_info->addr = xsk_buff_xdp_get_frame_dma(dma_info->xsk);
> > >  
> > > +	/* MTT page mapping has alignment requirements. If they are not
> > > +	 * satisfied, leak the descriptor so that it won't come again, and try
> > > +	 * to allocate a new one.
> > > +	 */
> > > +	if (rq->wq_type == MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ) {
> > > +		if (unlikely(dma_info->addr & ~MLX5E_MTT_PTAG_MASK)) {
> > > +			xsk_buff_discard(dma_info->xsk);
> > > +			goto retry;
> > > +		}
> > > +	}
> > 
> > I don't know your hardware much, but how would this work out performance
> > wise? Are there any config combos (page size vs chunk size in unaligned
> > mode) that you would forbid during pool attach to queue or would you
> > better allow anything?
> 
> This issue isn't related to page or frame sizes, but rather to frame
> locations. As far as I understand, frames can be located at any places
> in the unaligned mode (even at odd addresses), regardless of their
> size. Frames whose addr % 8 != 0 don't really work with MTT, but it's
> not something that can be enforced on attach. Enforcing it in xp_alloc
> won't be any faster either (well, only a tiny bit, because of one fewer
> function call).
> 
> In any case, next kernels will get another page mapping mechanism,
> which supports arbitrary addresses, and it's almost as fast as MTT, as
> the preliminary testing shows. It will be used for the unaligned XSK,
> this kludge will be removed altogether, and I also plan to remove
> xsk_buff_discard.
> 
> > Also would be helpful if you would describe the use case you're fixing.
> 
> Sure - described in the beginning of the email.

@Maciej: are you satisfied by Maxim's answers?

/P

