Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE535B6BE2
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbiIMKqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiIMKqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:46:08 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B135F129
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663065964; x=1694601964;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=cdOc/cHMFef7/HXHYe1CQ1aR0H+pJ64uy/MxfJ4qj/k=;
  b=bPJVaAzMpLPpANnAFlJOS+OJygLY51Of0ASHmwhmp7peqfjHE+MmMseX
   doR70mjLfTMQCevm9+CV9rPhXHrFCfkIL/UC+WUFpaAVvIp3YBg/1m9ud
   vBZKQnNI9TNtwPf+kqO3ibrYlCNY7vhzT2vauoBwYGN4eAuB8G5oloh6K
   exChJ09BLnvoBp1UOeoy551JjcJ5sbFpSzRVmb99u5V0ykzWLGGuYJa6A
   nsJ2K2Tvy41vaDaL2wWWwC5JTZ112XJtZyCJX9mQIrazuolTNiGXYJ5ah
   +3PcZvGLrruc+IaNJts0ldJyKNy0OcfyzMUEAEojFrYFIPxaMJP/j9DJR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="324349119"
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="324349119"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 03:46:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="678512542"
Received: from calabres-mobl.ger.corp.intel.com ([10.252.47.42])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 03:46:00 -0700
Date:   Tue, 13 Sep 2022 13:45:58 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next 2/2] net: wwan: t7xx: Add NAPI support
In-Reply-To: <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
Message-ID: <5820620-6450-e3f5-4ac0-e235cbf5c838@linux.intel.com>
References: <20220909163500.5389-1-sreehari.kancharla@linux.intel.com> <20220909163500.5389-2-sreehari.kancharla@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Sep 2022, Sreehari Kancharla wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Replace the work queue based RX flow with a NAPI implementation
> Remove rx_thread and dpmaif_rxq_work.
> Introduce dummy network device. its responsibility is
>     - Binds one NAPI object for each DL HW queue and acts as
>       the agent of all those network devices.
>     - Use NAPI object to poll DL packets.
>     - Helps to dispatch each packet to the network interface.

It would be useful to mention that GRO is also enabled.

>  static int t7xx_ccmni_open(struct net_device *dev)
>  {
>  	struct t7xx_ccmni *ccmni = wwan_netdev_drvpriv(dev);
> +	struct t7xx_ccmni_ctrl *ccmni_ctl = ccmni->ctlb;
>  
>  	netif_carrier_on(dev);
>  	netif_tx_start_all_queues(dev);
> +	if (!atomic_read(&ccmni_ctl->napi_usr_refcnt)) {
> +		t7xx_ccmni_enable_napi(ccmni_ctl);
> +		atomic_set(&ccmni_ctl->napi_usr_refcnt, 1);
> +	} else {
> +		atomic_inc(&ccmni_ctl->napi_usr_refcnt);
> +	}

atomic_fetch_inc() ?

-- 
 i.

