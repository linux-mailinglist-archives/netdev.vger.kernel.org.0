Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D741F97BD
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgFONCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:02:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:12263 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730388AbgFONCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 09:02:10 -0400
IronPort-SDR: qro7fIGpFxiL1UlnegIWZwkLVqLLSvBNi9qa2CjmoZM9f5lBaowT6gjf3+3+3zbltgwUzIOKvY
 1eVrVlQ84rSw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 06:01:44 -0700
IronPort-SDR: dw+zH0ma5AXOhsmdEM3HOch5+d2CFY9cMeRhRiJkTT9g8l3BqgslEw9Mbm2LBtYeb9ldF1YvI7
 LtALt4nVfkGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="476008651"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jun 2020 06:01:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id BEC5A298; Mon, 15 Jun 2020 16:01:39 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH 3/4] thunderbolt: NHI can use HopIDs 1-7
Date:   Mon, 15 Jun 2020 16:01:38 +0300
Message-Id: <20200615130139.83854-4-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NHI (The host interface adapter) is allowed to use HopIDs 1-7 as well so
relax the restriction in tb_port_alloc_hopid() to support this.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/switch.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index d7d60cd9226f..95b75a712ade 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -789,8 +789,11 @@ static int tb_port_alloc_hopid(struct tb_port *port, bool in, int min_hopid,
 		ida = &port->out_hopids;
 	}
 
-	/* HopIDs 0-7 are reserved */
-	if (min_hopid < TB_PATH_MIN_HOPID)
+	/*
+	 * NHI can use HopIDs 1-max for other adapters HopIDs 0-7 are
+	 * reserved.
+	 */
+	if (port->config.type != TB_TYPE_NHI && min_hopid < TB_PATH_MIN_HOPID)
 		min_hopid = TB_PATH_MIN_HOPID;
 
 	if (max_hopid < 0 || max_hopid > port_max_hopid)
-- 
2.27.0.rc2

