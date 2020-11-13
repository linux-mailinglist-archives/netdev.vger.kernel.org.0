Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA8B2B1929
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgKMKgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgKMKgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:36:21 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D3DC0613D1;
        Fri, 13 Nov 2020 02:36:21 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id o15so9224074wru.6;
        Fri, 13 Nov 2020 02:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=jUDWeF9PyT6cRrnNxcegWdDvCpaCTEIRoEvsbbvT65I=;
        b=VsggdTMH87/nqf/cZSQ8mjFNtepxPWyhxQsW6DQyJrdtXRQg3xsJCg0wM7FM4W5DgS
         V0ybfz1ZyEM/S36HZh3MEjbQHsuoi/TSBjXH5MqKxq93Io1IyrJ7/RoAIN4cLredmxOO
         EAO2ujv/a/af75qsrozRY6ovazh6BPcP9piCa6VU0jokaPvVIg1EH+eDQcLw659ehsBd
         hjxgWtf9S7ArqSexscl2pvNzb8qche6Ne3MjcLNgMJOi9wtqwEBUrx59Kof8BaoOlv0a
         oARXAz9nmGOktXzXRY79lI8msgrDyiGE3UvGbBaJvxATsSnvF4kBcR0NwU7pIHL0e5Ho
         l4fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=jUDWeF9PyT6cRrnNxcegWdDvCpaCTEIRoEvsbbvT65I=;
        b=hesJj7HTi1yX1wytRyykvTSCNscas+BY/UZgffd/dVhZGLzBk235jNKL5LTOeoKRct
         UDe88QvzxgmE56J4PY/KfxbMaoYCLKTG8ELEpGsQ5UbwBTuLz3JgPMO3nnGistNM2o1Z
         hqpzk8YD7jgKllTAY1J7i+6q9E12klC3NvrOuqqYlDIGv6WWyv9y/d5pKS1Bqt+Sx9dj
         QWu/6hT/DlQQ3HsxSJUa0vltkBnfmjiwGzlohB36Vaj2uHj/e9KQdJDUl4/dv2gIos9R
         FFLI35ZFtoY8m/cQztMqXFqemSpw0177jV6w3Wy/eR3qDAP0CpxqRk7dpGtUNL/8y/4i
         5BkQ==
X-Gm-Message-State: AOAM5302h2809g1+RVuhWVrHXTagfMi+MM1Pz7ec5uknYlJGtxihystg
        Kg5Qm1EDUHrLDRbfWSY3fXcjuvaPkAr9wZgjxdASnGx1803KxRAb
X-Google-Smtp-Source: ABdhPJyNMtAuROf+KI61o6PimzM1V5kMK2hQvfSbOHiBVVgdPxKgWgl9QVf0tZGgLDU5KHPyJqwTpJJ7m5ofnbmPK4A=
X-Received: by 2002:adf:ed04:: with SMTP id a4mr2754898wro.172.1605263779633;
 Fri, 13 Nov 2020 02:36:19 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Nov 2020 11:36:08 +0100
Message-ID: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
Subject: csum_partial() on different archs (selftest/bpf)
To:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was running the selftest/bpf on riscv, and had a closer look at one
of the failing cases:

  #14/p valid read map access into a read-only array 2 FAIL retval
65507 !=3D -29 (run 1/1)

The test does a csum_partial() call via a BPF helper. riscv uses the
generic implementation. arm64 uses the generic csum_partial() and fail
in the same way [1]. arm (32-bit) has a arch specfic implementation,
and fail in another way (FAIL retval 131042 !=3D -29) [2].

I mimicked the test case in a userland program, comparing the generic
csum_partial() to the x86 implementation [3], and the generic and x86
implementation does yield a different result.

x86     :    -29 : 0xffffffe3
generic :  65507 : 0x0000ffe3
arm     : 131042 : 0x0001ffe2

Who is correct? :-) It would be nice to get rid of this failed case...


Thanks,
Bj=C3=B6rn


[1] https://qa-reports.linaro.org/lkft/linux-next-master/build/next-2020111=
2/testrun/3430401/suite/kselftest/test/bpf.test_verifier/log
[2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.10-rc=
3-207-g585e5b17b92d/testrun/3432361/suite/kselftest/test/bpf.test_verifier/=
log
[3] https://gist.github.com/bjoto/dc22d593aa3ac63c2c90632de5ed82e0
