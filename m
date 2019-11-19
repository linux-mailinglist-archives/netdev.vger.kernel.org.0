Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D89F410255F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 14:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfKSN1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 08:27:53 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39361 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbfKSN1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 08:27:51 -0500
Received: by mail-pf1-f195.google.com with SMTP id x28so12186088pfo.6;
        Tue, 19 Nov 2019 05:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=991wadlKoIf5fyh5RZSIF1k5KlgY19LbPsWb2sODItY=;
        b=MMs2kPisReK9mXyL4pp0T6LGlkthL7Rahzcv0siIQvE9qzrBJ6lJJ3f+OJFvxRWl4X
         q+6+PdC6zw1/nKHpUVmRrAt8hDCXa3EAv3wWfxfvyjBJuEVB0W1WAAkhgU5ieRybU/ds
         wb7xMnwp/YDAhBH5B2oig5sIbXF6u8C6eqfWeOVUgh3DcHqH3X+4svPaNqinYLeAjzSZ
         9EHdigRNiQN4kUDkpn9k4ISHsbCcPMt79zd2im8uhkLZrFhy8sirOOzSpm/ZVmMxjbGB
         LVjj8DdssvVU4eheIbU4tF3YGz6PhkJHJDVaZgyz8tXbVdlqs5uoJBk+SxECBiedgeLP
         qk0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=991wadlKoIf5fyh5RZSIF1k5KlgY19LbPsWb2sODItY=;
        b=lI5n5CUzXmDgi/guXYzSdEXo6N8uf30kE4Yp4X5VdcvBb6lrqzW0czBVDJE33hU0Bw
         aohkbCFE3FTFSfWAS0rpiSNvpztfZq3ROtssSmpYjXrJf5/v9KA5I2gP2zKvXiUyudof
         DzU6KDQftycKd3FkWFimrPVIytOaZuUtJJ9q7fooGrXruW4jWcJQf/RZjZ4UDRbHW3CR
         oHMl9LuQxbM6FTzfB2awmj9mqp4NJ9FxKipOiytZGD7wkNMtOlP8ULCzQOB4meDVw9ce
         jjqPk6hg3F5Nt0/swUKo57RysqiFg65bIYCcQwEszRfbRGPBWbbDWPxKCtKvXkqj/9Wh
         SkqA==
X-Gm-Message-State: APjAAAVCySjWlVe03v+1ESR2QIci7CWnMG0JswWNnsuPFRxStDvaX515
        GkHHzyqc9lGJKNuhOs+kMAcO4sCH+8g=
X-Google-Smtp-Source: APXvYqw+xmNRYKHWxKazJushimkHPpsyMxOqggFVxLHTXURgx9mAc4U98J1uBHVY50FzDbdJFxfJzg==
X-Received: by 2002:a63:9d41:: with SMTP id i62mr5791328pgd.310.1574170070321;
        Tue, 19 Nov 2019 05:27:50 -0800 (PST)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id v189sm25990458pfv.133.2019.11.19.05.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 05:27:49 -0800 (PST)
From:   Wenbo Zhang <ethercflow@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org.com, daniel@iogearbox.net, yhs@fb.com,
        andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: [PATCH bpf-next v10 0/2] bpf: adding get_file_path helper
Date:   Tue, 19 Nov 2019 08:27:36 -0500
Message-Id: <cover.1574162990.git.ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
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
 kernel/trace/bpf_trace.c                      |  63 +++++++
 tools/include/uapi/linux/bpf.h                |  29 ++-
 .../selftests/bpf/prog_tests/get_file_path.c  | 171 ++++++++++++++++++
 .../selftests/bpf/progs/test_get_file_path.c  |  43 +++++
 5 files changed, 333 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_file_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_get_file_path.c

-- 
2.17.1

