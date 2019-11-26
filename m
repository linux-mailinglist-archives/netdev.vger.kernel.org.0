Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57E5B10A520
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 21:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfKZUNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 15:13:04 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44485 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZUNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 15:13:04 -0500
Received: by mail-oi1-f195.google.com with SMTP id s71so17836908oih.11;
        Tue, 26 Nov 2019 12:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nWXvBe8iHv2e1HrWC91gojWLhn523EghSo2ykxPHbqU=;
        b=pLKc4Sgt83cCty7y3uDo50AVWsudPf7KjkxbiFHhdSHn3c2hRoSBDM2JLYBUxV1tSP
         SLjy0cv/dPXBO8Vs8FKEIDZnVBIoHAEtnVBgLry7mAN/WID2pmhomxJBagLj3D/VaWLe
         V8EuElcIdHPotR99lG1+4W8PNp+U0cLUrvdQ+zSHq+OUZbu0Yir3HR1jHnu1NZaUQg6J
         MjxXW/8lZ9B429oBOYF2wEwI4Qrr7wYFuLAab+t/KtrPBCCptxD2zD3r7sFWo3mpun3d
         hSbpTmnkFt2Kd87raS0SmtOz2I3jZtEODnjulXNoBvTmbwOzV0nkU8h7tYq+PUPSR57Z
         1qDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nWXvBe8iHv2e1HrWC91gojWLhn523EghSo2ykxPHbqU=;
        b=AVodZ39JcWjvxEntNYvXQSazb4V83j8Hbi6n9QKGzju+upwrmD1JPc/pNiztz8p3gJ
         0jgmgGXLsS4TxcaehyaDTr69hbvAt8I51/RQtaDjicffErUMUvMGjhn4tEFpHd9bfDV7
         I6hHAnk8O6yf7ZEuglK/d1FHrkxvOS5FMwFe+hx0P/LPltkvCH8abBdKc9hTysveVIng
         F/JsX38fC+nyUll2zo4ofnoN4lF7txPjFqGtWFCa158dxK8NhY5nbQWBnvL+4Qj3qTKs
         codFw972H8PTJnLfo3dEn+1So9FpuDc+xHw93gQwdYV4vaxNViFhoSgQhE0vG/hJI6Di
         Usjg==
X-Gm-Message-State: APjAAAU9EkgA9BNc+OjEgeVR/IvOWpX1N9InhvZBPtK0nwyAdG47vYKQ
        0BNto77ZnUwQPfyYTVcjjNXXU5+r
X-Google-Smtp-Source: APXvYqz0+3tinyCTs/QonbBWOqSQwEdVYtN5Yuzp6nAaQo4LzvHIgPVdiRQM9CHSHWbw68sfN07ywA==
X-Received: by 2002:aca:b708:: with SMTP id h8mr787878oif.126.1574799182939;
        Tue, 26 Nov 2019 12:13:02 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::7])
        by smtp.gmail.com with ESMTPSA id e186sm4033064oia.47.2019.11.26.12.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 12:13:02 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] netfilter: nf_flow_table_offload: Don't use offset uninitialized in flow_offload_port_{d,s}nat
Date:   Tue, 26 Nov 2019 13:12:26 -0700
Message-Id: <20191126201226.51857-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns (trimmed the second warning for brevity):

../net/netfilter/nf_flow_table_offload.c:342:2: warning: variable
'offset' is used uninitialized whenever switch default is taken
[-Wsometimes-uninitialized]
        default:
        ^~~~~~~
../net/netfilter/nf_flow_table_offload.c:346:57: note: uninitialized use
occurs here
        flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
                                                               ^~~~~~
../net/netfilter/nf_flow_table_offload.c:331:12: note: initialize the
variable 'offset' to silence this warning
        u32 offset;
                  ^
                   = 0

Match what was done in the flow_offload_ipv{4,6}_{d,s}nat functions and
just return in the default case, since port would also be uninitialized.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Link: https://github.com/ClangBuiltLinux/linux/issues/780
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c54c9a6cc981..a77a6e1cfd64 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -340,7 +340,7 @@ static void flow_offload_port_snat(struct net *net,
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
-		break;
+		return;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
@@ -367,7 +367,7 @@ static void flow_offload_port_dnat(struct net *net,
 		offset = 0; /* offsetof(struct tcphdr, dest); */
 		break;
 	default:
-		break;
+		return;
 	}
 
 	flow_offload_mangle(entry, flow_offload_l4proto(flow), offset,
-- 
2.24.0

