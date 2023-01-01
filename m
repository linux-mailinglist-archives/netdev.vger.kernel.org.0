Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB6465A9B3
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 12:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjAALN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 06:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjAALN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 06:13:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4631055B6
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 03:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672571607; x=1704107607;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I9LY3jIUW9DdgSlyfQMkkMZK8alrM7zDbPMw8vJtNIs=;
  b=KVUcHor1NpR4XmeZlI9o+GB+XXoqUlGgdNO3NsFexW+OAi+0vIVb27E4
   gdUKQKumc5B4BybZso1WXhnqzjPcBZZAYRVn8YDZUUcItE9sCk7yLyIla
   cj86zsDENiUFE8k9oCEOQ/Dcj4m9CFFKTLYqnUuim1xuA1L+Fog2aUhAS
   NTM2kDODx+huajaCLN3O06D6LmNw1as+s0rWvNsKyq52QKJZEFU8DnNMj
   O+XAvivMHYJaz7iRxByJ6jOkHCdfbs1AQ+ygwoU6iGiV1tjtvrZeKFgDM
   izSuCxzVaZtE4gtfLTu+3f4v+ROyu1wF1vxNXk7uda4Ai2yCafF/WUGXM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="407640611"
X-IronPort-AV: E=Sophos;i="5.96,291,1665471600"; 
   d="scan'208";a="407640611"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2023 03:13:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="654260303"
X-IronPort-AV: E=Sophos;i="5.96,291,1665471600"; 
   d="scan'208";a="654260303"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.11.251]) ([10.13.11.251])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2023 03:13:24 -0800
Message-ID: <dd8605f7-941a-18c9-2a08-8c44be7700a4@linux.intel.com>
Date:   Sun, 1 Jan 2023 13:13:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v1] igc: offload queue max SDU from tc-taprio
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        intel-wired-lan@osuosl.org, vinicius.gomes@intel.com
Cc:     tee.min.tan@linux.intel.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
References: <20221214144514.15931-1-muhammad.husaini.zulkifli@intel.com>
Content-Language: en-US
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20221214144514.15931-1-muhammad.husaini.zulkifli@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/14/2022 16:45, Muhammad Husaini Zulkifli wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> Add support for configuring the max SDU for each Tx queue.
> If not specified, keep the default.
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc.h      |  1 +
>   drivers/net/ethernet/intel/igc/igc_main.c | 45 +++++++++++++++++++++++
>   include/net/pkt_sched.h                   |  1 +
>   net/sched/sch_taprio.c                    |  4 +-
>   4 files changed, 50 insertions(+), 1 deletion(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
