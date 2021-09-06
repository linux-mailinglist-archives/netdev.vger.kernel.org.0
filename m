Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AF740187A
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 10:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbhIFI6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 04:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241205AbhIFI6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 04:58:11 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BB4C0613C1
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 01:57:06 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id m25-20020a7bcb99000000b002e751bcb5dbso4203161wmi.5
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 01:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0CBEDd2Ue4x3XbE6CiEO+NVZCM8IZzCbHsIttyxTIVg=;
        b=Pw4guzPG8Orgy4UJCZk9M4eF7nOSylmCUWGXSHjZScbI27GHyeV8HfROWAIpzSquQf
         tY8X4PEZopiLp24q0qBFw/lNBOttn+EeFUEFEhfd26ZPuWl45gq3Yve7sESrbA6CY7I2
         0JQLDYyKNh4lZ9fJDcA00F2y0CKydA/xvyY7s09iWbovlKHCKLff7ojQaDAsjYBu1v3t
         xOxm7tCUeh9tpYFqSq98vbHolPZyUPKxUOR7q2YnRX3BkLOPKHlCsDCa4Bs3WV5848ng
         lwjk3p8NBbdFzBvftTFapKG7TDEMwquddK2fShIC9LMcrtDh3gtq0ldfn+0GfOYwEa+x
         z2ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0CBEDd2Ue4x3XbE6CiEO+NVZCM8IZzCbHsIttyxTIVg=;
        b=XUDC70xKnymRh69wK6faOLyrmdHjDBIjK/n5prWgkqPLvjgzmKeD7szbd3aBo2PkZN
         1R1HOuDdq1Z7BT3W/dDfpj+WaYebed0P+wRGK3Ol0a4C0L+LeCCC0G4olYwcrOQ/g8Wm
         MJSyy4Gt8y6EUzcgR1yb6wWxGGDK6V3r1fxAPjt8kvM77EelZdLHY32g6qI1BnjL1KBv
         01iMGSKwFBs0rqeRqp5GpevnwNGE5+pgkpAYHe/pAzr3prctVHAUeJSXJ/2evoEG0IBK
         jBIwwnkCdEJSFqF2sE9hMS5ChYdIL6zRgJITHTmIvkW5FXdS44ktKydprYYh2z0H+/aa
         UigQ==
X-Gm-Message-State: AOAM5310PyjpRK4L7++cr9DHA9/iDkLI5xTfIQ27S0qQMyKkB+zhfIeX
        XtzJ5eZOEmfyXOs1gWpVX36ULjWuaEUX9z8=
X-Google-Smtp-Source: ABdhPJxoraaGmbjUY9A0rx8r/cK7ABF/14DNuocMaUhUYchzZVRDH2QNh4X8JJose35Syk8aFg54Vw==
X-Received: by 2002:a7b:c190:: with SMTP id y16mr10124397wmi.158.1630918624800;
        Mon, 06 Sep 2021 01:57:04 -0700 (PDT)
Received: from devaron.home ([2001:1620:5107:0:f22f:74ff:fe62:384a])
        by smtp.gmail.com with ESMTPSA id x9sm6523071wmi.30.2021.09.06.01.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 01:57:04 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ardb@kernel.org, jbaron@akamai.com, peterz@infradead.org,
        rostedt@goodmis.org, jpoimboe@redhat.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH net 0/2] bonding: Fix negative jump count reported by syzbot
Date:   Mon,  6 Sep 2021 10:56:36 +0200
Message-Id: <20210906085638.1027202-1-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes a negative jump count warning encountered by
syzbot [1] and extends the tests to cover nested bonding devices.

[1]: https://lore.kernel.org/lkml/0000000000000a9f3605cb1d2455@google.com/

Jussi Maki (2):
  bonding: Fix negative jump label count on nested bonding
  selftests/bpf: Extend XDP bonding tests with unwind and nesting

 drivers/net/bonding/bond_main.c               | 11 ++-
 .../selftests/bpf/prog_tests/xdp_bonding.c    | 74 ++++++++++++++++---
 2 files changed, 69 insertions(+), 16 deletions(-)

-- 
2.30.2

