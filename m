Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7BF6F4945
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234288AbjEBRoQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjEBRoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:44:14 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492F2C3;
        Tue,  2 May 2023 10:44:11 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-55a2691637bso40609217b3.0;
        Tue, 02 May 2023 10:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683049450; x=1685641450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ws5j/dI0nYox1o3GIO+GjjxWpnPjNPrD+4R2eJ37G04=;
        b=agLweq+Hgw+KwpZ9g96mCqhPUpKHetp5atMN3v05x2Sdxul/yfjMV/m20XmAoa1VaR
         ry9Z2l+6XrPC1qlxSer7soKE1KTJCb8bgS/w5aY0X3NYke8q02WfEy7Ne51BBDWLnZm8
         1DfYdqhmrA0jgxKzMmQqz/LZYqrvl/kj/UUwyFIHsHKeV21lVP5BM+awqWYcpDrcIkSc
         B7g/ERQrGD2PwT621z+okSUjq8+vXI7bUZZ2C+H72L2o8VYiCFlgeE5K9dnpjhqNKcA4
         9M0FfBSodScePvz32bkP4isvv2GrNF/WxyiDxipuWnUsjF1VyDosuFt8AcPtjOX+y8de
         74zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683049450; x=1685641450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ws5j/dI0nYox1o3GIO+GjjxWpnPjNPrD+4R2eJ37G04=;
        b=K4ffdwe7fkD97hgQYwLzywmF+rUAdUXRdX+ekM8xb5KPGVVGSBaCfUhwn7kf+TyVph
         TwRKk9aX0BaH8gMeiHxFxAgKvjPRhrqUrSFVpzCzaXJnM0s4VndiB0/uSwSq26i3cxP5
         Hv/whQ+UywQIpurmINxuMEWpPWZiXJibV4qQwswmb10k+KwGamKCxDZ19B64husLyhws
         ikvOI4W9z1VNRyM57aOlR79cxJeg6lxcSz7yT6iNrbxbKyihblXdZUPKGL7ViEKyg8qe
         b3qt31+/fa/+QfiOAGNWwj2jcHnb7/5kxHkzAmWIKLQdP3LrLEteSNvqiMEMfb/AJuc9
         Dv1g==
X-Gm-Message-State: AC+VfDwrfGqoZC99pfU7uZPinmQ7T79JkJxaDOAyydgqBRsh7g9tuUKG
        lTPWr/gmXnKSRP1cGMWEjTJUWDncoUI=
X-Google-Smtp-Source: ACHHUZ6aPaZ7dpAAkU/aHe6CXoJqaQ94S0jCVnLuk/UrtTvAemcSK41fHAgqYgZcTp3A/voySR9+fw==
X-Received: by 2002:a25:d288:0:b0:b9a:74f6:2738 with SMTP id j130-20020a25d288000000b00b9a74f62738mr17204611ybg.38.1683049450089;
        Tue, 02 May 2023 10:44:10 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:42a1:f9ec:2dbe:d4e])
        by smtp.gmail.com with ESMTPSA id u7-20020a252e07000000b00b98dbbedb73sm7018211ybu.43.2023.05.02.10.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 10:44:09 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Subject: [Patch net] vsock: improve tap delivery accuracy
Date:   Tue,  2 May 2023 10:44:04 -0700
Message-Id: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When virtqueue_add_sgs() fails, the skb is put back to send queue,
we should not deliver the copy to tap device in this case. So we
need to move virtio_transport_deliver_tap_pkt() down after all
possible failures.

Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/vmw_vsock/virtio_transport.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index e95df847176b..055678628c07 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 		if (!skb)
 			break;
 
-		virtio_transport_deliver_tap_pkt(skb);
-		reply = virtio_vsock_skb_reply(skb);
-
 		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
 		sgs[out_sg++] = &hdr;
 		if (skb->len > 0) {
@@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 			break;
 		}
 
+		virtio_transport_deliver_tap_pkt(skb);
+		reply = virtio_vsock_skb_reply(skb);
 		if (reply) {
 			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
 			int val;
-- 
2.34.1

