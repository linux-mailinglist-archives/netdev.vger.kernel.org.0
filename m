Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B249111F57F
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 05:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbfLOEB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 23:01:28 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42568 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfLOEB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 23:01:28 -0500
Received: by mail-pg1-f194.google.com with SMTP id s64so1665146pgb.9;
        Sat, 14 Dec 2019 20:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QR0bvt2FWd49PnT/6EPvzh3QxhXxfa7a4OnFa3iFVqo=;
        b=WcVqqnekeuTfzHfcjpq+GtgAoIwM9ujX9ttoQYwCOaJ94q508yWeSqF1NG6cIjISaY
         YB/Z/nyGHB7z8wvk1IfOnWJuZhav3x11rlrxmrqkdG4nxfe7j06zeNU+prnvCvyOuqj3
         a/TeqR9CehMEg3LLPaeihFtJjaO3qspt8chUOp1UmnmEGDoga1cVuSHs5DlBmmWhAW8W
         3OO8AoZGEM6prSSzySyDLpwWr/twlfoaFobRVpyueNTGXM/dirLyjRcyvQINMQfagwGE
         DAIaXgB7/nciR1/cdhFgzwykcQObzV/I0aZUB7xjZj//cMp/99QzFh7voT3tqMKImcEf
         AKKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QR0bvt2FWd49PnT/6EPvzh3QxhXxfa7a4OnFa3iFVqo=;
        b=gFykYIU/V+xJJ1aLsJR0XsG1Stv3DWTuFrTxwtxCnX1dO002E8TQC47WuNph1dLoxm
         42H3TJfcdaV47RlnvPywPJxgLlLmOu46ZExxG70qk8cygXezqgS6voTLJJT09tg1hGUK
         JlTvJQjnWV4lnXhliKF4VMsepyWZiXB24d4UBJ6eMThsCOUy2LzWABUoKGQ+tS83dVnz
         l1q2frWtmvomfT/JASRMIW1QchTViT3oqX/oB4IUgOgOcBpnKHZUJ8IEV46DSCNW0cLV
         86jBHndRX1erRVetEmSNaqnBRVWzkOGq3c7y5anLeXgMzRteuxz2aP4VIV3BHkm17Avr
         Eung==
X-Gm-Message-State: APjAAAXeVyChyiZvCcMOw211fI2pC/tIzh+HSUUwL3jb2/oz7VdVcRyK
        kouB9kW0qN5v0p0EnZpfQWPeVM9XDPoIKA==
X-Google-Smtp-Source: APXvYqza+EEkyYBOucCpe80baAH/T2EFDxLom0+12l7h4s60i07vYiYtfsrWcFi5fkjKbLj6ftY2rg==
X-Received: by 2002:a63:ea4b:: with SMTP id l11mr9737543pgk.357.1576382487115;
        Sat, 14 Dec 2019 20:01:27 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id o12sm14586002pjf.19.2019.12.14.20.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 20:01:26 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: [PATCH bpf-next v12 0/2] bpf: adding get_file_path helper
Date:   Sat, 14 Dec 2019 23:01:08 -0500
Message-Id: <cover.1576381511.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
References: <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduce a bpf helper that can be used to map a file
descriptor to a pathname.

This requirement is mainly discussed here:

  https://github.com/iovisor/bcc/issues/237

This implementation supports both local and mountable pseudo file systems,
and ensure we're in user context which is safe for this helper to run.

Changes since v11:

* only allow tracepoints to make sure it won't dead lock


Changes since v10:

* fix missing fput


Changes since v9:

* Associate help patch with its selftests patch to this series

* Refactor selftests code for further simplification  


Changes since v8:

* format helper description 
 

Changes since v7:

* Use fget_raw instead of fdget_raw, as fdget_raw is only used inside fs/

* Ensure we're in user context which is safe fot the help to run

* Filter unmountable pseudo filesystem, because they don't have real path

* Supplement the description of this helper function


Changes since v6:

* Fix missing signed-off-by line


Changes since v5:

* Refactor helper avoid unnecessary goto end by having two explicit returns


Changes since v4:

* Rename bpf_fd2path to bpf_get_file_path to be consistent with other
helper's names

* When fdget_raw fails, set ret to -EBADF instead of -EINVAL

* Remove fdput from fdget_raw's error path

* Use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
into the buffer or an error code if the path was too long

* Modify the normal path's return value to return copied string length
including NUL

* Update helper description's Return bits.

* Refactor selftests code for further simplification  


Changes since v3:

* Remove unnecessary LOCKDOWN_BPF_READ

* Refactor error handling section for enhanced readability

* Provide a test case in tools/testing/selftests/bpf

* Refactor sefltests code to use real global variables instead of maps


Changes since v2:

* Fix backward compatibility

* Add helper description

* Refactor selftests use global data instead of perf_buffer to simplified
code

* Fix signed-off name


Wenbo Zhang (2):
  bpf: add new helper get_file_path for mapping a file descriptor to a
    pathname
  selftests/bpf: test for bpf_get_file_path() from tracepoint

 include/uapi/linux/bpf.h                      |  29 ++-
 kernel/trace/bpf_trace.c                      |  70 +++++++
 tools/include/uapi/linux/bpf.h                |  29 ++-
 .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
 5 files changed, 340 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c

-- 
2.17.1

