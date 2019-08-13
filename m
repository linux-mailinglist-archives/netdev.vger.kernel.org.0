Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAD48B813
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfHMMIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:08:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44326 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727425AbfHMMIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:08:02 -0400
Received: by mail-pf1-f194.google.com with SMTP id c81so2490750pfc.11;
        Tue, 13 Aug 2019 05:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/VLzgSwz7Ojl/rXjGtgOE1lI6r7B7q/BQ6+SStfrnZg=;
        b=Xw/SEa83cOPsCLVKND0fZ+qg5AuHySmttLZmQ7M0SFq1S+BOLvfDiWPs+38TQNHKa1
         rC6VxxOzKfoikkgaPLtlfuv29bHz0GUxupQsx9z3mPyExd9geHUiP4t92jVsxZ1w7oKj
         TBEDkwIHoJJLO16dJ003rzCkewMx5ZLlxc8ke7gYCS2KtEaqDQ7xdeVgP33thiHhff36
         0yecyWBhyqa7lyGQ157a+LPqngtvQsjk0rajWGzPG7hu4NTpxvrtIGakkXYxDSpsdo7P
         YF/32sUAkMmNM07O+0QG4tZWAarTI+Bkb4la0iN72xYwaDo4WukwnJkp0YgU+ob165qR
         WnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/VLzgSwz7Ojl/rXjGtgOE1lI6r7B7q/BQ6+SStfrnZg=;
        b=eOa2tj/NsO3xO2pl/hmEPVFl4wfmabbV9tCjciI8irgJHKW7CIBj/VWkt8QkJAbIjm
         SHaI40gOIeUHjVS2NTwwI6ltuDY3fO/LccqsiKqqF3/CRyAMg/1qjLnhE/vq/CJ8zg4I
         9DHY23u2SZmvf/Oo4+daaOwuTgee1U0R/c5+00Nl2n/qGhUs8uMdk4dPXI6WIzPt3quu
         VXH2VZF5PEwtlVoyv8sZfcT2zl78S6hxjoorxq4nPbsa3mB+YP1apTFilVz09KxncrJR
         FcfCJPnIoPLd96KUrKliFly7gVHghwKT//dcgaykM9T3iKFXgIBCefeSuiPkJCNCTzvD
         lFVw==
X-Gm-Message-State: APjAAAVjPLh4DQ/1pIVli61IwPOQ9TzAlWxGayNVfVPagBB1CN1DWgvl
        3V0ZBgKA3XCYDIfHSsWoiRU=
X-Google-Smtp-Source: APXvYqzN/XMbIA9OkqiXo15s/d0kDOEJ88WmDPlbw9beP2ZkxhxCMwN3AKbgYyGbDerhQ4lI03NOuw==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr34018783pgd.241.1565698081438;
        Tue, 13 Aug 2019 05:08:01 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:08:00 -0700 (PDT)
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
Subject: [RFC PATCH bpf-next 11/14] xdp_flow: Implement vlan_push action
Date:   Tue, 13 Aug 2019 21:05:55 +0900
Message-Id: <20190813120558.6151-12-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another example action.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/xdp_flow_kern_bpf.c | 23 +++++++++++++++++++++--
 net/xdp_flow/xdp_flow_kern_mod.c |  5 +++++
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/net/xdp_flow/xdp_flow_kern_bpf.c b/net/xdp_flow/xdp_flow_kern_bpf.c
index 8f3d359..51e181b 100644
--- a/net/xdp_flow/xdp_flow_kern_bpf.c
+++ b/net/xdp_flow/xdp_flow_kern_bpf.c
@@ -90,10 +90,29 @@ static inline int action_redirect(struct xdp_flow_action *action)
 static inline int action_vlan_push(struct xdp_md *ctx,
 				   struct xdp_flow_action *action)
 {
+	struct vlan_ethhdr *vehdr;
+	void *data, *data_end;
+	__be16 proto, tci;
+
 	account_action(XDP_FLOW_ACTION_VLAN_PUSH);
 
-	// TODO: implement this
-	return XDP_ABORTED;
+	proto = action->vlan.proto;
+	tci = action->vlan.tci;
+
+	if (bpf_xdp_adjust_head(ctx, -VLAN_HLEN))
+		return XDP_DROP;
+
+	data_end = (void *)(long)ctx->data_end;
+	data = (void *)(long)ctx->data;
+	if (data + VLAN_ETH_HLEN > data_end)
+		return XDP_DROP;
+
+	__builtin_memmove(data, data + VLAN_HLEN, ETH_ALEN * 2);
+	vehdr = data;
+	vehdr->h_vlan_proto = proto;
+	vehdr->h_vlan_TCI = tci;
+
+	return _XDP_CONTINUE;
 }
 
 static inline int action_vlan_pop(struct xdp_md *ctx,
diff --git a/net/xdp_flow/xdp_flow_kern_mod.c b/net/xdp_flow/xdp_flow_kern_mod.c
index caa4968..52dc64e 100644
--- a/net/xdp_flow/xdp_flow_kern_mod.c
+++ b/net/xdp_flow/xdp_flow_kern_mod.c
@@ -55,6 +55,11 @@ static int xdp_flow_parse_actions(struct xdp_flow_actions *actions,
 			action->ifindex = act->dev->ifindex;
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
+			action->id = XDP_FLOW_ACTION_VLAN_PUSH;
+			action->vlan.tci = act->vlan.vid |
+					   (act->vlan.prio << VLAN_PRIO_SHIFT);
+			action->vlan.proto = act->vlan.proto;
+			break;
 		case FLOW_ACTION_VLAN_POP:
 		case FLOW_ACTION_VLAN_MANGLE:
 		case FLOW_ACTION_MANGLE:
-- 
1.8.3.1

