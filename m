Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E001C1488A0
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405057AbgAXOUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405041AbgAXOUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8925B24658;
        Fri, 24 Jan 2020 14:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875646;
        bh=NI/F5O7O2DF5NpXDqVbwR4mY4CXCuJUdj3rgTc4J27Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBL8+tSQLRK7uTMzkirJvnO7VISgs+2nkwG+jt2VPD1wWiMGoNgziu5USvlfdog/E
         xCug6wUALA3zq8jZntffeh2ZpaeO0Veo3Sk/W8vZnbmliT6T42xFyINDfWNc2HwqH8
         SiIXQJafRD97xFRiO3clPSt/uYGEuMwEbvFJhKaE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 29/56] netfilter: fix a use-after-free in mtype_destroy()
Date:   Fri, 24 Jan 2020 09:19:45 -0500
Message-Id: <20200124142012.29752-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124142012.29752-1-sashal@kernel.org>
References: <20200124142012.29752-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c120959387efa51479056fd01dc90adfba7a590c ]

map->members is freed by ip_set_free() right before using it in
mtype_ext_cleanup() again. So we just have to move it down.

Reported-by: syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com
Fixes: 40cd63bf33b2 ("netfilter: ipset: Support extensions which need a per data destroy function")
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 257ca393e6f22..af480ffefaf32 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -64,9 +64,9 @@ mtype_destroy(struct ip_set *set)
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
 
-	ip_set_free(map->members);
 	if (set->dsize && set->extensions & IPSET_EXT_DESTROY)
 		mtype_ext_cleanup(set);
+	ip_set_free(map->members);
 	ip_set_free(map);
 
 	set->data = NULL;
-- 
2.20.1

