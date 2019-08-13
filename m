Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 669808B815
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfHMMIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:08:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40150 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbfHMMIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:08:06 -0400
Received: by mail-pg1-f193.google.com with SMTP id w10so51161849pgj.7;
        Tue, 13 Aug 2019 05:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nXUR57zVJA41KWE5xxjUW/MAhjVMNeKFhg9ej1hm1bs=;
        b=Uf6l/F3NVUroJP3OXRhhfkGNulTyndljCHvP48oxq8LDMQQdYaUaXRwEgNhAdUGeE/
         YOr3y8FhzS2wvmBLgxJWC34tnGJCs1VQT+gqb/vIVJjvsvgSwjAUip121HMfqfumNIqS
         IQ8lv+oKOcFeUV+QlhMjO+IjdQ0HUQDtub8jG1XDdgJcU/GagR6LLgS3YaCU7zbD3Dpc
         HtMzoLfFQGOuC5V0q6MHWzyXN6/r/Cj8bPKNFHiweiuZCZpV36ninJ9qMtPITL+j1eje
         iJ/yzo8QaepWxnqqAgFR4fP8NRN5x9VbsdathQDbaNzGwNOXNdk8Vry3/xM/a+WdqEO9
         Gvdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nXUR57zVJA41KWE5xxjUW/MAhjVMNeKFhg9ej1hm1bs=;
        b=CRNhGGGexy9LTIeTkSPGY7vgfAqi8aq7kxMxMSJNMyEXxZfx4/kx3jfZi7iDPivcQ0
         xHev1+gLkNDbA0hs6oya1Jh+dcfzFZK+a9enNYgS0gEI923YtEHwMPXv/Ji/4dNYfYWy
         uG0FbcHZA8YCa8+3dRFDJmeUOO0eOrt0o3AImwHLs8L/hMYeXRtq0sBFrDGSorOr3rpJ
         UNrNf2a4P7JBMoMrT5Bme4H2rLtvNDQiaPzQMQY92TpUS0igPhUFqHyJPf8gQIogUnIM
         OF8FCAfSzDSlxIFMw+/QFTYnQ4W2ybbPeUninl85SVyNXLHllnh7qiVGCm1Q4VpsrNEi
         tJnA==
X-Gm-Message-State: APjAAAVRRVv97VxSZhG3ses2DyaQgU5jo2OMMIkdRBxQBtq9iEhxScDF
        gvXzbL/1eat6RMFAVRdk3Iw=
X-Google-Smtp-Source: APXvYqxRd3nWpYyebfDCvRyb7AAoz8fjwQm1zIf3xK9gPSpq3/SIl0QVgydDwowdOX05K8fTcKVEGA==
X-Received: by 2002:a63:7d05:: with SMTP id y5mr12780591pgc.425.1565698085649;
        Tue, 13 Aug 2019 05:08:05 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.08.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:08:04 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 12/14] bpf, selftest: Add test for xdp_flow
Date:   Tue, 13 Aug 2019 21:05:56 +0900
Message-Id: <20190813120558.6151-13-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if TC flower offloading to XDP works.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 tools/testing/selftests/bpf/Makefile         |   1 +
 tools/testing/selftests/bpf/test_xdp_flow.sh | 103 +++++++++++++++++++++++++++
 2 files changed, 104 insertions(+)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_flow.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3bd0f4a..886702a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -50,6 +50,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
+	test_xdp_flow.sh \
 	test_offload.py \
 	test_sock_addr.sh \
 	test_tunnel.sh \
diff --git a/tools/testing/selftests/bpf/test_xdp_flow.sh b/tools/testing/selftests/bpf/test_xdp_flow.sh
new file mode 100755
index 0000000..cb06f3e
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_flow.sh
@@ -0,0 +1,103 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Create 2 namespaces with 2 veth peers, and
+# forward packets in-between using xdp_flow
+#
+# NS1(veth11)        NS2(veth22)
+#      |                  |
+#      |                  |
+#   (veth1)            (veth2)
+#      ^                  ^
+#      |     xdp_flow     |
+#      --------------------
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TESTNAME=xdp_flow
+
+_cleanup()
+{
+	set +e
+	ip link del veth1 2> /dev/null
+	ip link del veth2 2> /dev/null
+	ip netns del ns1 2> /dev/null
+	ip netns del ns2 2> /dev/null
+}
+
+cleanup_skip()
+{
+	echo "selftests: $TESTNAME [SKIP]"
+	_cleanup
+
+	exit $ksft_skip
+}
+
+cleanup()
+{
+	if [ "$?" = 0 ]; then
+		echo "selftests: $TESTNAME [PASS]"
+	else
+		echo "selftests: $TESTNAME [FAILED]"
+	fi
+	_cleanup
+}
+
+if [ $(id -u) -ne 0 ]; then
+	echo "selftests: $TESTNAME [SKIP] Need root privileges"
+	exit $ksft_skip
+fi
+
+if ! ip link set dev lo xdp off > /dev/null 2>&1; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without the ip xdp support"
+	exit $ksft_skip
+fi
+
+set -e
+
+trap cleanup_skip EXIT
+
+ip netns add ns1
+ip netns add ns2
+
+ip link add veth1 type veth peer name veth11 netns ns1
+ip link add veth2 type veth peer name veth22 netns ns2
+
+ip link set veth1 up
+ip link set veth2 up
+
+ip -n ns1 addr add 10.1.1.11/24 dev veth11
+ip -n ns2 addr add 10.1.1.22/24 dev veth22
+
+ip -n ns1 link set dev veth11 up
+ip -n ns2 link set dev veth22 up
+
+ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
+ip -n ns2 link set dev veth22 xdp obj xdp_dummy.o sec xdp_dummy
+
+ethtool -K veth1 tc-offload-xdp on
+ethtool -K veth2 tc-offload-xdp on
+
+trap cleanup EXIT
+
+# Adding clsact or ingress will trigger loading bpf prog in UMH
+tc qdisc add dev veth1 clsact
+tc qdisc add dev veth2 clsact
+
+# Adding filter will have UMH populate flow table map
+# 'skip_sw' can be accepted only when 'tc-offload-xdp' is enabled on veth
+tc filter add dev veth1 ingress protocol ip flower skip_sw \
+	dst_ip 10.1.1.0/24 action mirred egress redirect dev veth2
+tc filter add dev veth2 ingress protocol ip flower skip_sw \
+	dst_ip 10.1.1.0/24 action mirred egress redirect dev veth1
+
+# ARP is not supported so don't add 'skip_sw'
+tc filter add dev veth1 ingress protocol arp flower \
+	arp_tip 10.1.1.0/24 action mirred egress redirect dev veth2
+tc filter add dev veth2 ingress protocol arp flower \
+	arp_sip 10.1.1.0/24 action mirred egress redirect dev veth1
+
+ip netns exec ns1 ping -c 1 -W 1 10.1.1.22
+
+exit 0
-- 
1.8.3.1

