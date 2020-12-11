Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F42D2D6C58
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392761AbgLKAHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388177AbgLKAHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:07:39 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324B2C0613CF;
        Thu, 10 Dec 2020 16:06:59 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id y24so6698160otk.3;
        Thu, 10 Dec 2020 16:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZqUQTtozg4YHyEnLyrKyS7i7rvQiTl7B+fxYeP9gZnQ=;
        b=kwMZ7hQY7710N8huw13GB0estbPLsxihhIuOFscc2pdg7SKColgOxpzKp/oIA4zCbY
         TtYKNimlbYYO4f1QtfA5Hltn4hbFqI8/nhPBCptH5psqODjByvB/qic56pzPeBn9BIC4
         aObXjjV7BTD7zBVaRZlA9BSZKcO0/qXYSNl0UYcCpe5Knv7sDhE1z8N19hhRmTTiIbOX
         TlpOF18an6XZLMBTuUnV4ar5SR3dIEvG+SjkdaIgRHZCLo2enWG9f/XewjTmuFx28kOy
         uZhoWOQhXcsZxbm0xRzTYH1xmFOZyS1iApg9+Y5QF4JDH3EhmFgdmE7IPeJVOD7DD1JZ
         o5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZqUQTtozg4YHyEnLyrKyS7i7rvQiTl7B+fxYeP9gZnQ=;
        b=BCK3/lt3CUNfyu8NV2pLxy4P+GZ0zjm4Rzaii4CaHT3tVPh1BXzEmAhnjybSFlQTsQ
         2LPfOC9unRugPYYYtH5mILE0tAIg1gmPV6krKvCY3vrXt9uVNGqN0J6ltQnL2ojLdtAZ
         7HPR1cLi72uveOp+0L1TtwG7y127/R9GJUBQgP+ME79P4+koyYAYhZ8tTzfTumYy0BeL
         zznstAvV3GW4QxI7bYejJmFARy3uhYylG5nIHP4SEdErRSgyzIEUVpC1WfqUtQ9fsMz/
         eSPKXzQP+4BIt+uGAyPgAoWDIsGHp2g5m3Wjuc7vl6pXuxPxeEmQJ8Z7glDgt3axAraJ
         Wnsg==
X-Gm-Message-State: AOAM531IpPdX4l4Vua7XBwA5mxgRv1/8Lvkg+QIFuogFa48IfkU3o71V
        SmDElQaLugSH4l8EilRKy0OgLVSr8CTCIg==
X-Google-Smtp-Source: ABdhPJzeYLv7PqZXPl8NJ3hrNZWAqyTsc3ciJID8KDb3tMccT+ZqkgdAxGuONwDxsuzsLpvlsxeuOw==
X-Received: by 2002:a9d:a78:: with SMTP id 111mr7819000otg.94.1607645218151;
        Thu, 10 Dec 2020 16:06:58 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4819:cc94:4d6e:dad2])
        by smtp.gmail.com with ESMTPSA id l21sm1543570otd.0.2020.12.10.16.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 16:06:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next 0/3] bpf: introduce timeout map
Date:   Thu, 10 Dec 2020 16:06:46 -0800
Message-Id: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset introduces a new bpf hash map which has timeout.
Patch 1 is a preparation, patch 2 is the implementation of timeout
map, patch 3 contains a test case for timeout map. Please check each
patch description for more details.

---
Cong Wang (3):
  bpf: use index instead of hash for map_locked[]
  bpf: introduce timeout map
  tools: add a test case for bpf timeout map

 include/linux/bpf_types.h               |   1 +
 include/uapi/linux/bpf.h                |   3 +-
 kernel/bpf/hashtab.c                    | 296 +++++++++++++++++++++---
 kernel/bpf/syscall.c                    |   3 +-
 tools/include/uapi/linux/bpf.h          |   1 +
 tools/testing/selftests/bpf/test_maps.c |  41 ++++
 6 files changed, 314 insertions(+), 31 deletions(-)

-- 
2.25.1

