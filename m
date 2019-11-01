Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9250FEBB86
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfKAAvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 20:51:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37883 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727455AbfKAAvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 20:51:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id b20so6083054lfp.4
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 17:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7MKIuXyw5t1sYq66/m6OQwaXeRIeCWIlU6RP0tUgVBA=;
        b=GP+bnz3duEEFA84llAms/mV/2V9xmY+lczW1wxpnaQESMLp4BMJlHq1U5CWYBDYfyB
         prptJa1SsLd+GBE5L2rv55N8gQTEZj/GG7dhA+nfzaW9WtnWPUwR7nlHPVJ9V7hy+oMn
         ow7l4djMCfWF6t1lPToh43Iu5Hxjkpn/+j8ag+7AxTXfqu/yhfRsKVJW7xYtRoC5BxDo
         celtasUX/Arurq5wgAFzdxQG73r1HiqOeYBAKJsmcf7nYFg64cSnQ/JxlhavM5BwqjKv
         sHzlfDIjttBRCoXBJH5dy3k8rUm1p130n4OUx7rDnqobquOjUbT+6ud5WG1QjyTbKY3w
         czMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7MKIuXyw5t1sYq66/m6OQwaXeRIeCWIlU6RP0tUgVBA=;
        b=hzA6p4rNlLFHEMnLBx+4ot4vyqO7uPy3bIorCD7F3Fl87UNfWE6aj/u0Ci43k5eget
         Df2K1nz9/6Ua+9kzfsG8dVKN8u+hXgMR+3R8vPgCyiuQoCJw54ISX5WS64YFEpgbzkrv
         STi2QTu/dD3RXCRMz5o5c2qUeMml4PSsrR9bFFg1/RRpe7Sub2wsQyKGTE7osAbWTFdY
         CRYEN2enfU5d9+zV2a+YNjY/QOhK+0ziU57GruSjbYovYFMImQ6ZeEwDsuHHyz1yx32E
         CXPAYEJDb+mqM0ovCiYOWweMe29QnOmhRelwhy58oCwzh7kBJryDlRJvviFzsbfC6HZW
         T5bA==
X-Gm-Message-State: APjAAAVsySWw+VmZBRQcvro/PYo6bJJ+HUKGKrMsfw8V1Z0fLIfdVS+u
        zO0piJrltaOLajf3P8Y4CgS6eA==
X-Google-Smtp-Source: APXvYqyHfd/IaNRQBi5oidrpYHoXFA07acAGkJ3+eBEn50KgQcoHwxI071aUqui3L3Q5lGR/UkRZ1g==
X-Received: by 2002:a19:895:: with SMTP id 143mr5346751lfi.158.1572569499890;
        Thu, 31 Oct 2019 17:51:39 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y10sm2214009ljn.81.2019.10.31.17.51.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2019 17:51:39 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        bpf@vger.kernel.org, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next] Revert "selftests: bpf: Don't try to read files without read permission"
Date:   Thu, 31 Oct 2019 17:51:27 -0700
Message-Id: <20191101005127.1355-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 5bc60de50dfe ("selftests: bpf: Don't try to read
files without read permission").

Quoted commit does not work at all, and was never tested.
Script requires root permissions (and tests for them)
and os.access() will always return true for root.

The correct fix is needed in the bpf tree, so let's just
revert and save ourselves the merge conflict.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 tools/testing/selftests/bpf/test_offload.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index c44c650bde3a..15a666329a34 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -312,7 +312,7 @@ def bpftool_prog_load(sample, file_name, maps=[], prog_type="xdp", dev=None,
             if f == "ports":
                 continue
             p = os.path.join(path, f)
-            if os.path.isfile(p) and os.access(p, os.R_OK):
+            if os.path.isfile(p):
                 _, out = cmd('cat %s/%s' % (path, f))
                 dfs[f] = out.strip()
             elif os.path.isdir(p):
-- 
2.23.0

