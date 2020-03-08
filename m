Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A0E17D0CA
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 02:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgCHBT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 20:19:28 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43947 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgCHBT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 20:19:28 -0500
Received: by mail-pg1-f193.google.com with SMTP id u12so2995933pgb.10
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 17:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=si/CB5HCncfkTuj3GRMMzOawz8HUJ3HD+35qoVgf7rE=;
        b=BH8wEhZplH/BouL/KrGhkinaQFheojFypgpaa3vXLY8jI7WlRKNhmlqmDehS1viNiD
         hxncjSU4zy/wArlLSVoPd+veuDX5x4Kxfwyve610nz0892PWsAON9YJmWBn7kT58yl0V
         hETnAper/H/+iSZsktyU9ZswpWQ+eMEQVy+oRKVcdFEySLsS2wCi2yo77FY7wA4xBT0A
         HJMQRGaBte8UuJrJhOFtbu2ITMf1kBAgMUS6YjusCyX11MDotiXTwcg8s6nINFKHQgCJ
         gwXtQoOZP3HAFJtf4NEOcWcuCaqItDFV+egnUiO8z8LQBS76nSQLdtHmQrsOOmk1QGTF
         Xyhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=si/CB5HCncfkTuj3GRMMzOawz8HUJ3HD+35qoVgf7rE=;
        b=jCJW4Qoky6OKd0vWuRdarojM0kfs21a2T3H+UvLeJCOYtom1Sq4pUcjFPrgdn6k+uE
         +fOb4BwACJRESe5zh4tpZ5HZUzBdJx82VGKyydYRIcwfsgZH7YnkMylw92D1lys6Ly9/
         BQ+om9T3PZhmasM8CAbGIHIUI7miSW44FTGMf5NnfKV225Ifum38xeuCJodZZN2JpjTn
         GSZoTeR7bTIeTSdM/1/AxdjfY7WFGAENU8DVix5zgzeWpWn0ymf+GypOC75Y9SB1ONfs
         37dOOkcasDKGr18BKkxo31zdODsnMJ+5WQkt++cFffiBKU7L0OaW5Njr/2Q39RHUlhKn
         2OAg==
X-Gm-Message-State: ANhLgQ3Z++soe2njAfuy4vvT/MDJEI583l8KlXW46z9UdPT1kFTwSyFC
        eAGvtCG1NeSarUDyN35UlR0=
X-Google-Smtp-Source: ADFU+vsEC+CVHtIr/TlsDy+7ltfPYV3vGXMVaz9En2iXizDFfEYiYLbEIKFpJ/Yj1mpPzd38VdE3iQ==
X-Received: by 2002:a62:d408:: with SMTP id a8mr10258396pfh.99.1583630366982;
        Sat, 07 Mar 2020 17:19:26 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id y197sm25489286pfg.49.2020.03.07.17.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 17:19:26 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        martinvarghesenokia@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 2/3] bareudp: print error message when command fails
Date:   Sun,  8 Mar 2020 01:19:17 +0000
Message-Id: <20200308011917.6844-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When bareudp netlink command fails, it doesn't print any error message.
So, users couldn't know the exact reason.
In order to tell the exact reason to the user, the extack error message
is used in this patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bareudp.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index b1210b516137..c9d0d68467f7 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -556,10 +556,17 @@ static int bareudp_validate(struct nlattr *tb[], struct nlattr *data[],
 	return 0;
 }
 
-static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf)
+static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
+			struct netlink_ext_ack *extack)
 {
-	if (!data[IFLA_BAREUDP_PORT] || !data[IFLA_BAREUDP_ETHERTYPE])
+	if (!data[IFLA_BAREUDP_PORT]) {
+		NL_SET_ERR_MSG(extack, "port not specified");
 		return -EINVAL;
+	}
+	if (!data[IFLA_BAREUDP_ETHERTYPE]) {
+		NL_SET_ERR_MSG(extack, "ethertype not specified");
+		return -EINVAL;
+	}
 
 	if (data[IFLA_BAREUDP_PORT])
 		conf->port =  nla_get_u16(data[IFLA_BAREUDP_PORT]);
@@ -635,7 +642,7 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 	struct bareudp_conf conf;
 	int err;
 
-	err = bareudp2info(data, &conf);
+	err = bareudp2info(data, &conf, extack);
 	if (err)
 		return err;
 
-- 
2.17.1

