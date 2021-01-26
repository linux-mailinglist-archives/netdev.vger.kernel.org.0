Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0D83048B0
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732184AbhAZFlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbhAZELX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 23:11:23 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A48C0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:10:42 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y205so9760241pfc.5
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 20:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aKVkEDBagljuX3YCkGFMWzS+lPPdBp7IpdpqtPio3EU=;
        b=f0NIGHVBopI0yPqJVr/PiUV/mhKQiqe9Zkr1Ss+4XSbNk5DhohIa6DolWNsmB2DccW
         6ljXAdWx0+uM7qFc/tpWeUvJx+IQhUU4WZEQOMpM5PFfCvCcawF+21VSP+7hbhtvSVoH
         vXg5fWv1FdiYiyrSfvy1wLtuqn39uPftTEtbPbhb8DK036ka0oTsJtcNby9QPy0ipT10
         mKeC80M6GDWPx+xX1naF5S0AGlEWgRgwo0H8LUOecxg/mTWmpjnXwIV9vMhhUoX9Gd6M
         OTZ5mg69q2xam+YVhbRRsQo/rEnPUalloNWn1vm2jfaGhM4rGSvf74PG2Iq4le7LHsTb
         USiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aKVkEDBagljuX3YCkGFMWzS+lPPdBp7IpdpqtPio3EU=;
        b=m9s0oa9SWe/mnlt9xg7BSN7AgrTc3Bby0LlpbwBmPT9efZXv32DgACkyqGdVIG97lp
         zHOfifxv4UnPneBRZrxLLRPkm6dJHrmbKSFi0BYK305fWyid4/Lf0/IKFgHge71LSgxL
         f1CbPWEa41Jfnq91bQP2U3YoYjbmYtKzeBUTEzcnqYweryte9xTWza3nfoGAgsjrlmEE
         5U6vAQ3hVaZfdqVJ1rxmXpq2qi0NCy0jFXbXiB5H6LKNZEnRfvjS1hbQ1UqoV5/8tZK8
         5InQS9uH2bIyPMMnrYOF/w6bubX9si9+IiguyCPJjrPH9Z+svkQIXDjfObv2K0AO7gK8
         EVew==
X-Gm-Message-State: AOAM530XhBSsNbnrldBA64tu2GgxXbWeO7rGTvSfWLYP9eImXny26PpO
        gjbJf9IOPcBK/Yd3w2kRrgiSwiBigNjVBMix
X-Google-Smtp-Source: ABdhPJwWGZ3FBurbJc4PpDAopOt9mDr/vxh0Tv2YAD6NCmW23w9MN7k+ts53mGxcIDP/evmVyAO0MA==
X-Received: by 2002:a63:5122:: with SMTP id f34mr599446pgb.107.1611634242308;
        Mon, 25 Jan 2021 20:10:42 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bk18sm783784pjb.41.2021.01.25.20.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 20:10:41 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, Jarod Wilson <jarod@redhat.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next] bridge: Propagate NETDEV_NOTIFY_PEERS notifier
Date:   Tue, 26 Jan 2021 12:09:49 +0800
Message-Id: <20210126040949.3130937-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After adding bridge as upper layer of bond/team, we usually clean up the
IP address on bond/team and set it on bridge. When there is a failover,
bond/team will not send gratuitous ARP since it has no IP address.
Then the down layer(e.g. VM tap dev) of bridge will not able to receive
this notification.

Make bridge to be able to handle NETDEV_NOTIFY_PEERS notifier.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/bridge/br.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index ef743f94254d..b6a0921bb498 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -125,6 +125,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 		/* Forbid underlying device to change its type. */
 		return NOTIFY_BAD;
 
+	case NETDEV_NOTIFY_PEERS:
 	case NETDEV_RESEND_IGMP:
 		/* Propagate to master device */
 		call_netdevice_notifiers(event, br->dev);
-- 
2.26.2

