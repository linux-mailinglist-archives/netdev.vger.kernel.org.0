Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5B93E1923
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhHEQKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhHEQKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:10:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB392C061765;
        Thu,  5 Aug 2021 09:10:25 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d8so7279022wrm.4;
        Thu, 05 Aug 2021 09:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iKwt2CNIQOHR6e39/4WlE1XM4D8qqPBdFFLhXvUbs2c=;
        b=J5bGjDNOFp2j9iyfmg82V9jCtpcc5O1GC71ukEsWWYT+yfexjP3VYacvaUx4qbXeMY
         YybRJe/HDOCNMGiDYzeBynzUerLNH4TZqly9nfSUdc4vFUXhO1VKivaBe79HPSqT26OL
         3/ZBzqUMIgVYu5eJlmBxG2sva4M1XSi1ljwhkY1XeXYzNrHAKiCTWbfuHutdInUWfJ7Y
         ShtD5EnJxOzs6F2AP5LWu/Uw36V+WM3n/wcY1dPFEYlVsCKID8tbAd3N+7KeQcA+n7BD
         2j4PMZ6rGV3Yz5J7Wak6oJ9OpbjWDcS2OpDvIRmHdL/gRGP1d+Pvqg0sGq0+6Uf9zQCG
         BKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iKwt2CNIQOHR6e39/4WlE1XM4D8qqPBdFFLhXvUbs2c=;
        b=Top+NSVdid8VsWxguy9rCWO1OG1ErAjR0ppEz/jK5elae33jL6rP3rTb/Tb8q0xGha
         lDPexj5GRKSUttZmuDBV6pZOd/XsHRWsYGwY/6O09eVf7nT7WYnUSIMboB9mOeY3/OP6
         X5w69FO7D8jlK7XgctY0VzDvgGSMmYosKGZV2zaRyI1/hBN8hq0IDxUb1eM3mhVHZvPk
         sHYBb6XrXcyuZZDh5DGwchJ/QsAizPbUFWd+3BGV9/Jwri3TfT2LNHN63pAvWMMVQbpz
         rl2CkzUWWxbvzJUi6glrUTjYdsrW3aSA0HI7fVE2yNN7kuT9UlAYutAx4uBnL8vSym6g
         a4mQ==
X-Gm-Message-State: AOAM5332IwQVwYU/nOUNRv/EOYmDM3482LBVk9DVJIt55bCU1WMSMxYI
        lxXYaRdp0s4Jd0Irlrv3ilNYZ3eJ93GcuJw=
X-Google-Smtp-Source: ABdhPJwVvbIuvq39q09RDCMohhcpSPBO+kGRedfJsVDHLGGYdoPeyKeDV6m7CXAV9GDH6AcIPMrCyQ==
X-Received: by 2002:a5d:4a84:: with SMTP id o4mr5999329wrq.273.1628179824121;
        Thu, 05 Aug 2021 09:10:24 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id n5sm5843968wme.47.2021.08.05.09.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 09:10:23 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v6 5/7] net: core: Allow netdev_lower_get_next_private_rcu in bh context
Date:   Sat, 31 Jul 2021 05:57:36 +0000
Message-Id: <20210731055738.16820-6-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210731055738.16820-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210731055738.16820-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the XDP bonding slave lookup to work in the NAPI poll context
in which the redudant rcu_read_lock() has been removed we have to
follow the same approach as in [1] and modify the WARN_ON to also
check rcu_read_lock_bh_held().

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=694cea395fded425008e93cd90cfdf7a451674af

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 27023ea933dd..ae1aecf97b58 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7588,7 +7588,7 @@ void *netdev_lower_get_next_private_rcu(struct net_device *dev,
 {
 	struct netdev_adjacent *lower;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 
 	lower = list_entry_rcu((*iter)->next, struct netdev_adjacent, list);
 
-- 
2.17.1

