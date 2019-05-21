Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2294E2584D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfEUTa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:30:59 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37790 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfEUTa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:30:57 -0400
Received: by mail-qk1-f193.google.com with SMTP id d10so11835572qko.4
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o378TCts+dVx6CYoD2w/4eUcK7tHx7EAh9ayxGgzFVM=;
        b=iKFTxMXZaGnGB9pb+4ZsXj20bAwhZrmLcadOwzkY+37jQVB9zNtaBPKp7pKShcg5/Q
         n0ysB1Shhu4aqyXGRJdupRTpEpXLsjMQ4L8HsLjJ5WdrXmmwnNGIBiT6JTfQEmqLMySA
         VgfiP2W09wGq+YlizOaA8rMe+Ug4wNW1XnA2yZtZNVwUb0bgbWFiPV/Gi1LsUf0ooosu
         FW+4QgGxdja3hHDyezcfVioCfJqWG3oGuOKna6bbtAuwrxRXWQ0F2LeDmfhrHcqxmzlK
         wzEQYh8NQck2Le4yYohwKp1u/nDgceg141wiHd0ObNwCgDh/soeTmd574nI1T3YIzHEW
         E8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o378TCts+dVx6CYoD2w/4eUcK7tHx7EAh9ayxGgzFVM=;
        b=mwSkXT3eG7LjL0vOKrdnwqsDmGdlGwNmYM3aCHB448LT2XynS81UuaBSqSDORptJsV
         X/GmkMuZTeEBMYz5eUpeoFUqo/yKZupQyP7xSqD6BkdjkXNRs8uzSB6GmSmiSHT/4som
         sQfjE1nvEMhcFBqukiyuGGa5+VQ3AIPe+xuhdCI3/l3gyQCc5Uly/ULBVt2Nk5nNJQqM
         bknF0uCIL2Snw7/YtkUnlnqr9Eirunbs4b1WhLRAWxnqZ19FrOx7eLcfCC+PWGxq2w6r
         ZGo98Z1OUCGf1GNkSI0FDdv5TM0MVqS1SNYONBayY6PUZ4nyMtN3NtD8iDGQrDmavrOr
         zrTA==
X-Gm-Message-State: APjAAAXwykpIGMCfdwUgt89+OA/CaXTilDzmuyAxPe91lsSJO0BzL4dY
        WgNRcM0OdLHIBxTkqxlSwcKOoYGg
X-Google-Smtp-Source: APXvYqxqWydL/RGGPexYBDcTHyMi4kF1sd5WCLYa/vB5dQAKB1I0BwGwthzTMvdi0UZ3jg2KA9qFbw==
X-Received: by 2002:a37:7bc3:: with SMTP id w186mr8484568qkc.225.1558467056811;
        Tue, 21 May 2019 12:30:56 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id w195sm10865931qkb.54.2019.05.21.12.30.55
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:56 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 4/9] net: dsa: introduce dsa_is_upstream_port
Date:   Tue, 21 May 2019 15:29:59 -0400
Message-Id: <20190521193004.10767-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a dsa_is_upstream_port helper to check if a given switch
port is directly or indirectly connected to a CPU port.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 7b10a067b06d..c5b45bfeea01 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -347,6 +347,15 @@ static inline unsigned int dsa_upstream_port(struct dsa_switch *ds, int port)
 	return dsa_towards_port(ds, cpu_dp->ds->index, cpu_dp->index);
 }
 
+/* Return whether the port is a local upstream port */
+static inline bool dsa_is_upstream_port(struct dsa_switch *ds, int port)
+{
+	if (dsa_is_unused_port(ds, port))
+		return false;
+
+	return dsa_upstream_port(ds, port) == port;
+}
+
 static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 {
 	const struct dsa_switch *ds = dp->ds;
-- 
2.21.0

