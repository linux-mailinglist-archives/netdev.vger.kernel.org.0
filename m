Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811791227E2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfLQJr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:47:29 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34465 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQJr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 04:47:29 -0500
Received: by mail-pj1-f66.google.com with SMTP id j11so4347496pjs.1;
        Tue, 17 Dec 2019 01:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jGcLkmjhRjvareg7w21LXjb/4h49SxcikHdUgQxGOHI=;
        b=R1QSvR0sP1P0BRRixAxzoH9J+XQKtNeQRXDWfabhnIqVKuNrLGWfgFxO2ZI8BwYtJZ
         FhOFo3+nBSaPyQdSqSTX9gC6QAOjL0uxasAfBXfgmGOPGMqkBdc/WCMVj3IGqWpPJmP8
         345Q47pEUtiT5Jexz9uHJdcC9pS8opJTV2++UUd62PL7WsmcO1DRjOivd+5aqS0aIjud
         nLjAC9iE6Zb8h9eZX26YKvf+mFhg3pQ3UV/J+ljsvJ/3sOHrJYZX/XSGIbf5+B+XNKSG
         XJyd/D1tCEqhjl+IXQOQOd6EcQ5TKPfhbkRQHaXN/bGHpg4l3vBLxYK0dB4aOMCkZ3rg
         IAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jGcLkmjhRjvareg7w21LXjb/4h49SxcikHdUgQxGOHI=;
        b=Ouy8Uz4Ii6M52ahv0LzcWLuap19ALmKTKbu1lseW/domeHuP8fQYNtwxHhxf8C1Z66
         5PJOml1BB1VBk4rAZy5J5bDYY0ufiRlEcCzve1pKeZp795/QMycDv7mPsM5+h3IHS9x+
         iaGex9LuJP9y6zioqnhdrtlh1iKVCr4m1DeKE/5pwoKxfb3L0ghZnszsoleWvSYOGd49
         sws+3hU04+LA0dkh9IkP8wR6H8QkQB2gyZ4/k8GJI6lPwV5UcClrtTwWFKo9h3wmOEHP
         62ov/BEcnCIQpoiQBY3ESjvTGVDwSS12nuKTYx+AfzSSiUZglogMAIhm1K5145XXxaRC
         3jgQ==
X-Gm-Message-State: APjAAAUFr9H8sA/v7iIzupRL2w/9eQJ/4YbKdr+V4JSfTlDOAMOU/5Z7
        StHq7IggxMPksyQU1tDP1LfXZ8h8u+Gfgg==
X-Google-Smtp-Source: APXvYqy1XB5SctobybbeNPKtZ49fdzlgFbsnzWjH3al+GNLAapdQT/aY/hQqY1q6fThsKmeExXFsaQ==
X-Received: by 2002:a17:902:9302:: with SMTP id bc2mr21891913plb.148.1576576048379;
        Tue, 17 Dec 2019 01:47:28 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id o8sm2595978pjo.7.2019.12.17.01.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 01:47:27 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        bgregg@netflix.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v13 0/2] bpf: adding get_fd_path helper
Date:   Tue, 17 Dec 2019 04:47:15 -0500
Message-Id: <cover.1576575253.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
References: <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
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

Changes since v12:

* Rename to get_fd_patch

* Fix test issue on big-endian machines


Changes since v11:

* Only allow tracepoints to make sure it won't dead lock


Changes since v10:

* Fix missing fput


Changes since v9:

* Associate help patch with its selftests patch to this series

* Refactor selftests code for further simplification  


Changes since v8:

* Format helper description 
 

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
  bpf: add new helper get_fd_path for mapping a file descriptor to a
    pathname
  selftests/bpf: test for bpf_get_fd_path() from tracepoint

 include/uapi/linux/bpf.h                      |  29 ++-
 kernel/trace/bpf_trace.c                      |  69 +++++++
 tools/include/uapi/linux/bpf.h                |  29 ++-
 .../selftests/bpf/prog_tests/get_fd_path.c    | 171 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_fd_path.c    |  43 +++++
 5 files changed, 339 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_fd_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_fd_path.c

-- 
2.17.1

