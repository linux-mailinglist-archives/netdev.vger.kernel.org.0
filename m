Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86BF3DDE98
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhHBRf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHBRf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:35:28 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE60C06175F;
        Mon,  2 Aug 2021 10:35:18 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id h13so8897902wrp.1;
        Mon, 02 Aug 2021 10:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=r6bg/D0h+hHSSt2k/0GZqDs26DAnYPWQv+c56O1rXQU=;
        b=ZoxugyjH6qgO8Kba98UUpQzsZ9N43kL4yEKf1+fQud+NY6AFPeIxgDgbyN7fcAmDMS
         SA9va3fbiBXU9YuqD/+A32zwTr7+RHXhaK5dOpe6UxixF/w6iwC0VljThqc0IrMp+PWz
         iOZPr6XLe4drRxPLsWL7NR60sL+y9qNNQhS3dn5IBeH3BS3dgrap+CD/qt3GDipDTRYR
         xDyQjk6hrlTIaalzUoeRHYdvB0LPWUmLQMAlfVi22n4+FwujniF0mTgs63/AqJT8mljP
         XgS1cBakqXYZJNgXWgNgcn2ZDS2qvkzqv8MhrXXWaX+cuNmohDCWkPX6Wm86g8gaQzpa
         ZT7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r6bg/D0h+hHSSt2k/0GZqDs26DAnYPWQv+c56O1rXQU=;
        b=ZxtE1Ylzsd5E5e9WpILIjBbH/k9dja9jXcaovMDf2GKJM82K/U614PCxb20lNDpXbv
         Vt3qfSqPowxIo9Aeg/krX7PdgPH2XqrsE54O6Qb8G+IiggiDq7BNQGdYqYhniuscjjX7
         uHzOmh5dFcRteOwbhvOYf88SRdHAxH0AZK+Vwml36IKJv+YkKZ0RkL66bB4tMkNM2yYn
         8IU11Ayk0he9A0viqzF4vhl8deUAlFRU7ERSeIwCkqHmofgYKtc0Qrj8svVJeHbqr5sm
         MUvdpr0eGlRvJTLbwoYVfP7tl9JuTZ1sRmn92rCRhHWk7lxdAkqAxHBaAI7xKVSZWiCN
         D1xw==
X-Gm-Message-State: AOAM533n7f5nkp+oR0yv+rKU/cOLfCt/pPWoXtbNy90h7CVwFe1p3cyO
        ITf0y8WCZ8rwEV4Ua8/qIyw=
X-Google-Smtp-Source: ABdhPJzC+4l7ytCLAIQxQkriQ1JBuZu+PO3Qay8vSNbgdj3ZUV7INvXpfVRnKdQweqiqMlP9y7cpiw==
X-Received: by 2002:a5d:4386:: with SMTP id i6mr18852593wrq.249.1627925717477;
        Mon, 02 Aug 2021 10:35:17 -0700 (PDT)
Received: from hack-haven.speedport.ip (p200300ca17195e20d9703d2c4e611570.dip0.t-ipconnect.de. [2003:ca:1719:5e20:d970:3d2c:4e61:1570])
        by smtp.googlemail.com with ESMTPSA id g5sm22101wmh.31.2021.08.02.10.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 10:35:17 -0700 (PDT)
From:   Harshavardhan Unnibhavi <harshanavkis@gmail.com>
To:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, asias@redhat.com, mst@redhat.com,
        imbrenda@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Harshavardhan Unnibhavi <harshanavkis@gmail.com>
Subject: [PATCH net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
Date:   Mon,  2 Aug 2021 19:35:06 +0200
Message-Id: <20210802173506.2383-1-harshanavkis@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original implementation of the virtio-vsock driver does not
handle a VIRTIO_VSOCK_OP_CREDIT_REQUEST as required by the
virtio-vsock specification. The vsock device emulated by
vhost-vsock and the virtio-vsock driver never uses this request,
which was probably why nobody noticed it. However, another
implementation of the device may use this request type.

Hence, this commit introduces a way to handle an explicit credit
request by responding with a corresponding credit update as
required by the virtio-vsock specification.

Fixes: 06a8fc78367d ("VSOCK: Introduce virtio_vsock_common.ko")

Signed-off-by: Harshavardhan Unnibhavi <harshanavkis@gmail.com>
---
 net/vmw_vsock/virtio_transport_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 169ba8b72a63..081e7ae93cb1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1079,6 +1079,9 @@ virtio_transport_recv_connected(struct sock *sk,
 		virtio_transport_recv_enqueue(vsk, pkt);
 		sk->sk_data_ready(sk);
 		return err;
+	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
+		virtio_transport_send_credit_update(vsk);
+		break;
 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
 		sk->sk_write_space(sk);
 		break;
-- 
2.17.1

