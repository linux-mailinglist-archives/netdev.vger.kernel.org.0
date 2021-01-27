Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BEA3053DA
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbhA0HBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S316920AbhA0BBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 20:01:25 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C30DC061574
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:44 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id j13so359718edp.2
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 17:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rmce2OFbDqlp87QXq6O7QiMgUnESbP7sSv496Tlc0gQ=;
        b=FKRw3VFxDnFOSL/phKvdo8U78UhOKgcjvLObDYoB7JigP4D1xOCcE5TUZgZ/b3pgGF
         wu2+4SMN4RUliU9KKGPtk47ADeETDtIdp35KJIJLHTpM4G1NF7rcrgwHF3ZyfXJczFyO
         qPKYGOU7OEOmgrNINV4emWJ8gQHDjPFi0M2h6kpyTkuABp97b5chsTha4fK9Ciap9+0q
         B3zc3P/HlVDoR1Be3OYL9gzoYA0H9olH4r5rb9XOgXfH4C5sddWJiQKwXu0LNuAQl+ri
         cFKe/y03pZGlgImDz+10n6TcvbPX6LkyDeYHz20or4LN/TClQn6dSt3lbT2VtE9Fhled
         nYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rmce2OFbDqlp87QXq6O7QiMgUnESbP7sSv496Tlc0gQ=;
        b=bnXX3TLEymLOKepm3NRy8uOjDCFUTCngIz4/R6OoFqC1gIDyFY59bgjKysncPjFSAG
         fz1twc15UvPRxW1H7qyrDGNXbF3xpiX4ujLwAxZDqyLluCHVZPdy2kouPJyHi9Rvq2v/
         FheZpQEsY5ogDCGgnAmER5itAg/Nc5Nw2BbMEFgKTc7uFevVJO6oh8a3eGrlmk4Lc+Bb
         q7Pojo7GLDmmjTdcuCqNho2UaMQ2+tWyWWR1YzS+1zGpEJ3e0Vw1I3R+o9LVWKwQhSvw
         uZ6zMZPfxfdlB/9jiTSHvNzdfMiCf+sfy2/jAbb8i5tprQ6Ql9aDUJDmUdZnRThVH+5C
         Neaw==
X-Gm-Message-State: AOAM533LWFwrbwKSySX9/Qj2hkdaQyUMo6zx2XRhjbWF0s0G0/phmVL6
        emGiJ4ZNfTiFpjc0CG1Q0gU=
X-Google-Smtp-Source: ABdhPJyjuKBURfjmRGLxOuo2FZt2mPZsrLUzymLIqrJwwW1W4jIibl0CEjREP3TqYrIDhpPsGQpiXA==
X-Received: by 2002:a05:6402:1819:: with SMTP id g25mr6351115edy.46.1611709243092;
        Tue, 26 Jan 2021 17:00:43 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id ko23sm115897ejc.35.2021.01.26.17.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 17:00:42 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next 1/4] net: dsa: automatically bring up DSA master when opening user port
Date:   Wed, 27 Jan 2021 03:00:25 +0200
Message-Id: <20210127010028.1619443-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210127010028.1619443-1-olteanv@gmail.com>
References: <20210127010028.1619443-1-olteanv@gmail.com>
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
---
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
index f2fb433f3828..393294a53834 100644
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

