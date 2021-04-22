Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD953681E1
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236893AbhDVNw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:52:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45575 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236459AbhDVNwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 09:52:25 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E7A95C00DC;
        Thu, 22 Apr 2021 09:51:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 22 Apr 2021 09:51:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=P6tEnDufyu4Ld4het
        a43rN/h/1A4rvYoxNQMG/kr4NI=; b=wtRHVdSAzfm2ddaT7r8CJtqcQYCml17lX
        T7AL//SUFTCkJB36u97mBlf6KpZJQPd82KZCrVHhP2ZHVuUr6TH07UL2o/Qcb1YS
        z0CpOcSWYIDTlpEyRcG5fjjm9s4mlJm94npR+yBDPT8uts6QerDfB5/KCXvg0kh6
        sI9zVbrUpbB43/sD97NbAgW5idQMORuRafC8mYFPfgpoW4+NFx3RGtoH7N/OkVQm
        5K2wwQDSsCzjFO7paqChaF+UkzEnZRD8F0XlYO9e61uliHfpdqVVaO6MqtdwDx0r
        0r9sEN/FG440j/YfSomqIobRvI6qFyecq2si4nKU13p82ZqmPvMQA==
X-ME-Sender: <xms:c3-BYFCSaLkmzSSCwAhOh4EZnvC3k-gpZw_hTDkDOZVD_o-rcCGq8A>
    <xme:c3-BYDhIsG486Kx0E5IeBbfuDMYncML-2-u-0uBkm0SSVyiYyzN7YLmHuAIls2pCm
    FpOkmLN3qB07Vo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddutddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrudehfedrudekjeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:c3-BYAlo8ZzfgVwhADwjPX9uD3TzAtyJcVDaWV6K7AGkpv_igvb4dg>
    <xmx:c3-BYPzNcLFR4eNFTlJekEW7NKM8MBvPfKhD3Sm19oTJziO3ifTRfg>
    <xmx:c3-BYKTgq44Qy-9jBVvKlTZXjDHwYDDS8mpCkpMsoMCOCbIrRqDpSA>
    <xmx:c3-BYNIcPVRqsbAc_CcaFZ1575a6lKA4J8do_hTJ0g9JdBjWMjD8XQ>
Received: from shredder.lan (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id E919924005B;
        Thu, 22 Apr 2021 09:51:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] netdevsim: Only use sampling truncation length when valid
Date:   Thu, 22 Apr 2021 16:50:50 +0300
Message-Id: <20210422135050.2429936-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When the sampling truncation length is invalid (zero), pass the length
of the packet. Without the fix, no payload is reported to user space
when the truncation length is zero.

Fixes: a8700c3dd0a4 ("netdevsim: Add dummy psample implementation")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/netdevsim/psample.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/psample.c b/drivers/net/netdevsim/psample.c
index 5ec3bd7f891b..f0c6477dd0ae 100644
--- a/drivers/net/netdevsim/psample.c
+++ b/drivers/net/netdevsim/psample.c
@@ -79,9 +79,10 @@ static struct sk_buff *nsim_dev_psample_skb_build(void)
 }
 
 static void nsim_dev_psample_md_prepare(const struct nsim_dev_psample *psample,
-					struct psample_metadata *md)
+					struct psample_metadata *md,
+					unsigned int len)
 {
-	md->trunc_size = psample->trunc_size;
+	md->trunc_size = psample->trunc_size ? psample->trunc_size : len;
 	md->in_ifindex = psample->in_ifindex;
 	md->out_ifindex = psample->out_ifindex;
 
@@ -120,7 +121,7 @@ static void nsim_dev_psample_report_work(struct work_struct *work)
 	if (!skb)
 		goto out;
 
-	nsim_dev_psample_md_prepare(psample, &md);
+	nsim_dev_psample_md_prepare(psample, &md, skb->len);
 	psample_sample_packet(psample->group, skb, psample->rate, &md);
 	consume_skb(skb);
 
-- 
2.30.2

