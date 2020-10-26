Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C6C29909A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 16:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783226AbgJZPJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 11:09:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55843 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404123AbgJZPJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 11:09:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id a72so12013238wme.5;
        Mon, 26 Oct 2020 08:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+x1UhkmqmtmdEr4B0LaEa7qXm4z8dBJtIO4mmb7CBo=;
        b=ObfSZkZngFEmZWxxEhZfGBELFBwIHk7G8xR3tiYx34nveLIbpidn//YH7s05TuxmRj
         hdytqV8ozjYzWaFgCooqFToRZqT9aotWMFYarduQ3gJ7K/NOBTTGlbHvlb5F15cYb6CR
         +vIAcqWqN/Yi5EJTYVFZvOWjIgj41XLkZJJ5VY96a4zu5C4QFR75Sj/50CqyOYI32WYV
         YpsVK6lNyphBAXoD9EgyIV+A2+LaJIIaFgv6Te1/mFkk9CXMJ9js1i8Pw4nQ/cVpLgng
         qvJyAARbAbAZ0mN8K/aBxiSnaxaAiolOTHHVPc3Lildb4CETex+DvKX//j4TzQOd8zhQ
         Ay4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J+x1UhkmqmtmdEr4B0LaEa7qXm4z8dBJtIO4mmb7CBo=;
        b=pX+qtuz5cS+JoK0PGq7HEHhCJgJjccuovnieANFxC0ITiXGaWpYHZIv8TMXdtt8bi3
         nPptVSnHCziovaaEWIHk4iF0qe6V+MNFf4CwQGxVy/+UdjH1L2Hh0Kz4wbqLb54kzATh
         Zu+VBC2vxqG/8V2X2ZSgkwvASLBIRssdJA4IFeNZL4MxHn5kMmhKhp2O61ySDTu/0MRN
         YHxI6lf6HbJncex1B9TexcPW7t6fqpiSiLb6ypGnvznQfBqV2eEeyfpwnRCnqEmWPRxa
         FOHg1Q/W/KXaMB1T8003wQ3fmyWA5yR8m74K/steNFukOK7cH/qRRvjwF3npGDmRetWn
         5Nbg==
X-Gm-Message-State: AOAM532sT9JlztttyboQirvZJWWQurRIl7fMeQFkoF7N8FpmGAz158AN
        bMaDBOkK9NtzuBmiZqIOVgw=
X-Google-Smtp-Source: ABdhPJyWVKUwQ1tM9gAqB0j6VzRdQS6PG4/vx42gAhGgCegC2gOFzs3OyraKXyHK6edxylSL/4dEwA==
X-Received: by 2002:a1c:9a46:: with SMTP id c67mr15876240wme.115.1603724951892;
        Mon, 26 Oct 2020 08:09:11 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 24sm20043967wmf.44.2020.10.26.08.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 08:09:11 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>
Subject: [PATCH v3 0/3] net, mac80211, kernel: enable KCOV remote coverage collection for 802.11 frame handling
Date:   Mon, 26 Oct 2020 15:08:48 +0000
Message-Id: <20201026150851.528148-1-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
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
kcov_remote_start()/kcov_remote_stop()

v3:
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

 include/linux/skbuff.h | 31 +++++++++++++++++++++++++++++++
 include/net/mac80211.h |  2 ++
 kernel/kcov.c          |  2 ++
 net/core/skbuff.c      | 11 +++++++++++
 net/mac80211/iface.c   |  2 ++
 5 files changed, 48 insertions(+)


base-commit: 2ef991b5fdbe828dc8fb8af473dab160729570ed
-- 
2.29.0.rc1.297.gfa9743e501-goog

