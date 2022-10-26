Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22A960EC97
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 01:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbiJZX2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 19:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234508AbiJZX16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 19:27:58 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041C25A3DA;
        Wed, 26 Oct 2022 16:27:32 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bp11so28494140wrb.9;
        Wed, 26 Oct 2022 16:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fecvoE3GO3AEiM1jj/RAiMwmH/hP4TRAww18UbwirDs=;
        b=k6GcJ40EahQegR5VzpYdakh/t3MYmiw5Q0nyoVR3La3kE8hHFfClOYlbJtkuif5+FH
         N+beJsbpOPO01+Z92fw5EQpfHbajV6BXYlFsejUh8XHGarO8slnsEAXmHRtv+/BI7Mtl
         8mYGE3ppdfdobBJ5orRYKH7fKTAi65sJmaGRpdEvj38dPrdKFX+zpFuxO41BLZtafAu/
         py1L4GjunQmLB3cLC/q/i7l8SOD+x6MjsPNJQcaOKM++StQk5a3+YIF/6qnyBLGozKEk
         cLFxLUvG9ab+w5VYVCvLYhJeU8h5CcC25Vs2FFhb1ruNU0Gv7ZEUyf1TXWPxKfGP6oU6
         bAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fecvoE3GO3AEiM1jj/RAiMwmH/hP4TRAww18UbwirDs=;
        b=kxKolwb5g5BDgvJq27CbcS8LhOJxv8Zmd4Lp+/rSgmfgm/bLaXeo2KI+OT0NuFjrlt
         6m1SfUJeceNyq8D4aWLk+LM0Kc8patuj/NybQKt2TmMlcUiEkg6V5a0SSh9aZOmv/K+A
         pCX1YU1+TvCQT87+AztNMpdiEVW8ifi1xKP04ex92xfbGoygzsX/wTPXM0/zDTHsL4sF
         r30c/LGA7+QTkoKC94ytdrXZPKJJR1S9rDJREJIVG9cShB8zR5J3ya8sSd4QBCoIcfSU
         o5ACCrUOn8If9hOh5Fc2lylo0kBpHw7J/m6GuW4x7rXChgUro6u8Z5YleVNXphjRK3bA
         Dy1A==
X-Gm-Message-State: ACrzQf3lJWqQGJmFpJUYxAospRLIeIbPf+2yiBQzGNoaqm1hbZIIV+l+
        N+17kjzu29AyITx4T5kjsiHzjeybJX1qiA==
X-Google-Smtp-Source: AMsMyM6uKIqQLJPtQgzCdzQ8X4e6hA0DO3wkqZfAOeXGaBTc2rqEZDJAjGBqGIMwvDkfXo9Xx8KvOg==
X-Received: by 2002:adf:d1c4:0:b0:230:7771:f618 with SMTP id b4-20020adfd1c4000000b002307771f618mr28596922wrd.203.1666826852185;
        Wed, 26 Oct 2022 16:27:32 -0700 (PDT)
Received: from 127.0.0.1localhost (213-205-70-130.net.novis.pt. [213.205.70.130])
        by smtp.gmail.com with ESMTPSA id y4-20020adfd084000000b002368424f89esm4897526wrh.67.2022.10.26.16.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 16:27:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, io-uring@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        asml.silence@gmail.com, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH net 4/4] net: also flag accepted sockets supporting msghdr originated zerocopy
Date:   Thu, 27 Oct 2022 00:25:59 +0100
Message-Id: <d8869997f50c23e8446b4c35e3800ebe4bc8e92f.1666825799.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666825799.git.asml.silence@gmail.com>
References: <cover.1666825799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Metzmacher <metze@samba.org>

Without this only the client initiated tcp sockets have SOCK_SUPPORT_ZC.
The listening socket on the server also has it, but the accepted
connections didn't, which meant IORING_OP_SEND[MSG]_ZC will always
fails with -EOPNOTSUPP.

Fixes: e993ffe3da4b ("net: flag sockets supporting msghdr originated zerocopy")
Cc: <stable@vger.kernel.org> # 6.0
CC: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/io-uring/20221024141503.22b4e251@kernel.org/T/#m38aa19b0b825758fb97860a38ad13122051f9dda
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv4/af_inet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3dd02396517d..4728087c42a5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -754,6 +754,8 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
 		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
 
+	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
 	sock_graft(sk2, newsock);
 
 	newsock->state = SS_CONNECTED;
-- 
2.38.0

