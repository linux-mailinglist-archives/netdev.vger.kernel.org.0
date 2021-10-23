Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2743839B
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 14:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhJWMHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 08:07:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhJWMHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 08:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634990699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WJ7OqKyeNGLyX08QkZ4hXW8FK+z+RePlGaRNyyYTfto=;
        b=gS6vKi6YnSlKnc/JojPVF50kWY/57kC5g9U2FIb4o+TdrnxiWWEvVOTpXlpB7xAFN3zlZW
        ZUkpwoxwj/SjL3arMfr7hwI2aouUqou4cOkzxXOleS/fKKKscy6CaFNeVZPS4r9Ut+Hj+t
        ht4H0GUWU3ZstsClQUfrDC+mcqQGlXU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-idBeqRCqOVey6ytFsEWJ1w-1; Sat, 23 Oct 2021 08:04:55 -0400
X-MC-Unique: idBeqRCqOVey6ytFsEWJ1w-1
Received: by mail-ed1-f72.google.com with SMTP id g6-20020a056402424600b003dd2b85563bso3309718edb.7
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 05:04:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WJ7OqKyeNGLyX08QkZ4hXW8FK+z+RePlGaRNyyYTfto=;
        b=IBtSYaoQh2eJnK6Ok+077zLhNSkAak4jQKd1GImsbifi57sYY43NYshKbFqtBnOj8X
         ddd5020nPXH032BlpHmMg2wXtz6DxDDbfuOEUs2/yzIWu6bmjmQqQoADRu7GcLlxNpja
         34bWLw+0X1Exh7w2w4dz8EPsbLfWt9/zqm0hwGjL9yClH6x4/AGEyhmzUoyDqKYtovXB
         qAvIX5//2pT69/6qjraHU5tlI86uCnCzdGwmP+2iGNBpQRfUeO6wrdtTh6pqX6c3PwXN
         qtRfan1Ff4KK7xnPtFDKJLHqw7qCuY1w4aQHH4wJ+5NKLP/EKfsiPOGoDejFjaq01F2v
         X5Lw==
X-Gm-Message-State: AOAM5310mCJo5AIxgHKyDrQlZZxKNeSYD3Q5Vdk4bAhEHRhe8qAHXo+n
        x2rfbHskR1PuglQHSs9bTs8PkQ5jHmsQhcSC53P5mvzfRvScHjjUqbmHiWeF3eQqc4hv1zpahr9
        GFbabJzyEToX9JJfh
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr8120007edd.129.1634990694719;
        Sat, 23 Oct 2021 05:04:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTnrkfuISB6s8UrcrnxDhWe7LRw2byylqlFuZxr5TZkQkliWOBCzwqrIVsgzO+5iK7CcdmgQ==
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr8119975edd.129.1634990694487;
        Sat, 23 Oct 2021 05:04:54 -0700 (PDT)
Received: from krava.cust.in.nbox.cz ([83.240.63.48])
        by smtp.gmail.com with ESMTPSA id f3sm5034882ejl.77.2021.10.23.05.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 05:04:54 -0700 (PDT)
From:   Jiri Olsa <jolsa@redhat.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
Date:   Sat, 23 Oct 2021 14:04:50 +0200
Message-Id: <20211023120452.212885-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
I'm trying to enable BTF for kernel module in fedora,
and I'm getting big increase on modules sizes on s390x arch.

Size of modules in total - kernel dir under /lib/modules/VER/
from kernel-core and kernel-module packages:

               current   new
      aarch64      60M   76M
      ppc64le      53M   66M
      s390x        21M   41M
      x86_64       64M   79M

The reason for higher increase on s390x was that dedup algorithm
did not detect some of the big kernel structs like 'struct module',
so they are duplicated in the kernel module BTF data. The s390x
has many small modules that increased significantly in size because
of that even after compression.

First issues was that the '--btf_gen_floats' option is not passed
to pahole for kernel module BTF generation.

The other problem is more tricky and is the reason why this patchset
is RFC ;-)

The s390x compiler generates multiple definitions of the same struct
and dedup algorithm does not seem to handle this at the moment.

I put the debuginfo and btf dump of the s390x pnet.ko module in here:
  http://people.redhat.com/~jolsa/kmodbtf/

Please let me know if you'd like to see other info/files.

I found code in dedup that seems to handle such situation for arrays,
and added 'some' fix for structs. With that change I can no longer
see vmlinux's structs in kernel module BTF data, but I have no idea
if that breaks anything else.

thoughts? thanks,
jirka


---
Jiri Olsa (2):
      kbuild: Unify options for BTF generation for vmlinux and modules
      bpf: Add support to detect and dedup instances of same structs

 Makefile                  |  3 +++
 scripts/Makefile.modfinal |  2 +-
 scripts/link-vmlinux.sh   | 11 +----------
 scripts/pahole-flags.sh   | 20 ++++++++++++++++++++
 tools/lib/bpf/btf.c       | 12 ++++++++++--
 5 files changed, 35 insertions(+), 13 deletions(-)
 create mode 100755 scripts/pahole-flags.sh

