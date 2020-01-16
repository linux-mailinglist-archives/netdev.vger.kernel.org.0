Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F015413F3E7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389927AbgAPRKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389911AbgAPRKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B356205F4;
        Thu, 16 Jan 2020 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194622;
        bh=GxpxSfn4Aog9jObkkwzJClYhMneNU3fTJqn+IXbCiGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wyz+O5Rwk/jbC8uaAyi+p+7sltSdczBBFyYQEAZ9cSDrEjrm3czSklo4fgikssVbQ
         uFK52lkIgZ4Cv4p3oIVftIMLGNRGO8dfzkOJsXi5VdUZpmMlKaoo1qJVaaSEhUah66
         qckkt7DThFaicMLB7iDYDm5RlT8fMqtANF+saWjQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Brandon Cazander <brandon.cazander@multapplied.net>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 483/671] net: fix bpf_xdp_adjust_head regression for generic-XDP
Date:   Thu, 16 Jan 2020 12:02:01 -0500
Message-Id: <20200116170509.12787-220-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 065af355470519bd184019a93ac579f22b036045 ]

When generic-XDP was moved to a later processing step by commit
458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
a regression was introduced when using bpf_xdp_adjust_head.

The issue is that after this commit the skb->network_header is now
changed prior to calling generic XDP and not after. Thus, if the header
is changed by XDP (via bpf_xdp_adjust_head), then skb->network_header
also need to be updated again.  Fix by calling skb_reset_network_header().

Fixes: 458bf2f224f0 ("net: core: support XDP generic on stacked devices.")
Reported-by: Brandon Cazander <brandon.cazander@multapplied.net>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 935fe158cfaf..73ebacabfde8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4349,12 +4349,17 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 
+	/* check if bpf_xdp_adjust_head was used */
 	off = xdp->data - orig_data;
-	if (off > 0)
-		__skb_pull(skb, off);
-	else if (off < 0)
-		__skb_push(skb, -off);
-	skb->mac_header += off;
+	if (off) {
+		if (off > 0)
+			__skb_pull(skb, off);
+		else if (off < 0)
+			__skb_push(skb, -off);
+
+		skb->mac_header += off;
+		skb_reset_network_header(skb);
+	}
 
 	/* check if bpf_xdp_adjust_tail was used. it can only "shrink"
 	 * pckt.
-- 
2.20.1

