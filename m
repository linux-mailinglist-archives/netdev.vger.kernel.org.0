Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2A821991C4
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 11:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbgCaJV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 05:21:29 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34409 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730548AbgCaJV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 05:21:29 -0400
Received: by mail-pg1-f194.google.com with SMTP id l14so2953900pgb.1;
        Tue, 31 Mar 2020 02:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition;
        bh=yGyg1ENScRE5z1DsfTEwNcOjmNLUF+zRAh9CdI7gqOg=;
        b=NhRKE6/JaxAnbEhCW2wwKvHlDkv5/m7BqqIKe/fNqwhdNUu3OrHc5ry5mfGANoCq5p
         bYiXIMCsf0PrCT6EHGQhi8wXvYCKRhfufmTAxaNLVEwx2vy5BYAfmXePoII21Mt6HGSm
         mdB9L7HAXTrCfJDftHtQM0C2npxwlVimMB0N/igUc0Uk5mdMJ9yHQrtIf30YoRk4a62Y
         FgcCS2RgMqRRjS7e3oAhJJMtYMMQMy62QdSgfO0QAL2RBOb0xobhKy1Vd9zWgl/zmgmh
         GIEYoAZr1jL5zYQa4spE7zNWkH0wAZdtmkoPsfkMsH9sflsJbawHAibObcNW1fUdLWQv
         SEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=yGyg1ENScRE5z1DsfTEwNcOjmNLUF+zRAh9CdI7gqOg=;
        b=k4aNGw3ftaWexysu20yJ1P0G/n0ivMCrerevwNkledKS4dfbxy6fHyNjL/exKCRMXl
         aVFIGx57uNY72wbhBqTE8v/NZY/r/7c8hHU/0futrcfVM3j9N1+oyTGHGf3TBcFOsAUm
         dEnhoy3wRaC2mTXpudbu7nI+dhW37QJSuADwBR0kyueagE36H+6E8nQYdtmAbNcQ32aY
         PRz5uvvYn4fABODVPVj+taaP1NpJj3bUzyya9oAljhtsNxBaTP8TTQ5sDQePP2cdTlUU
         LeXt9/e/BCU7FrqJgLhmqT99vplsNX+TI4Fxov3Xm75BBKHH4qV2/fVSwXxLW3SgkPu3
         ARjQ==
X-Gm-Message-State: ANhLgQ3i2cgOR75GMXPzdVYLBU+90vuj+MSFF6jbCG0+R8kSwWZYVOVu
        kMeXKTKFBD1sD6WJ7jkCRJc=
X-Google-Smtp-Source: ADFU+vslw43GDAqAatksB6/tDHIxvAhJy1bO7D85eQQEgR3jPGoNMqSSAkg7du8J6pRlH6QdKdWWJQ==
X-Received: by 2002:aa7:962d:: with SMTP id r13mr18081654pfg.244.1585646488149;
        Tue, 31 Mar 2020 02:21:28 -0700 (PDT)
Received: from localhost (194.99.30.125.dy.iij4u.or.jp. [125.30.99.194])
        by smtp.gmail.com with ESMTPSA id d23sm11980605pfq.210.2020.03.31.02.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 02:21:27 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Tue, 31 Mar 2020 18:21:25 +0900
To:     Jouni Malinen <jouni@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [linux-next] bisected: first bad commit: mac80211: Check port
 authorization in the ieee80211_tx_dequeue() case
Message-ID: <20200331092125.GA502@jagdpanzerIV.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Commit "mac80211: Check port authorization in the ieee80211_tx_dequeue()
case" breaks wifi on my laptop:

	kernel: wlp2s0: authentication with XXXXXXXXXXXXXX timed out

It just never connects to the network.

$ git bisect log
git bisect start
# bad: [458ef2a25e0cbdc216012aa2b9cf549d64133b08] Merge tag 'x86-timers-2020-03-30' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 458ef2a25e0cbdc216012aa2b9cf549d64133b08
# good: [16fbf79b0f83bc752cee8589279f1ebfe57b3b6e] Linux 5.6-rc7
git bisect good 16fbf79b0f83bc752cee8589279f1ebfe57b3b6e
# bad: [59838093be51ee9447f6ad05483d697b6fa0368d] Merge tag 'driver-core-5.7-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect bad 59838093be51ee9447f6ad05483d697b6fa0368d
# bad: [e59cd88028dbd41472453e5883f78330aa73c56e] Merge tag 'for-5.7/io_uring-2020-03-29' of git://git.kernel.dk/linux-block
git bisect bad e59cd88028dbd41472453e5883f78330aa73c56e
# good: [906c40438bb669b253d0daeaf5f37a9f78a81b41] Merge branch 'i2c/for-current' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect good 906c40438bb669b253d0daeaf5f37a9f78a81b41
# bad: [10f36b1e80a9f7afdaefe6f0b06dcdf89715eed7] Merge tag 'for-5.7/block-2020-03-29' of git://git.kernel.dk/linux-block
git bisect bad 10f36b1e80a9f7afdaefe6f0b06dcdf89715eed7
# bad: [3a0eb192c01f43dca12628d8b5866d5b8ffb35f5] Merge tag 'for-5.7/libata-2020-03-29' of git://git.kernel.dk/linux-block
git bisect bad 3a0eb192c01f43dca12628d8b5866d5b8ffb35f5
# bad: [0f751396346f5cfb6d02abe1985af53717b23c3d] Merge tag 'tpmdd-next-20200316' of git://git.infradead.org/users/jjs/linux-tpmdd
git bisect bad 0f751396346f5cfb6d02abe1985af53717b23c3d
# bad: [a0ba26f37ea04e025a793ef5e5ac809221728ecb] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
git bisect bad a0ba26f37ea04e025a793ef5e5ac809221728ecb
# bad: [8262e6f9b1034ede34548a04dec4c302d92c9497] net: ks8851-ml: Fix IO operations, again
git bisect bad 8262e6f9b1034ede34548a04dec4c302d92c9497
# bad: [ce2e1ca703071723ca2dd94d492a5ab6d15050da] mac80211: Check port authorization in the ieee80211_tx_dequeue() case
git bisect bad ce2e1ca703071723ca2dd94d492a5ab6d15050da
# good: [575a97acc3b7446094b0dcaf6285c7c6934c2477] ieee80211: fix HE SPR size calculation
git bisect good 575a97acc3b7446094b0dcaf6285c7c6934c2477
# good: [05dcb8bb258575a8dd3499d0d78bd2db633c2b23] cfg80211: Do not warn on same channel at the end of CSA
git bisect good 05dcb8bb258575a8dd3499d0d78bd2db633c2b23
# first bad commit: [ce2e1ca703071723ca2dd94d492a5ab6d15050da] mac80211: Check port authorization in the ieee80211_tx_dequeue() case

	-ss
