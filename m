Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1782F84A8
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 19:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733251AbhAOSnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 13:43:49 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:41116 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727863AbhAOSnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 13:43:49 -0500
Received: by mail-wr1-f50.google.com with SMTP id a12so10258589wrv.8;
        Fri, 15 Jan 2021 10:43:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+794t8aJWFKiUG7Y4A7+DFW3GISGeN1bFWGcWCBpz7o=;
        b=KVgDaqLbgC3yDQUs5Wo6AdZ0JGi6qteRSjq79TXcoWC1/oRFzqT3tYnqLpsdXMrKju
         seGkUg9eboqkPW2ZlaTErtXB/hg5+B2uomsldfm4l9YDA2bWXhoa0YiWKW0uZ5WSbgdr
         AWmIn7Sf9kvdhmZtoV+8IyOOq//p1/Ms03mTQN0qGKc1KBfVFETMTO68PwyqvnmjNFq/
         v41wHfP0/AEYfMuERRW96BSFwAQQJEf3VFP5t7Ddo5mlpyFl1AaEIpqzg47D9Zga39A3
         CAcEDS3LeVGoQCa26P6fJRsWnpGSPw8SFwizSS8RW4BOaFYfVBfuoFNb9aRpC3sFwBoo
         0yGg==
X-Gm-Message-State: AOAM531iVMi2mWxeviPZayDTfwKa1u6eoZhiqlApVH4/BFW9LDborXXS
        PxKGCOy43NKP0d7e87tjzGx7dW1qkuf6hQ==
X-Google-Smtp-Source: ABdhPJw/ynUlSRPRgKj8IK2ryzYiUkgGdFBRVf0GuTg+PNpFi47rqm6AmydaAJ3ac6bWAw7QGFY8+Q==
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr14814821wrv.51.1610736187200;
        Fri, 15 Jan 2021 10:43:07 -0800 (PST)
Received: from msft-t490s.fritz.box (host-80-116-27-12.pool80116.interbusiness.it. [80.116.27.12])
        by smtp.gmail.com with ESMTPSA id z6sm12881529wmi.15.2021.01.15.10.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 10:43:06 -0800 (PST)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] ipv6: create multicast route with RTPROT_KERNEL
Date:   Fri, 15 Jan 2021 19:42:08 +0100
Message-Id: <20210115184209.78611-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115184209.78611-1-mcroce@linux.microsoft.com>
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

The ff00::/8 multicast route is created without specifying the fc_protocol
field, so the default RTPROT_BOOT value is used:

  $ ip -6 -d route
  unicast ::1 dev lo proto kernel scope global metric 256 pref medium
  unicast fe80::/64 dev eth0 proto kernel scope global metric 256 pref medium
  unicast ff00::/8 dev eth0 proto boot scope global metric 256 pref medium

As the documentation says, this value identifies routes installed during
boot, but the route is created when interface is set up.
Change the value to RTPROT_KERNEL which is a better value.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 net/ipv6/addrconf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index eff2cacd5209..19bf6822911c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2469,6 +2469,7 @@ static void addrconf_add_mroute(struct net_device *dev)
 		.fc_flags = RTF_UP,
 		.fc_type = RTN_UNICAST,
 		.fc_nlinfo.nl_net = dev_net(dev),
+		.fc_protocol = RTPROT_KERNEL,
 	};
 
 	ipv6_addr_set(&cfg.fc_dst, htonl(0xFF000000), 0, 0, 0);
-- 
2.29.2

