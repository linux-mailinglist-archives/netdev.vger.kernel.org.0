Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93B94E3346
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiCUW4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiCUWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:55:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA774453A63;
        Mon, 21 Mar 2022 15:37:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A52DB81A21;
        Mon, 21 Mar 2022 21:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370EFC340F0;
        Mon, 21 Mar 2022 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899565;
        bh=iwUeLQxCDC7OEVPT2rElS4J+zZ+Rdy4pMjpsoROH3zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBsseh0cn2thgVqePrN4RgFuGEW2VNTJVZPTHosMWJc34KAmmDIcs5UXM4LpPMeeh
         rfss51Y9V6fQsI6uOzz3M6yoJD7EtglyfXEWZWscj5a1Vf3wQEaqKNsbtVkakHCfNg
         xeU9u5CMIZhwTko0aTTIch8Btd4w3EAT6M8dn7VCAwsCEBripw3oT30stG3N6+DpFl
         FoKU903EXpNMIURsyGnnDhEY9PgIFx2Q3JTvrnmTQZTHdUX18F5a4XaNfcxTIcLN4T
         phEhBksexV+riE+HNt94i3lkJTnxJRtC1EkAPJkKcKJe9BxxiTpWXouNhcPVOkxSIk
         p3INSGbKK7zsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 2/6] af_key: add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
Date:   Mon, 21 Mar 2022 17:52:33 -0400
Message-Id: <20220321215240.490132-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220321215240.490132-1-sashal@kernel.org>
References: <20220321215240.490132-1-sashal@kernel.org>
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
index 9bf52a09b5ff..fd51db3be91c 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1699,7 +1699,7 @@ static int pfkey_register(struct sock *sk, struct sk_buff *skb, const struct sad
 
 	xfrm_probe_algs();
 
-	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL);
+	supp_skb = compose_sadb_supported(hdr, GFP_KERNEL | __GFP_ZERO);
 	if (!supp_skb) {
 		if (hdr->sadb_msg_satype != SADB_SATYPE_UNSPEC)
 			pfk->registered &= ~(1<<hdr->sadb_msg_satype);
-- 
2.34.1

