Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A48B47DC4F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 01:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238129AbhLWAqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 19:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhLWAqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 19:46:00 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8BFC061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 16:46:00 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e131-20020a25d389000000b005fb5e6eb757so7040876ybf.22
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 16:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=uxpsulq9S2Sfdu0djE+Z1QblFTtKLssdcKMSWFWjQTc=;
        b=hs0LZHXvQszPfdXv4fhD650v5KYGxDI5G3DZh8l3x1ooqvmENgL+LkZNNlyEa3ffA3
         F7MdBGxWmGR9tgZUcAAbJQfvOmW/1FHHSn7j0S7HbxVmJn0JHXZugz/WqQ+Kz90/lrdb
         ZfpWtVvz+h9PnircIABQCU9smds7AipJ3sz3vcYEtwxPO7m2Dh77N+8u9o6fYVXoi+7o
         wFIVI7fhaPtreZT4cQ9a62TdRUlkBbW4ACrMZFXFqIRqPb9LrhSHzP1VB56im5K2z8QH
         Vw+8EYgPW8hnW0rmjyxyld8h69ns1Qh1tZEiBfpQPMq8+m1qmWw2Uq5YFqHOQ106sy2T
         oRCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=uxpsulq9S2Sfdu0djE+Z1QblFTtKLssdcKMSWFWjQTc=;
        b=hmXBJUWbt33oEhFKHNNekqfC18tp/K1pOTq1snHgoNDFwUvg5x09de29G04Pee8m3o
         f5W/yusD7oDHyVpa8bkPr/pPCwUG7wuMgRxjNtJebE8FRWzYXqnMPZWpoHoNVxuvoxos
         0thXT6ykM1cCP7x/s2GsA1dVjug2aYMwbXAIAMKwVceqBYP8t2g3XV3H7RfoMKiI9qdO
         uq8gSfo0J7oGU7hP0O2gU0Bo3OM2inLGg55dzorueDk2y+7z2zkDW50D5G8GJ2C3RCS+
         Pg1it7F3egihTfmv9ei/6AmRErf985APUSXCZ6Ve0rG0/Ykmxy7pm85TWMhy7ImzlwuG
         KagA==
X-Gm-Message-State: AOAM532Rb36FSAlOP+J1/AP/n45bOOvCsv4fzxx7NgJecaQ29hhQCaDt
        dWLo7zRCAxQWHb7riFcKh14LtwzBKSPGNw==
X-Google-Smtp-Source: ABdhPJw9p/Nxf21UOOH5JeLcy/YJRGVp0zpckYd2I5r84WzMJ6Mmop3cTaEAPtEwakdWW1ryeIY/jhBcEO+/FQ==
X-Received: from evitayan.mtv.corp.google.com ([2620:0:1000:5711:78f5:9c84:70bc:be20])
 (user=evitayan job=sendgmr) by 2002:a05:6902:72c:: with SMTP id
 l12mr248386ybt.89.1640220359499; Wed, 22 Dec 2021 16:45:59 -0800 (PST)
Date:   Wed, 22 Dec 2021 16:45:53 -0800
Message-Id: <20211223004555.1284666-1-evitayan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.307.g9b7440fafd-goog
Subject: [PATCH v1 0/2] Fix issues in xfrm_migrate
From:   Yan Yan <evitayan@google.com>
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, nharold@google.com,
        benedictwong@google.com, maze@google.com, lorenzo@google.com,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series include two patches to fix two issues in xfrm_migrate.

PATCH 1/2 enables distinguishing SAs and SPs based on if_id during the
xfrm_migrate flow. It fixes the problem that when there are multiple
existing SPs with the same direction, the same xfrm_selector and
different endpoint addresses, xfrm_migrate might fail.

PATCH 2/2 enables xfrm_migrate to handle address family change by
breaking the original xfrm_state_clone method into two steps so as to
update the props.family before running xfrm_init_state.

Yan Yan (2):
  xfrm: Check if_id in xfrm_migrate
  xfrm: Fix xfrm migrate issues when address family changes

 include/net/xfrm.h     |  5 +++--
 net/xfrm/xfrm_policy.c | 14 ++++++++------
 net/xfrm/xfrm_state.c  | 38 +++++++++++++++++++++++++++-----------
 net/xfrm/xfrm_user.c   |  6 +++++-
 4 files changed, 43 insertions(+), 20 deletions(-)

-- 
2.34.1.307.g9b7440fafd-goog

