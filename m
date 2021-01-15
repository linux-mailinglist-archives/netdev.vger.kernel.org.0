Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A04C2F84AC
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387617AbhAOSol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:44:41 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:54903 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387533AbhAOSok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:44:40 -0500
Received: by mail-wm1-f53.google.com with SMTP id i63so8294760wma.4;
        Fri, 15 Jan 2021 10:44:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8gwIOY/GKLF64xOgYxUdqP4ghmyuqyfb19XQrB6veDY=;
        b=mwQ4Wqt/FZss1o0Dlg1Gzfyw7Aafmnsv91ttNB03bFtT+ZP3xMOkvq6eiEuOoMu3d5
         OLcfRE+9P2PcdMxkXsO+7u4cGDFAsEk3k+L4zj5ZC1BG/2v9K4xaMUPIoqBF8rC2ovhA
         IX57h1Xfapll4QpQYzx7rpGQiCFISnrVZhJdwZTBRMqg1z/MGGfl7JWOllq4oGJgcvIK
         RUxPNuJ1YsdxVi0D4Rw2+n/JlrbaHodPB+Mlqj2soPjb1+Dk5ZqE3ikwpbUmHJ678BRx
         ndAmNLWgCekZ0tnROWYIdV4Bu9VCi0xa6ThgxmpF26FQuhcJrLVW6y9MtdVRde16MuPG
         EJ3A==
X-Gm-Message-State: AOAM5302rLSvxYZT7uc1kZdjx8Sc/f3dHN39Noau4VX8o3328RfG4yak
        YqKjO12bXFGelLGwK6Kh1Xi7mu4gIaMZWg==
X-Google-Smtp-Source: ABdhPJyfHCUAUXw6dFZ4Ae1ivDcq5R7Z1cNheYMe89+NkfFJ1qjZq4gzgQRIga0sM+ZGnTf4Ccvlig==
X-Received: by 2002:a05:600c:22d9:: with SMTP id 25mr9831227wmg.158.1610736238438;
        Fri, 15 Jan 2021 10:43:58 -0800 (PST)
Received: from msft-t490s.fritz.box (host-80-116-27-12.pool80116.interbusiness.it. [80.116.27.12])
        by smtp.gmail.com with ESMTPSA id z6sm12881529wmi.15.2021.01.15.10.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:43:57 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/2] ipv6: set multicast flag on the multicast route
Date:   Fri, 15 Jan 2021 19:42:09 +0100
Message-Id: <20210115184209.78611-3-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115184209.78611-1-mcroce@linux.microsoft.com>
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The multicast route ff00::/8 is created with type RTN_UNICAST:

  $ ip -6 -d route
  unicast ::1 dev lo proto kernel scope global metric 256 pref medium
  unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
  unicast ff00::/8 dev eth0 proto kernel scope global metric 256 pref medium

Set the type to RTN_MULTICAST which is more appropriate.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 19bf6822911c..9edc5bb2d531 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2467,7 +2467,7 @@ static void addrconf_add_mroute(struct net_device *dev)
 		.fc_ifindex = dev->ifindex,
 		.fc_dst_len = 8,
 		.fc_flags = RTF_UP,
-		.fc_type = RTN_UNICAST,
+		.fc_type = RTN_MULTICAST,
 		.fc_nlinfo.nl_net = dev_net(dev),
 		.fc_protocol = RTPROT_KERNEL,
 	};
-- 
2.29.2

