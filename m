Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4342109BD8
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbfKZKJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:26 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37087 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfKZKJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:25 -0500
Received: by mail-pg1-f195.google.com with SMTP id b10so8756377pgd.4;
        Tue, 26 Nov 2019 02:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EWBtU+IlOUXhhtmkIhJ52D/yxzedCQhAg5N/fljwEYM=;
        b=mc9u7EWTbaAvtKBfR1FxVgVgSAqvpWaqH4I+At8oqCl0wPs4cfCfmxX5bUF+7APNl4
         Xmw2dKPJ0fdmby7ayXU98TCOKpU3tQ1wLifizZBS9IU8NwE5tsD4IoVzY5pYlcirUpf9
         GML0jDXsPkYpnJe+/RALaLB8XlL6sdizXEjybBT7EgZxdovS1whnnDXgS67wftULUchR
         O3p4sPYpo+nunkY6U7wrAUIFDpc4+vzXWVNuD0tkqqUfIITHpRM0zfXFvhm5VUEnlf0k
         FecGp1HqFADGdhQP1ea4gIcNAQRIySeCIanS7L8aCvBvaHue4K/B4u8Yk6YJPLPoV0QZ
         x0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EWBtU+IlOUXhhtmkIhJ52D/yxzedCQhAg5N/fljwEYM=;
        b=cw+bDVHiE+2qHMbMmaKvT9YDDz11I0bZ7hRBqEhSgCAlZaMKcKd8V6kl+oAMv9mv8A
         wfezoVKQSNr4IdlGlVHfV2XsPHvjbQc87iXl9EeQssMBQmTvrsWwaRWFb1OdjvjCdjbC
         8q5YvwVo2gpWBUg6Z0DRVbBBYxaZSDXzEEy+MhAKxu+L127arCnxJF5QGo+uIuXLNlGw
         RFWPy0EagwNSPZM2M3uPjzANPBOuP9VGUHL6i2393aNMVH59IXcu0UqufoCErodm9gYw
         pvSyR5n/3ahe7nVHaTtgjevmATGQPPO2eqgTM16hiLrKNaqhIxS1Z4nbtTFQTYsuZ4HK
         ekfQ==
X-Gm-Message-State: APjAAAVcEGThHZsNJTT7fftvRn7tHA2bl2VmZYc3dvozzG/WB9jREAt6
        c2uL0+88HyGHq52Z0suhe0g=
X-Google-Smtp-Source: APXvYqz49czbgi+kYj34fPF5hK5fvqdKlFHvat1AI4Q3wYxfqfWIPNVeAlyJ9wlfZ+jcUET4SjDAZg==
X-Received: by 2002:a63:6b87:: with SMTP id g129mr29079841pgc.438.1574762964825;
        Tue, 26 Nov 2019 02:09:24 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:24 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC net-next 11/18] tun: run xdp prog when tun is read from file interface
Date:   Tue, 26 Nov 2019 19:07:37 +0900
Message-Id: <20191126100744.5083-12-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
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
index 084ca95358fe..639921c10e32 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2318,8 +2318,10 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 			   struct iov_iter *to,
 			   int noblock, void *ptr)
 {
+	struct xdp_frame *frame;
 	ssize_t ret;
 	int err;
+	u32 act;
 
 	tun_debug(KERN_INFO, tun, "tun_do_read\n");
 
@@ -2333,6 +2335,15 @@ static ssize_t tun_do_read(struct tun_struct *tun, struct tun_file *tfile,
 		ptr = tun_ring_recv(tfile, noblock, &err);
 		if (!ptr)
 			return err;
+
+		if (tun_is_xdp_frame(ptr)) {
+			frame = tun_ptr_to_xdp(ptr);
+			act = tun_do_xdp_offload(tun, tfile, frame);
+		} else {
+			act = tun_do_xdp_offload_generic(tun, ptr);
+		}
+		if (act != XDP_PASS)
+			return err;
 	}
 
 	if (tun_is_xdp_frame(ptr)) {
-- 
2.20.1

