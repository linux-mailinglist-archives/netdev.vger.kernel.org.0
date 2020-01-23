Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C3A146EDE
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgAWRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:00:02 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42921 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbgAWQ7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:59:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so3881649wro.9
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g7SvZ9phUNQgBFhv9EVqVUJXNc7V2T/+gA9/uB1lrNY=;
        b=gtrzkuQ3f7nCSsbvZV+79p3YHEpiG55tz/BtLLT1TKC04h4wnV8nBZfVTy/oeleTWI
         FLytsgneqoqPVgRerwb4UmFKfANQw/OyLCbDS9cyI8/FdPksxF1YRxNFYVfCmifcHrmO
         gfDjmiP/5qHzq51cApwjJfE8JvSN2pHsTbzhE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g7SvZ9phUNQgBFhv9EVqVUJXNc7V2T/+gA9/uB1lrNY=;
        b=P8dgX5qPQ0CCKNVmtnAkxmURLZTdCbZZtC9Lk+5z+DAsNWLQDi8CtmmCWcyEYt+Ycu
         9FrYSRF6eCihV7I91L7rA1/tHFowxHTwyN/7bR6H5ENpLATglSd9+sNS4vUZ+ThYUvvG
         uMoH+SIVR6+MgUqOTpqSjF9xnVbC8K+VSsZnvCZCWlIAdutWwsi/sZZ1fyou4mCDP9yO
         AVjni29345X1KMjR6zOEo38NUuxmXkbd90ApCzyKZUpYUdegv5xElx2UKuI3BXvHCzv/
         a+HXUTz7OPqQKecsWjr1FmGlaJ5GwvqrCij7LGD6THTrtNzCI9VoY+nZu5D9Ddb3AO10
         oLDw==
X-Gm-Message-State: APjAAAUMsdR4L4/bBZVL8llUNotNeth40gVEGKlic0pBT9gSMgAyVIix
        0SM5U762fgPhNIo5OupjI6Oejw==
X-Google-Smtp-Source: APXvYqxZBMzloyeuvuGWMOXyEMsTRg357vgRAFLanDZW9K3hvo17Oc9CnYfhEOKDJRcCoIGSj/eFaA==
X-Received: by 2002:adf:cf0a:: with SMTP id o10mr18246948wrj.325.1579798783545;
        Thu, 23 Jan 2020 08:59:43 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:d0a9:6cca:1210:a574])
        by smtp.gmail.com with ESMTPSA id u1sm3217698wmc.5.2020.01.23.08.59.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 08:59:42 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf 2/4] selftests: bpf: ignore RST packets for reuseport tests
Date:   Thu, 23 Jan 2020 16:59:31 +0000
Message-Id: <20200123165934.9584-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123165934.9584-1-lmb@cloudflare.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reuseport tests currently suffer from a race condition: RST
packets count towards DROP_ERR_SKB_DATA, since they don't contain
a valid struct cmd. Tests will spuriously fail depending on whether
check_results is called before or after the RST is processed.

Exit the BPF program early if FIN is set.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/progs/test_select_reuseport_kern.c        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
index d69a1f2bbbfd..26e77dcc7e91 100644
--- a/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c
@@ -113,6 +113,12 @@ int _select_by_skb_data(struct sk_reuseport_md *reuse_md)
 		data_check.skb_ports[0] = th->source;
 		data_check.skb_ports[1] = th->dest;
 
+		if (th->fin)
+			/* The connection is being torn down at the end of a
+			 * test. It can't contain a cmd, so return early.
+			 */
+			return SK_PASS;
+
 		if ((th->doff << 2) + sizeof(*cmd) > data_check.len)
 			GOTO_DONE(DROP_ERR_SKB_DATA);
 		if (bpf_skb_load_bytes(reuse_md, th->doff << 2, &cmd_copy,
-- 
2.20.1

