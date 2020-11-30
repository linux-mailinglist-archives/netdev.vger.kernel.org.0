Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41A92C862D
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgK3OHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3OHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:07:07 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D54C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:27 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id r24so21842682lfm.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=fN23nySHxvx1JCV57DAOBvz5Flb+CbadWho63myTLyM=;
        b=KHHMaCTKo3Zk5yOfqOa2Kv7qht7edXTyXQ3M5/yiyAxsY3S797gHH4XHeFr/k84mWE
         77Zt67UpvBi0OR0ovgSPY6/RuDK2IdyTHcasF3qIiSfk3ro8qSlVh7hwsKYzg7d+M+CQ
         EdL//7ZadAwxWPqzT+f0ICKaeQAU4duymXHSIsdu8xBeCFCWTKAezBRxu4NQcgE3giry
         8BidVHt6t8t3bIcM3qLW+9fYYoFWpaxPhb/udNU0rpoGAVx40Zyecs8TLTSCzhkMN/M/
         xT3zNnjKFE7nnr7IqvmQLCjCGSXjn5bO/BJy7D5cDi9D+1OS1y6EZbD4Eqc1Ky56mb7/
         Rv0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=fN23nySHxvx1JCV57DAOBvz5Flb+CbadWho63myTLyM=;
        b=f2rUl+Z5EGQTMmw6hXdi8oicTao7/9Gib5A8c/eqixueNaaNF+DuKgnEVM2yUSWNgK
         9qoMge7Y7GW0bvgiUGxdfSuCH6NEJs/1ugDWbErLDSmea+T5h6CLYcR+7+nNp0QyUHfx
         vnTj418630w0Wmq80r/7RSn99mvNYX9i7HKc+OHWy1QyuA3nyHuHOGtsYmD4ZleFHfl4
         8lc/DrzvyR6occ+r1osHjdsExzapsAcqHgbjaNgEQBSzKeD4QkYLN4WJfbb4JtPSMF0N
         Tyu8zXWSvxiCUOLtKIkjzy/+5DGYkJbJjrMWcWkC4+RpU1LtGmCTbJ7zwLxeKK0Bbklt
         nUgg==
X-Gm-Message-State: AOAM533R5gatyhxi6PGDUeC6UfoqG1AQsMbKfEHgpyD+QY7MTX0nrqjJ
        PYYXvHjCHkedpDw8lhpAdX/xbQ==
X-Google-Smtp-Source: ABdhPJyas4ExXggMOXRJ1ptEuPh2w4CW5We6+ezvDQTLn88KxUP38/bncG/mGE8/6vPJZ7sgQnznPw==
X-Received: by 2002:a19:5f11:: with SMTP id t17mr8846788lfb.572.1606745184627;
        Mon, 30 Nov 2020 06:06:24 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v22sm2977292ljd.9.2020.11.30.06.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 06:06:24 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 1/4] net: bonding: Notify ports about their initial state
Date:   Mon, 30 Nov 2020 15:06:07 +0100
Message-Id: <20201130140610.4018-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130140610.4018-1-tobias@waldekranz.com>
References: <20201130140610.4018-1-tobias@waldekranz.com>
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
---
 drivers/net/bonding/bond_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index e0880a3840d7..d6e1f9cf28d5 100644
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

