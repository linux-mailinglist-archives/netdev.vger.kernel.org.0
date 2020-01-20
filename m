Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C7F142D06
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 15:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgATOTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 09:19:02 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:37269 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgATOTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 09:19:02 -0500
X-Originating-IP: 84.44.14.226
Received: from nexussix.ar.arcelik (unknown [84.44.14.226])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id B2ED4C000E;
        Mon, 20 Jan 2020 14:18:57 +0000 (UTC)
From:   Cengiz Can <cengiz@kernel.wtf>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Cengiz Can <cengiz@kernel.wtf>
Subject: [PATCH] tools: perf: add missing unlock to maps__insert error case
Date:   Mon, 20 Jan 2020 17:15:54 +0300
Message-Id: <20200120141553.23934-1-cengiz@kernel.wtf>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`tools/perf/util/map.c` has a function named `maps__insert` that
acquires a write lock if its in multithread context.

Even though this lock is released when function successfully completes,
there's a branch that is executed when `maps_by_name == NULL` that
returns from this function without releasing the write lock.

Added an `up_write` to release the lock when this happens.

Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
---

Hello Arnaldo,

I'm not exactly sure about the order that we must call up_write here.

Please tell me if the `__maps__free_maps_by_name` frees the
`rw_semaphore`. If that's the case, should we change the order to unlock and free?

Thanks!

 tools/perf/util/map.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index fdd5bddb3075..f67960bedebb 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -549,6 +549,7 @@ void maps__insert(struct maps *maps, struct map *map)

 			if (maps_by_name == NULL) {
 				__maps__free_maps_by_name(maps);
+				up_write(&maps->lock);
 				return;
 			}

--
2.25.0

