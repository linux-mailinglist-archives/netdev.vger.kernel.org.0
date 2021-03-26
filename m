Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47C34ABD0
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhCZPs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:48:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55690 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhCZPsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 11:48:50 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616773728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lA6akj0v/6lF/gpbgvcBrn48UemGabieR9KKjZ0EI68=;
        b=SKzfl0HG29PUGhhd0BrGc1PDRoXephYCPQoxDiVlMCm+musAtucP/xQczIM/wI2SbvSA0y
        wosAW1NTDMzaXDDVXRPHH+MSAAkif5gMGfgKcTFFokC85DPvH/vUBsf9pl0Fi6zYtHtdeP
        ba6XVfvwGo8DW3CdDZiKWEfZbBML17BHh6/eUU4UaKjs6p9NLoU2AOlsxVDNTMLBekeBpu
        Dme5vjE5z8NzJ6Rhfdx5GexAWXR5RYTQXMjfqheA9adrbsx9q2yYPcO9Yi8GaM0B8RYeCB
        txfnxA81cWtg0GMdFayEt9JVkE/Gpg49ToEQ7TaM1xgJVdjMedgepGFU+lWJrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616773728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lA6akj0v/6lF/gpbgvcBrn48UemGabieR9KKjZ0EI68=;
        b=x+nRxoUAQ2dCOb1TessPC4ityBA9mImBvajX5T6csEHug7iXGWdTgE1TVGp3p5n1FCu7zm
        p2c8c7YssfRLCUCw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next] net/packet: Reset MAC header for direct packet transmission
Date:   Fri, 26 Mar 2021 16:48:35 +0100
Message-Id: <20210326154835.21296-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reset MAC header in case of using packet_direct_xmit(), e.g. by specifying
PACKET_QDISC_BYPASS. This is needed, because other code such as the HSR layer
expects the MAC header to be correctly set.

This has been observed using the following setup:

|$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
|$ ifconfig hsr0 up
|$ ./test hsr0

The test binary is using mmap'ed sockets and is specifying the
PACKET_QDISC_BYPASS socket option.

This patch resolves the following warning on a non-patched kernel:

|[  112.725394] ------------[ cut here ]------------
|[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
|[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)

The MAC header is also reset unconditionally in case of PACKET_QDISC_BYPASS is
not used.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/packet/af_packet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 118d585337d7..6325c9b7df38 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -241,6 +241,7 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po);
 
 static int packet_direct_xmit(struct sk_buff *skb)
 {
+	skb_reset_mac_header(skb);
 	return dev_direct_xmit(skb, packet_pick_tx_queue(skb));
 }
 
-- 
2.20.1

