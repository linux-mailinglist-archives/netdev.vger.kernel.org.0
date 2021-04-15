Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4D3603CB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhDOIAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbhDOIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:00:23 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3460C061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:00:00 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p67so10582277pfp.10
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 01:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7lUrl78FZWgL/B+JdFUwj8s8u2OB2mAhQiecoNfWZKI=;
        b=qHtJrEWGz4PRtii5kmrudJyiCizuEZA74LfUAnbrCANTBCPW3HNRcM2ZzDY2cHVRUK
         c2cPdFzROG1+UWApX6cJwQHm87fa2TArRaCpGZmGihVdK/1py13FhxRdkvtqfMw9LPIC
         vqxBzTEEO7Nn7wCNrNidHDrPg6r1n+2TnFjNkhP2ClEfizcUCcpjj/n4KBJ0U8XCuOJ1
         9GA/gXZ9xRZAE5KTRkjPpetpiC6NbQ1obkwOIgykgSaJBekiwiAdwcGH9GWNbI9WcfhV
         lBhCAYiNrXt6D6qmMFItXRd5CIKGZimiCp5gg7OLqmb/idu1qwmI5tbRGxrnwhWEUhQ6
         Nv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7lUrl78FZWgL/B+JdFUwj8s8u2OB2mAhQiecoNfWZKI=;
        b=f9WhKJt4yUrq24i5wj2z7ckd3JrqQpq4Z+5PSziPqYejIJz4Zhsa/Q4VGD2Keuz4UY
         FPUMm0iWfahdaedYSF3LnjT3LRXobhJPvp7aFdpu6qjNviKJGxiGRjpsLcoOHi0I1Ifi
         T+UDz/FAlrFX/c2ijCqbhnfK/vE4WwzIVmLtAcRdR3P7GYykVT9DBz2wUghBYolMe1nJ
         mH/6q0EXyFnSzmd6T4LJNFnXhJm4uB+sIvdEusk16AUiqq1KPEwLPF/kJPJUfRMYjkHZ
         BDmCNRj7+b0NEaQldUOqcG2z2Zpk84lep0OovcHVK167YKLvMeNE107Fc9aCOWXKQE//
         U54A==
X-Gm-Message-State: AOAM5323w6ub0yVKvLwmFcY34modMGzR1UeZzT188W+cyq/mj97fC8yr
        IMGF0pkdMTFpO3TVA8eg6h0=
X-Google-Smtp-Source: ABdhPJzuLASIWPjtUrKHOMeRVYzVZMDX8I1D6SZsIKH7zWnL3pusFrKyA6pntamsSELEPNBpbL72RA==
X-Received: by 2002:a62:3892:0:b029:250:4fac:7e30 with SMTP id f140-20020a6238920000b02902504fac7e30mr2034532pfa.81.1618473600399;
        Thu, 15 Apr 2021 01:00:00 -0700 (PDT)
Received: from nuc.wg.ducheng.me ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id 184sm1424387pfx.156.2021.04.15.00.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:00:00 -0700 (PDT)
From:   Du Cheng <ducheng2@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        eric.dumazet@gmail.com, Du Cheng <ducheng2@gmail.com>,
        syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Subject: [PATCH v2] net: sched: tapr: remove WARN_ON() in taprio_get_start_time()
Date:   Thu, 15 Apr 2021 15:59:52 +0800
Message-Id: <20210415075953.83508-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415063914.66144-1-ducheng2@gmail.com>
References: <20210415063914.66144-1-ducheng2@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a reproducible sequence from the userland that will trigger a WARN_ON()
condition in taprio_get_start_time, which causes kernel to panic if configured
as "panic_on_warn". Remove this WARN_ON() to prevent kernel from crashing by
userland-initiated syscalls.

Reported as bug on syzkaller:
https://syzkaller.appspot.com/bug?extid=d50710fd0873a9c6b40c

Reported-by: syzbot+d50710fd0873a9c6b40c@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
Detailed explanation:

In net/sched/sched_taprio.c:999
The condition WARN_ON(!cycle) will be triggered if cycle == 0. Value of cycle
comes from sched->cycle_time, where sched is of type(struct sched_gate_list*).

sched->cycle_time is accumulated within `parse_taprio_schedule()` during
`taprio_init()`, in the following 2 ways:

1. from nla_get_s64(tb[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME]);
2. (if zero) from parse_sched_list(..., tb[TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST], ...);

note: tb is a map parsed from netlink attributes provided via sendmsg() from the userland:

If both two attributes (TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME,
TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST) contain 0 values or are missing, this will result
in sched->cycle_time == 0 and hence trigger the WARN_ON(!cycle).

Reliable reproducable steps:
1. add net device team0 
2. add team_slave_0, team_slave_1
3. sendmsg(struct msghdr {
	.iov = struct nlmsghdr {
		.type = RTM_NEWQDISC,
	}
	struct tcmsg {
		.tcm_ifindex = ioctl(SIOCGIFINDEX, "team0"),
		.nlattr[] = {
			TCA_KIND: "taprio",
			TCA_OPTIONS: {
				.nlattr = {
					TCA_TAPRIO_ATTR_PRIOMAP: ...,
					TCA_TAPRIO_ATTR_SCHED_ENTRY_LIST: {0},
					TCA_TAPRIO_ATTR_SCHED_CLICKID: 0,
				}
			}
		}
	}
}

Callstack:

parse_taprio_schedule()
taprio_change()
taprio_init()
qdisc_create()
tc_modify_qdisc()
rtnetlink_rcv_msg()
...
sendmsg()

These steps are extracted from syzkaller reproducer:
https://syzkaller.appspot.com/text?tag=ReproC&x=15727cf1900000

 net/sched/sch_taprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 8287894541e3..5f2ff0f15d5c 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -996,7 +996,7 @@ static int taprio_get_start_time(struct Qdisc *sch,
 	 * something went really wrong. In that case, we should warn about this
 	 * inconsistent state and return error.
 	 */
-	if (WARN_ON(!cycle))
+	if (!cycle)
 		return -EFAULT;
 
 	/* Schedule the start time for the beginning of the next
-- 
2.30.2

