Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473A9233746
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 19:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbgG3REP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 13:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3REO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 13:04:14 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE916C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:04:14 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id lx9so5100975pjb.2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 10:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=io9G5AAiJq7DKy/FqKBvvJPSBqkMqBW55oTJpyX0Bis=;
        b=YK2oSz3tW8/PhRqdpYqtpe4WSYk4a5zNDcoW/hxM4tMaTrjDQeB70NCZrUcItvjOpi
         LVL6H0fk6XWvi9ePVa/1MpWhanLn4MbocKi+20yPfQWzh7I6zGq56kC5RNLM9A6sb/oF
         2reCxRs3IM0WdH4nzre92UbA1GBcrzeERT6+40yCMYWU4mPBOCuqx+y498kYJ5CunM7R
         h8wFzLcDKGPcHvCTPGfqNk/5DNAQAZhKLFbVCjL1mUzDC/URQNtlmC13yKw4ScTTTk2O
         EXoRPwUBGnCzG4EFGqvXHPkMfEvIMjCBnL1h1Jp2nzWSPJoskkq9xI23h9cPpmz3eGnb
         hKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=io9G5AAiJq7DKy/FqKBvvJPSBqkMqBW55oTJpyX0Bis=;
        b=YEmvOj2sdrZv4VbubBktpzraz1BpO7zVTwl1h77fr9oXm2t6us7CSvqE9CImwkGZnY
         2hnfgC4D8U9W2vVDOGoe4GPkyuIs4NSrWn/6valIoCUfUxDUvT7+bAxUNLG+MH9d9yzq
         DKTl9EzgdOgWc9JGSLF6OokC53BDNkcwHY1P0fUb08F4/03QThgZP7kuuApxszxmFqSc
         aBVCFG412U/n3K7wQvp/Y/3hijjRaEV+6fWGTs1hVciH0AbjTfzcKlZ8FKuHCJM5qHcl
         qIAynJ4kJXIK62EcWSdk4a6R8AtvmqL9uRbXN5wGVdjbhEyW8uWwt8RZJkvTmBLsVo7/
         rF9g==
X-Gm-Message-State: AOAM53055QPFjbmIO6wFa9NQTHH1tRoB+wvxetNVUqkbYLIQmbftkyXM
        yahFwwAOtGPJAXEOnwfF9Mv4rDGb
X-Google-Smtp-Source: ABdhPJxh1Ym9FtwbGCzIBzEdTMR25lT25rz0MGLG7o9VL4XYc1dMTu/rH3gQdwK22RM90s/mjycVlw==
X-Received: by 2002:aa7:9910:: with SMTP id z16mr4296225pff.250.1596128653944;
        Thu, 30 Jul 2020 10:04:13 -0700 (PDT)
Received: from martin-VirtualBox.apac.nsn-net.net ([157.44.211.74])
        by smtp.gmail.com with ESMTPSA id 64sm7620680pgb.63.2020.07.30.10.04.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jul 2020 10:04:13 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jbenc@redhat.com, gnault@redhat.com
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net] bareudp: Disallow udp port 0.
Date:   Thu, 30 Jul 2020 22:33:51 +0530
Message-Id: <1596128631-3404-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

Kernel does not support udp destination port 0 on wire. Hence
bareudp device with udp destination port 0 must be disallowed.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 drivers/net/bareudp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 88e7900853db..08b195d32cbe 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -578,8 +578,13 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
 		return -EINVAL;
 	}
 
-	if (data[IFLA_BAREUDP_PORT])
+	if (data[IFLA_BAREUDP_PORT]) {
 		conf->port =  nla_get_u16(data[IFLA_BAREUDP_PORT]);
+		if (!conf->port) {
+			NL_SET_ERR_MSG(extack, "udp port 0 not supported");
+			return -EINVAL;
+		}
+	}
 
 	if (data[IFLA_BAREUDP_ETHERTYPE])
 		conf->ethertype =  nla_get_u16(data[IFLA_BAREUDP_ETHERTYPE]);
-- 
2.18.4

