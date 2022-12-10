Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75CE0648CF3
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbiLJDrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiLJDrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:47:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279CE2AC3
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 19:47:39 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id k88-20020a17090a4ce100b00219d0b857bcso6944325pjh.1
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 19:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2spuyOtJTo+ECwzzNrX5q/0j7RC1IxXdm/DeJvlIBfY=;
        b=CxkoNXreiRpBZRLSU3OBIj62Th1BumSgGoy+FeFEO9lYwLxV2L2/2P9p2xvBg76itt
         iDRtXvw0EigWtJNQS7+kEOHDzhxMA3AybcdhDtdgWcoavsIlP/LbTPs7QWhQR0rJ+Maa
         mLlWSrkbyvpJJ8opRJfUrOvGn3d9CXXBfgtr2z0oufphlFU6Hbh9ESUgyoeUym52hjkg
         o/3KzqnYFK8xDdMfVnm3GkbKOCa5Orv70PhY3aDsNSC3x+JnN7vcdy774nLvKPcK+9AJ
         DcRWKAWJQCNoYBcsyAyw4KU8Vf2NIaEKtggyD+/0YyErZFuhSwGfMCBhTVW7P/8bG1xA
         8k7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2spuyOtJTo+ECwzzNrX5q/0j7RC1IxXdm/DeJvlIBfY=;
        b=exHNdm6EnWQ+/9FxznYKK1241CK1pIfx+7TCDGGPk7LaI80ECCjhBlLexUl8VZv3Yi
         6CULDAry8V+eBh00yt0ZXex8PoWJqFluqpQv2BbXoyvh5zdhRa0vCHWYrzyx/vLpFYiu
         g5c7VdeCPPmY4iuhyjlSQQHTZ0ywTW9kKmia0Xeu7HPFV4ev2eVN3qzS9BBNlPFwL6kR
         uFNKyxR71BrOu28DaMZC8RnesFCFpCG/+Jx4/9Mj3Q2muvhIAfFdkoATF7f9fDNdR0/A
         NdsIHIEXm1kLdcS9BtJz64AvSWIR7rtQAm9zt+tn/pD8VYzzVEPKnFlxF+moSH8/FXtX
         /6hw==
X-Gm-Message-State: ANoB5pnWYSp+oUvzBLotI/K3vSUKRn5f0ZHzs8WggOeuwaCOyk1kGCoC
        TNGuqbudvn/m4kMUl/uTpAJV/QmnkHJtnGTR3pk=
X-Google-Smtp-Source: AA0mqf5vuQUYz26iP1kbJMXY/bsl81h+I6zIdqPAibXMf4sHy8AOBsh55YJLQ1SzC/Ua2u1UONH2Cg==
X-Received: by 2002:a17:90a:2b82:b0:218:7148:580d with SMTP id u2-20020a17090a2b8200b002187148580dmr8514115pjd.7.1670644058452;
        Fri, 09 Dec 2022 19:47:38 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f34-20020a17090a702500b0021806f631ccsm1722442pjk.30.2022.12.09.19.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 19:47:38 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] tc: print errors on stderr
Date:   Fri,  9 Dec 2022 19:47:36 -0800
Message-Id: <20221210034736.90666-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't mix output and errors.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/tc_class.c   | 2 +-
 tc/tc_monitor.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/tc_class.c b/tc/tc_class.c
index b3e7c92491e0..1297d152fd5f 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -365,7 +365,7 @@ int print_class(struct nlmsghdr *n, void *arg)
 		if (q && q->print_copt)
 			q->print_copt(q, fp, tb[TCA_OPTIONS]);
 		else
-			fprintf(fp, "[cannot parse class parameters]");
+			fprintf(stderr, "[cannot parse class parameters]");
 	}
 	fprintf(fp, "\n");
 	if (show_stats) {
diff --git a/tc/tc_monitor.c b/tc/tc_monitor.c
index c279a4a1a898..64f31491607e 100644
--- a/tc/tc_monitor.c
+++ b/tc/tc_monitor.c
@@ -67,7 +67,7 @@ static int accept_tcmsg(struct rtnl_ctrl_data *ctrl,
 	}
 	if (n->nlmsg_type != NLMSG_ERROR && n->nlmsg_type != NLMSG_NOOP &&
 	    n->nlmsg_type != NLMSG_DONE) {
-		fprintf(fp, "Unknown message: length %08d type %08x flags %08x\n",
+		fprintf(stderr, "Unknown message: length %08d type %08x flags %08x\n",
 			n->nlmsg_len, n->nlmsg_type, n->nlmsg_flags);
 	}
 	return 0;
-- 
2.35.1

