Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59C8438CB
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbfFMPIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:08:38 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33588 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732585AbfFMPIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:08:21 -0400
Received: by mail-qt1-f195.google.com with SMTP id x2so22040577qtr.0;
        Thu, 13 Jun 2019 08:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZDnfRfLaB+GhguIpLqDKJ0r2BOY0L5ZqvT0vtIQUws=;
        b=FFIjYfDIbNt/f+AvqpOdChzf1Klyxb1vbw4NloHBTUIj6XN75XYA2RQSbzUH10Dr9J
         ZHLIgIITBH3N/+mgicLgoIw7MlEd4kFjeP7cjO4ZRVCJPZ4JDfChe8sR8ids7N66P9/T
         mPUdBkjk9abYpz/X16w33ijaVB+j/wcaROI2AwbgYMLztxyUPq9LZH0WvTIxjX/+kZeU
         E3kDxd7dFjKQIt81p+8BV7P5FDs3z1Xo6aMaks4MOhpTwXi4//o2a58e9yjFp0olE/cc
         VbqG6JvCou7ZwsVpBP3v13087blh9dANxGyZQlcNkRsdmQ4apm0ym2pO/bM9EBTqlpRM
         //fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZDnfRfLaB+GhguIpLqDKJ0r2BOY0L5ZqvT0vtIQUws=;
        b=ftokQkFCtBliJ6lIaMJo2BFvd5QIXXUj0m01071MGPDhy8sFwfCvDFGp9KSK0Y6hUo
         Zdx/SAfTpdUbq655DlUy3l3gJgTW8LjrRaY6Mj1cZEcvcsbx5psg5eHM/qAC6a0EZlXy
         rrTawTGSYGhB1wjvcqwKBAOhvBSjNudnrST/sCuPyJ2WgyIB8W/FedmhLBREQe1ozKfb
         qwBHr9nZmWmOAjhMhvUaVrNcrBwqvN8L6pt+tTKEqxJg74StsX1jR0gjc2F4+zdKyTDv
         Em9QPqdejDp+kDssFVf/gTt2Lqdd90x4JjN+y7/OExMtyyfA6PjnC499OKZlNrc+fMtM
         fKZg==
X-Gm-Message-State: APjAAAUp8Jb9+E9WZJKwjdTnKz5TuAnwnw3zIfT7XSfuJLnXAa8Pm61N
        preC5wv5UMV5LJ8AVu1CYwo=
X-Google-Smtp-Source: APXvYqy2smAFADzejBvh7EFS77OX1/J51MN3dPTqRKbzhkdTYmQa8GB60KJXLWScjVWMojPwjQHkxQ==
X-Received: by 2002:ad4:43e3:: with SMTP id f3mr4163862qvu.108.1560438499791;
        Thu, 13 Jun 2019 08:08:19 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id d188sm1641989qkf.40.2019.06.13.08.08.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 08:08:19 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     jakub.kicinski@netronome.com, peterz@infradead.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next 0/2] enable and use static_branch_deferred_inc
Date:   Thu, 13 Jun 2019 11:08:14 -0400
Message-Id: <20190613150816.83198-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

1. make static_branch_deferred_inc available if !CONFIG_JUMP_LABEL
2. convert the existing STATIC_KEY_DEFERRED_FALSE user to this api

Willem de Bruijn (2):
  locking/static_key: always define static_branch_deferred_inc
  tcp: use static_branch_deferred_inc for clean_acked_data_enabled

 include/linux/jump_label_ratelimit.h | 5 +++--
 net/ipv4/tcp_input.c                 | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

