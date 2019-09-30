Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5A8C1B65
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 08:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbfI3GXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 02:23:21 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46634 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729521AbfI3GXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 02:23:20 -0400
Received: by mail-pl1-f195.google.com with SMTP id q24so3480772plr.13
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 23:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=v2UXSRbpPDMJNbLsLxq3/UMcKkAZnO5Y/0E9KDSBhOo=;
        b=HlUOvK8EVF8UMWp9csj74S9LbksAznt7PrLFcaXSxF+m6w/v54Ri5xl/C30x/ImEMJ
         U9bVu3JnXRlbtKgiM2qJp44+SZu2B5LtRKAw6Vx5ZQRPqic3/+xxNW+i8La8GZXHgRmO
         NfKm7YxSxNA52g40Mr2kxNHqEXIGBwnUUWh44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v2UXSRbpPDMJNbLsLxq3/UMcKkAZnO5Y/0E9KDSBhOo=;
        b=e0NX1EKm8V4FjP7gBwu3Ha4y8rbGrvSBLIj/5S4T/BTRAAUjJSDQeDg45J9Bdr16kB
         gri9xhxktm0gLjtDTPELxg25HF4CqnUDU2KTLNnKk0Eba2qs0TO2NuYBtu00+RpboYbc
         yzDyyBXHTcvz+uJjytkdMJcqiZ4g4+Wm+UnPhBA61f6KSsrTsJCrhaPyx+MjWXc1WHDK
         xNbbv74scY3mOfTQyWIlCJRFhGlBL/vIlLxvkjBWtR1MbpAOCYlk0AbB/eTd/CL12Blz
         Mn7asaLV8v4HOyPNAGLNmgD+aQYwUHGv1DsLd5PT8mFG8UZikSsGzdw+BS/mvIATyqAH
         xD8A==
X-Gm-Message-State: APjAAAVOvTBxgV9osE0meMlbay+rlDyZphwnfrRy0BhVhUGJG1wxx+DA
        KiUNiQfIAeLgfH/yoRzYfyg3MA==
X-Google-Smtp-Source: APXvYqxS5mukV3TFkP4Xq/q+BaOaakE/7lN/V/+BF5mQ6mYb9Z91Ek2eW5lQDhwmEy3mPXay9GlV9g==
X-Received: by 2002:a17:902:a987:: with SMTP id bh7mr18259242plb.159.1569824600035;
        Sun, 29 Sep 2019 23:23:20 -0700 (PDT)
Received: from lxpurley1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id ev20sm10811593pjb.19.2019.09.29.23.23.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 23:23:19 -0700 (PDT)
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH v2 net] devlink: Fix error handling in param and info_get dumpit cb
Date:   Mon, 30 Sep 2019 11:52:21 +0530
Message-Id: <1569824541-5603-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If any of the param or info_get op returns error, dumpit cb is
skipping to dump remaining params or info_get ops for all the
drivers.

Fix to not return if any of the param/info_get op returns error
as not supported and continue to dump remaining information.

v2: Modify the patch to return error, except for params/info_get
op that return -EOPNOTSUPP as suggested by Andrew Lunn. Also, modify
commit message to reflect the same.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
---
 net/core/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index e48680e..f80151e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3172,7 +3172,7 @@ static int devlink_nl_cmd_param_get_dumpit(struct sk_buff *msg,
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI);
-			if (err) {
+			if (err && err != -EOPNOTSUPP) {
 				mutex_unlock(&devlink->lock);
 				goto out;
 			}
@@ -3432,7 +3432,7 @@ static int devlink_nl_cmd_port_param_get_dumpit(struct sk_buff *msg,
 						NETLINK_CB(cb->skb).portid,
 						cb->nlh->nlmsg_seq,
 						NLM_F_MULTI);
-				if (err) {
+				if (err && err != -EOPNOTSUPP) {
 					mutex_unlock(&devlink->lock);
 					goto out;
 				}
@@ -4088,7 +4088,7 @@ static int devlink_nl_cmd_info_get_dumpit(struct sk_buff *msg,
 					   cb->nlh->nlmsg_seq, NLM_F_MULTI,
 					   cb->extack);
 		mutex_unlock(&devlink->lock);
-		if (err)
+		if (err && err != -EOPNOTSUPP)
 			break;
 		idx++;
 	}
-- 
1.8.3.1

