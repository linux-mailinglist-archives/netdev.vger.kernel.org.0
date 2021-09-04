Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96834400A18
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 08:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbhIDGcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 02:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhIDGcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 02:32:43 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54F3C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 23:31:41 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e22-20020a05620a209600b003d5ff97bff7so2760410qka.1
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 23:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=+o8lcE147TTjVxsKTa6G2L6zU349yGMo2SAJF1LwOi0=;
        b=qH/OZDkvYZfga23y64jj08J9Vgb2VW7b6fDaUX20i7Wl/IXCPDzz4OzjnWjeHAzWwg
         V4WfnN4lo/ErpGi6usOYOQIFO/DXRx9LMdRiozkx0DQNVN2uLnfoMdxkCS7ZqRnKKjuc
         yh5e8z35btp12V3zo+BK3/keuXSZoH5vOfEKVnTHBWZnKPiPsABRrPigl6GQtWBGaHUe
         iq0wo8RK5s44Ve2vVgEsdwyVROmBwv6Y4UwzWRDlBAvg+kHm+CR2vrWZcePW0OaeoYVs
         zo6B0xbMM/FKqoaOud5ckBhO/9RBuuSW6K8AhjQWTCVi0I9hrFMcdKNvwsrGWYvNGIz9
         AXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=+o8lcE147TTjVxsKTa6G2L6zU349yGMo2SAJF1LwOi0=;
        b=iJ0OamVx2DLPiNBOukRDsH+2C5NKKLAvi8yIPYivoUsFTWhPQSDRCWq+GLigtQAjTm
         xBOBHJHi7yNZj0Blhl1TOCoJv9+HDyPqieq6bVqqfjOTr0p5ODJTHfa1o0gJoGXl7ygG
         yo9JGcQj6tWHPwLz3jxXTkbOLCJmT1e3J9TbY7d0jk3EVkRQeTiSW23c+pKnwuZiSTi6
         cK0TX504S94koIUs1vRcZLWONYmoVJXw5mZ8/SZA0P32uE9kkuoCZ2ZDvDc0RwlK9iWI
         D/W/YvFlyiwB6s8tqVpDrmClNn5wQp+5QON2xOQgBkzz+dVsQMiD6MMfK4LTMMJKPSUj
         6QdQ==
X-Gm-Message-State: AOAM532TBuYwp1ww/yt2z0ZAoG6nbv8/IQg3E9iaKpWHdXtxeuE29xBd
        xsZoqK8V0zBxJIOw22qbv+VqKhuukw==
X-Google-Smtp-Source: ABdhPJx3JAkJKFk35x4wA1PCS/BR77OIg5xIE5M72ryr6/R+Tt5x3rotEsdI1fFY8gIgRS6oqIntD3iP6w==
X-Received: from decot.svl.corp.google.com ([2620:15c:2c5:11:1c8c:da2:27b9:bdb0])
 (user=decot job=sendgmr) by 2002:a05:6214:2b4:: with SMTP id
 m20mr2682221qvv.35.1630737101086; Fri, 03 Sep 2021 23:31:41 -0700 (PDT)
Date:   Fri,  3 Sep 2021 23:31:29 -0700
Message-Id: <20210904063129.3969050-1-decot+git@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v1 1/1] bonding: complain about missing route only once for
 A/B ARP probes
From:   David Decotigny <decot+git@google.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     maheshb@google.com, David Decotigny <ddecotig@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Decotigny <ddecotig@google.com>

On configs where there is no confirgured direct route to the target of
the ARP probes, these probes are still sent and may be replied to
properly, so no need to repeatedly complain about the missing route.


Signed-off-by: David Decotigny <ddecotig@google.com>
---
 drivers/net/bonding/bond_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b0966e733926..3858da3d3ea7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2910,9 +2910,9 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 			 * probe to generate any traffic (arp_validate=0)
 			 */
 			if (bond->params.arp_validate)
-				net_warn_ratelimited("%s: no route to arp_ip_target %pI4 and arp_validate is set\n",
-						     bond->dev->name,
-						     &targets[i]);
+				pr_warn_once("%s: no route to arp_ip_target %pI4 and arp_validate is set\n",
+					     bond->dev->name,
+					     &targets[i]);
 			bond_arp_send(slave, ARPOP_REQUEST, targets[i],
 				      0, tags);
 			continue;
-- 
2.33.0.153.gba50c8fa24-goog

