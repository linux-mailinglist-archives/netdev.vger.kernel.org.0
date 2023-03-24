Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258716C8308
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjCXRMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCXRMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:12:08 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2EB2194A
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:06 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id n19so1577403wms.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679677925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2IaWlH7abh0r241+EHHXm0ebngTGfgUKffPXQtB3krM=;
        b=3DHgAd2wuhgjtclX+s1OIw9Yh9iKokUZ/ZAHOwXw1Wb3VWqsHW5eObAlUI8ikdimRv
         M1byi5NmGB7mlC21cWzoz7L+ut246zxHz1g1itan6UFznrFffkl+K2LtpsIWsusk7R/q
         kOWMzSMmb5cpmYGkVt9vxemQdrQ6/zY4hSUzOioxsqmqNSV/X+e/u+52QWx9jGqVnMsB
         WtgpSiuCd4A03eF0Fz7aEBV/2KUryOWt045uqt/uI8rQCO6YPeevdBxXHmIDH5T4mca1
         56uMWE1oqX6WvtUvKJwhnMGO3MH2kupzY3KuNgaHkKCzKMl0g7Fe2xvUi4NOtivBs52e
         PKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679677925;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2IaWlH7abh0r241+EHHXm0ebngTGfgUKffPXQtB3krM=;
        b=wXMDvQqGrYNevasuY5/5zdjlR5ce1VL/9szdIIXK9+myIkJr/eVmxA+7Igv2NPRUfe
         PBT1a4TFBq0eJitGU+xJXcCuhrbFPjWKvjsdb+C4csr4lbSXzj4rupqD1tnw2xwBDk5v
         T+Q9IeXjLNY57I41SoDSbi2z01mhWp2WEiaynfYJoMM6xOqbjXx9m7qVo78BrkT2CwzS
         YOjVGcKZqhpJQYIaRxL55Qk//V3ZzFGbBJUeLdp3PVkfzRYAg4vpggHW1cWldQZ1tF5a
         JAuJ6KeoUMW6AeM/hx/UjdDu0MK4QrfZcAExh2E2Du1boKcN8uP3Z07erOMkEsomGoj+
         a8JA==
X-Gm-Message-State: AO0yUKVATPKMoXNZnOE5YJaikEFQRfePqtVQt5z4VxLzs2/IaWxvuYYX
        jOE6itwfNAwHz4ZFRw179iP/9w==
X-Google-Smtp-Source: AK7set9BfYvV5O2qNMeqRUICrkkdWt0fhFtMlvs4HEKiSuXoR9OXSSnpBjEmVzugwxsB1FHJMe6pNA==
X-Received: by 2002:a05:600c:22d2:b0:3ee:392:39e3 with SMTP id 18-20020a05600c22d200b003ee039239e3mr2900091wmg.30.1679677924813;
        Fri, 24 Mar 2023 10:12:04 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n17-20020a1c7211000000b003edf2dc7ca3sm5336285wmc.34.2023.03.24.10.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 10:12:04 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 24 Mar 2023 18:11:32 +0100
