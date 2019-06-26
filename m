Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F241564A7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfFZIdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:33:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfFZIdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 04:33:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8DC33088DB5;
        Wed, 26 Jun 2019 08:33:32 +0000 (UTC)
Received: from T460ec.redhat.com (ovpn-117-229.ams2.redhat.com [10.36.117.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FB435D9C6;
        Wed, 26 Jun 2019 08:33:30 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        magnus.karlsson@gmail.com
Subject: [PATCH bpf-next v2] libbpf: add xsk_ring_prod__nb_free() function
Date:   Wed, 26 Jun 2019 10:33:16 +0200
Message-Id: <d4692ea57ba7a3fe33549fc6222fb8aea5a4225e.1561537968.git.echaudro@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Wed, 26 Jun 2019 08:33:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an AF_XDP application received X packets, it does not mean X
frames can be stuffed into the producer ring. To make it easier for
AF_XDP applications this API allows them to check how many frames can
be added into the ring.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---

v1 -> v2
 - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
 - Add caching so it will only touch global state when needed

 tools/lib/bpf/xsk.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a0f3ec..6acb81102346 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -76,11 +76,11 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
 	return &descs[idx & rx->mask];
 }
 
-static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
+static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
 {
 	__u32 free_entries = r->cached_cons - r->cached_prod;
 
-	if (free_entries >= nb)
+	if (free_entries >= nb && nb != 0)
 		return free_entries;
 
 	/* Refresh the local tail pointer.
@@ -110,7 +110,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
 					    size_t nb, __u32 *idx)
 {
-	if (xsk_prod_nb_free(prod, nb) < nb)
+	if (xsk_prod__nb_free(prod, nb) < nb)
 		return 0;
 
 	*idx = prod->cached_prod;
-- 
2.20.1

