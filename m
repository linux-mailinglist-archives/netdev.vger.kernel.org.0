Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5BB3014FC
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 13:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbhAWMHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 07:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbhAWMHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 07:07:48 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F956C0613D6
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:08 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id n10so5666352pgl.10
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8k1KHoH0YhPvCcTbGm/5f5sbqN3l0Z/PQN8GHopI/8=;
        b=eDkSZDQSsO6z75cYJTunjWARRgT5cHwN256bP9iYygg0sqlCehuJ3AVY5PxOlrdJ6b
         btjD3gjlXcPrrnS2EV/Q8nNHhrEogRtViVAEs3lv6kyMYF5tzO/2obT/ykwzn4LCOZ8m
         qJAS/n3ikhjAHuv4RRosCllbLuD4v0SujACYZAfuRqmRje1tmoqOQozueTtXUv579LNt
         1hEpWF5RyAO0JLCW5xUHmnjFxpG2QELZ1RTwVRE7d7becrcY7HqdX3hCt2n9rp+NuWFB
         eV4yK7xLNp7KaRGLIy2XtcawTUcZu3+7wYKOuozwbTSUtNwfAYevqcPGcL/KTLZtTru4
         Efhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m8k1KHoH0YhPvCcTbGm/5f5sbqN3l0Z/PQN8GHopI/8=;
        b=LFX8UCg/LiIOVNoVtn9L+Ic0hFh/Le2q+QpHyyOXKRq1Gx+R9fOPOhIRJvCpIEcICN
         gsvhin5IVCZ5NjOf9H8gVxu4DbuGwoxfLMKn3/cXZ8DB3Ub6v5b2jDDz740FbozS89eu
         iNA9sdHG/9XtsUjCIW3VE7lzcHv8NYwy70xUsoru29mZDWT5GNHRYtyOB248q93oOAHS
         aLNjxKFy6IQXILamV/MEWRUzHl5tYmfaPvGBSTsSpyVQS5PtsAnrhDLkD+ZgAuBlAV3a
         5gN5tsU9xls+D9g/FPqBMjh6j7IvP0HQe/ngGId4Ms1phgP0qEM45IlXluo/IjA/0f2t
         PLog==
X-Gm-Message-State: AOAM530TZ2w1ADChSlKyjRDnvoA9ukZcQl7lS+RYGIUSq/ItJJ/3xOaW
        mrqy9G2hHwxqV7BZ12w1Ig8=
X-Google-Smtp-Source: ABdhPJxl4ANqGRQRCS6Sc69xwNHDsYwadoJtwhSBwjiKKt/A6ZcLfYJA1dkn0WNL8uO2gwvLUfVXyQ==
X-Received: by 2002:a63:9811:: with SMTP id q17mr9507956pgd.238.1611403627658;
        Sat, 23 Jan 2021 04:07:07 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id v9sm11471079pff.102.2021.01.23.04.07.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 04:07:05 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH net-next 0/4] net: Avoid the memory waste in some Ethernet drivers
Date:   Sat, 23 Jan 2021 19:58:59 +0800
Message-Id: <20210123115903.31302-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In the current implementation of napi_alloc_frag(), it doesn't have any
align guarantee for the returned buffer address. We would have to use
some ugly workarounds to make sure that we can get a align buffer
address for some Ethernet drivers. This patch series tries to introduce
some helper functions to make sure that an align buffer is returned.
Then we can drop the ugly workarounds and avoid the unnecessary memory
waste.

Kevin Hao (4):
  mm: page_frag: Introduce page_frag_alloc_align()
  net: Introduce {netdev,napi}_alloc_frag_align()
  net: octeontx2: Use napi_alloc_frag_align() to avoid the memory waste
  net: dpaa2: Use napi_alloc_frag_align() to avoid the memory waste

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  3 +-
 include/linux/gfp.h                           |  3 ++
 include/linux/skbuff.h                        |  2 +
 mm/page_alloc.c                               | 12 +++++-
 net/core/skbuff.c                             | 40 ++++++++++++-------
 6 files changed, 43 insertions(+), 20 deletions(-)

-- 
2.29.2

