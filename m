Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 478E917E3AE
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCIPek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:34:40 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40289 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbgCIPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:34:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id m2so9601511qka.7
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3gsOuEGy6HexjrDI4Wv3W2durKZ3o60xuRureQ8zA8=;
        b=VZwjR+OrizYK25o7dMtIefN268sK5eacRFI18MXCcO6Hsz1xzp0SaLrDLli+4LkKqF
         ZbRG8/88J5TLkRKfLTcJ5v4wUXFvZLlrXcijEsNS+Pda1TI73KRli0IkKx0sxVHGmFwm
         znawoY6HCrjFVn0u2GdPMWRuOOstDYq/zQqhwvpVWDSeUc29Inv/1oK/QJxB82P3V1Kq
         P9jMmpuNliFV5DJ0IzoLD3fSJ8mEpR0qm8nNI4tRAoszkzUhfvNJT6S8ceMZwk6zvfBK
         UeZjn0bwRYvyKM2J2MzmfmLUmSjTMMpwMkcyOWtgsxmKblx5M3oKO3dLtWzxakPR8TMe
         yMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C3gsOuEGy6HexjrDI4Wv3W2durKZ3o60xuRureQ8zA8=;
        b=kBiNkVAmnt2NG8uVeVPKkfq+ApVx74ua3cq6NvtOtuPhZpViN13H12oF+jmwJZMiAs
         uQF9wJ2d5j3Wql1arr5tGHqqqNG3fNtfLKzu3f88cL+7LZQDd9h2sytIC+StIFx5zTPM
         MNU65VnYkaVQWIsH+oj4V7JKuZqflvA8TcBvb07rBgXGG5AWXjb3kExEDmVc18+qJF/G
         P3XS7GGJPaNLxpGgvOBaSiFqk9HSklKphELWC5G14bMynavAwwC7xlvVzVmC+BMw3obi
         DoCwask7BCS1gG3oGdki58rabdQZJAs8EOLN2Gx6xcgKYMIeh0WSUsTsFdGuPFiQKI5A
         hsZw==
X-Gm-Message-State: ANhLgQ3eSNSLxHGm6iJYFVk5XCHd9vLqKAt4wPASdzB4OHWYF/e63tRN
        aQTJFhdZvwJ8ktLQ9OQ+reQ9kt9t
X-Google-Smtp-Source: ADFU+vtsdeLk2hordJfuVKN0UWSpwESBKmnV/+cu9MQYSvu/wewWVQi6wj3kVKUxgr5b9Y6yVf4G+Q==
X-Received: by 2002:a37:7cc5:: with SMTP id x188mr16206075qkc.390.1583768078601;
        Mon, 09 Mar 2020 08:34:38 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:37b5:dd03:b905:30ea])
        by smtp.gmail.com with ESMTPSA id a1sm22170198qkd.126.2020.03.09.08.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:34:37 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mst@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] net/packet: tpacket_rcv: do not increment ring index on drop
Date:   Mon,  9 Mar 2020 11:34:35 -0400
Message-Id: <20200309153435.32109-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

In one error case, tpacket_rcv drops packets after incrementing the
ring producer index.

If this happens, it does not update tp_status to TP_STATUS_USER and
thus the reader is stalled for an iteration of the ring, causing out
of order arrival.

The only such error path is when virtio_net_hdr_from_skb fails due
to encountering an unknown GSO type.

Signed-off-by: Willem de Bruijn <willemb@google.com>

---

I wonder whether it should drop packets with unknown GSO types at all.
This consistently blinds the reader to certain packets, including
recent UDP and SCTP GSO types.

The peer function virtio_net_hdr_to_skb already drops any packets with
unknown types, so it should be fine to add an SKB_GSO_UNKNOWN type and
let the peer at least be aware of failure.

And possibly add SKB_GSO_UDP_L4 and SKB_GSO_SCTP types to virtio too.
---
 net/packet/af_packet.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 30c6879d6774..e5b0986215d2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2274,6 +2274,13 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 					TP_STATUS_KERNEL, (macoff+snaplen));
 	if (!h.raw)
 		goto drop_n_account;
+
+	if (do_vnet &&
+	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
+				    sizeof(struct virtio_net_hdr),
+				    vio_le(), true, 0))
+		goto drop_n_account;
+
 	if (po->tp_version <= TPACKET_V2) {
 		packet_increment_rx_head(po, &po->rx_ring);
 	/*
@@ -2286,12 +2293,6 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 			status |= TP_STATUS_LOSING;
 	}
 
-	if (do_vnet &&
-	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
-				    sizeof(struct virtio_net_hdr),
-				    vio_le(), true, 0))
-		goto drop_n_account;
-
 	po->stats.stats1.tp_packets++;
 	if (copy_skb) {
 		status |= TP_STATUS_COPY;
-- 
2.25.1.481.gfbce0eb801-goog

