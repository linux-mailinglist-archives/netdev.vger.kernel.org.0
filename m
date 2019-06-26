Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A705705E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFZSPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:15:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40471 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbfFZSPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:15:24 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190626181522euoutp029d99b8ca62aa256b1b988e29273f946d~r0kyv-pr40707007070euoutp02m
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 18:15:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190626181522euoutp029d99b8ca62aa256b1b988e29273f946d~r0kyv-pr40707007070euoutp02m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561572922;
        bh=SAjVXWVU+wN/bLQEdEYQ4VStpx/WPHw7CzyrLqzCoig=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Bisy1OAYnpfhKL11dIJlF085onDtBeX46jzjM2sCApKz4pXBhOS0jP9+eMuCcSJ6k
         /KsfOzdD4nAgbTm0tPTF8RdbbaA7m1Ckf63ZHuywYmKZrC/wmR8QFYEXWPUpM+ub6b
         5R4SM7pRNd3/nfTF8g8V612+VvqwflLMPCdoUaoc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190626181521eucas1p2ba4b961787a9c429885d8bb3ffa158c8~r0kxclAcY3035230352eucas1p2S;
        Wed, 26 Jun 2019 18:15:21 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id CE.BB.04298.836B31D5; Wed, 26
        Jun 2019 19:15:20 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190626181520eucas1p1817d31d958b8755600f0745e92edef5a~r0kwrobEp2194821948eucas1p1U;
        Wed, 26 Jun 2019 18:15:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190626181520eusmtrp2264b0ed253ef69b9931615ce8127cb08~r0kwdkFar2043720437eusmtrp2L;
        Wed, 26 Jun 2019 18:15:20 +0000 (GMT)
X-AuditID: cbfec7f2-f13ff700000010ca-3c-5d13b638801e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7D.34.04140.836B31D5; Wed, 26
        Jun 2019 19:15:20 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190626181519eusmtip2d493497d0d5fa4fc1a0b7c5c29712618~r0kvu_NFz0894308943eusmtip2D;
        Wed, 26 Jun 2019 18:15:19 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v4 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Wed, 26 Jun 2019 21:15:13 +0300
Message-Id: <20190626181515.1640-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSbUhTYRTHe3a3u6u1uk7R0yaKU0ElNakPF5VqYDD6ZI4gJstuedGRm7r5
        mlCrRE2pRViiCJqSr2RmQ91QyWGaZhrmB400XwqnoplmKTNt80769jv/F87h4SEwYQlPRKg0
        GYxWQ6dIcFdue//2SCjV7q48uVMRRe0UtCJqo28Ap2qf/caoytF8LjVeuM2n+q35OGVuKceo
        T+ZKnGqwvLNr1Z5Uh6EHnTssMzZOcmSmiim+rLZrkSMrnhjDZGUls5jsobEJyTbafGL5Ctfo
        RCZFlcVow89cdU1++lme9grPWdra5OjRArcYuRBAnob5ykZeMXIlhGQDgumFeufwC4Hp4w+c
        HTYQ3DVX8Q4q95cLcAcLyXoEY3OX2NAWguH+L/sGTp6AoeY+5GAPUgQ/Ozv4jhBGlmNgnC/d
        X+5OKmBYX4E5mEsGgnlqju9gARkJq7VNOLvNF5pb32COMpA2HKwvTBzWiIE+g4XPsjssDRid
        7A17pipn5jZ8zV9EbLkIQZll12mcBePyiL1A2E8KhpfmcFaWwve3E/sykEdhYsXNIWN2fNxe
        hrGyAIoKhGw6AGy99RjLIphc3XBeIIM73TVc9oGU0Fk3ij9CPhX/d1Uj1IS8mEydOonRRWiY
        7DAdrdZlapLCrqeq25D9i7zfHVjvRJtj1yyIJJDkiEDvK1QKeXSWLldtQUBgEg/Bc5pUCgWJ
        dO5NRpuaoM1MYXQWJCa4Ei9B3qGZeCGZRGcwNxgmjdEeuBzCRaRHPq+j9HT7Mcn8+YvrNYr0
        ANvMg6D4kLrL48H9M/Lj0T0mEb+3WlWo34mbVo+tWQOTGnc0f0J7/C8kdq907RFNynhv7Jtb
        i/yeOCHI+GQkhuHb1rKHygct1nQ/qXRWGls6mGK4FReena7M8yzM+eBn+2sQq8RX6iZP+UdO
        yxUSri6ZjgjBtDr6H5frnlUeAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xe7oW24RjDdb8ZrP407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL2PareCCjWwVr358ZWpgfM7SxcjJISFgItH5
        uo2ti5GLQ0hgKaNEy85DbBAJKYkfvy6wQtjCEn+udUEVfWOUWHbiJDNIgk1AR+LU6iOMILYI
        UMPHHdvZQWxmgYXMEl8mmYDYwgIRElvWrAGLswioSuy6+wjM5hWwkni3eBXUMnmJ1RsOME9g
        5FnAyLCKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMHi3Hfu5ZQdj17vgQ4wCHIxKPLwN8kKx
        QqyJZcWVuYcYJTiYlUR4lyYKxArxpiRWVqUW5ccXleakFh9iNAVaPpFZSjQ5HxhZeSXxhqaG
        5haWhubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGM8x7HNwvfy7Oza2c1HvzowN
        l5lU0sIvn91gtn4iT211rlnhOnfm3zOWaC//+qJ/RXap7bP/Fjs7Y389tG2eteDJ+9sLT2cw
        NTPcrrjzU6RhxreDEjst3+cJbtwawjtPz1yteeV+ZYHsA4siU+76VPRJPzEV8+aqPRzF/sb+
        ccDHqXanFnI+X63EUpyRaKjFXFScCAAneowpdAIAAA==
X-CMS-MailID: 20190626181520eucas1p1817d31d958b8755600f0745e92edef5a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190626181520eucas1p1817d31d958b8755600f0745e92edef5a
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190626181520eucas1p1817d31d958b8755600f0745e92edef5a
References: <CGME20190626181520eucas1p1817d31d958b8755600f0745e92edef5a@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 4:

    * 'xdp_umem_clear_dev' exposed to be used while unregistering.
    * Added XDP socket state to track if resources already unbinded.
    * Splitted in two fixes.

Version 3:

    * Declaration lines ordered from longest to shortest.
    * Checking of event type moved to the top to avoid unnecessary
      locking.

Version 2:

    * Completely re-implemented using netdev event handler.

Ilya Maximets (2):
  xdp: hold device for umem regardless of zero-copy mode
  xdp: fix hang while unregistering device bound to xdp socket

 include/net/xdp_sock.h |  5 +++
 net/xdp/xdp_umem.c     | 27 +++++++------
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 88 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 99 insertions(+), 22 deletions(-)

-- 
2.17.1

