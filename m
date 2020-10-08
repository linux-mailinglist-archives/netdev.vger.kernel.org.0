Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4678287B54
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 20:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729571AbgJHSCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 14:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJHSCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 14:02:16 -0400
X-Greylist: delayed 138 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Oct 2020 11:02:16 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164E2C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 11:02:16 -0700 (PDT)
Received: from sas1-5717c3cea310.qloud-c.yandex.net (sas1-5717c3cea310.qloud-c.yandex.net [IPv6:2a02:6b8:c14:3616:0:640:5717:c3ce])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 5FA682E1260;
        Thu,  8 Oct 2020 20:59:53 +0300 (MSK)
Received: from sas1-b105e6591dac.qloud-c.yandex.net (sas1-b105e6591dac.qloud-c.yandex.net [2a02:6b8:c08:4790:0:640:b105:e659])
        by sas1-5717c3cea310.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id jPkBuVt7JM-xrwSkYfY;
        Thu, 08 Oct 2020 20:59:53 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1602179993; bh=+fVZM2nq1ViNO2Js1dqqxRKY8AnXigzPCbMRoSykHPo=;
        h=Message-Id:Date:Subject:To:From;
        b=NoPfOBpubyS8XbcmwHThUhZeoWKdt2cxiEQHhq93l8GBbCshff4JAdGTI7cyOG83O
         obqJ/Ysc3gCmg0sB81i2oQ+Ph5Tm5nLXdl1p5ZaC2fcONZ3PeYi7ssQWYk/BsTtibq
         9bQm00Asj7mwWEsCIfcj6pTqPuCjcSJpiABNxwfI=
Authentication-Results: sas1-5717c3cea310.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 141.8.131.75-iva.dhcp.yndx.net (141.8.131.75-iva.dhcp.yndx.net [141.8.131.75])
        by sas1-b105e6591dac.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FKd97PYapo-xrnmkWq0;
        Thu, 08 Oct 2020 20:59:53 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     sharpd@nvidia.com, dsahern@gmail.com, netdev@vger.kernel.org
Subject: [PATCH iproute2] lib: ignore invalid mounts in cg_init_map
Date:   Thu,  8 Oct 2020 20:59:27 +0300
Message-Id: <20201008175927.47130-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of bad entries in /proc/mounts just skip cgroup cache initialization.
Cgroups in output will be shown as "unreachable:cgroup_id".

Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reported-by: Donald Sharp <sharpd@nvidia.com>
---
 lib/cg_map.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/cg_map.c b/lib/cg_map.c
index 77f030e..39f244d 100644
--- a/lib/cg_map.c
+++ b/lib/cg_map.c
@@ -96,11 +96,10 @@ static void cg_init_map(void)
 
 	mnt = find_cgroup2_mount(false);
 	if (!mnt)
-		exit(1);
+		return;
 
 	mntlen = strlen(mnt);
-	if (nftw(mnt, nftw_fn, 1024, FTW_MOUNT) < 0)
-		exit(1);
+	(void) nftw(mnt, nftw_fn, 1024, FTW_MOUNT);
 
 	free(mnt);
 }
-- 
2.7.4

