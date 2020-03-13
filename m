Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7823D183EF3
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 03:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCMCGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 22:06:36 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40898 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgCMCGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 22:06:36 -0400
Received: by mail-pj1-f68.google.com with SMTP id bo3so2040128pjb.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 19:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Y/RiGmKu2bGOe1k4hPC/XK5RVGb6F9gd5djR4zEb8Ks=;
        b=mDUEFUxPwHrIRNcNDDR5OVgOZfPQOgGwu+fzpzzKyKo6FRMD4BTshHH2rYtRryHwGR
         gNxYIF9MXtLU+ptZPSwVU+u+ys1WEQ4WDZax+bdiUZT16MkhtLAWRjQmCcUeaSZfHrD/
         R3knIQJiGcAJEyiAJFp0mHVtuU0WohzAuBw9QvyyuMy3SU+zz/TrncbqSjvG2CIbTHm+
         cDKRNfKmBbBMB6vcCQdR3BEHRTzp4pFzzpfiR/Gn5srkMoL1aSE8rqGobncle1mmyAUG
         F2/enl1bBzO8COkPBhVUo0GGOcAyS0M6BF7khQMwe8UHv+sQ1s6wVigV9MfjgZtaLafF
         rUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Y/RiGmKu2bGOe1k4hPC/XK5RVGb6F9gd5djR4zEb8Ks=;
        b=ip5UVg9+Y3g9YPUGKnWI7qrql8Y+uv3otbtt+tMnS+uaaGh282FB7VJEfrZwC5pK5k
         zYu8QP9NoYYGUOu0gS1S8x+ODoZZdDaQgw9gGG8S/aHL6KEvoJPujVswPV8NsIfw3OgY
         LPNm454umgSJ1SomCNZZMVjs4N2rlH0LGNo5PEk1/FF7z8XiBhZ/OEWyfcZVyZkuGSOl
         kFLAmonXXy4oqaLN02pPd+JqDC3iUP4oDMLjSBvjCMGHjF/3MNianR5Qm7lczziFmvo4
         6Rqes/OnSQ+QY+ZWhLCYG4GYS2vDsBSdIAEVpDrv3UFPqrhkZozN+bjXvNVcpvRd1Lvo
         rfag==
X-Gm-Message-State: ANhLgQ1kV/89tyxuFPhj+u5E6MAxWA01/jKIFsNPjaFc5G2AXCrnFOtM
        yJZBEIJCmKLC5XEl8qEwMqc=
X-Google-Smtp-Source: ADFU+vuHy637+eHc+Ub8e4Hg/gxSp28bqDnQ3zK6Eyv/2jzGB9RPd1QvyMlOFmfK5gA8MXyHTC3Sjg==
X-Received: by 2002:a17:902:9308:: with SMTP id bc8mr11300211plb.268.1584065195378;
        Thu, 12 Mar 2020 19:06:35 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id s61sm10153249pjd.33.2020.03.12.19.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 19:06:34 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 3/3] hsr: set .netnsok flag
Date:   Fri, 13 Mar 2020 02:06:26 +0000
Message-Id: <20200313020626.31683-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr module has been supporting the list and status command.
(HSR_C_GET_NODE_LIST and HSR_C_GET_NODE_STATUS)
These commands send node information to the user-space via generic netlink.
But, in the non-init_net namespace, these commands are not allowed
because .netnsok flag is false.
So, there is no way to get node information in the non-init_net namespace.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 6a6e092153ef..1d3141aa5766 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -473,6 +473,7 @@ static struct genl_family hsr_genl_family __ro_after_init = {
 	.version = 1,
 	.maxattr = HSR_A_MAX,
 	.policy = hsr_genl_policy,
+	.netnsok = true,
 	.module = THIS_MODULE,
 	.ops = hsr_ops,
 	.n_ops = ARRAY_SIZE(hsr_ops),
-- 
2.17.1

