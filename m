Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E6D653CF
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfGKJb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:31:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41026 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKJb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:31:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so2289640wrm.8;
        Thu, 11 Jul 2019 02:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=l4bEEAxzGIGnFBD/3jElNFp34ehWwPy0iGMb60Ja/qM=;
        b=LGEXirOw0aMcPgnorDYhAX95/V+nn+qMQkpvwFvcG/FKF+nsqfqBtq+YBr9sTW7cs+
         bicPHQ2DJeSeAt6FDWRizzeeEA0VSBSdFMdFN+GDwcL1yoln61rRciCl6pqBOlYWjOGD
         x1jm8zjeksPQFNvU0SzDa78BuYHqjMKZ8FUaj+IzVIWNN76JyIgFR/cAf4m7KpdCD2HX
         aeFCy8aUdVcvd/S+QZURH1POYFXsDHEF+8cxBT0ZBUZJXNNCJvDh5Q06q7cMUrKeRkyX
         0eVVCePqlrXqanKMOhDOuQf4ZQ5tRCUBsavFILtljXTueQGq3oA+0TsS2UkuXe4e7bVg
         oTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l4bEEAxzGIGnFBD/3jElNFp34ehWwPy0iGMb60Ja/qM=;
        b=F3H350j8dZdyREHovHQ6zb4iU67gsi2H8IqmhouhtajueAP+dTlPQJu9ZnyYMETNEb
         spoqk0zacQdqRGockF8NNTCWhyUQ3FrKajML0CcIdPUlt9reqU956Qa9/BOdlGmCCb+9
         BL+GpYvxQG83ZIyaVW+Uq7029xMDIosx9uDSQ8ln5ttPBJZA6WFnu4Dmu6ciiTM0vPPY
         zEwTc+bzIOVY4unw+IV0EZYKuMn58pB+cxuW0K4fPWsfUpux8hWcx6sqv1u6cpairX6C
         gngge1arf++FjFjGOZ1HFQPNpzYVKWec1FrAthFFvg4bKNPJTQey6pHuhM4rOAI5brIB
         4cOQ==
X-Gm-Message-State: APjAAAVKSSWjpGF5WKBuBRwW/UKLUrPUiJRde9nGQ/Ia9SVLZRuPqyDX
        eNnFWISnomEbU82isgJuiavQ+X44b6I=
X-Google-Smtp-Source: APXvYqz0OXD69emcOGH46hrtIm+cwY/xRJ7bJg/E0Xtb/ywPVDEIQWoLL7zGB5vyW+suzm7/ZgNwZw==
X-Received: by 2002:adf:db0b:: with SMTP id s11mr3967901wri.7.1562837515183;
        Thu, 11 Jul 2019 02:31:55 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id r123sm5074455wme.7.2019.07.11.02.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:31:54 -0700 (PDT)
From:   Paolo Pisati <p.pisati@gmail.com>
To:     --in-reply-to= <20190710231439.GD32439@tassilo.jf.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fold checksum at the end of bpf_csum_diff and fix
Date:   Thu, 11 Jul 2019 11:31:51 +0200
Message-Id: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

After applying patch 0001, all checksum implementations i could test (x86-64, arm64 and
arm), now agree on the return value.

Patch 0002 fix the expected return value for test #13: i did the calculation manually,
and it correspond.

Unfortunately, after applying patch 0001, other test cases now fail in
test_verifier:

$ sudo ./tools/testing/selftests/bpf/test_verifier
...
#417/p helper access to variable memory: size = 0 allowed on NULL (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0 
#419/p helper access to variable memory: size = 0 allowed on != NULL stack pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0 
#423/p helper access to variable memory: size possible = 0 allowed on != NULL packet pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0 
...
Summary: 1500 PASSED, 0 SKIPPED, 3 FAILED

And there are probably other fallouts in other selftests - someone familiar
should take a look before applying these patches.

Paolo Pisati (2):
  bpf: bpf_csum_diff: fold the checksum before returning the
    value
  bpf, selftest: fix checksum value for test #13

 net/core/filter.c                                   | 2 +-
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.17.1

