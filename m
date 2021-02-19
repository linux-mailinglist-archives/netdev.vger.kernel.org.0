Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0805231FDC8
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhBSRXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBSRXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 12:23:07 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726B0C061574
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 09:22:26 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n4so9592444wrx.1
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 09:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E/Ec0Bmrfn49vN1VjL7qhVatjAdetcq8BtSw/HoF3kI=;
        b=tSnn+M4o0EGunwBJmW5C70Zn0TqfqZokZXMcn0gdnuRx9QXCaN+sSlGMtAQ5EDxoRb
         PwaSOJncszcHnRpWUArnO6YtA3964Q/VMbnDJfmr16tjUPha9gf5h5tDBUC/E13bmBsA
         t0B0Eagjw1rv8rNqayTHVImn+pjd6UAsKq8wniWFn6uHJtR07DwJZG1/+0Jy/MMC2gBV
         LKS0LybVGZeahG/dIwwVV+CsyhItmbjeZdyKkNsN2VwqFxJ+jMKPLw4DgmJKZ6CiY6Xm
         ftR6JZrtYOLoYHjx7GHHGj0Zs3QNOKwJn4e5awkmbzZ/OW/GUGlIwsIHo/ZNvu6ezSlf
         I5Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E/Ec0Bmrfn49vN1VjL7qhVatjAdetcq8BtSw/HoF3kI=;
        b=uPrV8+DalVPzuj/TajVdyVitt0SXvciMlrwSxymbwv1a5e1HWavRB9vBbkad1vpYf0
         XyES47qjmJPX7BbgAERYninRznY/VqGTKR+6lqxZr9jrIaH6+z6LjepYahXTEa5fS4yJ
         wbvIFb+MjnVEwtZuTeIgnXrICUCpPhaxOSCqxUDBfi7+boekmng2FKENLDlYnSQXA+S2
         1wHzkBdcgb+VDplyvpbRTvn10XL8MVWo7NCkn1gKvfLC16JSHbvGKaB9Ciov0HxFXf5v
         +boMG5kK6WXYTctJSqjTqEkmcOG4yTKrSu72ocyq1031n9hHvD1nYcqU0dQpUKp4Hcrv
         3+8Q==
X-Gm-Message-State: AOAM532An6/eszGnhhDNW3iNa+jADkvjBE36v08sbD2uWkt9Y4DuMZq8
        Y1bKdnUoPjGXr1EKVgiaqO4=
X-Google-Smtp-Source: ABdhPJz8n209HoR5kD4YB/J010jGaIkFB7k+z7DmhxJO35Uh6muBXLm0z0r2nVlicF5Dn9ov8oOoag==
X-Received: by 2002:adf:bbca:: with SMTP id z10mr10289408wrg.168.1613755345022;
        Fri, 19 Feb 2021 09:22:25 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id z17sm17229119wrv.9.2021.02.19.09.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:22:24 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, sd@queasysnail.net,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec] xfrm: interface: fix ipv4 pmtu check to honor ip header df
Date:   Fri, 19 Feb 2021 19:21:27 +0200
Message-Id: <20210219172127.2223831-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frag needed should only be sent if the header enables DF.

This fix allows packets larger than MTU to pass the xfrm interface
and be fragmented after encapsulation, aligning behavior with
non-interface xfrm.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/xfrm_interface.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 697cdcfbb5e1..257b3c8b3995 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -304,13 +304,16 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 				mtu = IPV6_MIN_MTU;
 
 			icmpv6_ndo_send(skb, ICMPV6_PKT_TOOBIG, 0, mtu);
-		} else {
+			err = -EMSGSIZE;
+			goto tx_err_dst_release;
+		}
+
+		if (ip_hdr(skb)->frag_off & htons(IP_DF)) {
 			icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				      htonl(mtu));
+			err = -EMSGSIZE;
+			goto tx_err_dst_release;
 		}
-
-		dst_release(dst);
-		return -EMSGSIZE;
 	}
 
 	xfrmi_scrub_packet(skb, !net_eq(xi->net, dev_net(dev)));
-- 
2.25.1

