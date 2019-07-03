Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C091E5E1CC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfGCKTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:19:12 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38813 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfGCKTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 06:19:10 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so1791594ljg.5
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 03:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MDAbzUanknf4PJsLEUbC0kOM1La2C83H5dJbGwjf9oQ=;
        b=BStuIp4lx39QUwMNDApesZDWOux56RQyzibqQT0WtE7sdrznGvAb4wfLUKg7QKY9EF
         0eTCQlVTVpGq5zmjqgJk8ING+02J+P6W9QmFsv+oIeQPaTglC1bDZYjQPQixp3d4U24n
         DN6gdMxbbr2uYOX5bxg/rCjNL0oMBci2siqMJpCsLP26JhrG+o4405TwBeJV8XvylUWE
         jeENo2O1Epssy5gF3zvp7rBSkac1hWxWxGFAkvJetrnYBRoVktwsQm9tnXLOFv5P72vK
         vW4oKGQlH7i00io624xFqcPZBRXTRgB1SH5a/Ei8yX76FyIDLgSvSVdNj3sq1w7xdEY2
         lPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MDAbzUanknf4PJsLEUbC0kOM1La2C83H5dJbGwjf9oQ=;
        b=SMUgnXfXeQHFG9yAFoQF2Qh5xPGRkdUkGH1RQzPgort73REZ5y4Mte+Gs6tJFcTz0x
         C1wN0V55nzPx8W71oYUBanZK1X+YAMggONN4xmrDE8/8lzuwBGZtRi6oYmB+WcboLZZd
         wtmjtIbCZ8Fff/PpSEQHgfP+vn0u8OO7mAOVTbDkMwNOhPClUKgE9mEQogu12vs2pldo
         i/Mzjh+h5/XbxUnmYZ+zFcGNsDi71xtAYUl20QloYH50V7S0d6Yru3zpG8eRCd696F4v
         csMjk2MqAmSZch75DfYyGekCSC9t4rMpYUZ83S6GUs7mEHT5Ex83CVuiXbFI+V0/nwZ5
         w9ww==
X-Gm-Message-State: APjAAAWETQIN6DvNr2cSnrlQO3+wjtDLRdhm5zZcVpToxWhFFATZhC7N
        jOjqf46rbXtu/Q2oKxRHSPN+qg==
X-Google-Smtp-Source: APXvYqxN1wVjNfcQKjJAJHaRYIheYjov2AZ1vEh8atpfySg/spYnhrwoPYJrkeC9q18VFn1eFK4sig==
X-Received: by 2002:a2e:8396:: with SMTP id x22mr7001525ljg.135.1562149148704;
        Wed, 03 Jul 2019 03:19:08 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id i9sm67267lfl.10.2019.07.03.03.19.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 03:19:08 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v6 net-next 1/5] xdp: allow same allocator usage
Date:   Wed,  3 Jul 2019 13:18:59 +0300
Message-Id: <20190703101903.8411-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
References: <20190703101903.8411-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First of all, it is an absolute requirement that each RX-queue have
their own page_pool object/allocator. And this change is intendant
to handle special case, where a single RX-queue can receive packets
from two different net_devices.

In order to protect against using same allocator for 2 different rx
queues, add queue_index to xdp_mem_allocator to catch the obvious
mistake where queue_index mismatch, as proposed by Jesper Dangaard
Brouer.

Adding this on xdp allocator level allows drivers with such dependency
change the allocators w/o modifications.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 include/net/xdp_priv.h |  2 ++
 net/core/xdp.c         | 55 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
index 6a8cba6ea79a..9858a4057842 100644
--- a/include/net/xdp_priv.h
+++ b/include/net/xdp_priv.h
@@ -18,6 +18,8 @@ struct xdp_mem_allocator {
 	struct rcu_head rcu;
 	struct delayed_work defer_wq;
 	unsigned long defer_warn;
+	unsigned long refcnt;
+	u32 queue_index;
 };
 
 #endif /* __LINUX_NET_XDP_PRIV_H__ */
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 829377cc83db..4f0ddbb3717a 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -98,6 +98,18 @@ static bool __mem_id_disconnect(int id, bool force)
 		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
 		return true;
 	}
+
+	/* to avoid calling hash lookup twice, decrement refcnt here till it
+	 * reaches zero, then it can be called from workqueue afterwards.
+	 */
+	if (xa->refcnt)
+		xa->refcnt--;
+
+	if (xa->refcnt) {
+		mutex_unlock(&mem_id_lock);
+		return true;
+	}
+
 	xa->disconnect_cnt++;
 
 	/* Detects in-flight packet-pages for page_pool */
@@ -312,6 +324,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
 	return true;
 }
 
+static struct xdp_mem_allocator *xdp_allocator_find(void *allocator)
+{
+	struct xdp_mem_allocator *xae, *xa = NULL;
+	struct rhashtable_iter iter;
+
+	if (!allocator)
+		return xa;
+
+	rhashtable_walk_enter(mem_id_ht, &iter);
+	do {
+		rhashtable_walk_start(&iter);
+
+		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
+			if (xae->allocator == allocator) {
+				xa = xae;
+				break;
+			}
+		}
+
+		rhashtable_walk_stop(&iter);
+
+	} while (xae == ERR_PTR(-EAGAIN));
+	rhashtable_walk_exit(&iter);
+
+	return xa;
+}
+
 int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 			       enum xdp_mem_type type, void *allocator)
 {
@@ -347,6 +386,20 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 		}
 	}
 
+	mutex_lock(&mem_id_lock);
+	xdp_alloc = xdp_allocator_find(allocator);
+	if (xdp_alloc) {
+		/* One allocator per queue is supposed only */
+		if (xdp_alloc->queue_index != xdp_rxq->queue_index)
+			return -EINVAL;
+
+		xdp_rxq->mem.id = xdp_alloc->mem.id;
+		xdp_alloc->refcnt++;
+		mutex_unlock(&mem_id_lock);
+		return 0;
+	}
+	mutex_unlock(&mem_id_lock);
+
 	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
 	if (!xdp_alloc)
 		return -ENOMEM;
@@ -360,6 +413,8 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
 	xdp_rxq->mem.id = id;
 	xdp_alloc->mem  = xdp_rxq->mem;
 	xdp_alloc->allocator = allocator;
+	xdp_alloc->refcnt = 1;
+	xdp_alloc->queue_index = xdp_rxq->queue_index;
 
 	/* Insert allocator into ID lookup table */
 	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);
-- 
2.17.1

