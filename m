Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661C76D8B49
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbjDEX7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbjDEX7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:59:39 -0400
Received: from mail-ed1-x561.google.com (mail-ed1-x561.google.com [IPv6:2a00:1450:4864:20::561])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC52769A
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:59:37 -0700 (PDT)
Received: by mail-ed1-x561.google.com with SMTP id ek18so145324115edb.6
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 16:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680739176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6RrIwm12kQIEdac3W6j2b3rDX2Top484gFZq/Zi9RNA=;
        b=PQ42UvoH93/pvm16/tyqIkLlCV6vw5TBlivZd9ZL5sJu+PRgAYImG6MRxXs2CkgNPg
         +Ibg7p5oqxK/GWm6P7acGDHFrzV6NNr+PAQPXs97FwvX2/W9jflTcRaYPbPCDuuHKNmJ
         Cnnqq/m8XjOWzTV8nEXhsrBnBJ1wkdBoE83GM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739176;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6RrIwm12kQIEdac3W6j2b3rDX2Top484gFZq/Zi9RNA=;
        b=oZZHqjVzBSD3Dr1ewUnfY9bMiu5lVWGyp2jTeI60pdVcUujsXwvLqs/kq3E8IoV1HS
         RqzfAHKoBPfNNZdf24uDut7QnVXXbZ0LSRfIabX7P3twZk7voK0SHddN/FdZYNZ3BRdS
         JSpZ3jzQDu6zHC3Is0Wz+j5Tf7NpQK73L9QT0TmPbJasWZXzd0ozI+aBACImd/IorQzc
         IR6H9wAeRphGRaQh598hYo6Vz9VvkuHfSU3ncKtOP+cv4enfBfQyqERRuikFLpb72KeS
         YUfmTz3SrFDSKSqBMwt/6yAaaICPzWQ6TJ/apcyfe8RL2mnp0308nG+hVVbu0RZqOxvh
         AuUA==
X-Gm-Message-State: AAQBX9dmtecMMF7zEIAvIh2MpeIajXT3+VmlwnaPB7NKxhPIoK8toOhG
        7oV/d/VYDTLrrzjngtOX70o5KgOZuIuEyqN+tNeb0teSvkwm
X-Google-Smtp-Source: AKy350bpuB/trGYtGnlcwEhQM4zVWEmb5zF+7R0/Lw6vCklmeg2oC4JzL8eNLfW/n6hi8gyHpuoh5dkQm0ut
X-Received: by 2002:a17:907:c709:b0:947:40e6:fde4 with SMTP id ty9-20020a170907c70900b0094740e6fde4mr4155903ejc.2.1680739176150;
        Wed, 05 Apr 2023 16:59:36 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id hd33-20020a17090796a100b00949174b747bsm8548ejc.96.2023.04.05.16.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 16:59:36 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/2] xsk: Fix unaligned descriptor validation
Date:   Thu,  6 Apr 2023 01:59:17 +0200
Message-Id: <20230405235920.7305-1-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes the test with the bugfix as requested here:
https://lore.kernel.org/all/f1a32d5a-03e7-fce1-f5a5-6095f365f0a9@linux.dev/

Patch #1 (the bugfix) is identical to the previous submission except
that I improved the commit message slightly.

Magnus: I improved the test code a little different than you asked
since I thought this was a little simpler than having a separate
function for now. Hopefully, you can live with this :-).

Kal Conley (2):
  xsk: Fix unaligned descriptor validation
  selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE

 include/net/xsk_buff_pool.h              |  9 ++-------
 net/xdp/xsk_queue.h                      |  1 +
 tools/testing/selftests/bpf/xskxceiver.c | 24 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  1 +
 4 files changed, 28 insertions(+), 7 deletions(-)

-- 
2.39.2

