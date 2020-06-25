Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFCE209DB5
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404337AbgFYLrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:47:22 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:43944 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404220AbgFYLrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:47:22 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 992C22E15C7;
        Thu, 25 Jun 2020 14:47:19 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id qQqeesOMYo-lJiq0p6f;
        Thu, 25 Jun 2020 14:47:19 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1593085639; bh=nVLAq1POGqk9gUACLhMqfJ8x97f4+2OlsKe5CfyfAWY=;
        h=Message-Id:Date:Subject:To:From;
        b=jpAVaAgqN/acz+DeLzabYXpVQ3L2XcogM6EWmh4vb71bc25toL2+JswhxmqAT1AHA
         Fyn9YCCITNSPEIWlc77eQ7cMkedGtanl2XWvyFU8wpYRZZK0ZBEkUf42J4ENvcY8K9
         JoyAZ8dyBLr6kbB8TV/CEohvqGWwnlqPIUy6PDj4=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 5.255.237.167-vpn.dhcp.yndx.net (5.255.237.167-vpn.dhcp.yndx.net [5.255.237.167])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id z4oEZJbcE6-lJlWuDrM;
        Thu, 25 Jun 2020 14:47:19 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: [PATCH iproute2-next] lib: fix checking of returned file handle size for cgroup
Date:   Thu, 25 Jun 2020 14:46:57 +0300
Message-Id: <20200625114657.49115-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this patch check is happened only in case when we try to find
cgroup at cgroup2 mount point.

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

