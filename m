Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7644D543ADD
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiFHRzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiFHRzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:55:14 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE7C517D7;
        Wed,  8 Jun 2022 10:55:11 -0700 (PDT)
Received: from SPMA-03.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 690BF6CC20_2A0E181B;
        Wed,  8 Jun 2022 17:50:57 +0000 (GMT)
Received: from mail.tu-berlin.de (mail.tu-berlin.de [141.23.12.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-03.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 2FA116CC17_2A0E181F;
        Wed,  8 Jun 2022 17:50:57 +0000 (GMT)
Received: from jt.fritz.box (77.183.106.143) by ex-04.svc.tu-berlin.de
 (10.150.18.8) with Microsoft SMTP Server id 15.2.986.22; Wed, 8 Jun 2022
 19:50:56 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next 2/2] bpf: Require only one of cong_avoid() and cong_control() from a TCP CC
Date:   Wed, 8 Jun 2022 19:48:43 +0200
Message-ID: <20220608174843.1936060-3-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=r/es0biJwheMd9/0Jrv0H/8TstFWSIIW0i0IHiK0hF8=; b=OADotppMlTZS/eQYL7EqbgANKGTrotXR2E/t0Y4qMeaoqa7DAfR0m5nWk+xuLHMeXKZdWfKbOPZz+lvjSeHfQYuclGLBeUIP5qunTNGsLXLZFHw4vMRmqbMIr9DoLfvQ9l8qpCMtmzpTZi7YoC9E3YZUBRi7TeGD6S75NBsGYfA=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a CC implements tcp_congestion_ops.cong_control(), the alternate
cong_avoid() is not in use in the TCP stack. Do not force a BPF CC to
implement cong_avoid() as a no-op by always requiring it.

An incomplete BPF CC implementing neither cong_avoid() nor
cong_control() will still get rejected by
tcp_register_congestion_control().

Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
---
 net/ipv4/bpf_tcp_ca.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index 1f5c53ede4e5..37290d0bf134 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -17,6 +17,7 @@ extern struct bpf_struct_ops bpf_tcp_congestion_ops;
 static u32 optional_ops[] = {
 	offsetof(struct tcp_congestion_ops, init),
 	offsetof(struct tcp_congestion_ops, release),
+	offsetof(struct tcp_congestion_ops, cong_avoid),
 	offsetof(struct tcp_congestion_ops, set_state),
 	offsetof(struct tcp_congestion_ops, cwnd_event),
 	offsetof(struct tcp_congestion_ops, in_ack_event),
-- 
2.30.2

