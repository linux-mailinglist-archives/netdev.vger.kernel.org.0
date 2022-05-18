Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4193552C23C
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbiERSKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiERSKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:10:46 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81509F43
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 11:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652897444; x=1684433444;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=8YfA4rgQsuU6hIQVlldniJoCFetnxV+mo0jXapiTlNw=;
  b=KYM8jdrha1jaeVb8OPaZr1advGpXqBrwFuRhvDf3hGwiZJFs6+xSELzz
   kndbpfayj63CIa7fu9wCaIsf0KoV5KUB+7KRLRHT9u7TJjxh65G6zBR3L
   7ci8UeE5HM490pe5FYrovLgCPUlMQX8M2Kr9B573YM8tEi7H9/Hho8Hz/
   ZxfziqgvKjB7pPM7QcKqGf2sPdeFArBZk+jbzZ965rK4zDDQxC0Syxo2G
   DoQVKYB37Z0+8FIsV+DDqK4LMhY1ZwU9QZrOaLha7FaIsvRkaA5c5Kz5n
   Hd8obIsCihHDm6hIz3MkRpV3wWW5p23CidzOqaoPzSzmtFC5Fz8w1y6Ur
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="271515325"
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="271515325"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 11:09:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,235,1647327600"; 
   d="scan'208";a="597952373"
Received: from rottmaie-mobl1.ger.corp.intel.com ([10.252.53.238])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 11:09:45 -0700
Date:   Wed, 18 May 2022 21:09:37 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
cc:     chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
In-Reply-To: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
Message-ID: <d04ffa5b-13f6-5f4d-98e4-1a4550d6f69@linux.intel.com>
References: <20220517064821.3966990-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022, Ziyang Xuan wrote:

> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
> 
> Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
> remove the spin_lock from t7xx_cldma_clear_rxq().
> 

Perhaps Suggested-by: ... would have been appropriate too.

> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

-- 
 i.
