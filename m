Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A746DDC15
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfJTDUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34734 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfJTDUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:18 -0400
Received: by mail-qk1-f196.google.com with SMTP id f18so8471184qkm.1;
        Sat, 19 Oct 2019 20:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pu9v9MA8pxbEXLowlozaaYOX1Ipa7KhTSS/d86jmqlM=;
        b=aOEEr1C0wlHa9cpChWPMOeKJFsu13Q0toI2w790aw+PQCaUvp9Cl8klMbCtHHORh1Z
         FRzYqY4/gHL+EWUCMaUc6HX7CrxZ0wlCwI0I07SUz2KgSU+nJ0J89H7ZeUufCziJiI3r
         I86O1wSuuO00S3kzcLwu881ReDdA46vg3voaGg1IZLbYjzKQf3ixnOc+MCXX2dwyyRlR
         WJATUrQv1LEjn5eOgRfMB1Rmi4udYj+5n/hjGsBKo80uuTvbnpb3bxoqYQdQwSvemQWN
         /avVA16iAkk+YfMkEBG5jjNL97UzMTO7EsBwBF7muVxK2HZkKc5K+5c53TyvZsTxFpLQ
         S2Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pu9v9MA8pxbEXLowlozaaYOX1Ipa7KhTSS/d86jmqlM=;
        b=r4EdMh/UdFrLYapkPrXnI8F3Us+T1K9fwCW8TpUjP9v/nDg7C0jxs5fUcSylyuytOl
         eCWGgubZnRLALw8vkQYNgDOMyRUjc/9UTJdlSGuco21gVKk52PzpoZQSgbG445lTOXur
         4+GyhSZKeBIf7RCz0R4MwXDBhtPFdZC0TWSZHsXllfndMzlgQU2zEhBUV0ZtO0yzBK2P
         F1WbbHB/THVy3L91jyDh3NcJ5CSTq00mvXtmz9mf1jB0dfZK3/0NEK+AlahtfBWSmzMZ
         ZMlTCBVJzgRsNaP6GPv8Rur5Z8GvU2kYKyNIJziCqZ85NGyPwM3fdIjVj/06DYJR6I/l
         XhUg==
X-Gm-Message-State: APjAAAU8cs8ReeoHHzIhxsOsPI28oE+fxpcLgVcD8N2PTPnRmXOR/She
        qCI09qmoP7oG1oWrjt4KDWM=
X-Google-Smtp-Source: APXvYqwGgU+7eUsQm3YMTD8rgzMbLWD0QVmXfTfgtc/4S4sS7gFwVa8K4coPWj9bRtkMmSpSZMw/eQ==
X-Received: by 2002:ae9:f407:: with SMTP id y7mr5617764qkl.154.1571541617058;
        Sat, 19 Oct 2019 20:20:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t17sm9622626qtt.57.2019.10.19.20.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:16 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 07/16] net: dsa: use ports list to find a port by node
Date:   Sat, 19 Oct 2019 23:19:32 -0400
Message-Id: <20191020031941.3805884-8-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports to find a port from a given node.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 net/dsa/dsa2.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 84afeaeef141..8b038cc56769 100644
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

