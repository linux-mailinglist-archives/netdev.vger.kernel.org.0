Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8F358F89
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 03:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfF1BMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 21:12:36 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:43394 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfF1BMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 21:12:36 -0400
Received: by mail-pl1-f202.google.com with SMTP id t2so2457687plo.10
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 18:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Mv+Yt5661paO9K5dtP2dnQMy9o+sBxrbFhsWwSqJJcg=;
        b=fDc2qQrbPMqyoUOaO3fNeaHuQ43ov0aOHxaebEouKgwpC4G3ev/jls3vwwSvcszWbX
         IZhsE6K8dTrSEz1CjjdGtNBGq8zYfVJXg5VU2WUZ/F+IWp/I65K5chy6yMAk68bQtDey
         zTJS2cLjFqPbp2c2gobLF0cfOmNwJaH35Q97uKkbW/RobR4QO+QjUE2JDw+egcR/F3zK
         CcmOkhoizWftCW4vG+Y4wzzQnU5enejBy8l5dq+cLPtm/CZmAvaNECoZOYKmP1+caQqV
         h8hx07T+KvLon+T1YmJMaxit3RNmhuzwIKHRPaG/r316wGeKL72f3iUwl4uemVSgHDwT
         tIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=Mv+Yt5661paO9K5dtP2dnQMy9o+sBxrbFhsWwSqJJcg=;
        b=ZjUicQWwd66nm0lfS+2vr4d8MZy5GejJDAZJ/b9hLa5Nv1QI/xNeLo4QLUGBHFh49T
         woYYhhWDWug6Elb29kazJ3hekse82scRnYZU23y6ycV3PqinZWuxjvWj+N6vHMwegRC2
         kaiQYVdSOQHIEwzIDHM89GgZO0eT6y8OXkcMdTiOwm5it1v0gRoHP+TRT6i/J1QZq2iS
         9yrttiiXTsI1KDuViSQYbgxlAGbQ+Ax5G85XUT0IVZaYLhrpCGL845bpMQt62SqfE/1g
         OTcrMlsqbWgmjD0rMDHXp1CPCRQHbm/w6YkqCHD5/PFuVASdufqYaKSNq3bK8cxe0xxX
         i8pA==
X-Gm-Message-State: APjAAAX720nCzGgB6g7S/mXX6+Mu/2c52XGS9A+3vYzq9oHZRRfigDbb
        +bg5VTg7/lbNvkM8+Qe4UL3KfTqTdqNUWIOeIpyutVtaPUpNVrv98covLH+Syk8x+CSDExelzyS
        3gsmZtwjagPFCxM+M/nWtqgfV/8OkkCdzq9lwHKmtylGOau3gwL0OFg==
X-Google-Smtp-Source: APXvYqwkk6MBmmrk0+2fHEUEMJ52i+jfYv7vxan+bt8Qo3VylUxEwqZYZAx235/ZwaMa7oPZ2ZUgAwo=
X-Received: by 2002:a63:de50:: with SMTP id y16mr6615587pgi.431.1561684355393;
 Thu, 27 Jun 2019 18:12:35 -0700 (PDT)
Date:   Thu, 27 Jun 2019 18:12:33 -0700
Message-Id: <20190628011233.63680-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next] selftests/bpf: fix -Wstrict-aliasing in test_sockopt_sk.c
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's use union with u8[4] and u32 members for sockopt buffer,
that should fix any possible aliasing issues.

