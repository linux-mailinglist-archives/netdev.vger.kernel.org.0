Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F8B3AECCA
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFUPxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:53:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51645 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFUPxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:53:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lvMCv-0003rJ-FK; Mon, 21 Jun 2021 15:51:29 +0000
From:   Colin Ian King <colin.king@canonical.com>
To:     Qing Zhang <zhangqing@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: stmmac: pci: Add dwmac support for Loongson
Message-ID: <37057fe8-f7d1-7ee0-01c7-916577526b5b@canonical.com>
Date:   Mon, 21 Jun 2021 16:51:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis by Coverity on today's linux-next has found an issue in
function loongson_dwmac_probe with the following commit:

commit 30bba69d7db40e732d6c0aa6d4890c60d717e314
Author: Qing Zhang <zhangqing@loongson.cn>
Date:   Fri Jun 18 10:53:34 2021 +0800

    stmmac: pci: Add dwmac support for Loongson

The analysis is as follows:

110        plat->phy_interface = device_get_phy_mode(&pdev->dev);

Enum compared against 0
(NO_EFFECT)
unsigned_compare: This less-than-zero comparison of an
unsigned value is never true. plat->phy_interface < 0U.

111        if (plat->phy_interface < 0)
112                dev_err(&pdev->dev, "phy_mode not found\n");

Enum plat->phy_interface is unsigned, so can't be negative and so the
comparison will always be false.

A possible fix is to use int variable ret for the assignment and check:


        ret = device_get_phy_mode(&pdev->dev);
        if (ret < 0)
                dev_err(&pdev->dev, "phy_mode not found\n");
        plat->phy_interface = ret;

..however, I think the dev_err may need handling too, e.g.

        ret = device_get_phy_mode(&pdev->dev);
        if (ret < 0) {
                dev_err(&pdev->dev, "phy_mode not found\n");
		ret = -ENODEV;
		goto cleanup;		/* needs to be written */
	}
        plat->phy_interface = ret;

Colin
