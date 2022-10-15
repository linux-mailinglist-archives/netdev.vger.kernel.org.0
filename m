Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DCF5FFC08
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 23:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiJOVbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 17:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJOVbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 17:31:15 -0400
Received: from mx01lb.world4you.com (mx01lb.world4you.com [81.19.149.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BD342ADC;
        Sat, 15 Oct 2022 14:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iyTN7fvezMmWG/MWMwiZPJ/oBANq6JEJpbtyPFg/lk0=; b=IMN2ajFPQQAS2DZOpQJ6k8GWyb
        h+i7eZc4rxeF3W3tUAwCaMmJeN/aoV+n31vh4PgUMEoDMJEP5qePW3k68qQTP09pQT5QM7DCkSPPR
        BcxwyJwGHW4Rqj4i5jmicZsO7JrhSej3y15Bblt4g6wOEDfT7G4yeuPVwyPR+c2npCHo=;
Received: from [88.117.56.108] (helo=hornet.engleder.at)
        by mx01lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ojokF-0005aY-8u; Sat, 15 Oct 2022 23:30:59 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew.gospodarek@broadcom.com, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next] samples/bpf: Fix MAC address swapping in xdp2_kern
Date:   Sat, 15 Oct 2022 23:30:50 +0200
Message-Id: <20221015213050.65222-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp2_kern rewrites and forwards packets out on the same interface.
Forwarding still works but rewrite got broken when xdp multibuffer
support has been added.

With xdp multibuffer a local copy of the packet has been introduced. The
MAC address is now swapped in the local copy, but the local copy in not
written back.

Fix MAC address swapping be adding write back of modified packet.

Fixes: 772251742262 ("samples/bpf: fixup some tools to be able to support xdp multibuffer")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 samples/bpf/xdp2_kern.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
index 3332ba6bb95f..67804ecf7ce3 100644
--- a/samples/bpf/xdp2_kern.c
+++ b/samples/bpf/xdp2_kern.c
@@ -112,6 +112,10 @@ int xdp_prog1(struct xdp_md *ctx)
 
 	if (ipproto == IPPROTO_UDP) {
 		swap_src_dst_mac(data);
+
+		if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
+			return rc;
+
 		rc = XDP_TX;
 	}
 
-- 
2.30.2

