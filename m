Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5538F47CD41
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 08:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbhLVHGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 02:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbhLVHGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 02:06:23 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5CC061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 23:06:23 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id s73so2625064oie.5
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 23:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=znL6gPoBAiKsZIWIkNXi0kaaKLN9p5bWHU/s9NqLSjU=;
        b=NRJPjjc8RG5sziUSLjzr/NcBMUQ9Vw8W7iPPY0PhJOJFKn+EuGLLjS5qx/wRhFT7Mm
         Lnh0NJLgEMEddPEAD07TXHiC7w49dd8gf+fuIUhOBMPE7QAqQzlYSaRHaPOpRIf/ES1r
         ZWWT+ZkPQCIXBrHKZvxG/8ILWI+bHhUwMy3CuboJQ1hGtQ+yhRU5mYEJVR2wftdk5lxT
         0MPOhW0SfAno+hXJH6LBRuZ1+KRulHY3+SmES/Esa+crFKMIW6y7nTipHzo7F5nnzYI/
         VXOtHLzYgm7FeGgS1+sPCAZEE3m/6UuQNXeYLbpELAOpHzsk812beELe3hH2ihA8Nxul
         Hqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=znL6gPoBAiKsZIWIkNXi0kaaKLN9p5bWHU/s9NqLSjU=;
        b=t1LBmnZq1PxrR89bbMALAVIMcmwl5zUzP78mDnbpJHW0d/sOuCBPpqUtj41sw3s7QF
         EHWWwOeLpDiC9Ob/ObntD7p9RiqZTTYiFPUrhNmpJK1aaLJRg6WwGpmMI8qQjdWNjHQo
         e0CV5Cy0xOFm6L+dwCR5vu0+w+ySTtrY9/JCFxqECHlQub+jZC+UrIx1b2a4WT8zGF/r
         7wlDr8YOp4zfSVxqaCzEstqCxnoh+cV6xJhSb4snuLrPkW9c/MgfZRzsfJBD58dNSpZw
         xjwxi7mfLPbywGMOHRsGpg1XUnt915ujD/ZtrfrTyQKRJs+wtHl/WUGIF4Js3z7q5x+Z
         xmhg==
X-Gm-Message-State: AOAM530Br8JvNqK0MMNfATf4AdWx5R82fJ8/v65NA1Yy8UpdhsMwihiq
        jotlXafe96HasUHNpURXoX6eHx400ocTyJP9auGlBxZU66M=
X-Google-Smtp-Source: ABdhPJwrvF+W+Nbhqak4NpKfNVJI78U4X6NGDEBSdqMT8Pi//bQaMdtdgUFqR+tXnyFSflVrXIF2npeZUJj4GMzHC+8=
X-Received: by 2002:aca:4283:: with SMTP id p125mr1144402oia.35.1640156782532;
 Tue, 21 Dec 2021 23:06:22 -0800 (PST)
MIME-Version: 1.0
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Wed, 22 Dec 2021 08:06:11 +0100
Message-ID: <CAMeyCbj93LvTu9RjVXD+NcT0JYoA42BC7pSHumtNJfniSobAqA@mail.gmail.com>
Subject: net: fec: memory corruption caused by err_enet_mii_probe error path
To:     netdev <netdev@vger.kernel.org>
Cc:     Andy Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

There is an issue with the error path of fec_enet_mii_probe in
fec_enet_open(struct net_device *ndev) which leads to random memory
corruption.

In open() the buffers are initialized:
https://github.com/torvalds/linux/blob/v5.10/drivers/net/ethernet/freescale/fec_main.c#L3001

Then fec_restart will start the DMA engines.
https://github.com/torvalds/linux/blob/v5.10/drivers/net/ethernet/freescale/fec_main.c#L3006

Now if fec_enet_mii_probe fails (e.g. phy did not respond via mii) the
err_enet_mii_probe error path will be used
https://github.com/torvalds/linux/blob/v5.10/drivers/net/ethernet/freescale/fec_main.c#L3031

err_enet_mii_probe:
fec_enet_free_buffers(ndev);
err_enet_alloc:
fec_enet_clk_enable(ndev, false);
clk_enable:
pm_runtime_mark_last_busy(&fep->pdev->dev);
pm_runtime_put_autosuspend(&fep->pdev->dev);
pinctrl_pm_select_sleep_state(&fep->pdev->dev);
return ret;

This error path frees the DMA buffers, BUT as far I could see it does
not stop the DMA engines.
=> open() fails => frees buffers => DMA still active => MAC receives
network packet => DMA starts => random memory corruption (use after
free) => random kernel panics

So maybe fec_stop() as counterpart to fec_restart() is missing before
freeing the buffers?
err_enet_mii_probe:
fec_stop(ndev);
fec_enet_free_buffers(ndev);

Issue happend with 5.10.83 and should also also happen with current master.
