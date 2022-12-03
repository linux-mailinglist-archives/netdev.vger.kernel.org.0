Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB926414B6
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbiLCHbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiLCHbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:31:00 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2D889AC6;
        Fri,  2 Dec 2022 23:30:59 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id n20so16441520ejh.0;
        Fri, 02 Dec 2022 23:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=q27xXVAoOVTFDTd9/NdWrqUvwBdEacbxdc6Ij8MBQNDpx0MtSTL1RoqfzJG72Mw4Pn
         Y1bkc/a1Cgh6O0T5gg6jFcSMKWWPV4Q28roCy1oCETC5UE1OAHbRtzeEiEecE9BdGZCe
         +VfjtwQDwcN5lpr6GdvMsNj9cwJT7LY5eM3FGgP7XfS0H4D07hNBg7GLGZAYXlc3n/Mf
         wSTkjfhFDU2OrbjtUs0cmb73mV9cxa1R5hKb43Dp5URrUs4BxWvbBLYzgMRQv60KJJTy
         cBstvoP0ZN8t3Qf2PufNVzOud1ji+Ju0QSwG4jHMJ126jyPuklMPpgtC0tr/f5KCdj6y
         XF/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=aXPesNIVlon4O4hp2hkToGJ5TJeT0rnN5QgrcqScEHZjvTydysUUSPGZq/TC7LfERs
         41RXFwTPhY5sx/aasnUcphNjnON0PEy/FV7ZxTxYEReJo1MAtrIrgg51CPBbXhZ1iYE5
         tOXhSknoe47jXskEcEZwf/T8mj/ApCZzasU75AlCUgUZVJBTc9ksFn+Z6BQ0Z1cKXiwy
         64uuO5IGH5ksGtZqgQfKx+ymOEd5LLutCMwR/W6m1lmsZDSi6Dtz/jiWDVL7MQ9cmFYD
         RYjnaNjFgaNaXRXCEHLyPvU1FCOQHPn88LJO84r/NJmyR9MZMGKriqEKyRxSUE8DYvhl
         3IGA==
X-Gm-Message-State: ANoB5pnCn7UAr2+8ijOYWL/Rsa32ORwEZ39wijS4jgVmbfJkMy1XFQ3A
        ccY8BhHDtincUTCQ4SlUd4Q=
X-Google-Smtp-Source: AA0mqf683K/XLyrmkiS3NVJ5KQaa5nsOYSe0vP4R2L9k0FsNStGlKPDiWIBSAJh7QxJDjxJ6c4oYrA==
X-Received: by 2002:a17:907:c60d:b0:7bf:5fa6:b9b8 with SMTP id ud13-20020a170907c60d00b007bf5fa6b9b8mr24607516ejc.383.1670052658122;
        Fri, 02 Dec 2022 23:30:58 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402074400b0046267f8150csm3772709edy.19.2022.12.02.23.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 23:30:57 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, andrii@kernel.org,
        daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, shuah@kernel.org,
        liuhangbin@gmail.com, lixiaoyan@google.com, jtoppins@redhat.com,
        kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf-next,v5 1/4] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date:   Sat,  3 Dec 2022 09:30:32 +0200
Message-Id: <20221203073035.1798108-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221203073035.1798108-1-eyal.birger@gmail.com>
References: <20221203073035.1798108-1-eyal.birger@gmail.com>
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

This change allows adding additional files to the xfrm_interface module.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/xfrm/Makefile                                    | 2 ++
 net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} | 0
 2 files changed, 2 insertions(+)
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (100%)

diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 494aa744bfb9..08a2870fdd36 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -3,6 +3,8 @@
 # Makefile for the XFRM subsystem.
 #
 
+xfrm_interface-$(CONFIG_XFRM_INTERFACE) += xfrm_interface_core.o
+
 obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 		      xfrm_input.o xfrm_output.o \
 		      xfrm_sysctl.o xfrm_replay.o xfrm_device.o
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface_core.c
similarity index 100%
rename from net/xfrm/xfrm_interface.c
rename to net/xfrm/xfrm_interface_core.c
-- 
2.34.1

