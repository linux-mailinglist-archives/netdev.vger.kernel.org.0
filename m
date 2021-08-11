Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A923E891B
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 06:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhHKEKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 00:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHKEKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 00:10:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A1CC061765
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 21:10:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so7678229pjs.0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 21:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ksvdQcHuI+ph2peHhF1/XC324UmhQU9A7omBaZGHaf8=;
        b=e94Ot4F9VK//dQKPbCT6NhBSUHd07IREz/EE0+cp2nZSM2x3uycdomE0jrdAYZNJp8
         iYBZclHzvGzhTa48rr1iqyrWVkeFEtzArCrgmyLGyn24nH3ecnJAKx9UZAkzZ62Igdio
         p3pwdyxn9Qqu9w3j1jwVz7c6cbeLPqF2zAOdxQzvnLDmx5cVAbwOTVyXpqf6uHU+Xnjw
         ujGtlhmmzRlrvIIT0cnMEOY503q9P1rRISyKvbFbpSkF/r5u9NoYSpAGXmHUg4/YD4Ie
         h+hElNMELiPhOU1WfVDgGvC4cI0FVWz6rXTcZZSH9p/Bl59/Lz7xZmXRixwC0xMgXElk
         8WFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ksvdQcHuI+ph2peHhF1/XC324UmhQU9A7omBaZGHaf8=;
        b=VU+Tio86wTPDnhED1zFyUTLV7iYkQYpK9Nf7VVAifpOK1HEiSznVF3Py5V/aN2zdsw
         JnusJohhUuWtxy5Wu0CQodGzB4SdZwgx2DhHnxD/vHCPTWRndWeklvCeKilCXsEVxYEV
         WpLz2bfrA2OjkAEDF5r1FeGXa6Csl5hFQcA4XZgZCQnP9UzFVIy66EVaKCtqjKaKZQ2m
         NO2d91A2K44PsYsQ4Lkk+qROtuANyB2rOjk7tBYAPjubSRYJn0QykwaatdTmmQz9bYUd
         R9SooOVs8KLrKPhGmQs7K5qmlI6wg2SlEUZafUhVPaXQJSOJ3xbpc7sR7RCaqOWdogbF
         NE5g==
X-Gm-Message-State: AOAM530ilUuse9/VdY2FpXjaZjjLVCnwyijUbttIixYRJaG0dPbHaywM
        a7A5sdH9E8bcgs+aINGilL8=
X-Google-Smtp-Source: ABdhPJwrJ4ZmbO0g8te04Mevy9sv246W+kSWzvQ6doTX2FC3GXBVAHl7+LbGeHq5c1SVobqanRDVbg==
X-Received: by 2002:a65:52ca:: with SMTP id z10mr43988pgp.176.1628655023437;
        Tue, 10 Aug 2021 21:10:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id 129sm21358144pfg.50.2021.08.10.21.10.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Aug 2021 21:10:23 -0700 (PDT)
From:   tcs.kernel@gmail.com
X-Google-Original-From: tcs_kernel@tencent.com
To:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
Subject: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
Date:   Wed, 11 Aug 2021 12:09:51 +0800
Message-Id: <1628654991-24406-1-git-send-email-tcs_kernel@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

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

