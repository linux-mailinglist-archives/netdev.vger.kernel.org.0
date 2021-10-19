Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97AC432B36
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 02:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhJSAgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 20:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhJSAgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 20:36:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C825C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 17:34:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so703540pjb.1
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 17:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q01cbs6/SVguoM7bfj09GMUoIdvn58RGmBOiv0i7+ac=;
        b=BwTqaqwshEsO8xESj5g//t0D8YjxqozKwaODeBSPt/wGAGUcEw9SaBFgWoxi1uThSS
         28S5ZeLpvCl9fE1TmCnq5jXfCKJ6ENxigfzvfHxsxIvtwl/A23Qx/FwtZ57gppns/N+D
         a/SPblJ5dL5eXccqJhfVT0UgpGzLl/X+vFcGUO8JEpeHNeC7bJZ02aq3yvWxMzyRMTTJ
         UGCH2KxOfK+acacoZUGmV/f/k6bxBCgSUlUEGCNEduce45t2oCzTukqrz+xlofh7jcqp
         ESyDQucU6/mqiWWsLc0g3dLx/B0uqqp/xoUBNS42MzWbANzmiVm4Wz1Ym08y7JS0ygNY
         zOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q01cbs6/SVguoM7bfj09GMUoIdvn58RGmBOiv0i7+ac=;
        b=DJ22pre9DFgJC45kxxCQaDX1QFLFaW5yV3dYcdwPITEy0qk6YZuBNPeVoZMQPPHyqR
         duuDN7kQU1TexAErD3RSC5RNondDUynvD4wOSEuguf7TKpqA0aztc5ujRX1Gsu49ckqL
         9wiRFcKXmj5diOR/RPDXHdEPxOsSh5wPHdtBRMLeO6XMoZxPNZZXDT4V3DJgKoBYSu0k
         MYxIw8mXhFU0mqJ242ZcSj4lb0gF3wtR8z2Vq3Hr7MvZnfuegTcysxRYT6w3szIFDEtK
         cTT3TjNgArNeom6ky9IZEgBQT9xLVViIcBsdT8jHlKbHUYaKOu56gwpIEf4Me/m8nZF4
         Bz5g==
X-Gm-Message-State: AOAM53171kMsavk4dg+rSMn+D0C7J7UhfucF0jG9kx9Uj1dZzTbKoVrI
        mvk2o8EMfSuIT7Vos9kFxh8=
X-Google-Smtp-Source: ABdhPJy5yTz93FUNGLLhauLbLg/U3VyoKPjQdKlXTOxbzAOz3NCx2Or2RPqb/PtREHXqyz0tb2OwHw==
X-Received: by 2002:a17:90a:c081:: with SMTP id o1mr2727189pjs.24.1634603646785;
        Mon, 18 Oct 2021 17:34:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:85d3:2c8e:fcea:2b1e])
        by smtp.gmail.com with ESMTPSA id n22sm579675pjv.22.2021.10.18.17.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 17:34:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] net: sched: fixes after recent qdisc->running changes
Date:   Mon, 18 Oct 2021 17:34:00 -0700
Message-Id: <20211019003402.2110017-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

First patch fixes a plain bug in qdisc_run_begin().
Second patch removes a pair of atomic operations, increasing performance.

Eric Dumazet (2):
  net: sched: fix logic error in qdisc_run_begin()
  net: sched: remove one pair of atomic operations

 include/net/sch_generic.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

