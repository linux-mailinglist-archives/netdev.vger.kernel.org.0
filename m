Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF42E123C09
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfLRA4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:56:40 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33382 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbfLRA4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:56:40 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so229800pfk.0;
        Tue, 17 Dec 2019 16:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AYCZBK/F6WXc/6GYxQqzgfcNB0CkdTjluO37WmZm4bg=;
        b=JMmkHFibHV/Qjd++iy7CzXnIrEWKHwQHiy9ugEV8EdxRMZ5pZAfkGrCxuno8qB7cR1
         2xVSltgvIF+fWOd08xrNSV5Kp17LgCzxaXgp56kMkVsCjgL4ojSSEU0vDq9e8U8A+BbZ
         pknqxT+LrnMobHPcpFLUQfnI2DV67ehyAn1rfU12cH4+mSKOOtnS6i00XGejV1LVQbKk
         IXwGhPNqZPE8qh5t8f7UvQhV1S2d5ebAgtxQ4M/oLvlTe1tW964eFAexw6MczSEYf+yv
         P+YD9/itm8QtCGw+z0p/EuOYEkWnacwMfqZjxvOGHV05gLit/yE/qWtP0am6yvjsmj/B
         HkSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AYCZBK/F6WXc/6GYxQqzgfcNB0CkdTjluO37WmZm4bg=;
        b=ZBWPr/b1BNji9nhSUEbQ7PTpHCavWIHIeYPjnLYggD9oQ8g6Y0keGrFmW/1qdc0prT
         TATXG6pMMV6EriNU3TU3+xOGLChZx+WRGAY9F7E7t/8C+h2hjOZr3ez7L5orxoaVKUvE
         AAwWn+xhcLDkGzVXE/UPkIIE+bcVuSL74r4avRa1ZO7tCzcA24ESQR3oPSk7/nO3WGsY
         mxsgL/Xe9zZ22/sqJdZ3OPkSwmV4uaT2DSYd90Pt9jUl9xwhjbRIyGjd8KIDDUgejQrB
         Md2UqgINZQXO2giWoa4qbkVwLc89DsHWJwEQ9BwdaiVohdEEj2HlIAo9Zq96kCjuFPTr
         pHsg==
X-Gm-Message-State: APjAAAW8xNbyceqewIlwP4EEQxstsNLO88vj6bSXsG3qmemEkx1gQxM9
        8UkXnjfAA32bSznf8WTeo0Axl36OHF8=
X-Google-Smtp-Source: APXvYqy7JR51ctyTBRBHjvDLIPP1yR9e/KW+TDV95QBD2Xu0qDOu5MFxKyA5Jee6TwUu40fS/qU5lA==
X-Received: by 2002:a63:455a:: with SMTP id u26mr343846pgk.282.1576630599365;
        Tue, 17 Dec 2019 16:56:39 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id z129sm278464pfb.67.2019.12.17.16.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 16:56:39 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        bgregg@netflix.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v14 0/2] bpf: adding get_fd_path helper
Date:   Tue, 17 Dec 2019 19:56:27 -0500
Message-Id: <cover.1576629200.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
References: <8f6b8979fb64bedf5cb406ba29146c5fa2539267.1576575253.git.ethercflow@gmail.com>
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

Changes since v13:

* Fix this helper's description to be consistent with comments in d_path

* Fix error handling logic fill zeroes not '0's


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

