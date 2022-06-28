Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58A955E244
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244123AbiF1CX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244121AbiF1CXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19BF24BC1;
        Mon, 27 Jun 2022 19:22:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BC36617D4;
        Tue, 28 Jun 2022 02:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8839C34115;
        Tue, 28 Jun 2022 02:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382951;
        bh=uhhm1hQwl9GEenymTrnKlp8FI+WMSqOom27CaC4a0TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FytOubyi8kx1X0BhRQZaPpcIwxEJbmswkAWLVcDvV+dxXkWi3K4i6sq29f4BQ753J
         wbetYaIc/W68lo2CjBXvQ1mC1zajx/YhH1ZhHRKmSj4Cymr9cwEtDtGYZIWWoh+vng
         1LlIQjHyRBdQWQTQGZlsNqxySNEOflWliZa+1ADt6Vi0Fib0JZB4UoOQf3rs/TWl3G
         NmRvPxnuuJ3qf1c/tU4B1jIbZiPtJjgovuILtdH23+NKZXDHy/XNIR7dT3qzH+/7iB
         CRsUyjZRKqOe5l60y4LTQ/mca5JXZ5EKRdG/nT71fOvUJcwkzdve3M8rr1a/6nnAgn
         GZjPnnT0FFiFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, llvm@lists.linux.dev,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
        jiri@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 37/41] hinic: Replace memcpy() with direct assignment
Date:   Mon, 27 Jun 2022 22:20:56 -0400
Message-Id: <20220628022100.595243-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022100.595243-1-sashal@kernel.org>
References: <20220628022100.595243-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 1e70212e031528918066a631c9fdccda93a1ffaa ]

Under CONFIG_FORTIFY_SOURCE=y and CONFIG_UBSAN_BOUNDS=y, Clang is bugged
here for calculating the size of the destination buffer (0x10 instead of
0x14). This copy is a fixed size (sizeof(struct fw_section_info_st)), with
the source and dest being struct fw_section_info_st, so the memcpy should
be safe, assuming the index is within bounds, which is UBSAN_BOUNDS's
responsibility to figure out.

Avoid the whole thing and just do a direct assignment. This results in
no change to the executable code.

[This is a duplicate of commit 2c0ab32b73cf ("hinic: Replace memcpy()
 with direct assignment") which was applied to net-next.]

Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: llvm@lists.linux.dev
Link: https://github.com/ClangBuiltLinux/linux/issues/1592
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Link: https://lore.kernel.org/r/20220616052312.292861-1-keescook@chromium.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index 6e11ee339f12..92d4e0039565 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -43,9 +43,7 @@ static bool check_image_valid(struct hinic_devlink_priv *priv, const u8 *buf,
 
 	for (i = 0; i < fw_image->fw_info.fw_section_cnt; i++) {
 		len += fw_image->fw_section_info[i].fw_section_len;
-		memcpy(&host_image->image_section_info[i],
-		       &fw_image->fw_section_info[i],
-		       sizeof(struct fw_section_info_st));
+		host_image->image_section_info[i] = fw_image->fw_section_info[i];
 	}
 
 	if (len != fw_image->fw_len ||
-- 
2.35.1

