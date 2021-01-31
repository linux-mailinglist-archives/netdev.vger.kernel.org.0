Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9AC309B03
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhAaHzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhAaHzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:55:15 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45852C061573
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:54:35 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id m6so9443056pfk.1
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 23:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kgKKLqQW2xwwboCbHSHJTnsaD6K/pF+foLG6aE5xNZI=;
        b=oDxn1at6cBgrCy+et5aUyF+io1XklVS/57elmEIaWxBM1/ibd5bKHiTn9mmLsiOLQX
         UMZ7lZVEACJhjhmM+01y4TQMeqMYsjTOL7FgY5WfwpdwZwvUUhnRN7t0DRVfXBFuBvcx
         O+QMbM6WrA3qtbuMszSP2LOVVVjF7sxv0XcyvRbW384Hxlw7mM2+7dtVleMpwAxL3V64
         HfWPZDfg63jwjcUmmtjk6VBQGc1YJgQoC91eHChzczcqmgM6tT+uYOenP+oE6bULR6YH
         52fWaiJqBNwEahiWccb6RZbV+iDQp1HGsBGcZ8KtNtqz8UBkUgc1Oo2Y7P8OVYD7jlGL
         GZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kgKKLqQW2xwwboCbHSHJTnsaD6K/pF+foLG6aE5xNZI=;
        b=l1SCfzK+aZPUSoTogiut8ln/aZa5Ub1xfm8rEFnCQg9SyZOEFOLk3MU1XIH2Aupb+W
         DILVWM8HOFc8YlAE+DMt3NtkiiFXt3WVqnvGfQa+wm3BwJlDSuRKnEZN/W8e3NScR3Yr
         j+4FQs3lhQukH3b9qVVgDFCltSeMZJ/Z8ACLPyZcl5yEk+6nbvXbaeR9HlCaiHqN/HBp
         TNhlm5R1OtRMjK3d2q0QBDAgoNrv4BlgvvACm76Q+jsY8BDyM88+hNou6U2eLfrBsPz6
         lsstvjZbnXOHBoFjgX0OM6brheuQPNyifeNOcc4LFEH1MdiUuKC5xBLJ/D3wk+I77kMq
         Fadg==
X-Gm-Message-State: AOAM533Xb6RPSzDS9UIdPs0M+GzA8eQreAkvepJs58+pj5SdLLk2TKkH
        wCLROsjLBdmf08T21KN+4Hw=
X-Google-Smtp-Source: ABdhPJwYDoHasKHUwogN7dtZKrVQKPFUWaRliX1zNTwlp5yslrIgooO/VbUgGjJJC7zm76ncO3r/uw==
X-Received: by 2002:a63:700c:: with SMTP id l12mr11763069pgc.137.1612079674628;
        Sat, 30 Jan 2021 23:54:34 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id h23sm13931290pgh.64.2021.01.30.23.54.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 30 Jan 2021 23:54:33 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH net-next v2 0/4] net: Avoid the memory waste in some Ethernet drivers
Date:   Sun, 31 Jan 2021 15:44:22 +0800
Message-Id: <20210131074426.44154-1-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

v2:
  - Inline page_frag_alloc() and {netdev,napi}_alloc_frag()
  - Adopt Vlastimil's suggestion and add his Acked-by

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

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  3 +--
 .../marvell/octeontx2/nic/otx2_common.c       |  3 +--
 include/linux/gfp.h                           | 12 +++++++--
 include/linux/skbuff.h                        | 22 ++++++++++++++--
 mm/page_alloc.c                               |  8 +++---
 net/core/skbuff.c                             | 25 +++++++------------
 6 files changed, 46 insertions(+), 27 deletions(-)

-- 
2.29.2

