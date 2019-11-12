Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F521F8789
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 05:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLEi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 23:38:56 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33062 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbfKLEi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 23:38:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id a17so1370499wmb.0;
        Mon, 11 Nov 2019 20:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nLLidl8EpyfCmholvzuJT3GpVTM10C9w3Aj4vlpHqn4=;
        b=GywpLzr6omZN7FAOh3Nz5QrhXFDYtGTzjRZJKuL8RCDz0JXzd3fZZh1BPNNgz+O47D
         QdhJvcUKL2M2uspcwGJQk0sdiwvfFcme3NAmp+nqUiwFd/1uhrtsZCneZMC+pLgmF+3f
         +L7cmURcxX88rZfpmPeenSRJFPDBpEChNpvmeqXmBBfrXloCbi278iy1jcBcel82Ypbf
         tlWCR9bunZc5H9lspXaYWfPfcoVFD0VGWYmxUhpSow31tjErj//UXIJZfZOGJlNZCY++
         r1HmMaeGZt98z9FCEJ1EqL8I9/+M9ngda69aKZP/UpA+i/9sstb6sgAXLIXDXBqHUgdD
         kr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nLLidl8EpyfCmholvzuJT3GpVTM10C9w3Aj4vlpHqn4=;
        b=e/Dx9MOJqykxd9jhooSfkJkZOFe5ivU42bjhlrqAyPnmLEhmSWzv6b+Ae7xPAijdba
         nA7Ta+6du37npNQsWlzNBcbTr3K252D1bYk/w6gcTTFUO9WOxaBizkAq3Lqq7gVDkY1R
         OAAkXOYigzTQCo3Ci7ygi3QHrjowAWeTsRFpGmXyTl3ZLmsT/Zq9zAUAMD0GOmAJW10X
         /y0H3+Oyxu2V+gxx86fEIxGDqi5tKP6PmZ/TCzShmowP0QkL+pOWDvLu+S9ZxjsxMeCo
         Dv/IwLlXON0HaqwuF6EQUx24ZHhu/1odWtM8glXL1qgkiWLZj3aX0zjb/6dEitEgXAH1
         vWEg==
X-Gm-Message-State: APjAAAUxl+4312omWr98cqSqlx0TM63yEo7R+dwITRixqEhFp3QJSOxn
        8iXJrXCWsK5BA5fICrqr8XodyG96
X-Google-Smtp-Source: APXvYqzsu94Y/7Mf2116uGBLzpWhNh3Dc5qaXb6ELXpZdOMIWwygsvtjGjuRxDwPfm4QZOq2e8IrMQ==
X-Received: by 2002:a7b:ce12:: with SMTP id m18mr2158944wmc.130.1573533533525;
        Mon, 11 Nov 2019 20:38:53 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v9sm16387950wrs.95.2019.11.11.20.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 20:38:52 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: dsa: Prevent usage of NET_DSA_TAG_8021Q as tagging protocol
Date:   Mon, 11 Nov 2019 20:38:46 -0800
Message-Id: <20191112043846.3585-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible for a switch driver to use NET_DSA_TAG_8021Q as a valid
DSA tagging protocol since it registers itself as such, unfortunately
since there are not xmit or rcv functions provided, the lack of a xmit()
function will lead to a NPD in dsa_slave_xmit() to start with.

net/dsa/tag_8021q.c is only comprised of a set of helper functions at
the moment, but is not a fully autonomous or functional tagging "driver"
(though it could become later on). We do not have any users of
NET_DSA_TAG_8021Q so now is a good time to make sure there are not
issues being encountered by making this file strictly a place holder for
helper functions.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
- keep MODULE_LICENSE
- added Vladimir's Rbt

 net/dsa/Kconfig     | 2 +-
 net/dsa/tag_8021q.c | 9 ---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 29e2bd5cc5af..136612792c08 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -20,7 +20,7 @@ if NET_DSA
 
 # tagging formats
 config NET_DSA_TAG_8021Q
-	tristate "Tag driver for switches using custom 802.1Q VLAN headers"
+	tristate
 	select VLAN_8021Q
 	help
 	  Unlike the other tagging protocols, the 802.1Q config option simply
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 9c1cc2482b68..563501721287 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -342,13 +342,4 @@ struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
 
-static const struct dsa_device_ops dsa_8021q_netdev_ops = {
-	.name		= "8021q",
-	.proto		= DSA_TAG_PROTO_8021Q,
-	.overhead	= VLAN_HLEN,
-};
-
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_8021Q);
-
-module_dsa_tag_driver(dsa_8021q_netdev_ops);
-- 
2.17.1

