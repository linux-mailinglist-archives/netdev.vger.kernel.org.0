Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE4B5CCBE3
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfJESEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50773 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbfJESEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id 5so8710939wmg.0
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J9x6zahBJcxdJ7IoFk/SIUSNZpI3SewEW30cVzYPpwQ=;
        b=fnc+ZFRr3TYJxsKIwlJmMQTPA28asUJw4CEl6wMIrxmmQl8r0cHy8VOM32yJvc+n6w
         hr6lGGEt5q935talPMvApC7b0ja8A5k8pZRA3kr3trQUi4RYT6K9iECc2lF8KUXfYBhZ
         ZQqFtA/2GmlQCgR7kySixvJCWylRFlOlPbaUTwX/4ljwbEVqob1Y3T3QN/B3r8aFiZ9a
         scK39kZExGi8yR//rk+XXmRBaIMigYIM1hsEfAq7w1kGsjLE2KmEf/vyk78gJKuHx5Kj
         /atLp3IscKBCNcZ7Q+bvn1sft9gfA8MECcFOwen4gmq8gO9xFV/dXEPC+2aifwXFuJW+
         /xuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J9x6zahBJcxdJ7IoFk/SIUSNZpI3SewEW30cVzYPpwQ=;
        b=p0czHG8zFtkoa1UhdthGZfJG/RxNsR7N0Umw79RjLG0NJXgkTwW1wh64VGN97a308Q
         KAg3IHU+rVAQwT4dmPBkKTHgj8hr9auYkTLCtpXkqWJSHK6tvkawBMz+xLbdRmyZku6M
         T6CRZu9orHXF/QdK9xAZpWSIXMVJsTZ4k6Laoa7Wef14JYjKkbG46AzpmvmBIObNT01I
         tEZU5sAUtMKrFKySfVObOZPKZzYUkJ19ALI2OUek4KSW7Hu3Op6pnKSY3glAeB3tcRXf
         HwJ5NZqmghGqHHKNy7SwA0xIPk8tnNJQwuP4YUaeAXUcIpE6ga7M2msjhbaHezjoZJO5
         XO+Q==
X-Gm-Message-State: APjAAAVCWaTINGj6GvbMZjQwY13+8Q7Kf2pnDMd1ZlSkD/4RPPLgyecv
        rGZB0F+Yds7iPC3o58e9U0CNPMUAwDw=
X-Google-Smtp-Source: APXvYqyf1FIG8QpIa45NQx08lG4CCj1rhVCD15VZ1/amaIeMwkTl9hYnKNtIxzlNvBNnXFvc6qSrIg==
X-Received: by 2002:a7b:c412:: with SMTP id k18mr15357522wmi.149.1570298689313;
        Sat, 05 Oct 2019 11:04:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id q124sm16026997wma.5.2019.10.05.11.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 06/10] net: nfc: have genetlink code to parse the attrs during dumpit
Date:   Sat,  5 Oct 2019 20:04:38 +0200
Message-Id: <20191005180442.11788-7-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191005180442.11788-1-jiri@resnulli.us>
References: <20191005180442.11788-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Benefit from the fact that the generic netlink code can parse the attrs
for dumpit op and avoid need to parse it in the op callback.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/nfc/netlink.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 17e6ca62f1be..fd9ad534dd9b 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -102,22 +102,14 @@ static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
 
 static struct nfc_dev *__get_device_from_cb(struct netlink_callback *cb)
 {
-	struct nlattr **attrbuf = genl_family_attrbuf(&nfc_genl_family);
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct nfc_dev *dev;
-	int rc;
 	u32 idx;
 
-	rc = nlmsg_parse_deprecated(cb->nlh,
-				    GENL_HDRLEN + nfc_genl_family.hdrsize,
-				    attrbuf, nfc_genl_family.maxattr,
-				    nfc_genl_policy, NULL);
-	if (rc < 0)
-		return ERR_PTR(rc);
-
-	if (!attrbuf[NFC_ATTR_DEVICE_INDEX])
+	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
 		return ERR_PTR(-EINVAL);
 
-	idx = nla_get_u32(attrbuf[NFC_ATTR_DEVICE_INDEX]);
+	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
 
 	dev = nfc_get_device(idx);
 	if (!dev)
@@ -1697,7 +1689,8 @@ static const struct genl_ops nfc_genl_ops[] = {
 	},
 	{
 		.cmd = NFC_CMD_GET_TARGET,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.dumpit = nfc_genl_dump_targets,
 		.done = nfc_genl_dump_targets_done,
 	},
-- 
2.21.0

