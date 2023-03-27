Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D741E6CB168
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 00:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjC0WBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 18:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC0WBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 18:01:48 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECBD1FC4
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 15:01:46 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id t13so7911551qvn.2
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 15:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1679954506;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VX1NBj5by138i4YAyUE/B8GjUplIoeAkADXmwDxGNDM=;
        b=SebD/g43tpygUyk6ZM3YDldFlmJidPf7k3TynS59PcvmDEByGoo2yt47ql83Z4NzDC
         lUASYGyyVh3QBEjcuQyduecz78g3JHHtpu8C9yVZTBXXLC2szTnZAu6RvGIr3NZvWFBI
         6NsCyP5hcUvA7jjQtcKcd2LvodESeyCsPhnz50ZzdkLkUOmwW6B1zkKgb9KIpA6jLPxw
         1TxuqldbXf9IBCSY2kgmmqFSjNyOMA8oz/qT2kw8ohirTCarfnFQ3Un6fIHgk76U3rX3
         FjJ7ZLd2pMPaSYOHCA/95YLjw1XtOnykY4Ap0CIs20ORMNFdbHvg5Ad9+uNWjCslgOox
         ICnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679954506;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VX1NBj5by138i4YAyUE/B8GjUplIoeAkADXmwDxGNDM=;
        b=Y+/8+4BiUHo1Aa81BmigwmdJRVeXXoP+nnI9WKlhrJEaVS2vZm2OgL1wdvJmBJHOvn
         Xt0fo+avQhRZl7SE+ReV/2bG9udSe6ZV9CZ81xTEhvgZuY1xeryDdFc2g4vBacS+Vliq
         Uyg3CsiK5ZFTiVBHH79BntPnNSwDoMRDwEAuXykK52EiAdHqNHw5A7AawcpQS88afZF3
         DoOuYm486ecj3IlEkzfNl77acRMMUKy6Ng0wrVAHnzWpGK1xiB/XeFevC/QfDV5tvX22
         57SGF+sAEZ/8RzugiZlyoAoH1vQSpOJy95X6tq48QQj7AnKfWttAkVIbVUfL0lpORWBB
         PTGw==
X-Gm-Message-State: AAQBX9d8tTf/AE/U5rwvM/NDRV6oMadh/4+5FzBH7dlfMLSgGQ2JTqIb
        tmLzUxESCOuOC8EzX48gK86oww==
X-Google-Smtp-Source: AKy350bpNLMZp4nU+AcWQ1pDqSqUI6blgXq7NZf41dmUi/9aSPTJ/0lx85kRQSFA/GEy2F859PeTWQ==
X-Received: by 2002:a05:6214:2604:b0:5ab:e259:b2a9 with SMTP id gu4-20020a056214260400b005abe259b2a9mr25452716qvb.14.1679954505774;
        Mon, 27 Mar 2023 15:01:45 -0700 (PDT)
Received: from [172.17.0.3] ([130.44.212.120])
        by smtp.gmail.com with ESMTPSA id t10-20020a37aa0a000000b0074683c45f6csm12299847qke.1.2023.03.27.15.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 15:01:45 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Mon, 27 Mar 2023 22:01:05 +0000
Subject: [PATCH net] virtio/vsock: fix leak due to missing skb owner
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com>
X-B4-Tracking: v=1; b=H4sIACASImQC/0WNQQrCQAxFr1KyNtCZIhavIi4yY2rDSEYSqULp3
 Z26cfk+7/FXcDZhh3O3gvEiLlUbhEMHeSa9M8qtMcQ+Dv0QT7h4zQUn+eCDqWAKmadwHCPRCC1
 K5IzJSPO8Z3/bS8L6Vrbdehq37Xd7AeUXXLftC+VLmi+LAAAA
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

This patch sets the owner for the skb when being sent from a socket and
so solves the leak caused when virtio_transport_purge_skbs() finds
skb->sk is always NULL and therefore never matches it with the current
socket. Setting the owner upon allocation fixes this.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
---
 net/vmw_vsock/virtio_transport_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 957cdc01c8e8..2a2f0c1a9fbd 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -94,6 +94,9 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 					 info->op,
 					 info->flags);
 
+	if (info->vsk)
+		skb_set_owner_w(skb, sk_vsock(info->vsk));
+
 	return skb;
 
 out:

---
base-commit: e5b42483ccce50d5b957f474fd332afd4ef0c27b
change-id: 20230327-vsock-fix-leak-b1cef1582aa8

Best regards,
-- 
Bobby Eshleman <bobby.eshleman@bytedance.com>

