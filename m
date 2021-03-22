Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E72344A60
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbhCVQFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhCVQEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:04:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60C55619A7;
        Mon, 22 Mar 2021 16:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616429056;
        bh=n4YjjyF/BQX1oLI53brWrn/ZFErJefAlbdz/B6a/LhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PJL0qpPDqSs2z7UPLYK5QVJo9sc76O7NWlWo5JPHSsPqGyDVDF4pF7hWXIkB1JA75
         QpQt35+7BgO8L8Mn3URqgy3oEgZ8mXFVdUTizaV6t4aX9h9ExQGoEX/rwcyz2jamB2
         scTuPUkDJISJZufdWGtFTIeZztxCxD3lXQOLujQyrS4sySOSS+Y/vZY+qg8LWnqJQL
         I/Aimz84KOYue+E+Dz/GzEJ2kjYrLgh/PeozYrKn1GELVG7ePD4iEbNB0WU3el9Rvz
         crDXO284w80Ehtcr/BjQheDrwVIVIOc3LE73CNZdbBcsVLFqijc8sIiXIjFKbmSQwm
         LtmW3NkvnLTfA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Carl Huang <cjhuang@codeaurora.org>,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ritesh Singh <ritesi@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Aloka Dixit <alokad@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 04/11] ath11: Wstringop-overread warning
Date:   Mon, 22 Mar 2021 17:02:42 +0100
Message-Id: <20210322160253.4032422-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

gcc-11 with the kernel address sanitizer prints a warning for this
driver:

In function 'ath11k_peer_assoc_h_vht',
    inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:1632:2:
drivers/net/wireless/ath/ath11k/mac.c:1164:13: error: 'ath11k_peer_assoc_h_vht_masked' reading 16 bytes from a region of size 4 [-Werror=stringop-overread]
 1164 |         if (ath11k_peer_assoc_h_vht_masked(vht_mcs_mask))
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:1164:13: note: referencing argument 1 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:969:1: note: in a call to function 'ath11k_peer_assoc_h_vht_masked'
  969 | ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
      | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

According to analysis from gcc developers, this is a glitch in the
way gcc tracks the size of struct members. This should really get
fixed in gcc, but it's also easy to work around this instance
by changing the function prototype to no include the length of
the array.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99673
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b391169576e2..5cb7ed53f3c4 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -966,7 +966,7 @@ ath11k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 }
 
 static bool
-ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[])
 {
 	int nss;
 
-- 
2.29.2

