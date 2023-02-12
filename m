Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533E16937D0
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 15:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBLOw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 09:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjBLOw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 09:52:57 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBAD3A9A;
        Sun, 12 Feb 2023 06:52:56 -0800 (PST)
Received: from fpc.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2D4C140D403D;
        Sun, 12 Feb 2023 14:52:54 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2D4C140D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1676213574;
        bh=1BOm5AF/SVPewGAsff3Q3TCQ4aozkAkOLj7Mo396mAE=;
        h=From:To:Cc:Subject:Date:From;
        b=HWiNqTf6viB3SkNSJIpMeGSyqyOZnFh1lrs096bNFBD4OwxPj6tOY93Yue5jmyRjs
         2Y762XhvHCYPEiYeGGLaRb49aeFK8jYbY+yCaLywabHsLSgMc28w2qaQP3U21Avm2c
         fXLttrcQlZhMr9RZB7YVSGSSuDHjTHj2AjMEQOMo=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 0/1] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Date:   Sun, 12 Feb 2023 17:52:37 +0300
Message-Id: <20230212145238.123055-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

the problem is described in the following patch.

Some remarks:
I'm not quite sure if the function proposed in the patch should be placed
somewhere else in the code... The patch now calls it during device
deinitialization after urbs deallocation, and I suppose the interrupt
callback ath9k_hif_usb_rx_stream() not to be executed during/after that
period (in this case the leak would still remain, but I couldn't reproduce
this particular case). Maybe the function freeing remain_skbs should be
placed right before calling 'kfree(hif_dev)'?

The patch is made on top of [1] master branch.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/

---
Regards,

Fedor
