Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6385682FBE
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjAaOwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjAaOwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:52:06 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF53C2940A
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:52:05 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id e21-20020a9d5615000000b006884e5dce99so5494816oti.5
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+4O5OmPTt5TeZL/wQPVmfFEhgjgr79SuvUM3ydqeh9Q=;
        b=1CZ7dcWyd3mXRnbTgoBBuJHipoSOM5X2XVIf9DBuDX5/eCttbTPdyDaVEx49pDuyAI
         wbI+4BnZJAJP7yM+CIa/gFZynG5qTuZsb6sdlQTDfBE5EkKlBayCO69TY+lQ8QaUL5Ru
         8MNMv8Y8rp+T2tmL0YJhXXlxGHR5u/6qCFXZHE8ZnZo998wTthg1kfHNf61837mSYDcn
         UVp2mehPSR8lYha+mZrlR4zGlEiA/SXr3faZ1mNb2ch8lak7E6Bmv27H2wJ/R5R6SAEo
         dWH0OfwvutsMme5wRcH9n3TOdI9OBI69eya/u59R7nlqXtjb/C0ZMGwcJhI/KjGa4+eE
         ulwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+4O5OmPTt5TeZL/wQPVmfFEhgjgr79SuvUM3ydqeh9Q=;
        b=izlGqVWN/BKwQ9cvdDKI75Rl4rT7Bg9GyNsz57NX1x2MaBQ7PEL/hX3NOSXqckUGoC
         jv33rmiCottbpH3TexNWMHXGvQElrDMluVEcuhP6D8vkD6mo7zXc3q32mlHQBC6D4pu0
         amRlDShHmXRbfbLGQUWyVY1W7XmTTjo3zlB9RwQO2GiCuvgAvL+PHSJnYL/tLSdcKcg+
         XQhw8+vcRS/5esJZoYTzaVwx+tr9F6Wz/bl6JC/2GJoMrx8PjdskAVX77Tj4pXDquexX
         VYuhfhEfXaAx8oG91EKlda7c0H6wwWkD3qejOK04h96zJ1g80zseK5Uu1lf21aZ69Jzu
         ib9w==
X-Gm-Message-State: AO0yUKVV+AuH/L1LaRxVuPYEwq5fQLhffBPDDiIinNYlVZbqMV+sMPat
        KQ74L8JHwmxxhXxFUgVkn9YubmICd9uETZ3P
X-Google-Smtp-Source: AK7set9WOeNjko4daYYoMFwLLb5G4vpvZL7wp5KW71KM3xGdDbXXnYv7cNNC29UBHQZtBT7HyrYcrg==
X-Received: by 2002:a05:6830:34a3:b0:68b:d0cc:d1c2 with SMTP id c35-20020a05683034a300b0068bd0ccd1c2mr4804873otu.19.1675176725074;
        Tue, 31 Jan 2023 06:52:05 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id e4-20020a0568301e4400b00670461b8be4sm6639371otj.33.2023.01.31.06.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 06:52:04 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 0/2] net/sched: transition act_pedit to rcu and percpu stats
Date:   Tue, 31 Jan 2023 11:51:47 -0300
Message-Id: <20230131145149.3776656-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The software pedit action didn't get the same love as some of the
other actions and it's still using spinlocks and shared stats.
Therefore, transition the action to rcu and percpu stats which
improves the action's performance.

We test this change with a very simple packet forwarding setup:

tc filter add dev ens2f0 ingress protocol ip matchall \
   action pedit ex munge eth src set b8:ce:f6:4b:68:35 pipe \
   action pedit ex munge eth dst set ac:1f:6b:e4:ff:93 pipe \
   action mirred egress redirect dev ens2f1
tc filter add dev ens2f1 ingress protocol ip matchall \
   action pedit ex munge eth src set b8:ce:f6:4b:68:34 pipe \
   action pedit ex munge eth dst set ac:1f:6b:e4:ff:92 pipe \
   action mirred egress redirect dev ens2f0

Using TRex with a http-like profile, in our setup with a 25G NIC
and a 26 cores Intel CPU, we observe the following in perf:
   before:
    11.59%  2.30%  [kernel]  [k] tcf_pedit_act
       2.55% tcf_pedit_act
             8.38% _raw_spin_lock
                       6.43% native_queued_spin_lock_slowpath
   after:
    1.46%  1.46%  [kernel]  [k] tcf_pedit_act

v4->v5:
- Address Simon's comments

v3->v4:
- Address Simon's comments

v2->v3:
- Add missing change in act idr create

v1->v2:
- Fix lock unbalance found by sparse

Pedro Tammela (2):
  net/sched: transition act_pedit to rcu and percpu stats
  net/sched: simplify tcf_pedit_act

 include/net/tc_act/tc_pedit.h |  81 ++++++++--
 net/sched/act_pedit.c         | 273 ++++++++++++++++++----------------
 2 files changed, 213 insertions(+), 141 deletions(-)

-- 
2.34.1

