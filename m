Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C347FD29C
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKOB51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:57:27 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41817 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727406AbfKOB50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:57:26 -0500
Received: by mail-lf1-f68.google.com with SMTP id j14so6692379lfb.8
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 17:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VhwfCvUXZdHcPjd/8gnXz63IRCXwmj0cc9MwMWk9XXQ=;
        b=e+QjIhLz/WsEJAN12AxLkTNiXTZIBr5lqC50IVP0v3sj3Dv4Vght57Kv79N+t2D0uf
         U+mTHNdA3WbMGdb9k6sJoOovSavYzNoubzdH8/k9oiMusB8TRlv5I8W07vZMh+xP4SNn
         66YT/YbdoWng9ye34W9IfWIPnEeHVWKymthBeju9oAksBfbIcCppd3oKuMK5KzpzAWK9
         gYOUlRqvPBWPnSEtGjNvz2c2Gvgsw/aSfn9s+yPjqNsGBMu6TDE2zdKdJk+awScoOZGn
         He2vsQHPpfNKqMPSrFqqwuUWbNuD/zy/vh7AhQmMdOECtXu/kiIeXELfwO+pIPVp/1Up
         peIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VhwfCvUXZdHcPjd/8gnXz63IRCXwmj0cc9MwMWk9XXQ=;
        b=LGVr++XI2FX6wly3j6C8M0zSZTo0LODMpqlRDjHqtkGl/aXUuwubTJk6yQQ/9B9IN/
         a8HXyjc2IP9mhgY3qU9TyjD7TTF1qFArgr40JzmOCAivk/ewBIu5QNLDB+ZQVn/cVXNK
         jzG0iOmBWokSzRNVbohW3CnVgt6JcHOdcm5xKU4Tnx0VLLwTKrw9MhD4o+mlFk9VW9+p
         Fyftky+wOKqBKaYdw2Osoi9dTxe/w5srKs29XeFFto8XwmmO3xQ1WeNXnoNbpcdwFow3
         2DpOas/ao4rXgSAnWeufjV9PAPb3+YFGGRR4Ju+TqcNk/KayiYbVcrLk39e0HC7c9Dmn
         2wtw==
X-Gm-Message-State: APjAAAUJ9oBghoKoq/1AbI0mZt32IhVw/CAypJxkSeAjWBUHeVtnmbO6
        O0Ok6BnwLnri1N6glsA/2nzXvr8d0P4=
X-Google-Smtp-Source: APXvYqz1qOY1cWE8Vi59QvBvRmmDiO65qvpBAwJtShWlFCb8fPUP7tPVw8M2P1uoObYofhL+pdmBGA==
X-Received: by 2002:a19:3f07:: with SMTP id m7mr9468163lfa.136.1573783043837;
        Thu, 14 Nov 2019 17:57:23 -0800 (PST)
Received: from localhost.localdomain (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id v22sm4376394lfg.63.2019.11.14.17.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 17:57:22 -0800 (PST)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [net-next PATCH] taprio: don't reject same mqprio settings
Date:   Fri, 15 Nov 2019 03:56:07 +0200
Message-Id: <20191115015607.11291-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The taprio qdisc allows to set mqprio setting but only once. In case
if mqprio settings are provided next time the error is returned as
it's not allowed to change traffic class mapping in-flignt and that
is normal. But if configuration is absolutely the same - no need to
return error. It allows to provide same command couple times,
changing only base time for instance, or changing only scheds maps,
but leaving mqprio setting w/o modification. It more corresponds the
message: "Changing the traffic mapping of a running schedule is not
supported", so reject mqprio if it's really changed.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 net/sched/sch_taprio.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7cd68628c637..bd844f2cbf7a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1347,6 +1347,26 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 	return err;
 }
 
+static int taprio_mqprio_cmp(struct net_device *dev,
+			     struct tc_mqprio_qopt *mqprio)
+{
+	int i;
+
+	if (mqprio->num_tc != dev->num_tc)
+		return -1;
+
+	for (i = 0; i < mqprio->num_tc; i++)
+		if (dev->tc_to_txq[i].count != mqprio->count[i] ||
+		    dev->tc_to_txq[i].offset != mqprio->offset[i])
+			return -1;
+
+	for (i = 0; i < TC_BITMASK + 1; i++)
+		if (dev->prio_tc_map[i] != mqprio->prio_tc_map[i])
+			return -1;
+
+	return 0;
+}
+
 static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			 struct netlink_ext_ack *extack)
 {
@@ -1398,6 +1418,10 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 	admin = rcu_dereference(q->admin_sched);
 	rcu_read_unlock();
 
+	/* no changes - no new mqprio settings */
+	if (mqprio && !taprio_mqprio_cmp(dev, mqprio))
+		mqprio = NULL;
+
 	if (mqprio && (oper || admin)) {
 		NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running schedule is not supported");
 		err = -ENOTSUPP;
-- 
2.20.1

