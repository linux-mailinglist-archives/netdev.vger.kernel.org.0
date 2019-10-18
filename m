Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0BCDCC52
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634450AbfJRRJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:09:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35543 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634427AbfJRRJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:09:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id 14so160228wmu.0
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 10:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ERrtIgHR/p+D79N6KWbo2h7Ye/jeGfQi5jPHJizIIPk=;
        b=ddCgyOjmfEXLNPN1dsRpE8WURIPdIUm0+IKpF9hKcvOLABWTeiGR3IISYeMgkcPeZA
         5V8KEAu0sTXzCziw7XWzGuYvKMynUx6qZ5h+veoXsGfdKEHfbXYKxrUJhbE/Fdlh9ZQ8
         baWvmedIMat0u2a5kDGnxDHYX8JYOpgsyN3tG5/I5eg2jzOKb7ESWnmPUGOPLOVK5zup
         TR6zMY+g5u3GzWfVm9/nqHhx/RiflVXiOU46svuiRzJwhgQLDrVHLud+JZLCizZlncFU
         Oq4CG/iorVlSSpaQ15HuPfacabQTPJ2AHddkgPPSZm9lOIOuMiDcJeLHTvoLPSSeKfiJ
         QHGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ERrtIgHR/p+D79N6KWbo2h7Ye/jeGfQi5jPHJizIIPk=;
        b=P/urbzGoeomS8Ku5qvGQgq+6nP30pLbGVe5ls7+h8dHsU0LE2E8KYcMuKIE1fSeDKk
         akmT1vpMxWzv35n4kgryU7X0DgE3t/hD3Aen9DtZInWtfnpN02Mbad570/wPibrN8hXa
         mXAFqR8QybK1yro7qtsb9VhRdLK/qZGHnlDg9nCrNctE0Zl/TiH04qkNgYNN+vvFY6yg
         gMlZhZBgeBeoqYy+oZILwWSrbHucYmrxsELstY/ZUtMZqEd1mJzIlFlLYbcfM6BGANpA
         tMdvt04OWb6U3FjKMpzUlDqRFdyJem4zNDwVcbjl3dRblLq7eG3WZVSz+5tQojbJ82lJ
         a9sQ==
X-Gm-Message-State: APjAAAUIFnW2k1IXSkY00+2EGMZKFzp2z+XJypVyBGpCxReKTe3THisu
        K4l7yqXWbv+0eOTUMSVQucpFKrAFAiQ=
X-Google-Smtp-Source: APXvYqy6+xjd8fMhqemRYMD2oYyODtsGfBVGDH2BRwVmvxvnVCfunznyPUS5qdVDNjkDvmJ/UKXM7Q==
X-Received: by 2002:a1c:a651:: with SMTP id p78mr1991735wme.53.1571418592281;
        Fri, 18 Oct 2019 10:09:52 -0700 (PDT)
Received: from localhost (ip-94-113-126-64.net.upcbroadband.cz. [94.113.126.64])
        by smtp.gmail.com with ESMTPSA id z142sm6844451wmc.24.2019.10.18.10.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 10:09:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: [patch net-next v2] devlink: add format requirement for devlink param names
Date:   Fri, 18 Oct 2019 19:09:51 +0200
Message-Id: <20191018170951.26822-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, the name format is not required by the code, however it is
required during patch review. All params added until now are in-lined
with the following format:
1) lowercase characters, digits and underscored are allowed
2) underscore is neither at the beginning nor at the end and
   there is no more than one in a row.

Add checker to the code to require this format from drivers and warn if
they don't follow.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- removed empty line after comment
- added check for empty string
- converted i and len to size_t and put on a single line
- s/valid_name/name_valid/ to be aligned with the rest
---
 net/core/devlink.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..a7f240f03e1c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -20,6 +20,7 @@
 #include <linux/workqueue.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/timekeeping.h>
+#include <linux/ctype.h>
 #include <rdma/ib_verbs.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
@@ -7040,10 +7041,38 @@ void devlink_resource_occ_get_unregister(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_resource_occ_get_unregister);
 
+static bool devlink_param_name_valid(const char *name)
+{
+	size_t i, len = strlen(name);
+
+	if (!len)
+		return false;
+
+	/* Name can contain lowercase characters or digits.
+	 * Underscores are also allowed, but not at the beginning
+	 * or end of the name and not more than one in a row.
+	 */
+	for (i = 0; i < len; i++) {
+		if (islower(name[i]) || isdigit(name[i]))
+			continue;
+		if (name[i] != '_')
+			return false;
+		if (i == 0 || i + 1 == len)
+			return false;
+		if (name[i - 1] == '_')
+			return false;
+	}
+	return true;
+}
+
 static int devlink_param_verify(const struct devlink_param *param)
 {
 	if (!param || !param->name || !param->supported_cmodes)
 		return -EINVAL;
+
+	if (WARN_ON(!devlink_param_name_valid(param->name)))
+		return -EINVAL;
+
 	if (param->generic)
 		return devlink_param_generic_verify(param);
 	else
-- 
2.21.0

