Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE6159584
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbfF1IEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:04:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52753 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfF1IEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:04:16 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190628080415euoutp01d9a8c6b252a834ee1377a5c70ca18b24~sThyUfmY-1690416904euoutp01F
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:04:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190628080415euoutp01d9a8c6b252a834ee1377a5c70ca18b24~sThyUfmY-1690416904euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561709055;
        bh=htDwnlFffhxBEvi8+xBRx4sQ66noavvKHXBdcxpj0oE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Pddsr2r8tzeZLDWy3mzk9x4ogEV9SU4EjXIA6fr7ZU8tdmrgqmbRofKitW9kt/Lwn
         tdzAoazMO5PeykB++U9fkOPbndsCveDwcqo5dD6ED0/yu+4d8+sYmIRbtlQIfviIy/
         qoLSLWEr+oofbsg6K9eohjiAoaOt9HLa4wxBp0Ss=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190628080414eucas1p177132201f2e18478fa8c7eee5cad0236~sThxmNMqC1746317463eucas1p1p;
        Fri, 28 Jun 2019 08:04:14 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 61.8E.04298.EF9C51D5; Fri, 28
        Jun 2019 09:04:14 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080413eucas1p13f3400f657b4827414737af42f02a57b~sThwqRHhx0956609566eucas1p1u;
        Fri, 28 Jun 2019 08:04:13 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190628080413eusmtrp1e13deb5ff2bc58387fa51528ec2cfce4~sThwcK1Pb2367323673eusmtrp1U;
        Fri, 28 Jun 2019 08:04:13 +0000 (GMT)
X-AuditID: cbfec7f2-f13ff700000010ca-e9-5d15c9fe74f1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 87.10.04140.DF9C51D5; Fri, 28
        Jun 2019 09:04:13 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080412eusmtip189a4ddd4e3bb6ce2297a10e4e641928c~sThvrvVfh2337623376eusmtip1h;
        Fri, 28 Jun 2019 08:04:12 +0000 (GMT)
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
Subject: [PATCH bpf v6 0/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Fri, 28 Jun 2019 11:04:05 +0300
Message-Id: <20190628080407.30354-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0WSe0hTYRjG+3a2neNldZy31yVqQ/8oygtEHSjMIOxQQSqYoFmtPKikU3a8
        FyQhpitT1FgTE8tK3eYlGV5WSA5vKSzUIA28VEJeULOVzhRpx6P03+99nue98PERmLRYJCOS
        lRmMSqlIkYsdhe39G5Zj2x/c44MnityprcJWRFl7B8RU3fM1jKr+WCCkPj3YwKn+uQIxZWrW
        YtSYqVpMNZgH7VqtB9VR2o3CnGhj44SA7qqaxOm6d/MCWj0+itGah18x+rFRh2hrm08EHut4
        OoFJSc5iVEGhNxyTbBubePoLPKfZWCbIR0aRGjkQQB6HZaterEaOhJRsQLAwMyfii98IGk0j
        SI0Ie2FF0JKw19C7uiXgWErWI7AYcvm8DUGFYQ1xhpg8CkP63h12I2Ww2tmBcyGM1GJg/F4p
        5AxXMhYma76JORaSAVC52IZzLCFPwTNLJc5v8wV963uMawZyUwwzr7U4dxGQ58Bgy+YzrrAw
        YNzNe8NwxSMhz/dgumAe8b1FCDTmbQFvnAHjomVnDkYehhZTEC+fBU1TP+LH74fxJRdOxuxY
        3q7BeFkCRYVSPu0Pmz31GM8ymFi27l5Aw9TgU8S/TzwMroxgZcin6v+uWoR0yJPJZFMTGTZE
        yWQHsopUNlOZGHgrLbUN2T/I8PbAr070Z/SmGZEEkjtL/Lrc4qUiRRabm2pGQGByN4mXxS5J
        EhS5eYwq7boqM4VhzeggIZR7Su7sm4mTkomKDOY2w6Qzqj1XQDjI8lFAiZqJ9jWs+4QG5QXY
        Vq5crdXV5ZT/9Scivqi8ZVvOAv2hrrUDnRnUbOnnawanFo+wkQsOS1MZyjH9qv5S3zJ5gr0c
        Fbw+NnQxSiRr08S81HpNN/dF+6jDIbJm8OcPXfLJmNqS++eLw13i/LqfuDYZ9O6RZW/uvp3v
        YV7N0r5yIZukCDmCqVjFPx0kJL8cAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xu7p/T4rGGhxZKWrxp20Do8XnI8fZ
        LBYv/MZsMed8C4vFlfaf7BbHXrSwWexaN5PZ4vKuOWwWKw6dAIotELPY3r+P0YHbY8vKm0we
        O2fdZfdYvOclk0fXjUvMHtO7HzJ79G1ZxejxeZNcAHuUnk1RfmlJqkJGfnGJrVK0oYWRnqGl
        hZ6RiaWeobF5rJWRqZK+nU1Kak5mWWqRvl2CXsaPn7/ZCxaxV6zbMoGpgXELaxcjJ4eEgInE
        kY9/mLoYuTiEBJYySrxYvp4ZIiEl8ePXBagiYYk/17rYIIq+MUpManrHApJgE9CROLX6CCOI
        LQLU8HHHdnYQm1lgIbPEl0kmILawQITEgkltYDUsAqoSU15vAqvhFbCWmHtuCjvEAnmJ1RsO
        ME9g5FnAyLCKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMHy3Hfu5ZQdj17vgQ4wCHIxKPLwK
        O0VihVgTy4orcw8xSnAwK4nwSp4DCvGmJFZWpRblxxeV5qQWH2I0BVo+kVlKNDkfGFt5JfGG
        pobmFpaG5sbmxmYWSuK8HQIHY4QE0hNLUrNTUwtSi2D6mDg4pRoYte43N7g1PM6LjTmu9qrL
        /uBuhwm/bhvFbfV596CKo6X7X/Zj/ZpXGVVCmuHhISVuCd1rf3rzrpb3uXOs1Xr/6zvmwW6X
        dugaMTJu6hVUatfIknq/q35ZzuRVjSuXNN+5POPL/DsTw47f3+I+Na1u4sf9O4LYtbY437vw
        I6bLPD1WUEPH201SiaU4I9FQi7moOBEAMN6RiHUCAAA=
X-CMS-MailID: 20190628080413eucas1p13f3400f657b4827414737af42f02a57b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190628080413eucas1p13f3400f657b4827414737af42f02a57b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190628080413eucas1p13f3400f657b4827414737af42f02a57b
References: <CGME20190628080413eucas1p13f3400f657b4827414737af42f02a57b@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Version 6:

    * Better names for socket state.

Version 5:

    * Fixed incorrect handling of rtnl_lock.

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
 net/xdp/xdp_umem.c     | 21 +++++-----
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 93 insertions(+), 21 deletions(-)

-- 
2.17.1

