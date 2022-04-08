Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B407C4F8E7E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 08:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiDHDcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 23:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiDHDcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 23:32:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED2D32765B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 20:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D087B61DB0
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 03:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F77C385A0;
        Fri,  8 Apr 2022 03:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649388604;
        bh=CIKp4EBhVeVP5VDWB1RAD8ZdzptsOPckPZjUlBLHpfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XwAdDjby8DSKA59zpJ9nlXCtzzVZz4lATuvaKgyuDd152/Wyvk1je0HdWk7POI2Kw
         6h50go8jW6/Uop9ljlw5ZQZLgQqYoyGLISsRJ2/+HfSZYtKRPFf/mmWNd2TH0V/9qS
         URuOWMQUE264A//SfbMDj41GBAOYT1KFBYaOZgNhyv6F1lxwU5cvlm0izUHKdnaQZN
         vO9rSxavp3fUkuiWjzlsNez5+BE4U6V/8jiyiG4EFxTddZObGuFDreUKeCp0DkPPFg
         FmA7VHD+hTAVXZq/wmyfWxor6ZJZoiLC5GYIPmfGwS987XgBx/QmbLHL6VF3736nKl
         blFEdF3/Bvgeg==
Date:   Thu, 7 Apr 2022 20:30:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, pabeni@redhat.com,
        thomas.petazzoni@bootlin.com, ilias.apalodimas@linaro.org,
        jbrouer@redhat.com, andrew@lunn.ch, jdamato@fastly.com
Subject: Re: [RFC net-next 1/2] net: page_pool: introduce ethtool stats
Message-ID: <20220407203002.6d514e43@kernel.org>
In-Reply-To: <ab9f8ae8a29f2c3acdb33fe7ade0691ff4a9494a.1649350165.git.lorenzo@kernel.org>
References: <cover.1649350165.git.lorenzo@kernel.org>
        <ab9f8ae8a29f2c3acdb33fe7ade0691ff4a9494a.1649350165.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Apr 2022 18:55:04 +0200 Lorenzo Bianconi wrote:
> +void page_pool_ethtool_stats_get_strings(u8 *data)

This needs to return the pointer to after the used area, so drivers can
append more stats. Or make data double pointer and update it before
returning.

> +{
> +	static const struct {
> +		u8 type;
> +		char name[ETH_GSTRING_LEN];
> +	} stats[PP_ETHTOOL_STATS_MAX] = {
> +		{
> +			.type = PP_ETHTOOL_ALLOC_FAST,

Why enumerate the type? It's not used.

> +			.name = "rx_pp_alloc_fast"
> +		}, {
> +			.type = PP_ETHTOOL_ALLOC_SLOW,
> +			.name = "rx_pp_alloc_slow"
> +		}, {
> +			.type = PP_ETHTOOL_ALLOC_SLOW_HIGH_ORDER,
> +			.name = "rx_pp_alloc_slow_ho"
> +		}, {
> +			.type = PP_ETHTOOL_ALLOC_EMPTY,
> +			.name = "rx_pp_alloc_empty"
> +		}, {
> +			.type = PP_ETHTOOL_ALLOC_REFILL,
> +			.name = "rx_pp_alloc_refill"
> +		}, {
> +			.type = PP_ETHTOOL_ALLOC_WAIVE,
> +			.name = "rx_pp_alloc_waive"
> +		}, {
> +			.type = PP_ETHTOOL_RECYCLE_CACHED,
> +			.name = "rx_pp_recycle_cached"
> +		}, {
> +			.type = PP_ETHTOOL_RECYCLE_CACHE_FULL,
> +			.name = "rx_pp_recycle_cache_full"
> +		}, {
> +			.type = PP_ETHTOOL_RECYCLE_RING,
> +			.name = "rx_pp_recycle_ring"
> +		}, {
> +			.type = PP_ETHTOOL_RECYCLE_RING_FULL,
> +			.name = "rx_pp_recycle_ring_full"
> +		}, {
> +			.type = PP_ETHTOOL_RECYCLE_RELEASED_REF,
> +			.name = "rx_pp_recycle_released_ref"
> +		},
> +	};
> +	int i;
> +
> +	for (i = 0; i < PP_ETHTOOL_STATS_MAX; i++) {
> +		memcpy(data, stats[i].name, ETH_GSTRING_LEN);
> +		data += ETH_GSTRING_LEN;
> +	}
