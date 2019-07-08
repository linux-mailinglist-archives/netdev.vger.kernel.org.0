Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7202262667
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391527AbfGHQcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:32:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37237 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388484AbfGHQbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:31:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so8702263wrr.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3geFFJ9tql4ZwrkQmT2Y6FVy9TSA0XcjotCe5RWiIWM=;
        b=W11kKcw12664L0TISI/sieWZFZRo6VanqFvi/sZiO58JX6zHqbOe5vVsLBGA/+5B+Y
         kKAtx9nfU9bBDJD3JcMKrs3s0vOlMoOeV4DK5ENYnVnXju2PxsleMeKcMdkefpydrt/X
         /qu3fMa+w+lGdlcWFfAf4e1+K73wTK7C4pWbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3geFFJ9tql4ZwrkQmT2Y6FVy9TSA0XcjotCe5RWiIWM=;
        b=FmJcg0vRcazjCJ7CyYJiqUBnOlWgHJVh77V7eKxi39K9NgdYFO7iuxqPSpShR1su4l
         4DdLE625FZRjPt99fezjktms27JOmMqF5A8zqgpSecuOYcTMdrJ916m2ne/Ud0jhBpwB
         KmDocvKEqB6qZjG30xBfJ5Aq5++i2JZQqIbUoGDBAWcpsQw5rVOjZ7T7J1TsNNwfIwNH
         uFrW++ah8JnaWdsoltm02QC3vaLwYQBrgEwki/i7Aczl3RFud2sLVor/SkoHBkIxN+uK
         vW4gxU4aDQlKqy4FnyxJGnFhs7zrJ/jlG1WHAiQNfuxYP3kSGoaFrXBtZJrOaFKX7bYV
         aPnQ==
X-Gm-Message-State: APjAAAW3z/wu1AO4M+qfd1Lcg/cudRoaoihtV2IJJKMuUly+mqUYxN96
        oMaLf08ENqvm+jHr2nb8gOAbaA==
X-Google-Smtp-Source: APXvYqzjb6vUPKfQHIBsttODvNl7TdmxISCG+2hXPuXBG5uEruZ3Y9wg/g4GGXFNnZrOITpNYyyoWQ==
X-Received: by 2002:adf:ec0f:: with SMTP id x15mr19952633wrn.165.1562603508638;
        Mon, 08 Jul 2019 09:31:48 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.31.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:31:48 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     linux-kernel@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 02/12] selftests/bpf: Avoid a clobbering of errno
Date:   Mon,  8 Jul 2019 18:31:11 +0200
Message-Id: <20190708163121.18477-3-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190708163121.18477-1-krzesimir@kinvolk.io>
References: <20190708163121.18477-1-krzesimir@kinvolk.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Save errno right after bpf_prog_test_run returns, so we later check
the error code actually set by bpf_prog_test_run, not by some libcap
function.

Changes since v1:
- Fix the "Fixes:" tag to mention actual commit that introduced the
  bug

Changes since v2:
- Move the declaration so it fits the reverse christmas tree style.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 832c6f2c29ec ("bpf: test make sure to run unpriv test cases in test_verifier")
Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
---
 tools/testing/selftests/bpf/test_verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b8d065623ead..3fe126e0083b 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -823,16 +823,18 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
 	__u8 tmp[TEST_DATA_LEN << 2];
 	__u32 size_tmp = sizeof(tmp);
 	uint32_t retval;
+	int saved_errno;
 	int err;
 
 	if (unpriv)
 		set_admin(true);
 	err = bpf_prog_test_run(fd_prog, 1, data, size_data,
 				tmp, &size_tmp, &retval, NULL);
+	saved_errno = errno;
 	if (unpriv)
 		set_admin(false);
 	if (err) {
-		switch (errno) {
+		switch (saved_errno) {
 		case 524/*ENOTSUPP*/:
 			printf("Did not run the program (not supported) ");
 			return 0;
-- 
2.20.1

