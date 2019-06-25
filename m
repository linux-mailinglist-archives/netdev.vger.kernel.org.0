Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C92255C6E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfFYXkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36565 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfFYXkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id u8so220618wmm.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p4bW0LFhzAs59fQgji2s6FjCXLUJz56vWy5UpoSbPBE=;
        b=sI3qE1pQTpT0674R8axyjxIK+owzh/sgT2o6KZoc9rNCbEhBG9LjDzYx3xwSITLJFX
         TqWuflhkILYiY+tlC6j3VpTo7K4L3AVrF3JN5HhL/LrqEDE2FGqXvp4zMwnRs9OBqSmC
         meQOPFZNteJI1FHzVLw2AeQu++vN59FNQGrRELc5HcVvAfkMe4jK08WQI76RoQkyxYYh
         EcOJBmybf0TzMUYgkqxGwocHFRhrs98Ry8jzbmU4KcWSS8O9DvZP7ROj0eNltfq1Pixi
         kS1vxOwfhjVeK+0cdn5xWNgdaqs6I0+nEjcRne7ChMp3wDua9i2ciPgZR0e9a4HQYWA5
         va+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p4bW0LFhzAs59fQgji2s6FjCXLUJz56vWy5UpoSbPBE=;
        b=YxQbTu1Kr2D+pNAmJ+RRYPCpOpAbx1Q+kRQb/dO2C1HT3QjV3zJqF9VUtB035ExYcU
         KRpH0raFDJ4cqFZaNlEgm+VVJyphpJmmdVTNhNVecbzyeYIpyjgb7nkY2qnDki2blNIu
         lwltOAhssIWsDGZG6fT4t+AlmP50XkLYXFq0OBXxCPt6aDRXfSpDJAUIQqB73VO8msbJ
         t4Oo+aAoiaP/PPuRnZmQQRkThZoxNXNSnKoP4pw1kwZ6W1wICAKh1TPlGbVRE5YrO7kg
         Hih0BqN6hZnLeQbcW8idNt/H81LlmHrWtzeHVrxPhb2Mmf/d3VRcoqfqCvQVdmTIezxQ
         t0sA==
X-Gm-Message-State: APjAAAUi62btjcuqjIxKcFlVrHxktgqfLOxHxk3/k+5YAJ1rq/XLodl+
        cxkY8lC2RljNbjHC425pRcI=
X-Google-Smtp-Source: APXvYqxRiTxynVeqRa+YpmEme1A0wrpQ6JhgcL8z97zL4qDK9lsQxyrzSFiwiZotgHqlCf+2xPDDGQ==
X-Received: by 2002:a1c:39d6:: with SMTP id g205mr201419wma.85.1561506008388;
        Tue, 25 Jun 2019 16:40:08 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 05/10] net: dsa: sja1105: Make P/Q/R/S learn MAC addresses
Date:   Wed, 26 Jun 2019 02:39:37 +0300
Message-Id: <20190625233942.1946-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the end of the commit 1da73821343c ("net: dsa: sja1105: Add FDB
operations for P/Q/R/S series") message, I said that:

    At the moment only FDB entries installed statically through 'bridge fdb'
    are visible in the dump callback - the dynamically learned ones are
    still under investigation.

It looks like the reason why they were not visible in 'bridge fdb' was
that they were never learned - always flooded.

SJA1105 P/Q/R/S manual says about the MAXADDRP[port] field:

    Specify the maximum number of MAC address dynamically learned from
    the respective port. It is used to limit the number of learned MAC
    addresses per port.

It looks like not providing a value in the static config (aka providing
zeroes) is enough for it to not store the learned addresses in the FDB.

For now we divide the 1024 entry FDB "equally" amongst the 5 ports. This
may be revisited if the situation calls for that - for now I'm happy
that learning works.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c          | 3 +++
 drivers/net/dsa/sja1105/sja1105_static_config.c | 4 ++++
 drivers/net/dsa/sja1105/sja1105_static_config.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index bc9f37cd3876..46a3c81825ec 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -203,6 +203,7 @@ static int sja1105_init_static_fdb(struct sja1105_private *priv)
 static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 {
 	struct sja1105_table *table;
+	u64 max_fdb_entries = SJA1105_MAX_L2_LOOKUP_COUNT / SJA1105_NUM_PORTS;
 	struct sja1105_l2_lookup_params_entry default_l2_lookup_params = {
 		/* Learned FDB entries are forgotten after 300 seconds */
 		.maxage = SJA1105_AGEING_TIME_MS(300000),
@@ -210,6 +211,8 @@ static int sja1105_init_l2_lookup_params(struct sja1105_private *priv)
 		.dyn_tbsz = SJA1105ET_FDB_BIN_SIZE,
 		/* And the P/Q/R/S equivalent setting: */
 		.start_dynspc = 0,
+		.maxaddrp = {max_fdb_entries, max_fdb_entries, max_fdb_entries,
+			     max_fdb_entries, max_fdb_entries, },
 		/* 2^8 + 2^5 + 2^3 + 2^2 + 2^1 + 1 in Koopman notation */
 		.poly = 0x97,
 		/* This selects between Independent VLAN Learning (IVL) and
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.c b/drivers/net/dsa/sja1105/sja1105_static_config.c
index a1e9656c881c..b31c737dc560 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.c
@@ -230,7 +230,11 @@ sja1105pqrs_l2_lookup_params_entry_packing(void *buf, void *entry_ptr,
 {
 	const size_t size = SJA1105PQRS_SIZE_L2_LOOKUP_PARAMS_ENTRY;
 	struct sja1105_l2_lookup_params_entry *entry = entry_ptr;
+	int offset, i;
 
+	for (i = 0, offset = 58; i < 5; i++, offset += 11)
+		sja1105_packing(buf, &entry->maxaddrp[i],
+				offset + 10, offset + 0, size, op);
 	sja1105_packing(buf, &entry->maxage,         57,  43, size, op);
 	sja1105_packing(buf, &entry->start_dynspc,   42,  33, size, op);
 	sja1105_packing(buf, &entry->drpnolearn,     32,  28, size, op);
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index a9586d0b4b3b..2a3a1a92d7c3 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -151,6 +151,7 @@ struct sja1105_l2_lookup_entry {
 };
 
 struct sja1105_l2_lookup_params_entry {
+	u64 maxaddrp[5];     /* P/Q/R/S only */
 	u64 start_dynspc;    /* P/Q/R/S only */
 	u64 drpnolearn;      /* P/Q/R/S only */
 	u64 use_static;      /* P/Q/R/S only */
-- 
2.17.1

