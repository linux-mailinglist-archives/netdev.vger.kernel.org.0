Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333826055A0
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 04:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJTCsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 22:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJTCsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 22:48:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F63172B47
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 19:48:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 742A9B825C9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEE2C433D6;
        Thu, 20 Oct 2022 02:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666234079;
        bh=ylhd5iTqqGAemMIhI+Dp5Vb3E4mYoi6I/gK3lsXkwAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nJYjM+3El2niJL/4yFxYddIrkEl82skjFKedexHSgelZ7CoCNGAh9LkK6lNM3yDNb
         SMqPH04Xz/LYeKz41kWYZl4gaFwLyR73C0bfu1Xf2zsNa91ApDXsDjT/c5dTvDje37
         zU5FGHFPp2iyb9hiqlAyHkb8gqVUI8x9eT+pQbP4urJpzWoSu21QJjl3JUdZUgCufl
         LYv7YdFoOt/h2IFcZmRSikLuBHC2MGHIhEjvT2ndJbrIB3bcVI4EiHpzgkf+LaKNSV
         PnySeuVYgSeliry/4y/Ipp/i4d8tuPrpIa1jZJ3Pe+eTH9KvWGh3qEAK/RQMeasJie
         MmYi3Lr2eTGmA==
Date:   Wed, 19 Oct 2022 19:47:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP
 packets
Message-ID: <20221019194757.3e21a93e@kernel.org>
In-Reply-To: <SJ1PR11MB61802672AFAA8A4B0A34E81AB82A9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
        <20221018120254.752de264@kernel.org>
        <SJ1PR11MB61802672AFAA8A4B0A34E81AB82A9@SJ1PR11MB6180.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Oct 2022 02:16:25 +0000 Zulkifli, Muhammad Husaini wrote:
> > On Tue, 18 Oct 2022 09:07:28 +0800 Muhammad Husaini Zulkifli wrote:  
> > > v1 -> v2:
> > > 	- Move to the end for the new enum.
> > > 	- Add new HWTSTAMP_FILTER_DMA_TIMESTAMP receive filters.  
> > 
> > Did you address my feedback? How do we know if existing
> > HWTSTAMP_FILTER_ALL is PHC quality of DMA?  
> 
> I apologize if I didn't respond to your feedback. If I recall properly, you agreed to only
>  use the flag rather than creating a new tx type as a result of below conversation. 
> https://lore.kernel.org/all/20220930074016.295cbfab@kernel.org/

My bad, I wasn't very clear. I meant to agree that if you prefer we can
forgo adding a new tx_type, and depend on SOF_TIMESTAMPING_TX_* to
advertise the capabilities and request particular type. But
SOF_TIMESTAMPING_TX_* should still not assume that SOF_TIMESTAMPING_TX_HARDWARE 
is guaranteed to be measured close to the wire.

I was just looking at some mlx5 patches from last night:
https://lore.kernel.org/all/20221019063813.802772-5-saeed@kernel.org/
and if you look around you'll see that they advertise hardware
timestamps but AFAIU only packets they match to be PTP will go on 
the special queue that gets real close-to-wire time:
https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlx5/core/en/selq.c#L247
If application requests a HW stamp on a non-PTP packet (NTP? custom
proto?), or PTP is running on a custom UDP port, or simply the FW/HW
does not support this feature (mlx5 supports at least a decade's worth
of HW generations) - the application will get a DMA stamp.

Same for Rx - close-to-wire stamps may be more expensive for the NIC
and some modern TCP congestion control algos (BBRv2, Swift) need
HW timestamps of all packets but are okay with DMA stamps.

So we need:
 1) clear disambiguation when time stamps are *really* taken
    close-to-the-wire (CTW);
 2) ability to configure Rx to provide CTW stamps for PTP/NTP
    frames and DMA stamps for all the rest for congestion control.

I think extending the documentation in:
  Documentation/networking/timestamping.rst
to explain the API you're adding and how it will allow the above cases
to be satisfied will be a good start.
