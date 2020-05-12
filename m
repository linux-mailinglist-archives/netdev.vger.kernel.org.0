Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE0B1CF49F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 14:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729378AbgELMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 08:44:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727783AbgELMoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 08:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589287461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oQE7Luxj46ryOPRlV71322h7pmSI2E1I/c7PU9mBn1o=;
        b=L+N37f2MwiXuZ98aXFKFGJMGs0aPuZaUtLlPdneKb7qiVgX5MNg4tuzuF/4aiT3bfAV4ad
        nYW5YvMsFSuD+eOr2gumcSo9kUQBftTYVHTsfF7+d7BjdypdgOpa00NFLnnF0rsmdDyt9I
        68EC3sBdqd3NlO3Q4p2KABedLA0yefA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-8Zl9Q_-QNcWpJxsegJoltw-1; Tue, 12 May 2020 08:44:17 -0400
X-MC-Unique: 8Zl9Q_-QNcWpJxsegJoltw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6469B107B767;
        Tue, 12 May 2020 12:44:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59C5B196AE;
        Tue, 12 May 2020 12:44:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-security-module@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>, ppandit@redhat.com,
        Matthew Sheets <matthew.sheets@gd-ms.com>
Subject: [PATCH net] netlabel: cope with NULL catmap
Date:   Tue, 12 May 2020 14:43:14 +0200
Message-Id: <07d99ae197bfdb2964931201db67b6cd0b38db5b.1589276729.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cipso and calipso code can set the MLS_CAT attribute on
successful parsing, even if the corresponding catmap has
not been allocated, as per current configuration and external
input.

Later, selinux code tries to access the catmap if the MLS_CAT flag
is present via netlbl_catmap_getlong(). That may cause null ptr
dereference while processing incoming network traffic.

Address the issue setting the MLS_CAT flag only if the catmap is
really allocated. Additionally let netlbl_catmap_getlong() cope
with NULL catmap.

Reported-by: Matthew Sheets <matthew.sheets@gd-ms.com>
Fixes: 4b8feff251da ("netlabel: fix the horribly broken catmap functions")
Fixes: ceba1832b1b2 ("calipso: Set the calipso socket label to match the secattr.")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/cipso_ipv4.c        | 6 ++++--
 net/ipv6/calipso.c           | 3 ++-
 net/netlabel/netlabel_kapi.c | 6 ++++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 0bd10a1f477f..a23094b050f8 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1258,7 +1258,8 @@ static int cipso_v4_parsetag_rbm(const struct cipso_v4_doi *doi_def,
 			return ret_val;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	return 0;
@@ -1439,7 +1440,8 @@ static int cipso_v4_parsetag_rng(const struct cipso_v4_doi *doi_def,
 			return ret_val;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	return 0;
diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 221c81f85cbf..8d3f66c310db 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1047,7 +1047,8 @@ static int calipso_opt_getattr(const unsigned char *calipso,
 			goto getattr_return;
 		}
 
-		secattr->flags |= NETLBL_SECATTR_MLS_CAT;
+		if (secattr->attr.mls.cat)
+			secattr->flags |= NETLBL_SECATTR_MLS_CAT;
 	}
 
 	secattr->type = NETLBL_NLTYPE_CALIPSO;
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 409a3ae47ce2..5e1239cef000 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -734,6 +734,12 @@ int netlbl_catmap_getlong(struct netlbl_lsm_catmap *catmap,
 	if ((off & (BITS_PER_LONG - 1)) != 0)
 		return -EINVAL;
 
+	/* a null catmap is equivalent to an empty one */
+	if (!catmap) {
+		*offset = (u32)-1;
+		return 0;
+	}
+
 	if (off < catmap->startbit) {
 		off = catmap->startbit;
 		*offset = off;
-- 
2.21.3

