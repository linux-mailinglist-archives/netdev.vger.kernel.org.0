Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEF847AE84
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 16:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238758AbhLTPBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 10:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239301AbhLTO6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 09:58:32 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6910EC061379
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:50:31 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id 193so9498991qkh.10
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 06:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mDhxT8Hnj7gdcBCL0K+pdhDn9kvhoiJ03wVufpwf0qM=;
        b=Lxw3o758FX5vV5HNs425cW4rx0MS+JIG3XnViQUsJFj35tbvmUlpsCjGp87BIx0zVB
         +8LnXO3cWqC+5KiY5y338f1Hk0q58ZLVphqGgCvg8moKNJnjF0MfRQ8WjDtCqdvbv6jy
         btUNCrhlwXztSuknfyouDWc9Xra+rCTjzigRzSboA5r3WpGc1Wkk/noouS/Ljbg/1Guc
         Yg2wWyr7+0ryXKUcT1UCTW8HMbUoXwKpuI0IT4/89zB9h+0wyJMT2YUK6E5Fdctc6V+C
         vp6lEjp72L5e5rY8nXpUYlU2+dL/166ObIqJM1X078lWoc7sfuN1wwHPkQTH6jUry9PU
         Astw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mDhxT8Hnj7gdcBCL0K+pdhDn9kvhoiJ03wVufpwf0qM=;
        b=Xtp/ZWZlcYQUKwZPtFNX6P4ct5o+djVrresqVp+dwNsnp+F4oLqHJyFWtt3dyvMl9I
         2imVgGZ3HNeOo6PxwUu97aFAN6G16X/q6ALSD1Q7KAb1riIMmxtF+9QSL9lV9SF+Yuiq
         0fnRim8Ueqketucdr6J7XUFcv7YrPHLX1Lrrw4i8YMW19T8wdgzWYp7RIKL4iejqpyjl
         7jb2xttP4tug7uveznXwrqiBoVA+gTxegbw26YlThGIiDWFD0GEN0QWHZxUN08KLdOmK
         uPYRiech1H0WKuNJ18MAWF4uaPNIFzckvvp8r77tzdvPWxn7mDKFDrmi4NhULjJeQk18
         nzzg==
X-Gm-Message-State: AOAM532GWVg/Df5IBikes7+dRIXplY5LKQH3yvXdRwChKcdgry44LIoR
        OOnUGpIDHCBY4n0pUnwC2rdyVUitdcM=
X-Google-Smtp-Source: ABdhPJxka5xayh9UC2vXsR9kqRKxQjAof3th2kX9WcQRZipau3AqLuWnDC0sn6IZPfQw8CpJ+zhcQA==
X-Received: by 2002:a05:620a:c4e:: with SMTP id u14mr9339195qki.714.1640011830611;
        Mon, 20 Dec 2021 06:50:30 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id l22sm14194939qtj.68.2021.12.20.06.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 06:50:30 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        jianfeng.tan@linux.alibaba.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] net: skip virtio_net_hdr_set_proto if protocol already set
Date:   Mon, 20 Dec 2021 09:50:27 -0500
Message-Id: <20211220145027.2784293-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

virtio_net_hdr_set_proto infers skb->protocol from the virtio_net_hdr
gso_type, to avoid packets getting dropped for lack of a proto type.

Its protocol choice is a guess, especially in the case of UFO, where
the single VIRTIO_NET_HDR_GSO_UDP label covers both UFOv4 and UFOv6.

Skip this best effort if the field is already initialized. Whether
explicitly from userspace, or implicitly based on an earlier call to
dev_parse_header_protocol (which is more robust, but was introduced
after this patch).

Fixes: 9d2f67e43b73 ("net/packet: fix packet drop as of virtio gso")
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 22dd48c82560..a960de68ac69 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -25,6 +25,9 @@ static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 					   const struct virtio_net_hdr *hdr)
 {
+	if (skb->protocol)
+		return 0;
+
 	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 	case VIRTIO_NET_HDR_GSO_UDP:
-- 
2.34.1.173.g76aa8bc2d0-goog

