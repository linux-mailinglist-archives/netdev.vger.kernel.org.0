Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D64A7F64
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 07:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245030AbiBCGqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 01:46:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbiBCGqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 01:46:14 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C3FC061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 22:46:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u11so1333653plh.13
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 22:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ADS829oFeIBhbvrzSPNGNISFdoYcnaFviURdP1JvF7g=;
        b=Xb7ZXRX/orSTGZwhb23ZmZeDgY5hxY3GO85SQCCX9tTBxeH7k4uQ3ZGqAoA0ienyVz
         xzSDrPSpDx2HAvpUyyAE/vV1vWsBwXA7SIXbe/P4ZmSEjo2U8YFV00x6MO9RVUus8hMR
         FQ9/7ky+F4kER77iCAh4G//nphEeNq7fLc1+16j0i3AHICKQ3BFFVJPZnRSXERr0Wzhx
         Q+VfdQOKdTxh6RIh1j9j3JzxYZ5KVMTgb7Ch3/fldhDulJF+7vltGNxx9voV27N1abH3
         hxyZPLJqIuR6RC7bqypbRhHjnh6efaFAe/lb0AsHWBo3Pp+7UFaraqAJBQsTRk/vnNOJ
         vJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ADS829oFeIBhbvrzSPNGNISFdoYcnaFviURdP1JvF7g=;
        b=On9/isBqgJW3ILNPegaJKPxYd9sew7LnhMo8FQFRlNoFZnA5XCq6LsTq99I+0UiuSQ
         0nhvQelGb8phwcSaZeJ2uN75gFpvL26L799lW/z4WPQ859WCAmQrqOJ7298hor5dmioO
         jP76SxYDMYzTU5ZVIJ8FjY7BkhkS3vJsnEjAYV6rygGJdvB85omuMdqcV3yKCJvdS7o+
         COyl/AmRYm2fobYQEgm3XeOJY+qAp+RofN7RPcJA960wEc4jQh6SGdUmBtoT31Rra1vQ
         MLizVFhAD1ZnXarxrximFGNMnW7um8802lObe9/FZhinRWp6tz6YGVvRYbr6a4cpj7q/
         ActQ==
X-Gm-Message-State: AOAM5331um/JCPgHSyAQR62LIgaXhCxId2cVglGmbALa8Ev6naZPoY5j
        JZTCiHR8wQue2zigLTTrG1M=
X-Google-Smtp-Source: ABdhPJyekF6Z0l+sRNrozizE3tuNifE98jRTXwpofEG0OadbnhKThm6LKytiJmr1KX1BUjUBJqCPug==
X-Received: by 2002:a17:903:11c3:: with SMTP id q3mr34435639plh.97.1643870773692;
        Wed, 02 Feb 2022 22:46:13 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id b12sm10760116pfm.154.2022.02.02.22.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 22:46:13 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: minor __dev_alloc_name() optimization
Date:   Wed,  2 Feb 2022 22:46:09 -0800
Message-Id: <20220203064609.3242863-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

__dev_alloc_name() allocates a private zeroed page,
then sets bits in it while iterating through net devices.

It can use __set_bit() to avoid unecessary locked operations.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1baab07820f65f9bcf88a6d73e2c9ff741d33c18..f79744d99413434ad28b26dee9aeeb2893a0e3ae 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1037,7 +1037,7 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 				/*  avoid cases where sscanf is not exact inverse of printf */
 				snprintf(buf, IFNAMSIZ, name, i);
 				if (!strncmp(buf, name_node->name, IFNAMSIZ))
-					set_bit(i, inuse);
+					__set_bit(i, inuse);
 			}
 			if (!sscanf(d->name, name, &i))
 				continue;
@@ -1047,7 +1047,7 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 			/*  avoid cases where sscanf is not exact inverse of printf */
 			snprintf(buf, IFNAMSIZ, name, i);
 			if (!strncmp(buf, d->name, IFNAMSIZ))
-				set_bit(i, inuse);
+				__set_bit(i, inuse);
 		}
 
 		i = find_first_zero_bit(inuse, max_netdevices);
-- 
2.35.0.rc2.247.g8bbb082509-goog

