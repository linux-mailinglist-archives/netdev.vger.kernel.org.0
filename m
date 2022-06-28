Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C912755C98C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243553AbiF1CWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243638AbiF1CVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:21:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F2A24F02;
        Mon, 27 Jun 2022 19:20:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5124B81C00;
        Tue, 28 Jun 2022 02:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91363C385A9;
        Tue, 28 Jun 2022 02:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382849;
        bh=fnbjg2y5q4ORZyOyzWa2ckHS44WEdmOAUqXEWcMqugI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ka2Up4koD9AAuSD6T8RqcnF0V/6UYnJG6MyPk2oUtP8uC6Z/dm/0kn5Vc9NWWA0ZS
         jeaH3+Bpi6ZO/LMf3Ct++cIciM+sUXUe3s/ce539vInxug7CDqKBt43F7dm/wj2hI5
         E8DD/vlnyDEmpZG86C2DWTvMFsn+9lKT+ZFzXaqITIwbVa0UdC+d12ap7bh6djbEqi
         TnC1lEa1EJJoJIJMjKbMV3zfgGJ8MFURdfg2bVtQG8PLf8hSAn8H3QSn3jtvSdnRuM
         clx5Fywu0BWJg7TYQUjsNaObkJq5L9tP8/8cmM55X+s8Snu0n07LqyvG8+A9tNNGnz
         4Ur0Q6aVLl5yQ==
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
        jiri@nvidia.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 49/53] hinic: Replace memcpy() with direct assignment
Date:   Mon, 27 Jun 2022 22:18:35 -0400
Message-Id: <20220628021839.594423-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
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
index 60ae8bfc5f69..1749d26f4bef 100644
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

