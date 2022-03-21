Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B025A4E33F4
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiCUW76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiCUW56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:57:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C781470748;
        Mon, 21 Mar 2022 15:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 201D661572;
        Mon, 21 Mar 2022 21:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939CFC36AE5;
        Mon, 21 Mar 2022 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899626;
        bh=ReG+VWBvGcSBsdPVjYVc8wE2DtUbo7m/mh9lr4jEPLs=;
        h=From:To:Cc:Subject:Date:From;
        b=hYWjwKd/jKBdBjsDCrxzbyp09dq87qZ3v4nioNxEyAG5YXnJZy+lvXPjJj+SgeMme
         BrVCSBm1cRaOkwZ608+26VDKN+41H/yo1tybSMN3fVqkik3tS+QIuD/X3cHvqoLiVF
         h6hG0MicTi499gp5poVOGHH1FpTjWjB1pc2frHm7Xd4e/EooUr5yPpJX2fhXVU76ix
         kQCzqU26BBAaZe07AKzAPsHP8ccmZo4zFf+wl8y6szZUGcO9cma42zwGy+zrBAEas1
         lVgIk8HMMf4l2eQA+787Taanba7MLZnGnbSMDGa1Cs6dIo58+9Voln7+jpmCAZxTrb
         bHl5Aq+xJ/k9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 1/2] af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
Date:   Mon, 21 Mar 2022 17:53:42 -0400
Message-Id: <20220321215343.490600-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

[ Upstream commit 9a564bccb78a76740ea9d75a259942df8143d02c ]

Add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
to initialize the buffer of supp_skb to fix a kernel-info-leak issue.
1) Function pfkey_register calls compose_sadb_supported to request
a sk_buff. 2) compose_sadb_supported calls alloc_sbk to allocate
a sk_buff, but it doesn't zero it. 3) If auth_len is greater 0, then
compose_sadb_supported treats the memory as a struct sadb_supported and
begins to initialize. But it just initializes the field sadb_supported_len
and field sadb_supported_exttype without field sadb_supported_reserved.

Reported-by: TCS Robot <tcs_robot@tencent.com>
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index adc93329e6aa..3f7e27c1aa83 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1726,7 +1726,7 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 
 	xfrm_probe_algs();
 
-	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL);
+	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
-- 
2.34.1

