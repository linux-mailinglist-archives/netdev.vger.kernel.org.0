Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6467FF7C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 19:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404725AbfHBRXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 13:23:41 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37893 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404689AbfHBRXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 13:23:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so36373607pfn.5;
        Fri, 02 Aug 2019 10:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zxlybz2DrAreBUG46vUr4Lh24574pktraowLMiv39Vk=;
        b=EzOBANlqiE9wIDomd0Wm6GYWf81TArMo+XXrHAYM6K0xDbXsyOE6DpM7xLb5e7jdCI
         dlZVBdW5e9NyrMDwDjaSV95zLmtEl2pNWZP47mGuglFmLnuczyePjXYWeEuuqCYbDrm4
         EJYLVYbDBdbXHebepSP0fRL899Qst/7KK/c7UAuAK53/lKHDYPjk8gJrQOyBtz+TzTDp
         oQ7Zi5q4XmKJjRMMMgVwKxg0i9yAnkB75hVUZ/6XeL3QjgF2IkqJcylOw31zf0G8Ql9B
         5CWKA1WcSBJH/iCJ+B4Wfv5ldiZx0KGVAry29mIOnF+u9bNY6RNCKzv2YY/0Zz+bBMYn
         5h+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zxlybz2DrAreBUG46vUr4Lh24574pktraowLMiv39Vk=;
        b=CzdlLpB+yxZKQR5NsIKNaUNFvlTzdng2lheMH87RlesK575sbENR2Ssxx1KhssDSZe
         HDnAty3H0/rhGyNQ7gdbPHXI0xFTKrAkns1OR+7bO6bJCzz4RU1n2XnfnAzRT2empWbi
         2htCKgRZZ8pY6EbTJE06V0K4HehBFexzu1RirsZI0rIIgEIGKt3hJBCG1+JTM191YW4W
         r8rsQXbUdWHyeeGABsveelaWUBaSIaaOgu6F2Vs32o2mb6IF5hXLORVUzMCev0iaAttI
         9xTCc9mECZEmtgw1csobFCvaoyf4wuNT5+LU1NSTnd8Zl9f7Hm4CzeSpzXdMJRFWi/yg
         Q5HQ==
X-Gm-Message-State: APjAAAUoU6nxyyTjza2fTjAe6+hvxmkno45xGLtcW6QrlxvlnQKW4M09
        6sVqwOpN7YhRRKH+LGO2o1g=
X-Google-Smtp-Source: APXvYqw13dES9lzIEcWjOG+GswfpW0q2APkhUIHrK/JITeFz+RqNqv752GKeiLFUuHtThquBlSXDnw==
X-Received: by 2002:a62:e710:: with SMTP id s16mr62645808pfh.183.1564766620741;
        Fri, 02 Aug 2019 10:23:40 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id y23sm77760479pfo.106.2019.08.02.10.23.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:23:39 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH v2 0/3] Use refcount_t for refcount
Date:   Sat,  3 Aug 2019 01:23:34 +0800
Message-Id: <20190802172334.8305-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reference counters are preferred to use refcount_t instead of
atomic_t.
This is because the implementation of refcount_t can prevent
overflows and detect possible use-after-free.

First convert the refcount field to refcount_t in mlx5/driver.h.
Then convert the uses to refcount_() APIs.

Changelog:

v1 -> v2:
  - Add #include in include/linux/mlx5/driver.h.

Chuhong Yuan (3):
  mlx5: Use refcount_t for refcount
  net/mlx5: Use refcount_() APIs
  IB/mlx5: Use refcount_() APIs

 drivers/infiniband/hw/mlx5/srq_cmd.c         | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 6 +++---
 include/linux/mlx5/driver.h                  | 3 ++-
 3 files changed, 8 insertions(+), 7 deletions(-)

-- 
2.20.1

