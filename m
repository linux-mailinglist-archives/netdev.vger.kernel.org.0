Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2D81C2973
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 05:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgECDJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 23:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726702AbgECDJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 23:09:33 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDFFC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 20:09:33 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id q57so16449960qte.3
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 20:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=n/0Ut9gQo5Jm24RDwN7W8/9Z0xUpyQWs338WKD6Iu04=;
        b=jJ6NWY0sJVbw7e0rjJqsRz1Kd/uPOqG7ndgImK0GeRlaqMYnEBN1ixrZbDvA5Ou1Kk
         ST+/IL0Fy+bVK9ullTmErnX1VpEG1JpRyVhypkCgC1EJLfZSeonb9fwJTi9HXPhWMDFL
         nmzCyMn73XsdAPm4xSRwJ7Oq40N73A8exUNJbe1ZRLHrhLMgEQAH0/pBHz7KqWETvlT7
         zMp6AZ7nJnSlB21sxzVLwQhNtGMrw1+14PcPmNOY3CarEHdwiHiYJg73SPX51bcBCxEK
         o0Xezdds5p9hPPzBemBHTLmNdOrVttpcMpQvIQZr1hHcpLzCYelzh2g1gs6gf8LfbNBl
         P8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=n/0Ut9gQo5Jm24RDwN7W8/9Z0xUpyQWs338WKD6Iu04=;
        b=iv19ej/a9oUharehbnWB+ecQTfwNzd/EqUgklYnO6XDpPweZKCGqMgO3yNdgn657sR
         C7GCS2WS8xwYeHxuV8YvTwYI+Q0xF7FWKqmxRB8uVa42YSIG1se3ET6aQpLNbm5+BF1O
         pUfMKlzGYXOP3wb5jvnlRb23TOjrzYStQkRyueF+G1OHQxuw1MYjmtdWQdSGlSc39JUz
         b/znULbuhwtOMkDWks+Fjk9c/ZhnODe9noZTI+WlO8r/FRkuFfCcw+iBUxqpuZ+ZL7b3
         LPAbGeR2I3tpxsxDGogxh7BjKqeGoGOtLrroavvAYa5FMXI5Vc0+LoQpSNLl8imNPkMo
         6ThQ==
X-Gm-Message-State: AGi0PubBlO+b7v881Wi01Gck+hqtaJ5w6y9kHu4EYxaQ7IU5l5FBFnPh
        rfdDqrlaWvgxJXMBzgSrYVgOPv1KFhtRBw==
X-Google-Smtp-Source: APiQypLN9ow+cITm/6bkRSEt6jAVZeKREz3whhG9fXyMy1AYbbV/dQiubkrHr80BL2OeefX6mmDXO++U6glkOg==
X-Received: by 2002:a0c:e992:: with SMTP id z18mr11228948qvn.25.1588475372452;
 Sat, 02 May 2020 20:09:32 -0700 (PDT)
Date:   Sat,  2 May 2020 20:09:25 -0700
Message-Id: <20200503030925.33060-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net] net_sched: sch_skbprio: add message validation to skbprio_change()
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

Do not assume the attribute has the right size.

Fixes: aea5f654e6b7 ("net/sched: add skbprio scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_skbprio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_skbprio.c b/net/sched/sch_skbprio.c
index 0fb10abf757962c1e3e6feb8c68dedd9a1808f1b..7a5e4c454715617cb57c6db7de7fdaa9e6886d40 100644
--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -169,6 +169,9 @@ static int skbprio_change(struct Qdisc *sch, struct nlattr *opt,
 {
 	struct tc_skbprio_qopt *ctl = nla_data(opt);
 
+	if (opt->nla_len != nla_attr_size(sizeof(*ctl)))
+		return -EINVAL;
+
 	sch->limit = ctl->limit;
 	return 0;
 }
-- 
2.26.2.526.g744177e7f7-goog

