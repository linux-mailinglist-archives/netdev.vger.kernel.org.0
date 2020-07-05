Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB4214DF7
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 18:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgGEQS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 12:18:26 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:39772 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgGEQS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 12:18:26 -0400
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id B68D72E14F5;
        Sun,  5 Jul 2020 19:18:16 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id z5sFN3YmzU-IGmS4T7m;
        Sun, 05 Jul 2020 19:18:16 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1593965896; bh=zjTWgrEuhSqZ11G2ZxtLXsfwh6Dg2YOT1b2YEFs6ekA=;
        h=Message-Id:Date:Subject:To:From;
        b=LwWbbTvgd2tWKt5eLM78Y/xcN/ufxhniUDK+6POFofCvCN8GY60w43bXv72WpAhZj
         d8E1DYlcF7CmHwzh5IjTm2kCEbmFghpXi+S/YuZ/h7/hXS5eAtiYZWltvoSfM02hdM
         X//H5t91VSMJ5bEZbwDc1TUDcw1w193QgoX3YQAI=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [199.21.99.33])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lVHU6Cz5fl-IGiWrkMY;
        Sun, 05 Jul 2020 19:18:16 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: [PATCH iproute2-next v2] lib: fix checking of returned file handle size for cgroup
Date:   Sun,  5 Jul 2020 19:18:12 +0300
Message-Id: <20200705161812.45560-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch check is happened only in case when we try to find
cgroup at cgroup2 mount point.

v2:
  - add Fixes line before Signed-off-by (David Ahern)

Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 lib/fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/fs.c b/lib/fs.c
index e265fc0..4b90a70 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -148,10 +148,10 @@ __u64 get_cgroup2_id(const char *path)
 					strerror(errno));
 			goto out;
 		}
-		if (fhp->handle_bytes != sizeof(__u64)) {
-			fprintf(stderr, "Invalid size of cgroup2 ID\n");
-			goto out;
-		}
+	}
+	if (fhp->handle_bytes != sizeof(__u64)) {
+		fprintf(stderr, "Invalid size of cgroup2 ID\n");
+		goto out;
 	}
 
 	memcpy(cg_id.bytes, fhp->f_handle, sizeof(__u64));
-- 
2.7.4

