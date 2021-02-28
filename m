Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC16932746C
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 21:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhB1UdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 15:33:20 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:54428 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhB1UdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 15:33:16 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Feb 2021 15:33:15 EST
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 0A4CC20C677B
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: [PATCH net 1/3] sh_eth: fix TRSCER mask for SH771x
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
References: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <a92afef3-2ae8-e8c7-855d-f0e86a1beede@omprussia.ru>
Date:   Sun, 28 Feb 2021 23:25:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <7009ba70-4134-1acf-42b9-fa7e59b5d15d@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According  to  the SH7710, SH7712, SH7713 Group User's Manual: Hardware,
Rev. 3.00, the TRSCER register actually has only bit 7 valid (and named
differently), with all the other bits reserved. Apparently, this was not
the case with some early revisions of the manual as we have the other
bits declared (and set) in the original driver.  Follow the suit and add
the explicit sh_eth_cpu_data::trscer_err_mask initializer for SH771x...

Fixes: 86a74ff21a7a ("net: sh_eth: add support for Renesas SuperH Ethernet")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
 drivers/net/ethernet/renesas/sh_eth.c |    3 +++
 1 file changed, 3 insertions(+)

Index: net/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net/drivers/net/ethernet/renesas/sh_eth.c
@@ -1089,6 +1089,9 @@ static struct sh_eth_cpu_data sh771x_dat
 			  EESIPR_CEEFIP | EESIPR_CELFIP |
 			  EESIPR_RRFIP | EESIPR_RTLFIP | EESIPR_RTSFIP |
 			  EESIPR_PREIP | EESIPR_CERFIP,
+
+	.trscer_err_mask = DESC_I_RINT8,
+
 	.tsu		= 1,
 	.dual_port	= 1,
 };
