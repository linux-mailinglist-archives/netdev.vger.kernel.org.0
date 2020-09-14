Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6670D2685E7
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgINHa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgINHa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:29 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0914FC06178B
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:28 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kk9so4888194pjb.2
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4BvUTu0NraX8NuxRp3ret+6HOiubsMR2QzLSoIPYMxc=;
        b=A6331fHhTKblWh/ccTyH5HfeZjN4s2Kc7QN0In2/3oXwmQVnzlxpRLRerE37bcVr0d
         evYaXvb8v0VlR8hpkYYvBJI8yVDdayJ0vh0o2WFYxH/ESVbxkqyzsc3UzK1JfFq7jQfA
         aEW6OAQqCMBjF9MjsxUDW1390UwPKVr/BZFYn2zh3TkQ2No6YcPbxrKxjwbbn1fnFM0Y
         s8fClbYAO26ZQoZMicoHbqkZm9uMnJEvzZRqoeLvHpR4aA9mlO8RUs/wbqezke04lMvz
         /oAbWOGEf31dwRd68L3Zts1OZRUW94vxHd6JsdpwMPTtAR0UqvfzJLV9AHADO+Erehnl
         Ue6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4BvUTu0NraX8NuxRp3ret+6HOiubsMR2QzLSoIPYMxc=;
        b=B3mLJODe8mGLJ5N7SQDUilqATFgK4OyiBNgu9GlPNi1PQTp62wk2nTvOx51ei2WsFw
         PKG9Yvn7s2M2Wa7iMexD4Yf9TWjEWYyalno5Ez6oNmnFkWWeEVPTUK/TZBJtl+t8O5Q9
         Y/k1EkEppeoKgzqwEgGoXjRbd93j7d5DAyn3hK0is6KZ2xCi5EYS57yig7Ws8tS0Sfgv
         x43saYk5GKIXysLuspMItTS7gdwipcaunRauv9ObLtS7jaw+jNRhjW8AF+0XCqmOHHKU
         DRE/w//UkhiyFMrB80MHf8gBj+7TkHSkCRTJqSVa71HT1k3S7lnovZI6/XTfWXBVCr4F
         AvNw==
X-Gm-Message-State: AOAM531slZ/CrCxDovskgEX5wje6JdTxyZ95eNeUeTDAAYnXFqwFpblY
        Bk0Dopwl18l8YpBxKXhx3oU=
X-Google-Smtp-Source: ABdhPJw5obAFdGU3YVkxucMZ9L7ukIYiB8iRjluWH/HfDbZkuXD90mdOPycGb6Ewm0pVsmCAiL+5OQ==
X-Received: by 2002:a17:90a:a613:: with SMTP id c19mr3555072pjq.119.1600068627667;
        Mon, 14 Sep 2020 00:30:27 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:27 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 09/20] net: ehea: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:28 +0530
Message-Id: <20200914072939.803280-10-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 3153d62cc73e..c2e740475786 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1212,9 +1212,9 @@ static void ehea_parse_eqe(struct ehea_adapter *adapter, u64 eqe)
 	}
 }
 
-static void ehea_neq_tasklet(unsigned long data)
+static void ehea_neq_tasklet(struct tasklet_struct *t)
 {
-	struct ehea_adapter *adapter = (struct ehea_adapter *)data;
+	struct ehea_adapter *adapter = from_tasklet(adapter, t, neq_tasklet);
 	struct ehea_eqe *eqe;
 	u64 event_mask;
 
@@ -3417,8 +3417,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
 		goto out_free_ad;
 	}
 
-	tasklet_init(&adapter->neq_tasklet, ehea_neq_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->neq_tasklet, ehea_neq_tasklet);
 
 	ret = ehea_create_device_sysfs(dev);
 	if (ret)
-- 
2.25.1

