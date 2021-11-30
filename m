Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB55A463BBB
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 17:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244013AbhK3Qa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 11:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243855AbhK3QaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 11:30:11 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B9CC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:26:51 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id b11so18494259qvm.7
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 08:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gPMT2fxS+9TrrsJBfbhxfW0FNQ+ZCQWgBUI443gv3nw=;
        b=VA5mk80dsaeiumFzSeiNoCVI7II1ZNEN/kVE1oO3OK2atfEU+zZXcED7QrTR//GUUL
         M1yMHjbiXKdjHEEkBpM/4axlyAAKKJLoBaU/9C1hcvTuDIRgsUU1hAqHzMTV7wzjfAbA
         iDQS36vtuTrWGsVrebb9ldFqQKF345dtT6/HyQyHQRkFxOvMWRcEGMt0I7aReuK3iboD
         1+2+2bXhRdsCKOviVdyWUk5m757huEkcfYS4YDF89Ssnj7CN617VYm5AIEhbHIo5H/S/
         UcP+mejmgKo9xZMVp6AxJ1HLXIDSy22kzSnHMF5QuwFFVME46szeW0xpA3oeQUNBeyiT
         lsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gPMT2fxS+9TrrsJBfbhxfW0FNQ+ZCQWgBUI443gv3nw=;
        b=asadDXs40zuKyJqjWpw0dbMiuOGO51Yp3n3MS+FJDz8wu9Z2wBjNzLXmhOYA69MR2O
         PUKKo5EOJ8VGjl12nLbpDBuTEi8c2NghFl0hJpmXlW5C8yOgvWXz24tTpXMRLjXH8MIG
         45fMa5QulXiFmtg2tuZg1dd5uQOz0nc4/6aV1XD/Qz0nyQAai/aWw5QOHY57PgxjCO7C
         zdwplju0Laa5F5wFLqiPfSaIARdXwTkIRkNWboptHl1SZbLanErAz0EGKpFaO+zlbe7C
         5mKKEWLSoFBuAKLqCWEozQuO3PCFHp5e9ZDFYbsQS3cppJCdis9tZnfjcBEg5w0FjcxN
         HsRw==
X-Gm-Message-State: AOAM531+HM8dDJO7Yta6a9VrNXf/C/fITRAJj5WVFy4I+g7fwFXmjlO9
        CpFMkON+9KWLjSdqO2cPGJgypN26+g==
X-Google-Smtp-Source: ABdhPJyBGVALdnsL1vmKQdMJEI1Xsvd03mIoDL91deFUm+Z4G2T8sE8iCsViSENd9Atkw5SE3yiuwg==
X-Received: by 2002:a05:6214:f62:: with SMTP id iy2mr51782081qvb.25.1638289611007;
        Tue, 30 Nov 2021 08:26:51 -0800 (PST)
Received: from ssuryadesk.lan ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id r16sm10849840qkp.42.2021.11.30.08.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 08:26:50 -0800 (PST)
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: [PATCH net] vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit
Date:   Tue, 30 Nov 2021 11:26:37 -0500
Message-Id: <20211130162637.3249-1-ssuryaextr@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPCB/IP6CB need to be initialized when processing outbound v4 or v6 pkts
in the codepath of vrf device xmit function so that leftover garbage
doesn't cause futher code that uses the CB to incorrectly process the
pkt.

One occasion of the issue might occur when MPLS route uses the vrf
device as the outgoing device such as when the route is added using "ip
-f mpls route add <label> dev <vrf>" command.

The problems seems to exist since day one. Hence I put the day one
commits on the Fixes tags.

Fixes: 193125dbd8eb ("net: Introduce VRF device driver")
Fixes: 35402e313663 ("net: Add IPv6 support to VRF device")
Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
---
 drivers/net/vrf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index ccf677015d5b..131c745dc701 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -497,6 +497,7 @@ static netdev_tx_t vrf_process_v6_outbound(struct sk_buff *skb,
 	/* strip the ethernet header added for pass through VRF device */
 	__skb_pull(skb, skb_network_offset(skb));
 
+	memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 	ret = vrf_ip6_local_out(net, skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		dev->stats.tx_errors++;
@@ -579,6 +580,7 @@ static netdev_tx_t vrf_process_v4_outbound(struct sk_buff *skb,
 					       RT_SCOPE_LINK);
 	}
 
+	memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 	ret = vrf_ip_local_out(dev_net(skb_dst(skb)->dev), skb->sk, skb);
 	if (unlikely(net_xmit_eval(ret)))
 		vrf_dev->stats.tx_errors++;
-- 
2.25.1

