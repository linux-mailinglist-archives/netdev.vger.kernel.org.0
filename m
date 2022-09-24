Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1465E8F65
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 20:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiIXSlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 14:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIXSlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 14:41:03 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0CC13D58;
        Sat, 24 Sep 2022 11:41:01 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1280590722dso4416625fac.1;
        Sat, 24 Sep 2022 11:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=8JOtQBvvLW72XVECmck79YSCsfPdNEq7ykuouwI7PTQ=;
        b=MSxyC2yaJeJFCrV3/oDu6uv9ePg9BMYRIryj1KMAIrVpi3mTBGxkNUVnBCzgaPf6bQ
         +/GAysqPfj3fNGaTMTI916aGvO/Kwmj737GqoNXXw7V2s8ebEHLwT57AyPSTBouiZXNX
         cIkj15f08jmn2QkGa79lkBiIb8bE2WGgK9N9+72jGgo5L2uF2bzet43DfGHA2SHYbzYX
         3A3MxbO3ys2lktiyS/iQQ1ulZv5lXOjPl39ygxpP6mzK0QXGv1DID2Mi3zjTua7n5ulu
         D2/fyyEmqJZ7uc6PPC/9/PVJ4rtEbwTd23xTbUoCRrAhBsCj2xQP/qYWNj8C8p0ON/2n
         YSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=8JOtQBvvLW72XVECmck79YSCsfPdNEq7ykuouwI7PTQ=;
        b=1k+EQGgy1H+AlO2qx8ps4Aix/o1asbCQ9xEknxYSxPPm7lErXbal8+R29z1EVFq3Ml
         eKlSfUWHOmVo2/j+W9mZfTKGg6nslLT4Yhxdhk/1PjHRHOU0hUh7anSmWofYXDsbvNKO
         CIS+yzQ62vY1g6jW5OxKAGy8zSBynlVYxOvUP9FjqCaY+p7XYR6kAUzDMOv+snHpdbLD
         lHGMTVV9K9Mb5EdigqWO8zDL5578CI0MclENQd8X59PaZIHfs12HSrL2Osn/i3n8AFDO
         0Mv0NFmNijzUJOOMQsUCcAOHXVtB65ZCDGLt2Y5aCSlk+3Kf/QSfw/uqVn/IIc7gd/HW
         x2cg==
X-Gm-Message-State: ACrzQf2HIjIqivGD4Kq6zQ19l4uAOgiL1fyLQPgHTojZ6RCVGR6774o4
        GgmM0Uru4DHLfAlxt/zMkVg=
X-Google-Smtp-Source: AMsMyM7/QppKaCvZ9AfPDnSI2olE5YiSRYcrHUcuFRLuFzHDidrPoBxkEIbi+YYShIqiI6EKekT7vw==
X-Received: by 2002:a05:6870:c213:b0:127:a748:4aab with SMTP id z19-20020a056870c21300b00127a7484aabmr14139381oae.52.1664044860580;
        Sat, 24 Sep 2022 11:41:00 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:3499:8fa2:1bc4:de36:509f])
        by smtp.gmail.com with ESMTPSA id e5-20020a056870c0c500b001275f056133sm6519090oad.51.2022.09.24.11.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 11:41:00 -0700 (PDT)
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
Subject: [PATCH] wifi: mac80211: mlme: Fix missing unlock on beacon RX
Date:   Sat, 24 Sep 2022 15:40:41 -0300
Message-Id: <20220924184042.778676-1-rafaelmendsr@gmail.com>
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

Commit 98b0b467466c ("wifi: mac80211: mlme: use correct link_sta")
switched to link station instead of deflink and added some checks to do
that, which are done with the 'sta_mtx' mutex held. However, the error
path of these checks does not unlock 'sta_mtx' before returning.

Fixes: 98b0b467466c ("wifi: mac80211: mlme: use correct link_sta")
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
---
 net/mac80211/mlme.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5265d2b6db12..c0fbffd9b153 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5589,12 +5589,16 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, sdata->vif.cfg.ap_addr);
-	if (WARN_ON(!sta))
+	if (WARN_ON(!sta)) {
+		mutex_unlock(&local->sta_mtx);
 		goto free;
+	}
 	link_sta = rcu_dereference_protected(sta->link[link->link_id],
 					     lockdep_is_held(&local->sta_mtx));
-	if (WARN_ON(!link_sta))
+	if (WARN_ON(!link_sta)) {
+		mutex_unlock(&local->sta_mtx);
 		goto free;
+	}
 
 	changed |= ieee80211_recalc_twt_req(link, link_sta, elems);
 
-- 
2.34.1

