Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF80372B9A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfGXJnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:43:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41367 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfGXJnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:43:15 -0400
Received: by mail-pg1-f196.google.com with SMTP id x15so10600504pgg.8;
        Wed, 24 Jul 2019 02:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=iR/rCzIi399aRKhJN0gwqymimR1s0rrYFixqzZ944Cc=;
        b=G4L08l+wMcbZdgsUmXCEsJdyn8PGqwrko5Wx6BSSo+NtApUJqete7vvQcxJaFqVG2/
         /yWeRAwqd0zam4RYqhqQmV1uP3NGB757vb3ZjMVs3irXTdc+oGT+ogVEXVY324c/MTOK
         g6ggFvSMVodXYU3NCV2EGyHVow5FOCkhZikXp+mz91fHl2tS2l650FyHsJPLpIr27QiH
         2PUUgu8KJypFd12Pq72H48XImKkTxRqd1r2zMUY0AVZHVhj/174M+DH4bA5+xSXjuaBH
         Au2GtRzHDbhrSz3hwaA8AT36Ux4D+e0O27pmv0BOo/+sF2FTMXflBOA7bsemf5l6u2eg
         w3Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iR/rCzIi399aRKhJN0gwqymimR1s0rrYFixqzZ944Cc=;
        b=PoBFddTebabCul3CFXgNM1M4PL21lepADvnxVSAow4vje8pSlA7or0Xg5KpYv4NU89
         WWtXEo+ST5IcWhmtT33Mmo6pfGbbAJVts5LX73fd3LKX6qTU6MPFSVecoe8Lk0ShZLr0
         Lr0NXD+KaxlzIHEPd3I73N2p/qmuQHI/DTEoxmlEBldfX+cxN77Q/gkEt2kL4g1lKMTx
         3Ql1/ebKKUBkaavQUyM8/9fvG/IHSyLrFcmsmpnEvCVjNuE2ej+S3CB/6WsjCIfSC6+C
         h20lSnHLBBF3LQPqqT1Tm861vS1sEmrw7R0Wxotnovdof5W+sJfT2cUgX6+u7UMQ6udt
         /hfA==
X-Gm-Message-State: APjAAAWPHPk7BYlxEQVeey3IltN2QgCMHkOy91PtqH9KWMWLXgiNKrpu
        CZDYEU/ImSHvEAnDSADYEtNIjFeYdzo=
X-Google-Smtp-Source: APXvYqxhzYr7NV2FggQ7OCSMgRgws55e+2f5hgDhCfoQ8LXK75v0BzE4vCZy2mERL0MWIjZSFYWABg==
X-Received: by 2002:aa7:82da:: with SMTP id f26mr10488550pfn.82.1563961394272;
        Wed, 24 Jul 2019 02:43:14 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id 22sm53099526pfu.179.2019.07.24.02.43.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 02:43:13 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     idryomov@gmail.com, jlayton@kernel.org, sage@redhat.com,
        davem@davemloft.net
Cc:     ceph-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: ceph: Fix a possible null-pointer dereference in ceph_crypto_key_destroy()
Date:   Wed, 24 Jul 2019 17:43:06 +0800
Message-Id: <20190724094306.1866-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In set_secret(), key->tfm is assigned to NULL on line 55, and then
ceph_crypto_key_destroy(key) is executed.

ceph_crypto_key_destroy(key)
    crypto_free_sync_skcipher(key->tfm)
        crypto_skcipher_tfm(tfm)
            return &tfm->base;

Thus, a possible null-pointer dereference may occur.

To fix this bug, key->tfm is checked before calling
crypto_free_sync_skcipher().

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/ceph/crypto.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 5d6724cee38f..ac28463bcfd8 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -136,7 +136,8 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 	if (key) {
 		kfree(key->key);
 		key->key = NULL;
-		crypto_free_sync_skcipher(key->tfm);
+		if (key->tfm)
+			crypto_free_sync_skcipher(key->tfm);
 		key->tfm = NULL;
 	}
 }
-- 
2.17.0

