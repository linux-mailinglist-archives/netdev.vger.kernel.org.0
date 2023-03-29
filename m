Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EE76CEFDF
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjC2Qwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjC2Qwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:52:45 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237896198
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:52:07 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id m6so12115095qvq.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 09:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680108726;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TJcSi47EhXNIDZ28a5A+wUVsGYy6JkYPL7x7pr4x14E=;
        b=WuSoUr/TbmkUjF2NfkFCiLWNR8BN63Wj2yZKpy+M4B64e8/kMV22C47oGxbcMFfC8a
         u9K2KoG11gGOJV88vDBO0cHYSNjLau+amgIYXgnJy/mkhyPjfbPl1bpR55+gGFA/0T2X
         Y3lycNnqyZdxaqxkJIKbMiDC1r8Gj8OTmpBMCymksqnij1usKSqpDIrarl3NgzaZfqjV
         S8/uoEwaxx27oTUV+7urz/oarTKj5kZLJTFUkzuHdx3bRJJLEiJmTH7P8ajdrR5lzv0o
         t0b5e7GwE3jiwm57u4EC/aaFF4fkZN9gaSFM6g80KTSZHj6RHlq9Xu5MXIUo7DUQPELT
         BnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680108726;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJcSi47EhXNIDZ28a5A+wUVsGYy6JkYPL7x7pr4x14E=;
        b=xGas+U4pNsOQ+Hvpi2LMP7MgnRgL//m5uh1GAY5y4SYVW+Ci9UsXt0WdtIGPJNgdUb
         CVuAhAIHL7ig67naPcOqHgg5qR+oB92LylAj8qrPkTcpFPtDros79pX2iPloTk9Ifa+e
         K5wk96DWSsQBArgJwY5ZsqOG1Mma4fYOj+Dhn0G7hdsOF0mTHrS9fhkzsb1+E0I2+YQA
         PQBpsEJ6zikOFiT3s/aqRexo1IXA5ZjMMpnJ6kzeoH5rVWVy1iuXX6JbKxhkZ1wZVtAt
         4gTgkMY+pAoyDMFBIyD4GKDRuzzBSkbJFFskEsWXsn3LfEdRqueMRdRVeAeQRRRo0Fth
         cFnQ==
X-Gm-Message-State: AAQBX9fYl/dha/u9Sv6nUAl0M5SGzjpn9n/j+GxmJ+4W3iH2j06E+neD
        8OsrtX1QnZl+LLRqQI8tn1Zd+NyMEfH4xrMr3kg=
X-Google-Smtp-Source: AKy350bK7zGq4k69rZlQkPib1d9x8G+KiYL3mTAPdFc8sKo0rQ6LMTYNTi6e9fe7gDD2dheQbUJTQQ==
X-Received: by 2002:ad4:5949:0:b0:5d5:11b4:ad0 with SMTP id eo9-20020ad45949000000b005d511b40ad0mr31106166qvb.11.1680108726011;
        Wed, 29 Mar 2023 09:52:06 -0700 (PDT)
Received: from [172.17.0.3] ([147.160.184.95])
        by smtp.gmail.com with ESMTPSA id mh2-20020a056214564200b005dd8b934582sm4686029qvb.26.2023.03.29.09.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 09:52:05 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 29 Mar 2023 16:51:58 +0000
Subject: [PATCH net v3] virtio/vsock: fix leaks due to missing skb owner
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-vsock-fix-leak-v3-1-292cfc257531@bytedance.com>
X-B4-Tracking: v=1; b=H4sIAK5sJGQC/32OzQ7CIBCEX8Vwdk2B9M+T72E88LNYUgUDDdo0f
 XcpFxMTPc7szDe7kIjBYiTH3UICJhutd1nw/Y6oQbgrgtVZE1YxXnHWQopejWDsC24oRpBUoaF
 1x4ToSC5JERFkEE4NW+2TjqME/3QYttQjYPbK7Jk4nMglm4ONkw9zeSXRcvq1mihQ4AY18qalV
 W1Ocp5Q51U8KH8vuMT+I1hGmKahfd8yjVh9I9Z1fQMY3VJGHgEAAA==
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets the skb owner in the recv and send path for virtio.

For the send path, this solves the leak caused when
virtio_transport_purge_skbs() finds skb->sk is always NULL and therefore
never matches it with the current socket. Setting the owner upon
allocation fixes this.

For the recv path, this ensures correctness of accounting and also
correct transfer of ownership in vsock_loopback (when skbs are sent from
one socket and received by another).

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
---
Changes in v3:
- virtio/vsock: use skb_set_owner_sk_safe() instead of
  skb_set_owner_{r,w}
- virtio/vsock: reject allocating/receiving skb if sk_refcnt==0 and WARN_ONCE
- Link to v2: https://lore.kernel.org/r/20230327-vsock-fix-leak-v2-1-f6619972dee0@bytedance.com

Changes in v2:
- virtio/vsock: add skb_set_owner_r to recv_pkt()
- Link to v1: https://lore.kernel.org/r/20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com
---
 net/vmw_vsock/virtio_transport_common.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 957cdc01c8e8..c927dc302faa 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -94,6 +94,11 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 					 info->op,
 					 info->flags);
 
+	if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
+		WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
+		goto out;
+	}
+
 	return skb;
 
 out:
@@ -1294,6 +1299,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		goto free_pkt;
 	}
 
+	if (!skb_set_owner_sk_safe(skb, sk)) {
+		WARN_ONCE(1, "receiving vsock socket has sk_refcnt == 0\n");
+		goto free_pkt;
+	}
+
 	vsk = vsock_sk(sk);
 
 	lock_sock(sk);

---
base-commit: e5b42483ccce50d5b957f474fd332afd4ef0c27b
change-id: 20230327-vsock-fix-leak-b1cef1582aa8

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

