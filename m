Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13D739F83F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbhFHOA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 10:00:26 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:34568 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233118AbhFHOAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 10:00:20 -0400
Received: by mail-wr1-f45.google.com with SMTP id q5so21720034wrm.1
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 06:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WxNx57mPX5CoyU1yFaPVyt2pdIp6epOYJaS+sjEZn20=;
        b=mr/g80xtX7GL1/5VN9aSPuw0Y4MpWN+kOd02LksE+PxtSqd87doKeNg++AP+q78bH4
         grS+epvq34fHMxJzS8x0lpcTcfqJ/OzTK0CtTZ9rIYMiKqwZRLjy/bKDxfTRa8CIpvTk
         fgyln0OqSEdczz4OuCer3ztXi8DRJ57H2Iqe2d/sF7YIcEuEifDQhbxDOj3oPZS03HdF
         Qj5HP6boKJexJxNi5Oz7THvtwXigrU5doSs8fJgGT3rNjwnsYgDmJWIVR7liJJrh2Nw6
         EJThJ5bepNzyGWZ20fXSHzfo58A68bFG5RbylL7dE5RJ43ijIHSKGVZHP8N0j3NH/XqH
         ehpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WxNx57mPX5CoyU1yFaPVyt2pdIp6epOYJaS+sjEZn20=;
        b=msmotVQiOljiEqfcaAmn2XEEi/2SQFhJvn7ec6xwHFZkEfET1YMpJouv3Q3oX0Xhry
         VwWdkgU8QPkGfEf3XSYwjQbMwA8W1X+52JCYg4UTheNCktlMbBMB88QLDMlUlllF2Ol1
         Ej6eK7uApubK0QyxM74bxtXNmaLt04UhE7AIRSvyPPphNg4aBuXb6oBOaU5yospDZ6mS
         kH9o7j/f2q/OBjPEnadNwYnLIoQcWWajGmeaV5OedtgcAYa0geP0lSFIseqa77w3rNi6
         DEwlSYra1Cw51DjvYS9lV2cnUlMyDfic25cLRiXiD5RARzqE54k+YJh1+Ov3yGgZ1rDF
         JeOg==
X-Gm-Message-State: AOAM531mIKlZnMpe4KXZqGWVdGckC0WovrwLcQ5t47AlM+Rd6Ex8i43m
        NVpZ2BF4buN2dgSt3A+sSADNHmrATTN/NgmF
X-Google-Smtp-Source: ABdhPJxB6Mu9lI05/NJdsijwzEOD3VzzrPUsfa2WgIuPhI8ZuFfGUF5r4mt2McyPuKZ+ElQkeNEwHw==
X-Received: by 2002:adf:cd82:: with SMTP id q2mr16298980wrj.258.1623160646983;
        Tue, 08 Jun 2021 06:57:26 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:82c:5f0:85ed:406e:1bc4:a268])
        by smtp.gmail.com with ESMTPSA id f14sm1956108wmq.10.2021.06.08.06.57.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jun 2021 06:57:26 -0700 (PDT)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, johannes.berg@intel.com, leon@kernel.org,
        m.chetan.kumar@intel.com, Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: [PATCH net-next 3/4] rtnetlink: fill IFLA_PARENT_DEV_NAME on link dump
Date:   Tue,  8 Jun 2021 16:07:06 +0200
Message-Id: <1623161227-29930-3-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
References: <1623161227-29930-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Return a parent device using the FLA_PARENT_DEV_NAME attribute during
links dump. This should help a user figure out which links belong to a
particular HW device. E.g. what data channels exists on a specific WWAN
modem.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 net/core/rtnetlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 56ac16a..120887c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1819,6 +1819,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_prop_list(skb, dev))
 		goto nla_put_failure;
 
+	if (dev->dev.parent &&
+	    nla_put_string(skb, IFLA_PARENT_DEV_NAME,
+			   dev_name(dev->dev.parent)))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.7.4

