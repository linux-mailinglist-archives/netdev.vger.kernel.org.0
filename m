Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311C2242244
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 00:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHKWEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 18:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgHKWEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 18:04:32 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B5BC06174A;
        Tue, 11 Aug 2020 15:04:32 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v15so7288342pgh.6;
        Tue, 11 Aug 2020 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=ma0c9whmshvrI6ZYCGlJjDy8m+CBdr+9jORpR5LDtRM=;
        b=e/j9OVVLFdWf5BfeP+b3OLkieoTNmqfkGlf7Q/QWKJ0GR0GLy2/iKjkFKYU75QsKln
         tVkVCeFUtif7i/NOXYQyrjBm0iobhDnlXyHSGJ0cxS+1TqkOd+D2zjFCSYQCc3a3+N6W
         idIzYHktzIv5bo+SMWNdEDKXb7ggrTOUgN2THzKb5NvtUTaVWNcGZCsffjNQ/ebZAXhz
         +bzDiahMa1Wcw/pa4DIO8jArkXeSCicBWUicAJdF8Gni3T8s87Wzxy+5pvG9pe0gMv6l
         noOiTCvjBaj+zn8qNLVps7u9H42oqmSPcfFrWgqlieiaC/gh5V4dFWfL4RO/rEzXckyK
         KnSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=ma0c9whmshvrI6ZYCGlJjDy8m+CBdr+9jORpR5LDtRM=;
        b=sGnHj/2u7N76NsIxpl7ISfVOobsKiQ/vIsoCSRTSk2ZGphER7iY6cUNJKxPa1HBRwp
         /dgAw6u6LNQSgaO9a9gpU7rRf7D34+KCLdl9oEPy8If8SDAo1ChPBZ1ppdOHncpoQzGa
         keC8ON5eEXwyATPqPa3xOIL5mPkS/Nze18PTB9wRP2GJgkpbcQkMROXZfkmKKhCEFAHx
         jwg+nfOIbNBdN00wwzacuM5IYvUB4UhaAcbmrSiLmJSlIOeHqCtZoVvtR0ipBKM0orr6
         PIukGC7qK33dRPtToRK8O7+0Ue4oNcqU3cigk/VS2Cy5F2Yc7upz/x1P/FYXxpw4186C
         tM1w==
X-Gm-Message-State: AOAM531NBruVAnrIgQdXx6z8szI6R1/jKah+7jvuLji/Cb4BnKC3FQC8
        ybTYcHF39iEvfCG2J4tqiYs=
X-Google-Smtp-Source: ABdhPJwC4lIhHlHM2TvJntuwjH0ABVuIiz3LwvDQU1PrksnY1rgaRGTSS6BEpbC617UkWGY2LEK7eA==
X-Received: by 2002:a65:6287:: with SMTP id f7mr2508291pgv.307.1597183471755;
        Tue, 11 Aug 2020 15:04:31 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x12sm68753pff.48.2020.08.11.15.04.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Aug 2020 15:04:31 -0700 (PDT)
Subject: [bpf PATCH v3 0/5] Fix sock_ops field read splat
From:   John Fastabend <john.fastabend@gmail.com>
To:     songliubraving@fb.com, kafai@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 11 Aug 2020 15:04:18 -0700
Message-ID: <159718333343.4728.9389284976477402193.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Doing some refactoring resulted in a kernel splat when reading sock_ops
fields.

Patch 1, has the details and proposed fix for sock_ops sk field access.

Patch 2, has the details and proposed fix for reading sock_ops->sk field

Patch 3, Gives a reproducer and test to verify the fix. I used the netcnt
program to test this because I wanted a splat to be generated which can
only be done if we have real traffic exercising the code.

Patch 4, Is an optional patch. While doing above I wanted to also verify
loads were OK. The code looked good, but I wanted some xlated code to
review as well. It seems like a good idea to add it here or at least
shouldn't hurt. I could push it into bpf-next if folks want.

Patch 5, Add reproducers for reading scok_ops->sk field.

I split Patch1 and Patch2 into two two patches because they have different
fixes tags. Seems like this will help with backporting. They could be
squashed though if folks want.

For selftests I was fairly verbose creating three patches each with the
associated xlated code to handle each of the three cases. My hope is this
helps the reader understand issues and review fixes. Its more or less
how I debugged the issue and created reproducers so it at least helped
me to have them logically different patches.

v2->v3: Updated commit msg in patch1 to include ommited line of asm
        output, per Daniels comment.
v1->v2: Added fix sk access case

---

John Fastabend (5):
      bpf: sock_ops ctx access may stomp registers in corner case
      bpf: sock_ops sk access may stomp registers when dst_reg = src_reg
      bpf, selftests: Add tests for ctx access in sock_ops with single register
      bpf, selftests: Add tests for sock_ops load with r9,r8.r7 registers
      bpf, selftests: Add tests to sock_ops for loading sk


 net/core/filter.c                                  |   75 +++++++++++++++++---
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |   41 +++++++++++
 2 files changed, 103 insertions(+), 13 deletions(-)

--
Signature
