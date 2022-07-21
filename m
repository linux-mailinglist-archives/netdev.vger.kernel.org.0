Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE49057CD94
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiGUO1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiGUO1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:27:14 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA1181B2E;
        Thu, 21 Jul 2022 07:27:13 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h8so2545144wrw.1;
        Thu, 21 Jul 2022 07:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cS7HI6SzP+cUTcYgVfMeyM3fLXZCY/z4ELbXGyMLw1s=;
        b=J5FEUrT1LIq+LAfx/r6Aoyp4RzUbFON6T18AAnnb4/AAJgUc31L2F+B7h1jozXGN4c
         AZo2ptXHfCWYzGlyOnfdPRIc8ePc7Lh8bv3vTxtgu56kKJOjCtG6T+Fv166odqcB38FS
         Miw2YAWHQVo75nmPyy/Nz/gLLNT3yIrkY3D0AoHMwc11laqkuEMu25TXkire9TFmHCzf
         BRJPB1IChSzhPF555Es7vy4Q7KD5ucRpkwSfuEkDX9JJdq8f8rdtuDfAS0ukQNDhMmcj
         UitdKUnIwMVs9kd2R+fqH34ZX1D1TYInLxzmqY1Xy95SWscNEDIM7jKS6FMZFornIA7d
         74Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cS7HI6SzP+cUTcYgVfMeyM3fLXZCY/z4ELbXGyMLw1s=;
        b=gN7GzIHXXO586tddmLiwT97Pr9n4JU74+NvKIbGnIe0WsMopBtmRH6HpPwVdXv0Rb/
         q1jzkyGl5YmiYDv454oQHy86G1WD7S8XVseoyht2G5vb/wO739UpbAt7WZl/zFdrorlX
         oX1LnyyBz5Nk9zI9hpWRZ18JDHTt8wWMGP35D+3wbEsqygbMXqDx3OSeKcOMfqsU9l8z
         XzTfzJY27Ugy40LMZGAI/eLm395WASUWi3mdjulJlNgq0VlehZ4WgOBgGvR2Yx8RraYo
         qMW2g/7dBdRFh4l/Uk3bEAnYjNrcoqihM3WMN5jOnBFbA9LQQDb6YdIqkwpVlk2tBvJp
         OvoA==
X-Gm-Message-State: AJIora+0AHavVQpuR0IRP69OQxQEN/mu9FljvFSYszt26z2ZJErUKaxk
        HwVSA/tRbiJ90kPxEPiknIBTDaf9nzhZ0Q==
X-Google-Smtp-Source: AGRyM1s2umnKbiUxRjfkk59PJGmeuhNQZawweS8YvfwcceUG+/rqjlIb0swPGDTCdjJcoDHFuzjWDA==
X-Received: by 2002:a05:6000:1547:b0:21e:5be2:9ed3 with SMTP id 7-20020a056000154700b0021e5be29ed3mr825023wry.459.1658413631486;
        Thu, 21 Jul 2022 07:27:11 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:64b4])
        by smtp.gmail.com with ESMTPSA id bw6-20020a0560001f8600b0021e529efa60sm2013358wrb.1.2022.07.21.07.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:27:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next] net: fix uninitialised msghdr->sg_from_iter
Date:   Thu, 21 Jul 2022 15:25:46 +0100
Message-Id: <ce8b68b41351488f79fd998b032b3c56e9b1cc6c.1658401817.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Because of how struct msghdr is usually initialised some fields and
sg_from_iter in particular might be left out not initialised, so we
can't safely use it in __zerocopy_sg_from_iter().

For now use the callback only when there is ->msg_ubuf set relying on
the fact that they're used together and we properly zero ->msg_ubuf.

Fixes: ebe73a284f4de8 ("net: Allow custom iter handler in msghdr")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

It's not the best approach long term but let's fix first and later
I'm going to clean up msghdr initialisation.

 net/core/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 28cdb79df74d..ecbc0f471089 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -619,7 +619,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 {
 	int frag;
 
-	if (msg && msg->sg_from_iter)
+	if (msg && msg->msg_ubuf && msg->sg_from_iter)
 		return msg->sg_from_iter(sk, skb, from, length);
 
 	frag = skb_shinfo(skb)->nr_frags;
-- 
2.37.0

