Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B98687865
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbjBBJKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbjBBJJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:09:54 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E1079F39
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:09:51 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o13so1318812pjg.2
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9fCw3ePbQ4sWf6yjA8O8Z29UEVxW6bYbx76RpPXO7aY=;
        b=QvSn8hl/YfOcJ6FUJ33/gevLAhxNPtImxPhVY9NtVFLqgJKnmAdY4fmFodpUno6RNc
         oen0Nb31vxxT6csN1kDCMM/Td1864giiGAkZEs7gW85Syn6Pj1SM9x2CZKodsLBYYUSz
         aZOTpZ9Y3lhg4gMxyjWaKs2pqWsaLiiUB4wIMa5l+2HevJulxagZJ5Tx67zZocuoTp53
         98kNK6qXTnqcFpvjdEuaciLik7dIpUAL2MYm3x+dcQFG/xkN+ZY4ApbDm44elRY3YvY4
         35ynjrCrCa1J9JoHmhwPSALH6eG7hoA8g7zkDWL25SYUeFN3Cv75MEP6szlFF8zvTaih
         A6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9fCw3ePbQ4sWf6yjA8O8Z29UEVxW6bYbx76RpPXO7aY=;
        b=ycqanJGjk8ZfkAvtMebiHHuqLBo8V1W8F4Qg/cScPWlM5Es38NxAVlkGriegwBOYS/
         fzuQr4GVOlp2+APZyTHAatWEiexADgy/yUWJifj6hiyZiJ55vXjJelZ5l31zr7RzZXJk
         JdvywmalZLzXfqI2JLiXCzAde1yKQSd1eiKjJE7OFUVrTV9TbpioBn68oTqs1JwU1AM3
         sW6f966jyc1DaJok0Fv6G1h2VmejcMiOfNrJFn9JRmuL6ZY/oZp7GUC77UrNcmuzBeJd
         i/82bfHdiXhXw/a8NCotI7Z84bXALk9kGjitdNskFmT+blgn15zf6xEb7CEkadeqg2U3
         5PDQ==
X-Gm-Message-State: AO0yUKWKyotFXRS7UEyMUq9NH+3OSKjSKwCTWu7sU8x/iy1A0GRTNWoS
        67uxzv3vvSeIHAsa5H0zuzDs8g==
X-Google-Smtp-Source: AK7set+VcV7K8yqmRf4cYf2lfFnsxI5XpYxApbh7KrJBd8QyBrfSTpMm7lizGCx4Zb9IGMEax7/M/A==
X-Received: by 2002:a17:902:e850:b0:198:a845:fbaf with SMTP id t16-20020a170902e85000b00198a845fbafmr7362979plg.48.1675328991294;
        Thu, 02 Feb 2023 01:09:51 -0800 (PST)
Received: from tyrell.hq.igel.co.jp (napt.igel.co.jp. [219.106.231.132])
        by smtp.gmail.com with ESMTPSA id ik12-20020a170902ab0c00b001929827731esm13145968plb.201.2023.02.02.01.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 01:09:51 -0800 (PST)
From:   Shunsuke Mie <mie@igel.co.jp>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shunsuke Mie <mie@igel.co.jp>
Subject: [RFC PATCH v2 4/7] tools/virtio: convert to new vringh user APIs
Date:   Thu,  2 Feb 2023 18:09:31 +0900
Message-Id: <20230202090934.549556-5-mie@igel.co.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230202090934.549556-1-mie@igel.co.jp>
References: <20230202090934.549556-1-mie@igel.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct vringh_iov is being remove, so convert vringh_test to use the
vringh user APIs. This has it change to use struct vringh_kiov instead of
the struct vringh_iov.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
---
 tools/virtio/vringh_test.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 98ff808d6f0c..6c9533b8a2ca 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -193,8 +193,8 @@ static int parallel_test(u64 features,
 			errx(1, "Could not set affinity to cpu %u", first_cpu);
 
 		while (xfers < NUM_XFERS) {
-			struct iovec host_riov[2], host_wiov[2];
-			struct vringh_iov riov, wiov;
+			struct kvec host_riov[2], host_wiov[2];
+			struct vringh_kiov riov, wiov;
 			u16 head, written;
 
 			if (fast_vringh) {
@@ -216,10 +216,10 @@ static int parallel_test(u64 features,
 				written = 0;
 				goto complete;
 			} else {
-				vringh_iov_init(&riov,
+				vringh_kiov_init(&riov,
 						host_riov,
 						ARRAY_SIZE(host_riov));
-				vringh_iov_init(&wiov,
+				vringh_kiov_init(&wiov,
 						host_wiov,
 						ARRAY_SIZE(host_wiov));
 
@@ -442,8 +442,8 @@ int main(int argc, char *argv[])
 	struct virtqueue *vq;
 	struct vringh vrh;
 	struct scatterlist guest_sg[RINGSIZE], *sgs[2];
-	struct iovec host_riov[2], host_wiov[2];
-	struct vringh_iov riov, wiov;
+	struct kvec host_riov[2], host_wiov[2];
+	struct vringh_kiov riov, wiov;
 	struct vring_used_elem used[RINGSIZE];
 	char buf[28];
 	u16 head;
@@ -517,8 +517,8 @@ int main(int argc, char *argv[])
 	__kmalloc_fake = NULL;
 
 	/* Host retreives it. */
-	vringh_iov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
-	vringh_iov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
+	vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
+	vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
 	err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
 	if (err != 1)
@@ -586,8 +586,8 @@ int main(int argc, char *argv[])
 	__kmalloc_fake = NULL;
 
 	/* Host picks it up (allocates new iov). */
-	vringh_iov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
-	vringh_iov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
+	vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
+	vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
 	err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
 	if (err != 1)
@@ -613,8 +613,8 @@ int main(int argc, char *argv[])
 		assert(err < 3 || buf[2] == (char)(i + 2));
 	}
 	assert(riov.i == riov.used);
-	vringh_iov_cleanup(&riov);
-	vringh_iov_cleanup(&wiov);
+	vringh_kiov_cleanup(&riov);
+	vringh_kiov_cleanup(&wiov);
 
 	/* Complete using multi interface, just because we can. */
 	used[0].id = head;
@@ -638,8 +638,8 @@ int main(int argc, char *argv[])
 	}
 
 	/* Now get many, and consume them all at once. */
-	vringh_iov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
-	vringh_iov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
+	vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
+	vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
 	for (i = 0; i < RINGSIZE; i++) {
 		err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
@@ -723,8 +723,8 @@ int main(int argc, char *argv[])
 		d[5].flags = 0;
 
 		/* Host picks it up (allocates new iov). */
-		vringh_iov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
-		vringh_iov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
+		vringh_kiov_init(&riov, host_riov, ARRAY_SIZE(host_riov));
+		vringh_kiov_init(&wiov, host_wiov, ARRAY_SIZE(host_wiov));
 
 		err = vringh_getdesc_user(&vrh, &riov, &wiov, getrange, &head);
 		if (err != 1)
@@ -744,7 +744,7 @@ int main(int argc, char *argv[])
 		/* Data should be linear. */
 		for (i = 0; i < err; i++)
 			assert(buf[i] == i);
-		vringh_iov_cleanup(&riov);
+		vringh_kiov_cleanup(&riov);
 	}
 
 	/* Don't leak memory... */
-- 
2.25.1

