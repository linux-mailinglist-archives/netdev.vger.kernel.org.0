Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B791521472
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbiEJMBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241329AbiEJMAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:00:51 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F01165AB;
        Tue, 10 May 2022 04:56:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m62so10032545wme.5;
        Tue, 10 May 2022 04:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pua5AB+TuiWpBNNo706/7tjcbO+td6dVP5r0dIQv+lY=;
        b=M9wWkAUKIL9gBHv74isCO7t0baGf2lxmfVjbGIcrklR7sVhEpGF19eYhDovyTbPJ4x
         S88z+u+1ZLdBwRsDePv5UjVR39HyXpGMvJB/H0ATlxc5EIVBbZywKimvKq8RlfoKyux2
         t8F7DlrxDjpF8UG0nxqBAgDgEBqtw3xBJ/bTHvWG7uCWRDmfxjTbX4GH+ORhowcz1vmt
         dDryIwnd3RAf/kEJruJTK0zYc7fI8Uufs5IuU03qb8ezpp82ye3OQ1xyb/NWIU8ORazb
         qD3nGi1bwgnfxrbneuZEVEKYmdagOifLduwoqpZMyqdrTWKEDLeSa0OAwJBX4fyCW5TL
         0LBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pua5AB+TuiWpBNNo706/7tjcbO+td6dVP5r0dIQv+lY=;
        b=xkPbayhbuezEbuAjJU2Kzwrdy79fKx2zVUmFFyE1AA6pCarK1jgITYcFKdfA8foyUv
         fK9SJ2EjymFS0ViKuEEnKPf5dAFV+T57X1F/ZYiM4uAA7HtQQd4Rok5ijvvNQa5GYExV
         8a8OmA9+AyNQ+smyHYR+QNSyxfWPLggiF/p4SUvMUs7z4hyLqWye1eA0EKasJD1uNjMt
         KCoLGWKWnx0xmn99TlIoShtX3Aab4q8j1Jkr1j3FIzJilzqrdVTludnWHHrmi+f+92Eh
         a6l/JItefZgveu2qa1iqj2yuYSNjCQUL5oBT+c+CQMMNfi5lBGEGz+0bz9RgCZ5RkW0L
         bllQ==
X-Gm-Message-State: AOAM532IOU/FNgRO4CjhCKFPE4VLadHmqHUEC88yTYYCPan25e1eK/VW
        U9X19DJehx0iykuwDW2zuSs=
X-Google-Smtp-Source: ABdhPJxzmZ5ZMTbkEo2Rs8vMkxU/XNhwlhsODdZGaqmUKZq8doHeYaGwiEsWnabWRthdF+G5BAAwDw==
X-Received: by 2002:a05:600c:2552:b0:394:65f:fbf1 with SMTP id e18-20020a05600c255200b00394065ffbf1mr21616639wma.55.1652183810725;
        Tue, 10 May 2022 04:56:50 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:50 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 2/9] selftests: xsk: do not send zero-length packets
Date:   Tue, 10 May 2022 13:55:57 +0200
Message-Id: <20220510115604.8717-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Do not try to send packets of zero length since they are dropped by
veth after commit 726e2c5929de84 ("veth: Ensure eth header is in skb's
linear part"). Replace these two packets with packets of length 60 so
that they are not dropped.

Also clean up the confusing naming. MIN_PKT_SIZE was really
MIN_ETH_PKT_SIZE and PKT_SIZE was both MIN_ETH_SIZE and the default
packet size called just PKT_SIZE. Make it consistent by using the
right define in the right place.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 14 +++++++-------
 tools/testing/selftests/bpf/xdpxceiver.h |  5 +++--
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index cfcb031323c5..218f20f135c9 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -575,7 +575,7 @@ static struct pkt *pkt_generate(struct ifobject *ifobject, u32 pkt_nb)
 
 	if (!pkt)
 		return NULL;
-	if (!pkt->valid || pkt->len < PKT_SIZE)
+	if (!pkt->valid || pkt->len < MIN_PKT_SIZE)
 		return pkt;
 
 	data = xsk_umem__get_data(ifobject->umem->buffer, pkt->addr);
@@ -677,8 +677,8 @@ static bool is_pkt_valid(struct pkt *pkt, void *buffer, u64 addr, u32 len)
 		return false;
 	}
 
-	if (len < PKT_SIZE) {
-		/*Do not try to verify packets that are smaller than minimum size. */
+	if (len < MIN_PKT_SIZE || pkt->len < MIN_PKT_SIZE) {
+		/* Do not try to verify packets that are smaller than minimum size. */
 		return true;
 	}
 
@@ -1282,10 +1282,10 @@ static void testapp_single_pkt(struct test_spec *test)
 static void testapp_invalid_desc(struct test_spec *test)
 {
 	struct pkt pkts[] = {
-		/* Zero packet length at address zero allowed */
-		{0, 0, 0, true},
-		/* Zero packet length allowed */
-		{0x1000, 0, 0, true},
+		/* Zero packet address allowed */
+		{0, PKT_SIZE, 0, true},
+		/* Allowed packet */
+		{0x1000, PKT_SIZE, 0, true},
 		/* Straddling the start of umem */
 		{-2, PKT_SIZE, 0, false},
 		/* Packet too large */
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 62a3e6388632..37ab549ce5fe 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -25,9 +25,10 @@
 #define MAX_TEARDOWN_ITER 10
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
-#define MIN_PKT_SIZE 64
+#define MIN_ETH_PKT_SIZE 64
 #define ETH_FCS_SIZE 4
-#define PKT_SIZE (MIN_PKT_SIZE - ETH_FCS_SIZE)
+#define MIN_PKT_SIZE (MIN_ETH_PKT_SIZE - ETH_FCS_SIZE)
+#define PKT_SIZE (MIN_PKT_SIZE)
 #define IP_PKT_SIZE (PKT_SIZE - sizeof(struct ethhdr))
 #define IP_PKT_VER 0x4
 #define IP_PKT_TOS 0x9
-- 
2.34.1

