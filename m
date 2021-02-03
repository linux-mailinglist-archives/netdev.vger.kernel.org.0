Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9630330DF42
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhBCQJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234876AbhBCQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:09:24 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FA1C0613D6
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 08:08:42 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f14so12383460ejc.8
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 08:08:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ybgqix3kyeUq3RKDuuhyNef4XyLVRGqFwbLZYyCLiY=;
        b=JTIr3SLF0R2cjTNmsAOW8bJFEPf1Onk8+6Vw8yU8nHBMlkn/9w54hx9zI7/iRW+0Jn
         vKybe+3j9SFvHjEaDh8KZxU8zz7ySWa7QqvMrHM6oAu9eNRx74HJTbYqfr0W6x5gfu0u
         bMZyX60WcoEWZJx9rC/XPD6BZfqjK82NXkIF+n+Fbd9Eqr1qz7Bdvtlq3lyLknU+m2eG
         eWNJoL22g48NAYjfLkOjdNLwfbSwgbmjrYUZU+7guawkwzcnE/CHSHSsaSIiPrim55yc
         eMmG9wJ9e9iBmPVKQpFNc0yVzVq1YfX7oWn2umG5Z+7No7LPu7whX8bSMw/i5a+M9f9e
         1swA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ybgqix3kyeUq3RKDuuhyNef4XyLVRGqFwbLZYyCLiY=;
        b=OC39t8GQC99Nnqk5wt5wVdTD0HZUBogfYwjZJ/c3zkA94wwAqg9MU3cR4EfGxuL/52
         CSMpicJIeeI1m3VAB+oR/Qq+Bq3KEHEoUmIJnNloO54OJE4oDVM6SpfNbAo/jxk8SEeh
         +WzPG3U+O7thw/jpYslErkoeFHQ+41kdqFm4DF/wb0BCmPh4381qm3wY+SqlornzOvRY
         2FaqdODck1K1XocLEoV9fncip3bfCzQX6rKU57F7a33l9Cv3T5wti1ILropxUEcKY8YQ
         6naldi2ceIFYhmeml/HCcuiC2Zqeyv1fo2zOf8t8PFDCAMi51qAj1bsx1dWJmeKcZNxj
         wSug==
X-Gm-Message-State: AOAM533s8Jn7gb6ropb/Um7vKlAobgnyZw6zkj2FTO0sOoKuM17hS5QV
        g8N3gN4GrOqbQtw5WzJjaxE=
X-Google-Smtp-Source: ABdhPJwwZyfWGdwaiF5fmJ0Fga2tl7ZLYKPYuMKw8+gIGWmPfvVCgE6imDX0k0/pTXqJ5n4nvkPXXw==
X-Received: by 2002:a17:906:4442:: with SMTP id i2mr3961838ejp.41.1612368521199;
        Wed, 03 Feb 2021 08:08:41 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u16sm1085589eds.71.2021.02.03.08.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 08:08:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH v2 net-next 1/4] net: dsa: automatically bring up DSA master when opening user port
Date:   Wed,  3 Feb 2021 18:08:20 +0200
Message-Id: <20210203160823.2163194-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203160823.2163194-1-olteanv@gmail.com>
References: <20210203160823.2163194-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA wants the master interface to be open before the user port is due to
historical reasons. The promiscuity of interfaces that are down used to
have issues, as referenced Lennert Buytenhek in commit df02c6ff2e39
("dsa: fix master interface allmulti/promisc handling").

The bugfix mentioned there, commit b6c40d68ff64 ("net: only invoke
dev->change_rx_flags when device is UP"), was basically a "don't do
that" approach to working around the promiscuity while down issue.

Further work done by Vlad Yasevich in commit d2615bf45069 ("net: core:
Always propagate flag changes to interfaces") has resolved the
underlying issue, and it is strictly up to the DSA and 8021q drivers
now, it is no longer mandated by the networking core that the master
interface must be up when changing its promiscuity.

From DSA's point of view, deciding to error out in dsa_slave_open
because the master isn't up is (a) a bad user experience and (b) missing
the forest for the trees. Even if there still was an issue with
promiscuity while down, DSA could still do this and avoid it: open the
DSA master manually, then do whatever. Voila, the DSA master is now up,
no need to error out.

Doing it this way has the additional benefit that user space can now
remove DSA-specific workarounds, like systemd-networkd with BindCarrier:
https://github.com/systemd/systemd/issues/7478

And we can finally remove one of the 2 bullets in the "Common pitfalls
using DSA setups" chapter.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 Documentation/networking/dsa/dsa.rst |  4 ----
 net/dsa/slave.c                      | 10 ++++++++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index a8d15dd2b42b..e9517af5fe02 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -273,10 +273,6 @@ will not make us go through the switch tagging protocol transmit function, so
 the Ethernet switch on the other end, expecting a tag will typically drop this
 frame.
 
-Slave network devices check that the master network device is UP before allowing
-you to administratively bring UP these slave network devices. A common
-configuration mistake is forgetting to bring UP the master network device first.
-
 Interactions with other subsystems
 ==================================
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b0571ab4e5a7..4616bd7c8684 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -68,8 +68,14 @@ static int dsa_slave_open(struct net_device *dev)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
-	if (!(master->flags & IFF_UP))
-		return -ENETDOWN;
+	if (!(master->flags & IFF_UP)) {
+		err = dev_change_flags(master, master->flags | IFF_UP, NULL);
+		if (err < 0) {
+			netdev_err(dev, "failed to open master %s\n",
+				   master->name);
+			goto out;
+		}
+	}
 
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr)) {
 		err = dev_uc_add(master, dev->dev_addr);
-- 
2.25.1

