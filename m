Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9709DF70F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbfJUUvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:51:52 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46368 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbfJUUvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:51 -0400
Received: by mail-qk1-f196.google.com with SMTP id e66so14119979qkf.13;
        Mon, 21 Oct 2019 13:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+CwstySmiepzoE+a6XraWOC/6PchbI8I6Ki/UQTySws=;
        b=tPnuFqevwVoN7J/ZrzHR4oZJZ8Q+kxW+B28j8lCAZ3O0x3800QrK22OQQ0EYOfgcJ0
         SgZQI47byWY91ju99PkTCSCZF5wdjr0U/lA7eUF/z84W3zmR6TGzOQ2v4bCeKqttn7z7
         sBR5kavwYjB9BLG8Vk5RT0SOIKew7QkLcX5EkMwwCqgF+S4X6b0qNhusEXcryuJgpqQO
         ualCXD2B7aOIbDXiuapXPkaJgyU3ApXdFn5eqEVPqtUnnpcdJx3R6Dfv6rxJ9AcCRaap
         +aavm+/TJLqiEvd7OjJfxiQ8+/wyQNLgmMJ1OpdUyc05Ri7LEIOewu1kHlqy/qY6epoD
         HU/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+CwstySmiepzoE+a6XraWOC/6PchbI8I6Ki/UQTySws=;
        b=ctH45h5BezavM7UHm5iZZ4jUBgge2KyB0k8vjQlMiNdc8ZEDo3AJ3EMPaVOKgqfopq
         4ll76a/L9Q1dCbp8uQpk8VCrW4jlg7PFp6aqIQUPSGDFxRrNH0+Ax8ZuWAPDaIz26niU
         4+1L+gM2IZTX/U5KV/iwF4UOcoNdaUUBVuFrsP9VvGRrsfm6rVBUtme1vuWWqHsLJDJP
         9D7WH7ed5hiyl3KXt/bWiVHPqdtP1KGhkdAqx8OfrFQhKxtc00cNXd+FvVr6d5tWkf25
         ZXySPF/RaG3ss+MokU/UJ5ZJTtN6Oyp+cfe5meu6HbR+HWBLpyXeR0hCPndOo+jw4WDx
         2gjA==
X-Gm-Message-State: APjAAAVs+tbBooq6At5vrNxGdZKZy4AIxQgOuLMTLX4KHGVs5fyKpUA8
        jQEmeAoYzV+0NvPGuIxFlWQ=
X-Google-Smtp-Source: APXvYqwhfDBa7TdpYHVfo97i3GdrIG82b5JUic/bxJKYJLdiRMxe0m2kJQkpeV8cRXOKU2QpLoBrig==
X-Received: by 2002:a05:620a:12e7:: with SMTP id f7mr24029730qkl.290.1571691110102;
        Mon, 21 Oct 2019 13:51:50 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o38sm10783985qtc.39.2019.10.21.13.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:49 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 09/16] net: dsa: use ports list to find first CPU port
Date:   Mon, 21 Oct 2019 16:51:23 -0400
Message-Id: <20191021205130.304149-10-vivien.didelot@gmail.com>
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
ports when looking up the first CPU port in the tree.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 514c0195e2e8..80191c7702a9 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -186,22 +186,11 @@ static bool dsa_tree_setup_routing_table(struct dsa_switch_tree *dst)
 
 static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
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
-			if (dsa_port_is_cpu(dp))
-				return dp;
-		}
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_cpu(dp))
+			return dp;
 
 	return NULL;
 }
-- 
2.23.0

