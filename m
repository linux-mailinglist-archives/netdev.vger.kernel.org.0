Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0604A1E0866
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387941AbgEYIEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387807AbgEYIEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:04:25 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0201AC061A0E;
        Mon, 25 May 2020 01:04:25 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f21so5373560pgg.12;
        Mon, 25 May 2020 01:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OMcD6XNHpVb4lacePOdo/rE18+iLuc+4mEImQrhoTNs=;
        b=Zes3Uz9lypw63iz50yk+D+/L836Fzh/13qv8blPLh6AMjg+/vJ0wjdVaD01QpnrIPZ
         mEKSAPE2qXhLBeRNQD7fOkdQ1AIUcP2cmrXiN/EGLosPyEoNHpGQCA8XU849gqjZUoO1
         mhaFyal9X5gUUo3FIUSFnix/eQElBBQqwcM6KjbRgcgkzGfsxMkc6nBnN/ouqGnV6Miq
         fnaun6KSUAPkLv0FlFk/RKE+E8rkOg/sMuziVzFHs9nkKar7/fQn2l4WD/x1ksPd0hon
         GpRw/0iVcfkTDiyXc44Gx2Bu4CvfaIjQU6e3M2TGUbIsfDK9/ZL153i0h5uPmYui92SG
         I82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OMcD6XNHpVb4lacePOdo/rE18+iLuc+4mEImQrhoTNs=;
        b=U98TrnSVI5WBvRI4McrNfLAuOEBPGNr1D93XzS99dH8AtHnyDoKdPoCqQb/Fzbjn/R
         0b7X3UxjunoiDjrq+ht+2ZXKimCYB5dE7g/5UwR/s0+nG9y4F6HVkhuMNjyxNEeOxX9O
         RQv7IIkZbLb7fFLyOByvhmI+sR9mUsNa2THwmgJerQF1YNMiZCVmaRahzhGltuPN7oq8
         iz47L4Ug40ldlSq5hcWVNM7NQxsOg8ON2a7UnS9ucFC3stVDSicr9SDBnkCzQejP5ekW
         hlfmolDj4WnjIGp54fHKVC6eUQsSsjc+MHWtp/5hd0EhrscASwrooSjaBRiUMwhgGjbZ
         UVhA==
X-Gm-Message-State: AOAM533KzENDfqJVNXNjTrm4d9gI1XpKngMBxo+9GRk0opkcidj1xu4n
        93Xeq7XZkZ0Vpi0mqC1MyG4=
X-Google-Smtp-Source: ABdhPJx7kAsmj8qo8AgkJFRnVqYtFp7l0+6zcxTgxGfPKoB/qiFUZjr+Vp+QMDLdyIqfnDUroAWEhQ==
X-Received: by 2002:a62:a518:: with SMTP id v24mr14926568pfm.295.1590393864494;
        Mon, 25 May 2020 01:04:24 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id k29sm11453316pgf.77.2020.05.25.01.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 01:04:23 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com,
        =?UTF-8?q?Minh=20B=C3=B9i=20Quang?= <minhquangbui99@gmail.com>
Subject: [PATCH bpf] xsk: add overflow check for u64 division, stored into u32
Date:   Mon, 25 May 2020 10:03:59 +0200
Message-Id: <20200525080400.13195-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The npgs member of struct xdp_umem is an u32 entity, and stores the
number of pages the UMEM consumes. The calculation of npgs

  npgs = size / PAGE_SIZE

can overflow.

To avoid overflow scenarios, the division is now first stored in a
u64, and the result is verified to fit into 32b.

An alternative would be storing the npgs as a u64, however, this
wastes memory and is an unrealisticly large packet area.

Link: https://lore.kernel.org/bpf/CACtPs=GGvV-_Yj6rbpzTVnopgi5nhMoCcTkSkYrJHGQHJWFZMQ@mail.gmail.com/
Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt")
Reported-by: "Minh Bùi Quang" <minhquangbui99@gmail.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xdp_umem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index ed7a6060f73c..3889bd9aec46 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -341,8 +341,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
 	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
+	u64 npgs, addr = mr->addr, size = mr->len;
 	unsigned int chunks, chunks_per_page;
-	u64 addr = mr->addr, size = mr->len;
 	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -372,6 +372,10 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if ((addr + size) < addr)
 		return -EINVAL;
 
+	npgs = div_u64(size, PAGE_SIZE);
+	if (npgs > U32_MAX)
+		return -EINVAL;
+
 	chunks = (unsigned int)div_u64(size, chunk_size);
 	if (chunks == 0)
 		return -EINVAL;
@@ -391,7 +395,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->size = size;
 	umem->headroom = headroom;
 	umem->chunk_size_nohr = chunk_size - headroom;
-	umem->npgs = size / PAGE_SIZE;
+	umem->npgs = (u32)npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;

base-commit: d04322a0da1e86aedaa322ce933cfb8c0191d1eb
-- 
2.25.1

