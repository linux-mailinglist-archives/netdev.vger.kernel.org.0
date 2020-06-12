Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFAB1F7B5B
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 18:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgFLQCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 12:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgFLQCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 12:02:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21ADC08C5C1
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 09:02:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so10281289wru.0
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 09:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zQejEshYFNqUb7v3sioackX6D/pyfet7gpxzYUl52wE=;
        b=PBYbhxCMm9X+7/S47/3y+XNZktGaW42Z7fcfOreCztwwDU50QNAbPSjHdjzR+nZFit
         305TjsQRfWasNDoU/NywVe2HLHqNrWeS7kF/hLOrAeXpuypJ4icYBdiY3OxolNpJVbsC
         j2Bp60+NVG2kGFpa1PAj91qYQMPUEWyZsQQqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zQejEshYFNqUb7v3sioackX6D/pyfet7gpxzYUl52wE=;
        b=ESKx+nqP3nTcoBoqa54M266gIaPD9kWxQIkPX41CwLDpCz6rqLYJIwU2KYwK5Kto5C
         sl4CIO4dHzwx0EWCYxgM22krAN++hISfJz3Vm33KLj+3deKswKQwJyo8vEbsWJjnf6/E
         YDYVPWijyT6/PupXu8fY7uzQA4fYuY5rRugVbVuTc7byX/OEmTrib3oL8M+cxdFHsOwI
         P5A0ESkE7kXVuLoXFwBd23eSvprqVxwXze2Spz18HUyBPWxXQh1ytlhKVz5Moug1w8fw
         UdAhuJ3zMS9f6KuXBpKKp6haGBqFw5/6SB4gIznMtUbwqmrTIQQ0R3jP2XzYCWVsRYTT
         VuLw==
X-Gm-Message-State: AOAM531399rDAPsz1xkv08mlLAMv2plVrQXk+hrBQeASkH/3l4iQ7ceK
        fch/jIg4rAxpYAp7ydkXK2F9KhrfgJpAml1i
X-Google-Smtp-Source: ABdhPJwmxuL4QdXOsFvU61egyGC88qJdz9nI+m0Pp8bmpgmWGAwH/RDq42CraRgRg31Tvv29fPJ3/g==
X-Received: by 2002:adf:e9cb:: with SMTP id l11mr15244107wrn.86.1591977720712;
        Fri, 12 Jun 2020 09:02:00 -0700 (PDT)
Received: from antares.lan (1.e.7.e.0.1.3.6.1.5.d.2.f.1.0.9.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:901f:2d51:6310:e7e1])
        by smtp.gmail.com with ESMTPSA id k16sm11169941wrp.66.2020.06.12.09.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 09:02:00 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf 2/2] bpf: sockmap: reject invalid attach_flags
Date:   Fri, 12 Jun 2020 17:01:41 +0100
Message-Id: <20200612160141.188370-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200612160141.188370-1-lmb@cloudflare.com>
References: <20200612160141.188370-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using BPF_PROG_ATTACH on a sockmap program currently understands no
flags, but accepts any value. Return EINVAL if any flags are specified.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
---
 net/core/sock_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 00a26cf2cfe9..6f0894909138 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -70,6 +70,9 @@ int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *prog)
 	struct fd f;
 	int ret;
 
+	if (attr->attach_flags)
+		return -EINVAL;
+
 	f = fdget(ufd);
 	map = __bpf_map_get(f);
 	if (IS_ERR(map))
-- 
2.25.1

