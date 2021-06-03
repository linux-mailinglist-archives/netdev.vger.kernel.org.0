Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1D8399959
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhFCEwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFCEwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:52:03 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49687C06174A;
        Wed,  2 Jun 2021 21:50:07 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a5so6899341lfm.0;
        Wed, 02 Jun 2021 21:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zqKGPh2sFHvHDPUOdf/BuenLWamDTQPRfxgjQFjdLik=;
        b=ICtBHhnlYLayEfFAoEECXkECT70TRWFmqt4dq4WM6UJl5dzo2g9YbRs/WmEtsrPcGQ
         PwVkJpSRlwjO5Q6XtXpqGIP5Dnb5tTYxEAeY5lo78JTpO3qIBiUyqJSsFtN51RvZj/XG
         CsNAw2Sq1F72HCZng8kueeQbflC/gdlpJAVtoKZifaJbOEF9S0Z/CsFH2sIpiZ6ZwHlm
         xYVHYQs6dBUJZYC0I54ZCATW/YgkYFazxx7yqcEmN/WCWKgrldmBOqRLf5tuBacAyuGw
         0Lfn1n6JjFG91s/CB9j1tlYUAVxKjl02MNc/rCjzS+1rcddp6p8fwzGSDZbfkLBo+2eo
         Auuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zqKGPh2sFHvHDPUOdf/BuenLWamDTQPRfxgjQFjdLik=;
        b=VzspNt1zwf2FjVww8xOQiJSCf2lk98yEceXok6MYzcaDoBlGeSQG3tbFEgQ4HOkrcZ
         6TXXOvyrbmdVHoYJauxJwYmTwPK2bAqlxh49l6Mx/o38wPnQT/vDcO3AKhWaTe29vTB7
         fkunKYojiBbW314OuJUUc8SLQLYY4XefT57D/4wcRcWFICTTBdyp3jQTQtSWHoi0PbN4
         489OShVbUWTl2W3OPQMvJhZtdYhm/G1gK2MMXmvr0puaHOhGP+Yl15a2maF4NbdLWn7B
         hyHuz1BYjrD26wsOZtD5MkWv9Pg/rFgS+W5UKL3m5ekPcAQmzgn7aavs2Tnk4skg1m0h
         2QRg==
X-Gm-Message-State: AOAM533+tiHEIvu0Q2KGurJRQkYWGmwz5UVrSxNS5GlaCYogx/LabcTX
        nxzDWVBj/0ES0WCtqyDfYlk=
X-Google-Smtp-Source: ABdhPJwsXeAq0PJAwgA4obBVAwF0dBlX+NCMXMD3eaPgjxfSZshNDR0/RADw7ee8kBDT8CC/jL/u1w==
X-Received: by 2002:a05:6512:411:: with SMTP id u17mr11418179lfk.287.1622695804290;
        Wed, 02 Jun 2021 21:50:04 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:03 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 1/6] rtnetlink: fix alloc() method introduction
Date:   Thu,  3 Jun 2021 07:49:49 +0300
Message-Id: <20210603044954.8091-2-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
References: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTNL checks for the setup() callback existing in a few place as a sanity
check. The introduction of the alloc() method makes the setup() method
optional. So allow RTNL families that define at least one alloc() or
setup() method.

Fixes: ???? ("rtnetlink: add alloc() method to rtnl_link_ops")
Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 net/core/rtnetlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 49a27bf6e4a7..56ac16abe0ba 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -376,12 +376,12 @@ int __rtnl_link_register(struct rtnl_link_ops *ops)
 	if (rtnl_link_ops_get(ops->kind))
 		return -EEXIST;
 
-	/* The check for setup is here because if ops
+	/* The check for alloc/setup is here because if ops
 	 * does not have that filled up, it is not possible
 	 * to use the ops for creating device. So do not
 	 * fill up dellink as well. That disables rtnl_dellink.
 	 */
-	if (ops->setup && !ops->dellink)
+	if ((ops->alloc || ops->setup) && !ops->dellink)
 		ops->dellink = unregister_netdevice_queue;
 
 	list_add_tail(&ops->list, &link_ops);
@@ -3421,7 +3421,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EOPNOTSUPP;
 	}
 
-	if (!ops->setup)
+	if (!ops->alloc && !ops->setup)
 		return -EOPNOTSUPP;
 
 	if (!ifname[0]) {
-- 
2.26.3

