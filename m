Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130973D6809
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhGZTjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhGZTjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:39:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE046C061760
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:19:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 16-20020a250b100000b029055791ebe1e6so15547661ybl.20
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GsN8HCqVh5N8aSJwsQzyNpefHB2pESiItXifSlAmSSM=;
        b=gJdCKTbk2C37vKwDcBCzX6vy3NgrJaCdDO8ylX4jL5Efkl2THEgpciZ+Gfqpi1pNu+
         uz26sJGw6z1vPs7dtWhk3sYsIs7+y9MTiHK5v5yI865S++oSd16Nctp8n7nUT3Zj8zzi
         6QLaLHEEcBGQrCRMx7m+rBZ3I//g9e+H6PPfSwhHOcYcQS9yh5jeI/vbv5ydjBavNrJj
         YRem8g5HR3BObvLbZY4p2i6KNKemqng7M1oG5CxGQFLuez26dnrjalCM9GaZH58s/TzH
         7JwmhrgZ00ztjpGMEkzhVpegunGGT7RAb+M41Lv048GixgOjdctrvQDap6++zAdAeABt
         zxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GsN8HCqVh5N8aSJwsQzyNpefHB2pESiItXifSlAmSSM=;
        b=i/6/DQyTX8xIH9UksIKNQ02iu+F+mZwqtz29Zo7rd4Uk2/ByijauH1lw+8pYxEtVKc
         G+Pjdh2Xb09hOhcjsN4fJJobAd97ipgT9pgr07D+2Uu356RziGNJepznI03mfzSYj9zP
         pCYIQ1e8RaYXE+A57mJR3zCNSHwDfMkKtLi5mnLhpVrsl/AMLiFA2YF20IyaWJywb4MQ
         1fqPJaJMeF482JQqEfF3t84TeuA4IUWfyL7J1oyXna/w/yiZKrWMdxX8RCAlSRhKOKwI
         s3uFFrP3CFtOQlyPn6ZUjpe+c0aOYbOWSztVMnO683lVpBMK6x0nlSEwmUK+zfGRDEKA
         0oAA==
X-Gm-Message-State: AOAM531WBm+/x2NxUpp/xILZFFNjJJPgubnD6jyTGSuoJlT9/+NBw1NQ
        KlMYZRXR36VvkbiD1v9jb0D80dPj
X-Google-Smtp-Source: ABdhPJyOQYwh3EiuCdUYc7I7SF9y2w6LHgoEfYxWl8nVzf1ebeI5lLJPSEbw4ycEaE0y5KP0ZO54TwepYg==
X-Received: from fawn.svl.corp.google.com ([2620:15c:2cd:202:ccf7:db54:b9d7:814f])
 (user=morbo job=sendgmr) by 2002:a25:ba10:: with SMTP id t16mr26601022ybg.87.1627330767966;
 Mon, 26 Jul 2021 13:19:27 -0700 (PDT)
Date:   Mon, 26 Jul 2021 13:19:21 -0700
In-Reply-To: <20210714091747.2814370-1-morbo@google.com>
Message-Id: <20210726201924.3202278-1-morbo@google.com>
Mime-Version: 1.0
References: <20210714091747.2814370-1-morbo@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 0/3] Fix clang -Wunused-but-set-variable warnings
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

Changes for v2:
- Mark "no_warn" as "__maybe_unused" to avoid separate warning.

Bill Wendling (3):
  base: mark 'no_warn' as unused
  bnx2x: remove unused variable 'cur_data_offset'
  scsi: qla2xxx: remove unused variable 'status'

 drivers/base/module.c                             | 2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 6 ------
 drivers/scsi/qla2xxx/qla_nx.c                     | 2 --
 3 files changed, 1 insertion(+), 9 deletions(-)

-- 
2.32.0.432.gabb21c7263-goog

