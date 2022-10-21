Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5591E6074E1
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiJUKS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiJUKSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:18:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438D225D64A;
        Fri, 21 Oct 2022 03:18:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so1672727wmq.1;
        Fri, 21 Oct 2022 03:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XYSmnfkREi4WTYQUlVts9ImWulHHVRJvwWZMmCq9+b4=;
        b=KHh36XrOk8PQTl3xCNfbAdR+CJFAY1Of1DEFIslUVrf3SEJiIkbJ1DfVyKzcJrTJmc
         WS1HszyjQ3hHyL9XAtrtEB9RlxkCn2aUM34pukvPQfULNfAMI36GevMNb96AmGSU8yRX
         Ga74KHOe1hHZnwv3rLfe7Kq84wTlPv6QGJEWkSpGR87f0PTsEcmKvxix0giTihRrmjCz
         6Xs8z9PN5pww9ZxVMIiqCUHNE69Slg1hX3C/KF3i4TR1ZTRuLP9E8KYPDBYcJs48++sO
         VU097D1eTf8MP+vNaQYonBAD/I89erGeSAYCEjJsJsKbWsH9G7PQ4uaLj86eLp5ASU12
         YswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYSmnfkREi4WTYQUlVts9ImWulHHVRJvwWZMmCq9+b4=;
        b=oNTVPAii7Hc474gSBEQOd+EarAhJ06w2VvxWR7PNrtNpzRiHKFD98WLgSwPmlcVBW0
         wLo7I1xbgINfjYFu8JjyolqGtS9g497swfwnS41SpxXoQ7pme6J3zivje6alMm6SVTxE
         ApbUlBsjtMsKcT3juKItIZZRLB3de4Wb1bNMUE/LorjDDIzae6fMsnSRu81NBV4JPvn+
         nBVdbQQhElkBFXbxeCsWo9FKB7Ph3/lNez9n/3lR/x2KtZD1WIjCTBS+HZ1pjKfz9yVV
         TARf5GdMV3vls1r9yNT5N2XtVdHDF+aRdNjy6rZAsDww9subbX7HvAQp15QPtm0Gx5pM
         tx5g==
X-Gm-Message-State: ACrzQf31kOm50dLp6R8n0NfyXqf2O3PQ79DB+Isjv90kNeHVZMafQDmK
        yla2c3ZoDEHdCYCl9Xoj8BI=
X-Google-Smtp-Source: AMsMyM6n+ImPTPPJxJmfA5xO4wIri8bPQx8lbnerE8t6jUfzro/NXAcN3K6zusi17VWmcafYirCqlQ==
X-Received: by 2002:a7b:cc15:0:b0:3b4:ca90:970d with SMTP id f21-20020a7bcc15000000b003b4ca90970dmr12559946wmh.198.1666347516321;
        Fri, 21 Oct 2022 03:18:36 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id ba3-20020a0560001c0300b002365254ea42sm1565184wrb.1.2022.10.21.03.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 03:18:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1 0/3] fail io_uring zc with sockets not supporting it
Date:   Fri, 21 Oct 2022 11:16:38 +0100
Message-Id: <cover.1666346426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

Some sockets don't care about msghdr::ubuf_info and would execute the
request by copying data. Such fallback behaviour was always a pain in
my experience, so we'd rather want to fail such requests and have a more
robust api in the future.

Mark struct socket that support it with a new SOCK_SUPPORT_ZC flag.
I'm not entirely sure it's the best place for the flag but at least
we don't have to do a bunch of extra dereferences in the hot path.

P.S. patches 2 and 3 are not combined for backporting purposes.

Pavel Begunkov (3):
  net: flag sockets supporting msghdr originated zerocopy
  io_uring/net: fail zc send when unsupported by socket
  io_uring/net: fail zc sendmsg when unsupported by socket

 include/linux/net.h | 1 +
 io_uring/net.c      | 4 ++++
 net/ipv4/tcp.c      | 1 +
 net/ipv4/udp.c      | 1 +
 4 files changed, 7 insertions(+)

-- 
2.38.0

