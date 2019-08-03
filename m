Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9148089B
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfHCXhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 19:37:33 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36341 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729247AbfHCXhd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 19:37:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so37835613pgm.3
        for <netdev@vger.kernel.org>; Sat, 03 Aug 2019 16:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=btfNjAU/StodtODflUCvcanP6uqDGoGYYbmWPETZzu0=;
        b=pOrLFTcoaWp7IVzMk9Pde0zLHgK690l1LFC9sig+XECXskzPF0lE87Plz6HFqlZibZ
         JwvzStecDpthKJkfjk7MmYZd270FJNz0cpEVoZzJzbhuDQMxk6s/N2w7HklxjyStYktP
         0ahNMAa/i7LWpKjZi40AqioI+zVTvEu0aE/tLWJNP+RJNfbbXHBu0NJitdF/t8nUI7QU
         Q+dRv/8NG8sZI/tfMGdmPCmRXAfHa+8AsRkhvYQ9MiAbJDnbfwWhQfKUwXZTFW7Xh/vE
         NcGE68ZRIOGECBzVH3d7mmYXy8Va8II+oj3HeyyrAiVd+Cm8/RcN9VQZiu79jzsSGx6p
         iafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=btfNjAU/StodtODflUCvcanP6uqDGoGYYbmWPETZzu0=;
        b=e9SIfJNpXe1GWw82GpIn66y7N7YGv4DPgbd4xJ5vw3cpTftQ9diYBERaExsLlLtfKB
         YD2xxGJZx3472dg5pRm9Px36ZBMEPwiKvtVKXmy+hOnjB2IBQUePRCPf0s40ZnyL/V1X
         Gfkld1yj/qfxP/mrbWwQ9q9wbht1rEvcZjNXNXfNZc7jlyFK4l1ifNHN3CKH4kzAXJkL
         J4Kq9FWAA3+HTYJLFlDnps1T4bmqkI3TydAKi76U/wIDHw92SQRmNGFSo6GWw4r/aOPj
         KJysy9LjnNMy+pFpuGk4G+Yz2jJ4bFF2yPqvuRHDuSPfagBJ5BaIgJrSFZ7c4hgcYbD/
         XB7Q==
X-Gm-Message-State: APjAAAVPdAg9uHgBmY+533auocNV4dFEVF89opXg/ZCp2K2iwqtvjnKq
        y1OpJsp7/lHSDL81GK10oT+Cmtngqog=
X-Google-Smtp-Source: APXvYqz1KnsteGOMKDDOFHKGPOypJ6y5AFzHNF4eaRyw2aAr/JwujFWPdrtJCkeX6fjAY/MPfhEe5A==
X-Received: by 2002:a17:90a:29c5:: with SMTP id h63mr10737720pjd.83.1564875452401;
        Sat, 03 Aug 2019 16:37:32 -0700 (PDT)
Received: from dancer.lab.teklibre.com ([2603:3024:1536:86f0:eea8:6bff:fefe:9a2])
        by smtp.gmail.com with ESMTPSA id x24sm76076336pgl.84.2019.08.03.16.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 03 Aug 2019 16:37:31 -0700 (PDT)
From:   Dave Taht <dave.taht@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Dave Taht <dave.taht@gmail.com>
Subject: [PATCH net-next 1/2] Increase fq_codel count in the bulk dropper
Date:   Sat,  3 Aug 2019 16:37:28 -0700
Message-Id: <1564875449-12122-2-git-send-email-dave.taht@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
References: <1564875449-12122-1-git-send-email-dave.taht@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the field fq_codel is often used with a smaller memory or
packet limit than the default, and when the bulk dropper is hit,
the drop pattern bifircates into one that more slowly increases
the codel drop rate and hits the bulk dropper more than it should.

The scan through the 1024 queues happens more often than it needs to.

This patch increases the codel count in the bulk dropper, but
does not change the drop rate there, relying on the next codel round
to deliver the next packet at the original drop rate
(after that burst of loss), then escalate to a higher signaling rate.

Signed-off-by: Dave Taht <dave.taht@gmail.com>

---
 net/sched/sch_fq_codel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index d59fbcc745d1..d67b2c40e6e6 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -173,6 +173,8 @@ static unsigned int fq_codel_drop(struct Qdisc *sch, unsigned int max_packets,
 		__qdisc_drop(skb, to_free);
 	} while (++i < max_packets && len < threshold);
 
+	/* Tell codel to increase its signal strength also */
+	flow->cvars.count += i;
 	flow->dropped += i;
 	q->backlogs[idx] -= len;
 	q->memory_usage -= mem;
-- 
2.17.1

