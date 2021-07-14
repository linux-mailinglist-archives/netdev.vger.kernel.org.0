Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42103C8149
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238624AbhGNJUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238489AbhGNJUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 05:20:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43F19C061760
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:17:58 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z39-20020a25ada70000b029056092741626so1725785ybi.19
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 02:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=wlrejQF48WL4uSnd99LoOFS/aI1Cbh+kk7n1cuLb8Cw=;
        b=P1U+2qmKrZFPH1F205C0/YpTnPSOtrtZBISVrVuEwKIgIwSqtTHUeBOxhmFB/MvPem
         2cLbH//lBQbItf6/Yc3FkRmungVvfG2zSsBaUwKDE/P5z4CjvB7jWDetnL+2r9KzMUpi
         gIbMOZMlPnGP5E9kj/cEmpbjW9wnXRnCakZzq6OaxHE7giuBuEMO2O54imLNby/x/Nsp
         IE/Ktf90LufxxRvIiKvriv4sSdGNeXul5YdCxx2YJF0bfpJOYOhZIHbjzQAsMkbNOvRp
         4jz/2/2oT3h6NQysEUnSd2ysPyr0MMSn/tdotxY0VoZTkoQ6It9txcbkrvge+5gddc90
         3BUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=wlrejQF48WL4uSnd99LoOFS/aI1Cbh+kk7n1cuLb8Cw=;
        b=Clh4mNg6YSQ7Xbvnr2BM+/Xp8DqQuWTw0auAtkFCOZ6RH7zQxxVpF5evTbe+c8N1D8
         3+oOZTxb/Vtb+oLaC6QeMZo8aKrqIn8caHgTnePH4nzyk29civoiFR1qmzTwYpWPgipS
         yOcIwMoABMsQPLHpki7sGem0Q2ppSIVQfzot4CNmLF6MHtZiACNQ9EyVcdTpegEATgGF
         BuCMGtQ3JfCjbhmyTuleAs71Y6GoNvpKhMGjjOmVx0TuRBIDPBppcufA822RAIu5bIb/
         /XpAIRUBU2cYqr6Afm9p+QVCo1sp3PJajVBpt6lawbE4uYAEGGle7xzwxwvZUSO04qev
         VLBA==
X-Gm-Message-State: AOAM533yilwgOLKZlYbB8V7fY6zaRuk00KwNXUPiYQaEKpbwdKFh2JGi
        AzMDKBcMUEFGJSIvzZVUelLpKHDi
X-Google-Smtp-Source: ABdhPJzvZoBrVMLmKVofazWugPLVIdobBxAIACgaacdGRcC6DEb+OIp6+hpvaCQiE14wFI8hFJkY3Qjipw==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:c569:463c:c488:ac2])
 (user=morbo job=sendgmr) by 2002:a25:764b:: with SMTP id r72mr12013800ybc.254.1626254277400;
 Wed, 14 Jul 2021 02:17:57 -0700 (PDT)
Date:   Wed, 14 Jul 2021 02:17:44 -0700
Message-Id: <20210714091747.2814370-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH 0/3] Fix clang -Wunused-but-set-variable warnings
From:   Bill Wendling <morbo@google.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches clean up warnings from clang's '-Wunused-but-set-variable' flag.

Bill Wendling (3):
  base: remove unused variable 'no_warn'
  bnx2x: remove unused variable 'cur_data_offset'
  scsi: qla2xxx: remove unused variable 'status'

 drivers/base/module.c                             | 6 ++----
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 6 ------
 drivers/scsi/qla2xxx/qla_nx.c                     | 2 --
 3 files changed, 2 insertions(+), 12 deletions(-)

-- 
2.32.0.93.g670b81a890-goog

