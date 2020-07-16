Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7312226E6
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgGPPXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:23:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59838 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729169AbgGPPXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:23:11 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <seth.forshee@canonical.com>)
        id 1jw5j3-0003HU-5p
        for netdev@vger.kernel.org; Thu, 16 Jul 2020 15:23:09 +0000
Received: by mail-il1-f198.google.com with SMTP id v12so3927811ilg.2
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 08:23:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=1/qolDFvhpKVU/laUVqhlu2vl5yv7xqj8R5RCMHuoAE=;
        b=ltjNcmg1fLNwMokpnHoDx2bqoZyjmz0s6Akqi3dXR29oh7YzL4cEAAgoojQxsWJwrn
         LaUYykJbQx2NoBX8cvqSLFnMBWMuixiE+m8AeIMi+Sf04l15m62JjOn3jNKK/ALnUCmV
         33vSziirt7RbBkWGAxvvmi9dKOiwRpAVooO/9CDsNIwLvnmXWPC2+fCFkmP6i6C5mE81
         yD5SkhU3LquXoeKUvzYhgicaFBmWDd39zskv/dMAS2Oww9JDYqjxh2v+DD7monKH05fq
         s1ILQKJe/i7GVx5tGI62pAJbd3f5m9HE4l68nMmVmR/DlXGX6t1Gs43qbSuPmQoUpqHZ
         VrBQ==
X-Gm-Message-State: AOAM5339kkA4VrXcbJFozegQVv2uzcm6Q1Sn2kjd/bCou67gnSt3ENNg
        cD/05SlxyIM+IV23riDgcwstbIWE7iUX1OufLex0NSQ8RdVji5rShS7hEZWTL3bisiha61kAF64
        fMDmE90CZE6iVM9p60BWMlMtfG9OcKoX9qQ==
X-Received: by 2002:a92:9144:: with SMTP id t65mr4972490ild.157.1594912987980;
        Thu, 16 Jul 2020 08:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrcNPFqPdPzXrKIfmDcBgzmn7KYvCBmjSXDPrxbfaGjS57nLBMFDU5BF5DLJu0FIUjZaBEMA==
X-Received: by 2002:a92:9144:: with SMTP id t65mr4972471ild.157.1594912987705;
        Thu, 16 Jul 2020 08:23:07 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:90fa:132a:bf3e:99a1])
        by smtp.gmail.com with ESMTPSA id o67sm2764824ila.25.2020.07.16.08.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 08:23:07 -0700 (PDT)
Date:   Thu, 16 Jul 2020 10:23:06 -0500
From:   seth.forshee@canonical.com
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: test_bpf regressions on s390 since 5.4
Message-ID: <20200716152306.GH3644@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tests in lib/test_bpf.c were all passing in 5.4 when using the JIT,
but some are failing in 5.7/5.8. Some of the failures are due to the
removal of BPF_SIZE_MAX causing some expected failures to pass, which I
have already send a patch for [1]. The remaining failures appear to be
regressions. I haven't tried 5.5 or 5.6, so I'm not sure exactly when
they first appeared.

These are the tests which currently fail:

 test_bpf: #37 INT: MUL_X jited:1 ret -1 != 1 FAIL (1 times)
 test_bpf: #42 INT: SUB jited:1 ret -55 != 11 FAIL (1 times)
 test_bpf: #44 INT: MUL jited:1 ret 439084800 != 903446258 FAIL (1 times)
 test_bpf: #49 INT: shifts by register jited:1 ret -617 != -1 FAIL (1 times)
 test_bpf: #371 JNE signed compare, test 1 jited:1 ret 2 != 1 FAIL (1 times)
 test_bpf: #372 JNE signed compare, test 2 jited:1 ret 2 != 1 FAIL (1 times)
 test_bpf: #374 JNE signed compare, test 4 jited:1 ret 1 != 2 FAIL (1 times)
 test_bpf: #375 JNE signed compare, test 5 jited:1 ret 2 != 1 FAIL (1 times)

Thanks,
Seth

[1] https://lore.kernel.org/lkml/20200716143931.330122-1-seth.forshee@canonical.com/
