Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA70101032
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfKSAXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:23:19 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41424 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbfKSAXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:23:18 -0500
Received: by mail-lf1-f66.google.com with SMTP id j14so15388650lfb.8
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 16:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4llU1F6LnwHCj5QCkkDFR2utRYRS39lSfGOyGIyfVHo=;
        b=hvkhe0HyZsyEUxKasN7CBPhArMPIxYuemst7zJgC6mwFDHbojiQUgTIES3kmaCgK7H
         wzEpToDBrdS32NzPxH55/yoFLKYB+TYZkHGZgbBwMSgnki3v21XSkhc5LYUanlkIKLy6
         4+y75ud2n1Iv24PNKkuKgy1+Bkac1xakcVGnUm06kDcreZO+YT+BbPVVQ3yNOfH4T7Qh
         BScxdSlLv8rDbQYBtqSVom7DP3EZHr3Oc3aRXHI7cyCoVNOuX+5YaT+KGKJVsjIN8hkl
         MSOsM3+L4aDwy11MnhjP9KbgrEKTBCTVY/U4k+FWEQ2axXFPiLjFwwyf9F880YnT1iFR
         7yxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4llU1F6LnwHCj5QCkkDFR2utRYRS39lSfGOyGIyfVHo=;
        b=IEHpNwizYpcUMZ9h+rdzMB9FgtfwS0V6sJdCl7rfD6VobZRCG0kBOInwieNQdHXNBK
         H8u9xeOe7K2qKcEc1LGQO3RmGem1F+XJmxcObwPhhFTdusBe3hF6baLeeWkG+SiP/W1O
         DgqtXXfWYnBuVZXQ/570GbCh6DfW0/tDVHTnXIvH6Ui7IDnWLp5I3OFUi6e8xso9m1Ks
         D1aAlaZLsV+bToRUf/jcfzfQRw3TItyPpx45bbhIqVJ9m9up40tNGpc/vo5j2pdOUhOo
         VIgcMrn2mv8FOGIyPtqPdw8Z5g//GCL4PgLSLocdecj427Oq9YoM1cByGbbgietCMPMd
         YwGQ==
X-Gm-Message-State: APjAAAUJZz4Soc0XAhyAvBIOETAAzn5qYNaCtybgcbKvDB9x4YMwRhwX
        kzYwPxXsuckxM26BgmYjknckXJCroyY=
X-Google-Smtp-Source: APXvYqxzCBXE23ht+1iaif+rlqHGf5YhEfM5ZZzaeubaq3PrsNd7qh/NH8WgFa5bgfBk/VQDkNwpRw==
X-Received: by 2002:a19:6e06:: with SMTP id j6mr1468098lfc.6.1574122996442;
        Mon, 18 Nov 2019 16:23:16 -0800 (PST)
Received: from localhost.localdomain (57-201-94-178.pool.ukrtel.net. [178.94.201.57])
        by smtp.gmail.com with ESMTPSA id i6sm2633167lfo.12.2019.11.18.16.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 16:23:15 -0800 (PST)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     netdev@vger.kernel.org, davem@davemloft.net,
        vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, olteanv@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [net PATCH v2] taprio: don't reject same mqprio settings
Date:   Tue, 19 Nov 2019 02:23:12 +0200
Message-Id: <20191119002312.23811-1-ivan.khoronzhuk@linaro.org>
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

Also corrected TC_BITMASK + 1 for consistency, as proposed.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

v2..v1:
- rebased on net/master instead of net-next/master
- added fixes tag
- corrected TC_BITMASK + 1 and used <=

 net/sched/sch_taprio.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 7cd68628c637..c609373c8661 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -922,7 +922,7 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 	}
 
 	/* Verify priority mapping uses valid tcs */
-	for (i = 0; i < TC_BITMASK + 1; i++) {
+	for (i = 0; i <= TC_BITMASK; i++) {
 		if (qopt->prio_tc_map[i] >= qopt->num_tc) {
 			NL_SET_ERR_MSG(extack, "Invalid traffic class in priority to traffic class mapping");
 			return -EINVAL;
@@ -1347,6 +1347,26 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 	return err;
 }
 
+static int taprio_mqprio_cmp(const struct net_device *dev,
+			     const struct tc_mqprio_qopt *mqprio)
+{
+	int i;
+
+	if (!mqprio || mqprio->num_tc != dev->num_tc)
+		return -1;
+
+	for (i = 0; i < mqprio->num_tc; i++)
+		if (dev->tc_to_txq[i].count != mqprio->count[i] ||
+		    dev->tc_to_txq[i].offset != mqprio->offset[i])
+			return -1;
+
+	for (i = 0; i <= TC_BITMASK; i++)
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
+	if (!taprio_mqprio_cmp(dev, mqprio))
+		mqprio = NULL;
+
 	if (mqprio && (oper || admin)) {
 		NL_SET_ERR_MSG(extack, "Changing the traffic mapping of a running schedule is not supported");
 		err = -ENOTSUPP;
@@ -1455,7 +1479,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					    mqprio->offset[i]);
 
 		/* Always use supplied priority mappings */
-		for (i = 0; i < TC_BITMASK + 1; i++)
+		for (i = 0; i <= TC_BITMASK; i++)
 			netdev_set_prio_tc_map(dev, i,
 					       mqprio->prio_tc_map[i]);
 	}
-- 
2.20.1

