Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618CF83D77
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 00:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfHFWpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 18:45:45 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36179 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfHFWpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 18:45:45 -0400
Received: by mail-lj1-f196.google.com with SMTP id i21so4368427ljj.3
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 15:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=yFlcIGmAU2Q+uytclp71VZt3u5YOqHJodYGg72mUCzc=;
        b=GbTjz/2s4NjsyNf0XtwpIGx2XV/fhtcfMSKIKlRJXkD9uQ5mQ9ip7LHSp5MrQDSHT2
         9H/vZ9roGFqPllWoYovJJRa2aOtFjhsPn9Iw0pWUW1ZMVPfk9U//Ju8G/l9ovKsbufzw
         q2wrMMGsHQ2w/MUQavcj7lKXuvcx6eitC4HKg3t7C7rlYZzovmqS49rkgQ/esrqfnDVw
         eezHif8/em/bku2sgVbKe1P/SCNc7B0DBllLUk87nFP6btrR4iLrw8zILBq4PP0IJrY3
         LT3JoHgVDe597SQVwij/Fx9Mu4spKfE9Qcfen+HJUIyptPt55p48MZm3sA5kvjY5UYGY
         hK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yFlcIGmAU2Q+uytclp71VZt3u5YOqHJodYGg72mUCzc=;
        b=XF6969J0vlgkRJyEoJEcKba/fx215csbY6KwUaBMTM1w2lQKC0y+C3Dt4A6qWaejy/
         4kutqkab+X6/XeFa9YsK+PdUB8D1sRyjY51/O+MWwmiKgX7B3q+3eF1OusBOyaTrsSnK
         MvZb5sFpvUc2zIZJV/KYp9H6U+G78lViVQNm7pTC8u0AhElZxgNT24a6QStO4veTvg1N
         lzSVJhQongMuX+iGtloZRydstD55rga1mvQhs5n08bxZ6gG+HrVyEuUvpWKhN/nYS7Bj
         Do/k5kLlue3ucWPXGlgU2RRs6gcig6zQnsFG2a/ytiAN6JQRF3lEymWzIyF0xtVAIqNi
         6QYA==
X-Gm-Message-State: APjAAAUPnqO1UG5ahB2wfrtUzR8XKWYUGe4fZR00OjHd+kfeUBIqEZSn
        hZJ5vkINZ/d/8eP+pFTfM6ZmaA==
X-Google-Smtp-Source: APXvYqzv5v+UvSduzIqq3jgfq6+g5eZaOOBvLM0FzCtbv2aLfiIX6ycIMkVZq1lfC5ch9/jKKSToMg==
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr3024100ljj.170.1565131543482;
        Tue, 06 Aug 2019 15:45:43 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id j30sm2540507lfk.48.2019.08.06.15.45.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 15:45:42 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     vinicius.gomes@intel.com, davem@davemloft.net
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2] net: sched: sch_taprio: fix memleak in error path for sched list parse
Date:   Wed,  7 Aug 2019 01:45:40 +0300
Message-Id: <20190806224540.24912-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In error case, all entries should be freed from the sched list
before deleting it. For simplicity use rcu way.

Fixes: 5a781ccbd19e46 ("tc: Add support for configuring the taprio scheduler")
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 net/sched/sch_taprio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index c39db507ba3f..e25d414ae12f 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1195,7 +1195,8 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	spin_unlock_bh(qdisc_lock(sch));
 
 free_sched:
-	kfree(new_admin);
+	if (new_admin)
+		call_rcu(&new_admin->rcu, taprio_free_sched_cb);
 
 	return err;
 }
-- 
2.17.1

