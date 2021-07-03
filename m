Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791453BA67B
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 02:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhGCAtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 20:49:12 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:33634 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCAtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 20:49:11 -0400
Received: by mail-pf1-f176.google.com with SMTP id s14so10773390pfg.0;
        Fri, 02 Jul 2021 17:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2kl9UtuLXwqigXL0z/0Ce1Bg3PqN6wXeWZxwKnEIWoE=;
        b=BPZ81H9+/ugQyisrsbjJllDnnoVOcWEpRFGxzrUevq6dCeyEsjGzxq6m0UDjqc1qVj
         zpsvH61SLm9URpFXuirfZ8zyE7U/DN0MOIAQ5Unhh6uKN6Ig4WX8Gw278uUnE5kbUOUI
         Om+b3mb+uZw+5LFMdywQphF2NCy4baIj5S6DhcpAjRUcw2TviFQmDG9u5skRpMZoHXkX
         dwWtlyID4LRQPSf2EKsEx+ynZMjxDpjIXhF/28DEC1D/ek6kAaJRlrqUWab1z2A3yLiG
         cQf+D1G7tRqtfHJPHpc+REyt65JsOveka5Ca9PXlgidhFjNbFwXJcyHavLk1O7Q1sM1X
         GrQw==
X-Gm-Message-State: AOAM532bBHTIQho+EMRZMtnqSDKh2V0UyG+MPyREYR7iLjEG1xgaWMgu
        4IrDARMLE8KaWpqOhRdISxU=
X-Google-Smtp-Source: ABdhPJwGJju08VhRuXSU6vHnaEQqhLvLgMpIjXX58qMb53c2M1AVO015kQMXy6Yi1waWrN3B2dyxKQ==
X-Received: by 2002:a62:9290:0:b029:318:a43b:e99 with SMTP id o138-20020a6292900000b0290318a43b0e99mr1385332pfd.6.1625273197181;
        Fri, 02 Jul 2021 17:46:37 -0700 (PDT)
Received: from localhost ([191.96.121.144])
        by smtp.gmail.com with ESMTPSA id y16sm4801730pfe.70.2021.07.02.17.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jul 2021 17:46:36 -0700 (PDT)
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
Subject: [PATCH v2 0/4] selftests: add a new test driver for sysfs
Date:   Fri,  2 Jul 2021 17:46:28 -0700
Message-Id: <20210703004632.621662-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This v2 rebases onto the latest linux-next tag, next-20210701. A few
changes were needed, namely:

  1) changes kernfs_init_failure_injection() to return int instead
     of void. On the latest linux-next we have a new static build
     check for this, so this mistake was captured when building.

  2) I made kernfs_init_failure_injection static

  3) lib/test_sysfs.c moved to the new blk_alloc_disk() added by
     Christoph as direct queue allocation is no longer supported,
     ie, blk_alloc_queue() is no longer exported. This work was
     done by Christoph in preparation to help make add_disk*()
     callers eventually return an error code and make the error
     handling much saner. Because of this same change
     blk_cleanup_queue() is no longer needed so we embrace
     the shiny new blk_cleanup_disk().

I've put this up on my linux-next git tree [0] under the branch
named 20210701-sysfs-fix-races-v2.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210701-sysfs-fix-races-v2

Luis Chamberlain (4):
  selftests: add tests_sysfs module
  kernfs: add initial failure injection support
  test_sysfs: add support to use kernfs failure injection
  test_sysfs: demonstrate deadlock fix

 .../fault-injection/fault-injection.rst       |   22 +
 MAINTAINERS                                   |    9 +-
 fs/kernfs/Makefile                            |    1 +
 fs/kernfs/failure-injection.c                 |   83 +
 fs/kernfs/file.c                              |   13 +
 fs/kernfs/kernfs-internal.h                   |   72 +
 include/linux/kernfs.h                        |    5 +
 lib/Kconfig.debug                             |   23 +
 lib/Makefile                                  |    1 +
 lib/test_sysfs.c                              | 1027 ++++++++++++
 tools/testing/selftests/sysfs/Makefile        |   12 +
 tools/testing/selftests/sysfs/config          |    5 +
 tools/testing/selftests/sysfs/sysfs.sh        | 1376 +++++++++++++++++
 13 files changed, 2648 insertions(+), 1 deletion(-)
 create mode 100644 fs/kernfs/failure-injection.c
 create mode 100644 lib/test_sysfs.c
 create mode 100644 tools/testing/selftests/sysfs/Makefile
 create mode 100644 tools/testing/selftests/sysfs/config
 create mode 100755 tools/testing/selftests/sysfs/sysfs.sh

-- 
2.27.0

