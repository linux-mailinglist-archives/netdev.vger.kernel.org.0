Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7FF26FB2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbfEVT57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731110AbfEVTYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:24:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8036920879;
        Wed, 22 May 2019 19:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553044;
        bh=C0r+/pATXVdBaBIXsTrqqwu3xhz3epE8VJyDmAubfoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BW4iCTwmkTtD09osk3pyhDpAaFZZ5MQrGRLagOu8niFL9VjQ2KwIXnLy8WDHsphTP
         6fMTmwC6tnGMGpz74uBEBMXLo9UBooMqy8u+/QHkP305FU+2O2xcvVYe1lqwad2ScR
         NI01B55v7upHCNEZteuKksaYdfwaIqbNMQ6BI1PY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 017/317] net: ena: gcc 8: fix compilation warning
Date:   Wed, 22 May 2019 15:18:38 -0400
Message-Id: <20190522192338.23715-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit f913308879bc6ae437ce64d878c7b05643ddea44 ]

GCC 8 contains a number of new warnings as well as enhancements to existing
checkers. The warning - Wstringop-truncation - warns for calls to bounded
string manipulation functions such as strncat, strncpy, and stpncpy that
may either truncate the copied string or leave the destination unchanged.

In our case the destination string length (32 bytes) is much shorter than
the source string (64 bytes) which causes this warning to show up. In
general the destination has to be at least a byte larger than the length
of the source string with strncpy for this warning not to showup.

This can be easily fixed by using strlcpy instead which already does the
truncation to the string. Documentation for this function can be
found here:

https://elixir.bootlin.com/linux/latest/source/lib/string.c#L141

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index a6eacf2099c30..41c1c9acb3246 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -2292,7 +2292,7 @@ static void ena_config_host_info(struct ena_com_dev *ena_dev,
 	host_info->bdf = (pdev->bus->number << 8) | pdev->devfn;
 	host_info->os_type = ENA_ADMIN_OS_LINUX;
 	host_info->kernel_ver = LINUX_VERSION_CODE;
-	strncpy(host_info->kernel_ver_str, utsname()->version,
+	strlcpy(host_info->kernel_ver_str, utsname()->version,
 		sizeof(host_info->kernel_ver_str) - 1);
 	host_info->os_dist = 0;
 	strncpy(host_info->os_dist_str, utsname()->release,
-- 
2.20.1

