Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC23642852
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiLEMW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiLEMWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:22:20 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92386F02E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:22:03 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qk9so9584402ejc.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zH10zqiWoRGk0H7TFDInvDRblijdvWkUYJmhhjKI1yI=;
        b=kUz2ukT/VHLsCLKuleKWdRu6w++TTZUiy5ZxIGk63xUkHOyGp7G/Cvi7/8/L2H1QZ5
         8ejxBb9FDxEkv+Hzc4IcU7etuxn8LAh2v7mpg1CtsXxvltCL9lpxWi4zubizjaDePODH
         Vijm7uv75hoqAcYL4sUCIUSxILE8gRnxt89MY524SetG33jxLahie5vLDAxa8grQNFwU
         oGV10eu/DLpMDGkEcaxc4RQMOMxodWQl1Xs2IPNZSfzKTVqarYyGWHOBuQftmnsXqli7
         +JN7Qy6lhySrALwDejqMEhi+zaRD3XwDysxvMZWfWlbz3RRTZJUEOwd4GYSPKhEfKTJk
         u39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zH10zqiWoRGk0H7TFDInvDRblijdvWkUYJmhhjKI1yI=;
        b=FDrZ741EGvVOprOXybRNyaTbtVqB9+a5ANGRzbIok+9ygGQKqCRpl7ybjD359zN19W
         ChO+huXzh8FgRB2RPD3termsuL4jzrmC9p40ZHQ5COYvu/MeVPn6OXNv0b2rKe1tobNx
         ZAjr+dZZhZdZl3jUPREtUBYLFUinaJAQsjgZ9XSoPvATMGZwV5OQfXdzhFxxM0vNmtlb
         h7Ja7kJB5Nz0GrydU9T45J6VNtkdhW9q1cfdEzrIZrrfn3q3GvvcPfcytXDA8bnNgS5/
         FilnZSjZ+vBrntu9/+b+qfAOWHDNEdUywnHyVkW+mzsYj/e48oJMzeS9mTeFdtB77KAz
         FkDw==
X-Gm-Message-State: ANoB5pnNzQuJk339hKEFXU9thEiNdAmR+1H0W8ew/gd0Suo4TTdV2Kap
        9abVmgTCDHCKeE3FgEeBR8dLalueTgHa5sz1kB0=
X-Google-Smtp-Source: AA0mqf769vQN/PkYNCMkm/7OPbOSrLxZWC0SDpHFDvKH7n/cHJuSgtKv+SlGU14loyNGW2tfsZMtVw==
X-Received: by 2002:a17:907:a072:b0:7c0:ff74:facc with SMTP id ia18-20020a170907a07200b007c0ff74faccmr1503845ejc.515.1670242922140;
        Mon, 05 Dec 2022 04:22:02 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id k24-20020a1709065fd800b0078d76ee7543sm6186881ejv.222.2022.12.05.04.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:22:01 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2/net-next 1/4] devlink: add ifname_map_add/del() helpers
Date:   Mon,  5 Dec 2022 13:21:55 +0100
Message-Id: <20221205122158.437522-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205122158.437522-1-jiri@resnulli.us>
References: <20221205122158.437522-1-jiri@resnulli.us>
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
index 4a5eee7a13e8..d224655cd0e9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -778,16 +778,35 @@ static int function_attr_cb(const struct nlattr *attr, void *data)
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
@@ -801,11 +820,9 @@ static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
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
@@ -816,8 +833,7 @@ static void ifname_map_fini(struct dl *dl)
 
 	list_for_each_entry_safe(ifname_map, tmp,
 				 &dl->ifname_map_list, list) {
-		list_del(&ifname_map->list);
-		ifname_map_free(ifname_map);
+		ifname_map_del(ifname_map);
 	}
 }
 
-- 
2.37.3

