Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A9711F88
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfEBPuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:50:14 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35179 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfEBPuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:50:11 -0400
Received: by mail-yw1-f66.google.com with SMTP id n188so1942547ywe.2
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 08:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJQ31N3hZaG9+3EMTDqJhUCYotKpMS/dVZKKtxe+Og4=;
        b=b+XIq+GkTKcoCtZ1Lz6WL/o+5eaVjTufTLPMjk6cgvBoVcK+e7DcW40qAtLOoRvmJm
         BD75qUetNXmeihMBZQioG1xv1IJVge2ZYfUgciXnNb8sCZaAxE7mkbG1jvySB0HdLpf8
         8US/PmFeJiavVyTEJDZaHx3+B/emxIR8vrMVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fJQ31N3hZaG9+3EMTDqJhUCYotKpMS/dVZKKtxe+Og4=;
        b=OHYobP4SDL78OTIOYcGoyEDf8xgDe6Jj/5EKOj9+HKjpaDoTzMVMz9pG+C1OjB2EGi
         IypbHAVWDHLojKKbaumVgGBXFKw7y5QiZqFaTASFyaSD/tGGOHPRuIAPcfojexAtOh+E
         vqHl0GE+/PSOhidaMuCuLHz6U0NUAsgAxodrbuXo5PqVEcf6AJDYuG3c1uWjC9UaEa3L
         q5YkDQoIXIfC/jL6x6i4llNRb+J3Om2RDFFcz50nHkA6V+RZXQOvP58dBB2oEE0YhtVa
         I160njRR2RF9rR53i8sLoZVY0jBHqmvIE9BU/pdAEX3BFYIbQo1tdC5ouXvmJlxq0aj8
         W2LA==
X-Gm-Message-State: APjAAAVNxsk9FyeNl1rgxoG3DdbF6M/Tz6WIaJnQhLBg24X46y+ytvB8
        k0aRbjlzgbK5c32EqBbskIo6uQ==
X-Google-Smtp-Source: APXvYqwfb0PKIVIU25pzoxPKrevwD/g/zS0h2bxI7g00FVabFLPLw3S5mto5v9w14ae5HQJenNSmdA==
X-Received: by 2002:a25:a20a:: with SMTP id b10mr3857534ybi.431.1556812210579;
        Thu, 02 May 2019 08:50:10 -0700 (PDT)
Received: from localhost.localdomain (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id g7sm18913724ywg.31.2019.05.02.08.50.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 08:50:09 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Cc:     Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf] libbpf: always NULL out pobj in bpf_prog_load_xattr
Date:   Thu,  2 May 2019 11:49:32 -0400
Message-Id: <20190502154932.14698-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, code like the following segfaults if bpf_prog_load_xattr
returns an error:

    struct bpf_object *obj;

    err = bpf_prog_load_xattr(&attr, &obj, &prog_fd);
    bpf_object__close(obj);
    if (err)
        ...

Unconditionally reset pobj to NULL at the start of the function
to fix this.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 11a65db4b93f..2ddf3212b8f7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3363,6 +3363,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 	struct bpf_map *map;
 	int err;
 
+	*pobj = NULL;
+
 	if (!attr)
 		return -EINVAL;
 	if (!attr->file)
-- 
2.19.1

