Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4E37F690
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392524AbfHBMKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:10:42 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38878 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388969AbfHBMKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:10:41 -0400
Received: by mail-pg1-f195.google.com with SMTP id f5so27165402pgu.5;
        Fri, 02 Aug 2019 05:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=byjiNq9HtMcT98CUosHBBSmbXQTSvoTkbqa7rLBdSEY=;
        b=vZ1r17FMnkBg6TQJeK3FPgfRalxF6pjwpN2HDnLQaZdTdIaw1fDZpdu1SsmX6HulAR
         UDyLa51RZM77/lN8xZ4T03ImABpzGWvAuQYKDQrZ7cqZj85MjpU13QIKky9DI23ov9h4
         //EpBTCu5n5lUiI+DU3qYlaXCZLJf4qON1E4gUQgXs7ShcR/Qteq0UdsayYauo1WwPow
         H23sg9qdFn4ksqSI+dl6H9HHMtUHRFgpxTRqFHYF7M30azerWksy0/NGdFqsCG3WGFbA
         0EiZZCboqJiOLVY1idtdGLPicOz90MJ4vxW6M/MJwFX4nEBgdMXLktXBx2v7pnAYl6Or
         ukcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=byjiNq9HtMcT98CUosHBBSmbXQTSvoTkbqa7rLBdSEY=;
        b=MPPH1q7IxUceJkwkSBj6k2pjxu0Ooa0bIo3dV8Z96O9zB1bEj/O+WIQGWc5JAMmVcS
         FZklJ6+eQpQqLOygfNyrF7vxvWrLRb0+fSTynYZXAka/paxgynMJMuZbfTunhonB2vih
         eXsjQuaBZaeTJZbFiH07R/Cv1xGSQ1Ohux20kl3JaJFbrQod6TXxlT7lA77tHIJ16qqi
         2yd/DeiN9xt/aEXmFqSMyx80rMRbRVJFoqpPhnxXO3aBOzR2Ng7ilaD0OlvbRMab9jHs
         47L5X+IeAPbvXGLU4wG8TcxQSU3MtMlOteUQGSK+SbtPd4Thq6me50xMQSW0zHQS3KYH
         cbGw==
X-Gm-Message-State: APjAAAWy9JH8lUTt+fo9NxbNVZV7DvO5TpTk4SdZ31J7iNUD/m07563j
        LK/1UKTOMjePa7C4S+JFdzY=
X-Google-Smtp-Source: APXvYqyIz77r32l6lZeGFjpjjHZlgC5V5xylcFOfkb9tIaJGHh9MrFB1VSgzgP+AC/sS0WSTmADKPw==
X-Received: by 2002:a62:ac11:: with SMTP id v17mr59470346pfe.236.1564747840855;
        Fri, 02 Aug 2019 05:10:40 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id g62sm8243541pje.11.2019.08.02.05.10.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:10:40 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH 0/3] Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 20:10:35 +0800
Message-Id: <20190802121035.1315-1-hslester96@gmail.com>
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

Chuhong Yuan (3):
  mlx5: Use refcount_t for refcount
  net/mlx5: Use refcount_() APIs
  IB/mlx5: Use refcount_() APIs

 drivers/infiniband/hw/mlx5/srq_cmd.c         | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/qp.c | 6 +++---
 include/linux/mlx5/driver.h                  | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.20.1

