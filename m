Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96774CBFDC
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 17:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390172AbfJDP4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 11:56:24 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:43393 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390164AbfJDP4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 11:56:23 -0400
Received: by mail-yb1-f201.google.com with SMTP id v15so5196489ybs.10
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 08:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dSnbP5Jkis+rn77OzXcSHwYP7eOSGch4IOdOZ3lKMAI=;
        b=Im2RWn74vOKBgu9Poi6W/dO0NUqLg9bxxDf/THc48zCMcb8BNJcprvjqtPrdhLDZjc
         +wkFdGSW55YHNIkllq2xcHaH8fqiG47oMVCqlKUxAMIsG650R828Nwg4aV9cXI3mKYgK
         PoM5nB2Z6fOcoMci2sWkUUEg2G0YXfM9ffPqIvJobhlVTRsxzDIfbeFt8p8amdJEsYSF
         0upS5bHX1Hlzqe0nB7BC3r2zlB/7ClBn/XdmEtCaVYvRiwng0QUCtL7S0S/TPANMFhFI
         a+6l2cO9TN8A2hqhAxOL5BW968IwDg+ggI16mZC2hUe3bLUjEOeNmrCYT/+JIkz48/XO
         hopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dSnbP5Jkis+rn77OzXcSHwYP7eOSGch4IOdOZ3lKMAI=;
        b=niKfN0j1wRqIDwHXHHMRs5cjzQRzpUlG5If5YIt/b7gphh6Jd0n5rpt3GfT0XCokFk
         NWFJdv3a8q+At/Skj+85LeNBUuFF17ilnbzJsTJJQrNEv/Sjp2lKGhJ08+JbpCcbHjYx
         ow0puIUnP7jTfWfWZhk/RaCSsLJMT0tdf6ESunMJekxx/jFqzrG6dHUydIJlSZ/sByDB
         4GCXqIbO8g07Ffzvbg0YqywELVL1XgblnBa7du8fYQXOpzS89Vj/JUz4mfPuzBq3Y6lt
         Z9AOUJUXu4vUqqoSiDNGMHRVMOsc50fgcH9/kdU50fu5mu4UCxKdJMYmB0E/B3nNUI+L
         jhtA==
X-Gm-Message-State: APjAAAXjYm8ljOzyPMG8btXukkFcUlR9MZweosqZx/EIr0LiF68jkxUU
        7CYVU1cHMkrmD/HWUQ8xWwZQtZ0KO4JTN7g6ZI1MOqHkwKXboH+5RMlEHsSpiuaFczD4+pF4/jg
        cLxCz557tL7D1GLQOxJuDtzxXZCuYBjdxv53qFWrEulE0GpaGLphQhg==
X-Google-Smtp-Source: APXvYqx9ao7IS9HtEjI17gkBC+SDiaid6NDXJm8QkifSIxXPThWEQ+JeZcbfwmaHh+pLCYaIyelWl/8=
X-Received: by 2002:a81:8203:: with SMTP id s3mr11007383ywf.235.1570204582427;
 Fri, 04 Oct 2019 08:56:22 -0700 (PDT)
Date:   Fri,  4 Oct 2019 08:56:15 -0700
In-Reply-To: <20191004155615.95469-1-sdf@google.com>
Message-Id: <20191004155615.95469-3-sdf@google.com>
Mime-Version: 1.0
References: <20191004155615.95469-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: add test for BPF flow
 dissector in the root namespace
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure non-root namespaces get an error if root flow dissector is
attached.

Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/test_flow_dissector.sh      | 48 ++++++++++++++++---
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index d23d4da66b83..2c3a25d64faf 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -18,19 +18,55 @@ fi
 # this is the case and run it with in_netns.sh if it is being run in the root
 # namespace.
 if [[ -z $(ip netns identify $$) ]]; then
+	err=0
+	if bpftool="$(which bpftool)"; then
+		echo "Testing global flow dissector..."
+
+		$bpftool prog loadall ./bpf_flow.o /sys/fs/bpf/flow \
+			type flow_dissector
+
+		if ! unshare --net $bpftool prog attach pinned \
+			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			echo "Unexpected unsuccessful attach in namespace" >&2
+			err=1
+		fi
+
+		$bpftool prog attach pinned /sys/fs/bpf/flow/flow_dissector \
+			flow_dissector
+
+		if unshare --net $bpftool prog attach pinned \
+			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			echo "Unexpected successful attach in namespace" >&2
+			err=1
+		fi
+
+		if ! $bpftool prog detach pinned \
+			/sys/fs/bpf/flow/flow_dissector flow_dissector; then
+			echo "Failed to detach flow dissector" >&2
+			err=1
+		fi
+
+		rm -rf /sys/fs/bpf/flow
+	else
+		echo "Skipping root flow dissector test, bpftool not found" >&2
+	fi
+
+	# Run the rest of the tests in a net namespace.
 	../net/in_netns.sh "$0" "$@"
-	exit $?
-fi
+	err=$(( $err + $? ))
 
-# Determine selftest success via shell exit code
-exit_handler()
-{
-	if (( $? == 0 )); then
+	if (( $err == 0 )); then
 		echo "selftests: $TESTNAME [PASS]";
 	else
 		echo "selftests: $TESTNAME [FAILED]";
 	fi
 
+	exit $err
+fi
+
+# Determine selftest success via shell exit code
+exit_handler()
+{
 	set +e
 
 	# Cleanup
-- 
2.23.0.581.g78d2f28ef7-goog

