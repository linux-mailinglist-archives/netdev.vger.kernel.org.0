Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F2965CDA2
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjADHcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbjADHbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:31:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB0413CFD
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:31:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8129B811A5
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B340DC433EF;
        Wed,  4 Jan 2023 07:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672817507;
        bh=a6X9ESSpQaq8NgwxLWmPq/IUiYpZ1po5jbdjZCF0k0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sWkF1s9XO2QEHwAtfhL1dKBmXqn1zHc6iSR97ChlyclLhQA7DncDjdTuBwKqLDmKm
         erWH+GA7B27QgDfamjsHlJvh15iq1x2Ua2Vz2xR8p+0o+g0luNlmImfaCzoZmYZuTH
         trWDBgbcSLyvPcpelv4vK3QDZyN2la0wn7WxGRMdaZziSyaCpTeiF+gsUu/3/3jgio
         vRceqjNfXsWbAwfuB0Lr6SH2i7EkHqIwBHuadQ5pZLQKg43SAP0SU8MMC0lurshmin
         fAQXxRePrUcazM0jnER7QfuUoe+nKlXsDdG9imzZOI8LGHfZvQx1k6Uu9ApfDGbprF
         AwgiaEOsoZoEw==
Date:   Wed, 4 Jan 2023 09:31:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 3/3] igc: Remove reset adapter task for i226
 during disable tsn config
Message-ID: <Y7UrX1On4z1DtbTB@unreal>
References: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
 <20230103230503.1102426-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103230503.1102426-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:05:03PM -0800, Tony Nguyen wrote:
> From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> I225 have limitation when programming the BaseTime register which required
> a power cycle of the controller. This limitation already lifted in I226.
> This patch removes the restriction so that when user configure/remove any
> TSN mode, it would not go into power cycle reset adapter.
> 
> How to test:
> 
> Schedule any gate control list configuration or delete it.
> 
> Example:
> 
> 1)
> 
> BASE_TIME=$(date +%s%N)
> tc qdisc replace dev $interface_name parent root handle 100 taprio \
>     num_tc 4 \
>     map 3 1 0 2 3 3 3 3 3 3 3 3 3 3 3 3 \
>     queues 1@0 1@1 1@2 1@3 \
>     base-time $BASE_TIME \
>     sched-entry S 0F 1000000 \
>     flags 0x2
> 
> 2) tc qdisc del dev $intername_name root
> 
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c |  6 +++---
>  drivers/net/ethernet/intel/igc/igc_tsn.c  | 11 +++--------
>  drivers/net/ethernet/intel/igc/igc_tsn.h  |  2 +-
>  3 files changed, 7 insertions(+), 12 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
