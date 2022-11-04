Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747C9619460
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiKDKXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKDKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:23:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA3526116
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:23:32 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b2so12065216eja.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irJGxnB6lI423ouSCEisjudoHdWnd9CyFS0idBBdmaY=;
        b=0k2w99n6N17/Ex8B3hXaRtgi6mviL2wBQu+tLh/0zUFtCIuEGytUT8Z3+X4Dfu9HlV
         0iEQdd5baLiE7/3SQkkvxJ7QPlqvOpZdHENzrheuF4Jhnj63SeQoruNkpqZJgW0Wd3Bu
         8ecZLBlLdgBQg8Dpn/cvOr+hxyemgEQ09LDIDZMh4oJHSGO0Z7tsOqUnEE2Lk3ejMUT7
         f0sSD4UhMzDTjr0r/N1gan1P02/3rA6r2UHtpQm4djkrOReAa88DBuNrSbipoT7vCc12
         eIwRg5m6G20oJ5XLdRn4LYh+FFE2fu7G/MuUJ62osAm6KTspwzsSStAJp0Z36GP4mWh5
         UyhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irJGxnB6lI423ouSCEisjudoHdWnd9CyFS0idBBdmaY=;
        b=uR+ssvY/BbY445EFYmWb0PjfnJ3abAYZLem7XUW/WeWleRzzjgIqMBS5Hwuv8pnBMI
         ezPLked6btb0thfcsYFwXb59oBLB4Qog4sYBuEc0XtaEz/0IvO6x4qmiaP7fRYofvZhA
         q/bkxKUxmyiyFAvy8FHgDRogjMsCgG5SnbBDy5zoOhpPlkv8p7jckqXbJRWMl4MecsB+
         8cxWb3MstESeVf6WnjVCnNLzCsCdAsOmli68lV4jJaKOcloHCypEC1E/73iMcAQGL6hP
         zCfEuQwLIhZWZwQfeODV/t26nnBngSICuquCUzltoWL+24DOm+CNKGzcqT4RWEyPsUiA
         Yl/A==
X-Gm-Message-State: ACrzQf3+48KQqlD3UnI5t6MnW+jGzPB4hB5/er5bM9ZluinF01XjOs7C
        UjohUgMlLB0g4f518uvMVg38e2QJQV8YMFy4
X-Google-Smtp-Source: AMsMyM5t1DYOuxR9UvqrRqknw5bO/rbPFlj567IJRFGdp3dkznELtlK9mm32Lfu+1AKtEsb4FaLMWw==
X-Received: by 2002:a17:907:25c5:b0:782:978d:c3da with SMTP id ae5-20020a17090725c500b00782978dc3damr32274187ejc.623.1667557410637;
        Fri, 04 Nov 2022 03:23:30 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l2-20020a1709063d2200b00730bfe6adc4sm1633085ejf.37.2022.11.04.03.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 03:23:30 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, aeedm@nvidia.com
Subject: [patch iproute2-next 1/3] devlink: query ifname for devlink port instead of map lookup
Date:   Fri,  4 Nov 2022 11:23:25 +0100
Message-Id: <20221104102327.770260-2-jiri@resnulli.us>
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

ifname map is created once during init. However, ifnames can easily
change during the devlink process runtime (e. g. devlink mon).
Therefore, query ifname during each devlink port print.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8aefa101b2f8..680936f891cf 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -864,21 +864,38 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
 	return -ENOENT;
 }
 
-static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
-				 const char *dev_name, uint32_t port_index,
-				 char **p_ifname)
+static int port_ifname_get_cb(const struct nlmsghdr *nlh, void *data)
 {
-	struct ifname_map *ifname_map;
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	char **p_ifname = data;
+	const char *ifname;
 
-	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
-		if (strcmp(bus_name, ifname_map->bus_name) == 0 &&
-		    strcmp(dev_name, ifname_map->dev_name) == 0 &&
-		    port_index == ifname_map->port_index) {
-			*p_ifname = ifname_map->ifname;
-			return 0;
-		}
-	}
-	return -ENOENT;
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_PORT_NETDEV_NAME])
+		return MNL_CB_ERROR;
+
+	ifname = mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]);
+	*p_ifname = strdup(ifname);
+	if (!*p_ifname)
+		return MNL_CB_ERROR;
+
+	return MNL_CB_OK;
+}
+
+static int port_ifname_get(struct dl *dl, const char *bus_name,
+			   const char *dev_name, uint32_t port_index,
+			   char **p_ifname)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+	mnl_attr_put_strz(nlh, DEVLINK_ATTR_BUS_NAME, bus_name);
+	mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, dev_name);
+	mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_INDEX, port_index);
+	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, port_ifname_get_cb,
+				      p_ifname);
 }
 
 static int strtobool(const char *str, bool *p_val)
@@ -2577,8 +2594,7 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 	char *ifname = NULL;
 
 	if (dl->no_nice_names || !try_nice ||
-	    ifname_map_rev_lookup(dl, bus_name, dev_name,
-				  port_index, &ifname) != 0)
+	    port_ifname_get(dl, bus_name, dev_name, port_index, &ifname) != 0)
 		sprintf(buf, "%s/%s/%d", bus_name, dev_name, port_index);
 	else
 		sprintf(buf, "%s", ifname);
-- 
2.37.3

