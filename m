Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3226287816
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgJHPw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJHPw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:52:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3802C061755;
        Thu,  8 Oct 2020 08:52:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h6so4654058pgk.4;
        Thu, 08 Oct 2020 08:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ftYPNFaxojXaB4/26EDulnv1x0oPc17+YM4o4qmiv7Y=;
        b=FvwfOj3lWJTtJyXnza3lQaKG7OVju0ZV97/PIQazXuyO7JcLHmuBsqFEcw1qcULZWJ
         +Vxy1sU/UuKGpozLoCp/VlYHxtF1yFC6JvhPTjslZqRJ5qgeHMxa1ivsr9mu46hcVvjP
         /pT/mrLTXDSzzKRbR2+HFMFBvVLb1Bgy1WlWhQ7wsSvOQaXdr4FejwkZv7JDbbBcQguZ
         7C3r3apFklMjGs1WwguaGrRazWXJrxIACFA61z4XKzVW0tWTnP1/Q7KZSUHFYCznh6J1
         ze5FDbQHxa6WxjjSvmKInSq57ow1hVXP1eeTqxBugU86UB9H7wibhKyDVaDg3fR4U1/8
         fu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ftYPNFaxojXaB4/26EDulnv1x0oPc17+YM4o4qmiv7Y=;
        b=r/R5wNQrR9xfgJs5LhxEay4lSj4SSdStGAPQEPQV9lx8K/FlVPEaEVHGWhz0L1f58V
         6AMzGtG6W2KMggeJSWrynhjtxYHQr29gpeZoQjU7yXbn7DiV4mTTAeaQWVZn1B5eLLk1
         Qzf9J/o34FQlqAxr1qLxAK4iZZmKroHjNZy5muY6Vu9dQcGj3cItWSl2YYDIXRAL6iCa
         uTrfiVTiuSTMqovsRwQtoN5YRxhOtGaOCi52DYwCBLXXSUsvVNiSWKr8rgzW2lL2vQMT
         MVwvXtqGBGU6QLDSYO+TvB6WIwGt1muBYd9JB/d9XQKMETb3VOnUjpTMdehRwXKetstX
         8Kcw==
X-Gm-Message-State: AOAM531MnTk1zLcRh61YHK2yx60BBB38Bb9nwJxa4h4ijsAvZ5j+0ElX
        4UQTdL16bRATyc+e9JoscPA=
X-Google-Smtp-Source: ABdhPJz8200HaV4T+ED+6SZs23nOdiztkwBxnMtGsA9P6/N38Mrg8EvXqZmqjoR6gbUkSSnr/Xjfeg==
X-Received: by 2002:a63:8c42:: with SMTP id q2mr5544684pgn.130.1602172347261;
        Thu, 08 Oct 2020 08:52:27 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:52:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 002/117] mac80211: set rcname_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:14 +0000
Message-Id: <20201008155209.18025-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 4b7679a561e5 ("mac80211: clean up rate control API")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/mac80211/rate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index b051f125d3af..4f9d33fc895e 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -218,6 +218,7 @@ const struct file_operations rcname_ops = {
 	.read = rcname_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 #endif
 
-- 
2.17.1

