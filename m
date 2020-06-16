Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A475E1FA6ED
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 05:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgFPD1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 23:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgFPDZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 23:25:34 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7ED3C008631
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:32 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k1so7661602pls.2
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 20:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OccJNbyy0FfcO+NA6C7yQdujZ1D/AqAjCekMSJ8aj8A=;
        b=FRqFvjr6OjkLiohv0sT5U1oo9bD6Ib4bxSZIX8h+h7+J/bnqygBr6USH7j+phNr76Q
         F4vUdJeQo9YhtpUAiEDXiUENq7bOLk4RWEw145LTOX3+UBjOPc7vT4BUJ2rMVm0HCN/S
         zrrQ03Wg1ub1uXhOt1dsf8fWKv7xBwMTu70O8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OccJNbyy0FfcO+NA6C7yQdujZ1D/AqAjCekMSJ8aj8A=;
        b=sl6268SVj/2B5Nupbme7N7OxDbmzcSas/ldHcdbGVHBCRYhs216SsA6p54M+33I20G
         4AYGTF8bZAMGPrz2Q4chio3CE/v9ubx0NEW1bOUTEhNTh+14y4s76Qnn5mUywb+BfKNR
         KG5O6O5mxLUQSMCtY+E7+fhYjPoHdlrnFtO69b1hafbScePPZ/D2UgDi9njbQvRt0dG7
         RK0a9RGNaerPelmViQBmrswCiZ1JujFGXQV7Nct5pPuquCyM98zUf/fTomumNCSGGJ8Z
         kTzkPiHO8Kz/8J2WM0QWYD4erN0Mq/NNjCgryxHiCzN9mcqQzaGCabt7UKdV7mQIt0cM
         loQg==
X-Gm-Message-State: AOAM530tUnnQzW6EJsfsj8BIZV4sW5nGCseY3SvRBu05dGTeFZ1WGCZF
        ddqsxbA2B6dFW1dFFgi9wGMWSg==
X-Google-Smtp-Source: ABdhPJxgcK/l6xCXdtSwCQ40JJUAiVgLKoo4hOU48ZEP4FhEZChYl9Se2TmOgyhEb/6Mbtv9TOME9g==
X-Received: by 2002:a17:90a:1617:: with SMTP id n23mr730023pja.80.1592277932181;
        Mon, 15 Jun 2020 20:25:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n2sm15740871pfd.125.2020.06.15.20.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 20:25:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v4 00/11] Add seccomp notifier ioctl that enables adding fds
Date:   Mon, 15 Jun 2020 20:25:13 -0700
Message-Id: <20200616032524.460144-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

This is a bit of thread-merge between [1] and [2]. tl;dr: add a way for
a seccomp user_notif process manager to inject files into the managed
process in order to handle emulation of various fd-returning syscalls
across security boundaries. Containers folks and Chrome are in need
of the feature, and investigating this solution uncovered (and fixed)
implementation issues with existing file sending routines.

I intend to carry this in the seccomp tree, unless someone has objections.
:) Please review and test!

-Kees

[1] https://lore.kernel.org/lkml/20200603011044.7972-1-sargun@sargun.me/
[2] https://lore.kernel.org/lkml/20200610045214.1175600-1-keescook@chromium.org/

Kees Cook (9):
  net/scm: Regularize compat handling of scm_detach_fds()
  fs: Move __scm_install_fd() to __fd_install_received()
  fs: Add fd_install_received() wrapper for __fd_install_received()
  pidfd: Replace open-coded partial fd_install_received()
  fs: Expand __fd_install_received() to accept fd
  selftests/seccomp: Make kcmp() less required
  selftests/seccomp: Rename user_trap_syscall() to user_notif_syscall()
  seccomp: Switch addfd to Extensible Argument ioctl
  seccomp: Fix ioctl number for SECCOMP_IOCTL_NOTIF_ID_VALID

Sargun Dhillon (2):
  seccomp: Introduce addfd ioctl to seccomp user notifier
  selftests/seccomp: Test SECCOMP_IOCTL_NOTIF_ADDFD

 fs/file.c                                     |  65 ++++
 include/linux/file.h                          |  16 +
 include/uapi/linux/seccomp.h                  |  25 +-
 kernel/pid.c                                  |  11 +-
 kernel/seccomp.c                              | 181 ++++++++-
 net/compat.c                                  |  55 ++-
 net/core/scm.c                                |  50 +--
 tools/testing/selftests/seccomp/seccomp_bpf.c | 350 +++++++++++++++---
 8 files changed, 618 insertions(+), 135 deletions(-)

-- 
2.25.1

