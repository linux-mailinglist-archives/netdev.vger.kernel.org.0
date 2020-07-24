Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E5222C94D
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGXPcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 11:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGXPcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 11:32:06 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6217C0619E4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 08:32:05 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 2CB5E8AD9E;
        Fri, 24 Jul 2020 16:32:05 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595604725; bh=ue9mOAv1pdlNVez+dhAaSTApDx9q/qLQ4c9l0kwiYAM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=203/9]=20l2tp:=20remove=20BUG_ON
         =20in=20l2tp_session_queue_purge|Date:=20Fri,=2024=20Jul=202020=20
         16:31:51=20+0100|Message-Id:=20<20200724153157.9366-4-tparkin@kata
         lix.com>|In-Reply-To:=20<20200724153157.9366-1-tparkin@katalix.com
         >|References:=20<20200724153157.9366-1-tparkin@katalix.com>;
        b=M/M3dPsxl3GrgPJ3FljbeQNqueI1dV7Paw8vKs+VfU5pw3in8P5fUTn17bpg0G+oD
         vI0IdqRB6EHNCCdXILWV3+lxYaA1utWEecDtPRPaGqx0SmucsPUGGx4Y/HkQCUB7+k
         lsojU434tNddR+qymXK0T/Y6GezJDEjeAnyQ1UbTvug+9hQGhm8F8m46FQJQ4GOnR4
         Ooy/5LVpDIm7FJBk8Sd8ejMME0TRMyklCd2CzhmL+FiXgMMDTmVC7vYVCnF8JZhWTa
         d4taDUKsyGiUTBYczRtMW+XgwZT1hU4m+W9rWQKS4kymP7pzApMiHnIPS2KC9BtCw/
         4sWRpIvgs2+DQ==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 3/9] l2tp: remove BUG_ON in l2tp_session_queue_purge
Date:   Fri, 24 Jul 2020 16:31:51 +0100
Message-Id: <20200724153157.9366-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200724153157.9366-1-tparkin@katalix.com>
References: <20200724153157.9366-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_session_queue_purge is only called from l2tp_core.c, and it's easy
to statically analyse the code paths calling it to validate that it
should never be passed a NULL session pointer.

Having a BUG_ON checking the session pointer triggers a checkpatch
warning.  Since the BUG_ON is of no value, remove it to avoid the
warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index b871cceeff7c..a1ed8baa5aaa 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -777,7 +777,6 @@ static int l2tp_session_queue_purge(struct l2tp_session *session)
 {
 	struct sk_buff *skb = NULL;
 
-	BUG_ON(!session);
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 	while ((skb = skb_dequeue(&session->reorder_q))) {
 		atomic_long_inc(&session->stats.rx_errors);
-- 
2.17.1

