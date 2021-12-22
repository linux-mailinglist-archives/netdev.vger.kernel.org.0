Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0D747D0BA
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244524AbhLVLRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240196AbhLVLRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 06:17:09 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F32CCC061574;
        Wed, 22 Dec 2021 03:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Sb5Qc+GscYGAZKT3zRpL2xaJQHjtFgXyZ36fz2qmxnw=; b=ACe/to6El0tOh9S8I205MWS2Sk
        QVLGBrcI2+PkfLP04iO6Q2ba03rWzH8vKJitQOJVwGzTY/MZYnfYjvN1g3VFossJlX8WGIX2SVFR/
        05gFpu1LOnKldKL7F1qr5b3l1YTAE8WNVjdooNqXePEkbUDM8WcReMVKYJBcXVlzWyrc=;
Received: from p54ae97a7.dip0.t-ipconnect.de ([84.174.151.167] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mzzc3-0002Du-4V; Wed, 22 Dec 2021 12:16:51 +0100
Message-ID: <c156c75f-5797-917c-a8f7-ad7620903bf1@nbd.name>
Date:   Wed, 22 Dec 2021 12:16:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] ath10k: enable threaded napi on ath10k driver
Content-Language: en-US
To:     Abhishek Kumar <kuabhs@chromium.org>, kvalo@codeaurora.org,
        briannorris@chromium.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dianders@chromium.org, pillair@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        netdev@vger.kernel.org
References: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20211214223901.1.I777939e0ef1e89872d4ab65340f3fd756615a047@changeid>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-14 23:39, Abhishek Kumar wrote:
> NAPI poll can be done in threaded context along with soft irq
> context. Threaded context can be scheduled efficiently, thus
> creating less of bottleneck during Rx processing. This patch is
> to enable threaded NAPI on ath10k driver.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.2.2-00696-QCAHLSWMTPL-1
> Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
The name of the dummy device should be filled in as well. How about
something like this:

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3576,6 +3576,9 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
  		  ath10k_core_set_coverage_class_work);
  
  	init_dummy_netdev(&ar->napi_dev);
+	snprintf(ar->napi_dev.name, sizeof(ar->napi_dev.name), "%s",
+		 wiphy_name(ar->hw->wiphy));
+	ar->napi_dev.threaded = 1;
  
  	ret = ath10k_coredump_create(ar);
  	if (ret)
