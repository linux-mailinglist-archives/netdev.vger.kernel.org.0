Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCA83C3EC3
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 20:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhGKSfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 14:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhGKSfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 14:35:34 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2672AC0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 11:32:46 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id e1-20020a9d63c10000b02904b8b87ecc43so2163884otl.4
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 11:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rg9L3Dk0joAl/Y4W8CAVXRIHURFOXJ22e73C4jmmn+Q=;
        b=aHyaSCzrNoVtOp5+bkZjRuiaxLs1HrsTpJxw3rvZ0n/vD3Fg2RU0eSRVI/heBVCWXc
         zBAFn+mzhJhrPoxjTi4G76orIQ+fX+MLbaLtEgkwqTy81VVF3qHdwfnTU9xmCQuS5ILW
         Og4PPuriP7UiSMRGss0BZBmvGCHVXv2CeBXvBrbHjhJKMulyi4l/z3BHw6CCiWoH+P4p
         sfVzTatHgs81ibP38aPTLnXY5s2We4ecNyNHF6iT2x0NAwiGF+5cPMP68wHeB3DnLnRb
         x452RKilpeL8ljFvPnMSX13cKNgc2Hz4ieRPFipvYwcnNtwxcDA91AQGnR9qCcJbiOyj
         09nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rg9L3Dk0joAl/Y4W8CAVXRIHURFOXJ22e73C4jmmn+Q=;
        b=SNUYncyAYjnyJ9vhrJffiW91uYZC1A2soaKpjtmq+VmRLnF2nXQLWKCIOYfSs7QDTn
         zQ+S/D+htl0TtzID9r7xSn1JyLoFurLI5mYx3lH9xMk/kFWvP/oX1e+IZRK8iNEsUqBw
         qVpinYDeQzx3sV+DSfdWA4AcCMmY5b9h7J+f3xOxVfSTGVwpXRcGsJx0STmDB187Yjlt
         tgRuX47Y+6C4jL5QmYizydX6QeJPgXkk9ru6kfBfTjYl3D4K7ot5GUsWh5cyD98bxTfc
         cNIRLAQLF0m14lkLWcqgK9s+BzDvqftW1BqIsuZrwb1sEq77VG4FvpGAIalozEWouYrw
         9QHQ==
X-Gm-Message-State: AOAM533Mr99dBrStUCzTm238iYzciUlJLeBM2p13M3IoOatA5csLVDSg
        ZRV7xiBa+HstE1j2POTMCqEtBxkKaMw=
X-Google-Smtp-Source: ABdhPJz21L2vPSerHarNIdSIJ2Mt6OwIeiphZsKUCqOvgkdk+rdLAlQa+VLsbBUgHE/9IBjwEhSKqg==
X-Received: by 2002:a9d:5381:: with SMTP id w1mr37468167otg.259.1626028365319;
        Sun, 11 Jul 2021 11:32:45 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id o1sm2648675oik.19.2021.07.11.11.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 11:32:44 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next v2] net: use %px to print skb address in trace_netif_receive_skb
Date:   Sun, 11 Jul 2021 11:32:33 -0700
Message-Id: <20210711183234.7889-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

The print format of skb adress in tracepoint class net_dev_template
is changed to %px from %p, because we want to use skb address
as a quick way to identify a packet.

Note, trace ring buffer is only accessible to privileged users,
it is safe to use a real kernel address here.

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
 include/trace/events/net.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 2399073c3afc..78c448c6ab4c 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
 		__assign_str(name, skb->dev->name);
 	),
 
-	TP_printk("dev=%s skbaddr=%p len=%u",
+	TP_printk("dev=%s skbaddr=%px len=%u",
 		__get_str(name), __entry->skbaddr, __entry->len)
 )
 
-- 
2.27.0

