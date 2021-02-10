Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4903174D2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhBJX57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhBJX55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 18:57:57 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFAFC0613D6
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 15:57:17 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id i8so7239504ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 15:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2TDCUbNje3g/BBeppXwOLm/5tvwMe4/AKiWDp+LfyM=;
        b=Ha1+HlKW5Dy4uVWhirn3LK2IDUIegN3zvNGRFSO9yyAT9EfjnAxWHJCIHuC/JtgU2R
         +gCZqHatO+2j0gcpo6jLZBtxTWM3rEsaGEK7TqKKtOs2YWhDG+R7QITfQPsmXin4sgBV
         5UUj2Nt3B4Hbl4243pRxGB43LGwEqH2fXo0WNkfEmjO1ANARjOvnmEeeWKj5daFsL99F
         tFtiJHhOk4jSvk39AmBLdkpPoyjALsIVKXmvwuoKgNxyX5fgQ9FGDQdJTxwvPFm72UsK
         PVo0RA7ptKJOIyzx6xhxc86vdWU9/Q+U6Q4+1zpD972Pm1rlIy7fcKE0TA1YxYibjyR0
         Idng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z2TDCUbNje3g/BBeppXwOLm/5tvwMe4/AKiWDp+LfyM=;
        b=kG30nD67YlV3hdpgTIarwFdpokefHK7t+pyC2XhuEIhV3DU7e4Ji3NEhxLicU/BWlI
         VA9Sm+AbVXeevktYk4qBNSiG3GZGf8/1d5LbhJ5i1iFwwhxHkE1+t1iGTeX9gAYV3SbZ
         9bdG/4FNVD3naN8bxJAMLbKqveUnCledTO7op2t3piUJHaaZawTBElMlSaxv9gud/lSd
         mjN5sOTniJOazL6/O06XppjKk9Yf30ws1ZgywoVzPXDBL3uAgJXRbCPh2pWXxHiJ5d4b
         U1KSYlIxQ+Gx3zFteUy2uWyFa2nV7O/1lm3nuA27TY9O8VRMJb1iNzS2826Ta8NhY6LR
         ZUuw==
X-Gm-Message-State: AOAM531268QHJ6pF6fSQXr0Qr4CrPD9U6JwGA9RKwoYfDEXYSNZ48VYZ
        XC+PS4xjeR1YCViHblaih58=
X-Google-Smtp-Source: ABdhPJzF7D0ZqWtkllOjko0tO/uCUpm2Id427ipjI9vLkmih7mLwu6FXkskOp6uHs7pzp3ur+jxTXg==
X-Received: by 2002:a17:907:7347:: with SMTP id dq7mr5562052ejc.385.1613001436241;
        Wed, 10 Feb 2021 15:57:16 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id zg22sm2527218ejb.0.2021.02.10.15.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 15:57:15 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net-next] net: ipconfig: avoid use-after-free in ic_close_devs
Date:   Thu, 11 Feb 2021 01:57:03 +0200
Message-Id: <20210210235703.1882205-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Due to the fact that ic_dev->dev is kept open in ic_close_dev, I had
thought that ic_dev will not be freed either. But that is not the case,
but instead "everybody dies" when ipconfig cleans up, and just the
net_device behind ic_dev->dev remains allocated but not ic_dev itself.

This is a problem because in ic_close_devs, for every net device that
we're about to close, we compare it against the list of lower interfaces
of ic_dev, to figure out whether we should close it or not. But since
ic_dev itself is subject to freeing, this means that at some point in
the middle of the list of ipconfig interfaces, ic_dev will have been
freed, and we would be still attempting to iterate through its list of
lower interfaces while checking whether to bring down the remaining
ipconfig interfaces.

There are multiple ways to avoid the use-after-free: we could delay
freeing ic_dev until the very end (outside the while loop). Or an even
simpler one: we can observe that we don't need ic_dev when iterating
through its lowers, only ic_dev->dev, structure which isn't ever freed.
So, by keeping ic_dev->dev in a variable assigned prior to freeing
ic_dev, we can avoid all use-after-free issues.

Fixes: 46acf7bdbc72 ("Revert "net: ipv4: handle DSA enabled master network devices"")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/ipv4/ipconfig.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index f9ab1fb219ec..47db1bfdaaa0 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -309,6 +309,7 @@ static int __init ic_open_devs(void)
  */
 static void __init ic_close_devs(void)
 {
+	struct net_device *selected_dev = ic_dev->dev;
 	struct ic_device *d, *next;
 	struct net_device *dev;
 
@@ -322,7 +323,7 @@ static void __init ic_close_devs(void)
 		next = d->next;
 		dev = d->dev;
 
-		netdev_for_each_lower_dev(ic_dev->dev, lower_dev, iter) {
+		netdev_for_each_lower_dev(selected_dev, lower_dev, iter) {
 			if (dev == lower_dev) {
 				bring_down = false;
 				break;
-- 
2.25.1

