Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B45465C4B
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354955AbhLBCvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhLBCvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:51:03 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA512C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:47:41 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so2198022pjj.0
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HqsZ85E9DvKaTPtdQ0AfLXo0OZ5iGao1T0RRw0COHtM=;
        b=P2LuyLOD8UZXa7vqSOrt/fe61UbcI/VJHGKyNZhFqVmp0/ON3lKBFI8UHwhctWeqNa
         SFV66nb6tNwjcMZNmrUzjG2Qd3NWbjAAkd7zolMGzFOvb4L1d90GuhJoyZX9ge79187V
         rgqoTwaIsptnLrB1UXeeaXUKVJTQUqdfZB2h29W5i0316wV+lMMC6YusByNYCIklM3a7
         8f/YD9PKjiZMBVNSh79jWQ8qFcyscYtBnaYP/3k5bfjdFjNEms0t04Rjf8owTiQ+Flci
         flNn1l3ClKsEHF7xKnaB/u8CwfxRXIam4SLGraEvpyGsCxCtgU+s9T75VtHcYDeGf4ms
         Mqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HqsZ85E9DvKaTPtdQ0AfLXo0OZ5iGao1T0RRw0COHtM=;
        b=qL6RuoNynBZsBCXHHMV2bkzOLzNg0nEjOeyFhnyw/mj4LuMAps1+14aYKE1n1PkzpL
         vbsxLfs6uhq4CasrrUokYQpw2ZD1txAZ8ommZSQiVFtwEHVdZMFj+t9kL7R1/0hZF+RB
         7NHx0b3kBW2Jv/Dl8y34c7+3LUiIuwHPBDgW0VdtVzUuXn3fkVSHGCnRVXVrNghLYiw/
         3kvcZfrxWJ0OxoCwPJ8e92+IsD9ws4M5B2TuraJLAR9ndnbar4Vtt8cZQ+iDDKgHOu0J
         waRrS3xtZO2/j4pDCjFnEzZGH6lBTcB+in1IGTMpqpae+hldOSxOo3b3wqKi15GkKopZ
         7bRA==
X-Gm-Message-State: AOAM533HG/jubYm5v2iAsVTMwmCPjRLt2heUTFZthmj+lXwfWs9HHRhl
        iB1Fj8KuhD2AMm6tfLoOgNXBrjVX4weMvA==
X-Google-Smtp-Source: ABdhPJyRjEB4ewyWmtNd8143n3AArFCRniqZtm/F16Huk5+Sq3q6Y7hQLhiCz/+Omrod8zXaPXolJA==
X-Received: by 2002:a17:90b:4c0f:: with SMTP id na15mr2706283pjb.222.1638413261105;
        Wed, 01 Dec 2021 18:47:41 -0800 (PST)
Received: from localhost.localdomain ([111.204.182.106])
        by smtp.gmail.com with ESMTPSA id z10sm1183180pfh.188.2021.12.01.18.47.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Dec 2021 18:47:40 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, edumazet@google.com, atenart@kernel.org,
        alexandr.lobakin@intel.com, weiwan@google.com, arnd@arndb.de,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net v4 2/3] net: sched: add check tc_skip_classify in sch egress
Date:   Thu,  2 Dec 2021 10:47:22 +0800
Message-Id: <20211202024723.76257-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
References: <20211202024723.76257-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Try to resolve the issues as below:
* We look up and then check tc_skip_classify flag in net
  sched layer, even though skb don't want to be classified.
  That case may consume a lot of cpu cycles.

  Install the rules as below:
  $ for id in $(seq 1 10000); do
  $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
  $ done

  netperf:
  $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
  $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32

  Before: 152.04 tps, 0.58 Mbit/s
  After:  303.07 tps, 1.51 Mbit/s
  For TCP_RR, there are 99.3% improvement, TCP_STREAM 160.3%.

* bpf_redirect may be invoked in egress path. If we don't
  check the flags and then return immediately, the packets
  will loopback.

  $ tc filter add dev eth0 egress bpf direct-action obj \
	ifb.o sec ifb

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Antoine Tenart <atenart@kernel.org>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index d30adecc2bb2..10bad44e2ec4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3823,6 +3823,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	if (!miniq)
 		return skb;
 
+	if (skb_skip_tc_classify(skb))
+		return skb;
+
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	qdisc_skb_cb(skb)->mru = 0;
 	qdisc_skb_cb(skb)->post_ct = false;
-- 
2.27.0

