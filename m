Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9FF3154ACE
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 19:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBFSJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 13:09:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26740 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbgBFSI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 13:08:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581012532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=q4hL16tGUu/9Z3PSdaiBYG0LCaxRmPyopUs+ZSQJKRs=;
        b=PO79eedCop0ZXUxklWz18Xvxh5f80xfN08vn561OZfXcp8r91q31Limwr80Ln3NF4B+tXr
        QlSpfdA/P212ILpNkIZLh8Wn/y6jZoyK8Mq9Fu4WLIxkdBeA23506zOwu6igng5d8Xqksk
        UMs9HKoJfT3Bxw9IUbHd42xY3+e6oXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-AM0MHheuPDS2Y3BVe6av7A-1; Thu, 06 Feb 2020 13:08:49 -0500
X-MC-Unique: AM0MHheuPDS2Y3BVe6av7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD04E1081FA0;
        Thu,  6 Feb 2020 18:08:47 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.36.118.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0036863C8;
        Thu,  6 Feb 2020 18:08:46 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next] nstat: print useful error messages in abort() cases
Date:   Thu,  6 Feb 2020 19:08:29 +0100
Message-Id: <0dd54edffe6edd9f0a15dbe9590c251782b743a4.1581012315.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nstat temporary file is corrupted or in some other corner cases,
nstat uses abort() to stop its execution. This can puzzle some users,
wondering what is the reason of the crash.

This commit replaces abort() with some meaningful error messages and exit=
()

Reported-by: Renaud M=C3=A9trich <rmetrich@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 misc/nstat.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/misc/nstat.c b/misc/nstat.c
index 23113b223b22d..d8e3e274442f6 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -142,14 +142,19 @@ static void load_good_table(FILE *fp)
 		}
 		/* idbuf is as big as buf, so this is safe */
 		nr =3D sscanf(buf, "%s%llu%lg", idbuf, &val, &rate);
-		if (nr < 2)
-			abort();
+		if (nr < 2) {
+			fprintf(stderr, "%s:%d: error parsing history file\n",
+				__FILE__, __LINE__);
+			exit(-2);
+		}
 		if (nr < 3)
 			rate =3D 0;
 		if (useless_number(idbuf))
 			continue;
-		if ((n =3D malloc(sizeof(*n))) =3D=3D NULL)
-			abort();
+		if ((n =3D malloc(sizeof(*n))) =3D=3D NULL) {
+			perror("nstat: malloc");
+			exit(-1);
+		}
 		n->id =3D strdup(idbuf);
 		n->val =3D val;
 		n->rate =3D rate;
@@ -190,8 +195,11 @@ static void load_ugly_table(FILE *fp)
 		int count1, count2, skip =3D 0;
=20
 		p =3D strchr(buf, ':');
-		if (!p)
-			abort();
+		if (!p) {
+			fprintf(stderr, "%s:%d: error parsing history file\n",
+				__FILE__, __LINE__);
+			exit(-2);
+		}
 		count1 =3D count_spaces(buf);
 		*p =3D 0;
 		idbuf[0] =3D 0;
@@ -211,8 +219,10 @@ static void load_ugly_table(FILE *fp)
 				strncat(idbuf, p, sizeof(idbuf) - off - 1);
 			}
 			n =3D malloc(sizeof(*n));
-			if (!n)
-				abort();
+			if (!n) {
+				perror("nstat: malloc");
+				exit(-1);
+			}
 			n->id =3D strdup(idbuf);
 			n->rate =3D 0;
 			n->next =3D db;
@@ -221,8 +231,11 @@ static void load_ugly_table(FILE *fp)
 		}
 		n =3D db;
 		nread =3D getline(&buf, &buflen, fp);
-		if (nread =3D=3D -1)
-			abort();
+		if (nread =3D=3D -1) {
+			fprintf(stderr, "%s:%d: error parsing history file\n",
+				__FILE__, __LINE__);
+			exit(-2);
+		}
 		count2 =3D count_spaces(buf);
 		if (count2 > count1)
 			skip =3D count2 - count1;
--=20
2.24.1

