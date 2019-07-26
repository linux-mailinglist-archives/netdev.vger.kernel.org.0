Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 889D57731B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbfGZVBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:01:21 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39044 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfGZVBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 17:01:20 -0400
Received: from sf.home (host86-142-46-27.range86-142.btcentralplus.com [86.142.46.27])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: slyfox)
        by smtp.gentoo.org (Postfix) with ESMTPSA id CE79034891D;
        Fri, 26 Jul 2019 21:01:19 +0000 (UTC)
Received: by sf.home (Postfix, from userid 1000)
        id 5A3692440A511; Fri, 26 Jul 2019 22:01:15 +0100 (BST)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Sergei Trofimovich <slyfox@gentoo.org>, netdev@vger.kernel.org
Subject: [PATCH v2] iproute2: devlink: port from sys/queue.h to list.h
Date:   Fri, 26 Jul 2019 22:01:05 +0100
Message-Id: <20190726210105.25458-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726112956.3b54f906@hermes.lan>
References: <20190726112956.3b54f906@hermes.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sys/queue.h does not exist on linux-musl targets and fails build as:

    devlink.c:28:10: fatal error: sys/queue.h: No such file or directory
       28 | #include <sys/queue.h>
          |          ^~~~~~~~~~~~~

The change ports to list.h API and drops dependency of 'sys/queue.h'.
The API maps one-to-one.

Build-tested on linux-musl and linux-glibc.

Bug: https://bugs.gentoo.org/690486
CC: Stephen Hemminger <stephen@networkplumber.org>
CC: netdev@vger.kernel.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 devlink/devlink.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index bb023c0c..0ea401ae 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -25,7 +25,6 @@
 #include <linux/devlink.h>
 #include <libmnl/libmnl.h>
 #include <netinet/ether.h>
-#include <sys/queue.h>
 
 #include "SNAPSHOT.h"
 #include "list.h"
@@ -5981,13 +5980,13 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 
 struct nest_qentry {
 	int attr_type;
-	TAILQ_ENTRY(nest_qentry) nest_entries;
+	struct list_head nest_entries;
 };
 
 struct fmsg_cb_data {
 	struct dl *dl;
 	uint8_t value_type;
-	TAILQ_HEAD(, nest_qentry) qhead;
+	struct list_head qhead;
 };
 
 static int cmd_fmsg_nest_queue(struct fmsg_cb_data *fmsg_data,
@@ -6001,13 +6000,13 @@ static int cmd_fmsg_nest_queue(struct fmsg_cb_data *fmsg_data,
 			return -ENOMEM;
 
 		entry->attr_type = *attr_value;
-		TAILQ_INSERT_HEAD(&fmsg_data->qhead, entry, nest_entries);
+		list_add(&fmsg_data->qhead, &entry->nest_entries);
 	} else {
-		if (TAILQ_EMPTY(&fmsg_data->qhead))
+		if (list_empty(&fmsg_data->qhead))
 			return MNL_CB_ERROR;
-		entry = TAILQ_FIRST(&fmsg_data->qhead);
+		entry = list_first_entry(&fmsg_data->qhead, struct nest_qentry, nest_entries);
 		*attr_value = entry->attr_type;
-		TAILQ_REMOVE(&fmsg_data->qhead, entry, nest_entries);
+		list_del(&entry->nest_entries);
 		free(entry);
 	}
 	return MNL_CB_OK;
@@ -6116,7 +6115,7 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 		return err;
 
 	data.dl = dl;
-	TAILQ_INIT(&data.qhead);
+	INIT_LIST_HEAD(&data.qhead);
 	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_fmsg_object_cb, &data);
 	return err;
 }
-- 
2.22.0

