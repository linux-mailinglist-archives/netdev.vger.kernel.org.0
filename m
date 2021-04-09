Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254DA359FCA
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhDIN1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:27:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46670 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhDIN1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:27:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUrAZ-00019X-TV; Fri, 09 Apr 2021 13:27:31 +0000
To:     Siva Reddy <siva.kallam@samsung.com>,
        Byungho An <bh74.an@samsung.com>
From:   Colin Ian King <colin.king@canonical.com>
Subject: net: sxgbe: issue with incorrect masking / case values in switch
 statements
Cc:     Vipul Pandya <vipul.pandya@samsung.com>,
        Girish K S <ks.giri@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <e3f20a0f-058b-9f57-57aa-91455b2f34a5@canonical.com>
Date:   Fri, 9 Apr 2021 14:27:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Static analysis with Coverity has found an issue with the sxgbe driver
in drivers/net/ethernet/samsung/sxgbe/sxgbe_mtl.c from the following commit:

commit 1edb9ca69e8a7988900fc0283e10550b5592164d
Author: Siva Reddy <siva.kallam@samsung.com>
Date:   Tue Mar 25 12:10:54 2014 -0700

    net: sxgbe: add basic framework for Samsung 10Gb ethernet driver


The analysis is as follows:

 20 static void sxgbe_mtl_init(void __iomem *ioaddr, unsigned int etsalg,
 21                           unsigned int raa)
 22 {
 23        u32 reg_val;
 24
 25        reg_val = readl(ioaddr + SXGBE_MTL_OP_MODE_REG);
 26        reg_val &= ETS_RST;
 27
 28        /* ETS Algorith */
 29        switch (etsalg & SXGBE_MTL_OPMODE_ESTMASK) {

Logically dead code (DEADCODE)

 30        case ETS_WRR:
 31                reg_val &= ETS_WRR;
 32                break;

Logically dead code (DEADCODE)

 33        case ETS_WFQ:
 34                reg_val |= ETS_WFQ;
 35                break;

Logically dead code (DEADCODE)

 36        case ETS_DWRR:
 37                reg_val |= ETS_DWRR;
 38                break;
 39        }

Above:
  SXGBE_MTL_OPMODE_ESTMASK is 0x3
  ETS_WRR is 0xFFFFFFFB
  ETS_WFQ is 0x00000020
  ETS_DWRR is 0x00000040

so none of the case statements are ever reachable because of the mask
being used.


 40        writel(reg_val, ioaddr + SXGBE_MTL_OP_MODE_REG);
 41
 42        switch (raa & SXGBE_MTL_OPMODE_RAAMASK) {

Logically dead code (DEADCODE)

 43        case RAA_SP:
 44                reg_val &= RAA_SP;
 45                break;

Logically dead code (DEADCODE)

 46        case RAA_WSP:
 47                reg_val |= RAA_WSP;
 48                break;
 49        }
 50        writel(reg_val, ioaddr + SXGBE_MTL_OP_MODE_REG);
 51}

And above,
  SXGBE_MTL_OPMODE_RAAMASK is 0x1
  RAA_SP is 0xFFFFFFFB
  RAA_WSP is 0x00000004

again, none of the case statements are ever reachable because of the
mask being used.

Not sure of how this was meant to work, so I can't determine a fix,
hence I'm reporting this issue.

Colin
