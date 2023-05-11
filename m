Return-Path: <netdev+bounces-1708-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83CB56FEEFC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F56B28170C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 09:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88261C757;
	Thu, 11 May 2023 09:35:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5DF1C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 09:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493A4C433D2;
	Thu, 11 May 2023 09:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683797712;
	bh=Jl3566aH/3ykmNfm+L6zyhIBRl0U9RjudKH62vLSUOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+dFT7p3R5psV7Lz2wjGu9W31GWFYP+s4bI7lQ6f1iJIPxOaPQXl0SIknQpv+L2XH
	 gCTupsJPd6OAHCU4yJT3nTIQOofQZ3RSfXSOpbh3FHSn1UuLBRCJPb8StC9vQqciuT
	 9KoJ2Ov++Zw2zPviruQ2FvUkz7DsIKbm7NiSI6k/eIKwObnrNLIYS8e/buL3xF+BeP
	 Zti2C2HXzFCx+7P5hWaolrAkA/VDcnxGAOKyBpu4NHvLZlvpn8ruGF8JixC98iCEu6
	 JBXBIU8MWROOJDgaf+v+P8Y34UwsBI8obYGO0YoQ4jSZvAWnp2ny5ktYvzJ+z2vOUL
	 FkceZvsKjGKnQ==
From: Antoine Tenart <atenart@kernel.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: Antoine Tenart <atenart@kernel.org>,
	netdev@vger.kernel.org
Subject: [PATCH net-next 4/4] net: skbuff: fix l4_hash comment
Date: Thu, 11 May 2023 11:34:56 +0200
Message-Id: <20230511093456.672221-5-atenart@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511093456.672221-1-atenart@kernel.org>
References: <20230511093456.672221-1-atenart@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 877d1f6291f8 ("net: Set sk_txhash from a random number")
sk->sk_txhash is not a canonical 4-tuple hash. sk->sk_txhash is
used in the TCP Tx path to populate skb->hash, with skb->l4_hash=1.
With this, skb->l4_hash does not always indicate the hash is a
"canonical 4-tuple hash over transport ports" but rather a hash from L4
layer to provide a uniform distribution over flows. Reword the comment
accordingly, to avoid misunderstandings.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 738776ab8838..f54c84193b23 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -791,8 +791,8 @@ typedef unsigned char *sk_buff_data_t;
  *	@active_extensions: active extensions (skb_ext_id types)
  *	@ndisc_nodetype: router type (from link layer)
  *	@ooo_okay: allow the mapping of a socket to a queue to be changed
- *	@l4_hash: indicate hash is a canonical 4-tuple hash over transport
- *		ports.
+ *	@l4_hash: indicate hash is from layer 4 and provides a uniform
+ *		distribution over flows.
  *	@sw_hash: indicates hash was computed in software stack
  *	@wifi_acked_valid: wifi_acked was set
  *	@wifi_acked: whether frame was acked on wifi or not
-- 
2.40.1


