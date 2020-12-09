Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198712D40E2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgLILU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:20:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730484AbgLILUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:20:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607512730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=paX/7UAlKmbp58QFD0gyJzQyU0HAfzMzkzakh+VAmUM=;
        b=Ut2DG7fg1pAhVZlbcjfgf9bg2WexlR5jAuFY5+gr201Bov6tKKkI3e6GCtO3to+wCKIc7G
        fM+5JOXY5iTBfXEp9iqXD3TTzw7mZ0k0n7pKaJ8GW3Iw2mf96wNuhWvAd90lVJRkDHt+si
        eMtScq1n+Kq/kCYfJk37lq8zflA1L4Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-467-yd6YqGwPODO1RTNB5tEuug-1; Wed, 09 Dec 2020 06:18:48 -0500
X-MC-Unique: yd6YqGwPODO1RTNB5tEuug-1
Received: by mail-wm1-f71.google.com with SMTP id f12so430405wmf.6
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 03:18:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=paX/7UAlKmbp58QFD0gyJzQyU0HAfzMzkzakh+VAmUM=;
        b=CmDQcZGWE8rTAfOYLpUXjrXVLuO/7j155JVgElLjUbrhO6UC2EeYd0fuFnj61CrPGI
         ijfv5DXlSyjCDlzAmz7cniP2BS/Q2JxOc1haxQw/TKeMdxzA8bPjUCB/LHHk6JPyk9g+
         5B7A27pvRXQYsb2bJmlC1W4N+ceN3Vs9Q19+KgzhrX4eOMQF61ShAVYRKul9t8DSSWBe
         10MiTH/Jz87pD+vAtboUZbBSuJ/bJ9eoZdYJQ/4yrcHUMkZrhIyJmj0ur2+XWdUcpbIl
         2i4GBMModSvWEcnBDaNHMZ7OdkeVbg41Vey7zHOh7WXKaH9fBv/cGhpdJwfpfSIWeAQC
         wbQg==
X-Gm-Message-State: AOAM531Ro8704f1UPOVjEcR1+79RLTf2DvwWkP8jB6piQyvKygonkYnG
        Q7NmOayITZX9CGTUE2N77T6g0WHPm7HrSEQK2ymJ41G35Ix/rkxRyAXU4WOhH2r3cIH1dDpIYbv
        9UU0Jqnoh/9qJBEvp
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr2243675wmj.168.1607512727667;
        Wed, 09 Dec 2020 03:18:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIQXSKeI1KTNfWKjLVO4BGjQ+RlzPjAi6h6dYdW2N/q7Mg8WugtYj7pqH+1ymMCaAkwmoJxQ==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr2243632wmj.168.1607512727350;
        Wed, 09 Dec 2020 03:18:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m8sm2867185wmc.27.2020.12.09.03.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:18:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 96E5E18006E; Wed,  9 Dec 2020 12:18:44 +0100 (CET)
Subject: [PATCH bpf v3 6/7] selftests/bpf/test_offload.py: reset ethtool
 features after failed setting
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Wed, 09 Dec 2020 12:18:44 +0100
Message-ID: <160751272453.104774.14088086677950503174.stgit@toke.dk>
In-Reply-To: <160751271801.104774.5575431902172553440.stgit@toke.dk>
References: <160751271801.104774.5575431902172553440.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

When setting the ethtool feature flag fails (as expected for the test), the
kernel now tracks that the feature was requested to be 'off' and refuses to
subsequently disable it again. So reset it back to 'on' so a subsequent
disable (that's not supposed to fail) can succeed.

Fixes: 417ec26477a5 ("selftests/bpf: add offload test based on netdevsim")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/test_offload.py |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
index 51a5e4d939cc..2128fbd8414b 100755
--- a/tools/testing/selftests/bpf/test_offload.py
+++ b/tools/testing/selftests/bpf/test_offload.py
@@ -946,6 +946,7 @@ try:
     start_test("Test disabling TC offloads is rejected while filters installed...")
     ret, _ = sim.set_ethtool_tc_offloads(False, fail=False)
     fail(ret == 0, "Driver should refuse to disable TC offloads with filters installed...")
+    sim.set_ethtool_tc_offloads(True)
 
     start_test("Test qdisc removal frees things...")
     sim.tc_flush_filters()

