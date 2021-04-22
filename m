Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B5C3681A0
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236359AbhDVNnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbhDVNnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 09:43:10 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88397C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 06:42:35 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id gv2so12687843qvb.8
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 06:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hKEFsZLPVAMWONlqseCqrfz20aOL96cVEP1m1Kg1z4k=;
        b=kR+PacB12BfR9FIQoA9WAdqABy+6vpFxMz9TTqMmpXyhQ5Cp5hkniNUEL+nvarhy4T
         VXVUUMl88kc965ngMxcWZexp0F8vPayeTfoXR8t2lPaSx6pokZsn2zmqqKKZchhkdRmS
         fjThg/LVZJbYdb1KF6pILorS5IglRx/UgT2BYyg36yIlf+E0G7H/TTgzzBnRHnbdXpTe
         lJEIT2uhpjTfm3hqRQ9/MZVkDVcNnsSyNRlfzezFaCSXNWuqOSZ/Y+u5SkHcoJFegr0r
         5glhzGyCU8krLMAqziJ10Kt/LvQXM+h3hkY64qIAf0rLrM0tDZKLrQb77+DsWVcN8ETj
         oMEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hKEFsZLPVAMWONlqseCqrfz20aOL96cVEP1m1Kg1z4k=;
        b=ZPaFm9bdzOAtjNt9HzRYH4U8ljBCQwyVZbXRcEbw5E7nnpi4nFojKCRnYXbXnxyPRy
         kwLPJzrSY20foQXzSLEjPyR/F1KDpTEhkLjgJbj5nwzHDrjdmTKDOKsgRZO4qe3pjDVM
         ku++OT6rjAaU5DukA27ZpH3q6jjwqbT/5H4p3KZ6KsFQpql/FB7AR5+kvk1OpKjrPSZc
         ZwsIHMmfRgX44NyguXSuoB5MNsupScmfH5A60qYKY/PYlOrOtVwHj8XlFt+An747RZk4
         x/VxsO4wlOSUf+8YO9RLVQL3vqQ/eRbgSiRvlwWM86gcwOykn5NB+ANb8iU2znmcbUDh
         oxWQ==
X-Gm-Message-State: AOAM530xsWEfssb2avvVt6vWePhK3vxmSePbwP1KmGyt8byXWWXNFm4N
        3393mSO8+Dmu/SsyV4By4aGGWIwv4w7CLA==
X-Google-Smtp-Source: ABdhPJx6v7yEPo5PimrcCXCWDYDmugjxQK8Q2GvtLtH2IVa+/LVqhcym+/UV6dHeKPvMab3vPyYUKw==
X-Received: by 2002:a05:6214:19e7:: with SMTP id q7mr3670806qvc.34.1619098954501;
        Thu, 22 Apr 2021 06:42:34 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id x19sm2104112qkx.107.2021.04.22.06.42.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Apr 2021 06:42:33 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     netdev@vger.kernel.org
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] net: sock: remove the unnecessary check in proto_register
Date:   Thu, 22 Apr 2021 21:41:51 +0800
Message-Id: <20210422134151.28905-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

tw_prot_cleanup will check the twsk_prot.

Fixes: 0f5907af3913 ("net: Fix potential memory leak in proto_register()")
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/core/sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5ec90f99e102..c761c4a0b66b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3531,7 +3531,7 @@ int proto_register(struct proto *prot, int alloc_slab)
 	return ret;
 
 out_free_timewait_sock_slab:
-	if (alloc_slab && prot->twsk_prot)
+	if (alloc_slab)
 		tw_prot_cleanup(prot->twsk_prot);
 out_free_request_sock_slab:
 	if (alloc_slab) {
-- 
2.27.0

