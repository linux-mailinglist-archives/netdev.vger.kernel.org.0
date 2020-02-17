Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 167181613DD
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgBQNqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:46:49 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29757 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726977AbgBQNqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:46:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581947207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=d3J45i/iFgFhqXdb8PdNOHV/vscLYNA2Zd6HEo5Tg2c=;
        b=WeK5Gi1JbMR0wttDfv04blN1jZPr5ooQjMpwqEZb+OOAOyRj9TvPO5re8VGLW9Ry36n5Wt
        ZSesb/yOclma9fw4oYhxxC5tcAcjy0vwptqofWECTw9e1YjqptZet8KORXAtzzmCIbjMg8
        AMVdfAWWAjtaeuFTuy+9QR2Cc8zCgdc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-EQ-6DH7QOAy0OPX2wGflXw-1; Mon, 17 Feb 2020 08:46:46 -0500
X-MC-Unique: EQ-6DH7QOAy0OPX2wGflXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3886F100550E;
        Mon, 17 Feb 2020 13:46:45 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ECE019757;
        Mon, 17 Feb 2020 13:46:44 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2 v2] nstat: print useful error messages in abort() cases
Date:   Mon, 17 Feb 2020 14:46:18 +0100
Message-Id: <df68542441f77ecedd95a3c29dd61d696f98dfac.1581946818.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When nstat temporary file is corrupted or in some other corner cases,
nstat use abort() to stop its execution. This can puzzle some users,
wondering what is the reason for the crash.

This commit replaces abort() with some meaningful error messages and exit=
()

Reported-by: Renaud M=C3=A9trich <rmetrich@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 v2: replace two missing abort(), resend to iproute2 instead of iproute2-=
next

 misc/nstat.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/misc/nstat.c b/misc/nstat.c
index 23113b223b22d..425e75ef461ec 100644
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
@@ -221,18 +231,27 @@ static void load_ugly_table(FILE *fp)
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
 		do {
 			p =3D strrchr(buf, ' ');
-			if (!p)
-				abort();
+			if (!p) {
+				fprintf(stderr, "%s:%d: error parsing history file\n",
+					__FILE__, __LINE__);
+				exit(-2);
+			}
 			*p =3D 0;
-			if (sscanf(p+1, "%llu", &n->val) !=3D 1)
-				abort();
+			if (sscanf(p+1, "%llu", &n->val) !=3D 1) {
+				fprintf(stderr, "%s:%d: error parsing history file\n",
+					__FILE__, __LINE__);
+				exit(-2);
+			}
 			/* Trick to skip "dummy" trailing ICMP MIB in 2.4 */
 			if (skip)
 				skip--;
--=20
2.24.1

