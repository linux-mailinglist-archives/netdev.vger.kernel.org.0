Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948F745FFEE
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 16:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbhK0PuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 10:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347597AbhK0PsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 10:48:01 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60514C061574;
        Sat, 27 Nov 2021 07:44:47 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id t23so24944441oiw.3;
        Sat, 27 Nov 2021 07:44:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=X9mTAXN0GDjT0OEVL106WoVdWnzq/NHT7A3sF8XWLAg=;
        b=a/PWkdrcYwcyP2NijmJKQ2FoB7gZEOL9eWlziuafvWDQIt/7xwHjgU/+BgRphScBuD
         +H2CaKK1JvoDa4NOutV+4sohNBam/bngsGaLEQ7I5P4T3FfkaD2PvtowZmfVQVZc2vwy
         z+/kRjuSfB2p9dZor4Nc2MAJhuc1tRFAKbiP6dToOKg9/D7++Q8z/8SSdp182ce3THp3
         FHp8lIXzacwyr7wALSVxmdS1VGfSONkiXEX1wjgDGaSWeHaZSfuS+t/5iaHyCT0C6M6x
         SMZBEf2OsxMR1eLxybgXdcLcPMjZ6BFm1EVzelGBf+EmglZINU4F4wpkebw9E7iwofvr
         P9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=X9mTAXN0GDjT0OEVL106WoVdWnzq/NHT7A3sF8XWLAg=;
        b=V0DVv1Je69h2TW11Kn/YkTDf6sP82DqM1lFQyLGXLnmAOzkNx4564DJOY090zlIt0z
         v7DheQfqOD0D0GYfuZDK0J/QMOpguhIIYzc8Juhuza9cHr9eatNwSAeKa6Fc6M67rTqe
         jj+HMw/MV3ZyYx6Paii2aBTYk9c/3MRGDlsfRElZ2JJu4SrTk7gfE7/0u8rZ+TFe9gsE
         +r17fayxHxz0WkMLfTDK9dveiV5TKFTBnoxhfsB1iMBj4QpOB30lWpVCAxPmJ8glSynf
         qiMnb1pTSE/8jp1ucRLFLpwO5jupc8ZiR4t3nI9WJ7Jm2E9OIP8vMoZwJ1gfvlNUxfSw
         2NkQ==
X-Gm-Message-State: AOAM531+l+ursiS9SKitSI8OfkaXvfr+tckr2h0qXTEQ0gsDC9QFS2Io
        JFv400BmFIoTVmW57yQnTFiC3lWRCes=
X-Google-Smtp-Source: ABdhPJy+ILESTIBn64sxbqbS8Hj3UBtHk1uoo7F/y4JPliyr5R+5jU6MyqH+MYjaOCT95tj8ypRBEg==
X-Received: by 2002:a05:6808:1509:: with SMTP id u9mr31712601oiw.13.1638027886768;
        Sat, 27 Nov 2021 07:44:46 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t14sm1629056otr.23.2021.11.27.07.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 07:44:46 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Anton Altaparmakov <anton@tuxera.com>
Cc:     linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 0/3] Limit NTFS_RW to page sizes smaller than 64k
Date:   Sat, 27 Nov 2021 07:44:39 -0800
Message-Id: <20211127154442.3676290-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the third attempt to fix the following build error.

fs/ntfs/aops.c: In function 'ntfs_write_mst_block':
fs/ntfs/aops.c:1311:1: error:
	the frame size of 2240 bytes is larger than 2048 bytes

The problem is that NTFS_RW code allocates page size dependent arrays on
the stack. This results in build failures if the page size is 64k or
larger.

Since commit f22969a66041 ("powerpc/64s: Default to 64K pages for 64 bit
book3s") this affects ppc:allmodconfig builds, but other architectures
supporting page sizes of 64k or larger are also affected.

Increasing the maximum frame size for affected architectures just to
silence this error does not really help. The frame size would have to be
set to a really large value for 256k pages. Also, a large frame size could
potentially result in stack overruns in this code and elsewhere and is
therefore not desirable. Make NTFS_RW dependent on page sizes smaller than
64k instead.

Previous attempts to fix the problem were local to the ntfs subsystem.
This attempt introduces the architecture independent configuration flag
PAGE_SIZE_LESS_THAN_64KB and uses it to restrict NTFS_RW. The last patch
of the series replaces a similar restriction for VMXNET3 with the new
flag. This patch is not necessary to fix the NTFS_RW problem and is
provided only for completeness.
