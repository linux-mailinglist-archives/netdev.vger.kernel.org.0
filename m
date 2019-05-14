Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE091D119
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 23:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfENVMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 17:12:41 -0400
Received: from mail-oi1-f202.google.com ([209.85.167.202]:38162 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfENVMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 17:12:40 -0400
Received: by mail-oi1-f202.google.com with SMTP id 7so190425oie.5
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 14:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f4HloUjiQjHr3SUwk4xw1iDaHpvfypDo+dWu4ub0D+0=;
        b=lbqQA+/roB+NGcMKRsBPTxAX3UnGLFutoQsaIbPCUy/dl61OTM4A4waSp4cIh7BmWZ
         FRyLPWnVmHGOUZO1ZxzkFWO2sigyRVhdfNjZBzDstPAdsNeXDKbq7IofpFzjGrc1e2Xa
         S1EoHeKUkdHtPFHDLBhsp+u16C3mZU+cHdCXwLalXja2oTivUUo5+XQyn35YSs1qOhgG
         v04gyApmmXzFCr9JtlAtZNm+DteGh4kbElbudxNIVtbHb4A3HMN3bqcUrOHaX5WOSOJS
         IpLc3th2aHTMEP9R+k1cmljO4JbWizXZdcWI71S87R/XV2E8Sti1V9cF1XgWxoRmYo1+
         7/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f4HloUjiQjHr3SUwk4xw1iDaHpvfypDo+dWu4ub0D+0=;
        b=lgOyn0ppUqQuclbotKSytC6LvNoTWiZRrvhncUpnq6A9J+kasQrbSSkwJSjp9iIz9m
         13tLwyNFmbkcrS1ZAkvL0QA34AmqZnt+dWTpWQWJiNmRFzRXkn3PdE3/fuoMVBoy8GRk
         UUxeAvMoQE/2PBt7vC7mqJh2GGQ/V/FnZVwSdCFUod4xefF8XuO6SW4c9nqvJrgJxp/J
         ozrBlFfJRMbLmp4/VW5Bzsn+hFJENU1ci0U85o8kEbW6/yXu0WjSVLSpytlFxxLFSof6
         P7LC0UEjPCQVLRmGcF8u3mzeUyI/DTCXzfZOq5an9cPPEs6Wu1/QGvWpb0oj4DkMBaZY
         V3zA==
X-Gm-Message-State: APjAAAVWqd+yQYpkZCL4O5k8fbT5o6h30wcDAPu1qYJ0jd/5gMGEOsEp
        hTPDSMQjb5fHq5jKCwbezTEBP+dY6OJAg/MimkVU20btq+SssmDCdS0lBmoi/z86/x7zRcjfMC4
        76jKWyTpQQ84QsqsA6513epVI2bMtVqBitjxKMJJqHKBYV6XklZ893w==
X-Google-Smtp-Source: APXvYqyYiCp5DjnGAGHgrnNj6QVVU3tpJjkbXwVF4DaNh3Y34av5Dx+2S3jwV2YxuYPaxPcL0EY6wNM=
X-Received: by 2002:aca:da82:: with SMTP id r124mr4192393oig.49.1557868359634;
 Tue, 14 May 2019 14:12:39 -0700 (PDT)
Date:   Tue, 14 May 2019 14:12:34 -0700
In-Reply-To: <20190514211234.25097-1-sdf@google.com>
Message-Id: <20190514211234.25097-2-sdf@google.com>
Mime-Version: 1.0
References: <20190514211234.25097-1-sdf@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf 2/2] selftests/bpf: add prog detach to flow_dissector test
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case we are not running in a namespace (which we don't do by default),
let's try to detach the bpf program that we use for eth_get_headlen tests.

Fixes: 0905beec9f52 ("selftests/bpf: run flow dissector tests in skb-less mode")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index d40cee07a224..fbd1d88a6095 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -264,5 +264,6 @@ void test_flow_dissector(void)
 		CHECK_FLOW_KEYS(tests[i].name, flow_keys, tests[i].keys);
 	}
 
+	bpf_prog_detach(prog_fd, BPF_FLOW_DISSECTOR);
 	bpf_object__close(obj);
 }
-- 
2.21.0.1020.gf2820cf01a-goog

