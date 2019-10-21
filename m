Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D059BDF727
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbfJUUvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:44 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33614 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbfJUUvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:43 -0400
Received: by mail-qt1-f195.google.com with SMTP id r5so23383359qtd.0;
        Mon, 21 Oct 2019 13:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9CPdzYm5ufK2UyykZobSwUtkryq5A7eUGa+CDCAGtY=;
        b=AfG3Z4BlaA1xm2SvqDoO0ITGHEp/OYNdlDVjU2A1dqQVanWF0I29179/LgU5ZeZjuD
         v+LywfOLLK6mBCKNl6ROBE9pUOLblkHEgzocW5Pe3hBu3jfiFva33uuzyLJtOcerb+RX
         543MZOrpi9xpnjrbx6DZ9AQWbTIK0Aly279dLNDaMYcbj5XaSqCyOxA9uchUZk/Ir8ox
         rwxg7mtF1PJoXPlh0A5/T5i17jbBsEiMgUXrLKfqyGY3783hIdn8CHkiMCW/FgTOCyIJ
         zCr5GHBjfnTcOGvGoAY7DjeVXZActd47UE22NrrUxY8/60VKUD4QU/Gc06Iz3JbHMJqg
         dKrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9CPdzYm5ufK2UyykZobSwUtkryq5A7eUGa+CDCAGtY=;
        b=Nsz6TFobg78GKpKhFcsLOh1D2v2WVLSl5EfQSCtj6Tdzf4QDDFfpPqVaGwcvYv0wQH
         EfmEE/RGyS/LJNO5gbiTbCnZG9J0EtH93T1AbFXlFmJKFbIIfXcexViVaC15m9K1gQqZ
         SRTcbB9YVvlhrR3usFgirvXDakZuJiSLqkytA5aMO3+nF8cWRNxgL3vbSghoieSWjETe
         rLxwiOy2lu9Eq6lw5hzanNKvDzP5yJDjaFHhbFwhKndulv2pb95NfdNyrtwIvqBIfi4t
         ERdlLTD2BgF68Yg9v0hM7Ikmxh6ObpE5tM845LobnGsEv/CWd4O2SuyHZgsgh9kc/dp+
         RUUQ==
X-Gm-Message-State: APjAAAW0F/fIhQ14FwDSYZ6RsNe02AHvt+JrJAM3SU65RobCS1veavyb
        gamVNoflFRUdHbfwZ/7RjAE=
X-Google-Smtp-Source: APXvYqzVUOY2zYCggA4DFXzzyL+Xhs0eMzOdEXuTJwC7K4t0YKlZr9hqGVSbJf+NxasbkbtJU6hhYw==
X-Received: by 2002:ac8:70c3:: with SMTP id g3mr11171049qtp.391.1571691101896;
        Mon, 21 Oct 2019 13:51:41 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id x203sm9630984qkb.11.2019.10.21.13.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:41 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 04/16] net: dsa: use ports list to find slave
Date:   Mon, 21 Oct 2019 16:51:18 -0400
Message-Id: <20191021205130.304149-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports when looking for a slave device from a given master interface.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/dsa_priv.h | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 12f8c7ee4dd8..53e7577896b6 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -104,25 +104,14 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct dsa_switch_tree *dst = cpu_dp->dst;
-	struct dsa_switch *ds;
-	struct dsa_port *slave_port;
+	struct dsa_port *dp;
 
-	if (device < 0 || device >= DSA_MAX_SWITCHES)
-		return NULL;
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->ds->index == device && dp->index == port &&
+		    dp->type == DSA_PORT_TYPE_USER)
+			return dp->slave;
 
-	ds = dst->ds[device];
-	if (!ds)
-		return NULL;
-
-	if (port < 0 || port >= ds->num_ports)
-		return NULL;
-
-	slave_port = &ds->ports[port];
-
-	if (unlikely(slave_port->type != DSA_PORT_TYPE_USER))
-		return NULL;
-
-	return slave_port->slave;
+	return NULL;
 }
 
 /* port.c */
-- 
2.23.0

