Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A1C4EBF0
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUPZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:25:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbfFUPZy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:25:54 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4CD4D3082B67;
        Fri, 21 Jun 2019 15:25:54 +0000 (UTC)
Received: from T460ec.redhat.com (ovpn-116-108.ams2.redhat.com [10.36.116.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA8756090E;
        Fri, 21 Jun 2019 15:25:50 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com
Subject: [PATCH bpf-next] libbpf: add xsk_ring_prod__free() function
Date:   Fri, 21 Jun 2019 17:25:48 +0200
Message-Id: <49d3ddb42f531618584f60c740d9469e5406e114.1561130674.git.echaudro@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 21 Jun 2019 15:25:54 +0000 (UTC)
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
 tools/lib/bpf/xsk.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a0f3ec..86f3d485e957 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -95,6 +95,12 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
 	return r->cached_cons - r->cached_prod;
 }
 
+static inline __u32 xsk_ring_prod__free(struct xsk_ring_prod *r)
+{
+	r->cached_cons = *r->consumer + r->size;
+	return r->cached_cons - r->cached_prod;
+}
+
 static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 {
 	__u32 entries = r->cached_prod - r->cached_cons;
-- 
2.20.1

