Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64CC557A126
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbiGSOTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239688AbiGSOTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91B1D52897
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658239096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zWTPEQzptxXk3lrvWDrClDt6+96mfbGWSUz4hZOfrrY=;
        b=Y+suca6O4Ub2NUSHOLMaQ6nTHQtSaS9iDOOgyUs7y1X4fOxMdZcR1Vb0IZMrcn9i3rjmR8
        2hp+h98ln3o3nQPt576H+11BYWjDrMXNCcE6tOEdo55P9vF1xxtfKO82UxyQ09ffBxZxQR
        IeqO87HwV3796PbQtDmOvBav7tXuYag=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-D159tKaTNbmJEqnPcWem0g-1; Tue, 19 Jul 2022 09:58:15 -0400
X-MC-Unique: D159tKaTNbmJEqnPcWem0g-1
Received: by mail-wr1-f69.google.com with SMTP id j16-20020adfa550000000b0021d63d200a8so2596439wrb.5
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zWTPEQzptxXk3lrvWDrClDt6+96mfbGWSUz4hZOfrrY=;
        b=y6ROgqX1unL6qk1/JSio1LN7AcDcwa/SqQtdAJga8m6CZFk18j2B0SjakXtQMGxIVr
         iXkptJjJhY2GDlGr47TlpGoaDh4NdwfJ/Y7yO+RDsoqZgQAQpPZKnNr8UzaiXasN4HEJ
         TS+7fLOklEJqEcCQXOT2BTow/QPPwRgQE/EfZR4J6aEgji3JUq0ai5+gE/hjDUwcFbc5
         jubkbnLrAz8sqg0Nrk4r3UZuqTXjl1QOVcLI2ZT7bk055xgs/rblIwQ3ne+78pSCKxgp
         SR8gKDktlIqbzONgIIgrx7LsBDmTi/7z2xLEvK37XLI70zpDxkvdvu6hCrQIs8IsdrY0
         VA8g==
X-Gm-Message-State: AJIora+pMte/u53IIDOVx0jZdxNLCwf8Jh6x+HL728nad05mb2Ddj1qI
        R8ShTG/WELNq1Bb/spgiR89QrJdQetotMu494s5CDyel5F0rXy7wMTzZwJUwD+k8iSuEndAFYYJ
        I70VDT7sjoMwf3ngP
X-Received: by 2002:adf:f28b:0:b0:21e:3161:7129 with SMTP id k11-20020adff28b000000b0021e31617129mr3195233wro.438.1658239093843;
        Tue, 19 Jul 2022 06:58:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tt9EGYGYdDvsVKBkypPQ/oLxWulwLmQlcLonoOdkkZWIXnOaJo77fXBw3t9U4bq27bu53V5w==
X-Received: by 2002:adf:f28b:0:b0:21e:3161:7129 with SMTP id k11-20020adff28b000000b0021e31617129mr3195203wro.438.1658239093547;
        Tue, 19 Jul 2022 06:58:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id f7-20020adffcc7000000b0021e463e4017sm148945wrs.55.2022.07.19.06.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:58:13 -0700 (PDT)
Message-ID: <d432c897a8eef451bdd65cfdf5b1da0d866a9a5b.camel@redhat.com>
Subject: Re: [PATCH v3 net-next 5/5] net: ethernet: mtk_eth_soc: add support
 for page_pool_get_stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com
Date:   Tue, 19 Jul 2022 15:58:11 +0200
In-Reply-To: <YtaE/KJDNOqkvLml@localhost.localdomain>
References: <cover.1657956652.git.lorenzo@kernel.org>
         <8592ada26b28995d038ef67f15c145b6cebf4165.1657956652.git.lorenzo@kernel.org>
         <43ff0071f0ce4b958f27427acebcf2c6ace52ba0.camel@redhat.com>
         <YtaE/KJDNOqkvLml@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-19 at 12:18 +0200, Lorenzo Bianconi wrote:
> > On Sat, 2022-07-16 at 09:34 +0200, Lorenzo Bianconi wrote:
> > > Introduce support for the page_pool stats API into mtk_eth_soc
> > > driver.
> > > Report page_pool stats through ethtool.
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/mediatek/Kconfig       |  1 +
> > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 40
> > > +++++++++++++++++++--
> > >  2 files changed, 38 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mediatek/Kconfig
> > > b/drivers/net/ethernet/mediatek/Kconfig
> > > index d2422c7b31b0..97374fb3ee79 100644
> > > --- a/drivers/net/ethernet/mediatek/Kconfig
> > > +++ b/drivers/net/ethernet/mediatek/Kconfig
> > > @@ -18,6 +18,7 @@ config NET_MEDIATEK_SOC
> > >  	select PHYLINK
> > >  	select DIMLIB
> > >  	select PAGE_POOL
> > > +	select PAGE_POOL_STATS
> > >  	help
> > >  	  This driver supports the gigabit ethernet MACs in the
> > >  	  MediaTek SoC family.
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > index abb8bc281015..eba95a86086d 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > @@ -3517,11 +3517,19 @@ static void mtk_get_strings(struct
> > > net_device *dev, u32 stringset, u8 *data)
> > >  	int i;
> > >  
> > >  	switch (stringset) {
> > > -	case ETH_SS_STATS:
> > > +	case ETH_SS_STATS: {
> > > +		struct mtk_mac *mac = netdev_priv(dev);
> > > +		struct mtk_eth *eth = mac->hw;
> > > +
> > >  		for (i = 0; i < ARRAY_SIZE(mtk_ethtool_stats);
> > > i++) {
> > >  			memcpy(data, mtk_ethtool_stats[i].str,
> > > ETH_GSTRING_LEN);
> > >  			data += ETH_GSTRING_LEN;
> > >  		}
> > > +		if (!eth->hwlro)
> > 
> > I see the page_pool is enabled if and only if !hwlro, but I think
> > it
> > would be more clear if you explicitly check for page_pool here (and
> > in
> > a few other places below), so that if the condition to enable
> > page_pool
> > someday will change, this code will still be fine.
> 
> Hi Paolo,
> 
> page_pool pointer is defined in mtk_rx_ring structure, so
> theoretically we can have a
> page_pool defined for queue 0 but not for queues {1, 2, 3}.

I see. I missed hwlro is a per device setting.

> "!eth->hwlro" means
> there is at least one page_pool allocated. Do you prefer to do
> something like:
> 
> bool mtk_is_pp_enabled(struct mtk_eth *eth)
> {

> 	for (i = 0; i < ARRAY_SIZE(eth->rx_ring); i++) {
> 		struct mtk_rx_ring *ring = &eth->rx_ring[i];
> 
> 		if (ring->page_pool)
> 			return true;
> 	}
> 	return false;
> }

Even:

bool mtk_is_pp_enabled(struct mtk_eth *eth)
{
	return !eth->hwlro;
}

will suffice to encaspulate the logic behind page pool enabling in a
single place.

/P

