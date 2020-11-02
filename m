Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210E42A2D16
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 15:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgKBOit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 09:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgKBOit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 09:38:49 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF5DC0617A6;
        Mon,  2 Nov 2020 06:38:49 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id f21so6894361plr.5;
        Mon, 02 Nov 2020 06:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2sn9IlsAf/o9PWSnZUDacWvGJDMDAyE7jKOu80Z9/XQ=;
        b=NQ/gal9zzj2UqO3cAXsmHskedL493eGjFym6fPXH9qBstkQNuhYGfz/cumaLHhEwy5
         Q0lRD9kCA7ftBWsukFlgcPDc+FqT8IMRZSZO1/5f0lcStW8e8U+Y3l7EGiSzns7Aej0k
         IEz3QV61BRuLkPW+698vYxNtt3okkp/W2imR6Cjkr0flzsQg7WmhohibsRE5ebqGx2/2
         swHHF4uixV6q2Qu2iJSDAhp+Ucnskdcl/SFc9cmiPnNb6hdHPf74yxNcWgTllh+Q2In/
         njKUbFGis5ARnc2axQpcS1TyWxxZ7fZf/etN+/m1URj5yE54tbrL1S3OGxjZcPivRPST
         qGkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2sn9IlsAf/o9PWSnZUDacWvGJDMDAyE7jKOu80Z9/XQ=;
        b=bumkVOkHKMXkfg+2cPA8lROZY9mI+LLMucnR0dMYl3z/2xZNbGT9UbVRZIi0BmNweM
         uC5b1S+0MaANT5brTietXZKxl/8rbrvjuFcRVTGbmd/4jjd0QqEde1yKkuPBWdX8NpGX
         8KsNTP1XgLa4BY3EgTN8H/EB0oG4Xg4mziCdrEWb7IYkhWE4JcIP2YCqGRJ8yhQHFJHF
         ZHUS3Y9j5dwJoQxYRi/RG5R2HmX2lyWfnbo+F/eRHMhH/IsEAd+OaORd5bq1DmuIOwHg
         x8KDtwzE7BgRVjmbTE5vGnSOn8lYPGjXRI5TB7g3lG/dlggeu+aQzyHWfVw1tQiyeTD/
         FM2w==
X-Gm-Message-State: AOAM531eoTrh1u3Oo8hiWwOBpBny1e64SeN6TlizcZKJvQT1NfTorm9c
        O12NbUP790/MfX5HYaBTuOw=
X-Google-Smtp-Source: ABdhPJw2IijvFH0YG4q0KgzcaAPpdd6MlJv8jjS6BLDflCWUrk9NvLv0pzwQ1iGIwwaiLl1SFqK6sw==
X-Received: by 2002:a17:902:848e:b029:d6:d2c9:1d4c with SMTP id c14-20020a170902848eb02900d6d2c91d4cmr3358980plo.40.1604327928861;
        Mon, 02 Nov 2020 06:38:48 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id l129sm12900610pgl.3.2020.11.02.06.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:38:48 -0800 (PST)
From:   Menglong Dong <menglong8.dong@gmail.com>
To:     roopa@nvidia.com
Cc:     nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH] net: bridge: disable multicast while delete bridge
Date:   Mon,  2 Nov 2020 22:38:28 +0800
Message-Id: <20201102143828.5286-1-menglong8.dong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

This commit seems make no sense, as bridge is destroyed when
br_multicast_dev_del is called.

In commit b1b9d366028f
("bridge: move bridge multicast cleanup to ndo_uninit"), Xin Long
fixed the use-after-free panic in br_multicast_group_expired by
moving br_multicast_dev_del to ndo_uninit. However, that patch is
not applied to 4.4.X, and the bug exists.

Fix that bug by disabling multicast in br_multicast_dev_del for
4.4.X, and there is no harm for other branches.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 net/bridge/br_multicast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index eae898c3cff7..9992fdff2951 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3369,6 +3369,7 @@ void br_multicast_dev_del(struct net_bridge *br)
 	hlist_for_each_entry_safe(mp, tmp, &br->mdb_list, mdb_node)
 		br_multicast_del_mdb_entry(mp);
 	hlist_move_list(&br->mcast_gc_list, &deleted_head);
+	br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
 	spin_unlock_bh(&br->multicast_lock);
 
 	br_multicast_gc(&deleted_head);
-- 
2.25.1

