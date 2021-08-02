Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C3B3DDF05
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 20:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbhHBSWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 14:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 14:22:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F270FC061760
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 11:21:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j21-20020a25d2150000b029057ac4b4e78fso19858360ybg.4
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 11:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yv7WLNE2828qDLgR31t9jFSBn3B30XOTw/zxq8FSLFU=;
        b=JZXUBz4dnf8l5rXEZdeDOpq3WTb6EH38ITJ45zPxiK+FUGsGNAgEG/xBLPceWtOPAe
         jFLKx/NuhGRdA2LjFuZGebRD84/yfrjLqtgQCGw5PLETw9QknNngYf7nZ3hW4Uji21T4
         RplezT3ak29uKzYLvf96nQwKHm8lwZLZQP4nST8wpxYuRB0PTHjdU3oaQmsYZ1VvdRKE
         t6a5MMIfAHRjjrz7pCzGgkGDe2tAhIAckEJLjfVrL3+JXVs3srRKkSBparGMaPt2GtWT
         hSeHI8bAIolH0nTI8VZCnDphOtw4q1hxMSBX8OQv0HYZBcyg5v4m6gqCL5Hwchs6oDqU
         A4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yv7WLNE2828qDLgR31t9jFSBn3B30XOTw/zxq8FSLFU=;
        b=oPBT4V9MSS53Gy9QlzKulAa5zNLpi8uWvjjJ3/h0NDmdX1jiTS/HE8UiM6WbxRkuKn
         P72oOZTOdy+T9/Lvdo8Ug29qgDAEExthUXyExkY3zC7QvzR99yGx4D/JUiULI3MuMWkg
         QFiztL9aiwrrrkRTIbQAkmjyvy6VPXR1IRaXy5lAardSM0r69njzPffF49Dq8sB7ANz6
         15kvbKx3+oqiNaxDR43D8uokjY5mRK72f9Yu9Xuwte1Lq9VgnXEwg5Pob20+9cEJ4J8a
         BT8MNEIUKt7cSfnxsvCvhsqipcjNuPeoIIYHLo7NP4a611ZC7ShuGd9IURJrAgTc5EgH
         vm7Q==
X-Gm-Message-State: AOAM532ZH49+pdSNnVF0i1ZCNpfK8C267WGinaAT6N4oN0NO3VqXwAy8
        wjm9KvHWMlBovI2R03dX7Eln0eMf3gbGAWyYJ9U2GA==
X-Google-Smtp-Source: ABdhPJznTjz+KZKbDsCNPJz7BxB1CJD+q1y0cBlC/YOCBZs7kDpjY/el9laA0JlZcagGqwlp/4eYxfvITanP8q1xDDszmw==
X-Received: from mustash.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:337b])
 (user=richardsonnick job=sendgmr) by 2002:a25:27c1:: with SMTP id
 n184mr23601473ybn.496.1627928518173; Mon, 02 Aug 2021 11:21:58 -0700 (PDT)
Date:   Mon,  2 Aug 2021 18:20:53 +0000
In-Reply-To: <20210802102100.5292367a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-Id: <20210802182057.2199810-1-richardsonnick@google.com>
Mime-Version: 1.0
References: <20210802102100.5292367a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v3] pktgen: Fix invalid clone_skb override
From:   Nicholas Richardson <richardsonnick@google.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     nrrichar@ncsu.edu, arunkaly@google.com,
        Nick Richardson <richardsonnick@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Di Zhu <zhudi21@huawei.com>, Ye Bin <yebin10@huawei.com>,
        Yejune Deng <yejune.deng@gmail.com>,
        Leesoo Ahn <dev@ooseel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nick Richardson <richardsonnick@google.com>

When the netif_receive xmit_mode is set, a line is supposed to set
clone_skb to a default 0 value. This line is made redundant due to a
preceding line that checks if clone_skb is more than zero and returns
-ENOTSUPP.

Only the positive case for clone_skb needs to be checked. It
is impossible for a user to set clone_skb to a negative number.
When a user passes a negative value for clone_skb, the num_arg()
function stops parsing at the first nonnumeric value.

For example: "clone_skb -200" would stop parsing at the
first char ('-') and return zero for the new clone_skb value.

The value read by num_arg() cannot be overflow-ed into the negative
range, since it is an unsigned long.

Remove redundant line that sets clone_skb to zero. If clone_skb is
equal to zero then set xmit_mode to netif_receive as usual and return
no error.

Signed-off-by: Nick Richardson <richardsonnick@google.com>
---
 net/core/pktgen.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 7e258d255e90..314f97acf39d 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1190,11 +1190,6 @@ static ssize_t pktgen_if_write(struct file *file,
 			 * pktgen_xmit() is called
 			 */
 			pkt_dev->last_ok = 1;
-
-			/* override clone_skb if user passed default value
-			 * at module loading time
-			 */
-			pkt_dev->clone_skb = 0;
 		} else if (strcmp(f, "queue_xmit") == 0) {
 			pkt_dev->xmit_mode = M_QUEUE_XMIT;
 			pkt_dev->last_ok = 1;
-- 
2.32.0.554.ge1b32706d8-goog

