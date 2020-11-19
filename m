Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1222B9570
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgKSOpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgKSOps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:45:48 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9070C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:46 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id v20so6492022ljk.8
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=ELX4awErFfgvLz4aqj01JQ13V7Nw55c6s+FfjnTCkcQ=;
        b=Z1j5ijBRVRozaSVarePJTcc4U/AYtgqQgQ2ChUM1/x03g0k9qp+UKP9IuXhpRbE0pI
         XgfpkQPj1PMlug5dfYmg2RJo4BaRo6qJSyEBAaa5+2xC5ldEXrClxq+K94IddiCVtQts
         7Q4ODOCZ+zp8jN9dbxFxZsXw4CQOBaO3hQABWEHpeS4s6D6es7MmkOeDZpufYPoBYP1Q
         HJMFJ/H+UjC5KFKSyZz9Ms3YXKMD8btMW1DuSdKaKvYc+oXAhinRYAIMBf9BPdH+8eoC
         9BF2l3t8EtTRY0iNWEieIOV6RTxstSYjQXEUrzMFQn96dgAEuT1o1puhUGNNYq0uT94j
         AOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=ELX4awErFfgvLz4aqj01JQ13V7Nw55c6s+FfjnTCkcQ=;
        b=R71sMjQuWLkqP3+98s6+0Ch953QNqd11fDmwVXLoB05Pw1Wz7YIAeyIfYDZD5w/y8Y
         QSX7+HP1bYeacmZAhsaagPIJdwL/eJFSuQDKIbAyoV3Wv3t8TRYYX1v1lxZd8hKqRnmL
         eyXad/Exz0a8j5koOi9AG3x1WiHwC6Xj4LnbQlvA0UGB9WSmE4+7O7w7Hwlwep9Ywgu1
         CRGqtJRKiPD6Qsm2NQT4pUyIc6ly6oOJGmPn3iPOfiHBr5AC1UiEpH57dx3LZ7PHLgSY
         ikO9zru53dZsnK4T22JwVgWbvw8kPl7oTMCP6aYu1ejptuhuODN8fHKBivfzzUrJgA9z
         2t5Q==
X-Gm-Message-State: AOAM532Scx+JFftOwMit46pTL52E93P2o/zClW+bPK3CFsoN7CIENAk/
        0BmCUxh6ar34oR5ttLSxRRXVRA==
X-Google-Smtp-Source: ABdhPJyqUKzPcJ9UbCkxUBWhMohrjg7LWya/NG4S4Mvq8TNRro2hAuRqsiMhbaKDpc3qpSPtWUHUbg==
X-Received: by 2002:a05:651c:1105:: with SMTP id d5mr6747709ljo.265.1605797145456;
        Thu, 19 Nov 2020 06:45:45 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 123sm3993483lfe.161.2020.11.19.06.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 06:45:44 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: bonding: Notify ports about their initial state
Date:   Thu, 19 Nov 2020 15:45:05 +0100
Message-Id: <20201119144508.29468-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119144508.29468-1-tobias@waldekranz.com>
References: <20201119144508.29468-1-tobias@waldekranz.com>
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
index 71c9677d135f..80c164198dcf 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1897,6 +1897,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		goto err_unregister;
 	}
 
+	bond_lower_state_changed(new_slave);
+
 	res = bond_sysfs_slave_add(new_slave);
 	if (res) {
 		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);
-- 
2.17.1

