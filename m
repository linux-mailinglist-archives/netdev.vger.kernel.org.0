Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3392A3FCF
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgKCJSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCJSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:18:37 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DBCC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 01:18:37 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o129so13666926pfb.1
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 01:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o0hVPsAr1VDt5UfyyyjNZHilzHbFa9jL+8OkAqHUpRg=;
        b=loejW4mz8Xd638FPmeNWhz9kEzK4zno5Bh6AqET5Pln80dl2iX9l9Ftgsm6rLID3uO
         zCZVMnofFsWvVqW72fMZIKV5sQT02uaJ+nCVwWwWnodRVCAaASDFgsSdE86evNAnaLhW
         Jm5qBTeIIJFpmWB7/Y17KzIynr5gUtZReum9tHpsFtmsowvGsjYVP5h2owBuQUhYbLnn
         2AxX2m9xeAMN7qJmWGA3HyWmZBaKur+Vt0DnehcDCflMBC+j9/Mvu9xcqvzr4BRsc03b
         GBbCNZw89W3yzUOot9OjNXED9wIRhjmaDXic4owqOw2gDZyOfMgrWBG9TCL4HIaQ9G9G
         re0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o0hVPsAr1VDt5UfyyyjNZHilzHbFa9jL+8OkAqHUpRg=;
        b=qZC4O0nF2NcM1u7+xxVx5yqjJYBKXSMSKQAIOX/NETAwRvSkMv9YfX7cyzNj/482lS
         up31qGrnHhDaEwBQ9/YoWiWhUxGZkJg8aed80+oM6k8Nu40pfi2zQpj7dsI2lZCwHyop
         PzswdjLUmzFw0BmdeJmHLIkj6/yJKai0Vt++8H3MUuMZqsSSIfPT5BW1qPj6NcTnrdlT
         e6ekVaFEWXNpcxqUr8xLFmF/XWm3V58B7BVOltnXxpomLlK6XvFH4md4xF3fNjPeirbb
         QmGOrI8+ZyR1dbMd5uViw8qJra1vgrIeLBlT03DVbRMdHUKl5B7aTp/Ycb9IK5ao5T7N
         9STA==
X-Gm-Message-State: AOAM533YK37nlclZJj/QOU589ZQEWPDQyrjtk+e3vEOk+Ci1A3EnQRUA
        1r9iEZPiBIWkuB7K9FxGQng=
X-Google-Smtp-Source: ABdhPJzVvEAGd1DD9w2rtYfvEk5KUj6EugEf2yU3oisEnfgx31h/NPtSG9KufGtNspEe67H5OJhP4Q==
X-Received: by 2002:a17:90a:d30a:: with SMTP id p10mr2736259pju.15.1604395116796;
        Tue, 03 Nov 2020 01:18:36 -0800 (PST)
Received: from localhost.localdomain ([49.207.216.192])
        by smtp.gmail.com with ESMTPSA id f204sm17178063pfa.189.2020.11.03.01.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 01:18:36 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: [net-next v4 0/8]net: convert tasklets to use new tasklet_setup API
Date:   Tue,  3 Nov 2020 14:48:15 +0530
Message-Id: <20201103091823.586717-1-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts
all the net/* drivers to use the new tasklet_setup() API

The following series is based on net-next (9faebeb2d)

v3:
 introduce qdisc_from_priv, suggested by Eric Dumazet.
v2:
  get rid of QDISC_ALIGN() 
v1:
  fix kerneldoc

Allen Pais (8):
  net: dccp: convert tasklets to use new tasklet_setup() API
  net: ipv4: convert tasklets to use new tasklet_setup() API
  net: mac80211: convert tasklets to use new tasklet_setup() API
  net: mac802154: convert tasklets to use new tasklet_setup() API
  net: rds: convert tasklets to use new tasklet_setup() API
  net: sched: convert tasklets to use new tasklet_setup() API
  net: smc: convert tasklets to use new tasklet_setup() API
  net: xfrm: convert tasklets to use new tasklet_setup() API

 include/net/pkt_sched.h    |  5 +++++
 net/dccp/timer.c           | 12 ++++++------
 net/ipv4/tcp_output.c      |  8 +++-----
 net/mac80211/ieee80211_i.h |  4 ++--
 net/mac80211/main.c        | 14 +++++---------
 net/mac80211/tx.c          |  5 +++--
 net/mac80211/util.c        |  5 +++--
 net/mac802154/main.c       |  8 +++-----
 net/rds/ib_cm.c            | 14 ++++++--------
 net/sched/sch_atm.c        |  8 ++++----
 net/smc/smc_cdc.c          |  6 +++---
 net/smc/smc_wr.c           | 14 ++++++--------
 net/xfrm/xfrm_input.c      |  7 +++----
 13 files changed, 52 insertions(+), 58 deletions(-)

-- 
2.25.1

