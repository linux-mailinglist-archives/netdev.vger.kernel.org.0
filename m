Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED7E2DC3AA
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgLPQC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:02:28 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E653C0617A7
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:48 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o13so26432656lfr.3
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=4Nnto5h6ViHFh1w5xiIju4CgEt90/FHtiBfoJMG8QM8=;
        b=qL3014+aJsw7Zkcald145/2Em6jbAKNL7/LhSmS05YQjGuxn1DYTk7VpLXGsoYoJ9D
         CmhuMlr/sJgeaPdPpFiWMdmx7KCqcKjs6mmyfWaXTG4wJmscPlYYR1+j7AqhG5yf9wVi
         KJqqd2MFu8yT1XcGBWkc/F5ck/2OwqKh9VyD8t0Eoq+jcU1bHOqGNrTYNOC2jjesbLRh
         kcEIhUHFOmZEzZpKAQk7IvYX6LG9lbbk+cymML1ZO3VsozlSrqEW5AC5NmLwxvpzgRIH
         1atAwa2ywZ7g6NFlugNLUeMuT8NPOt0Ys7wRksSMAOXETu70QKQ3VeMgOXk3zRdvWWJ7
         Xpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=4Nnto5h6ViHFh1w5xiIju4CgEt90/FHtiBfoJMG8QM8=;
        b=uSmSfUKqNh5wbGQmwSoCpaGybVVXPuSTtOrZkJc+T97U2yiK8ZI93iN0Rx9SMDqmVn
         6SqbWTkf9rNBx7XGs7OcBMoY/Cm//JWDgUYs1QUL/fZOWQpULwb44sQtEjerJc1cDqdh
         7SCFt1GVCS08BG7lOvtjN0HnDf8Vm2w5hWn9jRAgM+2pAWDA3k2R38wt0peUrYmBOn1D
         CjixB68yWwZpXWWGzxg7afQA190MJfJ63tF2z3J/InuP0f+Fta9ukdip+Lt53J77Mcjk
         mTy3megsS7eq5wuIZaCRneG6L7CKuEhmUyk0zyu29QILlp2FtQTlfZCnlEW2WnPEObOg
         N5/g==
X-Gm-Message-State: AOAM53151aQxiDl0ewa8lgvgMPoUWxmEIH8ClVC8W9JM2PSyNNmal7UF
        ZfgXBf47NuMxD6Y0SFFYhMcenQ==
X-Google-Smtp-Source: ABdhPJxbPA+HNAWz48kojDTXV0zDVwJLTIfPFzYRjdv096Rnx7G1DplZ1tDb5UVrMLVVF0/X80V4gQ==
X-Received: by 2002:a19:4008:: with SMTP id n8mr13258166lfa.660.1608134505462;
        Wed, 16 Dec 2020 08:01:45 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e25sm275877lfc.40.2020.12.16.08.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:01:44 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 1/5] net: bonding: Notify ports about their initial state
Date:   Wed, 16 Dec 2020 17:00:52 +0100
Message-Id: <20201216160056.27526-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216160056.27526-1-tobias@waldekranz.com>
References: <20201216160056.27526-1-tobias@waldekranz.com>
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

