Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F0C45091F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbhKOQFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 11:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbhKOQFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:05:12 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52A1C061766
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:02:13 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id q12so3267564pgh.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 08:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tivrXntTWIbCkVzZC4y1HIyO4FqKtX6bYEAzYxt9B4c=;
        b=oWCc1n4tm5zCJxae3xkGIvL4qNO5jJQK2PhsxaekoUCUdhsyS7fg9L2yaSfdbujV6o
         Nxst2ng8GqpnJQDUI63bIJ9xF+qaMBDWS8GZZ6aPcOTldEZM5rehKQwQnphbJz2UsHyt
         VEiEBBs85fhJgJd4r6lseabO8YMZjqRaKncMOBiOVwBIu1Mujam77+cBPU1X303T/eNA
         f4jYM1hLklyJnwCD4BJBnhFX1rkPuAGRZkO/m4okbBL/i6/JnjpAP82/ZWWkSfaFR+xY
         r1NWO0EsdOZt6G/ek3HGZRAaKGon42iM9vQaiXnB8LBn52A3DXSZYYIzW1UCu3zHOHp0
         GLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tivrXntTWIbCkVzZC4y1HIyO4FqKtX6bYEAzYxt9B4c=;
        b=SSnij01RLHwUotqZbVFh3SZvrhe6vVkYNuzxj+NNoaKn7b/RwRCdq0JTmqgHugFneZ
         qt+SGWEy6U80E2ImK5TpsogyuzVrXxCUWyqS1dTWzpb1pzGQHjgmG1bCY7zUgbIO+39k
         lRRwGgwKlLsUD6rzMGpw2Q1zuNiR9uciTxWv4P2CUR8Kf/BmeMSLLhF2sLKnziQjyfHL
         1Oay2t0whyHwtu11YiXWhIw1Bf3Ies/kfaQDjnMbpb9aQ+dS007EV5LEuL0pr7qVC512
         mFMreyZhUre2PgoaNLUXK/dbPvbNNf949GAkL+40seT5RLQ2FqFsG+l/CSJt2L0HGJgV
         cLSQ==
X-Gm-Message-State: AOAM533ecn+k9hyDZBV3lEMJJgUl8CUGLO6CKB0IYzqaqyWAkhRWRPzv
        Tfm6nlTIOOX5Sib46YXHCzxZzw==
X-Google-Smtp-Source: ABdhPJzwcqJ6KzoH1s6JCM7i7hqtm/wv2VNT0LxCOTZuK4dKTRSpry+DXx0j2CMmYHa146COp1uoBw==
X-Received: by 2002:a63:bf45:: with SMTP id i5mr25148151pgo.161.1636992133191;
        Mon, 15 Nov 2021 08:02:13 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id o2sm16331383pfu.206.2021.11.15.08.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 08:02:12 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     davem@davemloft.net
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v2] tipc: check for null after calling kmemdup
Date:   Mon, 15 Nov 2021 08:01:43 -0800
Message-Id: <20211115160143.5099-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmemdup can return a null pointer so need to check for it, otherwise
the null key will be dereferenced later in tipc_crypto_key_xmit as
can be seen in the trace [1].

Cc: Jon Maloy <jmaloy@redhat.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: tipc-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 5.15, 5.14, 5.10

[1] https://syzkaller.appspot.com/bug?id=bca180abb29567b189efdbdb34cbf7ba851c2a58

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
Changed in v2:
- use tipc_aead_free() to free all crytpo tfm instances
  that might have been allocated before the fail.
---
 net/tipc/crypto.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index dc60c32bb70d..d293614d5fc6 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -597,6 +597,10 @@ static int tipc_aead_init(struct tipc_aead **aead, struct tipc_aead_key *ukey,
 	tmp->cloned = NULL;
 	tmp->authsize = TIPC_AES_GCM_TAG_SIZE;
 	tmp->key = kmemdup(ukey, tipc_aead_key_size(ukey), GFP_KERNEL);
+	if (!tmp->key) {
+		tipc_aead_free(&tmp->rcu);
+		return -ENOMEM;
+	}
 	memcpy(&tmp->salt, ukey->key + keylen, TIPC_AES_GCM_SALT_SIZE);
 	atomic_set(&tmp->users, 0);
 	atomic64_set(&tmp->seqno, 0);
-- 
2.33.1

