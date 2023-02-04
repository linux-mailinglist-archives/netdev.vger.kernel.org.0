Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A260768ABAC
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbjBDRjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjBDRji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:39:38 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CFD222E3
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:39:36 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ud5so23556714ejc.4
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 09:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pxDbwUh++gky5GuA5AqNVx6J2j18/7Ee7MKCicvy88w=;
        b=buyuf0JdK/ntq47wAkQZkVe3glYX/nPcfJGZlfZ6gBilRd2YcQ3XskdKwjAEFHv/gz
         XwaEv2Ib123vaz2ZCaJgWMuUD1S7xHdm6mVMQoXYII8+GWnaX6KhrlOeosP3wvuvsfmS
         Rj7KkTYGuX0pq/mdeIA7TZ1VC3gnBUBFeZYMk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxDbwUh++gky5GuA5AqNVx6J2j18/7Ee7MKCicvy88w=;
        b=McJG9UvkNhH7zh539XHSuCiyVxT+3a1wsOMsQU+8vTu5Tknm7uBkfeBpCyTZsBsWhG
         fvrKkRC23cBsEEFRp/oK8cdnrCDFgOdPLt87TXxSIAhKYjM2rVs6gQBesjSBwR8Nba8y
         wj7jT4p3/kt8PU8X1h57LlngdPl6pqDB/Npi5fd1QBRv44yCjR7EKkfNgZ+n1QwjxoRZ
         ucP3sJtePOF0C/ShdTTQ0d/ZecomBtFLHOl3ioeOXmVjrezUA0qoSR1bht0swnGDM7fd
         QCeLrT9D/dGLlB+OTtkqDcYvAORQvTrvJP8cNKOuZCGnYOQ7cZLcHJbaDbEo/QWsIwg8
         Suvg==
X-Gm-Message-State: AO0yUKUc9CcspBIrcpqgr5wfV/Ww05IXNADZVF6V8KnAHY1XKZaSuie4
        c6HomPjS9ccibdC9gbApUuMVRPZ+MH1vvRlNn5/RUg==
X-Google-Smtp-Source: AK7set8MZ7HsnYzKKNRu9LHf37zrwD3r79u9pR2bbErX/X3p3zvdmTkIbSQ8r26irG4GjbeIEkBv+Q==
X-Received: by 2002:a17:906:135a:b0:881:d1ad:1640 with SMTP id x26-20020a170906135a00b00881d1ad1640mr13755676ejb.57.1675532375103;
        Sat, 04 Feb 2023 09:39:35 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id ot1-20020a170906ccc100b008897858bb06sm3039321ejb.119.2023.02.04.09.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 09:39:34 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 04 Feb 2023 17:39:21 +0000
Subject: [PATCH net-next v3 2/3] tun: tun_chr_open(): correctly initialize
 socket uid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230131-tuntap-sk-uid-v3-2-81188b909685@diag.uniroma1.it>
References: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
In-Reply-To: <20230131-tuntap-sk-uid-v3-0-81188b909685@diag.uniroma1.it>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1675532373; l=1432;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=RM1ujG+d5gzCRApp5A/JtPOTgjex/btJO1mhhXLZSPY=;
 b=cmKZ2P1hEmqn8BQf1I1aAoelNXYwPMiZ6KlyR4d7SPR9D+zLPAOwBXGxCVvPEnQh309mRubKW7xK
 nEss/n0gAsN9bGEiwsNTrDLycsyfxoN9NskJgcZ88Yw59Ygj8OfR
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
However, tun_chr_open() passes a `struct socket` embedded in a `struct
tun_file` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with the
high 4 bytes of `struct tun_struct __rcu *tun` of `struct tun_file`,
NULL at the time of call, which makes the uid of all tun sockets 0,
i.e., the root one.
Fix the assignment by using sock_init_data_uid().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a7d17c680f4a..745131b2d6db 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3448,7 +3448,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;

-- 
2.25.1

