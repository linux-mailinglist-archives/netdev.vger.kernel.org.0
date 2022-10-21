Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CCB6074E9
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiJUKT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiJUKSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:18:49 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345662413E4;
        Fri, 21 Oct 2022 03:18:41 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso4675232wma.1;
        Fri, 21 Oct 2022 03:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2LfrtTV1vRKc7J7VJ5UwaKJfx82Qm1fvaWqDX51XpU=;
        b=VfwUVkR/Cnq8Ix+NAH+WJ3Qp07261Kqnye9ofG37njZ3mhGP5i90wRwkrSZmUFvBrq
         7qpalCNbeA7zRDAplaFY7Uxk6fVXxLdqE838IIv9PeauMVvOuocl1z+bO6A4Kwgr9fr1
         r7sHxE+koFFFC/cvTMVJgk0hnvLYPB2AXSoWG2XE5bKQqe+EgQkpsp9o3krdmG/tL3uX
         NosuNfUkQTiFiA4Vi5P81SL7AV+sCtJZesU3vgQIeqlbqxR4igh8IpQ5qZRZR69o5PwS
         TzKWHOldo62wJnLKMbUbR6b86clvzh6l43WpmIU41M+TVOtU2ucC0UnGCii0OOR5eYWq
         sKZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M2LfrtTV1vRKc7J7VJ5UwaKJfx82Qm1fvaWqDX51XpU=;
        b=C1iWTekz/BX9e4Nh6dCSQLAYi3USvR+Wu21z6rK3bndE8+diLABsMkDCXEAfLO7EFU
         hI3seHWVpaLnm6vprHbyUWR1qxhJ4jc2rhdmPfb266Xm8MvkK0Zl+GqL8AxpsvRrJD15
         F3HZdaen0XdWAJScqYH4fr4kdKdpasW9uh/jrD3/FGfb11RK+DGdvQJ+xVJ0lwtITB9s
         RvthUGUvmq6PfLITpofrxWy7Qc2ne+Frzhfx66lwF0Wh1O8B93qPVjTPu/JQdL8Qs6LF
         h6A3w5QRsIxuN/XmAOjKGBIvpVc728ZlVol3DjFvcgkHzOZclvqMC5Uz4Zeo+v5YG1r2
         sjsA==
X-Gm-Message-State: ACrzQf1Dub7vBXqD86sxWhPN1rohj5VJbXFFaRgCuiYwHnS2UTOneDh7
        Id9utNXNn4pzqXnEobFU7K5S3npY4vk=
X-Google-Smtp-Source: AMsMyM7RYUkfL2yfkxUORjlpQxQfc8xn2EZhWU3TJsiP/2OGqD1DJyATIfGrO9bJZiQyANyRhrVO0Q==
X-Received: by 2002:a05:600c:ad7:b0:3c6:facf:1f5f with SMTP id c23-20020a05600c0ad700b003c6facf1f5fmr15552036wmr.171.1666347518942;
        Fri, 21 Oct 2022 03:18:38 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id ba3-20020a0560001c0300b002365254ea42sm1565184wrb.1.2022.10.21.03.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:18:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 2/3] io_uring/net: fail zc send when unsupported by socket
Date:   Fri, 21 Oct 2022 11:16:40 +0100
Message-Id: <2db3c7f16bb6efab4b04569cd16e6242b40c5cb3.1666346426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666346426.git.asml.silence@gmail.com>
References: <cover.1666346426.git.asml.silence@gmail.com>
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

If a protocol doesn't support zerocopy it will silently fall back to
copying. This type of behaviour has always been a source of troubles
so it's better to fail such requests instead.

Cc: <stable@vger.kernel.org> # 6.0
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 8c7226b5bf41..26ff3675214d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1056,6 +1056,8 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
+	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		return -EOPNOTSUPP;
 
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
-- 
2.38.0

