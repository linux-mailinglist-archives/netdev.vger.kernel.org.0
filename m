Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F25948D22A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 07:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbiAMGDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 01:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiAMGDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 01:03:43 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415E8C061748
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:03:43 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s13-20020a252c0d000000b00611786a6925so9396980ybs.8
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 22:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:cc;
        bh=rRyEFmS7punxeQqOoiys20soJGTAicrW1PQEVjtcuOA=;
        b=UC0FFRMh7o2iv/d1ZaJ/LghgsJZH08kcjGW6ZhhwJ4hbYSY6P+mQaFSJDBtkIeisxh
         dMYTFNE35bneVl2jeioGSk0VZpsNrNj5umTNHSo7/WfBdW43ivLDm0uSMRRiN1q+wk18
         KUO68aRriqBmEwRu1X2MJ4F7pNMwbp3x5cG1qIhUeqa4uGQsEkK4wE/8puOTljUSMwxF
         bvjGIA8CNa10xPaJBAYSDpATqlY2HMsAksMnBkY1N10KeVbcV58t0I67QfSbqlDyIHqi
         7HCGiemBUd4/oKlwlhieXx+3JMxbst/olfPkK+vw2Dy7LIHVwPax+YlCJeOetB0tNcwu
         eOjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
        bh=rRyEFmS7punxeQqOoiys20soJGTAicrW1PQEVjtcuOA=;
        b=yAZx/CenA8eIwMkG1cIXLPr1k8e5M9r3+nuItwOkNc4vxYjxmy5qnR3erj1V7xhlIe
         NoTqbN/FGEG5c88vGVN80FJ6vUxguADEFGJhAEDRUPhAaG3ThYIZMFpy+Mr3hsKQXAG0
         eIevRbhkd0obhyr18SOxmu8B40UIDmF0AeMI5xb8nLJCjim1A8Fzy6Z3SPvhNu1MgeCc
         O4GquqGNCOcl50fEgx9Ac9+4ZFTpngh1JDJEKdwxu/AUMDw7GZdM49fiuIzMy/Ravudx
         +gmM2B+4miWCjFk8zoeUVIlDk77WCsNIp5psYeVVmFyF/+MlWUly7BAoqXHjWKHWCVz0
         Oeyg==
X-Gm-Message-State: AOAM531Xphv/KVjFW3zHLPk3yMjqAn6zjp2N6s7CkUJFj8MPraQXPTkD
        ZuA5hKiPTwlz1KI4DBXF/y796vXDqH4=
X-Google-Smtp-Source: ABdhPJxSiBZP+f3lo0Lf91MgLkH3gGGAomTSOZ3Jk/TA1UJ3E9WfxNaD7K60yMczdglZzeGoqktyox8bTi4=
X-Received: from jaeman.seo.corp.google.com ([2401:fa00:d:11:2232:d256:314c:979c])
 (user=jaeman job=sendgmr) by 2002:a05:6902:120f:: with SMTP id
 s15mr4571599ybu.390.1642053822522; Wed, 12 Jan 2022 22:03:42 -0800 (PST)
Date:   Thu, 13 Jan 2022 15:02:35 +0900
Message-Id: <20220113060235.546107-1-jaeman@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH] mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work
From:   JaeMan Park <jaeman@google.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        adelva@google.com, kernel-team@android.com,
        JaeMan Park <jaeman@google.com>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mac80211_hwsim, the probe_req frame is created and sent while
scanning. It is sent with ieee80211_tx_info which is not initialized.
Uninitialized ieee80211_tx_info can cause problems when using
mac80211_hwsim with wmediumd. wmediumd checks the tx_rates field of
ieee80211_tx_info and doesn't relay probe_req frame to other clients
even if it is a broadcasting message.

Call ieee80211_tx_prepare_skb() to initialize ieee80211_tx_info for
the probe_req that is created by hw_scan_work in mac80211_hwsim.

Signed-off-by: JaeMan Park <jaeman@google.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0307a6677907..95f1e4899231 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2336,6 +2336,13 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			if (!ieee80211_tx_prepare_skb(hwsim->hw,
+						      hwsim->hw_scan_vif,
+						      probe,
+						      hwsim->tmp_chan->band,
+						      NULL))
+				continue;
+
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
-- 
2.34.1.703.g22d0c6ccf7-goog

