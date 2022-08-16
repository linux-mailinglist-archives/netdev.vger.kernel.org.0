Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3FA5955CA
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbiHPJEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiHPJDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:03:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BDF6AA08
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 00:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660634087; x=1692170087;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cJaW55uoJxwe0yE6jeTZRRbnIXNeIk4evQxubrO4EYo=;
  b=NVgExqRoW35RIdrpp2NH4dlxrSQdCztfJAVPlutwkHXNP3jmAntoPHMe
   NW03mE15Gv1MfScA5H2b0l5SHu/fI/BzPSU2exeKmX4FDkRiWcFjWoj3B
   3XBichNSdk4eCBaR4Sv83yO2hWyySJvSHwZRDf3jAx3ft2M13rJxw4l48
   xHOnaR6v7VAk882EwXQP1IlFhB1l2ijnQZq5x/nGwAD1/zo1rM/2d2aws
   poCmPtloHwggrSWOOJ5Z5RPM5/V4+qYAAhBwHNZN4vTNK3Te3f2uh9UA2
   rYALypnIqeRUM57nBCGNfSr00lm4k7ol5/YZAdmh930UIL7FGvnQIWsX1
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="353889599"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="353889599"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 00:14:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="675110283"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.13.121]) ([10.13.13.121])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 00:14:44 -0700
Message-ID: <93210e6c-a583-aff1-753b-88286ab09434@linux.intel.com>
Date:   Tue, 16 Aug 2022 10:14:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [Intel-wired-lan] [PATCH net-next] igc: add xdp frags support to
 ndo_xdp_xmit
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, jesse.brandeburg@intel.com,
        jbrouer@redhat.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, davem@davemloft.net, magnus.karlsson@intel.com
References: <d8e3744f060ee11d5069bfd0f581f02d0ecb5e08.1657093744.git.lorenzo@kernel.org>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <d8e3744f060ee11d5069bfd0f581f02d0ecb5e08.1657093744.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/2022 10:54, Lorenzo Bianconi wrote:
> Add the capability to map non-linear xdp frames in XDP_TX and
> ndo_xdp_xmit callback.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Please note this patch is only compiled tested since I do not have
> access to a igc NIC
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 128 ++++++++++++++--------
>   1 file changed, 83 insertions(+), 45 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
