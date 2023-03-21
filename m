Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A976C29BB
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 06:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCUFT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 01:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjCUFT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 01:19:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD2C3846F;
        Mon, 20 Mar 2023 22:19:56 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q102so33803pjq.3;
        Mon, 20 Mar 2023 22:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679375995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oHkVNheFrTG/xnXLGGolgKyJ/XZClq78BBdPskDskiU=;
        b=aOaOhpwjRU5yFrtcV9GxJntOZHBBDFZPT0pw/fpJAEON/PnjdsfiDWiM3TsSO+Ng1j
         KOw7zUxspew0xlseO7LNZ8fpT5JuzdKskXeBbttUyJwhZfHpTpkaBUGuSYXYh0Dw2DJq
         wg/9zA276evMiikC7TCaz60u8iBWwStJKlIHRGpl0sQVKuqAqF4JDOkEnO8P0iuz/2k/
         IPEH5MaqD/oXsXN02lDAXDFknKVEUqe0ONEnoRJx0eNyd78x6FIZoOdb53DjWBZ0tlWE
         WvwUviuSO52zT1VTvj2KUknJHVINQJB8ZyLZOiYSrD28kPTrYSIwxSd4F/PL9YduEWVP
         wFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679375995;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oHkVNheFrTG/xnXLGGolgKyJ/XZClq78BBdPskDskiU=;
        b=KRGR020g+4kWDxZd6iNQodt7QPNJMVu0LY41ICrESiczgAi1cAuMn4e1koh4nkdLx+
         H+UJOBUXOTleDVc0714Q8LrFl86oReaAzlJ5pfQMgS3nRDAKJfa7mDlN4oIoEubm8vrJ
         Iwc/rPri/FSaxPD0H899/7828oGunWkfDpan4EDohBonyCUZfby4vxa4AplAGXPSPbg6
         8Fcv2aT8LRX2ZVByhD8OAG5jUyIOs6GpBOIfwAjnOyEvX4ZDlSFv3KkTAPzMcGLnjRUM
         tmsDHFUZwnFvhgcMqPVTMQD4C3Is7M977ccUoZmgQXOtMvt4wusn91E5GY8sHGdxCCUP
         6cPw==
X-Gm-Message-State: AO0yUKWCgl2wXnMf5km6txX0YLcuHv5eu56f7yD9ZzSg9EoTUhgvvoNK
        Me5zLdDmfjhwbiq558gAq4UpGKXYbnU=
X-Google-Smtp-Source: AK7set+jn/YZLzIIxMIIc3V1aJpgxGX5YTPMvXvRrtuRhoUR1qW4RIX8AOX2BHIXM5rZCzrhTgJNQA==
X-Received: by 2002:a17:903:1251:b0:19d:1c6e:d31e with SMTP id u17-20020a170903125100b0019d1c6ed31emr959783plh.60.1679375995297;
        Mon, 20 Mar 2023 22:19:55 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:1606])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902900800b0019a88c1cf63sm7629867plp.180.2023.03.20.22.19.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Mar 2023 22:19:54 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 0/4] bpf: Support ksym detection in light skeleton.
Date:   Mon, 20 Mar 2023 22:19:47 -0700
Message-Id: <20230321051951.58223-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

From: Alexei Starovoitov <ast@kernel.org>

Patch 1: Cleanup internal libbpf names.
Patch 2: Teach the verifier that rdonly_mem != NULL.
Patch 3: Fix gen_loader to support ksym detection.
Patch 4: Selftest.

Alexei Starovoitov (4):
  libbpf: Rename RELO_EXTERN_VAR/FUNC.
  bpf: Teach the verifier to recognize rdonly_mem as not null.
  libbpf: Support kfunc detection in light skeleton.
  selftests/bpf: Add light skeleton test for kfunc detection.

 kernel/bpf/verifier.c                         | 14 ++++---
 tools/lib/bpf/bpf_gen_internal.h              |  4 +-
 tools/lib/bpf/gen_loader.c                    | 38 +++++++++----------
 tools/lib/bpf/libbpf.c                        | 25 ++++++------
 .../selftests/bpf/progs/test_ksyms_weak.c     | 15 ++++++++
 5 files changed, 60 insertions(+), 36 deletions(-)

-- 
2.34.1