test_sockopt_sk.c: In function =E2=80=98getsetsockopt=E2=80=99:
test_sockopt_sk.c:115:2: warning: dereferencing type-punned pointer will br=
eak strict-aliasing rules [-Wstrict-aliasing]
  if (*(__u32 *)buf !=3D 0x55AA*2) {
  ^~
test_sockopt_sk.c:116:3: warning: dereferencing type-punned pointer will br=
eak strict-aliasing rules [-Wstrict-aliasing]
   log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x !=3D 0x55AA*2",
   ^~~~~~~

Fixes: 8a027dc0d8f5 ("selftests/bpf: add sockopt test that exercises sk hel=
pers")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/test_sockopt_sk.c | 51 +++++++++----------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testing/=
selftests/bpf/test_sockopt_sk.c
index 12e79ed075ce..036b652e5ca9 100644
--- a/tools/testing/selftests/bpf/test_sockopt_sk.c
+++ b/tools/testing/selftests/bpf/test_sockopt_sk.c
@@ -22,7 +22,10 @@
 static int getsetsockopt(void)
 {
 	int fd, err;
-	char buf[4] =3D {};
+	union {
+		char u8[4];
+		__u32 u32;
+	} buf =3D {};
 	socklen_t optlen;
=20
 	fd =3D socket(AF_INET, SOCK_STREAM, 0);
@@ -33,31 +36,31 @@ static int getsetsockopt(void)
=20
 	/* IP_TOS - BPF bypass */
=20
-	buf[0] =3D 0x08;
-	err =3D setsockopt(fd, SOL_IP, IP_TOS, buf, 1);
+	buf.u8[0] =3D 0x08;
+	err =3D setsockopt(fd, SOL_IP, IP_TOS, &buf, 1);
 	if (err) {
 		log_err("Failed to call setsockopt(IP_TOS)");
 		goto err;
 	}
=20
-	buf[0] =3D 0x00;
+	buf.u8[0] =3D 0x00;
 	optlen =3D 1;
-	err =3D getsockopt(fd, SOL_IP, IP_TOS, buf, &optlen);
+	err =3D getsockopt(fd, SOL_IP, IP_TOS, &buf, &optlen);
 	if (err) {
 		log_err("Failed to call getsockopt(IP_TOS)");
 		goto err;
 	}
=20
-	if (buf[0] !=3D 0x08) {
+	if (buf.u8[0] !=3D 0x08) {
 		log_err("Unexpected getsockopt(IP_TOS) buf[0] 0x%02x !=3D 0x08",
-			buf[0]);
+			buf.u8[0]);
 		goto err;
 	}
=20
 	/* IP_TTL - EPERM */
=20
-	buf[0] =3D 1;
-	err =3D setsockopt(fd, SOL_IP, IP_TTL, buf, 1);
+	buf.u8[0] =3D 1;
+	err =3D setsockopt(fd, SOL_IP, IP_TTL, &buf, 1);
 	if (!err || errno !=3D EPERM) {
 		log_err("Unexpected success from setsockopt(IP_TTL)");
 		goto err;
@@ -65,16 +68,16 @@ static int getsetsockopt(void)
=20
 	/* SOL_CUSTOM - handled by BPF */
=20
-	buf[0] =3D 0x01;
-	err =3D setsockopt(fd, SOL_CUSTOM, 0, buf, 1);
+	buf.u8[0] =3D 0x01;
+	err =3D setsockopt(fd, SOL_CUSTOM, 0, &buf, 1);
 	if (err) {
 		log_err("Failed to call setsockopt");
 		goto err;
 	}
=20
-	buf[0] =3D 0x00;
+	buf.u32 =3D 0x00;
 	optlen =3D 4;
-	err =3D getsockopt(fd, SOL_CUSTOM, 0, buf, &optlen);
+	err =3D getsockopt(fd, SOL_CUSTOM, 0, &buf, &optlen);
 	if (err) {
 		log_err("Failed to call getsockopt");
 		goto err;
@@ -84,37 +87,31 @@ static int getsetsockopt(void)
 		log_err("Unexpected optlen %d !=3D 1", optlen);
 		goto err;
 	}
-	if (buf[0] !=3D 0x01) {
-		log_err("Unexpected buf[0] 0x%02x !=3D 0x01", buf[0]);
+	if (buf.u8[0] !=3D 0x01) {
+		log_err("Unexpected buf[0] 0x%02x !=3D 0x01", buf.u8[0]);
 		goto err;
 	}
=20
 	/* SO_SNDBUF is overwritten */
=20
-	buf[0] =3D 0x01;
-	buf[1] =3D 0x01;
-	buf[2] =3D 0x01;
-	buf[3] =3D 0x01;
-	err =3D setsockopt(fd, SOL_SOCKET, SO_SNDBUF, buf, 4);
+	buf.u32 =3D 0x01010101;
+	err =3D setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &buf, 4);
 	if (err) {
 		log_err("Failed to call setsockopt(SO_SNDBUF)");
 		goto err;
 	}
=20
-	buf[0] =3D 0x00;
-	buf[1] =3D 0x00;
-	buf[2] =3D 0x00;
-	buf[3] =3D 0x00;
+	buf.u32 =3D 0x00;
 	optlen =3D 4;
-	err =3D getsockopt(fd, SOL_SOCKET, SO_SNDBUF, buf, &optlen);
+	err =3D getsockopt(fd, SOL_SOCKET, SO_SNDBUF, &buf, &optlen);
 	if (err) {
 		log_err("Failed to call getsockopt(SO_SNDBUF)");
 		goto err;
 	}
=20
-	if (*(__u32 *)buf !=3D 0x55AA*2) {
+	if (buf.u32 !=3D 0x55AA*2) {
 		log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x !=3D 0x55AA*2",
-			*(__u32 *)buf);
+			buf.u32);
 		goto err;
 	}
=20
--=20
2.22.0.410.gd8fdbe21b5-goog

