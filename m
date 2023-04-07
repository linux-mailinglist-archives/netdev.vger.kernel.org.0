Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB7D6DB1B5
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjDGRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDGRg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:36:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B76B463
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 10:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680888969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=girDT/3e1iBfq8YfqylLYXxjOSDey8dBT/Mp5wOCRPk=;
        b=UviER/VAxClIrkOFWwi9D7NCrDBJUvSROYGQ1n1GlbcD3eYK1ZOU55gCuQNHuZQd7oCPBA
        JznFj4COT3R6x9pfeprrM/aulUQ+gm53e1u/jv5P/gz7RMZPP0GyNwyvZmHMypdEjhAkeZ
        /gUD83rvSyfJu+sX1GkRajd71gGS5+s=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-EuG0FsUaNY6VJ34NaqrvCA-1; Fri, 07 Apr 2023 13:36:08 -0400
X-MC-Unique: EuG0FsUaNY6VJ34NaqrvCA-1
Received: by mail-ot1-f72.google.com with SMTP id x20-20020a9d7054000000b006a149b4ad1cso12447962otj.23
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 10:36:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680888967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=girDT/3e1iBfq8YfqylLYXxjOSDey8dBT/Mp5wOCRPk=;
        b=xxxvHs6tJCEITOH09c6YaHsHcLE4jYPwR+G7VO/Dqrla+M5tEGCwza5vN1xkJXbMil
         KpPtYX6ZvrXmxPil2iMNb21jG7xU7C3gXC/2OyMsJMGjIrS9oMitNQAtJXLZ5b2xowRt
         5018FOkTtKW5HkRm/kIc6FUlSw7w+wbUEm518Ym6o54+pGqW5RaApRuPS0v+eEK76aCn
         LkF/eG3OgZpVBzPtviqpnN/k/e+VWv5C/bjd6+VfwiENbS+WZScBPIA/VJyhyLApN50J
         JWqEPw8GEXDNAx4+841pPvZZZ/+MOOmbteSrkK9QE1S8jzU5csa9p4pwiICP6dEbSXTC
         0wPw==
X-Gm-Message-State: AAQBX9fjLSpFqfxknyqg3LFjx/b6K+TW6RmUMtosO50hpDb456X59/HN
        xZcNbIdNmjMCxdGd2Zbp1M9/r2TZNkp+Rm3vl9EA4MyhpFO/hZC9fpCP3n0MKjOsyE7DXJNhHmn
        Jy7iFDjmwzPNALJt1
X-Received: by 2002:a05:6870:b690:b0:17f:8da0:ce51 with SMTP id cy16-20020a056870b69000b0017f8da0ce51mr1898796oab.13.1680888967284;
        Fri, 07 Apr 2023 10:36:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350aTgPrp2NCi7zwwA49Thy6Fhgfj8/rEUQEZAp6wz3jWRG4d8C8CLe9Z0+wJS8A8Vn22KfosIA==
X-Received: by 2002:a05:6870:b690:b0:17f:8da0:ce51 with SMTP id cy16-20020a056870b69000b0017f8da0ce51mr1898768oab.13.1680888966976;
        Fri, 07 Apr 2023 10:36:06 -0700 (PDT)
Received: from halaney-x13s (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id an19-20020a056871b19300b00183fbbe8cdfsm1294396oac.31.2023.04.07.10.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 10:36:06 -0700 (PDT)
Date:   Fri, 7 Apr 2023 12:36:03 -0500
From:   Andrew Halaney <ahalaney@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v3 09/12] net: stmmac: dwmac4: Allow platforms
 to specify some DMA/MTL offsets
Message-ID: <20230407173603.lyj5fjox23uhn2gb@halaney-x13s>
References: <20230331214549.756660-1-ahalaney@redhat.com>
 <20230331214549.756660-10-ahalaney@redhat.com>
 <ZChGswjgAOkT0jvY@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZChGswjgAOkT0jvY@corigine.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 04:58:59PM +0200, Simon Horman wrote:
> On Fri, Mar 31, 2023 at 04:45:46PM -0500, Andrew Halaney wrote:
> > Some platforms have dwmac4 implementations that have a different
> > address space layout than the default, resulting in the need to define
> > their own DMA/MTL offsets.
> > 
> > Extend the functions to allow a platform driver to indicate what its
> > addresses are, overriding the defaults.
> > 
> > Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> > ---
> > 
> > This patch (and the prior patch) are replacements for
> > https://lore.kernel.org/netdev/20230320204153.21736840@kernel.org/
> > as was requested. Hopefully I was understanding the intent correctly :)
> > 
> > I'm pretty sure further refinement will be requested for this one, but
> > it is the best I could come up with myself! Specifically some of the
> > naming, dealing with spacing in some older spots of dwmac4,
> > where the addresses should live in the structure hierarchy, etc are
> > things I would not be surprised to have to rework if this is still
> > preferred over the wrapper approach.
> > 
> > Changes since v2:
> >     * New, replacing old wrapper approach
> > 
> >  drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  91 ++++++++--
> >  .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  36 ++--
> >  .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 157 ++++++++++--------
> >  .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  51 +++---
> >  .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  67 +++++---
> >  include/linux/stmmac.h                        |  19 +++
> >  6 files changed, 279 insertions(+), 142 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> > index ccd49346d3b3..a0c0ee1dc13f 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> > @@ -336,14 +336,23 @@ enum power_event {
> >  
> >  #define MTL_CHAN_BASE_ADDR		0x00000d00
> >  #define MTL_CHAN_BASE_OFFSET		0x40
> > -#define MTL_CHANX_BASE_ADDR(x)		(MTL_CHAN_BASE_ADDR + \
> > -					(x * MTL_CHAN_BASE_OFFSET))
> > -
> > -#define MTL_CHAN_TX_OP_MODE(x)		MTL_CHANX_BASE_ADDR(x)
> > -#define MTL_CHAN_TX_DEBUG(x)		(MTL_CHANX_BASE_ADDR(x) + 0x8)
> > -#define MTL_CHAN_INT_CTRL(x)		(MTL_CHANX_BASE_ADDR(x) + 0x2c)
> > -#define MTL_CHAN_RX_OP_MODE(x)		(MTL_CHANX_BASE_ADDR(x) + 0x30)
> > -#define MTL_CHAN_RX_DEBUG(x)		(MTL_CHANX_BASE_ADDR(x) + 0x38)
> > +#define MTL_CHANX_BASE_ADDR(addrs, x)  \
> > +({ \
> > +	const struct dwmac4_addrs *__addrs = addrs; \
> > +	const u32 __x = x; \
> > +	u32 __addr; \
> > +	if (__addrs) \
> > +		__addr = __addrs->mtl_chan + (__x * __addrs->mtl_chan_offset); \
> > +	else \
> > +		__addr = MTL_CHAN_BASE_ADDR + (__x * MTL_CHAN_BASE_OFFSET); \
> > +	__addr; \
> > +})
> 
> Could this and similar macros added by this patch be functions?
> From my pov a benefit would be slightly more type safety.
> And as a bonus there wouldn't be any need to handle aliasing of input.
> 

Sure, to be honest I'll be much more comfortable coding that up anyways.
I don't do a ton of macro programming and had to refamiliarize myself of
the pitfalls that comes with it when doing this.

Thanks,
Andrew

