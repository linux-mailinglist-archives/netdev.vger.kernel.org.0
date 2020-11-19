Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A60E2B95C8
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 16:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgKSPHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 10:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgKSPG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 10:06:59 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD27BC0613CF;
        Thu, 19 Nov 2020 07:06:59 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id 5so3082879plj.8;
        Thu, 19 Nov 2020 07:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RS/qSpAFGukp3/v16zb33bFhkDVWoKnFpkOAjHD2Ues=;
        b=TtA55CbywFGEZgmG2AIEnrf1G1aCZ62XjuGX9tKDdFyZx8TDeAMi9hvpdP1KFnkdqB
         IhdJXXjEpEJyCXC8/+hN6sKY3KNuvEsidW0kiGas0eh91wPMSa94DfOEeq8YxHXRWOpZ
         DAaOritJmqPXKTLfDapId7Iae/QL6gQRpsto7levO+WJ0njdBZuvwzHBXbMv4bEq32tV
         s70BgRO4tLQYq+lx0q2xhXJ0DW34LGY/Qa0mWMU6fTEfLUjRzDOmQvuQ1KGEMGlhs2cK
         CnEBiFdslPWczmJgLVEEnAIzaSssfA0gN+R/FdedihC0Lo0TIpaOzxj/pAVQkh2wURvz
         2bgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RS/qSpAFGukp3/v16zb33bFhkDVWoKnFpkOAjHD2Ues=;
        b=iff1xE38hHiO05ehOsWuY6NmorJNndLBXkZ0ndOWCnGgnWR8MM15LWOEI9d2dMUcfL
         w+nmTeL1lbT2jf6N25po9chTUDADAO0TypRRyL7zyBi9x836EH6FLNsUb+eq57JNO+sh
         KpQPG3ezdvaamE+tO2nBq34ob22BlUfTy3mzJN6nbT6/0KUVqfOfZtAAz9QrOIMITi8V
         TlKSRNrJq0kRFZglJH2epV1AjaawPcpHAlCjEjoNBy7PA6SyR0pXfms9+W3OcnvO7cec
         2pFBRWjOB1F3kqtes8O1lpJUcGJg8xze9Pxcb1858CuYZvdZcmK3Kj/3V7CvBHROKtaY
         S63A==
X-Gm-Message-State: AOAM532poH/mB+Dyk830/XgnZjHm/L2KWJiGUC1dETnxdNC45Pi9StLV
        TmjDBbqMZOVJrVXwCMdhGw==
X-Google-Smtp-Source: ABdhPJzZki7x+0zz4MBNmiQBfAG6eLca/O+2oHgu9w9coQHVQE8Th4CDsKriLmD0aczGF4BJfifa3g==
X-Received: by 2002:a17:902:9f87:b029:d9:e311:fc86 with SMTP id g7-20020a1709029f87b02900d9e311fc86mr1082667plq.74.1605798419245;
        Thu, 19 Nov 2020 07:06:59 -0800 (PST)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id b80sm77783pfb.40.2020.11.19.07.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:06:58 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 6/7] samples: bpf: fix lwt_len_hist reusing previous BPF map
Date:   Thu, 19 Nov 2020 15:06:16 +0000
Message-Id: <20201119150617.92010-7-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119150617.92010-1-danieltimlee@gmail.com>
References: <20201119150617.92010-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, lwt_len_hist's map lwt_len_hist_map is uses pinning, and the
map isn't cleared on test end. This leds to reuse of that map for
each test, which prevents the results of the test from being accurate.

This commit fixes the problem by removing of pinned map from bpffs.
Also, this commit add the executable permission to shell script
files.

Fixes: f74599f7c5309 ("bpf: Add tests and samples for LWT-BPF")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/lwt_len_hist.sh | 2 ++
 samples/bpf/test_lwt_bpf.sh | 0
 2 files changed, 2 insertions(+)
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh

diff --git a/samples/bpf/lwt_len_hist.sh b/samples/bpf/lwt_len_hist.sh
old mode 100644
new mode 100755
index 090b96eaf7f7..0eda9754f50b
--- a/samples/bpf/lwt_len_hist.sh
+++ b/samples/bpf/lwt_len_hist.sh
@@ -8,6 +8,8 @@ VETH1=tst_lwt1b
 TRACE_ROOT=/sys/kernel/debug/tracing
 
 function cleanup {
+	# To reset saved histogram, remove pinned map
+	rm /sys/fs/bpf/tc/globals/lwt_len_hist_map
 	ip route del 192.168.253.2/32 dev $VETH0 2> /dev/null
 	ip link del $VETH0 2> /dev/null
 	ip link del $VETH1 2> /dev/null
diff --git a/samples/bpf/test_lwt_bpf.sh b/samples/bpf/test_lwt_bpf.sh
old mode 100644
new mode 100755
-- 
2.25.1

