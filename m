Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B39164D52E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiLOCCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiLOCCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1AC05288C
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B208461CE2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2324C4339B;
        Thu, 15 Dec 2022 02:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069727;
        bh=gTsAx0ujdjnqHD4rxv1adDRi0oVpPyg0eChCLwcFWUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=slX8GW7zCyYu6nwMRlGEJNhhuTy4lpftUMcdmnfJAoj9LzSlpHZsOoC9K9W0XGiJ+
         N6oV/HebpFdwZ19qjLHOacQQIF5yON4MitqY9a6fqBSlKCgzM5G1ZaXLTyTPbkmsF8
         mk0OtSdnDRp3KoEAGfTUCQ++DgUiwdMa9c8TWFlCmMQPf1K90J1bwPeC/QvSwCzyDA
         ci95BpVTRTsE6+a3eQddZURx24w5+ec4IAR0oZL4Ss0MtUXqj3mheCqe29IL0dJMam
         zbMlf2/tApKRivfnuYI1tnlRrwUTWlj5GEfETivUJT5a4smIHy/4eLqfnR5a8C9pOp
         lO/50Xy9h7L8A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 08/15] devlink: drop the filter argument from devlinks_xa_find_get
Date:   Wed, 14 Dec 2022 18:01:48 -0800
Message-Id: <20221215020155.1619839-9-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like devlinks_xa_find_get() was intended to get the mark
from the @filter argument. It doesn't actually use @filter, passing
DEVLINK_REGISTERED to xa_find_fn() directly. Walking marks other
than registered is unlikely so drop @filter argument completely.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c          | 12 +++++-------
 net/devlink/devl_internal.h | 15 +++++----------
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index c084eafa17fb..3a99bf84632e 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -92,7 +92,7 @@ void devlink_put(struct devlink *devlink)
 }
 
 static struct devlink *
-devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
+devlinks_xa_find_get(struct net *net, unsigned long *indexp,
 		     void * (*xa_find_fn)(struct xarray *, unsigned long *,
 					  unsigned long, xa_mark_t))
 {
@@ -125,17 +125,15 @@ devlinks_xa_find_get(struct net *net, unsigned long *indexp, xa_mark_t filter,
 }
 
 struct devlink *
-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp,
-			   xa_mark_t filter)
+devlinks_xa_find_get_first(struct net *net, unsigned long *indexp)
 {
-	return devlinks_xa_find_get(net, indexp, filter, xa_find);
+	return devlinks_xa_find_get(net, indexp, xa_find);
 }
 
 struct devlink *
-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp,
-			  xa_mark_t filter)
+devlinks_xa_find_get_next(struct net *net, unsigned long *indexp)
 {
-	return devlinks_xa_find_get(net, indexp, filter, xa_find_after);
+	return devlinks_xa_find_get(net, indexp, xa_find_after);
 }
 
 /**
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 91059311f18d..ee98f3bdcd33 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -81,20 +81,15 @@ extern struct genl_family devlink_nl_family;
  * devlink_put() needs to be called for each iterated devlink pointer
  * in loop body in order to release the reference.
  */
-#define devlinks_xa_for_each_get(net, index, devlink, filter)		\
-	for (index = 0,							\
-	     devlink = devlinks_xa_find_get_first(net, &index, filter);	\
-	     devlink; devlink = devlinks_xa_find_get_next(net, &index, filter))
-
 #define devlinks_xa_for_each_registered_get(net, index, devlink)	\
-	devlinks_xa_for_each_get(net, index, devlink, DEVLINK_REGISTERED)
+	for (index = 0,							\
+	     devlink = devlinks_xa_find_get_first(net, &index);	\
+	     devlink; devlink = devlinks_xa_find_get_next(net, &index))
 
 struct devlink *
-devlinks_xa_find_get_first(struct net *net, unsigned long *indexp,
-			   xa_mark_t filter);
+devlinks_xa_find_get_first(struct net *net, unsigned long *indexp);
 struct devlink *
-devlinks_xa_find_get_next(struct net *net, unsigned long *indexp,
-			  xa_mark_t filter);
+devlinks_xa_find_get_next(struct net *net, unsigned long *indexp);
 
 /* Netlink */
 #define DEVLINK_NL_FLAG_NEED_PORT		BIT(0)
-- 
2.38.1

