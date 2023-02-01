Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C0D685C38
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjBAAgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjBAAgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:36:18 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9445819F3D
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:36:15 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id be12so4855181edb.4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+JesArMFT4xWwZ7KcACge7vTHA8Kg7J7cTO/gXeTzNs=;
        b=P/lQbRqir6FPjDbvvNopMVLVk6Cwz+bMPXjDFtd1b2KwFrApXodzEHi9oALLGk3Trm
         rHah4woFz32/Bs2c6hwPdtFxZ1t8d3a9XiWqxMdkzX5jmTQ8lq8bzQVAsEbGygsVr9rC
         JLy9CMbMHb410JILc5QVB4ncEqcCUprU7CF6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+JesArMFT4xWwZ7KcACge7vTHA8Kg7J7cTO/gXeTzNs=;
        b=v7Vi4eFOrYkNOgkeV2BKUa3VDODby1Br/S0904JcyY3FeOppk+KfwJw1lKe7EGfZEu
         mJv4MXJCu1EGDVt4aqvyAbrXIUeNBCZwfrEGHz6YvBH+ggTKS2ZRzL7muaU+P2YG4oJQ
         /50Ca0UyUHRresFslo6CFgNIFhIRLc6JQ9x/Hgc4so7ZJ53yYJS6rpZON0rh1iY85Woa
         PMdedhEuyKAYeej4SMPi4Rxq6gE6TGR7LMhsnrV98FEKhi/6Tpplk/WD2wxorQ85D57E
         qizBJuCUgUV3puk0YxAbiBzmA4dMrnsNNE5uU7wIr04gLDGC6SflfpjFM4pyUpAk4l13
         4uxg==
X-Gm-Message-State: AO0yUKWj1sPGnbri1CPFZ0HO5pbWqA3Xcis4dwwbu6Xt7bVtJIEEpHIC
        ZSz9f+cpVBFCoJyiUkoBHTEB/Q==
X-Google-Smtp-Source: AK7set/go6u6UT8IUjxYV9MQ6ahbDvEzHVf43R59XLbPZU1Jv+mNAzWhWG0jouKQKWsOpO9uwdPmmQ==
X-Received: by 2002:a05:6402:35c7:b0:499:cc32:6a52 with SMTP id z7-20020a05640235c700b00499cc326a52mr6475761edc.16.1675211774067;
        Tue, 31 Jan 2023 16:36:14 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id x5-20020aa7cd85000000b00497d8613532sm9128306edv.5.2023.01.31.16.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:36:13 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Subject: [PATCH net-next 0/2] tuntap: correctly initialize socket uid
Date:   Wed, 01 Feb 2023 00:35:45 +0000
Message-Id: <20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOGz2WMC/x2NQQqDMBAAvyJ77kISC4Z+pfSQxE1dpFvJRhHEv
 zf2OAzDHKBUmBQe3QGFNlb+SgN76yBNQd6EPDYGZ1xvbG+xrlLDgjrjyiMOnnLyJt+jd9CaGJQw
 liBpuqpP0ErlEkuhzPt/9AShikJ7hdd5/gDt5BvCggAAAA==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.11.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675211773; l=2418;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=9q4wRewKkazS0TsLYBzkWzOZjXKS2AFGi6OqBPmwo8Q=;
 b=fnuod4KPN2+HBQ2WDtuW/anpP+QSOANBOZeFyk3XAFIeJTm6q0j9KHMo9zACNGTiepQ8DdG4BR1F
 JC8FWM6ZCwm7/PrySgxMyqu69IptTvy1T0IYAsMPP1FN3CBbQR6U
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tap_open() and tun_chr_open() pass a `struct socket` embedded
in a `struct tap_queue` and `struct tun_file` respectively, both
allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.

Due to the type confusion, both sockets happen to have their uid set
to 0, i.e. root.
While it will be often correct, as tuntap devices require
CAP_NET_ADMIN, it may not always be the case.
Not sure how widespread is the impact of this, it seems the socket uid
may be used for network filtering and routing, thus tuntap sockets may
be incorrectly managed.
Additionally, it seems a socket with an incorrect uid may be returned
to the vhost driver when issuing a get_socket() on a tuntap device in
vhost_net_set_backend().

The proposed fix may not be the cleanest one, as it simply overrides
the incorrect uid after the type confusion in sock_init_data()
happens.
While minimal, this may not be solid in case more logic relying on
SOCK_INODE() is added to sock_init_data().
The alternative fix would be to pass a NULL sock, and manually perform
the assignments after the sock_init_data() call:
```
sk_set_socket(sk, sock);
// and
sk->sk_type	=	sock->type;
RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
sock->sk	=	sk;
sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
```

To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Lorenzo Colitti <lorenzo@google.com>
Cc: Cristiano Giuffrida <c.giuffrida@vu.nl>
Cc: "Bos, H.J." <h.j.bos@vu.nl>
Cc: Jakob Koschel <jkl820.git@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>

---
Pietro Borrello (2):
      tun: tun_chr_open(): correctly initialize socket uid
      tap: tap_open(): correctly initialize socket uid

 drivers/net/tap.c | 4 ++++
 drivers/net/tun.c | 5 +++++
 2 files changed, 9 insertions(+)
---
base-commit: 6d796c50f84ca79f1722bb131799e5a5710c4700
change-id: 20230131-tuntap-sk-uid-78efc80f4b82

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>
