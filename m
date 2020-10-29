Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EBB29F361
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgJ2Rgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgJ2Rgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:36:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EEFC0613CF;
        Thu, 29 Oct 2020 10:36:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id l8so633950wmg.3;
        Thu, 29 Oct 2020 10:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6OfWgdQ9UOXxPafN1r6hDh95ltyDk2cVMVkOYuDkgCw=;
        b=V03tMCxXFg+6S4W+MoVKQ5F3W25aYu9jzpVjlzAuCnRngdRKQcS8EpSLxGt5KUkkJA
         b5ipKgTpz7OQn+DjNvHvqXz92xvcu/weZ/kJMAjmTXdddMC9VB8VvX5/rdQIBrC4lT4m
         trb1I3bkuU8blvoelXw9fqD0RSC45a9BhcJwi7D47edpryrPAW0Zy3TvYt3s7JdchbKW
         QasK7mqvT9vVXC0z7CCgqEfo0piApjAIX6YaKV1vaxxcgj6o2gHtzSJxDGWJVa08Co32
         YOeFfcajzUlofNE4rcL5nBWUypWTaCbRvumphc1+EE4e8vTSQ4/WXpzIx94uNHMV9z99
         Nm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6OfWgdQ9UOXxPafN1r6hDh95ltyDk2cVMVkOYuDkgCw=;
        b=j7joAxZ+ij7KfB7hZm1N8cZzFU9nGRk5E+E+wibqjU6AQaASU3LIfU9x/GZMH3dvFz
         SyfG5TLHZnJQE1KdQp3/AmTFMeAzxl8o66TKwm/XJCrFiN8d2M9CHCevMnyfcUQbph9L
         2FVrMFLGg71Qf0EWxPbQsxHhDrdYgvaOoo9ouVWKzroazIRiXeCrfNaqyeFNYwbJhxcd
         p8aeNLd9sDnUyMn+v7V+5V8oN6anWBlVMo5U8kxz1cc8W8PhcB+BzquBNgULEc6V6GQt
         Sk5wqg72Ub8Tb2tZR6+K5t30zqnu+XMBJKDdNOtwXYHHGMLVLeO7njaFEKWAQ+fYdkZ+
         am0w==
X-Gm-Message-State: AOAM531QPCfryVHuGtAaVQpNqQ1HibOcl8IFxlkpmZrOre/X/6CSZtDC
        TynES8rhLIVvdykDr2SDFbQ=
X-Google-Smtp-Source: ABdhPJyyu6a3xDP2tayLoZwjLJ8vwVEW0NvH96gOtAPVLVVGizCUyuxTFLj11Hg+3XnEfNAuefFOfA==
X-Received: by 2002:a1c:9a4b:: with SMTP id c72mr194780wme.157.1603993008868;
        Thu, 29 Oct 2020 10:36:48 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id t4sm852122wmb.20.2020.10.29.10.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 10:36:48 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v5 0/3] net, mac80211, kernel: enable KCOV remote coverage collection for 802.11 frame handling
Date:   Thu, 29 Oct 2020 17:36:17 +0000
Message-Id: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

This patch series enables remote KCOV coverage collection during
802.11 frames processing. These changes make it possible to perform
coverage-guided fuzzing in search of remotely triggerable bugs.

Normally, KCOV collects coverage information for the code that is
executed inside the system call context. It is easy to identify where
that coverage should go and whether it should be collected at all by
looking at the current process. If KCOV was enabled on that process,
coverage will be stored in a buffer specific to that process.
Howerever, it is not always enough as handling can happen elsewhere
(e.g. in separate kernel threads).

When it is impossible to infer KCOV-related info just by looking at
the currently running process, one needs to manually pass some
information to the code that should be instrumented. The information
takes the form of 64 bit integers (KCOV remote handles). Zero is the
special value that corresponds to an empty handle. More details on
KCOV and remote coverage collection can be found in
Documentation/dev-tools/kcov.rst.

The series consists of three commits.
1. Apply a minor fix to kcov_common_handle() so that it returns a
valid handle (zero) when called in an interrupt context.
2. Take the remote handle from KCOV and attach it to newly allocated
SKBs as an skb extension. If the allocation happens inside a system
call context, the SKB will be tied to the process that issued the
syscall (if that process is interested in remote coverage collection).
3. Annotate the code that processes incoming 802.11 frames with
kcov_remote_start()/kcov_remote_stop().

v5:
* Collecting remote coverate at ieee80211_rx_list() instead of
  ieee80211_rx()

v4:
https://lkml.kernel.org/r/20201028182018.1780842-1-aleksandrnogikh@gmail.com
* CONFIG_SKB_EXTENSIONS is now automatically selected by CONFIG_KCOV.
* Elaborated on a minor optimization in skb_set_kcov_handle().

v3:
https://lkml.kernel.org/r/20201026150851.528148-1-aleksandrnogikh@gmail.com
* kcov_handle is now stored in skb extensions instead of sk_buff
  itself.
* Updated the cover letter.

v2:
https://lkml.kernel.org/r/20201009170202.103512-1-a.nogikh@gmail.com
* Moved KCOV annotations from ieee80211_tasklet_handler to
  ieee80211_rx.
* Updated kcov_common_handle() to return 0 if it is called in
  interrupt context.
* Updated the cover letter.

v1:
https://lkml.kernel.org/r/20201007101726.3149375-1-a.nogikh@gmail.com

Aleksandr Nogikh (3):
  kernel: make kcov_common_handle consider the current context
  net: add kcov handle to skb extensions
  mac80211: add KCOV remote annotations to incoming frame processing

 include/linux/skbuff.h | 36 ++++++++++++++++++++++++++++++++++++
 kernel/kcov.c          |  2 ++
 lib/Kconfig.debug      |  1 +
 net/core/skbuff.c      | 11 +++++++++++
 net/mac80211/iface.c   |  2 ++
 net/mac80211/rx.c      | 16 +++++++++-------
 6 files changed, 61 insertions(+), 7 deletions(-)


base-commit: 3f267ec60b922eff2a5c90d532357a39f155b730
-- 
2.29.1.341.ge80a0c044ae-goog

