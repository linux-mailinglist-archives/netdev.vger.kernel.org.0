Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EB965A9B7
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 12:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjAALQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 06:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjAALQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 06:16:29 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B3526ED
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 03:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672571788; x=1704107788;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=V/Drwe46nNm8ImYDn+F+kyPBWTptKXLn2Dws9TEbR+8=;
  b=NF8SzHuhL8Jibqtufgk+Zlp1cinHF3ti4RvLQtSAXxgNA4qkjgtkkfZn
   LDAjdpYR/gk86xvSpPEnIhHuLmy/ccR83SPbTNJEXyB5mxGuA1hb/aw9N
   X/acPPJjcHCgL7O23/5OmFs3Nc02hYVsQAEAfPS/oVSkUVMeSt/nHmCRw
   WGHnqcCkRn91u4nh9ZO7NOFeiE1lBQghwZzjN9L0CwCgnoFiYgeYnZPRu
   XK999Fyg5au6i7ImFPq/lePGxXYl6aJqrd23tad/VcBNCJNkuKK2xpC1X
   a7IEL7pACaIR3GZqoBbA0Juw7m01+g/zGoKBP1QxzoLo+QYSPbRuyftvj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="407640744"
X-IronPort-AV: E=Sophos;i="5.96,291,1665471600"; 
   d="scan'208";a="407640744"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2023 03:16:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="654260466"
X-IronPort-AV: E=Sophos;i="5.96,291,1665471600"; 
   d="scan'208";a="654260466"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.11.251]) ([10.13.11.251])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jan 2023 03:16:25 -0800
Message-ID: <71b8226c-06c6-efac-50f6-6b4f43a61bc9@linux.intel.com>
Date:   Sun, 1 Jan 2023 13:16:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] igc: offload queue max SDU from tc-taprio
Content-Language: en-US
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        intel-wired-lan@osuosl.org, vinicius.gomes@intel.com
Cc:     tee.min.tan@linux.intel.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com
References: <20221216150357.12721-1-muhammad.husaini.zulkifli@intel.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20221216150357.12721-1-muhammad.husaini.zulkifli@intel.com>
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

On 12/16/2022 17:03, Muhammad Husaini Zulkifli wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> Add support for configuring the max SDU for each Tx queue.
> If not specified, keep the default.
> 
> All link speeds have been tested with this implementation.
> No performance issue observed.
> 
> How to test:
> 
> 1) Configure the tc with max-sdu
> 
> tc qdisc replace dev $IFACE parent root handle 100 taprio \
>      num_tc 4 \
>      map 0 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 \
>      queues 1@0 1@1 1@2 1@3 \
>      base-time $BASE \
>      sched-entry S 0xF 1000000 \
>      max-sdu 1500 1498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
>      flags 0x2 \
>      txtime-delay 0
> 
> 2) Use network statistic to watch the tx queue packet to see if
> packet able to go out or drop.
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> ---
> V1 -> V2: Rework based on Vinicius's comment.
> ---
> ---
>   drivers/net/ethernet/intel/igc/igc.h      |  1 +
>   drivers/net/ethernet/intel/igc/igc_main.c | 44 +++++++++++++++++++++++
>   2 files changed, 45 insertions(+)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
