Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B46815D9
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbjA3QCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjA3QCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:02:44 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECA9126DF
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:02:42 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id z138-20020a4a4990000000b005175b8ae66cso488320ooa.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Gn/24M76QIxLcqG6nM8dJEpPH8rAolLqQGCDF1LNnc=;
        b=Y4LLZmDozwhv2lNwdYHWTCgEhPfYtmuoMpTknqZnRrhkV0OfSzzoDxkwI1p4D46Hvf
         7ufc7u7/tZeWcWH7bQpp5lZhUOSkmbyBghg73dNzpOipb6F+ksDrGgp3JDE3jUNFm4cP
         JeQIls/9Bi+FoqGjwIyIPgGoVSEQrn++G8kAhkMtniv0MnRVVJTc4FE7lejBYJPXmVji
         hJ2oUhICcGqbUeoI4p0W+Z09Fx7ZJ/+5+ECJwUwm1FBvMklm1f2aKOhHUDYeFwYEc5Fu
         eEfEoX6EjAw5pRC8VF1M8BXHoMBeAhB1YJGm4Cykr4zXhVy9qu4/oUyl5CI40sdPxHHk
         kOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Gn/24M76QIxLcqG6nM8dJEpPH8rAolLqQGCDF1LNnc=;
        b=TtN1Ps58oy1mLIsgX28FHSvxRurtS+jFSZ7I9yNX6zUTuq3HOcuA/fW7XAMFZCVTG9
         kQgDjB6a4Zv+nUtq61GnhG91LocBA5gXYUIiL+JBbF+sp8le5AIbeGISRS13z0TWqxBT
         Ol2hONoPVFJEvDe3kj9u7NLNU6PCkTel5U23LUJVFC0dlH0vndrHSN4YpeBB4V8GM7re
         O/fWUUihzQzEc0hIUYXs5uY3QWS5NqeMaOZgQTuXMIwHnBsbgF73DwHw1ZVIs9oASgRm
         Ofxra7eXbZ81/Yse1lU8tKMEOqAwPuWB1LYwEX6TzKjGO0cZudLrdcNYNDypqoCgwwED
         fzEw==
X-Gm-Message-State: AO0yUKUQIcRHrARBFKouq9g47ilRdeihGR40eIAMGsUtucZFpB2oOvxT
        CpO7XktkG+ghsyAmDrJTurS0HrX0CKMHRUTx
X-Google-Smtp-Source: AK7set+UlKBTMtnIjVJz/KpbQpCiScDxdMyiKEprh1hobieNIhMMl/nKNrnoCz91DPyhEz+87u5E4Q==
X-Received: by 2002:a4a:851d:0:b0:517:3f56:d292 with SMTP id k29-20020a4a851d000000b005173f56d292mr4059419ooh.1.1675094562025;
        Mon, 30 Jan 2023 08:02:42 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:c9d9:8f8:eebd:a6b0])
        by smtp.gmail.com with ESMTPSA id s16-20020a4ae550000000b004fd878ef510sm5119845oot.21.2023.01.30.08.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 08:02:41 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 0/2] net/sched: transition act_pedit to rcu and percpu stats
Date:   Mon, 30 Jan 2023 13:02:31 -0300
Message-Id: <20230130160233.3702650-1-pctammela@mojatatu.com>
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
 net/sched/act_pedit.c         | 273 +++++++++++++++++++---------------
 2 files changed, 217 insertions(+), 137 deletions(-)

-- 
2.34.1

