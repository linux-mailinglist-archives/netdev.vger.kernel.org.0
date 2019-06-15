Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD09146E9C
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 08:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbfFOGml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 02:42:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40487 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfFOGml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 02:42:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id d30so2774635pgm.7
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 23:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hNHWrhfyzsV2n/wRn65uyM6GtYs6ZW3csZvNGHrW1M=;
        b=SmfdGKEs9uPX16YgUrEx8uxW6d74F8JSAWtvzcoD+gYAubt5m7kLbAo3yn13CuIbXC
         LcmpVrD/YFGRQ2uPnZ8E7HdD1vyh7X+TsUnB8/8s0kEQvA+Uy6XhVghwux+/uDWQMx6t
         CA0eE1B4NKJOQWPT4O7Z+fdXwYC/6Ykz2Z89A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hNHWrhfyzsV2n/wRn65uyM6GtYs6ZW3csZvNGHrW1M=;
        b=Un0NEFkbWbpBNycjhHX8X1perzzvmNGa2Sh6nfjo1M1KHzmHfiNqW08YRWAZ0/VDSM
         e4zrw/SESy1+xmKfHyxlQmpsspdeRfPRUZ1ctRraqdFETPe45tnzXc73I/f2Q5DqbPqY
         UWW8HAX0PyVbaGkpA+iKyuRLSbphuT8FGKE4ly2C0fjTKz6VRF48wqTHHPaSbI/+TqZw
         1haOEVkPRayhGOhiRW5Og6V1p3HmW6efiPRFyWo4M7ZPQNXvuZVTbaGEs7WPiFIAO3cg
         Yo5sV3usLohbKV5YS417RXM7FuBHRYMp4PnTw9iaCY45xiKcHMv4YXZiZO7e8dQBtfbq
         vSMg==
X-Gm-Message-State: APjAAAWlt1Yi+UkTPMtItmNIQtJAuKnMsbIkZfokkkJ29l2pWaNr97R5
        vK5YnfiYQhXVBfe7BBFJYrkfig==
X-Google-Smtp-Source: APXvYqztVvlek2ciZ+0if+6HLcVw/2Jr58oCThu5McVtMseOVbl4zFUyuLV/sAQA79bZsV+yqr0xQg==
X-Received: by 2002:a63:eb55:: with SMTP id b21mr38365372pgk.67.1560580960622;
        Fri, 14 Jun 2019 23:42:40 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:942a:df4a:2beb:7e97])
        by smtp.gmail.com with ESMTPSA id z126sm7025201pfb.100.2019.06.14.23.42.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 23:42:40 -0700 (PDT)
From:   Stephen Barber <smbarber@chromium.org>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Barber <smbarber@chromium.org>
Subject: [PATCH] vsock/virtio: set SOCK_DONE on peer shutdown
Date:   Fri, 14 Jun 2019 23:42:37 -0700
Message-Id: <20190615064237.73586-1-smbarber@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the SOCK_DONE flag to match the TCP_CLOSING state when a peer has
shut down and there is nothing left to read.

This fixes the following bug:
1) Peer sends SHUTDOWN(RDWR).
2) Socket enters TCP_CLOSING but SOCK_DONE is not set.
3) read() returns -ENOTCONN until close() is called, then returns 0.

Signed-off-by: Stephen Barber <smbarber@chromium.org>
---
 net/vmw_vsock/virtio_transport_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f3f3d06cb6d8..e30f53728725 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -871,8 +871,10 @@ virtio_transport_recv_connected(struct sock *sk,
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SHUTDOWN_SEND)
 			vsk->peer_shutdown |= SEND_SHUTDOWN;
 		if (vsk->peer_shutdown == SHUTDOWN_MASK &&
-		    vsock_stream_has_data(vsk) <= 0)
+		    vsock_stream_has_data(vsk) <= 0) {
+			sock_set_flag(sk, SOCK_DONE);
 			sk->sk_state = TCP_CLOSING;
+		}
 		if (le32_to_cpu(pkt->hdr.flags))
 			sk->sk_state_change(sk);
 		break;
-- 
2.22.0.410.gd8fdbe21b5-goog

