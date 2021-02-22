Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D873215D9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhBVMLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:11:22 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9748 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhBVMLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:11:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60339f3f0000>; Mon, 22 Feb 2021 04:10:39 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Feb
 2021 12:10:38 +0000
Received: from c-236-149-120-125.mtl.labs.mlnx (172.20.145.6) by
 mail.nvidia.com (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via
 Frontend Transport; Mon, 22 Feb 2021 12:10:37 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next v2] dcb: Fix compilation warning about reallocarray
Date:   Mon, 22 Feb 2021 14:10:30 +0200
Message-ID: <20210222121030.2109-1-roid@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613995839; bh=FxjHKMzafwGfvjjqy5hsHQNXb+U7pDDImzKfoPRuW6A=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Type:Content-Transfer-Encoding;
        b=bjw8g2KZRIeSzPXgU6O9vtXRGe+92/RncDQ8ZhdammIpBaCg1r3a+dQJce5PLDf49
         XGxUZfC6AuOFLiYQJn590T2QeWbgkXIdleHsACBUW+mPxWUu5r1+y0MBMNEC3OnTtt
         THfHqOK2zRfGWlbWiKhI43iJnu6TnRbSwJ3M+NO6b3FTKrrFMs4rNXtwO+A9NjP8ba
         k52Vt7dYagZaVdaZJnxXLpDlk5oSzS+F5V17R9dlKVQEuwbVBD/J5K4SmdMf53NeYK
         bURPcyBmGj0GX8el9PrNqeUi264SpMqm+iHwRehUV/5EPwU5cucefErpSuX3yw2mQr
         rrYk4ul64fh3w==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In older distros we need bsd/stdlib.h but newer distro doesn't
need it. Also old distro will need libbsd-devel installed and newer
doesn't. To remove a possible dependency on libbsd-devel replace usage
of reallocarray to realloc.

dcb_app.c: In function =E2=80=98dcb_app_table_push=E2=80=99:
dcb_app.c:68:25: warning: implicit declaration of function =E2=80=98realloc=
array=E2=80=99; did you mean =E2=80=98realloc=E2=80=99?

Fixes: 8e9bed1493f5 ("dcb: Add a subtool for the DCB APP object")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---

Notes:
    v2
    - tag for iproute next
    - replace reallocarray with realloc instead of messing with libbsd

 dcb/dcb_app.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 7ce80f85072b..c4816bc2997f 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -65,8 +65,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
=20
 static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *a=
pp)
 {
-	struct dcb_app *apps =3D reallocarray(tab->apps, tab->n_apps + 1,
-					    sizeof(*tab->apps));
+	struct dcb_app *apps =3D realloc(tab->apps, (tab->n_apps + 1) * sizeof(*t=
ab->apps));
=20
 	if (apps =3D=3D NULL) {
 		perror("Cannot allocate APP table");
--=20
2.8.0

