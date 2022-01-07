Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C9648732D
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 07:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiAGGs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 01:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiAGGs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 01:48:58 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFD7C061245;
        Thu,  6 Jan 2022 22:48:58 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id v186so4834526ybg.1;
        Thu, 06 Jan 2022 22:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=xvjeU1BShYSYz/89CGB0rffOY9I8zC/Z7LnpWXix7ZQ=;
        b=QCbfbH0REo6BsoynxMo9CcmCJS+sHju5s2LBER+hoAWRJIzehIJNwOWdjkHuuxr+aC
         Y4H4VNugVVng1suxU1Ot1hlgcMca5otCSngiM8wasieuWDhcEflcR6f/q7Ibpdyyniv0
         y6aAa1m2T9dvOBXB98xSkJ57B1JOqRmt4q/QiLsKcSjbP9+tE/AF4Ej/PCny+53D3shs
         7Xb8cOiI2dEQKq0/GAwwnGuaZdHOW3K91/dzk5YEofMkXqdc02tQyUH9VUDQyGBa8p+3
         vFS9FdYAFK7PA3XUGI/qPdMLYmgcyNaB4nwTxD3Tu3Dj5u5ItN+GvaicJOaQcTDrqAIJ
         G6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=xvjeU1BShYSYz/89CGB0rffOY9I8zC/Z7LnpWXix7ZQ=;
        b=2+BJClQHaVXWVApCYx+vO+cQw22qvjx2NLX7FOGV2fUz36PWtiOz3Ti2L1b/BtFwod
         +/iNcTFBbuuHtdi9OXjsZCXjoKwUGzi0tcZ1ZdK3soXyffuz49HCZPeoRNdfFOMAkH1g
         RkzDlO193AReavsLkBt/feCacMDOf67MZBD4lCd1kfMsnYomhHTCsGWjLHyoYLln3heQ
         azLX8dV8nwZ7wq4zlU/K4I0mzwRbLHL7AmiXJLjSsemjwSep1F+JW3RIY0/cjnGTYssC
         kRSpW0GZSTM3YXnEfth3HYnKcW8UVYX+Z/2fR8tVlzDs1hZjJv78BPo8C4bt5d/p+Xk3
         4LGQ==
X-Gm-Message-State: AOAM533iGhtnREMAJzoG+vu7VlGWYuwRLCjVUE/fozwksGyznv/dA4VS
        svwAf4YBNZ6g7gp/CaDbQgxaH7I9983+ZrQuEqc=
X-Google-Smtp-Source: ABdhPJyVkUz1WXHCJYUMiLbKmjoV9D+XLsb67McUjTdtzRqhzdOv3dUmUuqlZ4Xu3O4eau74nnukMIzrJ/MIGvVbT+g=
X-Received: by 2002:a25:4002:: with SMTP id n2mr34172341yba.547.1641538137340;
 Thu, 06 Jan 2022 22:48:57 -0800 (PST)
MIME-Version: 1.0
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Fri, 7 Jan 2022 07:48:46 +0100
Message-ID: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
Subject: Observation of a memory leak with commit 314001f0bf92 ("af_unix: Add
 OOB support")
To:     Rao Shoaib <rao.shoaib@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Rao and David,


In our syzkaller instance running on linux-next,
https://elisa-builder-00.iol.unh.edu/syzkaller-next/, we have been
observing a memory leak in prepare_creds,
https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3,
for quite some time.

It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
So, it is in mainline, was released and has not been fixed in
linux-next yet.

As syzkaller also provides a reproducer, we bisected this memory leak
to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
support").

We also tested that reverting this commit on torvalds' current tree
made the memory leak with the reproducer go away.

Could you please have a look how your commit introduces this memory
leak? We will gladly support testing your fix in case help is needed.


Best regards,

Lukas
