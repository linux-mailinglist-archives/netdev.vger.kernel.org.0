Return-Path: <netdev+bounces-9084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B317271D5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE0211C20FA2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8153C3B3EB;
	Wed,  7 Jun 2023 22:38:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B3F3B3E0
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 22:38:24 +0000 (UTC)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B299E;
	Wed,  7 Jun 2023 15:38:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 5876863CC10C;
	Thu,  8 Jun 2023 00:38:17 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 2NQlVBlpCf14; Thu,  8 Jun 2023 00:38:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id D668963CC111;
	Thu,  8 Jun 2023 00:38:16 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OnWj-RF31K1B; Thu,  8 Jun 2023 00:38:16 +0200 (CEST)
Received: from foxxylove.corp.sigma-star.at (unknown [82.150.214.1])
	by lithops.sigma-star.at (Postfix) with ESMTPSA id 2F98E63CC10C;
	Thu,  8 Jun 2023 00:38:16 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: linux-hardening@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	keescook@chromium.org,
	Richard Weinberger <richard@nod.at>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC PATCH 1/1] vsprintf: Warn on integer scanning overflows
Date: Thu,  8 Jun 2023 00:37:55 +0200
Message-Id: <20230607223755.1610-2-richard@nod.at>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230607223755.1610-1-richard@nod.at>
References: <20230607223755.1610-1-richard@nod.at>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The scanf function family has no way to indicate overflows
while scanning. As consequence users of these function have to make
sure their input cannot cause an overflow.
Since this is not always the case add WARN_ON_ONCE() guards to
trigger a warning upon an overflow.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 lib/vsprintf.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 40f560959b169..3d8d751306cdc 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -70,6 +70,7 @@ static noinline unsigned long long simple_strntoull(con=
st char *startp, size_t m
 	prefix_chars =3D cp - startp;
 	if (prefix_chars < max_chars) {
 		rv =3D _parse_integer_limit(cp, base, &result, max_chars - prefix_char=
s);
+		WARN_ON_ONCE(rv & KSTRTOX_OVERFLOW);
 		/* FIXME */
 		cp +=3D (rv & ~KSTRTOX_OVERFLOW);
 	} else {
@@ -3657,22 +3658,34 @@ int vsscanf(const char *buf, const char *fmt, va_=
list args)
=20
 		switch (qualifier) {
 		case 'H':	/* that's 'hh' in format */
-			if (is_sign)
+			if (is_sign) {
+				WARN_ON_ONCE(val.s > 127);
+				WARN_ON_ONCE(val.s < -128);
 				*va_arg(args, signed char *) =3D val.s;
-			else
+			} else {
+				WARN_ON_ONCE(val.u > 255);
 				*va_arg(args, unsigned char *) =3D val.u;
+			}
 			break;
 		case 'h':
-			if (is_sign)
+			if (is_sign) {
+				WARN_ON_ONCE(val.s > SHRT_MAX);
+				WARN_ON_ONCE(val.s < SHRT_MIN);
 				*va_arg(args, short *) =3D val.s;
-			else
+			} else {
+				WARN_ON_ONCE(val.u > USHRT_MAX);
 				*va_arg(args, unsigned short *) =3D val.u;
+			}
 			break;
 		case 'l':
-			if (is_sign)
+			if (is_sign) {
+				WARN_ON_ONCE(val.s > LONG_MAX);
+				WARN_ON_ONCE(val.s < LONG_MIN);
 				*va_arg(args, long *) =3D val.s;
-			else
+			} else {
+				WARN_ON_ONCE(val.u > ULONG_MAX);
 				*va_arg(args, unsigned long *) =3D val.u;
+			}
 			break;
 		case 'L':
 			if (is_sign)
@@ -3684,10 +3697,14 @@ int vsscanf(const char *buf, const char *fmt, va_=
list args)
 			*va_arg(args, size_t *) =3D val.u;
 			break;
 		default:
-			if (is_sign)
+			if (is_sign) {
+				WARN_ON_ONCE(val.s > INT_MAX);
+				WARN_ON_ONCE(val.s < INT_MIN);
 				*va_arg(args, int *) =3D val.s;
-			else
+			} else {
+				WARN_ON_ONCE(val.u > UINT_MAX);
 				*va_arg(args, unsigned int *) =3D val.u;
+			}
 			break;
 		}
 		num++;
--=20
2.35.3


