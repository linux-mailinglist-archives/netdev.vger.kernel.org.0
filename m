Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACEC1BE6DA
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgD2TBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:01:15 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55811 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgD2TBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:01:14 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MsZif-1jA82b1Dq7-00tyVc; Wed, 29 Apr 2020 21:00:58 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nf_osf: avoid passing pointer to local var
Date:   Wed, 29 Apr 2020 21:00:41 +0200
Message-Id: <20200429190051.27993-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:CYlZfuFtNpjZrqTvwZ5028YLJ6KuOCHmVhyazWlbBu2PhEtBqbt
 6gk7Yk1cVVGh4KTcIw7birHOPmwEfP89NBJ4jutRj0t7LDFLDWtn40s6DoTQ41kT4oIJ4dL
 0lCl3TjjigXQtqSZAHYCqoxT0O3/kYlNBnbVDR1J0DXlK3rMlPkoFGvbesgvwNc20FuaSAJ
 prW7otpY0Wm5kTT4fSNpA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UTHG1ceMWl0=:vrEAPiFvvSnonSYlGvh3LL
 JSKK+SjWOMMoF2Iau67hHUbGEYcjDuIuB9pByQ7+uImR2f2QP1gj5urYdHRCwfuvECmmXVkXr
 /G+R4IuRTPjrVYX7SEfVenIQIqCQArexDI16d0AsD6Hqj7zbGo6jp2QDq+rT5/rRE6IbiWTtM
 ym1O+ovYBc8lFDbXmAbdFCS9uvxFVmtVwzR+I6SCbZIPkQTj7XZ99KOY5vYUZZb/dYZKnjh3z
 DHc4VgLAxKtaIJbjuN5ONO1NOqcxL9M81n7P2mHUvmBnF7oTCZVs6Aa2tv+DZAfoQdMG8peT1
 s1EYnLzRBsUrZQCqtgMmI7oKZTwkQsyZ91AloI3LXO2Zl7W+735WKJ4CBZzkEJ6d6J2lgvzoc
 R9AfBTSIUeQcIjI8jlKpYbqYw83Kr8lio55wOfwiCP/AYgqadMg0t79FUPeH15VkqXadYkP6F
 WpdgS7/zr4Gj7AtPRXqb4xZpRWGWqQM9tTYCoKje2yT/wyarO3YRAEK9y0k6xfCITxlMyFpqZ
 RuJxqaJOGODzqeXsYWYZ9XbvEFNMeIPpwBDMc9Ff25k++fCxyR6ylM4gtHOZuQINSCYfkzH7R
 ufciE9S52vwDlSSZ624E0VTDWJ17GdHfwYaCUBpJmJRQE9/YYBEO+dE5k+DuAkD1G4+ko0TRW
 RL5fRLPbXdnBVJP6rMXRy6y1kDWY86OHKcYvsgNgRXIWaImgDJevgEU0qBs130GO8RnG6DeZD
 +t/HFG1wn/NjMPzot+0PDK+DaaKDnmczVHvZy57zdyfq8TzJCILJcXLEm8YhGgVbuk9WKX8NR
 U/1+KjsU9R7euiyBM8zym9MwFOMIeVqYo2hdcWDO0IiyWyJeKg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 points out that a code path exists where a pointer to a stack
variable may be passed back to the caller:

net/netfilter/nfnetlink_osf.c: In function 'nf_osf_hdr_ctx_init':
cc1: warning: function may return address of local variable [-Wreturn-local-addr]
net/netfilter/nfnetlink_osf.c:171:16: note: declared here
  171 |  struct tcphdr _tcph;
      |                ^~~~~

I am not sure whether this can happen in practice, but moving the
variable declaration into the callers avoids the problem.

Fixes: 31a9c29210e2 ("netfilter: nf_osf: add struct nf_osf_hdr_ctx")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nfnetlink_osf.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 9f5dea0064ea..916a3c7f9eaf 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -165,12 +165,12 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 static const struct tcphdr *nf_osf_hdr_ctx_init(struct nf_osf_hdr_ctx *ctx,
 						const struct sk_buff *skb,
 						const struct iphdr *ip,
-						unsigned char *opts)
+						unsigned char *opts,
+						struct tcphdr *_tcph)
 {
 	const struct tcphdr *tcp;
-	struct tcphdr _tcph;
 
-	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), &_tcph);
+	tcp = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(struct tcphdr), _tcph);
 	if (!tcp)
 		return NULL;
 
@@ -205,10 +205,11 @@ nf_osf_match(const struct sk_buff *skb, u_int8_t family,
 	int fmatch = FMATCH_WRONG;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts, &_tcph);
 	if (!tcp)
 		return false;
 
@@ -265,10 +266,11 @@ bool nf_osf_find(const struct sk_buff *skb,
 	const struct nf_osf_finger *kf;
 	struct nf_osf_hdr_ctx ctx;
 	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
 
 	memset(&ctx, 0, sizeof(ctx));
 
-	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts);
+	tcp = nf_osf_hdr_ctx_init(&ctx, skb, ip, opts, &_tcph);
 	if (!tcp)
 		return false;
 
-- 
2.26.0

