Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC8E2F7594
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbhAOJhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbhAOJhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:37:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4699C0613D3;
        Fri, 15 Jan 2021 01:37:04 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id x18so4412862pln.6;
        Fri, 15 Jan 2021 01:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6y2PAyUtL03Nbrmo9xCdhafDQCYKT4PC/qS4knYVGiM=;
        b=hwltHPYFd2W+GcK7Vzqd6MSZF6ZrtrHJPAyvYuEOZID3gI6rcpRwdHNIhm2sMxTRIb
         rNUbhnpJ4H4psQblSK3w26bafNsfQQYiJh+dxNh/QktdwcvENqJ6jn+CWDB1m4wvyc2N
         QrNkccRLn7ZEPC9S9ypmDawMvb6jywu5mZY9yDcRUJq66UZ8jbB/EmLqLNRhoyvVmpl6
         aJAgyu54fUInL2XO+spe2ve3bdYHRdLqICcWZsgah2ChIvA+EVLHrjQ/cHvi7aBE0LRS
         CuG9SuM/Y3VQ3NHbI87l+TBJ79XHGiYidrZrQzTvzQxDKcSiImWX23cguyw50QAL3eWY
         TmNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6y2PAyUtL03Nbrmo9xCdhafDQCYKT4PC/qS4knYVGiM=;
        b=YCz5x/ec2O7Md2lbPPdCpMlnNBBkKnOtU9GkrP0PxfSE3Qlrk6cUFbLhIjmT77ElFi
         sWMrZ61N6iCVg/CdOokWONM4F9QEi0tCJGQl36iEmQQikCSvDL+Fcdv/kvE4zDsdRzMU
         afuSllwXc0+6YwPOVR2JCUjA1WesnWZDLHuVXfFAERi8AD9Kl9mB8evDjxyvnuIjBeYM
         5eaA5JvcB6cd0J5lZGCdRgcJQqnE/PXqmZWK9ld7gV55w1duIhjeSjl8zlR2uPlxXrF0
         OV+56dqpGvlGSJxj/WVevmTEgfkdJBh/Ak2Cmc3T1keLJQ6N9f3/5dfDeErj3LeqfAdo
         AsDw==
X-Gm-Message-State: AOAM531NaAhBN0KsFT+SmzYqK1VMZgYftyVYILyQNvqMEzEnyoIoQ/GF
        WISqgFBwsXiOqt6x12Qzt8gJEiyUM/5lQg==
X-Google-Smtp-Source: ABdhPJzGP5v9Rj+D1hzOSXYgAbwpN47Hhs5WJWWg07+//oaPf9hFN0Q9md7Kx1RhCg+mM8/d8ba1oQ==
X-Received: by 2002:a17:902:a517:b029:de:79a7:48d9 with SMTP id s23-20020a170902a517b02900de79a748d9mr692150plq.45.1610703424148;
        Fri, 15 Jan 2021 01:37:04 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g2sm8669740pjd.18.2021.01.15.01.37.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 01:37:03 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCHv3 net-next 2/2] sctp: remove the NETIF_F_SG flag before calling skb_segment
Date:   Fri, 15 Jan 2021 17:36:39 +0800
Message-Id: <0aeb3e215c9e47a0bdd87c9d5cc81560e2f71d23.1610703289.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610703289.git.lucien.xin@gmail.com>
References: <cover.1610703289.git.lucien.xin@gmail.com>
 <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610703289.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610703289.git.lucien.xin@gmail.com>
References: <cover.1610703289.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes more sense to clear NETIF_F_SG instead of set it when
calling skb_segment() in sctp_gso_segment(), since SCTP GSO is
using head_skb's fraglist, of which all frags are linear skbs.

This will make SCTP GSO code more understandable.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index ce281a9..eb874e3 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -68,7 +68,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 		goto out;
 	}
 
-	segs = skb_segment(skb, features | NETIF_F_HW_CSUM | NETIF_F_SG);
+	segs = skb_segment(skb, (features | NETIF_F_HW_CSUM) & ~NETIF_F_SG);
 	if (IS_ERR(segs))
 		goto out;
 
-- 
2.1.0

