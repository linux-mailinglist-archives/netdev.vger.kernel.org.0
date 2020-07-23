Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB722ABFE
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 11:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgGWJ75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 05:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgGWJ74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 05:59:56 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C931C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 02:59:56 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id i19so2940131lfj.8
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 02:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=peNb8+RImxTNVZkyG9ELZ4fhv916Nu+DkwVdstZXkiA=;
        b=LEEMGiaW0nGTr5CFiq3SrGNGE6dboorHG1aLnfiDOl6MgWGLACzz+29+izd56QHWX/
         TFRL7Rl0K3TDZiAD8lfmZ5vGG++cbTMvrnTx09rs142zLnZ0LAj5Mau2JsTfiXaVFDte
         b0cz3XGMizWT0ToH6w7sapzAuv9fTK0JKr4F0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=peNb8+RImxTNVZkyG9ELZ4fhv916Nu+DkwVdstZXkiA=;
        b=AiwmyKMB7MWfAn0faiPX7UWntjCv+NKDoAmvwGFgt1oJh8kMc3dEkmVF3ILXy/JdHA
         yHJ1eOjkRCaEBg75R10hvMlu0VukY+0G3P7Z9xXoU3yHp8ttfWIUXOlE/o17smiEBa/D
         MERv7rqHjEtDOA4/qf9hEaS+0vEvz5T8doukB5xuufze1tdjVXPGoWukc08zaf6mMm/O
         fd7Oi1xaB7X4GH0Xw29p0Fa7jawAMoAebYRWQrt9QeyfYo7bjsaAgDokK2tQ5puNjajr
         Y4/y1k/0ijW8icK1q5sRzNQfZbS8NBJimRZ+K56xSqq/JNjOh7hbK1vqRakdjON6UmC9
         eTvQ==
X-Gm-Message-State: AOAM532ke4/gVg2hylgXVXgZitTS2dhlezh28RTWpFKzkMUhQ/AFBTZS
        LFFEZpyH4zxQ33MhdhziDDUcq1BFe2E=
X-Google-Smtp-Source: ABdhPJxnsRyX1mdKT6YyBQWc6mtmdE+xNqWANhT+eqFjJoSxfc8QSpwXrCh9Oibo8KKdc9Av+fbLIQ==
X-Received: by 2002:ac2:4294:: with SMTP id m20mr1848076lfh.147.1595498394639;
        Thu, 23 Jul 2020 02:59:54 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h22sm2330598ljg.1.2020.07.23.02.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 02:59:54 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf v2 0/2] Fix narrow loads from an offset outside of target field
Date:   Thu, 23 Jul 2020 11:59:51 +0200
Message-Id: <20200723095953.1003302-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a second attempt at fixing narrow loads from context fields backed
by smaller-in-size target fields, when load offset is beyond the target
field.

Following Yonghong suggestion, verifier now emits an 'wX = 0' or 'rX = 0'
instruction for loads from offsets outside of target field.

Cc: Yonghong Song <yhs@fb.com>

[v1] https://lore.kernel.org/bpf/20200710173123.427983-1-jakub@cloudflare.com/

Jakub Sitnicki (2):
  bpf: Load zeros for narrow loads beyond target field
  selftests/bpf: Add test for narrow loads from context at an offset

 kernel/bpf/verifier.c                         | 23 ++++-
 .../selftests/bpf/prog_tests/narrow_load.c    | 84 +++++++++++++++++++
 .../selftests/bpf/progs/test_narrow_load.c    | 43 ++++++++++
 3 files changed, 148 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/narrow_load.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_narrow_load.c

-- 
2.25.4

