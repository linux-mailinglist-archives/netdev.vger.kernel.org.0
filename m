Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C846342A8F9
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237552AbhJLQAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237477AbhJLQAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D240610E8;
        Tue, 12 Oct 2021 15:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054329;
        bh=wfbt6ImL0n5GbHzvl0f7V3CT5bJgwTRiRpj5/Z31AW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eof9QeepucP39hDQnknvLJGBeoGGBhaz2sL7VQ7u+AM7yTUzDyJkzDs0EwAHIbq1U
         0KRd28vR6U27oWPndAPqZGYgk0CM5VLROrp4fOhT4hMDk8sENAi3bwoStqYRVv+jAt
         pJz+/sSuJxm6egF0wfCu6ciLnKaEQhjUAKhhVlbKtRN+C1Ynu2bdBC05A3IU2mZ9bA
         Jh3+dXhJD/JKBIzJhIcJG2IgkyPrfvPyx5e6h24gxx7+eTQjV5jEh93wogRh47/rsA
         eHQMSiultK7osDqAIe/FgcUjY5qip2yz5G5PvIEUZsW9wHGf0oOL1wldg95zXB/vcm
         9LCTyvfQeFxIQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] llc/snap: constify dev_addr passing
Date:   Tue, 12 Oct 2021 08:58:37 -0700
Message-Id: <20211012155840.4151590-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
References: <20211012155840.4151590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for netdev->dev_addr being constant
make all relevant arguments in LLC and SNAP constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/datalink.h | 2 +-
 include/net/llc.h      | 2 +-
 include/net/llc_if.h   | 3 ++-
 net/802/p8022.c        | 2 +-
 net/802/psnap.c        | 2 +-
 net/llc/llc_c_ac.c     | 2 +-
 net/llc/llc_if.c       | 2 +-
 net/llc/llc_output.c   | 2 +-
 net/llc/llc_proc.c     | 2 +-
 9 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/net/datalink.h b/include/net/datalink.h
index a9663229b913..d9b7faaa539f 100644
--- a/include/net/datalink.h
+++ b/include/net/datalink.h
@@ -12,7 +12,7 @@ struct datalink_proto {
         int     (*rcvfunc)(struct sk_buff *, struct net_device *,
                                 struct packet_type *, struct net_device *);
 	int     (*request)(struct datalink_proto *, struct sk_buff *,
-                                        unsigned char *);
+			   const unsigned char *);
 	struct list_head node;
 };
 
diff --git a/include/net/llc.h b/include/net/llc.h
index df282d9b4017..fd1f9a3fd8dd 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -133,7 +133,7 @@ static inline void llc_sap_put(struct llc_sap *sap)
 struct llc_sap *llc_sap_find(unsigned char sap_value);
 
 int llc_build_and_send_ui_pkt(struct llc_sap *sap, struct sk_buff *skb,
-			      unsigned char *dmac, unsigned char dsap);
+			      const unsigned char *dmac, unsigned char dsap);
 
 void llc_sap_handler(struct llc_sap *sap, struct sk_buff *skb);
 void llc_conn_handler(struct llc_sap *sap, struct sk_buff *skb);
diff --git a/include/net/llc_if.h b/include/net/llc_if.h
index 8d5c543cd620..c72570a21a4f 100644
--- a/include/net/llc_if.h
+++ b/include/net/llc_if.h
@@ -62,7 +62,8 @@
 #define LLC_STATUS_CONFLICT	7 /* disconnect conn */
 #define LLC_STATUS_RESET_DONE	8 /*  */
 
-int llc_establish_connection(struct sock *sk, u8 *lmac, u8 *dmac, u8 dsap);
+int llc_establish_connection(struct sock *sk, const u8 *lmac, u8 *dmac,
+			     u8 dsap);
 int llc_build_and_send_pkt(struct sock *sk, struct sk_buff *skb);
 int llc_send_disc(struct sock *sk);
 #endif /* LLC_IF_H */
