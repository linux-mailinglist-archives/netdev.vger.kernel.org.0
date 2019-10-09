Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C59D0E8C
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbfJIMSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:18:50 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44213 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729854AbfJIMSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:18:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id q15so963792pll.11
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 05:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uSLeu40xqmJNywXPmLMqpWmJXX9/505/giNLedaEP+k=;
        b=YH3o1sG+TLC0JFyhUczbB5XBGQduzrhWwctldERYBcwSY4P1EMHTpAdwb8zBM2eAlt
         0rRdmrnaZ3vUhk4cJySbC/fRRwVoiHrdAhV9MVglhSiIbcuHLXlYAqhVKr6McD8n/HUX
         6ZYCSWL5AI+LjZOUl3UapIBqdXRormhTZhPrjaIjAxGqglLqeE2Q0QJiyXTZnevbv/p7
         QjXL0p1NTQRfyi/E5r9cA7D4llJF5QxmJ2HS2M4oWm45o5mDta/t6bgdVm3ynr9XO1+8
         w1Kkl7n/qysndSUQStHdVnHSkMBbo5coWGZzPWdlBGKkl27EF591xHezTdDdzfhbIRGu
         Z59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uSLeu40xqmJNywXPmLMqpWmJXX9/505/giNLedaEP+k=;
        b=KO1xBZBiYJOVdgDVL7lWylNRm1HiIyou/wW+nQWA68sq0fnmtpkVXC72YFDELG8cPP
         BQTAg6izQVDBtIiK/km2iPDexHx0YgNd33aoRPp9kWHSjHGSbmfQbnld4YNb9aBMYj1N
         lUt77EDb4gEppKLC5xZ94jU1rUz1C8IoEzR/vyt+gRw7rxrGBz+rq8Xo1JlLeYxMvUUd
         MEXUDQ3N85YxShgjJ3/qcTXlxyf5vIPl7lKXDFgvj7XQUNiz7Bqj+hm9rNWVx4HL8GRp
         oQWXdVJ4lnplNRw8+JD7fLTB0XZOSfpydijDYA72mv1c+2o5OuLJ46mJn5CZ+eEQoGUN
         JgDg==
X-Gm-Message-State: APjAAAXXdj3MYsQzeT0paNaBEIYdmurFOsbY2TXmuLKbeSVX7qdW46SP
        jmc5RwNdjC+t1+739e4EWSJm+1lhbTw=
X-Google-Smtp-Source: APXvYqynyxDZyyWqiERxfLRERuIDuVmqJCVUxenMrYLyNVPsVVHIC8bEAhumHOZDUyvOSK6HeinUEA==
X-Received: by 2002:a17:902:7891:: with SMTP id q17mr2742158pll.289.1570623527808;
        Wed, 09 Oct 2019 05:18:47 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v13sm2121458pgo.79.2019.10.09.05.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 05:18:46 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        davem@davemloft.net, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net-next] team: call RCU read lock when walking the port_list
Date:   Wed,  9 Oct 2019 20:18:28 +0800
Message-Id: <20191009121828.25868-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191008135614.15224-1-liuhangbin@gmail.com>
References: <20191008135614.15224-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before reading the team port list, we need to acquire the RCU read lock.
Also change list_for_each_entry() to list_for_each_entry_rcu().

v2:
repost the patch to net-next and remove fixes flag as this is a cosmetic
change.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/team/team.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index e8089def5a46..cb1d5fe60c31 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2066,7 +2066,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
 	cmd->base.duplex = DUPLEX_UNKNOWN;
 	cmd->base.port = PORT_OTHER;
 
-	list_for_each_entry(port, &team->port_list, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(port, &team->port_list, list) {
 		if (team_port_txable(port)) {
 			if (port->state.speed != SPEED_UNKNOWN)
 				speed += port->state.speed;
@@ -2075,6 +2076,8 @@ static int team_ethtool_get_link_ksettings(struct net_device *dev,
 				cmd->base.duplex = port->state.duplex;
 		}
 	}
+	rcu_read_unlock();
+
 	cmd->base.speed = speed ? : SPEED_UNKNOWN;
 
 	return 0;
-- 
2.19.2

