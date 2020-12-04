Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4012CED93
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387888AbgLDLxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:53:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32136 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730139AbgLDLxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607082734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IK/QJ/mwWf6qYNme1m53SvUyoc+tECiyzDRKMtRU8jo=;
        b=Sjlujd57bh8FzQpguB/8lHFDAidt/KIjok2eG5p2vtn4wRmKtomTcciZ0+avcoPvNXukJP
        l+zXMtSgy6ll+hHlMkXCFOOLRyqf2sb+S6nODUrk+zjsUSs3K4temFmD5LeFvsMUNP4pDG
        8dD+jSGMZ8NAJpJgDIzFPufVDLt9RtM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-Gsq_RZlLPgKrTLvTS0X8_g-1; Fri, 04 Dec 2020 06:52:13 -0500
X-MC-Unique: Gsq_RZlLPgKrTLvTS0X8_g-1
Received: by mail-ed1-f70.google.com with SMTP id ca7so2260925edb.12
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IK/QJ/mwWf6qYNme1m53SvUyoc+tECiyzDRKMtRU8jo=;
        b=FOH9wpKnNRhy4lLshM+awH/1tijgbMeNF0Kltz/94Bi6IAAjKhozSZu1gk8PYU7GXh
         ViRsrFi6KnwX03kvqHWcP29da1EiTJdbnzrrR5HQF4Wi7gryhbgC89X/mv5zFyz/7e/i
         3f+BRcaimO3bX5koeDmH5XkGQsnDqeQsF1r6Rqo1CUBkkk/SuAcwUml8PUcxzLK0xbCn
         p/qIdRXaFDlne0XLvUzwmaYyQSh9w40lqbNWJ5RKhRyFQUV/4v1ZgHmw8/v4xcdgvF7o
         LBGOpnGW0HsxJ5UYPcUidsRxWg3aNdmKtgyq4tVefQ7qkRAFnvPJOJuOA03iuM5+stfg
         TB1w==
X-Gm-Message-State: AOAM530bAo9vx8RrHohBYL7s8jF3x87QtmUGJ2B7NXtEKdrbz2tznFsW
        vpLH2d9RQdxf2JOxLvSUIbCAVnqrfBVxTRwvHJ7iewuCHQap4wElnL/4QfMLN4rnh9YPvsxU5Lo
        VdhZj8VazO8w4CveV
X-Received: by 2002:a17:906:e082:: with SMTP id gh2mr6434418ejb.406.1607082731590;
        Fri, 04 Dec 2020 03:52:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJnmnrQQFUZtCpPBo0okVYdCn+4YqUFrQtfBWBO5pOeK9MIHcNI5YMcL0nBkzararsSM8lqA==
X-Received: by 2002:a17:906:e082:: with SMTP id gh2mr6434391ejb.406.1607082731155;
        Fri, 04 Dec 2020 03:52:11 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id e12sm3344289edm.48.2020.12.04.03.52.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:52:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C9F751843EC; Fri,  4 Dec 2020 12:52:08 +0100 (CET)
Subject: [PATCH bpf v2 6/7] selftests/bpf/test_offload.py: reset ethtool
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
Date:   Fri, 04 Dec 2020 12:52:08 +0100
Message-ID: <160708272873.192754.13552481233579004069.stgit@toke.dk>
In-Reply-To: <160708272217.192754.14019805999368221369.stgit@toke.dk>
References: <160708272217.192754.14019805999368221369.stgit@toke.dk>
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

