Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0962619462
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiKDKXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiKDKXf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:23:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170766162
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:23:34 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id y69so6908710ede.5
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcGcAtlq/o7IzGPxNxAFXmEIy7PcM1PZTpjalkDoN3w=;
        b=UzkLe3VMw/Yh6Pup3fSziOoVD7+PpwAbJO4FxbwB5k4313mkhk3PDlpVKGsk9DjyDT
         DNGQSJVV0RLeciwiybP8Tw9VPYfRSU6RRoGQyaN0alraPF7eizDdMDJlNFa1sc0JZWIA
         IE1hr4yjJ9LgR+TR1UeuT5bCPTSBpBetqz+9ty+13kLgq94yk7vrYKmv7OXvHEz6SlGK
         xwCB5DDiB1+4O+0Gp31GCRwWwRIuOi2eAW+7UKAg9CvuKaPTF3Dpc+U0724zVUrA+5k5
         fFPt3k2Re2MQdRoIJDk76eQps1bGMm6qua1pf/A5ftg+sl2D7NMf4E93KtWUHm3b1YFH
         Qk4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcGcAtlq/o7IzGPxNxAFXmEIy7PcM1PZTpjalkDoN3w=;
        b=hpyVo81vy+NEFyz7mAf27ST3dXFe7aKL8RsoTjSJItyUIuVh8fWnQ0ZlUZgUGGGExj
         9HlIIwy3onrNTxDs+G5F/QhoB1A7kv77Fkekdw5ylGLVNFUq6uxI9stuKLwMjUyIwKlr
         y7JVLeWi5lY+nAPbcv1/vr3rS6VnLqjrOruh7p8fRpiG9d6LCNAxJa4wsfc39UedM5hP
         gQEQxyVtupR6c/1CjRarfdI+aJI6iCO83g8yxJCdAm+uer9yaWU7o/R7Eygu7OojSze3
         hia1pKEZHmwLin9gT1/wS4Cg/yAKhSZ3KnPusG7LiY4SblzHQsLy/92zl0whZav8qH71
         EwPg==
X-Gm-Message-State: ACrzQf1vILBsgrl5ZpDAOaLfWneL55PK2zCis+xR4OPgRUxXBxKYFfaP
        4PgvhZ6U20oC5h7e+n8HW4KMCR9wOovM1QQI
X-Google-Smtp-Source: AMsMyM7RcRdPiB3iXM/j9/JD7XKn4L5ZJJJ75At2XO4yqR81u1uja4lGN4VxgJlMTjpTxs4GYEX1oQ==
X-Received: by 2002:aa7:cd61:0:b0:461:de5e:ba3b with SMTP id ca1-20020aa7cd61000000b00461de5eba3bmr33935776edb.74.1667557412618;
        Fri, 04 Nov 2022 03:23:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id lr27-20020a170906fb9b00b007a6c25819f1sm1623229ejb.145.2022.11.04.03.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 03:23:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, aeedm@nvidia.com
Subject: [patch iproute2-next 2/3] devlink: add ifname_map_add/del() helpers
Date:   Fri,  4 Nov 2022 11:23:26 +0100
Message-Id: <20221104102327.770260-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221104102327.770260-1-jiri@resnulli.us>
References: <20221104102327.770260-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Add couple of helpers to alloc/free of map object alongside with list
addition/removal.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 680936f891cf..6e8e03aa14b7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -774,16 +774,35 @@ static int function_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int ifname_map_add(struct dl *dl, const char *ifname,
+			  const char *bus_name, const char *dev_name,
+			  uint32_t port_index)
+{
+	struct ifname_map *ifname_map;
+
+	ifname_map = ifname_map_alloc(bus_name, dev_name, port_index, ifname);
+	if (!ifname_map)
+		return -ENOMEM;
+	list_add(&ifname_map->list, &dl->ifname_map_list);
+	return 0;
+}
+
+static void ifname_map_del(struct ifname_map *ifname_map)
+{
+	list_del(&ifname_map->list);
+	ifname_map_free(ifname_map);
+}
+
 static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
 	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
 	struct dl *dl = data;
-	struct ifname_map *ifname_map;
 	const char *bus_name;
 	const char *dev_name;
 	uint32_t port_index;
 	const char *port_ifname;
+	int err;
 
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
@@ -797,11 +816,9 @@ static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
 	port_index = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
 	port_ifname = mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]);
-	ifname_map = ifname_map_alloc(bus_name, dev_name,
-				      port_index, port_ifname);
-	if (!ifname_map)
+	err = ifname_map_add(dl, port_ifname, bus_name, dev_name, port_index);
+	if (err)
 		return MNL_CB_ERROR;
-	list_add(&ifname_map->list, &dl->ifname_map_list);
 
 	return MNL_CB_OK;
 }
@@ -812,8 +829,7 @@ static void ifname_map_fini(struct dl *dl)
 
 	list_for_each_entry_safe(ifname_map, tmp,
 				 &dl->ifname_map_list, list) {
-		list_del(&ifname_map->list);
-		ifname_map_free(ifname_map);
+		ifname_map_del(ifname_map);
 	}
 }
 
-- 
2.37.3

