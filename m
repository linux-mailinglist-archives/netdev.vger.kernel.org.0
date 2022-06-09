Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE27F5455EA
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 22:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbiFIUra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 16:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345132AbiFIUr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 16:47:28 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB1E3A71A;
        Thu,  9 Jun 2022 13:47:25 -0700 (PDT)
Received: from SPMA-04.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 2515F973CED_2A25C5BB;
        Thu,  9 Jun 2022 20:47:23 +0000 (GMT)
Received: from mail.tu-berlin.de (bulkmail.tu-berlin.de [141.23.12.143])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-04.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id DEDEF973CC0_2A25C5AF;
        Thu,  9 Jun 2022 20:47:22 +0000 (GMT)
Received: from jt.fritz.box (77.11.250.240) by ex-02.svc.tu-berlin.de
 (10.150.18.6) with Microsoft SMTP Server id 15.2.986.22; Thu, 9 Jun 2022
 22:47:22 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next v2 0/2] Align BPF TCP CCs implementing cong_control() with non-BPF CCs
Date:   Thu, 9 Jun 2022 22:47:00 +0200
Message-ID: <20220609204702.2351369-1-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
References: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=TZXB+oAuuLA3aluMpGgggja2dnCmhr6NparVyR0TbeM=; b=UKeSCqrSy+ng2XGHKRExB+9A5ayrFMEeQDA2K3FcvCjXwpiEMkVObolK/Bcw2Oardmifk7a9Ht6j9zcbseuDk3UCMD5lG500uCu8lopS5DrEbXQ/X6cmUTE8wEyf1IR3Lqxf1uJdJVe093CySCJG46ejJB0lNZAQc7KHbqNsy+I=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series corrects some inconveniences for a BPF TCP CC that
implements and uses tcp_congestion_ops.cong_control(). Until now, such a
CC did not have all necessary write access to struct sock and
unnecessarily needed to implement cong_avoid().

---
v2:
 - Drop redundant check for required functions and just rely on
   tcp_register_congestion_control() (Martin KaFai Lau)

Jörn-Thorben Hinz (2):
  bpf: Allow a TCP CC to write sk_pacing_rate and sk_pacing_status
  bpf: Require only one of cong_avoid() and cong_control() from a TCP CC

 net/ipv4/bpf_tcp_ca.c | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

-- 
2.30.2

