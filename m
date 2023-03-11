Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D929A6B5CC8
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjCKOVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCKOVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:21:23 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087CE72BF;
        Sat, 11 Mar 2023 06:20:10 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 8F0B742625;
        Sat, 11 Mar 2023 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1678544382; bh=K9gl8fahgYUMVFftdPQMDoNmStusBGDJI/NXoxPhu6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=tDGxqR5NqPgL2zB++YbolTcp9fLpui6CI9QgypZYnAKvKSPFLGWtT5J8uq7Fp0cr3
         2K8k2vlMH9b80XRTWwJ3MHYk7rafN7T9fLGJYUrG7NcnUaUi7Kccjiwwa5wxqrpN3g
         EzwZ58hpqwF3JxIt7H6OSIdw5IT1GGTP6P/mcHcPS5sNwWwOJtL882tKe36RolVUnB
         JIBwRQMVVi0NlPeKnDi86DAfxI8YgPoazmmcQGTReFc4IMRAOaLAjewdNRk87w/W3y
         PvSTaM7mRJNKhskVL7D94KA+yKBAgTqcgmETBylstCjSfDl3JQLfxcTUZbRx1UpO+7
         uOsNT2wDRfcGg==
From:   Hector Martin <marcan@marcan.st>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
Cc:     Ilya <me@0upti.me>, Janne Grunau <j@jannau.net>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, asahi@lists.linux.dev,
        Hector Martin <marcan@marcan.st>
Subject: [PATCH] wifi: cfg80211: Partial revert "wifi: cfg80211: Fix use after free for wext"
Date:   Sat, 11 Mar 2023 23:19:14 +0900
Message-Id: <20230311141914.24444-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st>
References: <d6851c2b-7966-6cb4-a51c-7268c60e0a86@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts part of commit 015b8cc5e7c4 ("wifi: cfg80211: Fix use after
free for wext")

This commit broke WPA offload by unconditionally clearing the crypto
modes for non-WEP connections. Drop that part of the patch.

Fixes: 015b8cc5e7c4 ("wifi: cfg80211: Fix use after free for wext")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-wireless/ZAx0TWRBlGfv7pNl@kroah.com/T/#m11e6e0915ab8fa19ce8bc9695ab288c0fe018edf
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 net/wireless/sme.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 28ce13840a88..7bdeb8eea92d 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1500,8 +1500,6 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		connect->key = NULL;
 		connect->key_len = 0;
 		connect->key_idx = 0;
-		connect->crypto.cipher_group = 0;
-		connect->crypto.n_ciphers_pairwise = 0;
 	}

 	wdev->connect_keys = connkeys;
--
2.35.1

