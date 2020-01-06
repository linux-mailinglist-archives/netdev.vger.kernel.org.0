Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D17013135B
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgAFOKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 09:10:44 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:35206 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbgAFOKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 09:10:44 -0500
Received: by mail-ua1-f73.google.com with SMTP id n23so2526069uao.2
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 06:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Lby6/1HCjr1ttcdqc9WcEVzlNfwkYXlBMw6C0GCuB1g=;
        b=ivxS/mmXynWeVZFCgOQ9T+slkE72A2xa+4cSYtscWY+79RKj4sHOIHf9bjEzFivRXM
         vNlg3VjXFpLmKYEk4gXj1MJbFpS0LOSnZMHTsAHZcDao4ygeMiXYOK8RtblqI+uNWDjS
         En19wdju0qub+OkESWF+cKlV8nKw131XXswhuWZlnaRAR483k07VIi74PCgcDq91qx3/
         BgrRwawHF2HHeAQO36XI50LdpH4TUlEph4oc1xv6fZCIyzSGtFpjrA4gtpHg/rtnCCd5
         0jwkuH0D9LxzN4ObeHCzQIZwYkFpplr5Vg5XRgPJulaXN2WTb5uzd6IoGRA6K+Ise3AN
         Tl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Lby6/1HCjr1ttcdqc9WcEVzlNfwkYXlBMw6C0GCuB1g=;
        b=OOS0P0RoDSM6FdjPTnxNIHXIiQ5tiHC9kh2yFBbT4PAxtY0cFmGUxGn3ISggcEFovd
         2k3x1rK/FPp0MNGOh0c3zdQ510VOLgiSA+ledL77K85ggfsQAjEvhXKukR7238pWwVT/
         /asuVjqHq0qLUI+jd/GF81DHExifpvMXRurrxjvFTRsQodHWyPJdcHg8TxdUETcWgZNd
         aB+wlFKCI3vQLI7KepsJgBfUsAEqpnlE4AeauX1BTTgc8lDjVLgb6UzDMmQz7WBNMAOm
         DVm5LaEIGk6+RYfB0XT/3MCHuwZE8kmO2+V76NEkNJO5RrSo2Yae+ETDb4gHN5OBVYhR
         GvxA==
X-Gm-Message-State: APjAAAU06sgdMDiiR+cR2UiO42kwmqZtzxyvzXdpRYDZD8cM7pumdddl
        2ydaajupM8tfRlFff5aI4dfXSACZKbsT2g==
X-Google-Smtp-Source: APXvYqyaz4WooYVH0MovbEKdzVBQ5/Qw3vKLe6a3XPP8EqWzx6VZi1Qxz7mprYMkjeQOgGqsUu8cdkIjl+mnyg==
X-Received: by 2002:ab0:710c:: with SMTP id x12mr56201669uan.81.1578319843021;
 Mon, 06 Jan 2020 06:10:43 -0800 (PST)
Date:   Mon,  6 Jan 2020 06:10:39 -0800
Message-Id: <20200106141039.204089-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] pkt_sched: fq: do not accept silly TCA_FQ_QUANTUM
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As diagnosed by Florian :

If TCA_FQ_QUANTUM is set to 0x80000000, fq_deueue()
can loop forever in :

if (f->credit <= 0) {
  f->credit += q->quantum;
  goto begin;
}

... because f->credit is either 0 or -2147483648.

Let's limit TCA_FQ_QUANTUM to no more than 1 << 20 :
This max value should limit risks of breaking user setups
while fixing this bug.

Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Diagnosed-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+dc9071cc5a85950bdfce@syzkaller.appspotmail.com
---
 net/sched/sch_fq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index ff4c5e9d0d7778d86f20f4bd67cc627eed0713d9..a5a295477eccd52952e26e2ce121315341dddd0f 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -786,10 +786,12 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_FQ_QUANTUM]) {
 		u32 quantum = nla_get_u32(tb[TCA_FQ_QUANTUM]);
 
-		if (quantum > 0)
+		if (quantum > 0 && quantum <= (1 << 20)) {
 			q->quantum = quantum;
-		else
+		} else {
+			NL_SET_ERR_MSG_MOD(extack, "invalid quantum");
 			err = -EINVAL;
+		}
 	}
 
 	if (tb[TCA_FQ_INITIAL_QUANTUM])
-- 
2.24.1.735.g03f4e72817-goog

