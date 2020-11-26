Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9CC2C5178
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 10:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389719AbgKZJhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 04:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389633AbgKZJhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 04:37:47 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DFDC0613D4;
        Thu, 26 Nov 2020 01:37:47 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m9so1262735pgb.4;
        Thu, 26 Nov 2020 01:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=05yC4RFsIGTfcpN6kDZHIOGx5M/LBqIoRBXgG3kCTno=;
        b=EKf2L//RC9rc76OhMlxsP8kgYNX7bhPPEaFKpUarDq5pFeEZDP+85thbHlF9Z3hXGC
         n4ez6O7KeK5mSwpPQO2WgyL2wdcy57fLZAc0chQsIkiuB9vsALl701QLV82vhQ65tmhf
         JpgfcI4Y4LeB6CcACQRqruOhsx3CMCKGospMsm7w6Iy10yzfH8kv48sOMiFiz7Y2X/iG
         qTfJlFLgcZVhr3j6kx3Vyx/51z+Q5tLTU7P/mSEqFYeyI9Q/4RXbK0m23tlE/mIY6clI
         +xNR+0mqJV5PwIKChyvgVJMWzEhX9Y3ZVCVhxDTzftaMkfDpCvJLyP0NmyYyS5+UjaNo
         f8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=05yC4RFsIGTfcpN6kDZHIOGx5M/LBqIoRBXgG3kCTno=;
        b=XsT/BDdD6VXgPwaBO8OxF3KQXqN9kXOZj19lrsR5rmjSud788J4A6r1sPn84iGa2hK
         c6nbKdo37D8yvEwGnX/rhk+8uz6Z+bQzE/VpdKJtODkNCfgTGPzCrqmp2pXtl9bprD1X
         ksQIRDBrftviL0DbKZOrPEvJWTGCVUppi2peEcuBg9NuU8IapyUWJSz/hqjRLkLU4hfZ
         /2Qv/6AnerbLmL22HCZONZw13L6iEB+r0djvjkyR/e7r1xYjDWz5R+Cbs+ZtJkgfOEu5
         bcRqPCxAfcON02ldxga7E4yF3i+x8K6u+ZF/bZheIgFRay4Om8DcYgZVHAglJqUabx8W
         Opqg==
X-Gm-Message-State: AOAM530nsIIAH6ahR9br9I30IRJAqiqVyG3WmCTp3NGfiMiH7lGuBJVa
        ZBThpw3i2Yy/sghLKOAAzuM=
X-Google-Smtp-Source: ABdhPJxj7Yny+1x/twRHNnla0hC8DS4pX60QhstphitRJjmgqse/RQY6YSCB2QwflrrM+RlpSrsoXQ==
X-Received: by 2002:a17:90a:3cc4:: with SMTP id k4mr2750325pjd.106.1606383467370;
        Thu, 26 Nov 2020 01:37:47 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id q72sm4250969pfq.62.2020.11.26.01.37.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Nov 2020 01:37:46 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: replace size_t with __u32 in xsk interfaces
Date:   Thu, 26 Nov 2020 10:37:35 +0100
Message-Id: <1606383455-8243-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Replace size_t with __u32 in the xsk interfaces that contain
this. There is no reason to have size_t since the internal variable
that is manipulated is a __u32. The following APIs are affected:

__u32 xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb,
                             __u32 *idx)
void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
__u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
void xsk_ring_cons__cancel(struct xsk_ring_cons *cons, __u32 nb)
void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)

The "nb" variable and the return values have been changed from size_t
to __u32.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/lib/bpf/xsk.h | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 1719a327e5f9..5865e082ba0b 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -113,8 +113,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 	return (entries > nb) ? nb : entries;
 }
 
-static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
-					    size_t nb, __u32 *idx)
+static inline __u32 xsk_ring_prod__reserve(struct xsk_ring_prod *prod, __u32 nb, __u32 *idx)
 {
 	if (xsk_prod_nb_free(prod, nb) < nb)
 		return 0;
@@ -125,7 +124,7 @@ static inline size_t xsk_ring_prod__reserve(struct xsk_ring_prod *prod,
 	return nb;
 }
 
-static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, size_t nb)
+static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
 {
 	/* Make sure everything has been written to the ring before indicating
 	 * this to the kernel by writing the producer pointer.
@@ -135,10 +134,9 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, size_t nb)
 	*prod->producer += nb;
 }
 
-static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
-					 size_t nb, __u32 *idx)
+static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
 {
-	size_t entries = xsk_cons_nb_avail(cons, nb);
+	__u32 entries = xsk_cons_nb_avail(cons, nb);
 
 	if (entries > 0) {
 		/* Make sure we do not speculatively read the data before
@@ -153,13 +151,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
 	return entries;
 }
 
-static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
-					 size_t nb)
+static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons, __u32 nb)
 {
 	cons->cached_cons -= nb;
 }
 
-static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
+static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
 {
 	/* Make sure data has been read before indicating we are done
 	 * with the entries by updating the consumer pointer.
-- 
2.7.4

