Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB0C19BD2A
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 09:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgDBH6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 03:58:38 -0400
Received: from mx58.baidu.com ([61.135.168.58]:23476 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725965AbgDBH6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 03:58:38 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Apr 2020 03:58:37 EDT
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 4B10611C0056;
        Thu,  2 Apr 2020 15:52:10 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org, kevin.laatz@intel.com,
        ciara.loftus@intel.com, bruce.richardson@intel.com,
        jonathan.lemon@gmail.com, daniel@iogearbox.net
Subject: [PATCH] xsk: fix out of boundary write in __xsk_rcv_memcpy
Date:   Thu,  2 Apr 2020 15:52:10 +0800
Message-Id: <1585813930-19712-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

first_len is remainder of first page, if write size is
larger than it, out of page boundary write will happen

Fixes: c05cd3645814 "(xsk: add support to allow unaligned chunk placement)"
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/xdp/xsk.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 356f90e4522b..c350108aa38d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -131,8 +131,9 @@ static void __xsk_rcv_memcpy(struct xdp_umem *umem, u64 addr, void *from_buf,
 		u64 page_start = addr & ~(PAGE_SIZE - 1);
 		u64 first_len = PAGE_SIZE - (addr - page_start);
 
-		memcpy(to_buf, from_buf, first_len + metalen);
-		memcpy(next_pg_addr, from_buf + first_len, len - first_len);
+		memcpy(to_buf, from_buf, first_len);
+		memcpy(next_pg_addr, from_buf + first_len,
+		       len + metalen - first_len);
 
 		return;
 	}
-- 
2.16.2

