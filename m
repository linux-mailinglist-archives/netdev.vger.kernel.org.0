Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875F265CC4E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbjADERK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbjADEQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DEF167FF
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A07BBB810A5
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73E9C433EF;
        Wed,  4 Jan 2023 04:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805808;
        bh=allJ9rfbtr82C8dYha5EM42/Z6iXuqRtbYQtq+WlXHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwAPV9ipHnJ19MMsNP8eRt5E1ZBeoUIiooAs3TIoYvOKB7eLyNYpPRbjxSQKfEgGE
         J6MuL25og3IDD2Ve1iS343oIJYp15CVt16WetxP1kppN0ifWhJxJxAOPD4kHtDMPFf
         b4p/niOtaSn3Bhg2RGrlYhqBBHsTRh60LQUletOb8nGwjXG7BTNNT7946tLXFNZmvQ
         m48KnHTQethnVNydDGy3p+lnRyN8q30ZdsrtBzXwYhX25DhXXmQGkou3+tmqNjzu1c
         GKX3qb282RYh4Xgjrq/JQAMz72uEwpWmrLnwBdCt+C7ax8qyMYQsnJnEIjmK2zmFiI
         STB76IyLEp5tA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/14] devlink: drop the filter argument from devlinks_xa_find_get
Date:   Tue,  3 Jan 2023 20:16:29 -0800
Message-Id: <20230104041636.226398-8-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230104041636.226398-1-kuba@kernel.org>
References: <20230104041636.226398-1-kuba@kernel.org>
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

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

