Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77DD6B27CE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 15:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjCIOwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 09:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbjCIOwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 09:52:05 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C865FCC
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 06:50:21 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-1767a208b30so2559305fac.2
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 06:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1678373420;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pd3Lkot3b9xUlf3dAcLlAT6oagcWYg/ttZtHlyeFJuA=;
        b=XguBoN4c3w1EVz2TKdJNXfaRnsWcFj+3h7Sri2mnrra4n1lMANrVVw5hQhqNyHynK1
         k2/wgRUCHAqSMlsI/fbWbg1wtroyhlH9ClfpzwRtU3lJ+RJkaoyRIBZ8hADXb40oWnP0
         Fuevm9l6l6zuukDFqZRNy5M0st17lcjINX8PNXE71QpU7+NJH13kAEjGoS2yF9DAaeVy
         hMhujEqq56L6Etm+CY7U4bGM3meZ3VZQDibsQR7XyCG0zcJCX/l/7SyQCakia0zqAJv8
         Il9lvmy9IwnQ+F79LBx9YUbYxGIWwjXs9RlckvlAWnfDEI9CaVayn0V1k6Bdho9koQl2
         svmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678373420;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pd3Lkot3b9xUlf3dAcLlAT6oagcWYg/ttZtHlyeFJuA=;
        b=DJg90J0QuKjgP+Cml1HCZjVYV+faFYqfHjwjt6UroaEkTxZuGwL8e12vLlOnImRx4+
         vzWklNhLc5SIJO9CfAjdbJ6i99ov944hQsMtJgwm8+LqtEZDaJ42w5WpMDvFsipcMM89
         4nG5gJ3KBH9FnzDCMERRfH5D+OwZA5qATBNSj+IaS7ku4KqgqG9eiy2Xme7gQbPeie3h
         kWggiQ16TuhsXsLQQi2XPQzVcI4/rnXyHMc0tVS79aIZWZB4IkWdPXdG3ljGQ3+7B9PQ
         JqwsdliW90v+b2dCxmi5bMtttyjbdCC+s+Hiz0zS1/hJvfQtmyZ9V8oOUpbqsjtOgBWQ
         24Cg==
X-Gm-Message-State: AO0yUKWs455Ql/DU/ebsiTM66x31jpjUbSbeAftTBdtNQRm9UnQrBHfd
        VKABIiWBxk5PED6yg/Dg1Z62yQ==
X-Google-Smtp-Source: AK7set8xW0L9dkcHq5g5ySMDfkDxpoazn3bl3Z3RUPUkkhBfK6L9OQtJMDXf/DF4tSrzNjWzqVmb4g==
X-Received: by 2002:a05:687c:19c:b0:172:4240:f224 with SMTP id yo28-20020a05687c019c00b001724240f224mr572178oab.18.1678373418243;
        Thu, 09 Mar 2023 06:50:18 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id ax39-20020a05687c022700b0016b0369f08fsm7351116oac.15.2023.03.09.06.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 06:50:17 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net v2 0/8] mptcp: fixes for 6.3
