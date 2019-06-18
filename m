Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5344A478
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfFROu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:50:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51400 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbfFROuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:50:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id 207so3644493wma.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=byTxbNZ1D/zzXSiSZAg8D9bpVcsrgqQHTZ3P0E7duVw=;
        b=t4D/FaJ+/ax0xa+Yw3OdCj4gaTdWOvHO4Maf2PiaUi4by1VIQGT1drG4d4gkFAUxNq
         /qe1lzgcMp707QubNmkUnAE+QNHzXt/zdca8Qp8pCTohk0WClOmMGFcfqXBntP6ibDGD
         CN9NB9HF3eO7LrGFDKo3xbDL21/sPOGNxpyq5wnpT37hKLv48uxvqX+nnxT7SvfuGjuz
         P9+DiHpAq86BHKrdsEC+9I4PLfCdl1oTs0YapSIIoUkqLfRVwFyLgAPy9kM8nDzfKCds
         CgbkU1lTlGzXceKyf8Al7AW4tpAp5De60Hp1zhG2cs1jNKWvVo44mgXu0rNNkrX8FnbY
         VCCA==
X-Gm-Message-State: APjAAAUSe4jg3H5njkp3jtnwJRcfPfY8rbzt3Qmhcv4qZOr6ncd6ZsB9
        GkpDC6pqtDyh5TuyifUukn7QnnEtExE=
X-Google-Smtp-Source: APXvYqyTcBkVeTtdJ7Z3zgpZr93Z7JrxUNA5pWAkHViMbMsLTPcUP7P+592wTSu/O9NIxcaOrVIpEg==
X-Received: by 2002:a7b:c5d1:: with SMTP id n17mr4089479wmk.84.1560869423477;
        Tue, 18 Jun 2019 07:50:23 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y133sm4013788wmg.5.2019.06.18.07.50.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:50:22 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Andrea Claudi <aclaudi@redhat.com>
Subject: [PATCH iproute2 v2 3/3] netns: make netns_{save,restore} static
Date:   Tue, 18 Jun 2019 16:49:35 +0200
Message-Id: <20190618144935.31405-4-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190618144935.31405-1-mcroce@redhat.com>
References: <20190618144935.31405-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netns_{save,restore} functions are only used in ipnetns.c now, since
the restore is not needed anymore after the netns exec command.
Move them in ipnetns.c, and make them static.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 include/namespace.h |  2 --
 ip/ip.c             |  1 -
 ip/ipnetns.c        | 31 +++++++++++++++++++++++++++++++
 lib/namespace.c     | 31 -------------------------------
 4 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/include/namespace.h b/include/namespace.h
index 89cdda11..e47f9b5d 100644
--- a/include/namespace.h
+++ b/include/namespace.h
@@ -49,8 +49,6 @@ static inline int setns(int fd, int nstype)
 }
 #endif /* HAVE_SETNS */
 
-void netns_save(void);
-void netns_restore(void);
 int netns_switch(char *netns);
 int netns_get_fd(const char *netns);
 int netns_foreach(int (*func)(char *nsname, void *arg), void *arg);
diff --git a/ip/ip.c b/ip/ip.c
index 49b3aa49..b71ae816 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -158,7 +158,6 @@ static int batch(const char *name)
 			if (!force)
 				break;
 		}
-		netns_restore();
 	}
 	if (line)
 		free(line);
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 58655676..a883f210 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -45,6 +45,7 @@ static int usage(void)
 static struct rtnl_handle rtnsh = { .fd = -1 };
 
 static int have_rtnl_getnsid = -1;
+static int saved_netns = -1;
 
 static int ipnetns_accept_msg(struct rtnl_ctrl_data *ctrl,
 			      struct nlmsghdr *n, void *arg)
@@ -635,6 +636,33 @@ static int create_netns_dir(void)
 	return 0;
 }
 
+/* Obtain a FD for the current namespace, so we can reenter it later */
+static void netns_save(void)
+{
+	if (saved_netns != -1)
+		return;
+
+	saved_netns = open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
+	if (saved_netns == -1) {
+		perror("Cannot open init namespace");
+		exit(1);
+	}
+}
+
+static void netns_restore(void)
+{
+	if (saved_netns == -1)
+		return;
+
+	if (setns(saved_netns, CLONE_NEWNET)) {
+		perror("setns");
+		exit(1);
+	}
+
+	close(saved_netns);
+	saved_netns = -1;
+}
+
 static int netns_add(int argc, char **argv, bool create)
 {
 	/* This function creates a new network namespace and
@@ -728,9 +756,12 @@ static int netns_add(int argc, char **argv, bool create)
 			proc_path, netns_path, strerror(errno));
 		goto out_delete;
 	}
+	netns_restore();
+
 	return 0;
 out_delete:
 	if (create) {
+		netns_restore();
 		netns_delete(argc, argv);
 	} else if (unlink(netns_path) < 0) {
 		fprintf(stderr, "Cannot remove namespace file \"%s\": %s\n",
diff --git a/lib/namespace.c b/lib/namespace.c
index a2aea57a..06ae0a48 100644
--- a/lib/namespace.c
+++ b/lib/namespace.c
@@ -15,35 +15,6 @@
 #include "utils.h"
 #include "namespace.h"
 
-static int saved_netns = -1;
-
-/* Obtain a FD for the current namespace, so we can reenter it later */
-void netns_save(void)
-{
-	if (saved_netns != -1)
-		return;
-
-	saved_netns = open("/proc/self/ns/net", O_RDONLY | O_CLOEXEC);
-	if (saved_netns == -1) {
-		perror("Cannot open init namespace");
-		exit(1);
-	}
-}
-
-void netns_restore(void)
-{
-	if (saved_netns == -1)
-		return;
-
-	if (setns(saved_netns, CLONE_NEWNET)) {
-		perror("setns");
-		exit(1);
-	}
-
-	close(saved_netns);
-	saved_netns = -1;
-}
-
 static void bind_etc(const char *name)
 {
 	char etc_netns_path[sizeof(NETNS_ETC_DIR) + NAME_MAX];
@@ -90,8 +61,6 @@ int netns_switch(char *name)
 		return -1;
 	}
 
-	netns_save();
-
 	if (setns(netns, CLONE_NEWNET) < 0) {
 		fprintf(stderr, "setting the network namespace \"%s\" failed: %s\n",
 			name, strerror(errno));
-- 
2.21.0

