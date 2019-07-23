Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC7A6710B3
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 06:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732601AbfGWEn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 00:43:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33737 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730761AbfGWEnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 00:43:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so18464681pfq.0
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 21:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1VudhpqrjtPC2BiJdBlKof0K6256U/1OZgWnoGKSxbw=;
        b=nDazJO4wWahvkk9uFkeXN96FIVmhdXz6wlEWdeznBvmljPURgGsx+vPdis8j+e1hrr
         2D47SEKuYmNy+lvSqjREMbmvUva1MACJOvX+MyQ2T5jia3cg/s5tILdv/fBd2j3bW0Vg
         7DSiKkiKapwOA9OuOLbdX1ObVBNBGS53powUaLDJk+shqDIRHsWekjfyGR1q5wgrYATH
         dYiT7CW/ayfLIUBOrt2oHEZT1gvvfPe4+8NRlavoKuPoNFliZ4YL3FMbLIVw/ALTGPQF
         yDo6ROPGM/gOZFOHzq9ESbDlkP6LsxSurm9pPmRhIfAbSgu/ikJKChOzClF6U63nDio4
         Usbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1VudhpqrjtPC2BiJdBlKof0K6256U/1OZgWnoGKSxbw=;
        b=rbtSLtkcnLqv93b3w8YF4whvYeJrKpx2aGLHotKlk7Hs1N5gheXf0WIUk9UXAyD73t
         0a2Mw6/br4PCBve1TuuQ9jfCmoViX7PMieQrhGw/wSZqtmv9UxEL24BDt3DrO1bCjMyU
         B8MslhJ2qkAQE5U+L0Uyd093Sbmc06Tyf8kt8p4EVGHzRNA52sG2jn+Xee8QWttI5sFc
         8htYqEbV3hxAok93BteVOlmbtbYJkmyC7KGXIXb6+wjateSu5zeLTRg40eAg17fVk18l
         ICP76Wp8ETf0PS7kkKaI0vm5xQeKE3B0G5VHq0SwlW+JeULfIm8Tjumi5lZDFBwblPDP
         dLCA==
X-Gm-Message-State: APjAAAVZTbOiJ54ZAF/utuTajWhtzcSega+1OB0fH9NK9qfEqdCHOLwm
        BSuwfdc5Yqqn434233pxZCa3YCKSz1I=
X-Google-Smtp-Source: APXvYqxAw/2BiaoAira3v9w+vvbkxbaHVIM5XSZtegti3vu83pJ0t16CYz0BeOtxGQEjOI0EOt7XOA==
X-Received: by 2002:a63:3fc9:: with SMTP id m192mr76156478pga.429.1563857004999;
        Mon, 22 Jul 2019 21:43:24 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id w4sm51854728pfn.144.2019.07.22.21.43.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 21:43:24 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+fbb5b288c9cb6a2eeac4@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] ife: error out when nla attributes are empty
Date:   Mon, 22 Jul 2019 21:43:00 -0700
Message-Id: <20190723044300.16143-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

act_ife at least requires TCA_IFE_PARMS, so we have to bail out
when there is no attribute passed in.

Reported-by: syzbot+fbb5b288c9cb6a2eeac4@syzkaller.appspotmail.com
Fixes: ef6980b6becb ("introduce IFE action")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_ife.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 41d5398dd2f2..3578196d1600 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -481,6 +481,11 @@ static int tcf_ife_init(struct net *net, struct nlattr *nla,
 	int ret = 0;
 	int err;
 
+	if (!nla) {
+		NL_SET_ERR_MSG_MOD(extack, "IFE requires attributes to be passed");
+		return -EINVAL;
+	}
+
 	err = nla_parse_nested_deprecated(tb, TCA_IFE_MAX, nla, ife_policy,
 					  NULL);
 	if (err < 0)
-- 
2.21.0

