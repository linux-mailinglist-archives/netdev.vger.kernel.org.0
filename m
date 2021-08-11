Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFB3E8998
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 07:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbhHKFKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 01:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbhHKFKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 01:10:49 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08597C061765
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 22:10:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so7801013pjr.1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fiESui1KRzGljhyjmIcy4FRTOq44ThwYFlFuxizW2lc=;
        b=BF/EmllYctMgkfqhWD8G3Y89Qb3wMRII5alVeEHzN/NzKsOiao6s65Oo4pEcBzuuvr
         Ax+NMROkHj+XU6OAwhaww4rRbm+eFS0T1ZgrficUT8JomQgIGkNdW5I3mgiD471FvrAu
         UO3r8Q/EDfstBmd2nNLIHCFtUx5HHxz2ELrzPORWB1bMvDDB19n2AU2yITAIIhGicaiq
         RGjv36cPLrVd1ACJ9gslQAnn7oLXP+JJhRgkLni92k8zRfKpM0+2A//Duo+ncmmQgfJW
         gCRXG5A5znZoov9CsjqVvsU+pZ8wd2bjwquhI3/ZBAU/6XDNfM/0nlv/DSDswb6VDBcN
         Txgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fiESui1KRzGljhyjmIcy4FRTOq44ThwYFlFuxizW2lc=;
        b=Tr9/ZOLN9UUj8pmGC7ZcpR4uguEvdpdh5hf7svdEUvpDLN0/MDh0mHq07ChA22xQ58
         wkdI2CpcqYyMEysTem3Z4MetyaG/dEpH/FQEpQ1ML0VDKBuzQwJXrTFCXVUBkIPAUeXx
         cj7sLdWUoaqYNH1dVXNlPuBDTqYV8G1d9UX7+bhByHMQX+gf99l/Ooq06HnlKwDdaHpJ
         gqMfKOPNzRc52P975toyBWkCERhp7Qcy5FEQEjxY9+QMv6HQBuydt4/Won2vG48d0GrN
         ZKDYJcibuN5ri13dsUVsEM8MPh+/AXp1AAyKFQbLZIPQFk0AbQvDdNxvXhJSp119dP7f
         iZCQ==
X-Gm-Message-State: AOAM531tnWOAeQfL3lbKLad8XGI/T4xhcPH98xQ/w/VdZP5BTzj8yPCv
        9dGi3ASFn4TsEkozTBRGXOQ=
X-Google-Smtp-Source: ABdhPJw1GLogG7nsUYu+qOomZaL/u0mYiSJ7K5Sb3oKq2TxDPMlJ2d/gmUBseNb+1rucuw/5gifjKg==
X-Received: by 2002:a17:90b:3604:: with SMTP id ml4mr8693218pjb.82.1628658626678;
        Tue, 10 Aug 2021 22:10:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id d20sm6161980pfu.36.2021.08.10.22.10.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Aug 2021 22:10:26 -0700 (PDT)
From:   tcs.kernel@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
Date:   Wed, 11 Aug 2021 13:10:09 +0800
Message-Id: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

syzbot report an array-index-out-of-bounds in taprio_change
index 16 is out of range for type '__u16 [16]'
that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
the return value of netdev_set_num_tc.

Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
---
 net/sched/sch_taprio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9c79374..1ab2fc9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	taprio_set_picos_per_byte(dev, q);
 
 	if (mqprio) {
-		netdev_set_num_tc(dev, mqprio->num_tc);
+		err = netdev_set_num_tc(dev, mqprio->num_tc);
+		if (err)
+			goto free_sched;
 		for (i = 0; i < mqprio->num_tc; i++)
 			netdev_set_tc_queue(dev, i,
 					    mqprio->count[i],
-- 
1.8.3.1

