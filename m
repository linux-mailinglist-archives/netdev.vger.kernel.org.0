Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB52AD253
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731787AbgKJJUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:52778 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729909AbgKJJUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:04 -0500
IronPort-SDR: IbHrBAd8GP1xmQzkVugIkB0PPETrVwZoZNkIb5M++EMv8NIsj3xAhSHPtGYkF0WBkuUyJNjPD8
 nBgHEtuB3zpA==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="156950715"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="156950715"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:02 -0800
IronPort-SDR: uCxQ0LdWe7kqqXei3G5TjN4VOMDWBZI3jGuxVFgV81fXF7hG0Jww9oGEFYm9iHDr02gQjNazYB
 ijObM0cWPlcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="473356418"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 10 Nov 2020 01:19:58 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 46AEC1CC; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 01/10] thunderbolt: Do not clear USB4 router protocol adapter IFC and ISE bits
Date:   Tue, 10 Nov 2020 12:19:48 +0300
Message-Id: <20201110091957.17472-2-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These fields are marked as vendor defined in the USB4 spec and should
not be modified by the software, so only clear them when we are dealing
with pre-USB4 hardware.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
---
 drivers/thunderbolt/path.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/path.c b/drivers/thunderbolt/path.c
index 03e7b714deab..7c2c45d9ba4a 100644
--- a/drivers/thunderbolt/path.c
+++ b/drivers/thunderbolt/path.c
@@ -406,10 +406,17 @@ static int __tb_path_deactivate_hop(struct tb_port *port, int hop_index,
 
 		if (!hop.pending) {
 			if (clear_fc) {
-				/* Clear flow control */
-				hop.ingress_fc = 0;
+				/*
+				 * Clear flow control. Protocol adapters
+				 * IFC and ISE bits are vendor defined
+				 * in the USB4 spec so we clear them
+				 * only for pre-USB4 adapters.
+				 */
+				if (!tb_switch_is_usb4(port->sw)) {
+					hop.ingress_fc = 0;
+					hop.ingress_shared_buffer = 0;
+				}
 				hop.egress_fc = 0;
-				hop.ingress_shared_buffer = 0;
 				hop.egress_shared_buffer = 0;
 
 				return tb_port_write(port, &hop, TB_CFG_HOPS,
-- 
2.28.0

