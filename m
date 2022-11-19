Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11E85630924
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiKSCLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:11:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKSCLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:11:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401DC2B602;
        Fri, 18 Nov 2022 18:11:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3AEAB82670;
        Sat, 19 Nov 2022 02:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E75C433D6;
        Sat, 19 Nov 2022 02:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668823889;
        bh=FV9cKpXU40ig1PLuoNySucKUItQdqkjAvnyrw0XqHSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xqui0203d2tMKEa1PDdyAfLPl0SCHcC3AFot9Jl+N2uLcfWT2dIzgbsd76YxhQtPR
         uThKRP+/orGcYphMJkShjd77oiCljvujhacH851JR6qvzi1oFMjJ1eTe/ak2fa4kmX
         74Nk3OLqCcczYyEgiopedJ6SLfh3QrDQbSXF0Y3KHkMpEZWvfso/pF6FPI5f9Y7TIA
         4CzVKk38NKrB9b8AwAqHSaDg1OXYPKrNOSzZl3onR3uygZkakxL21aM1Ubx2KHdjk7
         7euS4AUUhWC08l4UqR9CoR++d3sy77UPXIyvUUsPvVPX3v7+nzRpqk6rG+7myG2Ov2
         AWq+wfo9Lufxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Zhang <quic_paulz@quicinc.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 02/44] wifi: cfg80211: Fix bitrates overflow issue
Date:   Fri, 18 Nov 2022 21:10:42 -0500
Message-Id: <20221119021124.1773699-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021124.1773699-1-sashal@kernel.org>
References: <20221119021124.1773699-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Zhang <quic_paulz@quicinc.com>

[ Upstream commit 18429c51c7ff6e6bfd627316c54670230967a7e5 ]

When invoking function cfg80211_calculate_bitrate_eht about
(320 MHz, EHT-MCS 13, EHT-NSS 2, EHT-GI 0), which means the
parameters as flags: 0x80, bw: 7, mcs: 13, eht_gi: 0, nss: 2,
this formula (result * rate->nss) will overflow and causes
the returned bitrate to be 3959 when it should be 57646.

Here is the explanation:
 u64 tmp;
 u32 result;
 …
 /* tmp = result = 4 * rates_996[0]
  *     = 4 * 480388888 = 0x72889c60
  */
 tmp = result;

 /* tmp = 0x72889c60 * 6144 = 0xabccea90000 */
 tmp *= SCALE;

 /* tmp = 0xabccea90000 / mcs_divisors[13]
  *     = 0xabccea90000 / 5120 = 0x8970bba6
  */
 do_div(tmp, mcs_divisors[rate->mcs]);

 /* result = 0x8970bba6 */
 result = tmp;

 /* normally (result * rate->nss) = 0x8970bba6 * 2 = 0x112e1774c,
  * but since result is u32, (result * rate->nss) = 0x12e1774c,
  * overflow happens and it loses the highest bit.
  * Then result =  0x12e1774c / 8 = 39595753,
  */
 result = (result * rate->nss) / 8;

Signed-off-by: Paul Zhang <quic_paulz@quicinc.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 775836f6785a..450d609b512a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1555,10 +1555,12 @@ static u32 cfg80211_calculate_bitrate_eht(struct rate_info *rate)
 	tmp = result;
 	tmp *= SCALE;
 	do_div(tmp, mcs_divisors[rate->mcs]);
-	result = tmp;
 
 	/* and take NSS */
-	result = (result * rate->nss) / 8;
+	tmp *= rate->nss;
+	do_div(tmp, 8);
+
+	result = tmp;
 
 	return result / 10000;
 }
-- 
2.35.1

