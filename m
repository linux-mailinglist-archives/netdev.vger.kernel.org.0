Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B525E48E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfGCMwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:52:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45964 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCMwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 08:52:39 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA2DC356E4;
        Wed,  3 Jul 2019 12:52:38 +0000 (UTC)
Received: from T460ec.redhat.com (ovpn-116-169.ams2.redhat.com [10.36.116.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADD977BE6C;
        Wed,  3 Jul 2019 12:52:36 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii.nakryiko@gmail.com,
        magnus.karlsson@gmail.com
Subject: [PATCH bpf-next v3] libbpf: add xsk_ring_prod__nb_free() function
Date:   Wed,  3 Jul 2019 14:52:32 +0200
Message-Id: <ea49f66f73aedcdade979605dab6b2474e2dc4cb.1562145300.git.echaudro@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 03 Jul 2019 12:52:38 +0000 (UTC)
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

v2 -> v3
 - Removed cache by pass option

v1 -> v2
 - Renamed xsk_ring_prod__free() to xsk_ring_prod__nb_free()
 - Add caching so it will only touch global state when needed

 tools/lib/bpf/xsk.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a0f3ec..3411556e04d9 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -76,7 +76,7 @@ xsk_ring_cons__rx_desc(const struct xsk_ring_cons *rx, __u32 idx)
 	return &descs[idx & rx->mask];
 }
 
-static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
+static inline __u32 xsk_prod__nb_free(struct xsk_ring_prod *r, __u32 nb)
 {
 	__u32 free_entries = r->cached_cons - r->cached_prod;
 
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

