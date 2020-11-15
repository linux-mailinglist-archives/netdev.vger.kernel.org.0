Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDAC2B347E
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 11:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgKOKzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 05:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgKOKza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 05:55:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68905C0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 02:55:30 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id y17so14580658ejh.11
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 02:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Xh/WFs/ZS28tqFPGLvfBnu4Vz5uV5e6ocipJd/1rGds=;
        b=JZKsmXb/lQY2xhW55CRs2U53rPLWvliCFsnKw4mmkThsyFebww7nvBC30Y4KrTSzVM
         6NjSnoXVIoyh/3d13J2fzZbUjVIqa/eFax6UEJrkIS8rZRPdcknBqv1lcm9a7I3+kG7G
         NW7BuepyUagsWrTFYFrq29G4WmeuaVy+PPSyoml2mkNAock5XOmmRRjbbZrjsUxQcXGi
         unR3EoVhBXLG9wrRqsRRUPc7FrzLKvSnWTr2MnFcbjKskRipQXIzd7tRP1mIvdQwpoT5
         UipeJvD1UV3KxuD1YHAyqc1tdkL7DaXUK4XCzFgJCFlc3PBXW103jjU8ZTbWIASEynQO
         qDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Xh/WFs/ZS28tqFPGLvfBnu4Vz5uV5e6ocipJd/1rGds=;
        b=DiXSnXN/14Asg2zyVrYKCR6RlzSHFYjYNWEEx9geogop3rOR8gMfNAaARnm99XT2PB
         jAodJPD4A3MZwSVtERHcRNXmwJL/bz02QnWYUry8mSBFFbB5AQSv0uicbXmk9uF6S+dP
         pI7h7gPXYUg3takaMWltDsx+OLSSFxn2YRGp3FnV8u+egqdaXG+lLxWBkNliKW2TM0LR
         uUYwrNwSuNrpHC2HROgTqkCJMaDT1Zk4r05TczNlxkwo16vyJXvJTTzC95kI8BGPeMIk
         16G5uP9PdZTZ9YKG5/qzTCYACJnmTsfL8JdssxJvfYA0i2nV4WfEDv8FxKDqRB/zDg2k
         0WTg==
X-Gm-Message-State: AOAM531bihWfDjo1vqwhzh+q60qCPMABk0ZnLgkaiRtxHDiOs1r7RhH+
        7wSBP4FCRqfYPozlln+DYCG07L9gbCtrjQ==
X-Google-Smtp-Source: ABdhPJwQOlFNWiMzyVemeigxidORJzZ4hGByexLAJk7Q7c2fxRTj3zt82Qz0S8JyAC440gg9RtqFqg==
X-Received: by 2002:a17:906:aacb:: with SMTP id kt11mr10840899ejb.12.1605437728927;
        Sun, 15 Nov 2020 02:55:28 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id x1sm9202238edl.82.2020.11.15.02.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:55:28 -0800 (PST)
Date:   Sun, 15 Nov 2020 11:55:27 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201115105527.GA11569@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an IPv6 routes encapsulation attribute
to the result of netlink RTM_GETROUTE requests
(e.g. ip route get 2001:db8::).

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv6/route.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 82cbb46a2a4f..4d45696a70eb 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5489,6 +5489,11 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	rtm->rtm_scope = RT_SCOPE_UNIVERSE;
 	rtm->rtm_protocol = rt->fib6_protocol;
 
+	if (dst && dst->lwtstate &&
+	    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0) {
+		goto nla_put_failure;
+	}
+
 	if (rt6_flags & RTF_CACHE)
 		rtm->rtm_flags |= RTM_F_CLONED;
 
-- 
2.25.1

