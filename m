Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269216A0288
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 06:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjBWFrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 00:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjBWFry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 00:47:54 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF28B26B3
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 21:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677131269; x=1708667269;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rLPwR9WXt2IVWdEZpVT1ZBpKuqvFL61GJDE2FeBc/f0=;
  b=mselwhH+AetWKs8Hizh3egjg1lP3jpS09y+30urRj4a5hFWPvoXRenXF
   A7Yi/jG7+mnSv3QKF7zN/wNqzQh3vLUUroDDJkbuEwuXzI/kYe9OEdufs
   nOvWQuJ7m0skUBzV9QuXghs1MtLorYoSlXUUPY23N7Lj/FoeiC/zUwp+7
   N1k8aQvzY5s2D1CrkXtC6tpD1HPZP9eWqOc0LcqCLXOzypmWQQqo34Ryo
   NX6klWVTufznFMLaodRvmQOtEzWxk3gfu7nh5+gl7efmDABMa3T3ftsMQ
   Up4G//V7d4HtTsl+7u9Nl7d92boQ50SaLx3r4vCp2FLoq2HfSGPQc/jMd
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="395603070"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="395603070"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 21:47:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="741136680"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="741136680"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.114]) ([10.13.12.114])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 21:47:45 -0800
Message-ID: <a87701b4-4b77-3b03-38f0-3c73f5573b8f@linux.intel.com>
Date:   Thu, 23 Feb 2023 07:47:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v5] igc: offload queue max SDU from tc-taprio
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        intel-wired-lan@osuosl.org
Cc:     vinicius.gomes@intel.com, kuba@kernel.org,
        anthony.l.nguyen@intel.com, leon@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        tee.min.tan@linux.intel.com, netdev@vger.kernel.org,
        sasha.neftin@intel.com
References: <20230216011624.14022-1-muhammad.husaini.zulkifli@intel.com>
Content-Language: en-US
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230216011624.14022-1-muhammad.husaini.zulkifli@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/2023 03:16, Muhammad Husaini Zulkifli wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> Add support for configuring the max SDU for each Tx queue.
> If not specified, keep the default.
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> ---
> V4 -> V5: Rework based on Jakub's comment.
> V3 -> V4: Rebase to the latest tree as per requested by Anthony.
> V2 -> V3: Rework based on Leon Romanovsky's comment.
> V1 -> V2: Rework based on Vinicius's comment.
> ---
> ---
>   drivers/net/ethernet/intel/igc/igc.h      |  1 +
>   drivers/net/ethernet/intel/igc/igc_hw.h   |  1 +
>   drivers/net/ethernet/intel/igc/igc_main.c | 33 ++++++++++++++++++++---
>   3 files changed, 31 insertions(+), 4 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
