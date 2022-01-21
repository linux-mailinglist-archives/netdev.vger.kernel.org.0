Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE249588A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 04:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiAUDYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 22:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiAUDYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 22:24:19 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC2AC061574;
        Thu, 20 Jan 2022 19:24:18 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id e28so3226245pfj.5;
        Thu, 20 Jan 2022 19:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i4QbHTZsLroI/F3v7ghAzppSaB2PYGF736LCpyMu98s=;
        b=V71yUYiX4CJSgycnC0ue1TNs1tWa8PBmT2UCUblhD9gggziNxe4obJD4QyZVY7YLc5
         XoEelx2xKEDn7kDN82F4rpcQzsAp+BkJkJuT9y/sBYVugp7suY1kwK4OfE5w51RdwBdB
         2Us0/z70hEkQc5AaNU3FxpD1gTt0fZ2x1PZd3G3DgLdOHEUpsVwvzRWU8XvLI3zAvB67
         tA2YFCUZuuSJulXadTg8iy0E4lxKM6e4X+OuqcDYzbOXGoInOeAG5BEDnnrn5PP1dx6w
         yHi8p8ttY1qokesI0mQmrOO57qw2w6AO1jiMkQjq48Md2ZbH9MECTURM18z7vEzvGrKH
         a9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i4QbHTZsLroI/F3v7ghAzppSaB2PYGF736LCpyMu98s=;
        b=wAJtU79eclhyjnakGCtoWUjGJDfVknbTJWn7T9WcQU6iyZWl0t5T9jxOXTvDJ+fgBR
         NSCvf+b1+a22ANTDZ9r3pgB+b51l0Q0smTDZ164oo7cOU7Mgdh1f7P6WRIIGr9mpiTDK
         U4y6raq4erMaA54fBpHASKqKJxiTaImerAJ+9lSqRGjGuke2pZCDwLvJD5FAbooXYq/R
         +AAbTKqqPqVTT8OLxJtvqsaAGJNEDzBY95kk8Bzj83TpYklI9aZ7ISKs/PSdak7rfDjH
         hBRKslHOxUVALx+nFAHsjnPDJGZmibvL8AEt91wcEtaKajEWgxJq6yLrz3nCfv9tF+kp
         bJDg==
X-Gm-Message-State: AOAM531q7bq3tnr6nmzibdeOUrk+XJ3eEQLjVkRUZ1tLo1LA6cQYIZO0
        VUk2W/fxPCkX8cTs4DuOeRM=
X-Google-Smtp-Source: ABdhPJwl/1FoGgXedNhDH0Al5XfnUTqVSMh6l7iruP2FkK0EKaUpsKoHFuc6oCJZwTO1qBuq2pXhsw==
X-Received: by 2002:a63:8ac4:: with SMTP id y187mr1495104pgd.261.1642735458292;
        Thu, 20 Jan 2022 19:24:18 -0800 (PST)
Received: from localhost.localdomain ([106.11.30.62])
        by smtp.gmail.com with ESMTPSA id n22sm4553312pfu.193.2022.01.20.19.24.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 19:24:18 -0800 (PST)
From:   ycaibb <ycaibb@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ycaibb@gmail.com
Subject: [PATCH] net: missing lock releases in ipmr_base.c
Date:   Fri, 21 Jan 2022 11:22:10 +0800
Message-Id: <20220121032210.5829-1-ycaibb@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ryan Cai <ycaibb@gmail.com>

In method mr_mfc_seq_idx, the lock it->lock and rcu_read_lock are not released when pos-- == 0 is true.

Signed-off-by: Ryan Cai <ycaibb@gmail.com>
---
 net/ipv4/ipmr_base.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index aa8738a91210..c4a247024c85 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -154,6 +154,7 @@ void *mr_mfc_seq_idx(struct net *net,
 	it->cache = &mrt->mfc_cache_list;
 	list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list)
 		if (pos-- == 0)
+			rcu_read_unlock();
 			return mfc;
 	rcu_read_unlock();
 
@@ -161,6 +162,7 @@ void *mr_mfc_seq_idx(struct net *net,
 	it->cache = &mrt->mfc_unres_queue;
 	list_for_each_entry(mfc, it->cache, list)
 		if (pos-- == 0)
+			spin_unlock_bh(it->lock);
 			return mfc;
 	spin_unlock_bh(it->lock);
 
-- 
2.33.0

