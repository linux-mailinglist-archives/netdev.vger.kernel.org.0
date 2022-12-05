Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D99464284C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiLEMWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiLEMWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:22:14 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEE9FAC5
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:22:08 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id c17so6956357edj.13
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9tH9W6688V7YxZPE80AcFWtdnNsVJu69tH/v5pMx+3s=;
        b=SI20m68ij9Zp6tQ4Zwmknbqtm1g/rWN9AaJ2zmXdQKCexUoDIDmVhHLSYSASYjZ6u/
         6fOHl1B3WoWEq/TLVO6vJS7rCCZxhFMA0EwyAE27deAvvNFQNvpIYBUb4p3ar0CS3xfZ
         aGyvZvxSU1PHpLd+PmcKeC9wnZL7uq200PCbXx4IYA9oCykCsiDgl+DGf551B+iPEaN8
         HgBM3zxjZ7f85axABkyTp5C+uyQuJgCBUZnpIEVcQutaDFLMWUeW1oLNR7M1E8R4CfgH
         pZ4dOOfPG5pXoCBgA2IS8j2cziWpJBd8Aexv/uxk8PsFDNKY4+UrDgrwm8dqJl8XeCI4
         48EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9tH9W6688V7YxZPE80AcFWtdnNsVJu69tH/v5pMx+3s=;
        b=XAPo/Rw4MU+RuQnVCpBZjjS6GrmXor9mzsd6/rY7GMfdt55TcIx7KvplWdeyAvYn5A
         nck8Xy0JCYCmuzuohV7RVk7zyGs5CawqJ+gdNz6bKrSB1NJtuy5LmHHX4uiEcCaqwjNZ
         0c5OEvRJB33GgtetV6kqtFUqhzNYTdZz4athZJcACIaJmLyJyhImS1Txk9vfhCQaXuoY
         4y2brM5SWznAIcR4Wsar1h82BHXmedAjeisHDALKk5R3brMVp0VdfL8ipH05ZP50ZCnV
         oh6Iq03Ar1d4N5scQLcmZ4C2J5oCDM769xt7+YybfKRDi8/IuEt8QtdbqTU8aYteJKJI
         6P3g==
X-Gm-Message-State: ANoB5pnGB7hBc9YwDdZ8Hnms4Ii0DikIqQvElykAxfnBMfBy/0b5Mb6m
        Xyu2iN/TaYgQ8Fc13SoHJ3sJkalLI/QdRkVzwhQ=
X-Google-Smtp-Source: AA0mqf4kYvtgIrWRb9U3sNVf2CBfUsFwwHWO4As7pT3FNiFoQaOTFI/vfYySCIMUfAQB5Eh5PpNOBA==
X-Received: by 2002:aa7:d58e:0:b0:46c:3f7e:d7a5 with SMTP id r14-20020aa7d58e000000b0046c3f7ed7a5mr11057519edq.363.1670242927118;
        Mon, 05 Dec 2022 04:22:07 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b0079e11b8e891sm6135803ejc.125.2022.12.05.04.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:22:06 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2/net-next 4/4] devlink: update ifname map when message contains DEVLINK_ATTR_PORT_NETDEV_NAME
Date:   Mon,  5 Dec 2022 13:21:58 +0100
Message-Id: <20221205122158.437522-5-jiri@resnulli.us>
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

Recent kernels send PORT_NEW message with when ifname changes,
so benefit from that by having ifnames updated.

Whenever there is a message containing DEVLINK_ATTR_PORT_NETDEV_NAME
attribute, use it to update ifname map.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2d9ba32b4140..3125a3db98dc 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -242,6 +242,18 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 	free(ifname_map);
 }
 
+static int ifname_map_update(struct ifname_map *ifname_map, const char *ifname)
+{
+	char *new_ifname;
+
+	new_ifname = strdup(ifname);
+	if (!new_ifname)
+		return -ENOMEM;
+	free(ifname_map->ifname);
+	ifname_map->ifname = new_ifname;
+	return 0;
+}
+
 #define DL_OPT_HANDLE		BIT(0)
 #define DL_OPT_HANDLEP		BIT(1)
 #define DL_OPT_PORT_TYPE	BIT(2)
@@ -985,7 +997,7 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
 
 static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 				 const char *dev_name, uint32_t port_index,
-				 char **p_ifname)
+				 const char **p_ifname)
 {
 	struct ifname_map *ifname_map;
 
@@ -999,6 +1011,12 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 		if (strcmp(bus_name, ifname_map->bus_name) == 0 &&
 		    strcmp(dev_name, ifname_map->dev_name) == 0 &&
 		    port_index == ifname_map->port_index) {
+			/* In case non-NULL ifname is passed, update the
+			 * looked-up entry.
+			 */
+			if (*p_ifname)
+				return ifname_map_update(ifname_map, *p_ifname);
+
 			*p_ifname = ifname_map->ifname;
 			return 0;
 		}
@@ -2715,11 +2733,10 @@ static bool should_arr_last_port_handle_end(struct dl *dl,
 
 static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 				       const char *dev_name,
-				       uint32_t port_index, bool try_nice,
-				       bool array)
+				       uint32_t port_index, const char *ifname,
+				       bool try_nice, bool array)
 {
 	static char buf[64];
-	char *ifname = NULL;
 
 	if (dl->no_nice_names || !try_nice ||
 	    ifname_map_rev_lookup(dl, bus_name, dev_name,
@@ -2767,6 +2784,7 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 static void __pr_out_port_handle_start_tb(struct dl *dl, struct nlattr **tb,
 					  bool try_nice, bool array)
 {
+	const char *ifname = NULL;
 	const char *bus_name;
 	const char *dev_name;
 	uint32_t port_index;
@@ -2774,7 +2792,10 @@ static void __pr_out_port_handle_start_tb(struct dl *dl, struct nlattr **tb,
 	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
 	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
 	port_index = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
-	__pr_out_port_handle_start(dl, bus_name, dev_name, port_index, try_nice, array);
+	if (tb[DEVLINK_ATTR_PORT_NETDEV_NAME])
+		ifname = mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]);
+	__pr_out_port_handle_start(dl, bus_name, dev_name, port_index,
+				   ifname, try_nice, array);
 }
 
 static void pr_out_port_handle_start(struct dl *dl, struct nlattr **tb, bool try_nice)
@@ -6160,7 +6181,8 @@ static void pr_out_occ_show(struct occ_show *occ_show)
 
 	list_for_each_entry(occ_port, &occ_show->port_list, list) {
 		__pr_out_port_handle_start(dl, opts->bus_name, opts->dev_name,
-					   occ_port->port_index, true, false);
+					   occ_port->port_index, NULL,
+					   true, false);
 		pr_out_occ_show_port(dl, occ_port);
 		pr_out_port_handle_end(dl);
 	}
-- 
2.37.3

