Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9A1525209
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356248AbiELQFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356256AbiELQFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:05:17 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326CC263DBC;
        Thu, 12 May 2022 09:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1652371516; x=1683907516;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SbkIAr8kDAHWGtaAPt3QNiXsXJ4IT42PUqH47lTn8JY=;
  b=y0CUDKYSWqdE6VY0YfgbgFJvyYqZK08HyqkArf0UF0xoJlrXHovIWusB
   VT4aeFOcQefRsFED0pETmnAWJA7r3zzeNcxeY9fbn33Abf5XMpab5LO7x
   5bUirAnGNES++SZTLP6VtUH5/ODwx7OHOhbFktixzb9/ZBbunER9GjpM2
   A=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 12 May 2022 09:05:16 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2022 09:05:15 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 12 May 2022 09:05:15 -0700
Received: from [10.110.47.233] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 12 May
 2022 09:05:14 -0700
Message-ID: <fa713d4a-a3ef-2837-d220-857ed1e5538c@quicinc.com>
Date:   Thu, 12 May 2022 09:05:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v3 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>,
        <ath9k-devel@qca.qualcomm.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <toke@toke.dk>,
        <linville@tuxdriver.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <syzbot+03110230a11411024147@syzkaller.appspotmail.com>,
        <syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/2022 12:24 PM, Pavel Skripkin wrote:
[...snip...]
>   
>   #ifdef CONFIG_ATH9K_HTC_DEBUGFS
> -
> -#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> -#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> -#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> -#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
> +#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
> +#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> +#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> +#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> +#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)

it is unfortunate that the existing macros don't abide by the coding style:
	Things to avoid when using macros:
	macros that depend on having a local variable with a magic name

the companion macros in ath9k/debug.h do the right thing

perhaps this could be given to Kernel Janitors for subsequent cleanup?
