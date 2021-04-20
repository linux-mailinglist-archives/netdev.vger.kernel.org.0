Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86681365919
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbhDTMk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:40:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40884 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhDTMk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:40:26 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lYpfV-0000pB-NU; Tue, 20 Apr 2021 12:39:53 +0000
To:     "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: phy: nxp-c45: add driver for tja1103
Message-ID: <1ed4dfc4-3561-47d1-ad1f-507f67ed03f0@canonical.com>
Date:   Tue, 20 Apr 2021 13:39:53 +0100
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

Static analysis with Coverity on linux-next has found a potential issue
in drivers/net/phy/nxp-c45-tja11xx.c, function nxp_c45_get_phase_shift.
The analysis by Coverity is as follows:

350 static u64 nxp_c45_get_phase_shift(u64 phase_offset_raw)
351 {
352        /* The delay in degree phase is 73.8 + phase_offset_raw * 0.9.
353         * To avoid floating point operations we'll multiply by 10
354         * and get 1 decimal point precision.
355         */
356        phase_offset_raw *= 10;

Operands don't affect result (CONSTANT_EXPRESSION_RESULT)
result_independent_of_operands: phase_offset_raw is always assigned 0.

Did you intend to negate the value of phase_offset_raw instead of
assigning it 0? This occurs as the value assigned by "-".

357        phase_offset_raw -= phase_offset_raw;
358        return div_u64(phase_offset_raw, 9);
359 }

phase_offset_raw -= phase_offset_raw results in phase_offset_raw being
zero, I don't think that was the intent.

Colin
