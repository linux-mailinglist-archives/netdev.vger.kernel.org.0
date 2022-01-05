Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C01485713
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242159AbiAERI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242157AbiAERIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 12:08:54 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B48C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 09:08:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id j16so27637pll.10
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 09:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Cw+kSmh3qidWp8seDKtiehDtN7HN/f+44m8eCLTHA4=;
        b=QFXRS5qNKAlc3XdfWnLXjf1wCj5DFZSffgC8cyhdI+cNKKfgwabtaRygRDo7D1kKlS
         zuM1fOPOCcAwxVTn5JaUmdsE6ZeDD6AS0tl4E0BZiD6hMgK8pyebAht/7SA9ltLqV2jk
         SrP01nqEHDgDHcBJzF8HOtnlogwcgLrNuGYDUyD9klvFCq4bGWKj+k5ncI8/b7xg5MmL
         yrzWDSCRNmCOfLx/R+sGdbYOuh+Jeac5t6Y00AY5zvOKMB5ASoELJr091A8qLcMGv2DQ
         HLY99dft6XAUzh6SzGtl5rmRZ5LGAMuj83zH2Xo98iFho4Ml6G/mBwpORJLoSPtgTn/P
         NNMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6Cw+kSmh3qidWp8seDKtiehDtN7HN/f+44m8eCLTHA4=;
        b=hdqy2c//WuPZghthAZ3Ezdlmp3h6o29rpLrkUkyzOlzSPhbPoq6RRArm5QL5G9mg7F
         rHfpXBVD3eAQsRu2oEqPvo+PCHUmpCaIbKbUwRYPbc6A0kz5gVvvI3IpGXud9bCBBbxJ
         vJ8bsi3p35CpUamnldJuDC+SgU+SDkrOVwWBDoih0jv/F2lNreBW5TK37Lr12bHYwmux
         VAdxtZeHQCdyfj6okbS6q9Nr6zmlw9q1dck/bpYC2eEiS4DYh8Vz3Bpx8aJ6d7GeDgQz
         3JRmI4O3HSc4c3LLgKkRSZrbprmPbHf0Q1aXnwFvbJvPi2vWnNNEDRPeP4Nn0+bYqJtr
         aQEQ==
X-Gm-Message-State: AOAM531eCQcdLSmIFVHpQyCtIqJJiWz5+R2mQEPLJlqdnZot78bxSVEn
        rIiHimjIZTnq2ArMHw2TCCI=
X-Google-Smtp-Source: ABdhPJyM/YHq8Gg9iopAQiHSMN9DM4xp16Wd36Izk3iG8q3HeRK/SqlDjcSDIH2DCVoxCw42v6qOHg==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr5168768pjb.143.1641402533439;
        Wed, 05 Jan 2022 09:08:53 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2814:439c:a4c8:3675])
        by smtp.gmail.com with ESMTPSA id p37sm43808182pfh.97.2022.01.05.09.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 09:08:53 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH net-next] netlink: do not allocate a device refcount tracker in ethnl_default_notify()
Date:   Wed,  5 Jan 2022 09:08:49 -0800
Message-Id: <20220105170849.2610470-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As reported by Johannes, the tracker allocated in
ethnl_default_notify() is not really needed, as this
function is not expected to change a device reference count.

Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/ethtool/netlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ea23659fab28c734d1a8c11d857b3795f104beec..5fe8f4ae2cebc48eed6d0ce2b9d6607546e66bd6 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -627,7 +627,6 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	}
 
 	req_info->dev = dev;
-	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
 	req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
 
 	ethnl_init_reply_data(reply_data, ops, dev);
-- 
2.34.1.448.ga2b2bfdf31-goog

