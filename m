Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C1C122B9C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbfLQMd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:33:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:28139 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbfLQMdz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 07:33:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 04:33:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,325,1571727600"; 
   d="scan'208";a="217506050"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 17 Dec 2019 04:33:50 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id A2580535; Tue, 17 Dec 2019 14:33:45 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Rajmohan Mani <rajmohan.mani@intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Mario.Limonciello@dell.com,
        Anthony Wong <anthony.wong@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Kellner <ckellner@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/9] thunderbolt: Make tb_switch_find_cap() available to other files
Date:   Tue, 17 Dec 2019 15:33:42 +0300
Message-Id: <20191217123345.31850-7-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
References: <20191217123345.31850-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rajmohan Mani <rajmohan.mani@intel.com>

We need to find switch capabilities in order to implement TMU support so
make it available to other files as well.

Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/cap.c | 11 ++++++++++-
 drivers/thunderbolt/tb.h  |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/cap.c b/drivers/thunderbolt/cap.c
index fdd77bb4628d..19db6cdc5b70 100644
--- a/drivers/thunderbolt/cap.c
+++ b/drivers/thunderbolt/cap.c
@@ -113,7 +113,16 @@ int tb_port_find_cap(struct tb_port *port, enum tb_port_cap cap)
 	return ret;
 }
 
-static int tb_switch_find_cap(struct tb_switch *sw, enum tb_switch_cap cap)
+/**
+ * tb_switch_find_cap() - Find switch capability
+ * @sw Switch to find the capability for
+ * @cap: Capability to look
+ *
+ * Returns offset to start of capability or %-ENOENT if no such
+ * capability was found. Negative errno is returned if there was an
+ * error.
+ */
+int tb_switch_find_cap(struct tb_switch *sw, enum tb_switch_cap cap)
 {
 	int offset = sw->config.first_cap_offset;
 
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index 0158f0e9858c..28dd0e0b1579 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -685,6 +685,7 @@ struct tb_port *tb_next_port_on_path(struct tb_port *start, struct tb_port *end,
 				     struct tb_port *prev);
 
 int tb_switch_find_vse_cap(struct tb_switch *sw, enum tb_switch_vse_cap vsec);
+int tb_switch_find_cap(struct tb_switch *sw, enum tb_switch_cap cap);
 int tb_port_find_cap(struct tb_port *port, enum tb_port_cap cap);
 bool tb_port_is_enabled(struct tb_port *port);
 
-- 
2.24.0

