Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519CFE7968
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbfJ1Twt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:52:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33045 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731723AbfJ1Twh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:52:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id y39so11083179qty.0;
        Mon, 28 Oct 2019 12:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=62c4duj9vkdYuvoHZEg+AafvQH0FqgrHs83EeN+md7w=;
        b=Ivv3Nqh7MykRK4DCNPYC71wJWAMyatPueySoh4lMjGRGu2Nfu3JSOtPKrsSCkV1rNf
         I6vdjzJnlCzpZDQ/zXF791bGOAoMOB+DHocMloj3Yc/x7qSOAdhAhIaPh+t/Fg/1PATw
         Do7//okekbgElmSv3jY+/qagIFJsGFEMFsudDiRb3oGShOrMU2n6vvbkZ1o06mycZzq/
         IGWU4ruzPZa+yzfNfUPKN/dqZsXy3cYkANZugmKyy0l1LfX6Pbxgbz0dNWhBLjX8V043
         6UEPE2fkNBufRiBiCAOi9CLRw/ZBREoUn23oGjfIrVDoXr4BYh+UJpOKGnLjxNCQKWxm
         7A0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=62c4duj9vkdYuvoHZEg+AafvQH0FqgrHs83EeN+md7w=;
        b=uimyIXOTSE1UIfFlVkOitVl0r2o4jKTj1nALMGsvv24Dx/0XSHDMQXWsdCxQ4Squ6s
         o7MsYFhh4pFgevJuUDihM3AFyd6jWRuB8bsCyBzH+WPabn2zb1i9wMQ1jbwHSVteD0kg
         BE5GwQznLg2Bg0iZzxueqT8WzjARtTeiYgF6fKlGGEV8UTHa1ZtWMODK6w2tkV03UYH8
         Bn3b++wDKqG3TUo4yIATaXHquk1LiW+wCJ31f2KKAhxdL9gSQJKPmpcG7oHH/mzxDX8i
         vZhQr7Ge2pzVwoPUxCON+53KxsrySbxQZXwFICR1hbHxa3uBH7pj9nxC7OsTeybLtg6N
         3iwA==
X-Gm-Message-State: APjAAAWlgVDbVkXwEtvBVUdMou6qBU0QgJEK47FHclc1QEw8HJNYdBC4
        WKes9IYGcmrEmpYwnF/BR7s=
X-Google-Smtp-Source: APXvYqykH2OoT42r3FkNSEH8myfs1j+WQ/mzYNhHMZJG9o5Fmg9bwqZAzcISVCv/W2cgZ88Q7falzg==
X-Received: by 2002:ac8:47ce:: with SMTP id d14mr181174qtr.153.1572292355215;
        Mon, 28 Oct 2019 12:52:35 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q204sm7466948qke.39.2019.10.28.12.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 12:52:34 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/7] net: dsa: remove the dst->ds array
Date:   Mon, 28 Oct 2019 15:52:17 -0400
Message-Id: <20191028195220.2371843-5-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191028195220.2371843-1-vivien.didelot@gmail.com>
References: <20191028195220.2371843-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the DSA ports are listed in the switch fabric, there is
no need to store the dsa_switch structures from the drivers in the
fabric anymore. So get rid of the dst->ds static array.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 5 -----
 net/dsa/dsa2.c    | 7 -------
 2 files changed, 12 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2c9eb18e34e7..470e7b638c12 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -125,11 +125,6 @@ struct dsa_switch_tree {
 
 	/* List of DSA links composing the routing table */
 	struct list_head rtable;
-
-	/*
-	 * Data for the individual switch chips.
-	 */
-	struct dsa_switch	*ds[DSA_MAX_SWITCHES];
 };
 
 /* TC matchall action types, only mirroring for now */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 54df0845dda7..8cddc1b3304f 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -571,25 +571,18 @@ static void dsa_tree_remove_switch(struct dsa_switch_tree *dst,
 {
 	dsa_tree_teardown(dst);
 
-	dst->ds[index] = NULL;
 	dsa_tree_put(dst);
 }
 
 static int dsa_tree_add_switch(struct dsa_switch_tree *dst,
 			       struct dsa_switch *ds)
 {
-	unsigned int index = ds->index;
 	int err;
 
-	if (dst->ds[index])
-		return -EBUSY;
-
 	dsa_tree_get(dst);
-	dst->ds[index] = ds;
 
 	err = dsa_tree_setup(dst);
 	if (err) {
-		dst->ds[index] = NULL;
 		dsa_tree_put(dst);
 	}
 
-- 
2.23.0

