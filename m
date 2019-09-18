Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727A1B66B2
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 17:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbfIRPFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 11:05:46 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:53025 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfIRPFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 11:05:45 -0400
Received: by mail-vk1-f202.google.com with SMTP id 70so2842676vki.19
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 08:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=vr/WPWxecgGUfZrJyYPYEX36URySWJETzMluxrCqB+Q=;
        b=RyL90NOnELV6QFXimftl5i2+3VMUeYkTo3I5KQHigz1ezBXGedJerss3+yT88DcwsZ
         RzmUAHR9gpphGUvhjn5/OnOiVJ8JlGvAHABxj1itNIg/j+GSKQM5vGTqPhvPmpeiIOOJ
         u7sPBFr1JfS8x4VepB1hAa8INmVUF88zd32l3cBYjgcEmgsDu0RKUy/BdeR2oWsPGyS5
         J3TdSCEoIs4GCx9G7YgVRYI1x6ORHYSonwFgQ8DtG3hScNZhTLMeYbPZbfBVHdqeejdL
         5ZwjyxNwwQFPt350CwLkIfyOFbEq5sv4Zzaw78uu682puYijWkVnZ6xSavw8qCeiYtx2
         0yZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=vr/WPWxecgGUfZrJyYPYEX36URySWJETzMluxrCqB+Q=;
        b=D7XATqJ01n9GF2Q6PdBgK1HkvMg8YKuAd30SnAVB3U2F+jmoPRu8NVb5hETtBDVAX3
         Ve/6yXv800nasv2b8VOI3VeX9TivhaL9E+vH4d7WDbEtpkoG/vRKjetL2ujOjp4wj399
         5pzuhtoWWPI/3QMmvG3DqunkqUF9jrz3Hsw//rhQGfk7fE1NTB7HCM+sF1IORKu8+0qm
         /2xHIwvA48ImWeodayYEQinWUwtPReohtoaFb1TUciysZVle/CdYJS6k9aHlJNH8pyme
         zhzaxWmVF0OE/OOySjF4MXKZyCJr7HCKabdmZlCfJ3q6KvKfWe3l60+3nmvNxB0eLsBl
         Ts/A==
X-Gm-Message-State: APjAAAXJ6jmkCXWdNaGdnlh9bbmxwxhO1wPLYzxyu6qDSqB6A210LQrZ
        Mcp24Nv1f8O2BtAUI4KKRJLsdvgXGH2rsA==
X-Google-Smtp-Source: APXvYqz0Oz6uMHpyB/t0JH6tekaGVKNFmSVEI+OfhgMz61yA/4XKWi3/8NObVhPaaMQqlEF+u8zTunoWme0wcA==
X-Received: by 2002:a67:1405:: with SMTP id 5mr2518480vsu.38.1568819144421;
 Wed, 18 Sep 2019 08:05:44 -0700 (PDT)
Date:   Wed, 18 Sep 2019 08:05:39 -0700
Message-Id: <20190918150539.135042-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.237.gc6a4ce50a0-goog
Subject: [PATCH net] sch_netem: fix a divide by zero in tabledist()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot managed to crash the kernel in tabledist() loading
an empty distribution table.

	t = dist->table[rnd % dist->size];

Simply return an error when such load is attempted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index b17f2ed970e296adc57bed458ec3cced4fc6705b..f5cb35e550f8df557f2e444cc2fd142cab97789b 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -777,7 +777,7 @@ static int get_dist_table(struct Qdisc *sch, struct disttable **tbl,
 	struct disttable *d;
 	int i;
 
-	if (n > NETEM_DIST_MAX)
+	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
 	d = kvmalloc(sizeof(struct disttable) + n * sizeof(s16), GFP_KERNEL);
-- 
2.23.0.237.gc6a4ce50a0-goog

