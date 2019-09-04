Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB180A8CC2
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbfIDQRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732299AbfIDP7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D1122CF5;
        Wed,  4 Sep 2019 15:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612753;
        bh=lQYj4NUXHSkeIRtL2lZVGzZ2tZyvwgqLTUTTjnchcWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkVVKNcJRscE51XVCDAzvT79U7qlKGzqreDZeumKSzVf2SnZ2hoMkwLdLTGnmMkEg
         SJdDo+jLVabVzHCcvJE75NuGhh2l7SZ8oYFxyeL0+geBexHo6igwUKIDGjGiC0WhLY
         6zA3/Az16Op5RCxkuAIlXDC/6y47nJq3cmGhKmo4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 62/94] libceph: don't call crypto_free_sync_skcipher() on a NULL tfm
Date:   Wed,  4 Sep 2019 11:57:07 -0400
Message-Id: <20190904155739.2816-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit e8c99200b4d117c340c392ebd5e62d85dfeed027 ]

In set_secret(), key->tfm is assigned to NULL on line 55, and then
ceph_crypto_key_destroy(key) is executed.

ceph_crypto_key_destroy(key)
  crypto_free_sync_skcipher(key->tfm)
    crypto_free_skcipher(&tfm->base);

This happens to work because crypto_sync_skcipher is a trivial wrapper
around crypto_skcipher: &tfm->base is still 0 and crypto_free_skcipher()
handles that.  Let's not rely on the layout of crypto_sync_skcipher.

This bug is found by a static analysis tool STCheck written by us.

Fixes: 69d6302b65a8 ("libceph: Remove VLA usage of skcipher").
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/crypto.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
index 5d6724cee38f9..4f75df40fb121 100644
--- a/net/ceph/crypto.c
+++ b/net/ceph/crypto.c
@@ -136,8 +136,10 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
 	if (key) {
 		kfree(key->key);
 		key->key = NULL;
-		crypto_free_sync_skcipher(key->tfm);
-		key->tfm = NULL;
+		if (key->tfm) {
+			crypto_free_sync_skcipher(key->tfm);
+			key->tfm = NULL;
+		}
 	}
 }
 
-- 
2.20.1

