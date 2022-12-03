Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB64641507
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 09:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiLCIrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 03:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbiLCIrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 03:47:17 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF9C7DA53;
        Sat,  3 Dec 2022 00:47:16 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fc4so9655018ejc.12;
        Sat, 03 Dec 2022 00:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=cG5peFTZZup68qgxzcROlAC3JGIzLbyEKAtL5HHBu6CBFyhsVGaJsGqq7mlUdLnDE7
         kNkQZKRR7mtBgztR6FuJW/xqcqjlP90DOaUKrfMOv4Qe3BFMlsJty4lBS2Rqxm8IzGMc
         Woy6Wur+wJ73L2mj3W3tckY6i3PkSHNbB3wM/ISo0Bxol1F5NRBBSdNeGep9WS8f6Ict
         oR+ijcHCz67HKLwg0yM1oUoiEchrMqDjLOeB5QNFTxnAsuCyacpfqBFc+AMR9Hi7vYMc
         JA9dSW9FGs4dFuHXGKCD/IcVkm5ZTSHA+2LzXeArOk+1i/gh4T1zv3Ef70rRUMLrNhQ6
         XsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1/BEU+Gh3yZCofE7EQRT991qKfijn26P08IEHM1GPc=;
        b=FCYqa02Ii2dj/ZVULhkleF8s3/sgebzOksZljwJGDhEG8fdk7lqjDzRmq+PXwvLdhL
         DTIxHEv6XS5Vx6ZCWDltU5TMZjCICw0nlhmQn+k2TkzvgHwUx6irMlBvhYlf2dqcycUL
         77jUT5erZmia+TbeqA8F94QjcOBD7wf9KOdTav/GCDEgoF4I/wYgANsjFopKivVeLick
         hykpHud3qJeRVMjH3El28yvYneDitGZqc7r2OYW0MLRp3yBZQX0WQNHm2wQlyE5g8MP/
         W08qa6i1z53cvCTU5xNwCNsBqnqEw1g6kBwz/vGdlGd+/8Xu5KxS/MG7hdbPypRDXCi1
         zQmw==
X-Gm-Message-State: ANoB5pl6bJAtUJy6D4wTWiAnwIMom41tgCQejz9847wG9wFCi7sI1X9J
        i73PcREJ3kSg6j2uaE+8A7KVIFpB8J/2ZA==
X-Google-Smtp-Source: AA0mqf6fi8dfa39ADPCovkrYoHQS3ZRMVRGeArSGwUPEwFHpJAt1lxbiZXh+Oyz4NSven9fHFyMxmQ==
X-Received: by 2002:a17:906:547:b0:7ad:9028:4b17 with SMTP id k7-20020a170906054700b007ad90284b17mr62965814eja.366.1670057234865;
        Sat, 03 Dec 2022 00:47:14 -0800 (PST)
Received: from jimi.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id q26-20020a170906389a00b007bdc2de90e6sm3964200ejd.42.2022.12.03.00.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 00:47:14 -0800 (PST)
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
Subject: [PATCH bpf-next,v6 1/4] xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
Date:   Sat,  3 Dec 2022 10:46:56 +0200
Message-Id: <20221203084659.1837829-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221203084659.1837829-1-eyal.birger@gmail.com>
References: <20221203084659.1837829-1-eyal.birger@gmail.com>
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

