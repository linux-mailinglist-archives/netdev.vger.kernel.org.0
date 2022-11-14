Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91DB628375
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbiKNPDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiKNPDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:03:44 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C398D1C5;
        Mon, 14 Nov 2022 07:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668438223; x=1699974223;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4H5eSaMts1gBtG6QlF6k0Gn3KiUD0FXVxmalZTJiFSY=;
  b=G2jssB5ypTanuaiy6XMIFeZz9xAcxJi9evR8V32qO7mMWxYSzGYsyeF5
   oYIE5VMcCLKAvAlJiujk9tmHfmqpFLkfe52usO80d/u82P78WDwL2ozeJ
   9ffO1E59QaP7mUsEckAo/CZu5dYlsF35pvLskCbYV+ZXN9kcWkB24S/ZF
   nmQLCEGnORY41dORYPS2pjUEWwkQiG/HvVFLpAmbtXf8vObQ973V/+tMf
   +JnKH2bcTxTg+n7yqFWTR3tkTxOQuNNw1UBWNunInuFqDqZpHow4ORm2R
   gvL++kZIGLb4M7jHjJeXmSCZik+/HEOL5dszcMirK+H+pLcFNNzO1FG/1
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="292385337"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="292385337"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 06:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="727550238"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="727550238"
Received: from mylly.fi.intel.com (HELO [10.237.72.171]) ([10.237.72.171])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Nov 2022 06:57:11 -0800
Message-ID: <b1a9bd9f-5c12-3df8-6207-7acf1570d253@linux.intel.com>
Date:   Mon, 14 Nov 2022 16:57:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.4.1
Subject: Re: [PATCH 3/3] can: m_can: pci: add missing m_can_class_free_dev()
 in probe/remove methods
Content-Language: en-US
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raymond Tan <raymond.tan@intel.com>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1668168684-6390-1-git-send-email-zhangchangzhong@huawei.com>
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <1668168684-6390-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 14:11, Zhang Changzhong wrote:
> In m_can_pci_remove() and error handling path of m_can_pci_probe(),
> m_can_class_free_dev() should be called to free resource allocated by
> m_can_class_allocate_dev(), otherwise there will be memleak.
> 
> Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>   drivers/net/can/m_can/m_can_pci.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
Reviewed-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
