Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545C53251E5
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhBYPBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhBYPAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 10:00:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 383B864E83;
        Thu, 25 Feb 2021 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614265202;
        bh=4wzLdHIu+jiyPmW3PiOzDadifaMBPSqSTbdxzwLIE1c=;
        h=From:To:Cc:Subject:Date:From;
        b=G1oBjB6uOoC4UCHfTV2LUsCGDAd0MUJCZE95YTtfWF5Cch4L5tnf75prgLq19fCv1
         Zxx6a02DtrC6TzcyNu9066IZV5lBGowkcmlTc6MWj0gqquXzJ4Nca6HENTdXp2HXVQ
         YQ62sJ27DR/kG3CXW12s+6Mh2ayEePgl8nIZpqciUkFWCTojN5gnydDK1B5a/JhV1j
         a4mQU/n6dOxQQ5INkCevueTCy2svlyxM6x6wL5P2fw5WMOt9l8UNwojwQXWEljA7mX
         DJAp5dew5ZMgzfRYGe9Djth9Y4PXO9S15ZM2R+4rGlos00owsJUlV6CxX/8nZCD2N4
         xxZHdY6Mwvj6g==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH 1/2] mt76: mt7915: fix unused 'mode' variable
Date:   Thu, 25 Feb 2021 15:59:14 +0100
Message-Id: <20210225145953.404859-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang points out a possible corner case in the mt7915_tm_set_tx_cont()
function if called with invalid arguments:

drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:593:2: warning: variable 'mode' is used uninitialized whenever switch default is taken [-Wsometimes-uninitialized]
        default:
        ^~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:597:13: note: uninitialized use occurs here
        rateval =  mode << 6 | rate_idx;
                   ^~~~
drivers/net/wireless/mediatek/mt76/mt7915/testmode.c:506:37: note: initialize the variable 'mode' to silence this warning
        u8 rate_idx = td->tx_rate_idx, mode;
                                           ^

Change it to return an error instead of continuing with invalid data
here.

Fixes: 3f0caa3cbf94 ("mt76: mt7915: add support for continuous tx in testmode")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt7915/testmode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
index 7fb2170a9561..aa629e1fb420 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
@@ -543,6 +543,7 @@ mt7915_tm_set_tx_cont(struct mt7915_phy *phy, bool en)
 		tx_cont->bw = CMD_CBW_20MHZ;
 		break;
 	default:
+		return -EINVAL;
 		break;
 	}
 
@@ -591,6 +592,7 @@ mt7915_tm_set_tx_cont(struct mt7915_phy *phy, bool en)
 		mode = MT_PHY_TYPE_HE_MU;
 		break;
 	default:
+		return -EINVAL;
 		break;
 	}
 
-- 
2.29.2

