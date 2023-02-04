Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E6B68ABAA
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbjBDRjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjBDRji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:39:38 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F82E212B6
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:39:35 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id mc11so23472476ejb.10
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 09:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bY9mzamFpQVE1Oh0p5qI4v1NrbUk9zJdtBTT6eXQCgk=;
        b=k3HYSUVTtHr07dAptmGTBb0e+UPC+fWgrWgwpZHDQ9DbuBndUhqJj4dxih3dAae6HN
         I17XkB1pdVMkxcgk4tQ6GKNxtcOGLig7PCD7W7Uz0R/CPz4qhGvpO0FZnRSYByIFvrSn
         BJiiqvUufHDzsU3+dhphA0at/y+4X7ZpnBU5M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bY9mzamFpQVE1Oh0p5qI4v1NrbUk9zJdtBTT6eXQCgk=;
        b=wxIChPagnN18gEijHBb6Ct3tp4gjRe4VPe1ijIYow2VMKyEfYFiPUiis+6TSA7Pnv5
         hXyCn1xWGQh6aaNejXH+1cmDyAnh61NBC47pm2NGTLkZO8mAPMz/wQdLtllEsbWrgMhm
         B3wo6ghGzrU/ZKQRberQ6G/mpurx3cBGKXu8NJCMBrBm2jIVvlXXKKd4kE9CIVzTg5xz
         TCBN/gR7ytjhwCulhyfP/6xLDiAKnAiKh5W3h1ymwzmN1cG2PJcTS7ELr4mMaU6fc12L
         wUV767obVTXkYAaJCgesFG+pWE9evsaG+xWyQ0zeMp8uuYAYCwYyURyObUxQUIPZIvlw
         SmiQ==
X-Gm-Message-State: AO0yUKVwyDHwvlSetR1rAY0eDnfE5+ZlYLUidLGwkF2r3pT4Uaayrz4K
        VPk162l+Pmc8EtO+blf/G5MNbw==
X-Google-Smtp-Source: AK7set/zMm7Qp2lDZdn4F1tPZ+0o69PpXAP7IaM7LAroUeCwMx8Upuc5PbK1SClUbES8gsmkhpDd+Q==
X-Received: by 2002:a17:907:6d9c:b0:895:58be:957 with SMTP id sb28-20020a1709076d9c00b0089558be0957mr2049997ejc.2.1675532374132;
        Sat, 04 Feb 2023 09:39:34 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id ot1-20020a170906ccc100b008897858bb06sm3039321ejb.119.2023.02.04.09.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 09:39:33 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Subject: [PATCH net-next v3 0/3] tuntap: correctly initialize socket uid
Date:   Sat, 04 Feb 2023 17:39:19 +0000
Message-Id: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAEiY3mMC/32OQQ6CMBREr0K69pO2QKCuvIdxUeAXfgyFtIVgC
 He34FZdTl7mzWzMoyP07JpszOFCnkYbQ3ZJWNNr2yFQGzOTXGZcZALCbIOewD9hphbKCk1TcZP
 XlWSxU2uPUDttm/5oDdoHdAeYHBpaz6E7sxjA4hrYI5KefBjd63ywiJP/GFsEcNAmN8rkXJWqv
 bWku3S25MZBi5Q+wkX+lcgokQobURRKViL7Itn3/Q3f9aOaGQEAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675532373; l=2044;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=FnRmRa9+KPgA7wqZzllRlKTOSZY15LPM5WAdD+0/PgA=;
 b=IYbegY9YK8f/O1dP6xQvXjKMUAz2Km8qxRSmrwhMCRlMKCC1hHdpXzvWcpQ+8FJBXKO3Xx/5jrJy
 Dx2a+os2Dj2cYyZcSFSUWCaTwxdSNzA+sFaFMRzBhlLebuq/2apb
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

Fix the bugs by adding and using sock_init_data_uid(), which 
explicitly takes a uid as argument.

Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
Changes in v3:
- Fix the bug by defining and using sock_init_data_uid()
- Link to v2: https://lore.kernel.org/r/20230131-tuntap-sk-uid-v2-0-29ec15592813@diag.uniroma1.it

Changes in v2:
- Shorten and format comments
- Link to v1: https://lore.kernel.org/r/20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it

---
Pietro Borrello (3):
      net: add sock_init_data_uid()
      tun: tun_chr_open(): correctly initialize socket uid
      tap: tap_open(): correctly initialize socket uid

 drivers/net/tap.c  |  2 +-
 drivers/net/tun.c  |  2 +-
 include/net/sock.h |  7 ++++++-
 net/core/sock.c    | 15 ++++++++++++---
 4 files changed, 20 insertions(+), 6 deletions(-)
---
base-commit: 6d796c50f84ca79f1722bb131799e5a5710c4700
change-id: 20230131-tuntap-sk-uid-78efc80f4b82

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>

