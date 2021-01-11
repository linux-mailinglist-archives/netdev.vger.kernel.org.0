Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538022F1286
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbhAKMqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbhAKMqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:46:20 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C3EC061795;
        Mon, 11 Jan 2021 04:45:40 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j1so9466506pld.3;
        Mon, 11 Jan 2021 04:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=6y2PAyUtL03Nbrmo9xCdhafDQCYKT4PC/qS4knYVGiM=;
        b=SaBbLSbGW8fO/ng0tqWOzQ/i6ZcO94hAHvzLzOapfxzlSJwlNeFl+34uiqEtESjC6Y
         EPqn5eXO9AWR7JyLHMNwvW6QGYeI4BcLOrHhDijJmfTc8dOr7C5JhR9kdw/BXB9uR1zM
         p8aCqc43jDZ4w9yNSXF/tQCbLoOZQ9FO/bHZl1kmuHxrtvXlvvuVBnMIZ9L5Ef1nPlU6
         9PqDhzTbf7B18xEaaRPnigNO4FMbtn8BqjV3Zd+LZe9T9kGzH9S9NuSXj8tuKcF6bOMn
         xVPwp11QrhZZNBKhPPKThWZ4xh8zMPP7HZ5HeE4W16hLP18P9+fIRw0aAL82gNg83ui3
         VrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=6y2PAyUtL03Nbrmo9xCdhafDQCYKT4PC/qS4knYVGiM=;
        b=DCBmHae/xxmXRFDImxO86S3IUfBDeOKCJO+ssZ78B8IVsDviXe8STDadQNub6ALkGg
         GtTf+3mwfBjRQaOM41iHeASqhEjq6oLGj69BAMCSt8kzCjplumbjL0ZE36NDeS1VP3Cj
         lCFpoFlfqfN7KEQlgRuzMIh77JYu8/DjunsQCP2yX6pvynPXGi4nB+M1a6z2oxBOunYv
         e9fcpiuaYT92+VDKXDpU5grQYBwx1gQ5GzlSm8wi8L5SsxVjWrDsuRNxIbEEziuy2d+S
         NPyxCzO1bX7hzPJKXS96Epae5vBpfEy4V2Uo4vDnpZVjiWmlZ2YJx52No7qkqCXdqTL8
         Uriw==
X-Gm-Message-State: AOAM531Ceknlh6KVCn4pYDGrMqqsxnSM3sX9sQa0DyxCfzpsytC2IScG
        QTiiaJk5JueHEbnSFCQBm2bg9sYL+K5NLQ==
X-Google-Smtp-Source: ABdhPJyYj1jFb3xl7ksgoIqUaL1y+e3+P7qDNWrdpWE2a69OWDd8cmg+bKsKdC+3R9BUaZS2ctXoYQ==
X-Received: by 2002:a17:902:830a:b029:da:df3b:459a with SMTP id bd10-20020a170902830ab02900dadf3b459amr19621583plb.75.1610369139638;
        Mon, 11 Jan 2021 04:45:39 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 22sm18883235pfn.190.2021.01.11.04.45.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 04:45:39 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net-next 2/2] sctp: remove the NETIF_F_SG flag before calling skb_segment
Date:   Mon, 11 Jan 2021 20:45:14 +0800
Message-Id: <813eca10a6e21151b5d18a9fe7087ab906b689c7.1610368919.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <a34a8dcde6a158c64b0478c7098da757a6690f0b.1610368918.git.lucien.xin@gmail.com>
References: <cover.1610368918.git.lucien.xin@gmail.com>
 <a34a8dcde6a158c64b0478c7098da757a6690f0b.1610368918.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610368918.git.lucien.xin@gmail.com>
References: <cover.1610368918.git.lucien.xin@gmail.com>
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

