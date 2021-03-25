Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F139E349B73
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 22:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhCYVMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 17:12:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230341AbhCYVLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 17:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616706706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TNs0UXcUiaKuVEx3mnWkq8N4wvcF6O32GQhcLyoLTFo=;
        b=A7AHh29DtKEFcNbGoXWL7BqoyE9daMP6Ak7b/aJewoev00mKJWUs0sOczkmKexjWA3TBRo
        lCS+wz8/jw/V/E75SYEbnqm1CBi3zRaEbqZHAzh8Nga/lAKvm11SUWh0/BSgFeMXJb09Fz
        zDOp/ck2+3GFdeWfHMCoMf2CMv09eO4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-2TBP1gJUPF6s4N6jpohCKg-1; Thu, 25 Mar 2021 17:11:43 -0400
X-MC-Unique: 2TBP1gJUPF6s4N6jpohCKg-1
Received: by mail-ej1-f71.google.com with SMTP id k16so3176862ejg.9
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 14:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TNs0UXcUiaKuVEx3mnWkq8N4wvcF6O32GQhcLyoLTFo=;
        b=JqL3QKQrqyynzjmuHC9KM4zosW1nXWzeUzdanSSjy3m/nboO/fPBNIEoMjtbSeYMOT
         l4VlCQD3FtkU6xrtMOybLjh2CNkOSKH3JSOL80gCX9DZ9fmaSuPqHYad3Yr15XV952b8
         SFYdP4AKl50O7CWq+XIJDnmPNQGxZ6JogBPzsLCcBapNY7cqImTRK2fUSVnXljF6tILS
         LQz/7qDzjpZa1q7K2lMTz749Ps+odAjcdFmBtCxlZWiXNU6POdSB9gT9n9MBXU61BTfM
         ldorYdsHarLkLwLU6z+ZJzVkNqhTJTmxplZWE23rlWjjOD06QVeYKAx5eReQJRTTRVs6
         sxoA==
X-Gm-Message-State: AOAM530D0iI3ktiWxJ4VoKmCJUo07dYM14YfWe8pn3LUW92cvV44n6ne
        nwQ3xH6rh/ueX4N8YG3RZkRTwy3CSZrKarLmA0W8Sw+npTznhcwDa+Duj4iKndeMm/KLTc1f5kv
        vU8g5B0bq4W6C/NOv
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr11191666edv.44.1616706702148;
        Thu, 25 Mar 2021 14:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1FteeQQVFdTUCTr+XxdOclFOaKp764+qfSaHVpvq+RfJpExeEgB2GKDjn/XIsjUepv/bonA==
X-Received: by 2002:a05:6402:19a:: with SMTP id r26mr11191617edv.44.1616706701660;
        Thu, 25 Mar 2021 14:11:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u1sm3163116edv.90.2021.03.25.14.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 14:11:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 851171801A3; Thu, 25 Mar 2021 22:11:40 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v2 1/2] bpf: enforce that struct_ops programs be GPL-only
Date:   Thu, 25 Mar 2021 22:11:21 +0100
Message-Id: <20210325211122.98620-1-toke@redhat.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of the struct_ops program type, it became possible to
implement kernel functionality in BPF, making it viable to use BPF in place
of a regular kernel module for these particular operations.

Thus far, the only user of this mechanism is for implementing TCP
congestion control algorithms. These are clearly marked as GPL-only when
implemented as modules (as seen by the use of EXPORT_SYMBOL_GPL for
tcp_register_congestion_control()), so it seems like an oversight that this
was not carried over to BPF implementations. Since this is the only user
of the struct_ops mechanism, just enforcing GPL-only for the struct_ops
program type seems like the simplest way to fix this.

v2: Move check to the top of check_struct_ops_btf_id().

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 44e4ec1640f1..3a738724a380 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12158,6 +12158,11 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
 	u32 btf_id, member_idx;
 	const char *mname;
 
+	if (!prog->gpl_compatible) {
+		verbose(env, "struct ops programs must have a GPL compatible license\n");
+		return -EINVAL;
+	}
+
 	btf_id = prog->aux->attach_btf_id;
 	st_ops = bpf_struct_ops_find(btf_id);
 	if (!st_ops) {
-- 
2.31.0

