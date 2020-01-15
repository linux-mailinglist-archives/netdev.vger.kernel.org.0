Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B777613BEA6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 12:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgAOLlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 06:41:17 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39833 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbgAOLlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 06:41:17 -0500
Received: by mail-pg1-f195.google.com with SMTP id b137so8098458pga.6;
        Wed, 15 Jan 2020 03:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NJMMur67AR0jae8jF9nPUvI7tXT+F1ukuVAKqerILaA=;
        b=ZLy6jB7emzIXTRq+hgGRXWDcMcxvW/MxXSJxSfSOPYL7BT0wZJ9RmS4ECrN5sU64LE
         71VnbUoHLMD2ny/8BwRo+KG2gQA7bGfp/c2QH5oCx9lEUohAd0DsHdnMcGCSOzKVCnlr
         Mftxp9UKelVq0dZNII4VpiKfsAqEX7e+j6ZNI2rKuKgbdOsjRgXUipJdNXXOuOO00RSp
         AKY9pyE4551I+2MNDQFFvH4gpTkDWVZ7ONmC4AQvmgKjAtS9l0lVfRLd7k33KHBIOgzm
         myCYp341wTatTXf6qFxdajiVM9GXXcETTVnhYtgNuLJHofVS12KZvjCVja3WwRgi/X8+
         Gwwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NJMMur67AR0jae8jF9nPUvI7tXT+F1ukuVAKqerILaA=;
        b=IGx0FlTttThZNisFPhgrzJksjMwZewSPz/nB+h0lwd1QlFB5ecQMRKQtYSv1IOrWx2
         ERFjlWFdC7NUcY/gsLdbYrmYfO3fa8H68iQ0fqS2Krz1M3cFBldhqm3YC2gePCWsL8e2
         Kj7H3mQNqiBkKaed4Z/XXFH2h5D3tpDxJMipDo7UauTbZyibL6WIWXknKo6vaWzc5rGJ
         NxnDJMhKFnD5nYh2s3CaT5fQeWg1C5O2vkILQCX4J8Y8wO2z0Yec8tuEhs/l7ezzySAo
         ryaXmavfJtzKxlipTAxCA28dtiflQ392SGXFvLmD0pM3+83vaSqrSONWJHy3dVJflWeX
         rEqg==
X-Gm-Message-State: APjAAAUKuGaLQEwRPgSdHThGSQpl6MVEad0CxFTHI8QWFVw1NTZPXVje
        xJwyQ215jbg6O0UoflFEcuc=
X-Google-Smtp-Source: APXvYqx7eBmWC19EHivXv+68lQFzkQ9AwswFFyZ1hC6yGbRYdKg3lmD3zxWhHuW82cTbauFGweytHg==
X-Received: by 2002:a65:6451:: with SMTP id s17mr32436532pgv.188.1579088476475;
        Wed, 15 Jan 2020 03:41:16 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee2:fbb9:d507:a4c2:d370:bd13])
        by smtp.gmail.com with ESMTPSA id v4sm21300869pfn.181.2020.01.15.03.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 03:41:16 -0800 (PST)
From:   madhuparnabhowmik04@gmail.com
To:     davem@davemloft.net, gregkh@linuxfoundation.org
Cc:     paulmck@kernel.org, joel@joelfernandes.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        frextrite@gmail.com,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
Subject: [PATCH] net: wan: lapbether.c: Use built-in RCU list checking
Date:   Wed, 15 Jan 2020 17:11:01 +0530
Message-Id: <20200115114101.13068-1-madhuparnabhowmik04@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

The only callers of the function lapbeth_get_x25_dev()
are lapbeth_rcv() and lapbeth_device_event().

lapbeth_rcv() uses rcu_read_lock() whereas lapbeth_device_event()
is called with RTNL held (As mentioned in the comments).

Therefore, pass lockdep_rtnl_is_held() as cond argument in
list_for_each_entry_rcu();

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
---
 drivers/net/wan/lapbether.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 0f1217b506ad..e30d91a38cfb 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -64,7 +64,7 @@ static struct lapbethdev *lapbeth_get_x25_dev(struct net_device *dev)
 {
 	struct lapbethdev *lapbeth;
 
-	list_for_each_entry_rcu(lapbeth, &lapbeth_devices, node) {
+	list_for_each_entry_rcu(lapbeth, &lapbeth_devices, node, lockdep_rtnl_is_held()) {
 		if (lapbeth->ethdev == dev) 
 			return lapbeth;
 	}
-- 
2.17.1

