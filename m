Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E690229FB6
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgGVS5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgGVS5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:57:32 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40ACC0619DC;
        Wed, 22 Jul 2020 11:57:31 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k23so3633403iom.10;
        Wed, 22 Jul 2020 11:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cyYqWjxKnaJnkrSinErf/w6JPEbLN4zqCCxlbnmFQcU=;
        b=AC+kH/cBHN2vxvPbFT/Fgh402oNBuH353UPFNnCxHWEKrs/jGKQ60beooblVSxtdeZ
         YkDqtRUWvzeHgv8OpqaSOb4kZJSxLzgT+u/luWaHIAXgvr/dOypo1t6OygyOfKEsCNJ2
         7bzgXavlIboo6/4aTKak+orDkA3RHv2Y+AgaPDBLPBv2USv3p7XVRxR6nfztiR/p0mIL
         3L5m40vDAnr/Et3RRG53e+vVAQCqbs8wx94As5GNARAhIoc8YqXEd2yr8DptSp+4O20j
         0S9R+NPQ4bSueZ0gyIWGp82KADBwMJ6bdhxLp65/KBfEzFOhGUqdw1eI8g9yBmq5fEha
         WIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cyYqWjxKnaJnkrSinErf/w6JPEbLN4zqCCxlbnmFQcU=;
        b=NRcLkJ32SCrFvUZ0/w6UwIoFdC2Z87CBkCZKaPbU8HzWU80PlmpHnKKhjSlwBrQSh1
         VjgulnjhtLBmDvX++zmIehYRhHP14iKZj/co0jAwyKRRJZpxXw7yf0M85LocJZThyE9+
         IUI2Ib/vM+i63jQPG3Lv/OXEMv36Vel6Fap6kwZVd6QCCTYV+OIjt6Idk8RJxB2m2s0s
         bobjObBipX2FhnhgqbY3poD19ymx1EwiHE11EXXEn5Ey4MJd/LpOUSqNMZVZpT7W03vC
         05nIgnXE69pOxhYh5wxtmkT1jn19WS8FU8IsDVKc5wVpaawga9OyjcLbSR6CMb5BgFjh
         8JMQ==
X-Gm-Message-State: AOAM532u8ImBa31mNRh36QnF1f+SHRnasdNqFNabyqPKHPjvrGcICYXI
        xNWJ0Pc5rV+JZMgWymZZphI=
X-Google-Smtp-Source: ABdhPJypONaIA/NiGC5LcYqRsCE4RKA/YxWVwdlOmJalO2tHjKIEyDOyWaxWvPS2dea9RO9jlWjROw==
X-Received: by 2002:a02:a408:: with SMTP id c8mr684723jal.59.1595444251225;
        Wed, 22 Jul 2020 11:57:31 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id a5sm186256iol.39.2020.07.22.11.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 11:57:30 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH v2] cxgb4: add missing release on skb in uld_send()
Date:   Wed, 22 Jul 2020 13:57:21 -0500
Message-Id: <20200722185722.3580-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200720.183113.2100585349998522874.davem@davemloft.net>
References: <20200720.183113.2100585349998522874.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of uld_send(), the skb is consumed on all
execution paths except one. Release skb when returning NET_XMIT_DROP.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
changes in v2:
	- using kfree_skb() based on David Miller suggestion.
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index d8c37fd4b808..92eee66cbc84 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2938,7 +2938,7 @@ static inline int uld_send(struct adapter *adap, struct sk_buff *skb,
 	txq_info = adap->sge.uld_txq_info[tx_uld_type];
 	if (unlikely(!txq_info)) {
 		WARN_ON(true);
-		consume_skb(skb);
+		kfree_skb(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.17.1

