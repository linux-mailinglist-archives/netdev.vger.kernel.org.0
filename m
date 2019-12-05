Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B40113ABC
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 05:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfLEEUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 23:20:46 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46783 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbfLEEUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 23:20:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id z124so933369pgb.13;
        Wed, 04 Dec 2019 20:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SpgP0Yzf0I5ADZzkonZdC2K+bC/OvsRIZPIGAvUm8ig=;
        b=dBIFksDKVzmYd2Xt0J5ccHeN7ObFGdBn4bpuuueT7RIC5ZucTxibQ0Hw6NwwvzAruH
         icQjYr+RDX1VZ+3dkqYodKZI9B/MCaHLC18/xuIQTWxtBSDRgGOMgDIoPq2ww8x4a1xe
         aFapttVShPXxRLncIYEbwFNjLwQVcFMT/iqCP/boKpN8rotjzdj0bXzUZSEDRqv9z13W
         8c1EllKPZgha/nMGxDlqIOyqqa9fgglALhQpsmk6yT7A+Fzd/KzPyPS9fPRfAnV1mqYO
         J7Oj+3EkPMQ5Eag15FQ+A36TyUWu8t1sE+rGSwMiaPsEgFrpsQdzWcroYb2hE9lPJ4ET
         RCcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SpgP0Yzf0I5ADZzkonZdC2K+bC/OvsRIZPIGAvUm8ig=;
        b=bUy0mn7i3RgXhl7HrPDOqleHUucPXz9NG02W+V8KlE/bGOsxGGiK/NPE0hIrVvfVGS
         5o4HNZLk8mxbBTvbCmd3utN4heyM5nxjpkRO3FcVACDbBhR4Sx3h7LaORQ2oVQkD9932
         noDT5lkOMh44UbfE/WK5gX0u2rNf1vOYSpcZ11f9vWpaDEgzcDYU98pH0NS4D8zSz4Xq
         EMBjwl3lAxniyxEIStnjfRsFKY8O4haJYURPb+dwZ8gUOCLBA4J7i6LpWKQC7JJfLuU7
         kN0gmOzyFE6iGNXvavMQd+Hdo/UYsEFXWS1HvH1su2fQ/2IRF/npFCvNbtoAb5uvl/dv
         2ndQ==
X-Gm-Message-State: APjAAAXQLd3ljGEIWPW7c+tYJS4eEqwx1OxH0LADx76x1+LvmC6sJ1kA
        x4459jQH1M1czURUyt81jLWBYrc43favuA==
X-Google-Smtp-Source: APXvYqyzfaD3A+PNQuttEzJlx/kMP72WniZ6RNQzhkSXGQO9rqf+d6XdMudHNI17bu0Cm1gTZ7rd2Q==
X-Received: by 2002:a63:4e22:: with SMTP id c34mr2021212pgb.214.1575519645103;
        Wed, 04 Dec 2019 20:20:45 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id n26sm9303964pgd.46.2019.12.04.20.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 20:20:44 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: [PATCH bpf-next v11 0/2] bpf: adding get_file_path helper
Date:   Wed,  4 Dec 2019 23:20:34 -0500
Message-Id: <cover.1575517685.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
References: <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
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
 kernel/trace/bpf_trace.c                      |  68 +++++++
 tools/include/uapi/linux/bpf.h                |  29 ++-
 .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
 5 files changed, 338 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c

-- 
2.17.1

