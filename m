Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E52EDC7A2
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634203AbfJROlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:41:40 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:37483 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408509AbfJROlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:41:40 -0400
Received: by mail-il1-f193.google.com with SMTP id l12so5756240ilq.4;
        Fri, 18 Oct 2019 07:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=Aq0PTqhMU9mcsFxuwG5v4rceCh6bNboo4dvG6SU3rOA=;
        b=vMFMMv017N/WKAIOnqLWztCQ9b8658GyqGDHCFvU6x/DxWFUb1vOweFyfeQGPD302W
         EpQZXbWTLi3u3+DHawJf/CLZOF+NhcmnEKWdMKKxjxqxH8+X0N5YPETmo0T+CHk1nNYw
         pPr2MRjg4g/4g0yOUi0w7NpyD7JZvITixyZPKrHQOA+0Z+sjawBEwxJNiiyTanD+M//Q
         Az0Nz4JhXj1ddEnYKXq+aokCY28EiT/2FSXOC8/jLVmOZ42rrmCZBS+vaBzXrygXeH0C
         W9GPPt7PLslbGScVlHtv+RHXKJ3JO00fepeU/3/qovuYtfL3yPAUFL2DtMYCv0hrYm9p
         BefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=Aq0PTqhMU9mcsFxuwG5v4rceCh6bNboo4dvG6SU3rOA=;
        b=ZE1MQ/zfxsXU3XqnWCMametb6o9hFN0E54eAt/GMHrmgGrT+wTHrrOlfuXQ6LZIeoR
         RiODakFM1J9OCEmaS6vvxMOIV6URcRqoLFul9DeeHf+K7kpipv646kyuS04xTQMYLqrY
         z0TQfXssRcK1VVMON7+lPFQMc2Px5rdiQko45z2XanlMVi8NW7ILk9nj5MJhTtrk6m/T
         ErqjCbPEBPOOh5S3CyZ+fW4fozxuGVbDvYxUQ6MS676RYQdxRqVhUEkEkGsO1Hs14bru
         YpedjOfasubxnK+ojB9OomhmRqU3+Dr7P2N8amquoKGeXU3LOaGv3xWM2u2y8ojvtqg5
         DtUw==
X-Gm-Message-State: APjAAAVH9Uk4yUotNd08oITPgx4h1AjCC5fTVOqxwMZmzxCVnv4DlHEr
        mRkjsfpW96ZOcaqJHQMOD9Q=
X-Google-Smtp-Source: APXvYqwdfVuZ+KXTrEfNaDhWqS2Bx2FRqgHn+YMHAlcU95PVqnsnFTgHcRzdUh59gdHyqcj7qqlYHQ==
X-Received: by 2002:a92:475a:: with SMTP id u87mr10855362ila.26.1571409699079;
        Fri, 18 Oct 2019 07:41:39 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b138sm338072iof.17.2019.10.18.07.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:41:38 -0700 (PDT)
Subject: [bpf-next PATCH] bpf: libbpf,
 add kernel version section parsing back
From:   John Fastabend <john.fastabend@gmail.com>
To:     andriin@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Fri, 18 Oct 2019 07:41:26 -0700
Message-ID: <157140968634.9073.6407090804163937103.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit "libbpf: stop enforcing kern_version,..." we removed the
kernel version section parsing in favor of querying for the kernel
using uname() and populating the version using the result of the
query. After this any version sections were simply ignored.

Unfortunately, the world of kernels is not so friendly. I've found some
customized kernels where uname() does not match the in kernel version.
To fix this so programs can load in this environment this patch adds
back parsing the section and if it exists uses the user specified
kernel version to override the uname() result. However, keep most the
kernel uname() discovery bits so users are not required to insert the
version except in these odd cases.

Fixes: 5e61f27070292 ("libbpf: stop enforcing kern_version, populate it for users")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/lib/bpf/libbpf.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fcea6988f962..675383131179 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -656,6 +656,21 @@ bpf_object__init_license(struct bpf_object *obj, void *data, size_t size)
 	return 0;
 }
 
+static int
+bpf_object__init_kversion(struct bpf_object *obj, void *data, size_t size)
+{
+	__u32 kver;
+
+	if (size != sizeof(kver)) {
+		pr_warning("invalid kver section in %s\n", obj->path);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	memcpy(&kver, data, sizeof(kver));
+	obj->kern_version = kver;
+	pr_debug("kernel version of %s is %x\n", obj->path, obj->kern_version);
+	return 0;
+}
+
 static int compare_bpf_map(const void *_a, const void *_b)
 {
 	const struct bpf_map *a = _a;
@@ -1573,7 +1588,11 @@ static int bpf_object__elf_collect(struct bpf_object *obj, int flags)
 			if (err)
 				return err;
 		} else if (strcmp(name, "version") == 0) {
-			/* skip, we don't need it anymore */
+			err = bpf_object__init_kversion(obj,
+							data->d_buf,
+							data->d_size);
+			if (err)
+				return err;
 		} else if (strcmp(name, "maps") == 0) {
 			obj->efile.maps_shndx = idx;
 		} else if (strcmp(name, MAPS_ELF_SEC) == 0) {

