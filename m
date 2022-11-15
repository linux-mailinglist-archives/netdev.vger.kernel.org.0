Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3932629064
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiKODEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237545AbiKODDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:03:13 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AF825CB
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:21 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id r126-20020a632b84000000b004393806c06eso6750404pgr.4
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 19:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uak+AW+U5N4YbNn9buxZQp6UdtaFEKD9ZsMrNaxGG78=;
        b=IJf/QnwPGrSOWHjPA+9ALOSOh1NqTsi7DNF5o+Ei0MEPHu3z8rVErhbWDW95Xosh6Q
         uIBw9AgpUELCuBvp7NE8jOywhhD14OWbd78fEpD6KxeVYeOJoAmeyT0cCxCKVBRoR43c
         /6xdh7hMjmO+XCoGDf8FglKZERcU0WkoRUeHblmrOArJDbR8R6Ss6ko8vZDfltoFJS2M
         HIf4E/Rd05rwvEfBTnJTl9AYs3HcQrTnW7JJ8cVq+HBocflxY2Z1/iM46aeDi/Xb7xm4
         eFMvBRDWXPWdAaEwFcbd4HsFoNUByfHnFSyu8YxGlhbGhjJXdZGHki+EooWK7TxPBQsf
         Q7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uak+AW+U5N4YbNn9buxZQp6UdtaFEKD9ZsMrNaxGG78=;
        b=SBH0Ll/kGwe9BmbpvtuemUBgGzehrfpl1K1sjvNc6Ura2191amoS13lWlF0NHSt7Nb
         qcaC0zsMWKTes6/nN4HPwCKvTgvu9uRrToqwfIOGtzGCSE4j7h9+QHfnF6+7cZedErm1
         GaJUb4nnTtcOoHprWw2xrdVo4Fn2UkJbBj1nuyaBf5NGugFCjgPPwKzW+EjGp8RiGcTH
         PjcRMeDabrby8VsyrCmLJsrYOjyA6l4htYFHbkyzDUxy8qNZdpi6h3IG7Iqnp2aWWt6Z
         JJQg2s6BtpjGbFPW/IrNS2p18ikkIOyZLmI8o2q1tDKMdmuFRLa7Iukmcj5pKjkJT/xm
         8qcg==
X-Gm-Message-State: ANoB5pnRS3rSaZsOonEIsK//ZoYKhQJp7SiA5Pu2K7vrMWVrVG7x6YOw
        lLn5u7ObGT2YEl82EIPngA+0fF8=
X-Google-Smtp-Source: AA0mqf7XuKdCJk8xpjbtBEno+Sz5is/P53QXTUKvG4x+k1O80lInCyELmD/UVxjXkUNmhMxob/eWiBA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e546:b0:186:c56d:4950 with SMTP id
 n6-20020a170902e54600b00186c56d4950mr2116464plf.69.1668481341128; Mon, 14 Nov
 2022 19:02:21 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:02:04 -0800
In-Reply-To: <20221115030210.3159213-1-sdf@google.com>
Mime-Version: 1.0
References: <20221115030210.3159213-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115030210.3159213-6-sdf@google.com>
Subject: [PATCH bpf-next 05/11] veth: Support rx timestamp metadata for xdp
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The goal is to enable end-to-end testing of the metadata
for AF_XDP. Current rx_timestamp kfunc returns current
time which should be enough to exercise this new functionality.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/veth.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2a4592780141..c626580a2294 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -25,6 +25,7 @@
 #include <linux/filter.h>
 #include <linux/ptr_ring.h>
 #include <linux/bpf_trace.h>
+#include <linux/bpf_patch.h>
 #include <linux/net_tstamp.h>
 
 #define DRV_NAME	"veth"
@@ -1659,6 +1660,18 @@ static int veth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 }
 
+static void veth_unroll_kfunc(const struct bpf_prog *prog, u32 func_id,
+			      struct bpf_patch *patch)
+{
+	if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP_SUPPORTED)) {
+		/* return true; */
+		bpf_patch_append(patch, BPF_MOV64_IMM(BPF_REG_0, 1));
+	} else if (func_id == xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP)) {
+		/* return ktime_get_mono_fast_ns(); */
+		bpf_patch_append(patch, BPF_EMIT_CALL(ktime_get_mono_fast_ns));
+	}
+}
+
 static const struct net_device_ops veth_netdev_ops = {
 	.ndo_init            = veth_dev_init,
 	.ndo_open            = veth_open,
@@ -1678,6 +1691,7 @@ static const struct net_device_ops veth_netdev_ops = {
 	.ndo_bpf		= veth_xdp,
 	.ndo_xdp_xmit		= veth_ndo_xdp_xmit,
 	.ndo_get_peer_dev	= veth_peer_dev,
+	.ndo_unroll_kfunc       = veth_unroll_kfunc,
 };
 
 #define VETH_FEATURES (NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_HW_CSUM | \
-- 
2.38.1.431.g37b22c650d-goog