Subject: [PATCH net-next 3/4] mptcp: do not fill info not used by the PM in
 used
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230324-upstream-net-next-20230324-misc-features-v1-3-5a29154592bd@tessares.net>
References: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
In-Reply-To: <20230324-upstream-net-next-20230324-misc-features-v1-0-5a29154592bd@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2359;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=tfrD6RVlmEwTdSM2FDq/8Wzw0KDut8T4BXZaYVMDJvg=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHdnhO0H6C9F7gXGnhIa6irzV9sedrlpMm9M8Q
 RS7lv71+iSJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZB3Z4QAKCRD2t4JPQmmg
 c3ddEACCRWs4NatTqqTHhXzvSKo6oGFaqE0aL05ckSdgYCpNmpTv21ghoVC0u6JZLWL0aduCl7C
 gn7J/0M34+pj0JLEn9mFlltBbnoAyL34voCCnEdSEnt7E/9RyGRbGOfJUBSwXFuXwNYK2U1jKvT
 zcR1pLSmWDLFvIkSe9cvq+SMK9QPem5/oC+RRrx3gDVumOsYM1LNAcwAdf8wLI4tzM9dVmKpycs
 Wd4309UmaUv/eLKbeCav3vaRHMh9Jzq32k2sEuTupAyUxa/KC1KVmjEf46fVeqcisaphRlDtp9K
 5oWxUIQjg4qKH5usA3ibWNU+4zjpl/S1bJ/Ma+5sSrQf3+N643AsQQsA/KHFQT31C6f4SLx3222
 jalQQZxSMl+fPDMgmMGOTuzlywrPwpmgKR052FqBjHTI2myNywNZte7WcwH5NcnN/F02kVIrqOx
 emAR2FvAXUlcWp7RLfBPbjVYQqaeozGYgj3WtCeAsnOTdbvhzS8l4LTxduqF+hmcfw6r6rKC7fp
 RKSucYRIOSzSiaOai/fjQtV+bvoQZBvcURM8aBOx5cBMGZqv4HlTm63Iup3GhWvKfVRb0qXpw6C
 I6bAmGZcxCCG7htXAQ+f7dNwIrJa9J3HCcLi6tmjcvyhqCXPo95h1Bjx7/QaD32BDd5Qhw9uGnh
 q8/kK4ADpg2CrWg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only the in-kernel PM uses the number of address and subflow limits
allowed per connection.

It then makes more sense not to display such info when other PMs are
used not to confuse the userspace by showing limits not being used.

While at it, we can get rid of the "val" variable and add indentations
instead.

It would have been good to have done this modification directly in
commit 3fd4c2a2d672 ("mptcp: bypass in-kernel PM restrictions for non-kernel PMs")
but as we change a bit the behaviour, it is fine not to backport it to
stable.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/sockopt.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 5cef4d3d21ac..b655cebda0f3 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -885,7 +885,6 @@ static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 {
 	u32 flags = 0;
-	u8 val;
 
 	memset(info, 0, sizeof(*info));
 
@@ -893,12 +892,19 @@ void mptcp_diag_fill_info(struct mptcp_sock *msk, struct mptcp_info *info)
 	info->mptcpi_add_addr_signal = READ_ONCE(msk->pm.add_addr_signaled);
 	info->mptcpi_add_addr_accepted = READ_ONCE(msk->pm.add_addr_accepted);
 	info->mptcpi_local_addr_used = READ_ONCE(msk->pm.local_addr_used);
-	info->mptcpi_subflows_max = mptcp_pm_get_subflows_max(msk);
-	val = mptcp_pm_get_add_addr_signal_max(msk);
-	info->mptcpi_add_addr_signal_max = val;
-	val = mptcp_pm_get_add_addr_accept_max(msk);
-	info->mptcpi_add_addr_accepted_max = val;
-	info->mptcpi_local_addr_max = mptcp_pm_get_local_addr_max(msk);
+
+	/* The following limits only make sense for the in-kernel PM */
+	if (mptcp_pm_is_kernel(msk)) {
+		info->mptcpi_subflows_max =
+			mptcp_pm_get_subflows_max(msk);
+		info->mptcpi_add_addr_signal_max =
+			mptcp_pm_get_add_addr_signal_max(msk);
+		info->mptcpi_add_addr_accepted_max =
+			mptcp_pm_get_add_addr_accept_max(msk);
+		info->mptcpi_local_addr_max =
+			mptcp_pm_get_local_addr_max(msk);
+	}
+
 	if (test_bit(MPTCP_FALLBACK_DONE, &msk->flags))
 		flags |= MPTCP_INFO_FLAG_FALLBACK;
 	if (READ_ONCE(msk->can_ack))

-- 
2.39.2

