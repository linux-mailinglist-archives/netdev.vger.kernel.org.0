Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA66CFBAD
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfJHN4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 09:56:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33244 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJHN4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 09:56:38 -0400
Received: by mail-pg1-f196.google.com with SMTP id i76so3130944pgc.0
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 06:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fkFt6GAO/C3Itm9ELYYj+/vdhJb7a/vl0pJU6vDBgLk=;
        b=R1th6dS25UnVHBai0JXu55aTGiky+Khl9QA5BODHlsWc1QrHbhh9yhvTmZ07fH5OP1
         MVOjgqLegCmRXf9N3uTrYYhefA8R2FmcJ3qQtortRHqHDKWuaS/K6ZNu/gKnjkRs6aOC
         9MqJb3nF+3NsrfkJvV0Y/w6SfAx6RQPzhP/FICuU/JsbNxX6FfBOXpe1FvsmEwEkRV04
         +qSa5vCK8JaPK2Bi1HjCHvgGnsClRH+Z19iqoxgZdhLm3Vnn2tNAXcXLskF3ykdiQHzv
         DlvyvalMJ28A8dp+AfcqNkcnGT1BALyroZi8z/kVyO2eUtlpBDpih2/WxP0pRPoiVbMe
         Uudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fkFt6GAO/C3Itm9ELYYj+/vdhJb7a/vl0pJU6vDBgLk=;
        b=t8e6Cb5ND3Lj7gSYXNhXq9jT0cmNFynKv8N5egrzsN1WqK652WR0oFK/3JAxJTIJyN
         6joLcDwgI1vvSsDE+7pnm7P5eV9c2detlpQrQiGf7xivCa1W4ZRQAY/haPA69/vigBR7
         jIWGdUFNnCOJnWqpNCYGi/emJ4Te44UQkC96ukIeRMHv+Bg2iq7ys9QDdYBRbno97QoM
         OPN/UqDZ98Rv2WUhWFhtUOo38aq0mMhW/pVi+fYNnOedaK/NOGf7XjPGJyY9U8OI31QN
         tTmuMez4yq+oRdUr4JzKKRdGbMqmvJIpyX+obexA/d4xF4uMrSwq2gAwOWX44qT5UZoD
         SUxw==
X-Gm-Message-State: APjAAAW6pkDKcdql9UuFVSHarNG6Q1ZbruTBqXwsq3Os3qOL/V1+rCzh
        DUQHpNb+VOneuJXg4rROpOz5ZFgpJjE=
X-Google-Smtp-Source: APXvYqyp4WejFK/d+hr1RlVn7uPZtMq4UOj0FDBFoB8mspTOjVsDA7w0bJWO7/Bs0ZVHF9X7ZLWj/g==
X-Received: by 2002:a63:205d:: with SMTP id r29mr787451pgm.211.1570542997095;
        Tue, 08 Oct 2019 06:56:37 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f89sm2145961pje.20.2019.10.08.06.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 06:56:36 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] team: call RCU read lock when walking the port_list
Date:   Tue,  8 Oct 2019 21:56:14 +0800
Message-Id: <20191008135614.15224-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before reading the team port list, we need to acquire the RCU read lock.
Also change list_for_each_entry() to list_for_each_entry_rcu().

Fixes: 9ed68ca0d90b ("team: add ethtool get_link_ksettings")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
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

