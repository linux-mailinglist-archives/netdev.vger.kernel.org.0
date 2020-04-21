Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F951B2611
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgDUMbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726691AbgDUMbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:31:20 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD860C061A41
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:31:18 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u16so3455066wmc.5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 05:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GI+qMGN/uyW4lRjdZEGvzvxvFL98puDS/upIa5Tkw8I=;
        b=oRgnAARDJJdD43zWPrjChcNH6j4BY5O1iPYWdqBfOuyIP56MPdW7BWQ8S4g+kxecbE
         Di8288tl890sWLHTxgS/saTGoZxROyDsdYjxvfw9Goyam6M/Z/98QStTNod1ZjZX77KA
         O7StRAeq+IA4hfNLHeOgFmGfieS333b1ustVEGrN7TkVyTDTBoNtIcmT0SUO/j5Y7Li9
         PSp/HPbI6dJiybWG8z997rm5n6mv17zeCsiCWmqc+KuaQ8pafPi09+ER5q6vLBns0HkQ
         6Z4Bij6Fa/wRYaJUg0lY7QfAqOXmsv7DOFc4hbM03/RVP+2J1vfmGesTaBFbFYTaoK1t
         5yzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GI+qMGN/uyW4lRjdZEGvzvxvFL98puDS/upIa5Tkw8I=;
        b=QyeLdkdMBDaJeR7Lq8L6r64ymhQpPR2pOu9LnzQqtyg48ULTa4EPK6UnxGO1GItF65
         GEIsZTMermIZ43hu4XxytLCLVveAvZVuG0QfPUvxksrOQlj+5zMdD6doNYoEGWDmOZ9k
         zwxHykX0gYmImcRJ1vBM0fffj05u4C76ee2pbPCXFE1lIaoCsIXXadhvxZtllL63G+im
         cWX73dVa0pLfM0mD1LzpAslJm6QXF1C39z+/eY7cqIeSh3HG3XxnxUuvz0vCLJ9IFOFj
         YmaBfDZa3yLGDPsbpkxITPUOoHv/+nfGi+eReBtPtDB5I4W5A8QxSRCxzPpxdSggC8al
         Ipuw==
X-Gm-Message-State: AGi0PuYTyMDKJG7ug3nNqDe95rqKmWQ7EcTAxRDtBsYHW4J/Rif0MPOy
        dlkpCvIbV+VxvIw1tPxJnwA=
X-Google-Smtp-Source: APiQypLg2xztrVLnL8jdp2SlNr01ytPElbZQKSl0sacCI5D0FRmmJ4c5r9uf0zDa07EAoc4k7DPsgA==
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr5063722wml.189.1587472277508;
        Tue, 21 Apr 2020 05:31:17 -0700 (PDT)
Received: from localhost.localdomain ([188.25.102.96])
        by smtp.gmail.com with ESMTPSA id q8sm3256009wmg.22.2020.04.21.05.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:31:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, o.rempel@pengutronix.de
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/2] net: dsa: be compatible with DSA masters with max_mtu of 1500 or less
Date:   Tue, 21 Apr 2020 15:31:09 +0300
Message-Id: <20200421123110.13733-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421123110.13733-1-olteanv@gmail.com>
References: <20200421123110.13733-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It would be ideal if the DSA switch ports would support an MTU of 1500
bytes by default, same as any other net device. But there are 2 cases of
issues with trying to do that:

- Drivers that are legitimately MTU-challenged and don't support
  anything larger than ETH_DATA_LEN. A very quick search shows that
  sungem.c is one such example - there may be many others.

- Drivers that simply don't populate netdev->max_mtu. In that case, it
  seems that the ether_setup function sets dev->max_mtu to a default
  value of ETH_DATA_LEN. And due to the above cases which really are
  MTU-challenged, we can't really make any guesses.

So for these cases, if the max_mtu of the master net_device is lower
than 1500, use that (minus the tagger overhead) as the max MTU of the
switch ports.

Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e94eb1aac602..3776a6f6d312 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1723,6 +1723,7 @@ int dsa_slave_create(struct dsa_port *port)
 	const char *name = port->name;
 	struct net_device *slave_dev;
 	struct dsa_slave_priv *p;
+	int mtu;
 	int ret;
 
 	if (!ds->num_tx_queues)
@@ -1767,8 +1768,10 @@ int dsa_slave_create(struct dsa_port *port)
 	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
 
+	mtu = min_t(int, master->max_mtu - cpu_dp->tag_ops->overhead,
+		    ETH_DATA_LEN);
 	rtnl_lock();
-	ret = dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN);
+	ret = dsa_slave_change_mtu(slave_dev, mtu);
 	rtnl_unlock();
 	if (ret && ret != -EOPNOTSUPP) {
 		dev_err(ds->dev, "error %d setting MTU on port %d\n",
-- 
2.17.1

