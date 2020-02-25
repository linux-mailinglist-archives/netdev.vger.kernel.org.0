Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BAB16C170
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgBYMyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:54:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37468 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729066AbgBYMyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:54:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id l5so10363316wrx.4
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 04:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mk5/luBuqAZevIDbTNpIMjdUEpupZQ2J8usCGL3XYGg=;
        b=lWCL/tBJ33b8t2DiF+p1SnGfi9PjKFl4kYHSqVp7Uie+zC4P7wYqJzxz3mhsJxsbU2
         VSKUBzVRVeu6TUxgwEInBn8X8bYgw0xIUK3guwW7BpeDtLqKXjmYmtUbysa108ByZHAC
         Bwqc/b0ykNVtGVzLfRDt91eh03HA/29i8UaJIoia0Np2DSJjd7ndPYnBoSG904MFdAVt
         8FmlKR5AX58UNfirkkXjBy79P77fpJMG14/D1r04ox44DCWHJWVFZ+F2wFM0SIDeA8AO
         5yqBYJjr+vZkTWxMymSwHd35lGTUw0+r90p0O+L6U6SXJthqc+gEo7BcNGrOk2583wJg
         Ebkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mk5/luBuqAZevIDbTNpIMjdUEpupZQ2J8usCGL3XYGg=;
        b=ZLSG4tzINPvn+k6e/emSRfOP6h/OquhdICPhDR4qoN98s5FpiDzGxlRV66CYKHVbWc
         pix0COv1WTPjgC5CU8ZvQb5/cep8CQ8WkrrJV4Y9TI5gU1I7vw+5mZy6m5y3r/Rftr6s
         6LdcXsDRN3SvTsBOB8Bi5iJInMVIIsPajkNzr9hSWne0LshRTgNjAPCNoyejd7MYHTnp
         34sEv4vSZvpYupyFNtnI/J1J2ocUxZKwXIGVw8HfW+WjJ6yr1wH40rO94pYt59Uih1QC
         BZsrUXJMiikLEMv1JLf5pkN683+34rEldI+yzHHR6Ycz7zqhMsWLs1LYp/zBPrhVtc8N
         9wgg==
X-Gm-Message-State: APjAAAXFbTQt6I3Fe+bOYd82ne76oMUqsUfq0Ic6KDKe35Dft4XFfkKz
        EUxzmBfBed0KyJritQT+YXvmLIYMgf8=
X-Google-Smtp-Source: APXvYqxhPWYoLrj6FMabghbrtRdeRH5rH2NwdoEaB3EawVdgInt1LJpxIXVW80KZh6sfcjvdwTSvtA==
X-Received: by 2002:a5d:6692:: with SMTP id l18mr70669829wru.382.1582635253619;
        Tue, 25 Feb 2020 04:54:13 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id c26sm3689344wmb.8.2020.02.25.04.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 04:54:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, vladbu@mellanox.com, mlxsw@mellanox.com
Subject: [patch net] sched: act: count in the size of action flags bitfield
Date:   Tue, 25 Feb 2020 13:54:12 +0100
Message-Id: <20200225125412.9603-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The put of the flags was added by the commit referenced in fixes tag,
however the size of the message was not extended accordingly.

Fix this by adding size of the flags bitfield to the message size.

Fixes: e38226786022 ("net: sched: update action implementations to support flags")
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/act_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 90a31b15585f..8c466a712cda 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -186,6 +186,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 		+ nla_total_size(IFNAMSIZ) /* TCA_ACT_KIND */
 		+ cookie_len /* TCA_ACT_COOKIE */
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
+		+ nla_total_size(sizeof(struct nla_bitfield32)) /* TCA_ACT_FLAGS */
 		/* TCA_STATS_BASIC */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_basic))
 		/* TCA_STATS_PKT64 */
-- 
2.21.1

