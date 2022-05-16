Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013335292B3
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 23:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349260AbiEPVMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 17:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349188AbiEPVKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 17:10:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278CDB31;
        Mon, 16 May 2022 13:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652734624; x=1684270624;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=j7s6smruyWmhbNoHc6iTvZ7jsq4VNCTsuvEe6mBVoFQ=;
  b=Bae+jCyzA1wsQJNXFDvCsPvvj44aemW05k3/N1OpgweOiVD1Dm+N9tcv
   5z5gPlHfP8k22ZZavPXu2CcG1yqqI9xVNBkPFtHXtMtA2TqaH577DNMrc
   OYBJzWh8+QgS60Bno683qLNAzhEUEOQqDcMxrEcsROtFqIASS/8zjGdEq
   IlLH9ERf2aJvckzZ27i5876To611erEK1mjwWFFJVopvbia1iNUp7XSzZ
   E46+fDdb8tnEA0WOyF5EBNVfe/Xy5664V3+XEiaLl/NmyqUt7symrkt8P
   tVKxef0AnJd59Fiq902OkbuCpH9GIVJJB4M/D0cgmTHSaCiqRgaiT/mgf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="334004251"
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="334004251"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 13:57:01 -0700
X-IronPort-AV: E=Sophos;i="5.91,230,1647327600"; 
   d="scan'208";a="596717394"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.84.135]) ([10.209.84.135])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 13:57:00 -0700
Message-ID: <0b90f4f6-6911-017b-6d37-50354003900e@linux.intel.com>
Date:   Mon, 16 May 2022 13:57:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
References: <20220514091443.4150162-1-william.xuanziyang@huawei.com>
 <CAHNKnsS0D8bRA5GY0xss2ZUCwY2HoLNMgeR0K4ecH-HfmdTefg@mail.gmail.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <CAHNKnsS0D8bRA5GY0xss2ZUCwY2HoLNMgeR0K4ecH-HfmdTefg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/16/2022 1:36 PM, Sergey Ryazanov wrote:
> Hello Ziyang,
>
> On Sat, May 14, 2022 at 11:57 AM Ziyang Xuan
> <william.xuanziyang@huawei.com> wrote:
>> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
>> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
>> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>>
>> Replace GFP_KERNEL with GFP_ATOMIC to fix it.
> Would not it will be more reliable to just rework
> t7xx_cldma_clear_rxq() to avoid calling t7xx_cldma_alloc_and_map_skb()
> under the spin lock instead of doing each allocation with GFP_ATOMIC?
> E.g. t7xx_cldma_gpd_rx_from_q() calls t7xx_cldma_alloc_and_map_skb()
> avoiding any lock holding.

t7xx_cldma_clear_rxq() is a helper for t7xx_cldma_clear_all_qs() which 
is only called by t7xx_cldma_exception() after stopping CLDMA, so it 
should be OK to remove the spin lock from t7xx_cldma_clear_rxq().

