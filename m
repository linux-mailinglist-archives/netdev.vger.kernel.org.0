Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A22D4DA64B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352598AbiCOXb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352594AbiCOXb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:31:56 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8615DA57
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:30:42 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bu29so1137081lfb.0
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 16:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=NyNPoKbL808w7OY7R26NhmVWgd4nJ+fEBE5S54TvM4Y=;
        b=ClQlVsiqHu9L/Ayp4tl1EoPkxMAILRksImAfnZhFb3C/UfNi1t+Lgs4u0kzumA+VAO
         xQ7g9CR/oFB1BeDNpg2mv5WdmhruMNsJ4V1qxZzlOySPl9mILwqRVkoXLByH+aZb8cPl
         80/V3j5N3OhRDGYzJUqc/z1lUCn0J/uIo3mvf0pbm3SQjcMYqbQGYU5dyuFINidOGZvt
         fcyL0/oXA54vp1qo61GWECXyFFXNqbyTAPKoumMU2Q/tEQOrZl0g2I42DvYKfs28iwuQ
         6DeUaCtZvW7nZ8R6jzInhvBRdw40uU2rJH++zEp/GfX3I3N3OAiuvJEyxfdOpNWoSOKK
         p+Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=NyNPoKbL808w7OY7R26NhmVWgd4nJ+fEBE5S54TvM4Y=;
        b=MtEWKQf+7RZ8ihO5sKwhNfz/xG/6R7WdpmutLfwqt+o65AQfZROhAib1RiM60ysIsL
         6o+fp0uIFUHFv4tv3OXgKMet5M15+HRFyATOrFDuvXSSS6uZdeGYN334pZAFvGkivco/
         Mscr7DeOcGSGZcMp7IsvOyqz1Cu5nT1SnvbtX81OQWizF58QH6nIuOBe52dHUy6bPxTt
         sBP7dURYmOece1/d6yZ4oMIXO4DZirP6fnxFr8/zMed/dTjy/rPyUMMpfPEypy5AZgZf
         JWK22epjJR0+CONQzukH91q3iNnpsYSRg4k6fReSXqXoWVHepei4+GvzDX0oJmxG/WA6
         XH+w==
X-Gm-Message-State: AOAM532epz/62La9p95C1zbDui5aOh5pIYnrfnN215F2br/x8/BjJgOz
        E45i3bE7UcWDGtN4g1ezPLM4kQ==
X-Google-Smtp-Source: ABdhPJyc+AwfeDN6S+N36JN+QR1+D+RvkhYlnaRVzApgQ8yTVkgbC1T5pBA4MC4ppM2MzsE8BRJNpA==
X-Received: by 2002:a05:6512:3741:b0:443:d5c1:404b with SMTP id a1-20020a056512374100b00443d5c1404bmr17561653lfs.565.1647387040798;
        Tue, 15 Mar 2022 16:30:40 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 10-20020a2e080a000000b00247f82bbc6fsm35312lji.54.2022.03.15.16.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 16:30:40 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: dsa: Never offload FDB entries on standalone ports
Date:   Wed, 16 Mar 2022 00:30:33 +0100
Message-Id: <20220315233033.1468071-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a port joins a bridge that it can't offload, it will fallback to
standalone mode and software bridging. In this case, we never want to
offload any FDB entries to hardware either.

Previously, for host addresses, we would eventually end up in
dsa_port_bridge_host_fdb_add, which would unconditionally dereference
dp->bridge and cause a segfault.

Fixes: c26933639b54 ("net: dsa: request drivers to perform FDB isolation")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f9cecda791d5..d24b6bf845c1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2847,6 +2847,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (ctx && ctx != dp)
 		return 0;
 
+	if (!dp->bridge)
+		return 0;
+
 	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
 		if (dsa_port_offloads_bridge_port(dp, orig_dev))
 			return 0;
-- 
2.25.1

