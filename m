Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F42346E27F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 07:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhLIGex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 01:34:53 -0500
Received: from mail-m975.mail.163.com ([123.126.97.5]:4256 "EHLO
        mail-m975.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231567AbhLIGex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 01:34:53 -0500
X-Greylist: delayed 915 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2021 01:34:52 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=9lrPm
        /CapB6Mo9iRlBIyUZhYHkn5dDSEHVfcF/AFzVo=; b=YMTtmMRh6d7NQMb2meGRh
        PFONM6YhIvn4Xcy08b9aBOsIev7AnVlJEiaGfo+WHhF2QzvVWVf3uWdvkWTc77bR
        b5WCtwMIGCsu+nNRYszAVV7GGmGGungL6G4dkvKnK3RapDw/UzlhAPTjF+b/bn1a
        APUe63o2DH+0XmcdQ7WvaQ=
Received: from localhost.localdomain (unknown [218.106.182.227])
        by smtp5 (Coremail) with SMTP id HdxpCgCXSCQCn7FhlVI6Aw--.55449S4;
        Thu, 09 Dec 2021 14:15:44 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        libaokun1@huawei.com
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] nfp: Fix memory leak in nfp_cpp_area_cache_add()
Date:   Thu,  9 Dec 2021 14:15:11 +0800
Message-Id: <20211209061511.122535-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCXSCQCn7FhlVI6Aw--.55449S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uF1DCw45WrykGw4xur4kZwb_yoW8XFykpF
        ZrJ3yrCrWxXr1qgw4DArW8Z3sYya4DGFyfWa45u3y5ZFyagF1UGF15KayrXFyDurWrKFyS
        yry5JFy5Xrs8Cw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jqa0PUUUUU=
X-Originating-IP: [218.106.182.227]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/xtbBORBkjF-PKRy54wAAs+
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In line 800 (#1), nfp_cpp_area_alloc() allocates and initializes a
CPP area structure. But in line 807 (#2), when the cache is allocated
failed, this CPP area structure is not freed, which will result in
memory leak.

We can fix it by freeing the CPP area when the cache is allocated
failed (#2).

792 int nfp_cpp_area_cache_add(struct nfp_cpp *cpp, size_t size)
793 {
794 	struct nfp_cpp_area_cache *cache;
795 	struct nfp_cpp_area *area;

800	area = nfp_cpp_area_alloc(cpp, NFP_CPP_ID(7, NFP_CPP_ACTION_RW, 0),
801 				  0, size);
	// #1: allocates and initializes

802 	if (!area)
803 		return -ENOMEM;

805 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
806 	if (!cache)
807 		return -ENOMEM; // #2: missing free

817	return 0;
818 }

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index d7ac0307797f..34c0d2ddf9ef 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -803,8 +803,10 @@ int nfp_cpp_area_cache_add(struct nfp_cpp *cpp, size_t size)
 		return -ENOMEM;
 
 	cache = kzalloc(sizeof(*cache), GFP_KERNEL);
-	if (!cache)
+	if (!cache) {
+		nfp_cpp_area_free(area);
 		return -ENOMEM;
+	}
 
 	cache->id = 0;
 	cache->addr = 0;
-- 
2.25.1

