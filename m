Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A4F5E93A3
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIYOek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiIYOef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 10:34:35 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B47D46;
        Sun, 25 Sep 2022 07:34:31 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1278a61bd57so6344042fac.7;
        Sun, 25 Sep 2022 07:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=xj8bxFNFhBfMBy/4Wjr6E+CZ0TGU1nQFmryKPuPzrwc=;
        b=fVfi6cikVeeDJjLVkIoqBFuvSKdYaGimWvnOdIIA5PfpqBYCMDL385F5nfjEPTYfpw
         dgUlIazkAMsG3NmuIZLCVQbiL0Yy4s8x6zmDnPI32zuDPmDoHphOC4SvgGsHcfaxa88u
         YWxdKwuyU6ihKmdcZgysHh6tJ5Ic/O6yJZBKL5oGLljugHJYS2Tgic5sJ1Ciw5DJkNhX
         CGNTXQBn1GhohOnbeWJGPYJshAQC/4r74Bw1Kkx0gwbaPytdhlDZCg2W4ngrYZYkEJSa
         lh9Q5fOTKhYFEPkofLCSsu5NjSega5cwPePDRyTioa4Oe3W8MhXYs+V/V/4Eb3Yc6D96
         yxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=xj8bxFNFhBfMBy/4Wjr6E+CZ0TGU1nQFmryKPuPzrwc=;
        b=SOQUTzAFKSXjGkOBjv0inWvatkEsfuDyqm8aEHP0P3koIh0HjafRLDZPLF8QaRL6HO
         UF02/B0QxaMZ6OXI+GEmNZK9zqWiVnJxJQTT5nh0uL/xW1W8+7AITjbly6WakpW/qrze
         OWGlxPt96iXfErF0gQCoBDtQGONjKgFOvYRYzX0TiPIW3ATgYfIkJn8v+N77J3g/Z2tT
         zszgK0Lp9mFSoPevK2NrRLJpyX6XVcwSsj0ILdfMJr1hKHdhzBeG0ev8LfVkmq6JCWw9
         tXOrIRkp2WmAds1/Poi3d9VGjSmv31tnHDvRoNCy3G3XHYk40950TSyuLyt3u7WrMhsm
         S8jw==
X-Gm-Message-State: ACrzQf1Usn/stGqabE7rYqYe1ureRb94b8tHraaDLcg+eom1sUhDVdFH
        70uG9WgufamkvgxAKYWjEWE=
X-Google-Smtp-Source: AMsMyM4LViTjiC11MOWKRsiKf31+wQlYtiSJ0G1npGvId24EAChh+uXF6fLFcdU4fWKk5KS1TXtloA==
X-Received: by 2002:a05:6870:51cd:b0:12c:dd21:304b with SMTP id b13-20020a05687051cd00b0012cdd21304bmr10060028oaj.77.1664116470355;
        Sun, 25 Sep 2022 07:34:30 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:3499:e0c5:70cf:7854:eb24])
        by smtp.gmail.com with ESMTPSA id p6-20020a9d76c6000000b00616e2d2204csm6659713otl.21.2022.09.25.07.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 07:34:30 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: mlme: Fix double unlock on assoc success handling
Date:   Sun, 25 Sep 2022 11:34:19 -0300
Message-Id: <20220925143420.784975-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 6911458dc428 ("wifi: mac80211: mlme: refactor assoc success
handling") moved the per-link setup out of ieee80211_assoc_success() into a
new function ieee80211_assoc_config_link() but missed to remove the unlock
of 'sta_mtx' in case of HE capability/operation missing on HE AP, which
leads to a double unlock:

ieee80211_assoc_success() {
    ...
    ieee80211_assoc_config_link() {
        ...
        if (!(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_HE) &&
            (!elems->he_cap || !elems->he_operation)) {
            mutex_unlock(&sdata->local->sta_mtx);
            ...
        }
        ...
    }
    ...
    mutex_unlock(&sdata->local->sta_mtx);
    ...
}

Fixes: 6911458dc428 ("wifi: mac80211: mlme: refactor assoc success handling")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
---
 net/mac80211/mlme.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5265d2b6db12..6ca9c4f2775c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4040,7 +4040,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 
 	if (!(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_HE) &&
 	    (!elems->he_cap || !elems->he_operation)) {
-		mutex_unlock(&sdata->local->sta_mtx);
 		sdata_info(sdata,
 			   "HE AP is missing HE capability/operation\n");
 		ret = false;
-- 
2.34.1

