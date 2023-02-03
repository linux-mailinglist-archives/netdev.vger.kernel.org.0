Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FFF689BB0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbjBCObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBCObI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:31:08 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662FA9189F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:30:39 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ml19so15993572ejb.0
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 06:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SCfhQWifsNy9CyCbBvmbmuvaOgWVqMDaXIzl8qBm0x4=;
        b=z336Lb1iPJSZyYKXQhbaDhXihPVC0JsnENYUd0VWoG9KCS1hbFQ2FUSImZCiOpFZjm
         2FLmhjgADdx2nD215OoUSwkjeovCQ1AaPweUZQR0Jl7oVRCkEIpVlrsZCGhYVrdLgtcQ
         bl5yY12T+7obPeSltFQtzr8vVMn2JDgIBAHkQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SCfhQWifsNy9CyCbBvmbmuvaOgWVqMDaXIzl8qBm0x4=;
        b=4nlUT+JXivBINAUXhWCLlbqxqlgKK+US1RcYylHruN0WdOZJXcjJ/eeea7LKLTNRsi
         oZK4vc2zib/+5PLU7K4ot8GuGQaMlgJlqrsrSeoPYJe8fEdpXU3B3yd0cGpLz+Sey7a+
         SpiKaiXEKgN38uZ3xwFXKA8MVMW6G6ix/bVLk/IyeacXtTBWWZ7bcmWZ7smwnaLc2lri
         j0IW1GYFX4yN7QNDAwvmPWo0FOzj8R7t97GdnkKlsoov/StVcIJvgytyZtCtOJCoLyK4
         6npiP9HGDyAiq2q3nVOce8Jzwah5vZ6rZIk6OuGj71oKa95cRXGAtynb+sPfbXkdDVEW
         3wRw==
X-Gm-Message-State: AO0yUKV4ALlKRK/0hvavslsjxTcBhmgIGBM2rZJDrvCduPlFsNlc+McC
        euCtEGnwckO8bYfVTWmduTVxZQ==
X-Google-Smtp-Source: AK7set9sAkOUEJC4Bqjify5ZxZ//da2iQy5f+Fu/o4MO9VpT8FY2V54/8QZ15B6Y8491Z43q7ve0fQ==
X-Received: by 2002:a17:906:6a24:b0:87b:da77:eec2 with SMTP id qw36-20020a1709066a2400b0087bda77eec2mr14376037ejc.19.1675434637922;
        Fri, 03 Feb 2023 06:30:37 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id v17-20020a17090690d100b007b935641971sm1453388ejw.5.2023.02.03.06.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 06:30:37 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Subject: [PATCH net-next v2 0/2] tuntap: correctly initialize socket uid
Date:   Fri, 03 Feb 2023 14:30:26 +0000
Message-Id: <20230131-tuntap-sk-uid-v2-0-29ec15592813@diag.uniroma1.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIIa3WMC/3WOwQqDMBBEf0X23JUkCmpP/Y/Sw6obXYqxJFEs4
 r83eu9xeLyZ2SGwFw5wz3bwvEqQ2aVgbhl0I7mBUfqUwShTKF1ojIuL9MHwxkV6rGq2Xa1s2dY
 GktNSYGw9uW48rYlCZH+Cj2cr2zX0BMcRHW8RXomMEuLsv9eDVV/8z9iqUSHZ0ja2VE3V9I9ea
 MgXJ36eSOeSCo/j+AGoMCn/1AAAAA==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675434637; l=2185;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=k7OkDWZh6ckrGB3KcTW6UKWAah2540gJFLAT/7iNFX0=;
 b=vkf+XCAcN0KXWbS/7ktGZ8N/sUAXkaRTSZzm/rUkVcfzo5F2gGcrtPXfsEoEDzezcc1Ae65PFB2W
 Qv9SOYx7BJDiSrTqkdhrTMKHdATiTYZtGQXkHgKqDajkeaSIfxnK
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

Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
Changes in v2:
- Shorten and format comments
- Link to v1: https://lore.kernel.org/r/20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it

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

