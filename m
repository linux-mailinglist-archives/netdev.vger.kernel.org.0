Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9A9DF721
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730466AbfJUUvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:49 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33624 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbfJUUvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:48 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so23383712qtd.0;
        Mon, 21 Oct 2019 13:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gP5aOGQm4RR5GKmbETJdksv4+Dy+n4KwJgPC+qtGMS4=;
        b=Lbv5YQgUMc4hjqTtCjXgAOUYrLfjzad1Mv/7k3vVcHQMXYKsOSEZQW9mpUtZnBv89h
         W4BoyD2RnNqkfprfA9aoPVC+CHJ8/gvaK6c/rT85Xqv+udNExtaN7jasi8uKdZkwhIpN
         kS+ZmdIA4Br215x3Geea3DJ8HQQsmBknv7mCzFAFjShXFMaSo7K+hWWTI0+W6UvQzyz3
         vEpE/ehZMSkYnID4X1z7MPPg5LWkAn0vEVkx9FimEdfuwDFiokq1OdyTQM3xCXH3rnAT
         oq7rNqetqcJObM9HgVpNLzQdoHONSYTN3pyvywZ876PS8gvkmmbAjM21ke6YGbubaRtS
         Yymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gP5aOGQm4RR5GKmbETJdksv4+Dy+n4KwJgPC+qtGMS4=;
        b=MucsVzX8zO/N71x9JyGnCmBQdZV4O7Ch+S9JCswxFE/Un8Rcnhds0XA6fD9S/cx0A6
         CZAjzqMj+Njyr+uFwcjx6A5rVsKSGDtVQMBirISLKdTxX33aXW3Dc25vtL1E5R0wtztQ
         fTkD1T0halHQaVEtyVUjvxW9mDBrrri0s9vFA0IIcIlujdC8aZ3ftuqBFO5veLTaW5LF
         7AcsuoopJAAEisCX+1OYlLIXPHz+mKmTLf3Xv82zECjpZnlu1CdLZtbQk7Y+3CyzZH9W
         eO+A4JH9isbBbxv+GeCP+5S1rxECZndP5sFgagdE8y10HDFQGVb19ZXOuoixkYH6phTU
         zfCQ==
X-Gm-Message-State: APjAAAXxnxx/CjeuEJ+/QFOSHbvbyUUhCS2PJVOWJJ+4z0Yfx7IgWtco
        prMjwYv9ICd7dPX1vb+kx4c=
X-Google-Smtp-Source: APXvYqwqgl2+x5QDiF30Xi6fe1sHX39dluDbPbiQdvGRO5PLttsHdkhV3cdbNqv85ppspZKJmDd65A==
X-Received: by 2002:a05:6214:4a:: with SMTP id c10mr8293515qvr.89.1571691107093;
        Mon, 21 Oct 2019 13:51:47 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id y5sm8292049qki.108.2019.10.21.13.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:46 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 07/16] net: dsa: use ports list to find a port by node
Date:   Mon, 21 Oct 2019 16:51:21 -0400
Message-Id: <20191021205130.304149-8-vivien.didelot@gmail.com>
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
ports to find a port from a given node.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 623805ba8e1a..a4de7ff8b19b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -113,22 +113,11 @@ static bool dsa_port_is_user(struct dsa_port *dp)
 static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
 						   struct device_node *dn)
 {
-	struct dsa_switch *ds;
 	struct dsa_port *dp;
-	int device, port;
-
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
 
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
-
-			if (dp->dn == dn)
-				return dp;
-		}
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dp->dn == dn)
+			return dp;
 
 	return NULL;
 }
-- 
2.23.0

