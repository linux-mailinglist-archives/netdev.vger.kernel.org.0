Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D153AF8CC
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhFUWxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbhFUWxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:24 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0349C061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:09 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id k8so27258417lja.4
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fFRTgnhaZdiPc4s23/e1DRJMfNzImvLNibkBRz67I0U=;
        b=C6udMV9IW+azsIT1AE8bakJQpGQCaCZYvfc0d35CyE8TEvw0aYB3w2sjEGs9ufKhP9
         EGYN/V62Tv1LcBnLIrgT1Xx8k6ECQvKk0QwpI+/FM0fXIfQ9T2p5Hc6BJJ+6RjrGmG/9
         8gRLBjc/9M1pcpMQFoWWHc76rL0Tq5bjpcNomLd3IHKQ90apTtxEXUhijdbT/09vu7Ox
         /XNr0iGzuflIiwFa1NLpZ5ohQ4sguzP+p2+McwWdnFIelY4b00XSp7VSC28iXn5HqaOO
         JA2nZZOTnhztVwC9hCrGI/hCWoa8LdiusDvNLsnw1zNpA4WQjiI7te2ZxDzkEZtbSgJO
         COhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fFRTgnhaZdiPc4s23/e1DRJMfNzImvLNibkBRz67I0U=;
        b=Mm5U6INerU+Iq56L4nQzLt3/45D/m3GM8MMfJ7SUhdd8IcOarJsOH46J6k4/ui33lw
         ntiEajxLpcT+vHa7K/i2qI96NsJ0wQSp0ErOzkdc3xODfjzb/i5BVjofsIGGJfHp/6pd
         OocCp+TMU2nvw+zVnbzgbgyY5OaldKKToRo2FHHZq6Zc32syLSZ76MsVdRCFhPRR+s3/
         FY2hV+qTP9Hx1CupJRonIVlPdWX8tkIw70tVfimUeRygBM3cPY8t/jKs8NGk/DLj51ck
         VtXkqB8r2twnQEp9jDwp5GZJdzv/tMVg1V5Nk55TM4HE0d8YWB7NhLcZ/icaeYhoij5U
         Qu6w==
X-Gm-Message-State: AOAM5330RqaBfROzotRAQhMFDk+MUkW6G9VhZHTpMg1Qx+TRYPpBqad7
        fgnnl29Iavvbm9S60pYWgXE=
X-Google-Smtp-Source: ABdhPJzRUW2nS1hyXOMSvrKFTMDZr7bdgmy9H1PlVtLTcNn2fglWo28zLXzyDo3JPBHa22wg5I1VVg==
X-Received: by 2002:a05:651c:147:: with SMTP id c7mr460871ljd.98.1624315868374;
        Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 04/10] wwan: core: multiple netdevs deletion support
Date:   Tue, 22 Jun 2021 01:50:54 +0300
Message-Id: <20210621225100.21005-5-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use unregister_netdevice_queue() instead of simple
unregister_netdevice() if the WWAN netdev ops does not provide a dellink
callback. This will help to accelerate deletion of multiple netdevs.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

v1 -> v2:
 * no changes

 drivers/net/wwan/wwan_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 1bd472195813..b6b9c52f617c 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -882,7 +882,7 @@ static void wwan_rtnl_dellink(struct net_device *dev, struct list_head *head)
 	if (wwandev->ops->dellink)
 		wwandev->ops->dellink(wwandev->ops_ctxt, dev, head);
 	else
-		unregister_netdevice(dev);
+		unregister_netdevice_queue(dev, head);
 
 out:
 	/* release the reference */
-- 
2.26.3

