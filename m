Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E023938F630
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhEXXYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhEXXYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CE5C06138B
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:36 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id f18so14128078ejq.10
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p3/uvjoFsLdg1DQX9Am/VgA1o+nsnHsLypQWtoLEHes=;
        b=EXylfCshv7knwGJZQVAWKM2UFMNqE9g0VR3K3BDxI3DxcaeOje7Uqms9BztnBLnS4A
         htY4QP8NxWgOj+q8EBtNJUXyzUqIbEUUcazEw2/fdVw3ug3q5Thjeg4YZSyXKMzyys7o
         LXuZ6ErHagwB0BNLPrgj2MhcWWUMDCzeiBg5roawIr1KehTKEwSsF+kl+0yJ8L2oP+LE
         MuCP1yECXHtRvDLb8h+1e/rql1rdRbBKzhZ6mWVgYisyqUe4oRZiE0GWkVe6dnW5zkE4
         zE9+mUTS5206e84Ypda5LWM17343f3bM8N7wDL9+CzjSQoS460dIKeeL2Ow6nSBL7smv
         2d6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3/uvjoFsLdg1DQX9Am/VgA1o+nsnHsLypQWtoLEHes=;
        b=sjjB6FJmUjRzwjY7cvyJjeOH4jc0idfPsN67+Z+kWA3vBfjagJVFfpER+dLhxEk36p
         TnERb/1T70sdZSLLM/dBCtb0rO1pWDhUKPZGZbcDfDgpA18nvseScd4/Cgg8iFd8c5IS
         RT/xS7rru+SGp5cdlubp90Lrw9P19ARrtolo8QsL+NMeh6JFvW1Dt2yPVVoS4ZpjjLCU
         TvLkHfsEQHOJiE2mIlVAkI4cRuYgzp3OTGroJYtIyzBTCDzHsrqZuthOJ/op1sMqEA3u
         UiPlYEqYwMuaEEky+bBJu+rcXf9evLaHOPnjruqsgzdiPyStKlbuL57IwRKuQaQF+2fX
         7BrQ==
X-Gm-Message-State: AOAM533DPhSX0ldr8hoZ1REPcr4O9E4W0e1OzeptJ2KnazfqpWz4rX1t
        rbSWaDGb2dyiXmANoRFUdpfEjIEyQPU=
X-Google-Smtp-Source: ABdhPJwJ2K/PlLRdjM9EYBfJgZB6ekUbsZO7G2beIzhZaL3YMZlv/qEgKEb+RNgOLtvNUcXkAxJXmg==
X-Received: by 2002:a17:906:2a1b:: with SMTP id j27mr25238514eje.370.1621898555438;
        Mon, 24 May 2021 16:22:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 08/13] net: dsa: sja1105: some table entries are always present when read dynamically
Date:   Tue, 25 May 2021 02:22:09 +0300
Message-Id: <20210524232214.1378937-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1105 has a static configuration comprised of a number of tables
with entries. Some of these can be read and modified at runtime as well,
through the dynamic configuration interface.

As a careful reader can notice from the comments in this file, the
software interface for accessing a table entry through the dynamic
reconfiguration is a bit of a no man's land, and varies wildly across
switch generations and even from one kind of table to another.

I have tried my best to come up with a software representation of a
'common denominator' SPI command to access a table entry through the
dynamic configuration interface:

struct sja1105_dyn_cmd {
	bool search;
	u64 valid; /* must be set to 1 */
	u64 rdwrset; /* 0 to read, 1 to write */
	u64 errors;
	u64 valident; /* 0 if entry is invalid, 1 if valid */
	u64 index;
};

Relevant to this patch is the VALIDENT bit, which for READ commands is
populated by the switch and lets us know if we're looking at junk or at
a real table entry.

In SJA1105, the dynamic reconfiguration interface for management routes
has notably not implemented the VALIDENT bit, leading to a workaround to
ignore this field in sja1105_dynamic_config_read(), as it will be set to
zero, but the data is valid nonetheless.

In SJA1110, this pattern has sadly been abused to death, and while there
are many more tables which can be read back over the dynamic config
interface compared to SJA1105, their handling isn't in any way more
uniform. Generally speaking, if there is a single possible entry in a
given table, and loading that table in the static config is mandatory as
per the documentation, then the VALIDENT bit is deemed as redundant and
more than likely not implemented.

So it is time to make the workaround more official, and add a bit to the
flags implemented by dynamic config tables. It will be used by more
tables when SJA1110 support arrives.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 12cd04b56803..ff2742f53de3 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -78,6 +78,9 @@
  *		   on its ENTRY portion, as a result of a SPI write command.
  *		   Only the TCAM-based FDB table on SJA1105 P/Q/R/S supports
  *		   this.
+ *	OP_VALID_ANYWAY: Reading some tables through the dynamic config
+ *			 interface is possible even if the VALIDENT bit is not
+ *			 set in the writeback. So don't error out in that case.
  * - .max_entry_count: The number of entries, counting from zero, that can be
  *		       reconfigured through the dynamic interface. If a static
  *		       table can be reconfigured at all dynamically, this
@@ -651,6 +654,7 @@ static size_t sja1105pqrs_cbs_entry_packing(void *buf, void *entry_ptr,
 #define OP_WRITE	BIT(1)
 #define OP_DEL		BIT(2)
 #define OP_SEARCH	BIT(3)
+#define OP_VALID_ANYWAY	BIT(4)
 
 /* SJA1105E/T: First generation */
 const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
@@ -673,7 +677,7 @@ const struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_MGMT_ROUTE] = {
 		.entry_packing = sja1105et_mgmt_route_entry_packing,
 		.cmd_packing = sja1105et_mgmt_route_cmd_packing,
-		.access = (OP_READ | OP_WRITE),
+		.access = (OP_READ | OP_WRITE | OP_VALID_ANYWAY),
 		.max_entry_count = SJA1105_NUM_PORTS,
 		.packed_size = SJA1105ET_SIZE_L2_LOOKUP_DYN_CMD,
 		.addr = 0x20,
@@ -757,7 +761,7 @@ const struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_MGMT_ROUTE] = {
 		.entry_packing = sja1105pqrs_mgmt_route_entry_packing,
 		.cmd_packing = sja1105pqrs_mgmt_route_cmd_packing,
-		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH),
+		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH | OP_VALID_ANYWAY),
 		.max_entry_count = SJA1105_NUM_PORTS,
 		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_DYN_CMD,
 		.addr = 0x24,
@@ -911,11 +915,8 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 
 		cmd = (struct sja1105_dyn_cmd) {0};
 		ops->cmd_packing(packed_buf, &cmd, UNPACK);
-		/* UM10944: [valident] will always be found cleared
-		 * during a read access with MGMTROUTE set.
-		 * So don't error out in that case.
-		 */
-		if (!cmd.valident && blk_idx != BLK_IDX_MGMT_ROUTE)
+
+		if (!cmd.valident && !(ops->access & OP_VALID_ANYWAY))
 			return -ENOENT;
 		cpu_relax();
 	} while (cmd.valid && --retries);
-- 
2.25.1

