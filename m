Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFB0BB020
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 11:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfIWJC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 05:02:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35103 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfIWJC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 05:02:56 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so8760905pfw.2
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 02:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bhpZ0GaI/1mrh2C28BMexx1rsd2NBsHdc4MUjDcUbIY=;
        b=dXhZVEkqNLd9+bZxGcCW3fHgQS0lFlMz2zBVGTWcqZllsmf+U8yRlHdifoCuIg7S/0
         H78kepks/WQDr/cCXK1uwO0qB6GXXdUmC0KjNqXs6MevfFFKRv1oQCk91jFIqKiuoOwL
         Dn1zhidUxj9UUHf38Qe+6K6+K4kQuSj7Uvyp1mjTXFbG7gD/ZZBq5OC0GFq2Y295n1Q9
         yxWFEFSOjdo3LNOkxZ6thkM059EHjASAFnXKeT1hHiq0bZsCM/3YLtybQ2j+kETHRfjL
         VRJiUNMZgIHfTCiHgd08trZ5wPBUP0pJdu5lxPpptq1lgWIkQoshIMPIB0S7eK8787nT
         0vnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bhpZ0GaI/1mrh2C28BMexx1rsd2NBsHdc4MUjDcUbIY=;
        b=Q60DkO5VaYKYrbxeA3M0htJPoq83gdf7jXZcwqD82QprtV4peRDtbYy9C6d0lwdxA2
         pJ/HHewTyQjFuBxcpCnbBqZEyk7lidASqvxedBwQqyYe73Oi1YQpK950L+GC/qNw6qxS
         lzUzNcx9xL8j50LsE0W08aNA8os2yvfI7cfT7E0fD7qehGQnprupkoxNHh4C0q5VpTR+
         uNwBPV+OOTpZJhDH1+hqQukp3kexd2RTWwFO+PhBgXTgCGbkzisCriI0QS1tDndq5s4i
         YqtflAasUKFDfs2ug7WhpR9rs/qkhh5NWHQlNNrZfHxto/juJg2LY+dUN49GSd/PbV4G
         mzWA==
X-Gm-Message-State: APjAAAXIFuyH/Oe8hKzMruTDaxCQEK+XeZvvE//YehiX11UJOlws7UIz
        LkhzbreHMl+60PjK854QbubFbQqF
X-Google-Smtp-Source: APXvYqyKGxcyOEXwa0oRBxz4CkXBjcHObs56pTyvrbtsWJ9eac7aD6d9t1CPE+CGKrmmbeEFPEfYmQ==
X-Received: by 2002:a17:90a:6547:: with SMTP id f7mr10083781pjs.13.1569229374607;
        Mon, 23 Sep 2019 02:02:54 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w134sm17034603pfd.4.2019.09.23.02.02.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 02:02:53 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Sabrina Dubroca <sd@queasysnail.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] macsec: drop skb sk before calling gro_cells_receive
Date:   Mon, 23 Sep 2019 17:02:46 +0800
Message-Id: <36f492a4977192dc4bc22a8c3bbfaf496ed89328.1569229366.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fei Liu reported a crash when doing netperf on a topo of macsec
dev over veth:

  [  448.919128] refcount_t: underflow; use-after-free.
  [  449.090460] Call trace:
  [  449.092895]  refcount_sub_and_test+0xb4/0xc0
  [  449.097155]  tcp_wfree+0x2c/0x150
  [  449.100460]  ip_rcv+0x1d4/0x3a8
  [  449.103591]  __netif_receive_skb_core+0x554/0xae0
  [  449.108282]  __netif_receive_skb+0x28/0x78
  [  449.112366]  netif_receive_skb_internal+0x54/0x100
  [  449.117144]  napi_gro_complete+0x70/0xc0
  [  449.121054]  napi_gro_flush+0x6c/0x90
  [  449.124703]  napi_complete_done+0x50/0x130
  [  449.128788]  gro_cell_poll+0x8c/0xa8
  [  449.132351]  net_rx_action+0x16c/0x3f8
  [  449.136088]  __do_softirq+0x128/0x320

The issue was caused by skb's true_size changed without its sk's
sk_wmem_alloc increased in tcp/skb_gro_receive(). Later when the
skb is being freed and the skb's truesize is subtracted from its
sk's sk_wmem_alloc in tcp_wfree(), underflow occurs.

macsec is calling gro_cells_receive() to receive a packet, which
actually requires skb->sk to be NULL. However when macsec dev is
over veth, it's possible the skb->sk is still set if the skb was
not unshared or expanded from the peer veth.

ip_rcv() is calling skb_orphan() to drop the skb's sk for tproxy,
but it is too late for macsec's calling gro_cells_receive(). So
fix it by dropping the skb's sk earlier on rx path of macsec.

Fixes: 5491e7c6b1a9 ("macsec: enable GRO and RPS on macsec devices")
Reported-by: Xiumei Mu <xmu@redhat.com>
Reported-by: Fei Liu <feliu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 8f46aa1..cb76373 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1235,6 +1235,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 		macsec_rxsa_put(rx_sa);
 	macsec_rxsc_put(rx_sc);
 
+	skb_orphan(skb);
 	ret = gro_cells_receive(&macsec->gro_cells, skb);
 	if (ret == NET_RX_SUCCESS)
 		count_rx(dev, skb->len);
-- 
2.1.0

