Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A4D37066F
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 10:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhEAIaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 04:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhEAIaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 04:30:05 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01810C06174A
        for <netdev@vger.kernel.org>; Sat,  1 May 2021 01:29:15 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id v23so557107qkj.13
        for <netdev@vger.kernel.org>; Sat, 01 May 2021 01:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5sq4TUa7cvEY0zjz33yEojgUwWF9AS0gI52Rs5eaiH8=;
        b=nmnZHtoAeQ5IFhStRZ4CMJP1xWK9QbZIV8j/UxZNtxGfMIo1g9Nh5BGYyPNXpX7d8h
         Ho9cW4ChAfDZRytGmFqSyJ3Rdsiki87aWRFbrg7Fi9XOABUtPfk1Mci6vl+TN+aXeMeV
         IBBnDngQmOyQvHYLiNK4QkbMOePJ8M3sSDbhmRIzEQXdSy04d9XAw64GSl/7N/SgFLce
         1TPnc+ek8KtBeZX+k01zBUl3akec63N8MJed9tNsd0lb0wau2h1B7ooZKn6SoYY/z8KZ
         32vFEZeubzNCVVyzvsYs3NA8k/Fm79pj6LUmGg3VDLy3dmy/zvn3+g/cUAB0htSXEmJq
         T0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5sq4TUa7cvEY0zjz33yEojgUwWF9AS0gI52Rs5eaiH8=;
        b=Lqq7UQZVmLse7Shyc94en7QHshRuofdeT5fHfwZSa1IdagKlyjnjrpmL1wR5Eg7AE9
         mpaKWWInMJ5/8DGHUPobXAnTnO1rrBhfOk1gU6pFhMtHWvs4+IRjsiek8b5Lc7Vr2C1o
         J99ib/RmERnZ1IBLapdmX2psIt6mfwvoVCyHoG1IpwK3/BRZxVzOkydwU3Gdz3slffdl
         u6alwrCdVCTJw7p03fjisInb+2KISDPbJTrIc/yeyTsmcSC02SVNdoxIt8xc/ACXPrXP
         im9kWvg68z5TzlNwy2qr0V9XGQS6ME2Xz/D883Vl9AqBP0snAXFkHYOIqZrUj/7xalTD
         LhnA==
X-Gm-Message-State: AOAM530BILcqzz80eB9iWRMF3pdmUWHVOVoTl6DgiKYB9Ln5/PZOoHAh
        9DdcNL9Ht863tDiHZzicjLjq982oMV2V0GDr
X-Google-Smtp-Source: ABdhPJyiV4DTxz+S2MMmAB2xM08/7wSFcP0tSc/rJ5LN4EQEcdGBPxGlPTCaWQ5s5NNK8NI55WWPjQ==
X-Received: by 2002:ae9:e906:: with SMTP id x6mr9659119qkf.221.1619857754772;
        Sat, 01 May 2021 01:29:14 -0700 (PDT)
Received: from jrr-vaio.onthefive.com (2603-6010-7221-eda3-0000-0000-0000-1d7d.res6.spectrum.com. [2603:6010:7221:eda3::1d7d])
        by smtp.gmail.com with ESMTPSA id 75sm898554qkl.119.2021.05.01.01.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 May 2021 01:29:14 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jonathon Reinhart <jonathon.reinhart@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] net: Only allow init netns to set default tcp cong to a restricted algo
Date:   Sat,  1 May 2021 04:28:22 -0400
Message-Id: <20210501082822.726-1-jonathon.reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_set_default_congestion_control() is netns-safe in that it writes
to &net->ipv4.tcp_congestion_control, but it also sets
ca->flags |= TCP_CONG_NON_RESTRICTED which is not namespaced.
This has the unintended side-effect of changing the global
net.ipv4.tcp_allowed_congestion_control sysctl, despite the fact that it
is read-only: 97684f0970f6 ("net: Make tcp_allowed_congestion_control
readonly in non-init netns")

Resolve this netns "leak" by only allowing the init netns to set the
default algorithm to one that is restricted. This restriction could be
removed if tcp_allowed_congestion_control were namespace-ified in the
future.

This bug was uncovered with
https://github.com/JonathonReinhart/linux-netns-sysctl-verify

Fixes: 6670e1524477 ("tcp: Namespace-ify sysctl_tcp_default_congestion_control")
Signed-off-by: Jonathon Reinhart <jonathon.reinhart@gmail.com>
---
 net/ipv4/tcp_cong.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 563d016e7478..db5831e6c136 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -230,6 +230,10 @@ int tcp_set_default_congestion_control(struct net *net, const char *name)
 		ret = -ENOENT;
 	} else if (!bpf_try_module_get(ca, ca->owner)) {
 		ret = -EBUSY;
+	} else if (!net_eq(net, &init_net) &&
+			!(ca->flags & TCP_CONG_NON_RESTRICTED)) {
+		/* Only init netns can set default to a restricted algorithm */
+		ret = -EPERM;
 	} else {
 		prev = xchg(&net->ipv4.tcp_congestion_control, ca);
 		if (prev)
-- 
2.20.1