Date:   Thu, 09 Mar 2023 15:49:56 +0100
Message-Id: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABTyCWQC/5WOwQ7CIBBEf6Xh7Cqlmjae/A/jYUu3lkMpYZFoG
 v5d4ODd48zbmZ1dMHlDLK7NLjxFw2azWahDI/SC9klgpqyFkqqTSvXwchw84QqWAvzc1QXtYDZ
 vYtC6H+YO1XwZlcg9IzLB6NHqpTTl3ESxxE8rGlsunKcazfheuHhkczEcNv+py2Jb0R8jYgsSZ
 C+pk0hnHOgWiBk98bE+SCl9AbE4x8X8AAAA
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <martineau@kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>, stable@vger.kernel.org,
        Geliang Tang <geliang.tang@suse.com>
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2908;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=eJfqegXakEakPpXnWf87SdzqEbYoKrFI19FY/itAd28=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkCfIhXcnZ5ZKt/o/UUyrdQcd85f2M6UnxDt9d2
 ec5EeELVvuJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZAnyIQAKCRD2t4JPQmmg
 c72nEACeRBMVD2sAi3192xUCYkclJkbIcz0MIm3veGwJgdYvodHnBs9LAn5x29IGjvnvY8ZRJz3
 dlmDwMDMwvLVvt4LsS3sU/ZC5Il1EJIx/w4QZFaOO3f5DCKviEX5b4yjtcYFsYUSpkf/1B9fKvV
 Two7LCfQMGlOK0QjBgFDCtPf+GgPe8jkoc83mP9a69Ab2E2eKkn6gzOUfUGFjYmeT7/BKdocUfn
 yiVMGR5X3YBbnBNIMoT0peQ+TmHbi/ZfonqC4XtpQTMHIHMZ+ITUuW6k6T420dTDOKysHhpfZgv
 8mTpk0+UqIy2zeqtSEd/8c46i7nPASDd9Uhapk3avT7LMkndSn4o32fpvh5oOTRAA3YI+1P7szO
 5oLUctP7XCBxMAzVgtLM7uAp35NQOx9IFYPg3Kk2LrqG8oypW3NWSyfMLxLAdB2B75yBluZ373A
 ncGvPs4V1Yg9EtbW3r7vHWeyfvT6jZO9Srvl3rABBvVm+7xqjg0UOOm3NhZAcwf7pAgDy/MtW5L
 ej9BiWeZY/FdRapKR80iFVZCJoJUZeWmJL51OvhvQa6r0lGPc2ow+ueuxU53lC1GrDOPB9C/W81
 QAd3AyUY13rAfSeQMare7cUXGn4rnWdAJlrNuTLhqB5yQyMHDM0rcO0gzadzXPu8+dYLyp8kKM+
 cEKi5S4c+KluQJA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 fixes a possible deadlock in subflow_error_report() reported by
lockdep. The report was in fact a false positive but the modification
makes sense and silences lockdep to allow syzkaller to find real issues.
The regression has been introduced in v5.12.

Patch 2 is a refactoring needed to be able to fix the two next issues.
It improves the situation and can be backported up to v6.0.

Patches 3 and 4 fix UaF reported by KASAN. It fixes issues potentially
visible since v5.7 and v5.19 but only reproducible until recently
(v6.0). These two patches depend on patch 2/7.

Patch 5 fixes the order of the printed values: expected vs seen values.
The regression has been introduced recently: v6.3-rc1.

Patch 6 adds missing ro_after_init flags. A previous patch added them
for other functions but these two have been missed. This previous patch
has been backported to stable versions (up to v5.12) so probably better
to do the same here.

Patch 7 fixes tcp_set_state() being called twice in a row since v5.10.

Patch 8 fixes another lockdep false positive issue but this time in
MPTCP PM code. Same here, some modifications in the code has been made
to silence this issue and help finding real ones later. This issue can
be seen since v6.2.

Note that checkpatch.pl is now complaining about the "Closes" tag but
discussions are ongoing to add an exception:

  https://lore.kernel.org/all/a27480c5-c3d4-b302-285e-323df0349b8f@tessares.net/

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
Changes in v2:
- Patches 3 and 4 have been modified to fix the issue reported on netdev
- Patch 8 has been added
- Rebased
- Link to v1: https://lore.kernel.org/r/20230227-upstream-net-20230227-mptcp-fixes-v1-0-070e30ae4a8e@tessares.net

---
Geliang Tang (1):
      mptcp: add ro_after_init for tcp{,v6}_prot_override

Matthieu Baerts (2):
      selftests: mptcp: userspace pm: fix printed values
      mptcp: avoid setting TCP_CLOSE state twice

Paolo Abeni (5):
      mptcp: fix possible deadlock in subflow_error_report
      mptcp: refactor passive socket initialization
      mptcp: use the workqueue to destroy unaccepted sockets
      mptcp: fix UaF in listener shutdown
      mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()

 net/mptcp/pm_netlink.c                            |  16 +++
 net/mptcp/protocol.c                              |  64 +++++------
 net/mptcp/protocol.h                              |   6 +-
 net/mptcp/subflow.c                               | 128 +++++++---------------
 tools/testing/selftests/net/mptcp/userspace_pm.sh |   2 +-
 5 files changed, 95 insertions(+), 121 deletions(-)
---
base-commit: 67eeadf2f95326f6344adacb70c880bf2ccff57b
change-id: 20230227-upstream-net-20230227-mptcp-fixes-cc78f3a2f5b2

Best regards,
-- 
Matthieu Baerts <matthieu.baerts@tessares.net>

