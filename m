Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079C143FFC7
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhJ2Pph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhJ2Ppf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 11:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E1B861181;
        Fri, 29 Oct 2021 15:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635522185;
        bh=EKpljgVa5r5UmD2IEpypElISm7qojaXBWVSnqjIx8EI=;
        h=From:To:Cc:Subject:Date:From;
        b=DUE9p0WKnSWBxCzU791qowB58og7xeQNSE+jvOr1AKoxKnhkoir2yzs78lYIslDXB
         FkE/zSncUhI2lA2tKUexN3X3Q5AYvoam/0VqTPisHApFRfY6pSFASrjziUwf9cJw/J
         5EqV9PzRuXmjhWYvbpOSI2a+sC27jG+66ztNgD0SlLfEnCP9xi7yZw5bnkU7zq1yNk
         Zi0z7TpI3fQL3b2Xepxi1+kZRIozugkx+CwlqoEAJSOQXpXOELDKtHcvPADLl9vrx3
         pZay4F1IeCUQPTS7H2FclvL4K6vt+ZMEB97l1RFIB+DbfJHN4Pz1kak4gspPq3KprB
         AgktZwKqMjE0A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Yaara Baruch <yaara.baruch@intel.com>,
        Matti Gottlieb <matti.gottlieb@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH] iwlwifi: pcie: fix constant-conversion warning
Date:   Fri, 29 Oct 2021 17:42:29 +0200
Message-Id: <20211029154253.3824677-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang points out a potential issue with integer overflow when
the iwl_dev_info_table[] array is empty:

drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1344:42: error: implicit conversion from 'unsigned long' to 'int' changes value from 18446744073709551615 to -1 [-Werror,-Wconstant-conversion]
        for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
               ~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~

This is still harmless, as the loop correctly terminates, but adding
an (int) cast makes that clearer to the compiler.

Fixes: 3f7320428fa4 ("iwlwifi: pcie: simplify iwl_pci_find_dev_info()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index c574f041f096..81e8f2fc4982 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1341,7 +1341,7 @@ iwl_pci_find_dev_info(u16 device, u16 subsystem_device,
 {
 	int i;
 
-	for (i = ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
+	for (i = (int)ARRAY_SIZE(iwl_dev_info_table) - 1; i >= 0; i--) {
 		const struct iwl_dev_info *dev_info = &iwl_dev_info_table[i];
 
 		if (dev_info->device != (u16)IWL_CFG_ANY &&
-- 
2.29.2

