Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB8A3701B7
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 22:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbhD3UD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 16:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhD3UD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 16:03:57 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C39FC06174A;
        Fri, 30 Apr 2021 13:03:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so2348035pjv.1;
        Fri, 30 Apr 2021 13:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7jiq5BbN2CnQxL4Mk/7l29gw0yqYVUm0cKTtem2bcTA=;
        b=ZWJd85a+XjeinbJFI2AdFKzxwSQ1UeNYHRDolHVJR4fadQ0gemCBZ3iRT8jwA28v2T
         Sm+Bxw/gRJ16FCt23nZsnmJ/M0XIYen9rfkAwzz0/dHcwYoZqSDoUe9I06NoMCaVq7Ts
         4ZhshJUc0EkaEksFMSSzgiTJtZO6eJA85MD8h/oapJvLpOxxuBnBl24o5fM5Rk8+EisC
         TGaEuomNSn2/rbfd/Hw+vlyM+1OPJRXXPfUEKb7E90G0EGGJrruRm7c7Orqkdmp5co/Z
         ZhdfDCG5pGgxFz6kHD87nGfODX4HWByZ8PYHbBHcJMgQU7FFhU516DbgETSZ+dtBWARE
         d2sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7jiq5BbN2CnQxL4Mk/7l29gw0yqYVUm0cKTtem2bcTA=;
        b=YLIJ9/DrHwaaOa7hJVIStgWAZgStuM94zSA4+qNe9aWnAszm9j8miWBRhGI6XhyAYs
         BjTODoeIrfLG6JUPGGM7wNG4ZsYEvBlF5zju4J7O5KEGHCq+xxy2rJc4m019wDpYMRfB
         ZilCI8exzNhJmjwzUka3RwYEilVfmPULNmEuqqPGrwKS1vmduJ28392M0m3joM4rZkxf
         GFYyB4yIdrcLA/8xcQqdgbL4qtWHXhlVMriQdn7MJRMgZV6n+fk0m5qB2X1DCDVxesqp
         z976KfcwbMrr4lxOH7lozjDwfg7iSy32voBM3pZlMbk5dxMzCB87Qv4qp7adl/INfxhM
         fEiA==
X-Gm-Message-State: AOAM5302XY+FgEFz+TBMpuyWpGmQLlG7kZrYO1918S5Rj8YwP2WsiHN8
        HMa5ZKpIy4NtpCHH+WkB5eOCJrZwS6lutR35
X-Google-Smtp-Source: ABdhPJxbnAttF2ojjICxQQsF3pUiCsyfB6Hiuq8JImxQbJ2nQH6nYhdeAkBPDgNx8eMQw8yO5vlBZQ==
X-Received: by 2002:a17:90b:505:: with SMTP id r5mr6986760pjz.121.1619812988635;
        Fri, 30 Apr 2021 13:03:08 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b6sm2848771pfb.27.2021.04.30.13.03.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Apr 2021 13:03:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        jere.leppanen@nokia.com,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>
Subject: [PATCHv2 net 0/3] sctp: always send a chunk with the asoc that it belongs to
Date:   Sat,  1 May 2021 04:02:57 +0800
Message-Id: <cover.1619812899.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when processing a duplicate COOKIE-ECHO chunk, a new temp
asoc would be created, then it creates the chunks with the new asoc.
However, later on it uses the old asoc to send these chunks, which
has caused quite a few issues.

This patchset is to fix this and make sure that the COOKIE-ACK and
SHUTDOWN chunks are created with the same asoc that will be used to
send them out.

v1->v2:
  - see Patch 3/3.

Xin Long (3):
  sctp: do asoc update earlier in sctp_sf_do_dupcook_a
  Revert "sctp: Fix bundling of SHUTDOWN with COOKIE-ACK"
  sctp: do asoc update earlier in sctp_sf_do_dupcook_b

 include/net/sctp/command.h |  1 -
 net/sctp/sm_sideeffect.c   | 26 ------------------------
 net/sctp/sm_statefuns.c    | 50 ++++++++++++++++++++++++++++++++++++----------
 3 files changed, 39 insertions(+), 38 deletions(-)

-- 
2.1.0

