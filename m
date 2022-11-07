Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394BB61FA94
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiKGQxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiKGQxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:53:53 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01DD1571D
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:53:52 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h9so17201479wrt.0
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 08:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hK38omu7OoOs/B4+AU5CjHT4otBdcJVVcsp6bnFgQ+0=;
        b=OrheDMc3OUCbOv4j0ttqv92iXEx3S0rc+CR3SfPr82aaaV+laZhSQgvBENXdfTVidY
         RYEXKnWPwSubJn8W7+sPKWLmW0kH8/xv1w0ubdhnZARwbjnezdWGojcWOXm8/PhmGY/s
         kpT5wdHrAxUvFj2CLe74H4wq4Ozq6yy1ryD/qClkbIK6Q9QC9CtJ8+6rPUuL4YF1+KT0
         YGyxTuvnhDYzEB5eWBC6FyrkTq/CMx6/Thx00AsYeLjp7rf0fzK6/KeqdMcLOkzAVNCd
         5a/RxtGKGXpTx0Ri1t2CnZQZMSlTSRfEMpJ9GKGgcEGqCBt02NAOMI7SHKucpg3rdrE3
         1PRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hK38omu7OoOs/B4+AU5CjHT4otBdcJVVcsp6bnFgQ+0=;
        b=ZiXb7gdJpEwgK1EVajtgPYi7ejYiBkDqio5sSc4UZUXObsl5yexxG43GSDmkye5OXn
         60MmhXVGoe1Mqf2nx2YCvdSM7/L+N9DZQqBDGVGJieKGEgJ4bXWsSqskZJcMSAp4+eYC
         CeM8fGG99t9wEIZGhAY5bmrdK+okCJktsJ2w51J/N1CcdbsBPo7S+bUNrwSKho59fycT
         cl7x329W6vw3hiL8TfEoh9LaEncHYKmBUZt/NanlCbZ5suyNw4+QKyi2w9Rqu7KbmAni
         kDapSNuP0NKtpHH/yY6cvH/r1TvU9jeJO/wjMD3ijy4ykMEfrFgJLK6nx0l9Q+fOjpi3
         UoWQ==
X-Gm-Message-State: ACrzQf05rn2KjKLt3EBjNN7blSr9ysN33T5G7pLEIJnQSJ9Zv4iubIvh
        iR+3ylDKDdk5ZvXqYYVUVYFuRI1+o0dooankDzs=
X-Google-Smtp-Source: AMsMyM5Ek72FgTq1Ymxekgma4mBa3Uxor5fW4ZjlG00qYiHxILjz3fe13rLyE4t+BH7EsKOCG78dHQ==
X-Received: by 2002:adf:f9cf:0:b0:236:6a26:c055 with SMTP id w15-20020adff9cf000000b002366a26c055mr32445978wrr.195.1667840031168;
        Mon, 07 Nov 2022 08:53:51 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bq21-20020a5d5a15000000b00231ed902a4esm8116926wrb.5.2022.11.07.08.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 08:53:50 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, kuba@kernel.org, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch iproute2-next 1/2] devlink: add ifname_map_add/del() helpers
Date:   Mon,  7 Nov 2022 17:53:47 +0100
Message-Id: <20221107165348.916092-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221107165348.916092-1-jiri@resnulli.us>
References: <20221107165348.916092-1-jiri@resnulli.us>
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
index 8aefa101b2f8..308c0dbd1225 100644
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

