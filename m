Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815A2140AE2
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgAQNgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:36:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726950AbgAQNgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579268202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oVICxkwYE819T09jumS9b6kqZZVW9alGabNhw2Byv4c=;
        b=NBgagi4vaVDraEVb5z2UKdz55Ow06HL4VwzW9qJzYRjo+al8258qd5DgxWAka0djOH1o33
        gBg7BWxeCJNHe9I/wpip7Qt8epB/JM4qsS/P3oBPsHI/DbhRQfLFiUxUbBw9Ts8nR3zxBe
        Ibl6F4CbmqlBoHVRrH5eGjfL1ZTplOM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-VcWPcdWMMaSpjQsLyoVaNw-1; Fri, 17 Jan 2020 08:36:41 -0500
X-MC-Unique: VcWPcdWMMaSpjQsLyoVaNw-1
Received: by mail-lf1-f71.google.com with SMTP id t74so4371446lff.8
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 05:36:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oVICxkwYE819T09jumS9b6kqZZVW9alGabNhw2Byv4c=;
        b=oYmVAJgo51Y8mvx2NDvRjxo2wl3o1OI+JVKJ6tdAPpuChM8cKCRXv+djRpZLrbnfWa
         Oa00fzK1afqxgIsG3pVX7XErJvMjnC+zMiErEeuCvE5KyEHhaafnvAoeKPH6fjydMK0B
         KBPsfMsxUt5mso+B9/sm89GdoFSKzM5tVbBxqZnL3dr66539FylETnQjfDBiEPHD+AVW
         4L5QsoYLUYu0X3PWnTCrko/Go73SVieGeEMDaHn+Au++hapkXFL5Dc6crXJb0tCXR2Bd
         rriX345Ex9k1wmal7yvetpqYRmDK2lItchmYIEe/DrAJs4ubY8IOMIt7WCIpXbQIPvfp
         Ojjw==
X-Gm-Message-State: APjAAAVl9loSASKDd5aNwf/RYAzGHRjPHayQDSsKf2vVEiBSG1mgpx4D
        x54ixDmLm7kQA//krsPKMu/aU26Y5EiaOdVK4nwdM0CFhDAd4F4Hl136o5Nnzk4SKkz4Lu/dAa6
        5ULzsEv2iB7eLJvdP
X-Received: by 2002:a2e:3504:: with SMTP id z4mr5730203ljz.273.1579268199900;
        Fri, 17 Jan 2020 05:36:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqylN+0GVMNBaohq3jT5bbBFBEpPomA9QCEg65LVnS53cMW7Nhrc9Od5tPVFSrsyp0I8uvYr0A==
X-Received: by 2002:a2e:3504:: with SMTP id z4mr5730180ljz.273.1579268199696;
        Fri, 17 Jan 2020 05:36:39 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w1sm11999480lfe.96.2020.01.17.05.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:36:39 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 317BF1804D7; Fri, 17 Jan 2020 14:36:38 +0100 (CET)
Subject: [PATCH bpf-next v4 01/10] samples/bpf: Don't try to remove user's
 homedir on clean
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Fri, 17 Jan 2020 14:36:38 +0100
Message-ID: <157926819814.1555735.13181807141455624178.stgit@toke.dk>
In-Reply-To: <157926819690.1555735.10756593211671752826.stgit@toke.dk>
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The 'clean' rule in the samples/bpf Makefile tries to remove backup
files (ending in ~). However, if no such files exist, it will instead try
to remove the user's home directory. While the attempt is mostly harmless,
it does lead to a somewhat scary warning like this:

rm: cannot remove '~': Is a directory

Fix this by using find instead of shell expansion to locate any actual
backup files that need to be removed.

Fixes: b62a796c109c ("samples/bpf: allow make to be run from samples/bpf/ directory")
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 samples/bpf/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 5b89c0370f33..f86d713a17a5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -254,7 +254,7 @@ all:
 
 clean:
 	$(MAKE) -C ../../ M=$(CURDIR) clean
-	@rm -f *~
+	@find $(CURDIR) -type f -name '*~' -delete
 
 $(LIBBPF): FORCE
 # Fix up variables inherited from Kbuild that tools/ build system won't like

