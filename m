Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9202B1798
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgKMIzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgKMIzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 03:55:20 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D05C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 00:55:20 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id p93so9777097edd.7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 00:55:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=JkR1TlTURsuqhVlmf7oidCb+G84OLp7PiXn/8hbcbRE=;
        b=tLgSYgFUfQGHmPespyBj0qBkeXKngL9JnBmFm1r+HT6GdZz13jjADiU2tfMIm4VEb5
         onW2rbFMDuDrr0EKSyXlrdP94A94Z0mV2Ni4oyRK/leE6+jPfi6vnRopc3GfMRKXEEc5
         XPQfWmGMNI6i5NqIZbZ1or8f+57TCur2/BHw5yj/YYB1zLtM5gqhgvs6DqesEYsD8dQP
         6EQgiJ09yW9B1RXe116qWHg5lBwQI+rff0IWGf7kGEPDMQUykrTK+KhAFkbVFPGf7Yui
         98bYyKac+mIK4/tshSl1lhUqUr1dPay1MIzBl0At/ODK8xejRMqNk/C5m5nQSdJQwGz+
         AGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=JkR1TlTURsuqhVlmf7oidCb+G84OLp7PiXn/8hbcbRE=;
        b=fXZrJMtdUFS2WZgFfvMjHrXJJIg5yoXVxLg7EDqTKoQND0NzKEvC0gvWG95enxP6TQ
         lITEnMSG/Yp9rlAyALl01MR9tSqghcG7SUYA6pKYBibbsXuTsiOWP2zyV5OvGvffbK12
         XonwYjDpW9MDsGZcWGj5LczFtfI2NyEQCW0GtU5zPMJKPgYo6v4kAnSRm4QjZkeChpeb
         f9eCNn0sFBUAJT86BARhSgWCH1QXZfrUTypXJTKk86Qnm6AZhMGK/UWgaMfq35YyRanl
         JHmcx+XofeaxyTTiyV0jRz6ivLS4fJvVxfcnhQqPzImQbYSgH3oML4WgcqisP+pOrddO
         sbxQ==
X-Gm-Message-State: AOAM531zWXjbNHwiht6EVr+DXgxPPvZUS6YHeXuI9CVlr32+YXKKuKaO
        dojmkGqmLC2QnECFIdSP0gY=
X-Google-Smtp-Source: ABdhPJzUtu94I3AxJnEE9SSVP9D5xM1fRl0P4fo8aPZR/w86rpYcPNzYZiYa6Ul8W39pDb5rPoSDpA==
X-Received: by 2002:a05:6402:3098:: with SMTP id de24mr1415192edb.155.1605257718716;
        Fri, 13 Nov 2020 00:55:18 -0800 (PST)
Received: from tws ([2a0f:6480:3:1:d65d:64ff:fed0:4a9d])
        by smtp.gmail.com with ESMTPSA id lz27sm3116831ejb.39.2020.11.13.00.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 00:55:18 -0800 (PST)
Date:   Fri, 13 Nov 2020 09:55:17 +0100
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH v2] IPv4: RTM_GETROUTE: Add RTA_ENCAP to result
Message-ID: <20201113085517.GA1307262@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an IPv4 routes encapsulation attribute
to the result of netlink RTM_GETROUTE requests
(e.g. ip route get 192.0.2.1).

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv4/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1d7076b78e63..0fbb4adee3d4 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2860,6 +2860,9 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	if (rt->dst.dev &&
 	    nla_put_u32(skb, RTA_OIF, rt->dst.dev->ifindex))
 		goto nla_put_failure;
+	if (rt->dst.lwtstate &&
+	    lwtunnel_fill_encap(skb, rt->dst.lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
+		goto nla_put_failure;
 #ifdef CONFIG_IP_ROUTE_CLASSID
 	if (rt->dst.tclassid &&
 	    nla_put_u32(skb, RTA_FLOW, rt->dst.tclassid))
-- 
2.25.1

