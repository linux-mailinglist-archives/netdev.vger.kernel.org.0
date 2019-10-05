Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0FBCCBE1
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfJESEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:51 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:34569 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfJESEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:51 -0400
Received: by mail-wm1-f50.google.com with SMTP id y135so11850711wmc.1
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o5X/aLY+NFsL15ZEwGndIZdKFKFjviRfJEae9N1S3iA=;
        b=dnQtPeEoU+qQ1bTyREOPpZHgImbsSSqo7s55w/SMkmOdUyXUNJPOeF1SbTifBpWZHv
         dTAxAG2kai8b5NMrlpF6yABa+mPvR5NLL2q9Ht0CgovJIjgElO5dX+XOKaiWba7Qy194
         422BvGgFK928go+O2K918S6mJbodvZj+MDfNkLk7m8XtqETwa7CHKaWPh+wo8tveRUoa
         xGla7wcRtToHwm+4lmNa3HWNlUvdnFMfviNoNF44gxjUa/ASLWduN09ih87gopeR29y5
         k+P9nJ81qd0Q+Kumu92MNfkZ0dHjbE3juxO1UVuoD95+jt7MOn98/dmhXyXt0iyOyLwL
         aCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o5X/aLY+NFsL15ZEwGndIZdKFKFjviRfJEae9N1S3iA=;
        b=VBZsl9/1HAKN7n/e819Fm/t+swSaqeMTdCern3rqwDZHDtlnBqIelnJSOBijILtfF1
         HF76yKxOf620v1XvdhQ6J9iTyRNyTFGfZVGP8aejKUaQpIbi/GS8q1SW0cQRSXL97DEz
         /EYTTgPPLLr8CRVM2/WdrKydFY0OLqoGvtlyb0jc9S58hhWXtimOWjPDr9mYZt+TKFbX
         EtpC5+01xKPJ/6L4hjznj1qZsG+/dVN+Ds2mEpL5uWzlGLz2xpBgwkgAUDfy4N0bQpcq
         saoG4edJjp8RMEQ5cD1SDuJYLpt0gIbfTMi07qhi/4pNQFQgtkbDbauE2YqdW9cCnfH1
         3IxQ==
X-Gm-Message-State: APjAAAVwyKCta65iCaX7nvguPUU18zNnAvZg/MlMlj+9Qy8jKyx/J14N
        v3zwvV4mnwYVJYC2GeYBJNfScJQ2x/s=
X-Google-Smtp-Source: APXvYqy331BPTfPkLwrbLc6m7R17UOAyTp0hDGHPLF0oNqJr50t0WxC+A+EUpjJn7dVuuxPkq50rCA==
X-Received: by 2002:a1c:4102:: with SMTP id o2mr14446106wma.66.1570298688418;
        Sat, 05 Oct 2019 11:04:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 33sm14847940wra.41.2019.10.05.11.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 05/10] net: ieee802154: have genetlink code to parse the attrs during dumpit
Date:   Sat,  5 Oct 2019 20:04:37 +0200
Message-Id: <20191005180442.11788-6-jiri@resnulli.us>
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
 net/ieee802154/nl802154.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index ffcfcef76291..7c5a1aa5adb4 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -236,21 +236,14 @@ nl802154_prepare_wpan_dev_dump(struct sk_buff *skb,
 			       struct cfg802154_registered_device **rdev,
 			       struct wpan_dev **wpan_dev)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	int err;
 
 	rtnl_lock();
 
 	if (!cb->args[0]) {
-		err = nlmsg_parse_deprecated(cb->nlh,
-					     GENL_HDRLEN + nl802154_fam.hdrsize,
-					     genl_family_attrbuf(&nl802154_fam),
-					     nl802154_fam.maxattr,
-					     nl802154_policy, NULL);
-		if (err)
-			goto out_unlock;
-
 		*wpan_dev = __cfg802154_wpan_dev_from_attrs(sock_net(skb->sk),
-							    genl_family_attrbuf(&nl802154_fam));
+							    info->attrs);
 		if (IS_ERR(*wpan_dev)) {
 			err = PTR_ERR(*wpan_dev);
 			goto out_unlock;
@@ -557,17 +550,8 @@ static int nl802154_dump_wpan_phy_parse(struct sk_buff *skb,
 					struct netlink_callback *cb,
 					struct nl802154_dump_wpan_phy_state *state)
 {
-	struct nlattr **tb = genl_family_attrbuf(&nl802154_fam);
-	int ret = nlmsg_parse_deprecated(cb->nlh,
-					 GENL_HDRLEN + nl802154_fam.hdrsize,
-					 tb, nl802154_fam.maxattr,
-					 nl802154_policy, NULL);
-
-	/* TODO check if we can handle error here,
-	 * we have no backward compatibility
-	 */
-	if (ret)
-		return 0;
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
+	struct nlattr **tb = info->attrs;
 
 	if (tb[NL802154_ATTR_WPAN_PHY])
 		state->filter_wpan_phy = nla_get_u32(tb[NL802154_ATTR_WPAN_PHY]);
@@ -2203,7 +2187,8 @@ static void nl802154_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 static const struct genl_ops nl802154_ops[] = {
 	{
 		.cmd = NL802154_CMD_GET_WPAN_PHY,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		.doit = nl802154_get_wpan_phy,
 		.dumpit = nl802154_dump_wpan_phy,
 		.done = nl802154_dump_wpan_phy_done,
@@ -2343,7 +2328,8 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_GET_SEC_KEY,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		/* TODO .doit by matching key id? */
 		.dumpit = nl802154_dump_llsec_key,
 		.flags = GENL_ADMIN_PERM,
@@ -2369,7 +2355,8 @@ static const struct genl_ops nl802154_ops[] = {
 	/* TODO unique identifier must short+pan OR extended_addr */
 	{
 		.cmd = NL802154_CMD_GET_SEC_DEV,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		/* TODO .doit by matching extended_addr? */
 		.dumpit = nl802154_dump_llsec_dev,
 		.flags = GENL_ADMIN_PERM,
@@ -2395,7 +2382,8 @@ static const struct genl_ops nl802154_ops[] = {
 	/* TODO remove complete devkey, put it as nested? */
 	{
 		.cmd = NL802154_CMD_GET_SEC_DEVKEY,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		/* TODO doit by matching ??? */
 		.dumpit = nl802154_dump_llsec_devkey,
 		.flags = GENL_ADMIN_PERM,
@@ -2420,7 +2408,8 @@ static const struct genl_ops nl802154_ops[] = {
 	},
 	{
 		.cmd = NL802154_CMD_GET_SEC_LEVEL,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate = GENL_DONT_VALIDATE_STRICT |
+			    GENL_DONT_VALIDATE_DUMP_STRICT,
 		/* TODO .doit by matching frame_type? */
 		.dumpit = nl802154_dump_llsec_seclevel,
 		.flags = GENL_ADMIN_PERM,
-- 
2.21.0

