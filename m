Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEADC3F5210
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 22:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhHWU2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 16:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhHWU2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 16:28:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E560FC061575;
        Mon, 23 Aug 2021 13:27:30 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so872261wma.0;
        Mon, 23 Aug 2021 13:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bIcLXpEM37ywSUnR+r6MN9eaKbHaPN9c26DZBTA5Was=;
        b=oZ0dUV1PkpAzHK+44jGVy1MnwEmzrUrYnCAEEC3OOuNdmnd1f+ORs4dd3Db/O6Yh8i
         WPMR1fzieRRP8gdF64qMYJ1YpdFjEHflGslInBWBu3TUigBDUszFFW8mpVC+HlpJN9Mo
         bxybwp55U3Ra6/Dt6lk018gGy9CFlr6S0CLJYKdWFzzGVejueaBGYdBZeSlbT/MXoPbz
         vSTo60CN2sKp3vGk7O/9nLg0Ble10UttnFQ6QP2qYJzDtcdbL5ll/9TTLvLXluhm95VY
         GKdFrRedPozW8ai03fOIqNJ8yZysyTSNO0p3tP02VIS2y8XYTVbfgiknyr6gFFlYaSaC
         kliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bIcLXpEM37ywSUnR+r6MN9eaKbHaPN9c26DZBTA5Was=;
        b=SsCYSACmD32cI2p55QsEr1eXTPQQrzQT3AIzO/LBJ+nSUXlI31mKBSYEosh2b3YXBS
         KjPB75pb51mEIAeD/YwqhY0DWh/kZNZc86FJROgwlX2mQINaUm+r1zPqpGAwm922bZP4
         xJNR0pf6OIsoCCFBYZZXyQ/eJLwXJgh4piRkYEbF2L6k7USd6RChkQokWKnIctz6/MvU
         zT/tiUOjZUee9/QfQHU4TBdG0pmf5d9e9uKDAO+sOQuoizWpC6QPq8FcZRDH1idtMIqd
         zW1dOQT3Q1evh5yvksK9y1zsKcKTikHoJbUvObsVvv+OEhJpB2q1hplDEGDSrfo0JYLj
         gUNw==
X-Gm-Message-State: AOAM530qxnPMQvW6IQMNWkMhiAfnmOEtAO4avU820rpm07j3hQuaoNlh
        YVTkhTH//S7QhFXiMBGC+wc=
X-Google-Smtp-Source: ABdhPJwhDuUJBKWKofbT5kwxWtHMrfYPc1x9WzLluiMk0oTiJIsI+zWYG2KHtZsW9On/0SLZCOkSZA==
X-Received: by 2002:a05:600c:4896:: with SMTP id j22mr411938wmp.170.1629750449410;
        Mon, 23 Aug 2021 13:27:29 -0700 (PDT)
Received: from localhost.localdomain (arl-84-90-178-246.netvisao.pt. [84.90.178.246])
        by smtp.gmail.com with ESMTPSA id o6sm15842832wru.92.2021.08.23.13.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 13:27:29 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     netdev@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] netfilter: x_tables: handle xt_register_template() returning an error value
Date:   Mon, 23 Aug 2021 22:27:29 +0200
Message-Id: <20210823202729.2009-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit fdacd57c79b7 ("netfilter: x_tables: never register tables by
default") introduces the function xt_register_template(), and in one case,
a call to that function was missing the error-case handling.

Handle when xt_register_template() returns an error value.

This was identified with the clang-analyzer's Dead-Store analysis.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 net/ipv4/netfilter/iptable_mangle.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index b52a4c8a14fc..40417a3f930b 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -112,6 +112,8 @@ static int __init iptable_mangle_init(void)
 {
 	int ret = xt_register_template(&packet_mangler,
 				       iptable_mangle_table_init);
+	if (ret < 0)
+		return ret;
 
 	mangle_ops = xt_hook_ops_alloc(&packet_mangler, iptable_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
-- 
2.26.2

