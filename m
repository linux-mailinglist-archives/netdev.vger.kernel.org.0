Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29E52CB856
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388085AbgLBJPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388006AbgLBJPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:15:09 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DB8C0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 01:14:28 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id s27so3188663lfp.5
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 01:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=fN23nySHxvx1JCV57DAOBvz5Flb+CbadWho63myTLyM=;
        b=g8ULbBsjeUfptShHHO6Mh8kjk88p3k+NrPjUb/hsLkCBZdcCmxmcA12B9Z9fsH+lLt
         kRgt3JPfATfVh0b2JwzRfetD0AdzHtr+Yu4BOAC1QolJQC2f6n4kI8a033bCISo8+95Q
         OYN41Hd7IcrzwcPgBNUVjmP/FpfMv4tFcfrHhjjW67IfFhoZsLPnJSWVIsLDuIbp4HDc
         o+76uFOSyRYHMMuqJCV93uknGGBDcncxlaRghfsgYSdsZEuM26zQicgLB6VL4H93zhSm
         xLqLc/pjvLjabtr+Awdb+wZMZngF6oKx9tcuR4JleHsqEhWnFJCyhO+0K7I2BleTQwDj
         KV8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=fN23nySHxvx1JCV57DAOBvz5Flb+CbadWho63myTLyM=;
        b=S4onVWadAqgMY8M4sX5gMvapdrU+nOjIQZwuqI/nlLvKaQQhHrIQqhRkKV17NF1tMW
         YPCJ/fO2CGP5Iy8oRbaOzWnTz973HE8DiQ4p9lJ7YWzcb9oKXx6f20zLl4V4H2pA8MJH
         gLMnkICBaY/f2uKVys7A6KQoZBs8eNjGAxCSinopJHUtBhN6ErEBoVpapx8JZmEaYNnt
         WskM8X4zLiKI4CJpsgV3n+8HQeH5aCFNITSs8Wik4LhWlkIwdfv72dXTsX3ra81INJJa
         QnTPfwBDoldcKqqgL8gjJM0EaxdsRKhOYqwcqJBV6HTng0Fyz28fjk994RkbH3mLRDm0
         sWeA==
X-Gm-Message-State: AOAM531kkbH8kkPUXhpJyevcchN0h0bxMHquG3v/1o6O1HbXXAF4AE2Q
        bkSggHaJurwZvg0r/kHZ/q2R6g==
X-Google-Smtp-Source: ABdhPJy2EXUEyXIJm+NjgXbafkjEM1ezKTDscfFWNtkea35LNgSE7NdBVuaECOmj0c3HoVd7YuPwzw==
X-Received: by 2002:ac2:4acd:: with SMTP id m13mr816723lfp.69.1606900467168;
        Wed, 02 Dec 2020 01:14:27 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v1sm295970lfg.252.2020.12.02.01.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 01:14:26 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 1/4] net: bonding: Notify ports about their initial state
Date:   Wed,  2 Dec 2020 10:13:53 +0100
Message-Id: <20201202091356.24075-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202091356.24075-1-tobias@waldekranz.com>
References: <20201202091356.24075-1-tobias@waldekranz.com>
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

