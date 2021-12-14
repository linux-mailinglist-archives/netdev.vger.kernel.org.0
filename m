Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2104740BE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 11:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhLNKrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 05:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbhLNKrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 05:47:13 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA67C061574;
        Tue, 14 Dec 2021 02:47:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id f74so138498pfa.3;
        Tue, 14 Dec 2021 02:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UL296X80hfhHXgdxviFQfA4Kg0hAX2DoK5OWmb5VTAE=;
        b=RRgeQnCWJjU/M2xSFrfJdPXJV2auAnzJqNZaLeyZobEEta5Iy81bI937EvW41lPklJ
         I+3+fsEBv9teAo+vj2VDMvlscNxvI2snQgtqzr8aPRN+eFtziXeDjUq94oGLGIfRL+qj
         empaiDF68auVTpIXVbYvGB4c9q3/0wJU80NuSDU5YfC7wSeYVn0b43O0P24bKIkjEJK1
         7PE4z7pKqZMMzlNo8fCfDVhEaQ+Gx8aQ+kmjBiIXsaS9lAV0Fcvb4hoEu6e3Fk7g9mxU
         kQhYUTo+B+12QC252L3QTATraXEX3gLHwM82SrJrVt31rQ8hEfd/j+TN3SI16X/JdkiR
         GjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UL296X80hfhHXgdxviFQfA4Kg0hAX2DoK5OWmb5VTAE=;
        b=5uxQnfNVhcBHjVkm6bhpBy7jxpzO6dtwQ5jroiv6GkkqY8K/oKuKhmxOgKKmuHyMSL
         ZteioCqrpOsANURoaHw2ABg9ZTHldv5shS+r6IdTKSijwKEx37uMbjIV8Oe3tqXW6S9/
         DxrWtmJZaT1QcSq4PNLR/zy8ZOzpcmBnA+4V+gLhRvRnhVIovSwWEqROPKXynY6PTly8
         +Z1AV6n8NOrI3wUVrwhWVVQiZoGk7YMa/Hm7yK9VnCwY+OscmhybupFp7NLxQjilFtn6
         g/nXx+5t7vccAHMFCNjcpZQXSaZ8pdxMSP4hpj1x7/NPEkHGZpxuFBvTWEtibTe/hI5R
         Ulew==
X-Gm-Message-State: AOAM533ef6sesY8oeMBR9RBEmAtAG9DvQejuURc1anT37/E/+j8QLBZo
        bqrq63rG7Rrm8MFqJMXuFL4=
X-Google-Smtp-Source: ABdhPJwalddQByhX0UHxQvbkIDYv+Z3qM3CwDr1xgDMIZ1g8S4KA4TMrwWsqvTowcAlrvCoaCcpflw==
X-Received: by 2002:a05:6a00:1a56:b0:4a3:3c0c:11c0 with SMTP id h22-20020a056a001a5600b004a33c0c11c0mr3483457pfv.42.1639478832744;
        Tue, 14 Dec 2021 02:47:12 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.54])
        by smtp.gmail.com with ESMTPSA id z22sm16796788pfe.93.2021.12.14.02.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 02:47:12 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH net] rds: memory leak in __rds_conn_create()
Date:   Tue, 14 Dec 2021 18:46:59 +0800
Message-Id: <20211214104659.51765-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__rds_conn_create() did not release conn->c_path when loop_trans != 0 and
trans->t_prefer_loopback != 0 and is_outgoing == 0.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/rds/connection.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index a3bc4b54d491..b4cc699c5fad 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -253,6 +253,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 				 * should end up here, but if it
 				 * does, reset/destroy the connection.
 				 */
+				kfree(conn->c_path);
 				kmem_cache_free(rds_conn_slab, conn);
 				conn = ERR_PTR(-EOPNOTSUPP);
 				goto out;
-- 
2.25.1

