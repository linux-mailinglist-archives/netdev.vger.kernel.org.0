Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B291E53E5
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfJYSt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:49:58 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45867 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfJYSt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:49:58 -0400
Received: by mail-qt1-f195.google.com with SMTP id c21so4713161qtj.12
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1MfJDK6l/Wfn3YMeEDcdhAPY23Q+cJZubnwfWY5SNMY=;
        b=iUqSX9T+vQwkzhQFl1x0gDjubUwJ8coqd+//hPmFT4JU4sEkvzO6Q2LVvOQUuTJajO
         2MiGXxRpA8QS7Xhl8ChW12HHV4MTvJQlmDhHpZpMUX0TrDV2bakaxOBDBU2SVAPIiBF3
         dnvZRXlj0rAw71nzS+Lw8d13v+bfUGmzv4rqnezOObi1ZCHoh52IGOwlTjOj54HpcpL4
         BNgBH0dwJnD8vSZg1ZhteUge3NOHrtEwMy/nO2L1WlPnqyGMtNG5MmN/bpLWj45Y+i/p
         ouBhKpTtbF0MCqrePJpyKvQfPl597sZ/cPxv/x2cxWO1BmPsxHK7eJeZstmDNUGB4uIL
         5hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1MfJDK6l/Wfn3YMeEDcdhAPY23Q+cJZubnwfWY5SNMY=;
        b=i8tIe1lBc2nXmquVVJCJ54N+8o85AcxiKyxl6bp8ffsWbuE3tdoON3xIDNakoV0YVx
         4HAuVpzwb+Z7MQymXdR8IEsoEeZqZqjInp4Zh1b4lsimtfn9F+KMasAZoA/d4xNmiCJi
         N/phtpXJvsipCWrCftrX2Kdr7V8QD8fB3ufJlo1UPFM0SMex/lUMvDt7hRAMsRLExC7i
         iCAZJMZ3b2hsJ6OJ5TFWybDKTti+tukXnAO50/oFrhmyrfTnsubKavWSF5duaqhBZN7Q
         VgM/+/+wCYJQoTPv+gdkucYEYfnObj1jnSsYClldsF8N+hwSRTee9qYy0lb7MLncbgwO
         ecgQ==
X-Gm-Message-State: APjAAAX74gf4kXHvI+Pfd2Xl8Zk86wNPi9Ao6lAxyl2PV6xt6lL8YGs2
        fYevnwDg0LvQ6LOJSppKJfU=
X-Google-Smtp-Source: APXvYqx1R3x6lQA48Cmu1Ad2EPjLHkB+RRwQVTQNB7yRcdmK3MOkdYALfQlXruyeuPQ2v0WyEU7nDg==
X-Received: by 2002:aed:30c3:: with SMTP id 61mr4195642qtf.243.1572029397446;
        Fri, 25 Oct 2019 11:49:57 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u7sm992783qkm.127.2019.10.25.11.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 11:49:56 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next] net: dsa: return directly from dsa_to_port
Date:   Fri, 25 Oct 2019 14:48:53 -0400
Message-Id: <20191025184853.1375840-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return directly from within the loop as soon as the port is found,
otherwise we won't return NULL if the end of the list is reached.

Fixes: b96ddf254b09 ("net: dsa: use ports list in dsa_to_port")
Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 73900b89c1b9..14357b576b13 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -286,13 +286,13 @@ struct dsa_switch {
 static inline struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 {
 	struct dsa_switch_tree *dst = ds->dst;
-	struct dsa_port *dp = NULL;
+	struct dsa_port *dp;
 
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dp->ds == ds && dp->index == p)
-			break;
+			return dp;
 
-	return dp;
+	return NULL;
 }
 
 static inline bool dsa_is_unused_port(struct dsa_switch *ds, int p)
-- 
2.23.0

