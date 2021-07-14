Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B8F3C87F0
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 17:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239701AbhGNPur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 11:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhGNPur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 11:50:47 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C5C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 08:47:55 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i5so4409530lfe.2
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 08:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgEu55wIweQXk+rwT4ltUksXYjzK50iHIOkTGVvZXrI=;
        b=sauXd+CpZoMmcv+/BbUhRDJdIDPk23FAQd0VIkzxdllLuFe3Xt9WjAysw6/JPDWxYI
         uqnp9qIJReFeoVxbIJbP/ICYw+GFaX4YfvSce+pzf08bZn82TUTqSQeq9yZB9sTWwXNq
         3HNk7Cb/7/FfSDoCRPVv1LJ7qVNAhngqMnyjM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgEu55wIweQXk+rwT4ltUksXYjzK50iHIOkTGVvZXrI=;
        b=ppK8ut+dUb6EMh5LJmggurHrtbl0jbCNVtjtHCbnatnrdN8fjeOmHFxu9VtjtVEYr8
         dsUIg5CN3Dmcq5iWQ0H/C25+9+GFzZ2wX7ntxYXhxYbilOpP//W5PQcVHg9PUb/beyOk
         fCwluslOWUNjPT5e8PbdZCrKktcxEVUAdn9d+7xKQZiVQbuFIbvqTHOBhOFn+FB8aoQL
         k79qK4DOWzf+5XWKiFVLHmZ2uMc8loiUDICW9GU++bAPeuHPHkoN1GHaf+8aiZl3i5NE
         Q/Z0B3N1RqUl5xANQPcGjMpOfYPmCsbOeLjju7ZUmULDrezG6CCGiFKXcMzJoBSvVcPb
         NvsQ==
X-Gm-Message-State: AOAM531QYYCNF0yIvi97BuAMwl6knlV4JKpRIezkXhqYcgx8LiJrpLn8
        XfJu2ZS6ssarz2u3XAhAdOq9ug==
X-Google-Smtp-Source: ABdhPJzDI7Z0S9YxxtZKjQ+5IkN9C4mlUg8kVpEkDNvk7IeNJGYLNE/oCsPxTiqqoDlN+4ntGRijCw==
X-Received: by 2002:a19:4411:: with SMTP id r17mr8784205lfa.82.1626277672893;
        Wed, 14 Jul 2021 08:47:52 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id e20sm265174lji.140.2021.07.14.08.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 08:47:52 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf v2] bpf, sockmap, udp: sk_prot needs inuse_idx set for proc stats
Date:   Wed, 14 Jul 2021 17:47:50 +0200
Message-Id: <20210714154750.528206-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
We currently do not set this correctly from sockmap side. The result is
reading sock stats '/proc/net/sockstat' gives incorrect values. The
socket counter is incremented correctly, but because we don't set the
counter correctly when we replace sk_prot we may omit the decrement.

To get the correct inuse_idx value move the core_initcall that initializes
the udp proto handlers to late_initcall. This way it is initialized after
UDP has the chance to assign the inuse_idx value from the register protocol
handler.

Fixes: edc6741cc660 ("bpf: Add sockmap hooks for UDP sockets")
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

v2:
- Fixed "Fixes" tag (Cong Wang)

 net/ipv4/udp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_bpf.c b/net/ipv4/udp_bpf.c
index 45b8782aec0c..9f5a5cdc38e6 100644
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@ -134,7 +134,7 @@ static int __init udp_bpf_v4_build_proto(void)
 	udp_bpf_rebuild_protos(&udp_bpf_prots[UDP_BPF_IPV4], &udp_prot);
 	return 0;
 }
-core_initcall(udp_bpf_v4_build_proto);
+late_initcall(udp_bpf_v4_build_proto);
 
 int udp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore)
 {
-- 
2.31.1

