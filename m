Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785CE3ED1AA
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbhHPKMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhHPKMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:12:17 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F28F2C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u3so30786637ejz.1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qrgX9mkMySys2qqZfdyzIpqPBGrmxciDBq8IvhkKYPo=;
        b=cmDpAUSYRrg5Wn2RkMba5vTWd2xWbMFOxoa+ArS1wP2A3xTvn78pMoTnrb8qTeBiLY
         kneDtQf74WnkI2Y8xMCOkEL/gge+e6DMyVtgAKp3SMVrLookOtcZeFx8YBuxXmhDkFpO
         Pqq/b1KF3IP88Y2kV+EaOUBcyyHLij/lIa60swjCeObNXPxJUzAbYdj51GmJEYbMP9TE
         xrZR0S/lsbex5/TQ0zjas2kpZfr56+LzwhujIWvIfstqZebToQzw4PneEFZ37bTSsI48
         wIvkNdDzUvFLcBJSPDm0+rK5SBz6d8knOvpompWfVA1NVeJm3lbsl1swCGvNHKWzs32L
         NHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qrgX9mkMySys2qqZfdyzIpqPBGrmxciDBq8IvhkKYPo=;
        b=eioXqdwQ4bOdzBiPdBw6K3XGByI2fdrqld8zsWAHaZnktlHPUdlgtjaG5cYfBEtWQS
         CU89nrsXo+RRDWteoUxu8udvYmbRSyTXBSidO7t2V/qy19gqnxY0m7WFBhJ9jG/Ec5aU
         ig9W43b17eb3t4AsJklQIEM3/3mh1J+cSEdBr6GvCKBR+wll450ZBxH292gVyWnmetf5
         PolUyqvVxn0AM8Ge4oxr+ufgQp3WQTJBevDef4umqzeGdw5rkIUNmsASwDmThxG4XEOz
         sAJlHbwpe8Um9FvQlJzWujI+vAw8bHNgTnoTAF5ZXjY7LKxM24bxtv05dQ+ynyTF5+Gc
         bkLQ==
X-Gm-Message-State: AOAM533FfO16pH/KJMuZzSem2YXCJFOQQLzL4D7+XzQwO79XHDj6RylX
        7fz3XMfcaXRMWtG5geee/Ua3ZWbrwrl3jTzo
X-Google-Smtp-Source: ABdhPJxLBUkH8+7hCQLbyq+s+xNgzWzAutZtrmlVc3fLdipGPi/vMFyIf4ywSLEqcxvWTaUE0v2RoA==
X-Received: by 2002:a17:906:4310:: with SMTP id j16mr15414023ejm.182.1629108703611;
        Mon, 16 Aug 2021 03:11:43 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a60sm4673779edf.59.2021.08.16.03.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 03:11:43 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/3] net: bridge: mcast: fixes for mcast querier state
Date:   Mon, 16 Aug 2021 13:11:31 +0300
Message-Id: <20210816101134.577413-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
These three fix querier state dumping. The first patch can be considered
a minor behaviour improvement, it avoids dumping querier state when mcast
snooping is disabled. The second patch was a report of sizeof(0) used
for nested netlink attribute size which should be just 0, and the third
patch accounts for IPv6 querier state size when allocating skb for
notifications.

Thanks,
 Nik

Nikolay Aleksandrov (3):
  net: bridge: mcast: don't dump querier state if snooping is disabled
  net: bridge: mcast: drop sizeof for nest attribute's zero size
  net: bridge: mcast: account for ipv6 size when dumping querier state

 net/bridge/br_multicast.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.31.1

