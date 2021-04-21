Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80197367597
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 01:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhDUXLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 19:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343674AbhDUXLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 19:11:40 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2FCC06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 16:11:04 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h4so33863693wrt.12
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 16:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=philpotter-co-uk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BbWVjYPqLwnuhatdoL5i7GvVhe7lvMrxaHilttyNRMU=;
        b=nNNm3pMKhsGiG7o9fMMK7bQrVPxij3MuM7drbcQMRXhPmUb7mixi8xe/eYFsP4axmi
         X1DnmbwLT0k20AWnWnuiLWKIhaL1EnpEx+kxSqsm6xO+SQ0uyNrIflatz2oLSsrmVz2A
         VcFS0gy/Y6mBy4twReQBiWG66JcNqODbxpQMbXCRyyQhKUA6huA2dmdrMBiFgb3eqjn8
         zjwTmGl/B68ZvNY/TKciP7iM3GkDHGO0trB4kZ9iIqZXbcqxVFsOv2z30uDYla7/XA9S
         WisSB//a6F6KnOOkTVXNl2UPH9ujF4A2dW2XzxcZi4F09QJEXKIaABBsOEOfhGnXWMFV
         +b6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BbWVjYPqLwnuhatdoL5i7GvVhe7lvMrxaHilttyNRMU=;
        b=QFbxUhoR1D1+vx1tIQzykYyQyERRAaigAl2c0KGWuR1+QFtgS10mQOl1N3cHmAAMnX
         s1O+0pvf4VME9SZ+mM7c1+BNUpc/rvHu4lJpZrLffgKZs71XOSkuqtpUCfqaA2QvvGah
         blCFpr0OXE5GJMNy/c7JCJwVF4ur647xfoJb6lZiVXytMYnFwGpLKNfgWN7dQgz31w1J
         FKwifMFpc1UOo21FrKYVLJMVq3Pgtwdm+lmnsi4n1ABwCXQ6dms4vmhmL3YfiZeWTQBB
         q+pyW8OywkH702RMosh/0KEQXtEAXl9ctulX66yt+QWjZP3ck4HShn7ioPK8G6Jbb794
         liDw==
X-Gm-Message-State: AOAM532uAxJqQucsfExvaUvG2d8e/9KeBoyuhs/o7ArN2Sj2zFhPcOMb
        s1WvW5KoiQSF3Ig1F7TVf1yU+A==
X-Google-Smtp-Source: ABdhPJzb8usVsAK0c/UPmOrjqriA+wCPj8E4jJDBY/EWTh2ihuumYIN5Gg3uqQr5d+dExV4d/9NyEQ==
X-Received: by 2002:adf:d1c9:: with SMTP id b9mr503203wrd.352.1619046663555;
        Wed, 21 Apr 2021 16:11:03 -0700 (PDT)
Received: from localhost.localdomain (2.0.5.1.1.6.3.8.5.c.c.3.f.b.d.3.0.0.0.0.6.1.f.d.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:df16:0:3dbf:3cc5:8361:1502])
        by smtp.gmail.com with ESMTPSA id a2sm3335236wmn.48.2021.04.21.16.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:11:03 -0700 (PDT)
From:   Phillip Potter <phil@philpotter.co.uk>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Subject: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
Date:   Thu, 22 Apr 2021 00:11:00 +0100
Message-Id: <20210421231100.7467-1-phil@philpotter.co.uk>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
rather than struct ipv6hdr. This fixes two kernel selftest failures
introduced by commit 6628ddfec758
("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
diminishing the fix provided by that commit.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 drivers/net/geneve.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 42f31c681846..a57a5e6f614f 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 		return -EINVAL;
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
-- 
2.30.2

