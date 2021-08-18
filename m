Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DB83EF808
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 04:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhHRCXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 22:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbhHRCXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 22:23:17 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774D0C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:22:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id c4so868244plh.7
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 19:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nUTRJq9UadwH99/d1kuhebEbaWd7uB4U5gW7j+M7gA0=;
        b=pKmjcCmfMRgBqnAm1OpGQ0XmXwKi2xgDsTcFs4BnZMTHFWm0kDuYRsKt6lltn02knG
         pwFfpmL/XT0MX7if8BADUxmkKgKwtB3PbGDLeR/tWuc8xgrsgmzlnecAyekT6kg9O/Hm
         rSP8/0TOjWq5ZC7e4FSEKJd0Mjfb3yAQn44j9XcNh1dTZ/IaF8eYenKPq2NstDbbY4u8
         Ahjp9HC/s7qkOCWWV3hWqopRpmbHjr9ptNkblSPCo9AVemWBORkDKap2BmRiZ21BvQPy
         MUb3VAsdOq9jizy+lgh4EC/2uRmZJ2TifBkk5Bt5m10DBzUlalnRzPyvjuYviRI5Y1m6
         PbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nUTRJq9UadwH99/d1kuhebEbaWd7uB4U5gW7j+M7gA0=;
        b=qN5W4G6AewtqamFrN/C1tbRTr1egn2+GINE5ARAR/BTzerL5FtDMyBagZWmjtkZCqU
         dcfwtofTX46canVAvNiTiZeRnAf0YmpLanbfw8gCp5OqLp4kUf/xvfEA86P00+N1FAm4
         mcPLB05XR/Y5NGc6/I1cWkF2yZTifGGT4Kz6JH2Scfr+9PofVaFT9a0TCqI3Q6tQ6gzo
         ogeX+5j7U1hmccZslrAvNYT3uX9uHEocjVR7ngEX9NRqUVnDGHcXGU/Vhk5llGbGAKzg
         FDbNp5kICaxOzhpUS8J8K8tbajsoR9PqKsJaiuCrfUsm8/aDQT4CFOfmsXRhtWZwj+/E
         Furw==
X-Gm-Message-State: AOAM530IxC4V7r0OK0db6MGd4YdrAyFXFMoEu01htFa+192YEyc8tQYH
        oeHFGzL5DI3r6KNioOcAT/gtQM0aGLLPUg==
X-Google-Smtp-Source: ABdhPJzDNf0RwID5c0mFQxo/BtQbjjnYzflEKMU9RqX6j5eUUKMR21j8EWGi3FEBO/vTNlR6TcYzuQ==
X-Received: by 2002:a17:902:ab52:b0:12d:92b8:60c7 with SMTP id ij18-20020a170902ab5200b0012d92b860c7mr5388491plb.44.1629253361939;
        Tue, 17 Aug 2021 19:22:41 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.245])
        by smtp.gmail.com with ESMTPSA id t5sm4095938pfd.133.2021.08.17.19.22.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 19:22:41 -0700 (PDT)
From:   fankaixi.li@bytedance.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     "kaixi . fan" <fankaixi.li@bytedance.com>,
        xiexiaohui <xiexiaohui.xxh@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [PATCH] ovs: clear skb->tstamp in forwarding path
Date:   Wed, 18 Aug 2021 10:22:15 +0800
Message-Id: <20210818022215.5979-1-fankaixi.li@bytedance.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: kaixi.fan <fankaixi.li@bytedance.com>

fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
doesn't clear skb->tstamp. We encountered a problem with linux
version 5.4.56 and ovs version 2.14.1, and packets failed to
dequeue from qdisc when fq qdisc was attached to ovs port.

Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
---
 net/openvswitch/vport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 88deb5b41429..cf2ce5812489 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 	}
 
 	skb->dev = vport->dev;
+	skb->tstamp = 0;
 	vport->ops->send(skb);
 	return;
 
-- 
2.20.1

