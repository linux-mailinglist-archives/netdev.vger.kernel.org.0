Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486A3EC1D6
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhHNJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238037AbhHNJ6U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 05:58:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48D9260F00;
        Sat, 14 Aug 2021 09:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628935072;
        bh=G10PfifuW7zSncaUKdKeC95zgBDC68Nv+v9qApbeRGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttBpJ8ucPiNLEAKZUjRroaI0VapCGRxsmkRRVOVQzgs5Kd2UVK1LeSwX7ZPuy6WP+
         p79MhJB0ewWtKH/lNBh09mnn+YWkrzUguhKXMaopjByW+t3ao7HK9yhVt8+b9D+63W
         esc0+4+wzWsCMS89p8Wth96VF0VViMWmVTR7HIECHTj6U9VyGFjGvO01lLpiiLk+m8
         9B5O6OWZsFGWhak7wdp7U4vm26fpk4ZInT0EWxt1giRxTITQiMakd+krix7MOX3/py
         lBrYl4g4Ciuov//g7SLzSe6ek4779KvMlWn6VfDKET9shZEKAfZzsydek9gb5CHomt
         u2vw+9+FASqkg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: [PATCH net-next 5/6] devlink: Clear whole devlink_flash_notify struct
Date:   Sat, 14 Aug 2021 12:57:30 +0300
Message-Id: <d66bfd66eb8744663b7a299db0df7203bc6640cd.1628933864.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628933864.git.leonro@nvidia.com>
References: <cover.1628933864.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The { 0 } doesn't clear all fields in the struct, but tells to the
compiler to set all fields to zero and doesn't touch any sub-fields
if they exists.

The {} is an empty initialiser that instructs to fully initialize whole
struct including sub-fields, which is error-prone for future
devlink_flash_notify extensions.

Fixes: 6700acc5f1fe ("devlink: collect flash notify params into a struct")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index d218f57ad8cf..a856ae401ea5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4169,7 +4169,7 @@ static void __devlink_flash_update_notify(struct devlink *devlink,
 
 static void devlink_flash_update_begin_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE,
@@ -4178,7 +4178,7 @@ static void devlink_flash_update_begin_notify(struct devlink *devlink)
 
 static void devlink_flash_update_end_notify(struct devlink *devlink)
 {
-	struct devlink_flash_notify params = { 0 };
+	struct devlink_flash_notify params = {};
 
 	__devlink_flash_update_notify(devlink,
 				      DEVLINK_CMD_FLASH_UPDATE_END,
-- 
2.31.1

