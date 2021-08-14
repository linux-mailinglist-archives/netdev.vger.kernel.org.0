Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10243EC60B
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 01:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhHNXnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 19:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhHNXnh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 19:43:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 444C560F48;
        Sat, 14 Aug 2021 23:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628984588;
        bh=nipsjhHCi02+bGpq1NI464aFtAGGb9opafHbiKjdbAk=;
        h=From:To:Cc:Subject:Date:From;
        b=NTmxIQK/EkQOFxz+Xj/L87q6LcD8LiYeqfoc4xP4rA2cz2SmOuHYC1gA9FKLTXRpg
         reS/Bqdu/G2FhmszJ5kju49LberxoEgcbU8IBLkFuDS+Vq/AyGz30/GvVkhPXWy8LO
         esXjdw5LXXy8ezNboutxGMH0xS4G5M7Adf7ayP84tkfNieRUU4Ss4aOzBEISHAzmqb
         OIzCxY8ydFUg0JrwMd4hr7EQUABddM5yiJ+8e0OZPFbMxuSit6X7PGJaohAuv+XnEl
         CR2msEbk7VRUe37vE7JUuh6ZSwhlfzRJYqxhXdUGgK0bNK9LQ4eBsNdP36nGfkvlAL
         mwiuHv/9Ztokg==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] iwlwifi: mvm: Fix bitwise vs logical operator in iwl_mvm_scan_fits()
Date:   Sat, 14 Aug 2021 16:42:48 -0700
Message-Id: <20210814234248.1755703-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0.rc2
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/wireless/intel/iwlwifi/mvm/scan.c:835:3: warning: bitwise
and of boolean expressions; did you mean logical and?
[-Wbool-operation-and]
                (n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                                    &&
1 warning generated.

Replace the bitwise AND with a logical one to solve the warning, which
is clearly what was intended.

Fixes: 999d2568ee0c ("iwlwifi: mvm: combine scan size checks into a common function")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 0368b7101222..494379fc9224 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -832,7 +832,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 				     int n_channels)
 {
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
-		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
+		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &&
 		(ies->common_ie_len +
 		 ies->len[NL80211_BAND_2GHZ] +
 		 ies->len[NL80211_BAND_5GHZ] <=

base-commit: ba31f97d43be41ca99ab72a6131d7c226306865f
-- 
2.33.0.rc2

