Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706253C2581
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhGIOGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 10:06:18 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:37730
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229499AbhGIOGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 10:06:17 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9F63C401BE;
        Fri,  9 Jul 2021 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1625839412;
        bh=ArzmOf/twC31usgyIHswXRtlXpE+DnHhLO+/s9grB20=;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type;
        b=HSeoB3pKLFNLm2ZlDuZDlFKnmPTST6OaUdDf0uWdwdaWTIe6didlgnnzagiEzeS6l
         3/81HaWIsK5kdygO4gVtpafUpASSSNC05c/vNdww3hP/Oe4GYrdBWw4cVFquUkd3r8
         mbuskyedQfceBvQ++NC/jFq9/gmaQSuKOnCKZd25M6bVCcSfvitiwCYLYOGjtxf9iH
         VwMWHxNlpTsDFsvZQhs4obXz70eH2IyfnmH+CfA1QOoM3FGVHcHGU4EgkWfkeULu9C
         2ZFjhf6unyhrW1m8Fyx6RA1j4YGsvYyquDsUA68uk+ims3gAYGUYHvND4uu3Gz4XnZ
         afw9UkKLI34LQ==
To:     Byungho An <bh74.an@samsung.com>,
        Siva Reddy <siva.kallam@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: issue with unreachable code in net sxgbe driver
Message-ID: <bac2783b-c7af-4e2e-5b3b-318196abfc20@canonical.com>
Date:   Fri, 9 Jul 2021 15:03:32 +0100
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

Static analysis with Coverity has detected several occurrences of dead
code in the sxgbe driver in function sxgbe_mtl_init. The issue was
introduced with the following commit:

commit 1edb9ca69e8a7988900fc0283e10550b5592164d
Author: Siva Reddy <siva.kallam@samsung.com>
Date:   Tue Mar 25 12:10:54 2014 -0700

    net: sxgbe: add basic framework for Samsung 10Gb ethernet driver

The analysis is as follows:

 20static void sxgbe_mtl_init(void __iomem *ioaddr, unsigned int etsalg,
 21                           unsigned int raa)
 22{
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

SXGBE_MTL_OPMODE_ESTMASK is defined as 0x03
ETS_WRR is 0xFFFFFF9F
ETS_WFQ is 0x00000020
ETS_DWRR is 0x00000040

so the masking of etsalg & SXGBE_MTL_OPMODE_ESTMASK will never match any
of the ETS_* values, hence the dead code.


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

SXGBE_MTL_OPMODE_RAAMASK is defined as 0x1
RAA_SP is 0xFFFFFFFB
RAA_WSP is 0x00000004

so masking of raa & SXGBE_MTL_OPMODE_RAAMASK will never match any of the
RAA_* values, hence the dead code.

I don't think this is intentional. Not sure how to fix this hence I'm
reporting this issue.

Regards,

Colin
