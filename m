Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57342A1211
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgJaAjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgJaAir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 20:38:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EBCC0613D7;
        Fri, 30 Oct 2020 17:38:46 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id m17so144350pjz.3;
        Fri, 30 Oct 2020 17:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JN/b5liJNkCYHBYSnEufh73PPTqkvt+38op/HGk1BXE=;
        b=MaIkNRuDg5P7ZUvDC1p/js4ftSjHx4hFdH9TMRAPIh+bS/umoAdpht5Qw2Mdd3jKaR
         284Ytc7iwB/qAQsRKzvpbHVzel5HPjSmxlPW7YLzPeqj+kY8m253nSNJcYIesHWl7WoG
         gpOlUGEp5jQOmBZTWQ6zAeaCzkE6D5g1WN+DQNdE/E66YCBRtGrVTslJWRD8RdSDuayW
         DiGcySG/Yfn8e/x6kEl+M590ha99nqbJ/B0dWj3rsROk4j6Z0/ZLcqjSI9QLr1dFBbRM
         ILgiec9tcoHjLsGGcCa4HEkqph7zo35LW267H1V3OJjNQq9TcQGppeGVHXXA5H84RI/c
         8jHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JN/b5liJNkCYHBYSnEufh73PPTqkvt+38op/HGk1BXE=;
        b=I+W9ll2ZzQSJrn32nVmD4LFTOhoM9krY/hcJNEjPtU2GrknFFm6yqw5fOcc7Xee4EN
         HHlvWh6zc8mBVj8zlVHzj7yTXU07C+Tk/IKYXoh3Akcwb4Ny65ZKJaoKtzAXmVC0zbPS
         bVCVo7ZUoqvGJIxGFLpExNPEn8T82TSNoTD7Lfvj8WZQkZbFfm1h/f80hmJ6cgMj6KOn
         jL79QdaCPUzkgaBCGiNWhZEVPcQ9KFj6Pv81yXeulBLWNt6669tK6Xu5cnJXIjuxcVPP
         15bHtT1b+RIzh+U67vDdQQk/3QgrW9vRCXk9NOJA0KP7H8M+Ph6B7tvtbnlMXwK4JS1d
         ZzpQ==
X-Gm-Message-State: AOAM5308D2Hf1ZCtMoAeQKg/mIX2zWrU5rIL6YzAc6p2rFQMvUSxq3b9
        QwGEAM9iHr1cQMwFaXSlTGA=
X-Google-Smtp-Source: ABdhPJzZmVkGgVyH17eHpMWeIi4GBYbB/v7ibwq185wF7aPSXAuj73Gu+KuWAkhILs7VWKDfB/xbCw==
X-Received: by 2002:a17:902:a589:b029:d6:856a:2978 with SMTP id az9-20020a170902a589b02900d6856a2978mr11152069plb.67.1604104726319;
        Fri, 30 Oct 2020 17:38:46 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:48fd:1408:262f:a64b])
        by smtp.gmail.com with ESMTPSA id ch21sm4596888pjb.24.2020.10.30.17.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 17:38:45 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Krzysztof Halasa <khc@pm.waw.pl>
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v5 3/5] net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC devices
Date:   Fri, 30 Oct 2020 17:37:29 -0700
Message-Id: <20201031003731.461437-4-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031003731.461437-1-xie.he.0141@gmail.com>
References: <20201031003731.461437-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an skb is received on a normal (non-Ethernet-emulating) PVC device,
call skb_reset_mac_header before we pass it to upper layers.

This is because normal PVC devices don't have header_ops, so any header we
have would not be visible to upper layer code when sending, so the header
shouldn't be visible to upper layer code when receiving, either.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_fr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 71ee9b60d91b..eb83116aa9df 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -935,6 +935,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IP);
+		skb_reset_mac_header(skb);
 
 	} else if (data[3] == NLPID_IPV6) {
 		if (!pvc->main)
@@ -942,6 +943,7 @@ static int fr_rx(struct sk_buff *skb)
 		skb_pull(skb, 4); /* Remove 4-byte header (hdr, UI, NLPID) */
 		skb->dev = pvc->main;
 		skb->protocol = htons(ETH_P_IPV6);
+		skb_reset_mac_header(skb);
 
 	} else if (skb->len > 10 && data[3] == FR_PAD &&
 		   data[4] == NLPID_SNAP && data[5] == FR_PAD) {
@@ -958,6 +960,7 @@ static int fr_rx(struct sk_buff *skb)
 				goto rx_drop;
 			skb->dev = pvc->main;
 			skb->protocol = htons(pid);
+			skb_reset_mac_header(skb);
 			break;
 
 		case 0x80C20007: /* bridged Ethernet frame */
-- 
2.27.0

