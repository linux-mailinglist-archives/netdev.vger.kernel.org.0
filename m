Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9750A248EF1
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHRTpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgHRTpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:45:07 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E63C061344
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:06 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 19so13561779pfu.20
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=oZMmn4PHvUdTHMM4IFHnrX8/vyRXNZx/g7k6fnL4qoU=;
        b=X6/w59lwEh8yUIO0W3saAN78ZCcD2ydpd7W/kOSZiBJvR/vJoEN7iedoqSGmyLBGtM
         jiXFO36bjpXKrOyzTjEndE2RdIFtQiBJvw9/rshAOwN4uOgaJW2D+f9lcYMLJ3Bxnaoh
         5gnkGKpcu0ha6nAcLOY1zD+EUiaaqC5E2EWzKv/DY1dhOWnd8wIyiuPXkDbu+t8L8suC
         ioUCRdGZwu/XGf9LRv+xDES/uN48Ecip+ttDh5tO7TuoXzHZYMvFjz9kH8RAXXU4vfhc
         i12eopgxDfcMAx164hT+EgcxX7x+qcPGo4rsYKnawJGy1AI8Nmz+LpViy70CHEp0/R0H
         g7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oZMmn4PHvUdTHMM4IFHnrX8/vyRXNZx/g7k6fnL4qoU=;
        b=AzjE2+tw7Hvo609rgq+Y0z/u0YoVaOS1FTH+gZOkX20MP85wBopb9xlVAIQbKsmU5a
         c6Y14Fcd5LFGqGHUz2jgbndYSwSNYyFK0QL8TdQiMPDHNR/BID+d65nFEyg/GVwKHSHn
         8Tgxb3iUvJezVGLmWe+ydIl19vAw83Gm06nd5b0goGPjTyAS+Lwo5T/xYNKsOu0I6qiM
         xzXzs8dbEEjN7BbjM7iF00nWKPoOo+kkKhiDc+a4aw1KFLAkMIBUsVhhZSK9bVexWaqd
         t4Ca6PLtq5tdd0KXGYe+zB7I74PYs8iTktPGjxi0C8repAYogJ/N9R00NWMyAnfz9B0U
         RhVw==
X-Gm-Message-State: AOAM533PJpJwIqmSMKZpN3SqzF/ZeJpACkjmJjwkSzsWk3tYx4q+uJT1
        vBd4Hs6fbnOh/vdRUvlR5fPxX7AcmOT2XN5AO1UyTrX41Xkzb1YYOUhQvm534LozI8o6TOzc7IR
        E0SZMY7G+K0icz4NJECQMLlX/mdNDMNbi/QWrH+PO6ajAaWDXBfUwcHkUJ38jR+iC5wHgjrHX
X-Google-Smtp-Source: ABdhPJyzDg0y1YbsOii+jHAgrn8cZJjZX9qtkIWU0PgYuZGXsc1cBJYDlNasvrCSSEnJfR3sshJ9mGYYRgvjgaWB
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90b:3509:: with SMTP id
 ls9mr1180832pjb.230.1597779906155; Tue, 18 Aug 2020 12:45:06 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:11 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-13-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 12/18] gve: Add netif_set_xps_queue call
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Catherine Sullivan <csully@google.com>

Configure XPS when adding tx queues to the notification blocks.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 01d26bdca9b1..5d75dec1c520 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -176,12 +176,16 @@ static void gve_tx_free_ring(struct gve_priv *priv, int idx)
 
 static void gve_tx_add_to_block(struct gve_priv *priv, int queue_idx)
 {
+	unsigned int active_cpus = min_t(int, priv->num_ntfy_blks / 2,
+					 num_online_cpus());
 	int ntfy_idx = gve_tx_idx_to_ntfy(priv, queue_idx);
 	struct gve_notify_block *block = &priv->ntfy_blocks[ntfy_idx];
 	struct gve_tx_ring *tx = &priv->tx[queue_idx];
 
 	block->tx = tx;
 	tx->ntfy_id = ntfy_idx;
+	netif_set_xps_queue(priv->dev, get_cpu_mask(ntfy_idx % active_cpus),
+			    queue_idx);
 }
 
 static int gve_tx_alloc_ring(struct gve_priv *priv, int idx)
-- 
2.28.0.220.ged08abb693-goog

