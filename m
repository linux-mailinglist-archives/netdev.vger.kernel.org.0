Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A76FE4727A
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFOWyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 18:54:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43128 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbfFOWyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 18:54:24 -0400
Received: by mail-ot1-f65.google.com with SMTP id i8so5985402oth.10;
        Sat, 15 Jun 2019 15:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+P9nTmx6AVkxzkcKWAq6SHRAx2uOE86z8ZQoqv44Q9g=;
        b=jB3pkVuVNX2IYGpaqDtwbo7gRnhwlEbLmP8p69kIOY91oQnS637b0mA8ACYFui0KNK
         CaEF/iH24zh6eQ9zfrbb09Uw16IY/gZxukgu7m6YSiUOR3AQ49ENveWYMlypHo9S55jD
         9X2FpEEMAoc/hp1rqpGaUHTUNgtGokiFfxd8x5KnFvH/jLTIcftkMYFVBBmWvoZcrc15
         rGGareM0+q9JawutLvcMZN7HuTlV9b4LtYUPqTRypQyFYmvfDe0WcI42e3DOCtOS/Ce+
         Pocg25BZDBxJhpp+SmwwCHn71wWupTcDOnbHq/zm0A+7EBFHankJioOOghvjaZWhIguZ
         6Y4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+P9nTmx6AVkxzkcKWAq6SHRAx2uOE86z8ZQoqv44Q9g=;
        b=qAaBL/zSwdBNGCMzygS5oCyZz3nF3Pp4ER126gaPGTwyM5JSMymq7NajriRZVavrJf
         gsMi0D9W7FcM3n48trqqGcDjpDNEfzs1R9N02IaJUGENa0r5JcuyIn2wvCN20YEHgwol
         w7H0BjAbCZWWbH0v7T/GOi6AHJYkzVtFo2l5gUgcdenNUZxGWAZx9yRf97DNQYNIxBiC
         ZGjR2ft2HZe2cuHIBbwdOmsFNULBUDXjEv8fI5srT8HOhxeIciRn9A+QN/ctxHahkHP/
         ePSQaKgv24UuKs8g0eePGa7SM9L9/6qRVfp5IRWBBvscKAhYJ0lInFAQDeMMSVhqcJ2/
         BAOA==
X-Gm-Message-State: APjAAAWtWbiKy9nlGni5BUqtIwzrj2yk78hmlpGdJxNjYHPDgZ0Xnskx
        grEcicAfeE1EMY6cuZvEQTP5HlqUtLPLhNZr
X-Google-Smtp-Source: APXvYqxAAMCoJNtcF1RRUeY2DeG7Kwb7t+4t+b/GVJ7FQ2lgfETnfG1dJbZ8k2MIH3Z1fib0+LMgRg==
X-Received: by 2002:a9d:4c17:: with SMTP id l23mr51185564otf.367.1560639263582;
        Sat, 15 Jun 2019 15:54:23 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:91ff:fe99:7fe5])
        by smtp.gmail.com with ESMTPSA id o131sm3130636oia.21.2019.06.15.15.54.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 15:54:23 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH bpf] bpf: fix the check that forwarding is enabled in bpf_ipv6_fib_lookup
Date:   Sat, 15 Jun 2019 22:53:48 +0000
Message-Id: <20190615225348.2539-1-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf_ipv6_fib_lookup function should return BPF_FIB_LKUP_RET_FWD_DISABLED
when forwarding is disabled for the input device.  However instead of checking
if forwarding is enabled on the input device, it checked the global
net->ipv6.devconf_all->forwarding flag.  Change it to behave as expected.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index f615e42cf4ef..3fdf1b21be36 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4737,7 +4737,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 		return -ENODEV;
 
 	idev = __in6_dev_get_safely(dev);
-	if (unlikely(!idev || !net->ipv6.devconf_all->forwarding))
+	if (unlikely(!idev || !idev->cnf.forwarding))
 		return BPF_FIB_LKUP_RET_FWD_DISABLED;
 
 	if (flags & BPF_FIB_LOOKUP_OUTPUT) {
-- 
2.19.1

