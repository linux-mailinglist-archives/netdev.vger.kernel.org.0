Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBCB93B9BCF
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 07:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbhGBFIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 01:08:21 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:54212 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhGBFIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 01:08:19 -0400
Received: by mail-pj1-f42.google.com with SMTP id q91so5691800pjk.3;
        Thu, 01 Jul 2021 22:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FyBGG3CXDWkWudPsmroNJQ+bko8qV6KGaSAatO3OSLM=;
        b=MHZhzh44qFOiz++JEc4RIAPAskzTQb7vEHIqRv6gEzffgCcUMrlqe2rt/FFrERo1LY
         yBzje+/hQy2LvAE5UnRUTTJd35qyatVyx+xnfAJNTzcOUu8XJjBi9kVDvMBaEljJzoK4
         9Zo6/axfZmPHYK6nGYU6eKKv0H1rL8Ooe271MFj0TWYiMDzKEv2EhZzuAk+auGwyDHqA
         7g0lAFS6g+yP9JMil2TqwtIi68c+/1amYLo0mWt0xxCs/dlyrSHZcol1LlqZWjEPKhwG
         TRKdsBF1Oa4uFbMN81JFIrHgHIuk6u40iilwYMgzBD9e5W0AwtJiTeM6mXHLUoJnDu8b
         qqbg==
X-Gm-Message-State: AOAM5314DcKlYcdpRcaBJUMbprfLFVFv2KOG4EU5eNqOjpW2o0P/Ilvr
        CK7jgrP8dY+cUSJN4t3DfEm+j3f5TPY=
X-Google-Smtp-Source: ABdhPJxWp2Kv4AARq0m7M4xFOnYJIPWFCwM0Aa3UYrXg0FGWKrOr2aILQuyW+587EQ9/6w4s3M1QmQ==
X-Received: by 2002:a17:90b:46c3:: with SMTP id jx3mr3099151pjb.206.1625202348041;
        Thu, 01 Jul 2021 22:05:48 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id e29sm1860509pfm.0.2021.07.01.22.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 22:05:47 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org, tj@kernel.org, shuah@kernel.org,
        akpm@linux-foundation.org, rafael@kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, atenart@kernel.org, alobakin@pm.me,
        weiwan@google.com, ap420073@gmail.com
Cc:     jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, minchan@kernel.org,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] selftests: add a new test driver for sysfs
Date:   Thu,  1 Jul 2021 22:05:39 -0700
Message-Id: <20210702050543.2693141-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I had posted a patch to fix a theoretical race with sysfs and device
removal [0].  While the issue is no longer present with the patch
present, the zram driver has already a lot of enhancements, so much so,
that the race alone is very difficult to reproduce. Likewise, the zram
driver had a series of other races on module removal which I recently
posted fixes for [1], and it makes it unclear if these paper over the
possible theoretical sysfs race. Although we even have gdb output
from an actual race where this issue presented itself, there are
other races which could happen before that and so what we realy need
is a clean separate driver where we can experiment and try to reproduce
unusual races.

This adds such a driver, a new sysfs_test driver, along with a set of
new tests for it. We take hint of observed issues with the sysfs on the
zram driver, and build sandbox based where wher can try to poke holes at
the kernel with.

There are two main races we're after trying to reproduce:

  1) proving the deadlock is real
  2) allowing for enough slack for us to try to see if we can
     reproduce the syfs / device removal race

In order to tackle the second race, we need a bit of help from kernefs,
given that the race is difficult to reproduce. So we add fault injection
support to kernfs, which allows us to trigger all possible races on
write.

This should be enough evidence for us to drop the suggested patch for
sysfs for the second race. The first race however which leads to a
deadlock is clearly explained now and I hope this shows how we need a
generic solution.

[0] https://lkml.kernel.org/r/20210623215007.862787-1-mcgrof@kernel.org
[1] https://lkml.kernel.org/r/20210702043716.2692247-1-mcgrof@kernel.org

Luis Chamberlain (4):
  selftests: add tests_sysfs module
  kernfs: add initial failure injection support
  test_sysfs: add support to use kernfs failure injection
  test_sysfs: demonstrate deadlock fix

 .../fault-injection/fault-injection.rst       |   22 +
 MAINTAINERS                                   |    9 +-
 fs/kernfs/Makefile                            |    1 +
 fs/kernfs/failure-injection.c                 |   82 +
 fs/kernfs/file.c                              |   13 +
 fs/kernfs/kernfs-internal.h                   |   73 +
 include/linux/kernfs.h                        |    5 +
 lib/Kconfig.debug                             |   23 +
 lib/Makefile                                  |    1 +
 lib/test_sysfs.c                              | 1037 +++++++++++++
 tools/testing/selftests/sysfs/Makefile        |   12 +
 tools/testing/selftests/sysfs/config          |    5 +
 tools/testing/selftests/sysfs/sysfs.sh        | 1376 +++++++++++++++++
 13 files changed, 2658 insertions(+), 1 deletion(-)
 create mode 100644 fs/kernfs/failure-injection.c
 create mode 100644 lib/test_sysfs.c
 create mode 100644 tools/testing/selftests/sysfs/Makefile
 create mode 100644 tools/testing/selftests/sysfs/config
 create mode 100755 tools/testing/selftests/sysfs/sysfs.sh

-- 
2.27.0

