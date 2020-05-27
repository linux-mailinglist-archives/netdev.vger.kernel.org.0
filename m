Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC11E3762
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgE0Eft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE0Eft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:35:49 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D383C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:49 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x18so8555370pll.6
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xj3nued2RRfd1WJNv7vAFi0xgjfGyUUZLnhIpsuTegE=;
        b=aWuZrEINuog7zJw2Tlw4BqS6dDbogbMFHNN0a89SqmYIQaaYJrsxbTQVfLBa5p/TOu
         Jas7QpEmDExzuUIhb3uhR3MihFEAa0TQDjAt+zXd4TywHkd83CGyUM81yu0J/FKPvF8U
         tKverAWNxo83PmDhb6XjYqA8H2WFpdGyvhIH3MpKlSExc5J885EMo20tEOgPVwSPXE26
         NTddbBen2YYHP33IHJcD3xdxZChF1GfeJJxM5gI1hTh3QRKk7VonrStQYoGKvh80Y73J
         MBgvppJPr80wcPoOdXpWrG+YN7wCDPhn9YLa5/n5uCEM+dSxURcgJly6fTl8stK1ckkh
         bFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xj3nued2RRfd1WJNv7vAFi0xgjfGyUUZLnhIpsuTegE=;
        b=djaBfOvS7Rd6cQ8qjfCsp+f0W3TL5CJ/iZ5Oahyht3wE9ufyvFEqepf/Pm2MwkrBJQ
         aAeyG5KdsnG9QReq7Gc2I15OUbgDWMzMFSyO8uGCxUhmQuy/Fp7J5cGgvAn5hu/36aNq
         YXrCA5DR24rmb7u8y7pYZZ99bpX88n7d6tQ6zvsK8FnzP1959KTgFLXD0uiyrCCWAHSz
         uaEFrLtOIwZL0U1Yo7Bi73K/WReVK73gDocnudD0ZRW0H7ujWu8nqzA8u+ZZaiNNKhxK
         tLGssTBuxpzx/c97DbVEe1duJ+a+Y3f5iv06nbsuR6hSPRzCQh2AorXs17ksxewLgHtZ
         DpHg==
X-Gm-Message-State: AOAM531Z8Nuu1qRzI+So8M8Q024lf+dWFOHootJFfpM8YqlHR1ZHSWvg
        BtxOlGEvwDKovqdu6jv+IoEwxvjl
X-Google-Smtp-Source: ABdhPJwwhGhGU+qnCp9YiYSJCgfiZOodc/lRiRFitWWhdeZTP3lxh8jkeExDIyn5GXBvaJW/Tpg4iQ==
X-Received: by 2002:a17:90a:8c8e:: with SMTP id b14mr2651369pjo.222.1590554148683;
        Tue, 26 May 2020 21:35:48 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 62sm884990pfc.204.2020.05.26.21.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:35:48 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net-next 0/5] net_sched: reduce the number of qdisc resets
Date:   Tue, 26 May 2020 21:35:22 -0700
Message-Id: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset aims to reduce the number of qdisc resets during
qdisc tear down. Patch 1~3 are preparation for their following
patches, especially patch 2 and patch 3 add a few tracepoints
so that we can observe the whole lifetime of qdisc's. Patch 4
and patch 5 are the ones do the actual work. Please find more
details in each patch description.

Vaclav Zindulka tested this patchset and his large ruleset with
over 13k qdiscs defined got from 22s to 520ms.

---

Cong Wang (5):
  net_sched: use qdisc_reset() in qdisc_destroy()
  net_sched: add tracepoints for qdisc_reset() and qdisc_destroy()
  net_sched: add a tracepoint for qdisc creation
  net_sched: avoid resetting active qdisc for multiple times
  net_sched: get rid of unnecessary dev_qdisc_reset()

 include/trace/events/qdisc.h | 75 ++++++++++++++++++++++++++++++++++++
 net/sched/sch_api.c          |  3 ++
 net/sched/sch_generic.c      | 75 +++++++++++++++---------------------
 3 files changed, 110 insertions(+), 43 deletions(-)

-- 
2.26.2