diff --git a/net/802/p8022.c b/net/802/p8022.c
index a6585627051d..79c23173116c 100644
--- a/net/802/p8022.c
+++ b/net/802/p8022.c
@@ -23,7 +23,7 @@
 #include <net/p8022.h>
 
 static int p8022_request(struct datalink_proto *dl, struct sk_buff *skb,
-			 unsigned char *dest)
+			 const unsigned char *dest)
 {
 	llc_build_and_send_ui_pkt(dl->sap, skb, dest, dl->sap->laddr.lsap);
 	return 0;
diff --git a/net/802/psnap.c b/net/802/psnap.c
index 4492e8d7ad20..1406bfdbda13 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -79,7 +79,7 @@ static int snap_rcv(struct sk_buff *skb, struct net_device *dev,
  *	Put a SNAP header on a frame and pass to 802.2
  */
 static int snap_request(struct datalink_proto *dl,
-			struct sk_buff *skb, u8 *dest)
+			struct sk_buff *skb, const u8 *dest)
 {
 	memcpy(skb_push(skb, 5), dl->type, 5);
 	llc_build_and_send_ui_pkt(snap_sap, skb, dest, snap_sap->laddr.lsap);
diff --git a/net/llc/llc_c_ac.c b/net/llc/llc_c_ac.c
index 647c0554d04c..40ca3c1e42a2 100644
--- a/net/llc/llc_c_ac.c
+++ b/net/llc/llc_c_ac.c
@@ -781,7 +781,7 @@ int llc_conn_ac_send_sabme_cmd_p_set_x(struct sock *sk, struct sk_buff *skb)
 
 	if (nskb) {
 		struct llc_sap *sap = llc->sap;
-		u8 *dmac = llc->daddr.mac;
+		const u8 *dmac = llc->daddr.mac;
 
 		if (llc->dev->flags & IFF_LOOPBACK)
 			dmac = llc->dev->dev_addr;
diff --git a/net/llc/llc_if.c b/net/llc/llc_if.c
index ad6547736c21..dde9bf08a593 100644
--- a/net/llc/llc_if.c
+++ b/net/llc/llc_if.c
@@ -80,7 +80,7 @@ int llc_build_and_send_pkt(struct sock *sk, struct sk_buff *skb)
  *	establishment will inform to upper layer via calling it's confirm
  *	function and passing proper information.
  */
-int llc_establish_connection(struct sock *sk, u8 *lmac, u8 *dmac, u8 dsap)
+int llc_establish_connection(struct sock *sk, const u8 *lmac, u8 *dmac, u8 dsap)
 {
 	int rc = -EISCONN;
 	struct llc_addr laddr, daddr;
diff --git a/net/llc/llc_output.c b/net/llc/llc_output.c
index b9ad087bcbd7..5a6466fc626a 100644
--- a/net/llc/llc_output.c
+++ b/net/llc/llc_output.c
@@ -56,7 +56,7 @@ int llc_mac_hdr_init(struct sk_buff *skb,
  *	package primitive as an event and send to SAP event handler
  */
 int llc_build_and_send_ui_pkt(struct llc_sap *sap, struct sk_buff *skb,
-			      unsigned char *dmac, unsigned char dsap)
+			      const unsigned char *dmac, unsigned char dsap)
 {
 	int rc;
 	llc_pdu_header_init(skb, LLC_PDU_TYPE_U, sap->laddr.lsap,
diff --git a/net/llc/llc_proc.c b/net/llc/llc_proc.c
index a4eccb98220a..0ff490a73fae 100644
--- a/net/llc/llc_proc.c
+++ b/net/llc/llc_proc.c
@@ -26,7 +26,7 @@
 #include <net/llc_c_st.h>
 #include <net/llc_conn.h>
 
-static void llc_ui_format_mac(struct seq_file *seq, u8 *addr)
+static void llc_ui_format_mac(struct seq_file *seq, const u8 *addr)
 {
 	seq_printf(seq, "%pM", addr);
 }
-- 
2.31.1

