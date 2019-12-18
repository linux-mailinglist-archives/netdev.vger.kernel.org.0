Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5E1124139
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbfLRING (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:13:06 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44378 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRINF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:13:05 -0500
Received: by mail-pf1-f194.google.com with SMTP id d199so772510pfd.11
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qW0E3wcV0L7QSVwg9hdIctam4C3/RzO9fOEnybevMdg=;
        b=NHxS+v3F7/yI6+Xeibk9yX8naLh9aPg2TwtKH9+zx/Uth3yYvBC2aUOvKF4WMoRMDX
         HrAeqHe6CCN+41lyATsp8/tK1DVt5T1GiTo12GI1zGNtRHRmPKIZy7vcpcXfDmmXOrtJ
         oF7E7jK/LJvGtWuvP6LbrzC/V9DUYLl7nUiUpfV9pNaGfdKDhaigndomtB+a2OsXHIs0
         dW3FvcNoymQnTwkfxkwQdXLuhGwU/QMuawUcWI/xR4xPyjSZQl3a4+RM01KoCiES51St
         ztHvcsW7Z0R4lZuW9/ow2WB/k7ic+Rsz+gyBUDx9bcGfEKMMImXVaERGLYotSFfyY5/N
         iHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qW0E3wcV0L7QSVwg9hdIctam4C3/RzO9fOEnybevMdg=;
        b=N1A/KQ5JjY4dfuOZNuvG3+PbLnE1Ek490URyhkGsjd/fwn4SFwTHR4bBZcyv55nEkG
         lflF4GT3FoMluh9dy4Oy5ZoEmfboYQMj2UR/htj8dEevSUT20OuIScU+rkp11Br8ZAKE
         wUvQTVCDJSRUq673pj2ziZdnqQ0NqhRdAH+ZcETofIWnM0BBPoNtlJ5RPzcE5Cxa4g74
         SBsrJPzN7pw1HUhbgK2d5nLVf2Tf9sH7EtCoavt5TXV4LNqNc25k86WHJTVGn0DjUrzy
         3d8OQuqdlOVqS/1GzwGl3zCCztn18+SIy70ZZOS09fQo8SyCR6zunSQsnS+ld0bpByzC
         xr9Q==
X-Gm-Message-State: APjAAAULIgI+udSjUlDDGXLDGlTg80IOkVAAj74s3KvnlYwAqh2/m4XN
        5RmlqEqgH3ix07EGU8hFCXs=
X-Google-Smtp-Source: APXvYqyYSxaqrRD3/splVPY9DZ8/hT2HwngO8lj+4I9JyP7fcOMllfeJ3EDfilMICG1PEs0BW6aSAw==
X-Received: by 2002:a62:e814:: with SMTP id c20mr1721548pfi.2.1576656785057;
        Wed, 18 Dec 2019 00:13:05 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:13:04 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [RFC net-next 14/14] tun: run xdp prog when tun is read from file interface
Date:   Wed, 18 Dec 2019 17:10:50 +0900
Message-Id: <20191218081050.10170-15-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It handles the case when qemu performs read on tun using file
operations.

Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/tun.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 8e2fe0ad7955..0a9ac380c1b4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2335,8 +2335,10 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 			   struct iov_iter *to,
 			   int noblock, void *ptr)
 {
+	struct xdp_frame *frame;
 	ssize_t ret;
 	int err;
+	u32 act;
 
 	tun_debug(KERN_INFO, tun, "tun_do_read\n");
 
@@ -2350,6 +2352,15 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 		ptr = tun_ring_recv(tfile, noblock, &err);
 		if (!ptr)
 			return err;
+
+		if (tun_is_xdp_frame(ptr)) {
+			frame = tun_ptr_to_xdp(ptr);
+			act = tun_do_xdp_tx(tun, tfile, frame);
+		} else {
+			act = tun_do_xdp_tx_generic(tun, ptr);
+		}
+		if (act != XDP_PASS)
+			return err;
 	}
 
 	if (tun_is_xdp_frame(ptr)) {
-- 
2.21.0

