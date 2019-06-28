Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFF35A312
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfF1SEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:04:04 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:40300 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfF1SEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:04:04 -0400
Received: by mail-pg1-f179.google.com with SMTP id w10so2923826pgj.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YEgU79Y1GwrNgNLlXk2hG8WaStkQRSW4AZcjIQxvBNM=;
        b=t3g7ExZYBY1s5HPiQvkoZ/+O8FC81HAdpys/Cs70iuDCNqhBLcnoFWf155860X15+R
         3y5E8ozh5HzLH6LSr4sYHd8mFR9b5rAoxF8Lch4dKEmUHLNSJeny6BMDbZ9s4uBrWzRx
         xDqKaGZ2n9XfiDWsQ48vzLLhpiw62YTdB4ZBxOdb1g1Jq4sAhfT1XThZRF/uDkWLeTFW
         WutA7QGuu4d6i4QUOeAivxqDaa81ASaxqFrYOZiWlPWpsXiOyFdLeoHY2K3EAtKfo+FH
         pJ9z5xQpjPjmzV4hlMX/LhC7K6gjUTtm44WbJmCoYH8/QolwAMFuc5ESz8xBB6amvUh8
         rGrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YEgU79Y1GwrNgNLlXk2hG8WaStkQRSW4AZcjIQxvBNM=;
        b=GzkVDpI10Ia2Bn9QeHQEbqiYfesFKgOU5kIpXNHB6BcvR4GLdUZl34Zsg/acOhf/lM
         Vva682JaouzmSnyg1RLvcawiNAAHx6bicfo7OZyXqY3IMCW0SPJVoOivWKFx+cFbCGU5
         /8WrJadknuW+A40Y/ALHGE4mxdGCv5SMSpTxpgQdA0vrW8AhVKI8RbT1MyQoanHEI30C
         csxojMM3zYBWnmhti7bWpK5FbOzWJyxd9J35LKTQjPzUZ7M/OS3INY2wiLRLzhg98CbP
         mt778IJqy9Y23DtuFHvV9Qrq1lB0Vmm+3vfON7Be0KooqW5uOlI5r5nPJA94PbqKE/zm
         Ushg==
X-Gm-Message-State: APjAAAVb2hQdGR9pd9NEWBM/7f58CEPp/chPwzY4FWM7YC/oINKXI7OE
        FFjkrJjmUIo4HHcXXrbU7I8sirOfLGE=
X-Google-Smtp-Source: APXvYqzX3p5eVzazP9QoExdee8K6uWMb4eTStxUhHq3+0gmnUkYJjXXOe5nGz3k3AyWhvk00UudM3Q==
X-Received: by 2002:a17:90a:bc42:: with SMTP id t2mr14686101pjv.121.1561745043902;
        Fri, 28 Jun 2019 11:04:03 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d6sm2175919pgv.4.2019.06.28.11.04.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:04:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, chrism@mellanox.com, willy@infradead.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net 0/3] idr: fix overflow cases on 32-bit CPU
Date:   Fri, 28 Jun 2019 11:03:40 -0700
Message-Id: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

idr_get_next_ul() is problematic by design, it can't handle
the following overflow case well on 32-bit CPU:

u32 id = UINT_MAX;
idr_alloc_u32(&id);
while (idr_get_next_ul(&id) != NULL)
 id++;

when 'id' overflows and becomes 0 after UINT_MAX, the loop
goes infinite.

Fix this by eliminating external users of idr_get_next_ul()
and migrating them to idr_for_each_entry_continue_ul(). And
add an additional parameter for these iteration macros to detect
overflow properly.

Please merge this through networking tree, as all the users
are in networking subsystem.

Cong Wang (2):
  idr: fix overflow case for idr_for_each_entry_ul()
  idr: introduce idr_for_each_entry_continue_ul()

Davide Caratti (1):
  selftests: add a test case for cls_lower handle overflow

---
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 10 ++++---
 include/linux/idr.h                           | 21 +++++++++++++--
 net/sched/act_api.c                           |  9 ++++---
 net/sched/cls_flower.c                        | 27 +++++--------------
 .../tc-testing/tc-tests/filters/tests.json    | 19 +++++++++++++
 5 files changed, 57 insertions(+), 29 deletions(-)

-- 
2.21.0

