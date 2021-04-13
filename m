Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2835DB4C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbhDMJdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:33:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:17206 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343553AbhDMJdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 05:33:01 -0400
IronPort-SDR: IUT2i0chsDoQjlAa/oDRLECKbrgMaiRsDNnUB+l6gcwvKG1yoLE3eBnKyryCj1aheUvAnb7nDb
 JBQizONQWglg==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279681262"
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="279681262"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2021 02:32:41 -0700
IronPort-SDR: /d4kk3xEeYhVjKG9EI0x4bPz/abpWv5I8UQjIAXFp58MaJkYFp6qLnFC4uj5h/cBD6i1BhYotO
 HMrh5eCfaAIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,219,1613462400"; 
   d="scan'208";a="424178214"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2021 02:32:35 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     alexandre.torgue@foss.st.com,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 5/7] net: stmmac: Refactor __stmmac_xdp_run_prog for XDP ZC
Date:   Tue, 13 Apr 2021 17:36:24 +0800
Message-Id: <20210413093626.3447-6-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413093626.3447-1-boon.leong.ong@intel.com>
References: <20210413093626.3447-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare stmmac_xdp_run_prog() for AF_XDP zero-copy support which will be
added by upcoming patches by splitting out the XDP verdict processing
into __stmmac_xdp_run_prog() and it callable for XDP ZC path which does
not need to verify bpf_prog is not NULL.

The stmmac_xdp_run_prog() is used for regular XDP Rx path which requires
bpf_prog to be verified.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 35 ++++++++++++-------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0804674e628e..329a3abbac76 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4408,20 +4408,13 @@ static int stmmac_xdp_xmit_back(struct stmmac_priv *priv,
 	return res;
 }
 
-static struct sk_buff *stmmac_xdp_run_prog(struct stmmac_priv *priv,
-					   struct xdp_buff *xdp)
+/* This function assumes rcu_read_lock() is held by the caller. */
+static int __stmmac_xdp_run_prog(struct stmmac_priv *priv,
+				 struct bpf_prog *prog,
+				 struct xdp_buff *xdp)
 {
-	struct bpf_prog *prog;
-	int res;
 	u32 act;
-
-	rcu_read_lock();
-
-	prog = READ_ONCE(priv->xdp_prog);
-	if (!prog) {
-		res = STMMAC_XDP_PASS;
-		goto unlock;
-	}
+	int res;
 
 	act = bpf_prog_run_xdp(prog, xdp);
 	switch (act) {
@@ -4448,6 +4441,24 @@ static struct sk_buff *stmmac_xdp_run_prog(struct stmmac_priv *priv,
 		break;
 	}
 
+	return res;
+}
+
+static struct sk_buff *stmmac_xdp_run_prog(struct stmmac_priv *priv,
+					   struct xdp_buff *xdp)
+{
+	struct bpf_prog *prog;
+	int res;
+
+	rcu_read_lock();
+
+	prog = READ_ONCE(priv->xdp_prog);
+	if (!prog) {
+		res = STMMAC_XDP_PASS;
+		goto unlock;
+	}
+
+	res = __stmmac_xdp_run_prog(priv, prog, xdp);
 unlock:
 	rcu_read_unlock();
 	return ERR_PTR(-res);
-- 
2.25.1

