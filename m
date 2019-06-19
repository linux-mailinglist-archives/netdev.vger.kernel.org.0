Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32B54BED3
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbfFSQrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfFSQrr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:47:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A2430A3B6F;
        Wed, 19 Jun 2019 16:47:46 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-120-57.rdu2.redhat.com [10.10.120.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C5795D9C6;
        Wed, 19 Jun 2019 16:47:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 7/9] keys: Garbage collect keys for which the domain has
 been removed [ver #4]
From:   David Howells <dhowells@redhat.com>
To:     ebiederm@xmission.com, keyrings@vger.kernel.org
Cc:     linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        dhowells@redhat.com, dwalsh@redhat.com, vgoyal@redhat.com,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 19 Jun 2019 17:47:43 +0100
Message-ID: <156096286376.28733.13843099343286423128.stgit@warthog.procyon.org.uk>
In-Reply-To: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
References: <156096279115.28733.8761881995303698232.stgit@warthog.procyon.org.uk>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 19 Jun 2019 16:47:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a key operation domain (such as a network namespace) has been removed
then attempt to garbage collect all the keys that use it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/key.h      |    2 ++
 security/keys/internal.h |    3 ++-
 security/keys/keyring.c  |   15 +++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/key.h b/include/linux/key.h
index abc68555bac3..60c076c6e47f 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -278,6 +278,7 @@ extern void key_revoke(struct key *key);
 extern void key_invalidate(struct key *key);
 extern void key_put(struct key *key);
 extern bool key_put_tag(struct key_tag *tag);
+extern void key_remove_domain(struct key_tag *domain_tag);
 
 static inline struct key *__key_get(struct key *key)
 {
@@ -446,6 +447,7 @@ extern void key_init(void);
 #define key_fsgid_changed(c)		do { } while(0)
 #define key_init()			do { } while(0)
 #define key_free_user_ns(ns)		do { } while(0)
+#define key_remove_domain(d)		do { } while(0)
 
 #endif /* CONFIG_KEYS */
 #endif /* __KERNEL__ */
diff --git a/security/keys/internal.h b/security/keys/internal.h
index d3a9439e2386..5a561f5f199e 100644
--- a/security/keys/internal.h
+++ b/security/keys/internal.h
@@ -209,7 +209,8 @@ static inline bool key_is_dead(const struct key *key, time64_t limit)
 	return
 		key->flags & ((1 << KEY_FLAG_DEAD) |
 			      (1 << KEY_FLAG_INVALIDATED)) ||
-		(key->expiry > 0 && key->expiry <= limit);
+		(key->expiry > 0 && key->expiry <= limit) ||
+		key->domain_tag->removed;
 }
 
 /*
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 0da8fa282d56..d3c86fda1510 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -241,6 +241,21 @@ bool key_put_tag(struct key_tag *tag)
 	return false;
 }
 
+/**
+ * key_remove_domain - Kill off a key domain and gc its keys
+ * @domain_tag: The domain tag to release.
+ *
+ * This marks a domain tag as being dead and releases a ref on it.  If that
+ * wasn't the last reference, the garbage collector is poked to try and delete
+ * all keys that were in the domain.
+ */
+void key_remove_domain(struct key_tag *domain_tag)
+{
+	domain_tag->removed = true;
+	if (!key_put_tag(domain_tag))
+		key_schedule_gc_links();
+}
+
 /*
  * Build the next index key chunk.
  *

