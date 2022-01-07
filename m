Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A6487ECC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 23:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiAGWL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 17:11:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:54322 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbiAGWL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 17:11:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641593485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=omVKaNcy5fAR+P8CusXzfyn6nmrKkdfnGWZtZt9VL2k=;
        b=CcJxrSiTiig2SoPXns65u67PGVFyQohNlHYHv8noAgHi5LoPsaMg+bNyTC1jZpWY5WvPey
        Ih0n89NIOARV9E0m9ZP5L/RYg5wbNbuUcxbJGx8Ys5i9xKmzhe0UKo96DUA7u77IyG+XS2
        9ZVx+V32ohJfvOhin5esGobRUDGx8Kc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-355-hyZRS1uEO3G1gAKYi3sebw-1; Fri, 07 Jan 2022 17:11:24 -0500
X-MC-Unique: hyZRS1uEO3G1gAKYi3sebw-1
Received: by mail-ed1-f71.google.com with SMTP id v18-20020a056402349200b003f8d3b7ee8dso5748152edc.23
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 14:11:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=omVKaNcy5fAR+P8CusXzfyn6nmrKkdfnGWZtZt9VL2k=;
        b=BqKpAjfU/BSgTqztqveFc2RSsl0FNpmic2bABozPQifKc+gV7XgfY2yugJ8uyDa5RC
         6ZZSMRbdkdphl3OhZME0m9NNSdqFC5gZC0b3hgvqaMyMkViJbfno3+Yr9f0E/48hkXVK
         2WXaYbFGjSyDCaX53GP3qUgxydRBtjd5MT1/bB7iSLBsMAV66tVA5l1wZgc9+Wct5wN7
         IDXYh8EY+VlrSpQePR/ICZbiEcD1Fs71JGFNzgWSfktRzcu57KL8Qn+JKdM/16PsZwoV
         47DBCu+jcxMLjtc4xv1czXWpx3K1wdEjlVnc2KQFraD3AWysZNvaS34nwE1vKer5WO2U
         Qktg==
X-Gm-Message-State: AOAM5333vQM2DVOb4iPM9ok8tJKFtPKBIRdmzRCxVBrgPK+qg6N2SL3M
        UBg915QD91KNEe5KBThm2OF6IkN39ttYTG9aXTB+Q0sdGvaJ94YwlECT08jgKoJejmFhTjECupW
        +h/3t2q7SnRJ3bIua
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr65522105edu.148.1641593481125;
        Fri, 07 Jan 2022 14:11:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKzpJCWoqaZSxUYfC+gJ25uxor1OuK6byXmPFu4l+4AGwMSieKYCB5o2yckQxwbmLbVn0IGg==
X-Received: by 2002:a05:6402:154:: with SMTP id s20mr65521979edu.148.1641593478704;
        Fri, 07 Jan 2022 14:11:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g7sm1744790ejt.29.2022.01.07.14.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 14:11:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4F592181F2E; Fri,  7 Jan 2022 23:11:17 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v2 3/3] bpf/selftests: Add check for updating XDP bpf_link with wrong program type
Date:   Fri,  7 Jan 2022 23:11:15 +0100
Message-Id: <20220107221115.326171-3-toke@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107221115.326171-1-toke@redhat.com>
References: <20220107221115.326171-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check to the xdp_link selftest that the kernel rejects replacing an
XDP program with a different program type on link update.

v2:
- Split this out into its own patch.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/xdp_link.c | 5 +++++
 tools/testing/selftests/bpf/progs/test_xdp_link.c | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
index eec0bf83546b..b2b357f8c74c 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@ -127,6 +127,11 @@ void serial_test_xdp_link(void)
 	ASSERT_EQ(link_info.prog_id, id1, "link_prog_id");
 	ASSERT_EQ(link_info.xdp.ifindex, IFINDEX_LO, "link_ifindex");
 
+	/* updating program under active BPF link with different type fails */
+	err = bpf_link__update_program(link, skel1->progs.tc_handler);
+	if (!ASSERT_ERR(err, "link_upd_invalid"))
+		goto cleanup;
+
 	err = bpf_link__detach(link);
 	if (!ASSERT_OK(err, "link_detach"))
 		goto cleanup;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_link.c b/tools/testing/selftests/bpf/progs/test_xdp_link.c
index ee7d6ac0f615..64ff32eaae92 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_link.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_link.c
@@ -10,3 +10,9 @@ int xdp_handler(struct xdp_md *xdp)
 {
 	return 0;
 }
+
+SEC("tc")
+int tc_handler(struct __sk_buff *skb)
+{
+	return 0;
+}
-- 
2.34.1

