Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2163027A2BE
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 21:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgI0Ta1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 15:30:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31222 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgI0TaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 15:30:24 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601235022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=F8YPfe0pB7pttwaqfzziE+JMy4Da3EM0z4SpEHDuX4c=;
        b=ATCNBYspBNwEL+adMtDfqxDkgVkAupmBHTfD8Bzira32nk5Xx2hyX6Y7W/o6PJ5KjM2k3C
        IH+bhJLY/wSJfH+XckqjBJqxw/9O+FBoAcsz8lVaUgWvKG7cC8nYrejApI0BkVKMOG5Mwx
        +Id0M+pHA49F6301vKzMYgIpeZAuuSY=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-OAbB_GB4Nm6kNlAuOoNBYw-1; Sun, 27 Sep 2020 15:30:20 -0400
X-MC-Unique: OAbB_GB4Nm6kNlAuOoNBYw-1
Received: by mail-oo1-f72.google.com with SMTP id z75so4449965ooa.21
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 12:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F8YPfe0pB7pttwaqfzziE+JMy4Da3EM0z4SpEHDuX4c=;
        b=IqWTi/eiZ2sdtSabRdgkOkWIWZFuu49+yFSHOS0lnIIUIyYULquBC/OcjMJWyru6vP
         gWZFJlVPKSRXuMo5Q5nfdv1RWaMpP/218lmz3xp9ulyc0T10F8KabD+9SXdWSll4H54U
         5LEjO4o0CMo8dXYHyIryQYTfTDh1QUbStIUEFNdlZQJm9P/dtFdzluvJubLqp8ghq7Bh
         alfwt1oNl/3ckFV1NdqaWA1s5lm2mK2C7Hn7BfoPGG9ZZZtkIByMttyahEfgp8ypYmS/
         tTPiG+fkVujqVZcXLxpLxCKmzODLhDxDb3wdjgUxG+Lwce5L5hgDijEYWaW6NAl7F8O+
         iS7A==
X-Gm-Message-State: AOAM532O8g/4RXC5x8zxH262okJjiLqiSX8btDZ5UImaLnrPcNJmXdLn
        K4yX/GTM/anff5dU4odzimWMoHh2mM+o412HESr7fk2AvH/67134Vpw506TvTTLe1mie/azFDSa
        ywaLXdsJHfS3DTwfW
X-Received: by 2002:a54:4413:: with SMTP id k19mr3870978oiw.99.1601235019958;
        Sun, 27 Sep 2020 12:30:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhMfHlnktI/H8l8W2NHAHbIzvYQaA+JpsCtebgm3/8addT7JwxOQ6O7iu1zQlgZBClObCubA==
X-Received: by 2002:a54:4413:: with SMTP id k19mr3870966oiw.99.1601235019591;
        Sun, 27 Sep 2020 12:30:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id w20sm2323387otk.24.2020.09.27.12.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2020 12:30:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 02EED183C5B; Sun, 27 Sep 2020 21:30:16 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpf/preload: make sure Makefile cleans up after itself, and add .gitignore
Date:   Sun, 27 Sep 2020 21:30:05 +0200
Message-Id: <20200927193005.8459-1-toke@redhat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Makefile in bpf/preload builds a local copy of libbpf, but does not
properly clean up after itself. This can lead to subsequent compilation
failures, since the feature detection cache is kept around which can lead
subsequent detection to fail.

Fix this by properly setting clean-files, and while we're at it, also add a
.gitignore for the directory to ignore the build artifacts.

Fixes: d71fa5c9763c ("bpf: Add kernel module with user mode driver that populates bpffs.")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/preload/.gitignore | 4 ++++
 kernel/bpf/preload/Makefile   | 2 ++
 2 files changed, 6 insertions(+)
 create mode 100644 kernel/bpf/preload/.gitignore

diff --git a/kernel/bpf/preload/.gitignore b/kernel/bpf/preload/.gitignore
new file mode 100644
index 000000000000..856a4c5ad0dd
--- /dev/null
+++ b/kernel/bpf/preload/.gitignore
@@ -0,0 +1,4 @@
+/FEATURE-DUMP.libbpf
+/bpf_helper_defs.h
+/feature
+/bpf_preload_umd
diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
index 12c7b62b9b6e..23ee310b6eb4 100644
--- a/kernel/bpf/preload/Makefile
+++ b/kernel/bpf/preload/Makefile
@@ -12,6 +12,8 @@ userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi \
 
 userprogs := bpf_preload_umd
 
+clean-files := $(userprogs) bpf_helper_defs.h FEATURE-DUMP.libbpf staticobjs/ feature/
+
 bpf_preload_umd-objs := iterators/iterators.o
 bpf_preload_umd-userldlibs := $(LIBBPF_A) -lelf -lz
 
-- 
2.28.0

