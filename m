Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D93C30C427
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbhBBPlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235258AbhBBPOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:14:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D18664F9D;
        Tue,  2 Feb 2021 15:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278452;
        bh=91G44idT22nHLpyzhPSx7iPam8mPe8MI1jM14ONeA9k=;
        h=From:To:Cc:Subject:Date:From;
        b=qKrXUIxUrE9bqNw453UsaILDzLThYT8Bhtc1AYIeyPWTXVrYM07d6PR+FfbvTyqce
         mtB644yd4rfAf7D2hkrDzVkFxybgZ7js+WK0tLfz2+nO+QnTz8evYqBypQQYZ6Dc7S
         bwxX0rXiCakaj6xFzCfoQYOoCUXUuiAMmatawOSoaPHElZtZmtZal8FFyM6pIVhilA
         n6og7hIARN4d04Yo7cpiqsYQI7iLKvQP+U6ADAzP5NKSbL1hbyZYUVQAFI6fxTY0ig
         S4mMVx6HHpfziBge4jUSWCnKUQAor+ciNegm9ZV63w/vziGghaZTZzaSRkAshKO1u6
         BQCSLjP5Prp2A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/7] af_key: relax availability checks for skb size calculation
Date:   Tue,  2 Feb 2021 10:07:23 -0500
Message-Id: <20210202150730.1864745-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit afbc293add6466f8f3f0c3d944d85f53709c170f ]

xfrm_probe_algs() probes kernel crypto modules and changes the
availability of struct xfrm_algo_desc. But there is a small window
where ealg->available and aalg->available get changed between
count_ah_combs()/count_esp_combs() and dump_ah_combs()/dump_esp_combs(),
in this case we may allocate a smaller skb but later put a larger
amount of data and trigger the panic in skb_put().

Fix this by relaxing the checks when counting the size, that is,
skipping the test of ->available. We may waste some memory for a few
of sizeof(struct sadb_comb), but it is still much better than a panic.

Reported-by: syzbot+b2bf2652983d23734c5c@syzkaller.appspotmail.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 0747747fffe58..a10336cd7f974 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2906,7 +2906,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg) && aalg->available)
+		if (aalg_tmpl_set(t, aalg))
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2924,7 +2924,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
+		if (!(ealg_tmpl_set(t, ealg)))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2935,7 +2935,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg) && aalg->available)
+			if (aalg_tmpl_set(t, aalg))
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.27.0

