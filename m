Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8E6DCCCB
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 23:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjDJVZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 17:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjDJVZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 17:25:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3231FC1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 14:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681161867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=guIPUS4b/KI5jRIGt0RS4kaJQ4UcCDM9VQ9qZvewB+Q=;
        b=hhZQ5eYhAFmUcisBOXb9EdX7Gzdn70kQ3y+jNa/TP33fyPf1Hu20nIKl0/Hwi6K75fLvuD
        invxjP4B7WtKSyCjsi7gq9XvXOXHwz9w38t5tQ5gF8juVseNpWfyF12UGs7QE5Aq3IPTMu
        Uskv0RdMfyP6hataiF0BkEdn+8hwF1o=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-PyEBoWVOOA2XQFUwzJsnNQ-1; Mon, 10 Apr 2023 17:24:26 -0400
X-MC-Unique: PyEBoWVOOA2XQFUwzJsnNQ-1
Received: by mail-oi1-f197.google.com with SMTP id bd37-20020a056808222500b003894ce81c46so10611510oib.1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 14:24:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681161866;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guIPUS4b/KI5jRIGt0RS4kaJQ4UcCDM9VQ9qZvewB+Q=;
        b=AS39Wp5It1ysXNh0mGhgAFIzb76uNwIBpVzJZgn8jHmVThkcM793GqPce1B+xKjyJJ
         D6Jodfl7fYQxLv07eip1NBlTZ2l6BciRsPJzf+zwtJWGTCd4mB/gIIIAIUb9LPCd06RK
         NjU+NqD/zdUuJZkbF+vyGEH5c8ITj2KzFfEn9gHyXkBZD2xtJIzVSBDiK4Q60L/JkIWD
         NOtB93nMK8PbTTiFgiZVJ+zshHksW8XBmUAnlCm1IJXrbysW/haL+aCXHzOFNFCzGRDd
         t7Qz/bZ2rQ7LaPDVbqw73D8bKjity7ztUb0JKu1vgjWv7XC9PIQU0z9tvYTCNhGcSuAb
         do5g==
X-Gm-Message-State: AAQBX9eEIWFA/YZ5/FjrOk2Q+pLThWJVE/QMcUMbSUvlcljBJahOg/HR
        bhqvS9Yge4xnS3HpeV2OOEZft62q41fUAwd8LTtm+szdZLAr4hMY2PSdjZ04rIcbxZY5oBbkutX
        2q/vmCB3fGR8egCt/
X-Received: by 2002:a05:6808:1a27:b0:38b:c1b4:6af9 with SMTP id bk39-20020a0568081a2700b0038bc1b46af9mr2735753oib.4.1681161866118;
        Mon, 10 Apr 2023 14:24:26 -0700 (PDT)
X-Google-Smtp-Source: AKy350bgc7ZX4XjpSwPu1lYDObg75z6mEqgIGHBCnCkz1NdyheSPE+5IoVPpSan2LLi+1tqeOtiR4Q==
X-Received: by 2002:a05:6808:1a27:b0:38b:c1b4:6af9 with SMTP id bk39-20020a0568081a2700b0038bc1b46af9mr2735718oib.4.1681161865851;
        Mon, 10 Apr 2023 14:24:25 -0700 (PDT)
Received: from halaney-x13s (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id w127-20020a4a5d85000000b00525398a1144sm5117502ooa.32.2023.04.10.14.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 14:24:25 -0700 (PDT)
Date:   Mon, 10 Apr 2023 16:24:22 -0500
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
Subject: Re: [PATCH net-next v3 08/12] net: stmmac: Pass stmmac_priv in some
 callbacks
Message-ID: <20230410212422.2rztlqspw5vjtb4d@halaney-x13s>
References: <20230331214549.756660-1-ahalaney@redhat.com>
 <20230331214549.756660-9-ahalaney@redhat.com>
 <ZChIbc6TnQyZ/Fiu@corigine.com>
 <20230407173453.hsfhbr66254z57ym@halaney-x13s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407173453.hsfhbr66254z57ym@halaney-x13s>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 12:34:53PM -0500, Andrew Halaney wrote:
> On Sat, Apr 01, 2023 at 05:06:21PM +0200, Simon Horman wrote:
> > On Fri, Mar 31, 2023 at 04:45:45PM -0500, Andrew Halaney wrote:
> > > Passing stmmac_priv to some of the callbacks allows hwif implementations
> > > to grab some data that platforms can customize. Adjust the callbacks
> > > accordingly in preparation of such a platform customization.
> > > 
> > > Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> > 
> > ...
> > 
> > >  #define stmmac_reset(__priv, __args...) \
> > > @@ -223,59 +240,59 @@ struct stmmac_dma_ops {
> > >  #define stmmac_dma_init(__priv, __args...) \
> > >  	stmmac_do_void_callback(__priv, dma, init, __args)
> > >  #define stmmac_init_chan(__priv, __args...) \
> > > -	stmmac_do_void_callback(__priv, dma, init_chan, __args)
> > > +	stmmac_do_void_callback(__priv, dma, init_chan, __priv, __args)
> > 
> > Hi Andrew,
> > 
> > Rather than maintaining these macros can we just get rid of them?
> > I'd be surprised if things aren't nicer with functions in their place [1].
> > 
> > f.e., we now have (__priv, ..., __priv, ...) due to a generalisation
> >       that seems to take a lot more than it gives.
> > 
> > [1] https://lore.kernel.org/linux-arm-kernel/ZBst1SzcIS4j+t46@corigine.com/
> > 
> 
> Thanks for the pointer. I think that makes sense, I'll take that
> approach for these functions (and maybe in a follow-up series I'll
> tackle all of them just because the lack of consistency will eat me up).
> 

I tried taking this approach for a spin, and I'm not so sure about it
now!

1. Implementing the functions as static inline requires us to know
   about stmmac_priv, but that's getting into circular dependency land
2. You could define them in hwif.c, but then they're not inlined
3. There's still a good bit of boilerplate that's repeated all over
   with the approach. Ignoring 1 above, you get something like this:

static inline int stmmac_init_chan(struct stmmac_priv *priv,
				   void __iomem *ioaddr,
				   struct stmmac_dma_cfg *dma_cfg, u32 chan)
{
	if (priv->hw->dma && priv->hw->dma->init_chan) {
		priv->hw->dma->init_chan(priv, ioaddr, dma_cfg, chan);
		return 0;
	}
	return -EINVAL;
}

that is then repeated for every function... which is making me actually
appreciate the macros some for reducing boilerplate.

Am I suffering from a case of holiday brain, and 1-3 above are silly
points with obvious answers, or do they make you reconsider continuing
with the current approach in hwif.h?

Thanks,
Andrew

