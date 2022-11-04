Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9F66619E11
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiKDRFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiKDRFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:05:14 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC5D2F667
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:05:14 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id l127so5787594oia.8
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h89AUemzSCYMhqZav+il0k7Id8aRfBCJxs4FCAAetkM=;
        b=LMMuHiORKL0EH9FbTrH0DaMmHrO6Gsd4ZcJ9Z/PxvG/4suSnrjypRUzjelzaHTab41
         wSM282WiRsPHUIyrS0u19sFA7buTprLcjeWgKCKWHwc8j/1RxVLtnn9xIVRVN22wY5Zp
         0q9jT5rNyy+zcYbV6BeM7eq3CeJ81KkDORwohK0EdtSpCiiLe/JW+22Iwvu4kwUFuPZN
         7uUnrzQsz993GYOqt1Ar89CzpNPvv3j/FDIS4DiQ4C5z4Ugym+KqboPxaS/t3JMweeOY
         XIEFtUAkShyqryRXzze/xnpt8ivO1pBbwSHvIHTuEJy6PKM5bonJ02kT32M4ERqVLqzT
         tcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h89AUemzSCYMhqZav+il0k7Id8aRfBCJxs4FCAAetkM=;
        b=Bs4ef5EusLtmrJTSPT6yucL3TIsPJAM9vzltUpDS87jgkoOHJFazs5z0mvoveq9Zd3
         lbSgl47DIa3ZPyONbAYuw6AWsPsl/WMkVDfEGMgMONqwtqKObNm/ghslMXi+nivU/STl
         nLWeiInKLciIBykKNXKWhnQwT+zAeu+8yNMMgpbutyU3+37n2yDnvCacdH1PZQb4ciLW
         so+szYtirFKt4DAychn1qH9LlqQpLTwkGva5M3V4WoH+QxbwGYZL9OyaQbAhxhU7ziWk
         B6nF2Y0fc/16V4TMG3AVzPRdwsiHval0xxqCapKR3pfd+Q3mvhX007ynilijYtiXWX4d
         W8Ag==
X-Gm-Message-State: ACrzQf0sYeQNx4c5fqCZZddQk+TN9ivhQsKDrU+giSSd8Ms+FrbWYuVZ
        w9+a2HYJC/Wo0aaWaAWNaIFACpsNxR2no5CNLCzpKQ==
X-Google-Smtp-Source: AMsMyM7025hzYpInMhVBKGyfqBI84Cj7yVkV+huDC6jRu1A3hauRIqJkF9nHohRbPdggUmWxsQ6C0gLd+elB0+YUvU4=
X-Received: by 2002:a05:6808:1184:b0:350:f681:8c9a with SMTP id
 j4-20020a056808118400b00350f6818c9amr20026719oil.282.1667581513081; Fri, 04
 Nov 2022 10:05:13 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20221103181845epcas2p2d3e49699d634440046fc8a9deb9785be@epcms2p2>
 <20221103181836.766399-1-dvyukov@google.com> <20221104005917epcms2p228981fa87d326a8d4f503911f3472703@epcms2p2>
In-Reply-To: <20221104005917epcms2p228981fa87d326a8d4f503911f3472703@epcms2p2>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 4 Nov 2022 10:05:02 -0700
Message-ID: <CACT4Y+aWkj+0+1k9pPjUOH0BOB+RNsUensFhCEJ2Nquen2J9jA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] nfc: Allow to create multiple virtual nci devices
To:     bongsu.jeon@samsung.com
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Nov 2022 at 17:59, Bongsu Jeon <bongsu.jeon@samsung.com> wrote:
> On Fri, Nov 4, 2022 at 3:19 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> >
> >The current virtual nci driver is great for testing and fuzzing.
> >But it allows to create at most one "global" device which does not allow
> >to run parallel tests and harms fuzzing isolation and reproducibility.
> >Restructure the driver to allow creation of multiple independent devices.
> >This should be backwards compatible for existing tests.
> >
> >Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> >Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> >Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> >Cc: netdev@vger.kernel.org
> >
> >---
> >Changes in v2:
> > - check return value of skb_clone()
> > - rebase onto currnet net-next
> >---
> > drivers/nfc/virtual_ncidev.c | 146 +++++++++++++++++------------------
> > 1 file changed, 70 insertions(+), 76 deletions(-)
> >
> >diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> >index 85c06dbb2c449..48d6d09e2f6fd 100644
> >--- a/drivers/nfc/virtual_ncidev.c
> >+++ b/drivers/nfc/virtual_ncidev.c
> >@@ -13,12 +13,6 @@
>
> <...>
>
> > static int virtual_ncidev_open(struct inode *inode, struct file *file)
> > {
> >       int ret = 0;
> >+      struct virtual_nci_dev *vdev;
> >
> >-      mutex_lock(&nci_mutex);
> >-      if (state != virtual_ncidev_disabled) {
> >-              mutex_unlock(&nci_mutex);
> >-              return -EBUSY;
> >-      }
> >-
> >-      ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
> >-                                 0, 0);
> >-      if (!ndev) {
> >-              mutex_unlock(&nci_mutex);
> >+      vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> >+      if (!vdev)
> >+              return -ENOMEM;
> >+      vdev->ndev = nci_allocate_device(&virtual_nci_ops,
> >+              VIRTUAL_NFC_PROTOCOLS, 0, 0);
> >+      if (!vdev->ndev) {
> >+              kfree(vdev);
> >               return -ENOMEM;
> >       }
> >
> >-      ret = nci_register_device(ndev);
> >+      mutex_init(&vdev->mtx);
> >+      init_waitqueue_head(&vdev->wq);
> >+      file->private_data = vdev;
> >+      nci_set_drvdata(vdev->ndev, vdev);
> >+
> >+      ret = nci_register_device(vdev->ndev);
> >       if (ret < 0) {
> >-              nci_free_device(ndev);
> >-              mutex_unlock(&nci_mutex);
> >+              mutex_destroy(&vdev->mtx);
> >+              nci_free_device(vdev->ndev);
> >+              kfree(vdev);
> >               return ret;
> >       }
> >-      state = virtual_ncidev_enabled;
> >-      mutex_unlock(&nci_mutex);
> >
> >       return 0;
> > }
> >
> > static int virtual_ncidev_close(struct inode *inode, struct file *file)
> > {
> >-      mutex_lock(&nci_mutex);
> >-
> >-      if (state == virtual_ncidev_enabled) {
> >-              state = virtual_ncidev_disabling;
> >-              mutex_unlock(&nci_mutex);
> >+      struct virtual_nci_dev *vdev = file->private_data;
> >
> >-              nci_unregister_device(ndev);
> >-              nci_free_device(ndev);
> >-
> >-              mutex_lock(&nci_mutex);
> >-      }
> >-
> >-      state = virtual_ncidev_disabled;
> >-      mutex_unlock(&nci_mutex);
> >+      nci_unregister_device(vdev->ndev);
> >+      nci_free_device(vdev->ndev);
> >+      mutex_destroy(&vdev->mtx);
>
>     Isn't kfree(vdev) necessary?

You are right. Sent v3 with the fix.
