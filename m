Return-Path: <netdev+bounces-971-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 920F56FB873
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 22:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77B361C20A5E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:45:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528621119C;
	Mon,  8 May 2023 20:45:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F00847B;
	Mon,  8 May 2023 20:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A750C433D2;
	Mon,  8 May 2023 20:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683578731;
	bh=lvZTpD5KIgiY8VViVPBXVUnmb9cGPU4MaC+1OuhdwYs=;
	h=From:To:Cc:Subject:Date:From;
	b=SpcTrFroOEBjNeb2BEAL+ujmMoqszL+5MaxzV6XeSoxAb/1HsJSdWwLMXkq9g1AWG
	 MvSDvTdvg86/DDD+RpEdQshWuFuM1+xOcRnGPKbZm/OKSDY3rtbxfGm7Y/kdHc0/B2
	 iGso3Ul/Pq/98PTnpeymJtJf8YQY1ssP7NNr3byvG0mryae3jQdOhAwuOW3Yd0OO9Q
	 zwqZzX91btm4MyW1icBiG7GPQWlSg6+cpF5ff4qjwHKyQzTHMFUMJAxtPCNUCfhAFV
	 UQ+QVMoTnxc47TRddF+/jTlbOnEnkvhEsF1SY1YfQKzbr/LDQLxX++h9gm5voWAdrb
	 2cYqPbARaTMaA==
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: netdev@vger.kernel.org
Cc: lorenzo.bianconi@redhat.com,
	bpf@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	linyunsheng@huawei.com,
	ast@kernel.org,
	daniel@iogearbox.net
Subject: [PATCH net-next] net: veth: rely on napi_build_skb in veth_convert_skb_to_xdp_buff
Date: Mon,  8 May 2023 22:45:23 +0200
Message-Id: <0f822c0b72f8b71555c11745cb8fb33399d02de9.1683578488.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since veth_convert_skb_to_xdp_buff routine runs in veth_poll() NAPI,
rely on napi_build_skb() instead of build_skb() to reduce skb allocation
cost.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index dce9f9d63e04..3ae496011640 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -747,7 +747,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 		if (!page)
 			goto drop;
 
-		nskb = build_skb(page_address(page), PAGE_SIZE);
+		nskb = napi_build_skb(page_address(page), PAGE_SIZE);
 		if (!nskb) {
 			page_pool_put_full_page(rq->page_pool, page, true);
 			goto drop;
-- 
2.40.1


