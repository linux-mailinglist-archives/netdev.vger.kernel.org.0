Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9663B1A0E44
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgDGNXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 09:23:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36065 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgDGNXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 09:23:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id n10so813738pff.3
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 06:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TjWM2YzH1USVIxCoPL8ZalCmcQDCAISbYZs6BcOuYLg=;
        b=dPAdSe+pVRwEsFLfBGuEUSoatGcYsbEKQTtF3K3yjYv2R1N0rbpc+inVCf35DYZ8X2
         FaKGRexP6wKSSu1EaIBYWPoYmcggItYUBd9hNuAcU3mvBy/bUhMI5IANJFhKjO8FLmUh
         x8///Nx7b2y1X78yXOvJc258CB7oq7s2HPPOKg+P6YsiMcr5ZYBV8CbjXIPh3tN5bsHD
         5lc/07QK55iNL2rw6mY3VGSspq4qz67Oq3S82Qy8ecSz5/2uN+GRRLvWNSjsUx928aho
         2NJtRA2fQ28WN5FCXvIutcTLFjlRQNgUrI1laXru5W9Ux8WLp1Cxs/cE0MA6VuNSXx7Y
         Afkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TjWM2YzH1USVIxCoPL8ZalCmcQDCAISbYZs6BcOuYLg=;
        b=RN5+TJ3GeE3MqNWL3LZ41kX5v9z1CMZyEgt68Tlym6laPjhqdnwm4gXRBcAEIKnq1o
         s9F8KoRFZeDRwqbzj0tQvcGGaCZkw3XMY4Z0DyoQCBBF/6v7kilOgf2cUtIMmIsI38uK
         5DrSiiaVf/+FWDDheIVy6yf0UUwc6vXeF7zbex8M7QUMcOneDDMD7V8PA+pUlcs7Hyxv
         jl06bERFT52jbUWTsxQwOsZfi31BR8q5JF+3GhPRctRqboqLqZ9XUB8WbAK4VEt63Tce
         F2Yldk6DsYNUfIDobDbcDZfK/EcqvCo+9n64tadolrMYdOQV3FrW/aAHlbmiNJ/Dyx/D
         9Ccg==
X-Gm-Message-State: AGi0PuYHlwy5X4kUJoxyJf3GcTpk9ECgWQ8UCDnI7My0wcv7UEQfVYtz
        oq8C+Sk84oQqPdRK+pFW+PM=
X-Google-Smtp-Source: APiQypKJdtv8ncQRXFTE5q22PqSI6wOSsjstBz+DR+xQG1RaB6ox36i1ddnehAagkMyfZkb6TvuCaw==
X-Received: by 2002:a63:6f84:: with SMTP id k126mr2042976pgc.391.1586265808681;
        Tue, 07 Apr 2020 06:23:28 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id i16sm13992938pfq.165.2020.04.07.06.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 06:23:27 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] hsr: check protocol version in hsr_newlink()
Date:   Tue,  7 Apr 2020 13:23:21 +0000
Message-Id: <20200407132321.3957-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current hsr code, only 0 and 1 protocol versions are valid.
But current hsr code doesn't check the version, which is received by
userspace.

Test commands:
    ip link add dummy0 type dummy
    ip link add dummy1 type dummy
    ip link add hsr0 type hsr slave1 dummy0 slave2 dummy1 version 4

In the test commands, version 4 is invalid.
So, the command should be failed.

After this patch, following error will occur.
"Error: hsr: Only versions 0..1 are supported."

Fixes: ee1c27977284 ("net/hsr: Added support for HSR v1")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_netlink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 5465a395da04..1decb25f6764 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -69,10 +69,16 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	else
 		multicast_spec = nla_get_u8(data[IFLA_HSR_MULTICAST_SPEC]);
 
-	if (!data[IFLA_HSR_VERSION])
+	if (!data[IFLA_HSR_VERSION]) {
 		hsr_version = 0;
-	else
+	} else {
 		hsr_version = nla_get_u8(data[IFLA_HSR_VERSION]);
+		if (hsr_version > 1) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Only versions 0..1 are supported");
+			return -EINVAL;
+		}
+	}
 
 	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version, extack);
 }
-- 
2.17.1

