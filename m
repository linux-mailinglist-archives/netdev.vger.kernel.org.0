Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD0D386BFC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244892AbhEQVKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244766AbhEQVJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:09:57 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54592C061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:39 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id bo19-20020a17090b0913b029015d14c17c54so521826pjb.0
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 14:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lNknXnTPPfqjjwubpAKIoRoT+vgweyHOSBuOGTUbCXQ=;
        b=DKHtzOO4R8YzXD63OEKruBTfNu6dxEPRApcXyQKjG+YEgQvZ3vik0sn/dbjsaqzcmp
         t+7mkQQugM5HzsZuVHFne8Z0EoMGswZBl3DDGYyULgllO9FdZiJgI8GDW9GqBv+cVmOJ
         WY2e3WPm5/MRiaOvrdNHF0IhxLm6pxq0J684xwuiVqeZ4pn9983C6gI2fvGG9iLipBvj
         3q7yiA+DAAAtSmh3nZskILVtx9dLMKncrQ/rjIjNODwghwFOP1sBeBts/ndoN50Im09k
         jcinv91/ArmkpnKP4f4UDAg5vRXqDg73rNoXj9O8Rq+X+bA9a5Yo2N4QQ94EGxeGs82j
         TfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lNknXnTPPfqjjwubpAKIoRoT+vgweyHOSBuOGTUbCXQ=;
        b=DQdCpaJofss+euVxDl64TxI+8meY9xNr9DAr7qnxlRrY+WsMaW8LsamQGEjPQ31UXA
         uAcjHWmlv/6OxnM8llVED2TYyTA422liNcFgqyxCaeyW8+n/5hzR2gPPDhLII6KOCaPL
         X/qxwcWcj5Dxm00G7TWB5TtSyz9Tzlyb1I5buheNM88BnpJKb+IkFbNEn/aGDMDeZ5EK
         ZqzfBYUVZHzfxFOgHjQ8qXKYCGOET54k4QZjiQLXhJAtQ4pgb2//Utc8zTZ10FAhJPTv
         XhsNeK0REUgklvFLLQWKsCBi6JtjJcCCSrrlI89sboWe3dM54lTlotvlZ8vG1b7tFK6a
         is6g==
X-Gm-Message-State: AOAM531ioVd4jMtVIaSz7HzY4q6okZjzOnLkURtYImXy4Dab+0EoW1CX
        hgiOJ7vZpnW/tKi3thB1thncD4HvShtVZD0vWi2byYfrZCdV2ghds9mHrtkjOY+xtDhBjs61BPI
        KQosXiP5SFHcg05f6iVCS+6pQXINBf+avovLyYBJ7hbQ8CTAzXMM0yal5LH5I5EqadiAYjh/3
X-Google-Smtp-Source: ABdhPJwPyl72cUFdECRr7eMNjEOgJEBl0pfnf8GbnhponZCp0tRcyjAYdS3M35WbD2WNog6i3WjCoFD3V0iXwQcu
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:ba72:1464:177a:c6d4])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:7a89:: with SMTP id
 q9mr1104602pjf.0.1621285718806; Mon, 17 May 2021 14:08:38 -0700 (PDT)
Date:   Mon, 17 May 2021 14:08:15 -0700
In-Reply-To: <20210517210815.3751286-1-awogbemila@google.com>
Message-Id: <20210517210815.3751286-6-awogbemila@google.com>
Mime-Version: 1.0
References: <20210517210815.3751286-1-awogbemila@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH net 5/5] gve: Correct SKB queue index validation.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>,
        Willem de Brujin <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SKBs with skb_get_queue_mapping(skb) == tx_cfg.num_queues should also be
considered invalid.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: David Awogbemila <awogbemila@google.com>
Acked-by: Willem de Brujin <willemb@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index bb57c42872b4..3e04a3973d68 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -593,7 +593,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
 	struct gve_tx_ring *tx;
 	int nsegs;
 
-	WARN(skb_get_queue_mapping(skb) > priv->tx_cfg.num_queues,
+	WARN(skb_get_queue_mapping(skb) >= priv->tx_cfg.num_queues,
 	     "skb queue index out of range");
 	tx = &priv->tx[skb_get_queue_mapping(skb)];
 	if (unlikely(gve_maybe_stop_tx(tx, skb))) {
-- 
2.31.1.751.gd2f1c929bd-goog

