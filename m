Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E938E6B156
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbfGPVrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:47:53 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:37947 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbfGPVrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:47:52 -0400
Received: by mail-qt1-f174.google.com with SMTP id n11so21230591qtl.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=rYIv3+f+Wpfnr6NMWCcYLn28y9wrn6a9ojz4c0/+KO0=;
        b=F9QFNRkAj2AxjYTP3v86UzDM1ywEdAFCZVmWrPun7wyBJ/TR3zzJ3lz6DfpmqjzJ2N
         KIJZkSz3rB2cjFNCPF281hvzaUvyn6/aYJPIMY5FVdRUlsGWzbQ9Y8TkcGLvgVJYq5yH
         aiYyPVvmnAJpCUkxriMBcOZrdBT1lkRA0Qz4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=rYIv3+f+Wpfnr6NMWCcYLn28y9wrn6a9ojz4c0/+KO0=;
        b=mfi4wBwoY8Zy+YlPqRNpO008oO4fu5P52X5cfgaXlF9plYAwbECJv0TeA1VNXWX2BL
         zQmQPftwS37idjmLZ+PYXx+A0gTH73SNeTdUsyFJIbsRocwL3376ouLG4HNg7gM92wG0
         KrLcE9omweHlDVSs8+XtDrbKelb66U/tQ99RUnXW99CO+WQyT7vBm+K5Dco+GPEfzFWm
         OyFTsYnRKk4d7z4NjO6f6x8SxR1hSsCnvjQ0Mex55Qe9TG0hX1QFSu6oLmhKmvNaWX9c
         rjnXwd/T3yxYhB5ssQ5ZfwAJGI0j9JTLM+CdMpKl7drpHBLqcDEtRiw9tCYR/c3ejlfg
         8STA==
X-Gm-Message-State: APjAAAXZLp7nazFYyZstA9vTOUsGzAODPGa7BgjkqHZpoifxWpuPsr0U
        lDqE1bWELvp6M0RNEWbV7Lp58tfh7aKLqcynzc1QBOkTn7bgw68+
X-Google-Smtp-Source: APXvYqzk2ElYGbmGXakeEof2T6vw9TA+aJreKVj8sfbINfaag8CkplmHATB4jdl8o6M8mE9LH4hDIawBSFfrZ16WjbI=
X-Received: by 2002:ac8:d8:: with SMTP id d24mr25266793qtg.284.1563313671878;
 Tue, 16 Jul 2019 14:47:51 -0700 (PDT)
MIME-Version: 1.0
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Tue, 16 Jul 2019 23:47:40 +0200
Message-ID: <CAJPywTL5aKYB40FsAFYFEuhErhgQpYZP5Q_ipMG9pDxqipcEDg@mail.gmail.com>
Subject: OOM triggered by SCTP
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-sctp@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Morning,

My poor man's fuzzer found something interesting in SCTP. It seems
like creating large number of SCTP sockets + some magic dance, upsets
a memory subsystem related to SCTP. The sequence:

 - create SCTP socket
 - call setsockopts (SCTP_EVENTS)
 - call bind(::1, port)
 - call sendmsg(long buffer, MSG_CONFIRM, ::1, port)
 - close SCTP socket
 - repeat couple thousand times

Full code:
https://gist.github.com/majek/bd083dae769804d39134ce01f4f802bb#file-test_sctp-c

I'm running it on virtme the simplest way:
$ virtme-run --show-boot-console --rw --pwd --kimg bzImage --memory
512M --script-sh ./test_sctp

Originally I was running it inside net namespace, and just having a
localhost interface is sufficient to trigger the problem.

Kernel is 5.2.1 (with KASAN and such, but that shouldn't be a factor).
In some tests I saw a message that might indicate something funny
hitting neighbor table:

neighbour: ndisc_cache: neighbor table overflow!

I'm not addr-decoding the stack trace, since it seems unrelated to the
root cause.

Cheers,
    Marek
