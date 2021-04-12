Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A936635CA20
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242982AbhDLPh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:37:57 -0400
Received: from mga05.intel.com ([192.55.52.43]:41987 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243026AbhDLPhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:37:54 -0400
IronPort-SDR: mDIQgopT2Y17D0SHsjlLIDlSkSAIxbdYf1j9JjE5yOUVCrREWzWoA6TIzn6ngehNX3+uMyBvN1
 fThPEBKUZXsg==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="279520395"
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="279520395"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 08:37:36 -0700
IronPort-SDR: ptiedoemEo3kJs+PhAMGucRpNWpabLTlgW0GrCRIaJn0DYsCbIPlKKGp9uaMqui87xfTgf1etH
 sJ1lADVj21mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,216,1613462400"; 
   d="scan'208";a="614609623"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2021 08:37:32 -0700
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
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 5/7] net: stmmac: Refactor __stmmac_xdp_run_prog for XDP ZC
Date:   Mon, 12 Apr 2021 23:41:28 +0800
Message-Id: <20210412154130.20742-6-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210412154130.20742-1-boon.leong.ong@intel.com>
References: <20210412154130.20742-1-boon.leong.ong@intel.com>
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

