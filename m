Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120642F46C3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 09:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbhAMIo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 03:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbhAMIoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 03:44:25 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E981C06179F
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:45 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id o19so1596407lfo.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 00:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=jYsYUPMJW5/QalGVIYLB0FRD4cRJBAZJQQHBbr95zms=;
        b=MD3Wdf7NBqdKe+hmJ8MV5yitglBnZKccSdp1r6uiE3H/Ojy/bKynxhQiGM2AOioD3w
         usdi6Mbyq5VBpLTuzrCzKO929wPJPnBazKWMWg1/XsfBWpPFb0PZ7Aeo39ENJ6AGzjhV
         bcTwiKiqjy34yZr19yeucZ9Ihcw/HjVJBUyzyjLZhrzflKFXMRkdDwyf8FHKVBsAY+ub
         grvLPfxZjLN1BOcaDfJyurCzSbYQJroUEKbiIs/f+XhiNQMTuTnFZlEeHSRgX3rWd0gZ
         xE+LrRfUaFHDLcU9cHx8YrwsRviZIqBKuUm3zmVtozICblYybxz+avk03O7GRh2QqV3z
         PLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=jYsYUPMJW5/QalGVIYLB0FRD4cRJBAZJQQHBbr95zms=;
        b=Desp1rvosh5gBXBx4TOAxsZRIYMSJjtQjgDb2WIEl13GQ2j/E4YdUwg5AfRpYBQjlI
         F3AR6BQUO/qj/5uvRzCeJ4Qz48YTQeqKhD33IhZXRJrU8CPF+NlLRzWdfywz00ye30XN
         XX9EVzgJuXP7XUNCMchkLXRcSsQQRtDdaqk/YU2Sbb8ONGxPkCzWdZfy7hDZH4HbYoxg
         krMh2xQB63e/O7+21ErWY6GaB05ZgL4NUAKaaP+3vmaCx7unmw99FuQwt9W/wo9ZhqXx
         jxgcsBlsSsYk7espzcZq1rKj3SM1kkro5nYrANhX6fAOcigdmEoopWVTIzfSOkyVR9iD
         ydEA==
X-Gm-Message-State: AOAM531JVOnLuCgI2WDZLbkeDNtvVepYCBr1XKSO1l5kbs7x/uuW4hO7
        O2dP+jxPcsiZ68/XeGQEZRXztw==
X-Google-Smtp-Source: ABdhPJyz0H/jImmCQQ2QK/22BgqhL04dnBlZLHeUr6xQPja/kkcNCm6zC2TDh/nLt2wczV9xO3w/mw==
X-Received: by 2002:a05:6512:314c:: with SMTP id s12mr432889lfi.100.1610527422298;
        Wed, 13 Jan 2021 00:43:42 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u14sm137027lfk.108.2021.01.13.00.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 00:43:41 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v5 net-next 1/5] net: bonding: Notify ports about their initial state
Date:   Wed, 13 Jan 2021 09:42:51 +0100
Message-Id: <20210113084255.22675-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113084255.22675-1-tobias@waldekranz.com>
References: <20210113084255.22675-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When creating a static bond (e.g. balance-xor), all ports will always
be enabled. This is set, and the corresponding notification is sent
out, before the port is linked to the bond upper.

In the offloaded case, this ordering is hard to deal with.

The lower will first see a notification that it can not associate with
any bond. Then the bond is joined. After that point no more
notifications are sent, so all ports remain disabled.

This change simply sends an extra notification once the port has been
linked to the upper to synchronize the initial state.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5fe5232cc3f3..ad5192ee1845 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1922,6 +1922,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		goto err_unregister;
 	}
 
+	bond_lower_state_changed(new_slave);
+
 	res = bond_sysfs_slave_add(new_slave);
 	if (res) {
 		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);
-- 
2.17.1

