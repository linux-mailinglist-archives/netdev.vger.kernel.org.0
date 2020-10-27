Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7970329AC22
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 13:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439319AbgJ0McP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 08:32:15 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43134 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406396AbgJ0McP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 08:32:15 -0400
Received: by mail-pg1-f193.google.com with SMTP id r10so695217pgb.10;
        Tue, 27 Oct 2020 05:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1JSrthhCNHix8X49ZrSHsK+j5HmL4LI/jDszyOYaask=;
        b=BSXX6nuHG34nUYK+EcBssBn66lv3rZ4SuhemXx4UoNRBvtLDWstln/mUaoJB3ivGwJ
         a5zuOQZarl4rEOoH8hBu8zahUNhlYMEOC5FdNweG9iHqAvhb2zol2Pq79genNGqt6lSj
         3QmrJz5Hcul6ZvdJOy3YlD3nBJUtUUIAKC679QT7cmVhVQlVuvcPrcIBWTayOjuMGcfZ
         6p+99Hb40wwY5HMZQEdud7KJ13qczJmUQX+ncMpwo6/h7y2pp+6szN7Fh98DYBfcUYFI
         unh6UXy4/nHCydDWTlCS6UJ1RyFOx8UbHjTFDycODha+JDHJJDxdkfrWujXYyTQ0edL8
         ALcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1JSrthhCNHix8X49ZrSHsK+j5HmL4LI/jDszyOYaask=;
        b=mr57Zydx1Nbt/X88J/9HmAMzOM8NiVJA/uQn3v+z6riqSx0IW9A+i5Ge6Mup3owBSP
         5LdGpJQE/2N7K0sUROP91vzuvlI583gXp1NWYdiSqj36FwJGHA1+pBDy0iYH6xqdmvM7
         DWHSBJ8tN/vvU1Pm5I9+Ez+BRLyprWFfhAYEu1xnI5woNAmt8lGv6NblL4W+kVmYp6Yx
         bXp20rgXXY+5TSKGEOWOtNGjA1sIQlQ8VE1EKyx1HCRYwq632NmS2xw4n4eUwcY8ht3e
         NN+tpk/rTCIfDnUd2yiJuTczclqzCfKfjmHMV1B+sU+9mFrWT49eisVvhwWqWHfQ94Eq
         RO4Q==
X-Gm-Message-State: AOAM531kBAgUO81YTzeCM47+kWnTkeJqe8DbZBEcUZJzb2e7Mgx769dL
        7KEGq+ZREoD9U8vC3xV8vUI=
X-Google-Smtp-Source: ABdhPJwE/lNJ9uOh9tirhQNL2OcWZc3WizYfOvrD9D/oTL6oLFOBgOAHKk1Tsh06rVJjlKvb9WaeDA==
X-Received: by 2002:a63:e34a:: with SMTP id o10mr1694699pgj.129.1603801934528;
        Tue, 27 Oct 2020 05:32:14 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id ck21sm1852337pjb.56.2020.10.27.05.32.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2020 05:32:13 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf] xsk: fix possible memory leak at socket close
Date:   Tue, 27 Oct 2020 13:32:01 +0100
Message-Id: <1603801921-2712-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a possible memory leak at xsk socket close that is caused by the
refcounting of the umem object being wrong. The reference count of the
umem was decremented only after the pool had been freed. Note that if
the buffer pool is destroyed, it is important that the umem is
destroyed after the pool, otherwise the umem would disappear while the
driver is still running. And as the buffer pool needs to be destroyed
in a work queue, the umem is also (if its refcount reaches zero)
destroyed after the buffer pool in that same work queue.

What was missing is that the refcount also needs to be decremented
when the pool is not freed and when the pool has not even been
created. The first case happens when the refcount of the pool is
higher than 1, i.e. it is still being used by some other socket using
the same device and queue id. In this case, it is safe to decrement
the refcount of the umem outside of the work queue as the umem will
never be freed because the refcount of the umem is always greater than
or equal to the refcount of the buffer pool. The second case is if the
buffer pool has not been created yet, i.e. the socket was closed
before it was bound but after the umem was created. In this case, it
is safe to destroy the umem outside of the work queue, since there is
no pool that can use it by definition.

Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
Reported-by: syzbot+eb71df123dc2be2c1456@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 include/net/xsk_buff_pool.h | 2 +-
 net/xdp/xsk.c               | 3 ++-
 net/xdp/xsk_buff_pool.c     | 7 +++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index 0140d08..01755b8 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -86,7 +86,7 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_release(struct xdp_buff_xsk *xskb);
 void xp_get_pool(struct xsk_buff_pool *pool);
-void xp_put_pool(struct xsk_buff_pool *pool);
+bool xp_put_pool(struct xsk_buff_pool *pool);
 void xp_clear_dev(struct xsk_buff_pool *pool);
 void xp_add_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_del_xsk(struct xsk_buff_pool *pool, struct xdp_sock *xs);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index b71a32e..cfbec39 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -1146,7 +1146,8 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;

-	xp_put_pool(xs->pool);
+	if (!xp_put_pool(xs->pool))
+		xdp_put_umem(xs->umem);

 	sk_refcnt_debug_dec(sk);
 }
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 64c9e55..8a3bf4e 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -251,15 +251,18 @@ void xp_get_pool(struct xsk_buff_pool *pool)
 	refcount_inc(&pool->users);
 }

-void xp_put_pool(struct xsk_buff_pool *pool)
+bool xp_put_pool(struct xsk_buff_pool *pool)
 {
 	if (!pool)
-		return;
+		return false;

 	if (refcount_dec_and_test(&pool->users)) {
 		INIT_WORK(&pool->work, xp_release_deferred);
 		schedule_work(&pool->work);
+		return true;
 	}
+
+	return false;
 }

 static struct xsk_dma_map *xp_find_dma_map(struct xsk_buff_pool *pool)
--
2.7.4
