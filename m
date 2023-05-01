Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8016F3008
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 12:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjEAKBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 06:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbjEAKBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 06:01:18 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C97D3
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 03:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682935277; x=1714471277;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f7pPqvwxZuP+KTS5cSZIBXrAGCw66p2IelsoFemY/0A=;
  b=UpzN47ebuFVHVdM0j8QywZ7P8zxS9k3sfTiEkIBmVxruRkEwgfIR3nOf
   Re5vvjBkf/PwAm3IbmiVg462pwRsbU9NokCdeNaLQ/vsDU2EqlmLMbthq
   JI2WS31a3n6WF7xJOyIM2NzzzT+Cm1g+sk9Fj7tyInFMeDtuZIc6TkMvS
   VfJcbujXOmvE2Eb/aI0ErcofwjGG5Gs4G/fUrzEsLbjUZIKj2sSRVsyfU
   Mz2RxUCwzswO3Zk9rEy2/eu2xzual1xGvQ2+5thsUQ7yTiY3rkj5eTfh2
   06Fa4xlbyeSFYNiO2dp3C2kegYDuXopVLoAVdqfA9tNfvy01Ay3c7B5OJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="332462225"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="332462225"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2023 03:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10696"; a="760629037"
X-IronPort-AV: E=Sophos;i="5.99,239,1677571200"; 
   d="scan'208";a="760629037"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.36]) ([10.13.12.36])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2023 03:01:14 -0700
Message-ID: <1d2fbe2c-3e33-fb60-a384-1cb550ae5229@linux.intel.com>
Date:   Mon, 1 May 2023 13:01:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Intel-wired-lan] [PATCH net-next] igc: Avoid transmit queue
 timeout for XDP
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        intel-wired-lan@lists.osuosl.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20230412073611.62942-1-kurt@linutronix.de>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230412073611.62942-1-kurt@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/12/2023 10:36, Kurt Kanzenbach wrote:
> High XDP load triggers the netdev watchdog:
> 
> |NETDEV WATCHDOG: enp3s0 (igc): transmit queue 2 timed out
> 
> The reason is the Tx queue transmission start (txq->trans_start) is not updated
> in XDP code path. Therefore, add it for all XDP transmission functions.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>   drivers/net/ethernet/intel/igc/igc_main.c | 8 ++++++++
>   1 file changed, 8 insertions(+)

Tested-by: Naama Meir <naamax.meir@linux.intel.com>
