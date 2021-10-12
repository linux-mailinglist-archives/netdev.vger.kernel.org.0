Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6406242A915
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 18:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhJLQIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:08:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhJLQIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:08:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E7A1610FC;
        Tue, 12 Oct 2021 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054799;
        bh=qWuTiMXZuMMOBwI/LNOwvx4blL/IU+5cJhwVyy280tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DU2S4s9pGqE5OTDVkwIFwJB00dF+TXb007FJh/BTjhkiebJYb3ziEA2qgxMlKXT9D
         Oy1Hz4OJjdgcJsQ5OFNIG0FSm+puyEgNndO9/I9bApxbglr61Mp1I9pLzyWhV5BD72
         LWOmXdp9T9kwmLAcJE8rlekZRSW4EbSBYn17dcxHgAGtXtIOZAKhAfx+am7VmDYpIZ
         8TTyb8JQobqJYuuSFaVXbo9hbqqyXJcDcne+5dSGp7s8CtNHkAtQA/d49H0s663my7
         zGPkHtVbyMxIP3VQIFFYncYFf1Wdh57evirzOY4xMi9M8HhV2egtgydmkOGibkp0ZW
         C3ysXNS/tswnA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] netdevice: demote the type of some dev_addr_set() helpers
Date:   Tue, 12 Oct 2021 09:06:32 -0700
Message-Id: <20211012160634.4152690-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012160634.4152690-1-kuba@kernel.org>
References: <20211012160634.4152690-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__dev_addr_set() and dev_addr_mod() and pretty low level,
let the arguments be void, there's no chance for confusion
in callers converted to use them. Keep u8 in dev_addr_set()
because some of the callers are converted from a loop
and we want to make sure assignments are not from an array
of a different type.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0723c1314ea2..f33af341bfb2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4643,7 +4643,7 @@ void __hw_addr_init(struct netdev_hw_addr_list *list);
 
 /* Functions used for device addresses handling */
 static inline void
-__dev_addr_set(struct net_device *dev, const u8 *addr, size_t len)
+__dev_addr_set(struct net_device *dev, const void *addr, size_t len)
 {
 	memcpy(dev->dev_addr, addr, len);
 }
@@ -4655,7 +4655,7 @@ static inline void dev_addr_set(struct net_device *dev, const u8 *addr)
 
 static inline void
 dev_addr_mod(struct net_device *dev, unsigned int offset,
-	     const u8 *addr, size_t len)
+	     const void *addr, size_t len)
 {
 	memcpy(&dev->dev_addr[offset], addr, len);
 }
-- 
2.31.1

