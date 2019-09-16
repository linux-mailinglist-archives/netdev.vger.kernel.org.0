Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5F82B38BD
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732575AbfIPKy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:54:58 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37605 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732510AbfIPKyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:54:55 -0400
Received: by mail-lj1-f195.google.com with SMTP id c22so5455809ljj.4
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 03:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=awMC2NNgYQwIhWG3qRO8zKuB3GE6M/09XFXZ6Czatbc=;
        b=fA1ZBPhjkBsytlESQk6kpCQlXY2ePyrNVBUlN9vF9PL4a+tBgZiDhVywUcbg19c3Bt
         AFVvZR1wfpLJcovFqZU/aQsKJXekdUri03k6Na1iWOGfp6K6Dp58O6CN7NSB6SPDLpfg
         GXozVCNmNMDLClTQ87gCKyH9LKAUpqI+k+Kbnp0FZ2PA94mpFRY1q5zyGP+aXEbwImgB
         OFvOewfBoSVb3rMrGhZmnr3GGZ/Ajob3fWyYwb1F8nLz6YwfPnoTqeH9KHRQvED/7xCu
         AUV1acvpatip1LNApKO+AX58CTgYVBaSdpoGIR9HXyn994giZy6+fdPsNDCYKKXBskWH
         9zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=awMC2NNgYQwIhWG3qRO8zKuB3GE6M/09XFXZ6Czatbc=;
        b=bUlminGbHj82mIDS8WJ1F9OEZ8jtaNytI06kgDMT+bgLaqV0tp8QA8mYPimwsEPM9t
         q5gt4PEmsr3UU8Xt0LiNbjJsjWZhJWpoPL7meDKakirrDS3HWURPqkBxowCK8ENYd/Dj
         tw3HaZnN5/wCLezaZd+sh4aZAlWdNv+gmvpmFmj4erhGktQ9BXRiuTo5xBkCwdwwf41+
         kACdR8vnBfi+JwW3iTotbl1qSrlVEpQqh59hrAyHdWfm1zJyJp6eKThE4xD3kZRMfyOg
         zIzwitT7g5M9xp+ITW9NiwSJun+gfo0f48Bz1pIaKqyRPdU8L8SkUrgd0w8vxW2RUJGv
         yGNw==
X-Gm-Message-State: APjAAAVhGpkDsexGrAgH2lY/loNeu3OqOfD5GI0y4RJSGIxqUkuNP+ie
        bqqsUqlSZ0w4cOYSakLhrL5QwQ==
X-Google-Smtp-Source: APXvYqxFe+l0B6DF4Vp4tbNkF7b9m5dt3qevx/stJMvJalGS+zpGTiuxgMApQNLetSWeV53H0vtR9w==
X-Received: by 2002:a2e:98d2:: with SMTP id s18mr5649688ljj.68.1568631292008;
        Mon, 16 Sep 2019 03:54:52 -0700 (PDT)
Received: from localhost.localdomain (168-200-94-178.pool.ukrtel.net. [178.94.200.168])
        by smtp.gmail.com with ESMTPSA id v1sm8987737lfq.89.2019.09.16.03.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 03:54:51 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v3 bpf-next 09/14] samples: bpf: makefile: use own flags but not host when cross compile
Date:   Mon, 16 Sep 2019 13:54:28 +0300
Message-Id: <20190916105433.11404-10-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While compile natively, the hosts cflags and ldflags are equal to ones
used from HOSTCFLAGS and HOSTLDFLAGS. When cross compiling it should
have own, used for target arch. While verification, for arm, arm64 and
x86_64 the following flags were used alsways:

-Wall
-O2
-fomit-frame-pointer
-Wmissing-prototypes
-Wstrict-prototypes

So, add them as they were verified and used before adding
Makefile.target, but anyway limit it only for cross compile options as
for host can be some configurations when another options can be used,
So, for host arch samples left all as is, it allows to avoid potential
option mistmatches for existent environments.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 samples/bpf/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1579cc16a1c2..b5c87a8b8b51 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -178,8 +178,17 @@ CLANG_EXTRA_CFLAGS := $(ARM_ARCH_SELECTOR)
 TPROGS_CFLAGS += $(ARM_ARCH_SELECTOR)
 endif
 
+ifdef CROSS_COMPILE
+TPROGS_CFLAGS += -Wall
+TPROGS_CFLAGS += -O2
+TPROGS_CFLAGS += -fomit-frame-pointer
+TPROGS_CFLAGS += -Wmissing-prototypes
+TPROGS_CFLAGS += -Wstrict-prototypes
+else
 TPROGS_LDLIBS := $(KBUILD_HOSTLDLIBS)
 TPROGS_CFLAGS += $(KBUILD_HOSTCFLAGS) $(HOST_EXTRACFLAGS)
+endif
+
 TPROGS_CFLAGS += -I$(objtree)/usr/include
 TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf/
 TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
-- 
2.17.1

