Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADA15F004
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfGDAVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:21:43 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34761 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbfGDAVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:21:42 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so2101959plt.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 17:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6VYOVzWBYopPWKzQdlYV8cj5NJsq30a3YnonpYvXm1U=;
        b=uWepaB5PV+MV3W7a5U4q3EzyCfOxCXn6G7tXWLbSp5eFmBew9Q/VyK8WDy8xVElZ2P
         5rJQJVjaC9lWCLxE/6GWFj3zMcQJsFWC67tWVcmGyvF9a5mpoOnJTW/2bfve5pgo4sY5
         tmGcu6pBNn1ewyThRr0yflXQz2p8xWO1ahi5ScX8EVQFhiS1xqTOVTqT+3ukKou7OGDY
         AA+EybcZ/i8748/0O2m6KgNyidwqAkTzYnDohQhNGpB/MjSpEQHNzhwWoRWDIRl0TQSW
         zeUJNisWGbDB36+agjSLpt2SSRPH2zZpX3QyvI/+r0eDbkGu0H1J+pfrJjm+VTv2d5Si
         4FcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VYOVzWBYopPWKzQdlYV8cj5NJsq30a3YnonpYvXm1U=;
        b=TDe3rcx2gua7U9i0cDx9U9qJ4HYq1BnuoBgniiZnCKrfOeUhDAbxbJsn7rKc1pXGP1
         g1DsEJ++Zji1O9w44eoAyQ2E8IXwOgTvGudlGYZpddJO1I9qQ1hLhfvpbXQ1bY9lmgRe
         cqrXsjT4p8Y8Ajvm7cQoP9Yi90R4sEE6f/fSw8fcu+ejHAeZgQMsCXI4i3GpAgV4OIDL
         pRRl7in+os5BVeF+EugzMuh88QXpOWKg1HH2C4llyA8K5V1IjZfszGMGOxTSJdSbrPZP
         KSstVxB+E48DZp+ojQOsONXQRz02ej7wMobhy3cMTSRgHvqAujotkK5a49RW/z72VyT2
         9JoA==
X-Gm-Message-State: APjAAAUceVl1w6+wm/4LKFMre4jrivuGDJkQurDkEjYp4H+4oLI+BsDZ
        W3JvW3bARX/qF5mE2sagKsEAmwqqhdA=
X-Google-Smtp-Source: APXvYqymKx6DiPRxUsDogNbJskKn8ZhSGmFT5xSXdCDTs4vikTfAiLv76kcMkw+9hXFPQiUjzQ1EDQ==
X-Received: by 2002:a17:902:7285:: with SMTP id d5mr28164339pll.23.1562199701365;
        Wed, 03 Jul 2019 17:21:41 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id e11sm7252426pfm.35.2019.07.03.17.21.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 17:21:40 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Arvid Brodin <arvid.brodin@alten.se>
Subject: [Patch net 1/3] hsr: fix a memory leak in hsr_del_port()
Date:   Wed,  3 Jul 2019 17:21:12 -0700
Message-Id: <20190704002114.29004-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
References: <20190704002114.29004-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_del_port() should release all the resources allocated
in hsr_add_port().

As a consequence of this change, hsr_for_each_port() is no
longer safe to work with hsr_del_port(), switch to
list_for_each_entry_safe() as we always hold RTNL lock.

Cc: Arvid Brodin <arvid.brodin@alten.se>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/hsr/hsr_device.c | 6 ++++--
 net/hsr/hsr_slave.c  | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 15c72065df79..f48b6a275cf0 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -351,13 +351,14 @@ static void hsr_dev_destroy(struct net_device *hsr_dev)
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
+	struct hsr_port *tmp;
 
 	hsr = netdev_priv(hsr_dev);
 
 	hsr_debugfs_term(hsr);
 
 	rtnl_lock();
-	hsr_for_each_port(hsr, port)
+	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
 	rtnl_unlock();
 
@@ -428,6 +429,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
+	struct hsr_port *tmp;
 	int res;
 
 	hsr = netdev_priv(hsr_dev);
@@ -492,7 +494,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	return 0;
 
 fail:
-	hsr_for_each_port(hsr, port)
+	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
 err_add_port:
 	hsr_del_node(&hsr->self_node_db);
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 88b6705ded83..ee561297d8a7 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -193,4 +193,5 @@ void hsr_del_port(struct hsr_port *port)
 
 	if (port != master)
 		dev_put(port->dev);
+	kfree(port);
 }
-- 
2.21.0

