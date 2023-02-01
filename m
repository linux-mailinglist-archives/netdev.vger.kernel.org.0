Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8656C685C3B
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbjBAAgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBAAgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:36:18 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D11ABF2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:36:16 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ud5so46760979ejc.4
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rS54Fk+blZccv36/ddQJZIl5VNp6q0RMZlNbEI72g1M=;
        b=l5PSu4W/MxPPE5vmiw43ENLr63KaRIhpA6RM4H2J62MZjy8tETZkurD1HFNajqimHJ
         MVlPRZJelk58fXttWc68AOwF1Y+6B1MoXvwFJ9u+K3f5neJNHOVjRScHy2G+p9h2l/W6
         dN74hSR+KUjb6DPIIPAPK+hRldlYv6+j3qgiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rS54Fk+blZccv36/ddQJZIl5VNp6q0RMZlNbEI72g1M=;
        b=du/mu6iypfHbFDQViSDpmr/SvoJBChx7zNZBr57a0ahsHHbG56mjtY3TPa8KS42XxR
         9lwcl1/G1/H7GuYkX2A+j5yKNIowya1oCM9F4AJCwVSxlZO+QZf+1N/HIeYSCLzvjxFh
         p4OOYerhiJDH4JEencK5U3+Ehgcyh+U/PCsdiKHJ8weM40WXeKBrUVz/5z4j24O/ojrZ
         EZ7+tv0ZccvnwyavCBoiFPauE+p9bMzDkMLjT3rW+8a35YcKRoc5KoA0A8X9uN0BVzpr
         6cLfxMhtxo0mbjDcp+m8VJy2lA3vWgghiIPMcBGG1iQ6pKY5YkjjyRHasVP1UfEDyihr
         G2ig==
X-Gm-Message-State: AO0yUKWNhL9f5AI5iGOJoTo/QL+CKf9oL14H0Ib7NVK/JldLyKXYh5Qq
        5pdUAZhqPLaZaZhKUPGZYt7iAA==
X-Google-Smtp-Source: AK7set+eu6UmZvZlMXsYVfFeQkOI0IZwRjuvsPrll8ET40r8zzSEHho+H26j6DkBeKkNRk4Tl1EVFA==
X-Received: by 2002:a17:906:53d4:b0:878:7ef1:4a20 with SMTP id p20-20020a17090653d400b008787ef14a20mr377934ejo.4.1675211774812;
        Tue, 31 Jan 2023 16:36:14 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id x5-20020aa7cd85000000b00497d8613532sm9128306edv.5.2023.01.31.16.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:36:14 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Wed, 01 Feb 2023 00:35:45 +0000
Subject: [PATCH net-next 1/2] tun: tun_chr_open(): correctly initialize socket uid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230131-tuntap-sk-uid-v1-1-af4f9f40979d@diag.uniroma1.it>
References: <20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v1-0-af4f9f40979d@diag.uniroma1.it>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675211773; l=1573;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=rWTgXJjqmkGcx3bfIxVWvKyISJ7g38xNtfltnPXm0EI=;
 b=DM+nP8/msLn5nbx2NJbVEpVQhFqn7VaIFyQsK0NKEXhCd2nB+o3Xn3zLmkyzX7eRvwPIpiMou9Tq
 e9ifEjmGC3sLIa78fEoJrSJpH7NguZ102bMHgCAzHsLwyZVXiIeo
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tun_chr_open() passes a `struct socket` embedded in a `struct
tun_file` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with the
high 4 bytes of `struct tun_struct __rcu *tun` of `struct tun_file`,
NULL at the time of call, which makes the uid of all tun sockets 0,
i.e., the root one.  Fix the assignment by overriding it with the
correct uid.

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 drivers/net/tun.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a7d17c680f4a..6713fffb1488 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3450,6 +3450,11 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 
 	sock_init_data(&tfile->socket, &tfile->sk);
 
+	// sock_init_data initializes sk.sk_uid assuming tfile->socket is embedded
+	// in a struct socket_alloc and reading its corresponding inode. Since we
+	// pass a socket contained in a struct tun_file we have to fix this manually
+	tfile->sk.sk_uid = inode->i_uid;
+
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
 

-- 
2.25.1
