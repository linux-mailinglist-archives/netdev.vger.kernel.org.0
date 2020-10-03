Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E002822B4
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgJCIzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgJCIzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:55:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C87C0613D0;
        Sat,  3 Oct 2020 01:55:19 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t7so2615440pjd.3;
        Sat, 03 Oct 2020 01:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CoPzDp6vTYT+MKpKb6jQb62M0VDuNLDk+iBziiiNAaU=;
        b=q0n7vZOBi03DDnwDFuHmwxhdkw2ijkvJPRhYQysAqWoI+CjB7SpQpZm3zcdzNDtreC
         ifGuJozhaEeqFoaG+SCVdjzGuYjCF6q+915iY8wtdzbGkJVOJmzgUoBse4bkh/vlq+x1
         ANzqb0J5xYLMti7JdKQTwde8MUwyq2uqHdoWhT634/BJzbb30sgfr+i/HZ2/NPUCxJYc
         tV/6GciseO4RqSsOKzeERxb6i+DlzHkgNmfwllIGOQKNc6bwyggioRXlHhsKAmCm9Prl
         5sZAd7SqajHzIkttt9tOhopB9idtl3pIlTf5BB7l1doHJ2cRCJdGMRDBnENeUBYzLAKw
         Kw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CoPzDp6vTYT+MKpKb6jQb62M0VDuNLDk+iBziiiNAaU=;
        b=i3HE295+NmODVRcnY8ym9BbqlRtYHyC64lH6Gvlouw7qjywPSXejzSdUJS83vqgWGs
         rLFqxGBv7I53PocQlXUJWTU3ECT8fKfEE/Hu7F866jZoyX8o6K7K07g8LTzPJ8r76vii
         /s4hAUhxDnJqh/8jGHrxkrGwvHfCAAMZPINTT5w9bghq1ZzD+vUUFZva3dxw3mjA1sc6
         I5UCLAnDbE3OYbw6rfcab/YLJgaod0ljuQ2Hw6SyHCRyr5FGsPuHUGNJ4BrSw7wjs0jd
         D6hwE8KLRiK/igCT+ohary0oJYkYwT/ZdiRy6Flm+Cn/pSBvmoMK22EpcGU7XS223/U/
         gh1A==
X-Gm-Message-State: AOAM533JE54T3MWt1OYaE7uAS+K/xQjDkIGFDra1nQSZb/vh8sN0CSM/
        CwQlJLqjtzCU2kIF6u6FJ9FggvuHUf5s4w==
X-Google-Smtp-Source: ABdhPJxSiXd4rW1g4cFuBLSsWA/Vj1R1HEOqwL7KTcewEXL1VuxnhkD7Kel7IogIrfRtuhFXznjkzw==
X-Received: by 2002:a17:90a:77c1:: with SMTP id e1mr6479786pjs.39.1601715318712;
        Sat, 03 Oct 2020 01:55:18 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15sm4566374pgi.69.2020.10.03.01.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 01:55:18 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf 0/3] Fix pining maps after reuse map fd
Date:   Sat,  3 Oct 2020 16:55:02 +0800
Message-Id: <20201003085505.3388332-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201002075750.1978298-1-liuhangbin@gmail.com>
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a user reuse map fd after creating a map manually and set the
pin_path, then load the object via libbpf. bpf_object__create_maps()
will skip pinning map if map fd exist. Fix it by add moving bpf creation
to else condition and go on checking map pin_path after that.

v2:
a) close map fd if init map slots failed
b) add bpf selftest for this scenario

Hangbin Liu (3):
  libbpf: close map fd if init map slots failed
  libbpf: check if pin_path was set even map fd exist
  selftest/bpf: test pinning map with reused map fd

 tools/lib/bpf/libbpf.c                        | 80 +++++++++++--------
 .../selftests/bpf/prog_tests/pinning.c        | 46 ++++++++++-
 2 files changed, 91 insertions(+), 35 deletions(-)

-- 
2.25.4

