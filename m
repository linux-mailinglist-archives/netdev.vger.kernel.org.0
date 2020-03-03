Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7DA176E5A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgCCFFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbgCCFFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:41 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8549D2465A;
        Tue,  3 Mar 2020 05:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211940;
        bh=q4utRvIIIESWDbo2PkHoFo/rphIdEaYvTDtGh1dwjkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dfSiLKvalbuU4Ua5Foo2wp3jGFXEycl8gFYNdpJAieKIstZxssprdHtO04iuvubz0
         5n02HYekUlqk+vuUj6BeM4zIEr9fXLSt8iDmri/QL70oOUzvUyLKPeblqHsNOFHdzM
         p/1V45uNTIkFDv1p/Ks4H8mi9bQZ6whNYxEi9Snc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net 01/16] devlink: validate length of param values
Date:   Mon,  2 Mar 2020 21:05:11 -0800
Message-Id: <20200303050526.4088735-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEVLINK_ATTR_PARAM_VALUE_DATA may have different types
so it's not checked by the normal netlink policy. Make
sure the attribute length is what we expect.

Fixes: e3b7ca18ad7b ("devlink: Add param set command")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Jiri Pirko <jiri@mellanox.com>
CC: Moshe Shemesh <moshe@mellanox.com>
---
 net/core/devlink.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5e220809844c..8e44dc5cde73 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3352,34 +3352,41 @@ devlink_param_value_get_from_info(const struct devlink_param *param,
 				  struct genl_info *info,
 				  union devlink_param_value *value)
 {
+	struct nlattr *param_data;
 	int len;
 
-	if (param->type != DEVLINK_PARAM_TYPE_BOOL &&
-	    !info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA])
+	param_data = info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA];
+
+	if (param->type != DEVLINK_PARAM_TYPE_BOOL && !param_data)
 		return -EINVAL;
 
 	switch (param->type) {
 	case DEVLINK_PARAM_TYPE_U8:
-		value->vu8 = nla_get_u8(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]);
+		if (nla_len(param_data) != sizeof(u8))
+			return -EINVAL;
+		value->vu8 = nla_get_u8(param_data);
 		break;
 	case DEVLINK_PARAM_TYPE_U16:
-		value->vu16 = nla_get_u16(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]);
+		if (nla_len(param_data) != sizeof(u16))
+			return -EINVAL;
+		value->vu16 = nla_get_u16(param_data);
 		break;
 	case DEVLINK_PARAM_TYPE_U32:
-		value->vu32 = nla_get_u32(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]);
+		if (nla_len(param_data) != sizeof(u32))
+			return -EINVAL;
+		value->vu32 = nla_get_u32(param_data);
 		break;
 	case DEVLINK_PARAM_TYPE_STRING:
-		len = strnlen(nla_data(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]),
-			      nla_len(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]));
-		if (len == nla_len(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]) ||
+		len = strnlen(nla_data(param_data), nla_len(param_data));
+		if (len == nla_len(param_data) ||
 		    len >= __DEVLINK_PARAM_MAX_STRING_VALUE)
 			return -EINVAL;
-		strcpy(value->vstr,
-		       nla_data(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]));
+		strcpy(value->vstr, nla_data(param_data));
 		break;
 	case DEVLINK_PARAM_TYPE_BOOL:
-		value->vbool = info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA] ?
-			       true : false;
+		if (param_data && nla_len(param_data))
+			return -EINVAL;
+		value->vbool = nla_get_flag(param_data);
 		break;
 	}
 	return 0;
-- 
2.24.1

