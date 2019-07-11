Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACEC653D4
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfGKJcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:32:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34250 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKJcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:32:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so5513672wrm.1;
        Thu, 11 Jul 2019 02:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XCX9jE72PgkcoZQV6rWjyFaKhpvGYfcrX9M8ab1CPrw=;
        b=WTsGVGK5wpMdV1mszZheZ2DQv0yLpDGFfIyiS1+/TxS4VN0VpW8T8t2ABpexq/WJX1
         Ea//oqxGdlspsprOkrHgui7Ok3o+FO32SUph1iJ3VvTLYFXQm/2e7Aw6JdlP8KfMfjSg
         5xOQQozfObgyyKVLdJ27hwhbMYEoM5LxRxaoBVArkQN5wUTv9K0oNOUHV9gr8B9Qr/Tx
         sBKgTLeV+lshzWg7G7Wv9NQHBGGV+mfoTvLQb3IWU4IOqgI2Wu5QPW5/63YuCHL8ZXSa
         96zKO50Wb19A6fspkb8/MFtt6idQujk3OYq00JyasM4vZtsOm7pmLNfficN6YzT4SJEz
         ERsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XCX9jE72PgkcoZQV6rWjyFaKhpvGYfcrX9M8ab1CPrw=;
        b=WOvpkH6E1nwIMx1WBp21x0jPcCADEbn1EvZNb098nED3ZxB7cnE8ql93+5YSQ/sLUI
         fsI0IQfYTjKCMYiPKaUgDU62hbwKlO3TmYwSgZ/59J6PpuNXR8Lts5BMzEjN256aWixI
         j8rAvUhza4P+feO4GrCpJ55wtgaBw0khSiK8/Wmmbto1DwYkVq+o+q6wBbTnriuOi2Tn
         R01mO3OxGL58ci7jqqFfn6qaJJbHSs2Oh7fsAlUCbtYT/nH7oNfn46UPZt7P8AFAF3RQ
         4IvlvC1BDzaPNVZwYU9c+80hMoGnM8suMhcs7JDO0BPO73aYanNcfVZ+ucGB/i3pbnnH
         ABgA==
X-Gm-Message-State: APjAAAX8/XXLVCoOKy7EHABV7CH9tbppF6q+lsUwCVFKTVg1asEzHn51
        YcucUU1WPhrgJFOIOzIWYvs=
X-Google-Smtp-Source: APXvYqw9tEdX1PMjiyEKwGEihr7O9qyS3mFTiivnSPv8Ia0a0OF+Ojy6Q+d5m3MpzGXET/E1Ynczmw==
X-Received: by 2002:adf:db07:: with SMTP id s7mr3841329wri.10.1562837517725;
        Thu, 11 Jul 2019 02:31:57 -0700 (PDT)
Received: from gmail.com (net-5-95-187-49.cust.vodafonedsl.it. [5.95.187.49])
        by smtp.gmail.com with ESMTPSA id k17sm1236382wrq.83.2019.07.11.02.31.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 02:31:57 -0700 (PDT)
From:   Paolo Pisati <p.pisati@gmail.com>
To:     --in-reply-to= <20190710231439.GD32439@tassilo.jf.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] bpf, selftest: fix checksum value for test #13
Date:   Thu, 11 Jul 2019 11:31:53 +0200
Message-Id: <1562837513-745-3-git-send-email-p.pisati@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
References: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Pisati <paolo.pisati@canonical.com>

Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
---
 tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/verifier/array_access.c b/tools/testing/selftests/bpf/verifier/array_access.c
index bcb83196e459..4698f560d756 100644
--- a/tools/testing/selftests/bpf/verifier/array_access.c
+++ b/tools/testing/selftests/bpf/verifier/array_access.c
@@ -255,7 +255,7 @@
 	.prog_type = BPF_PROG_TYPE_SCHED_CLS,
 	.fixup_map_array_ro = { 3 },
 	.result = ACCEPT,
-	.retval = -29,
+	.retval = 28,
 },
 {
 	"invalid write map access into a read-only array 1",
-- 
2.17.1

