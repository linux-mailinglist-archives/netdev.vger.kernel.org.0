Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8772D3EBECD
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 01:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbhHMXhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 19:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235359AbhHMXhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 19:37:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4973060F39;
        Fri, 13 Aug 2021 23:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628897846;
        bh=oqn4XgW0ydGuOA6HGy4ScnTPPXFQGKlvilZrBfNxg8o=;
        h=From:To:Cc:Subject:Date:From;
        b=Ma9GAQfWJmGNqel5WK/ScBiOnuo7XeOGTsHZJT9vdJxyKZlB7vY97Ks2IaVX8wh9Z
         dnYPv8hYfKkjEj41WsuTOAOY/hsIy4C3oBfxZicbx+rF1XWjGj0xUY3MuraaPCwo7p
         FTaGacrF1t80MAVeTRnR6vv44iaK5WXysOZPOAnSjYeBOcRR3x2eoB5fEPv8XO8VyW
         VCww46IGkDxlMsFTVzxBaCYjJD/9JzlfLzHXvSQ8ymp9l2TLsy6ej7UVlDOMl0RNpA
         29br5yuy0UdNrsX+sDAERmRrezxeI8KZbNePrHshKyBa9oPaNQTu/zaMsUcAwVclb3
         aAAXel8Lnhi/A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] ipx: remove leftover header
Date:   Fri, 13 Aug 2021 16:37:22 -0700
Message-Id: <20210813233722.1573898-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7a2e838d28cf ("staging: ipx: delete it from the tree")
removed the last user of this header.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/ipx.h | 171 ----------------------------------------------
 1 file changed, 171 deletions(-)
 delete mode 100644 include/net/ipx.h

diff --git a/include/net/ipx.h b/include/net/ipx.h
deleted file mode 100644
index 9d1342807b59..000000000000
--- a/include/net/ipx.h
+++ /dev/null
@@ -1,171 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _NET_INET_IPX_H_
-#define _NET_INET_IPX_H_
-/*
- *	The following information is in its entirety obtained from:
- *
- *	Novell 'IPX Router Specification' Version 1.10 
- *		Part No. 107-000029-001
- *
- *	Which is available from ftp.novell.com
- */
-
-#include <linux/netdevice.h>
-#include <net/datalink.h>
-#include <linux/ipx.h>
-#include <linux/list.h>
-#include <linux/slab.h>
-#include <linux/refcount.h>
-
-struct ipx_address {
-	__be32  net;
-	__u8    node[IPX_NODE_LEN]; 
-	__be16  sock;
-};
-
-#define ipx_broadcast_node	"\377\377\377\377\377\377"
-#define ipx_this_node           "\0\0\0\0\0\0"
-
-#define IPX_MAX_PPROP_HOPS 8
-
-struct ipxhdr {
-	__be16			ipx_checksum __packed;
-#define IPX_NO_CHECKSUM	cpu_to_be16(0xFFFF)
-	__be16			ipx_pktsize __packed;
-	__u8			ipx_tctrl;
-	__u8			ipx_type;
-#define IPX_TYPE_UNKNOWN	0x00
-#define IPX_TYPE_RIP		0x01	/* may also be 0 */
-#define IPX_TYPE_SAP		0x04	/* may also be 0 */
-#define IPX_TYPE_SPX		0x05	/* SPX protocol */
-#define IPX_TYPE_NCP		0x11	/* $lots for docs on this (SPIT) */
-#define IPX_TYPE_PPROP		0x14	/* complicated flood fill brdcast */
-	struct ipx_address	ipx_dest __packed;
-	struct ipx_address	ipx_source __packed;
-};
-
-/* From af_ipx.c */
-extern int sysctl_ipx_pprop_broadcasting;
-
-struct ipx_interface {
-	/* IPX address */
-	__be32			if_netnum;
-	unsigned char		if_node[IPX_NODE_LEN];
-	refcount_t		refcnt;
-
-	/* physical device info */
-	struct net_device	*if_dev;
-	struct datalink_proto	*if_dlink;
-	__be16			if_dlink_type;
-
-	/* socket support */
-	unsigned short		if_sknum;
-	struct hlist_head	if_sklist;
-	spinlock_t		if_sklist_lock;
-
-	/* administrative overhead */
-	int			if_ipx_offset;
-	unsigned char		if_internal;
-	unsigned char		if_primary;
-	
-	struct list_head	node; /* node in ipx_interfaces list */
-};
-
-struct ipx_route {
-	__be32			ir_net;
-	struct ipx_interface	*ir_intrfc;
-	unsigned char		ir_routed;
-	unsigned char		ir_router_node[IPX_NODE_LEN];
-	struct list_head	node; /* node in ipx_routes list */
-	refcount_t		refcnt;
-};
-
-struct ipx_cb {
-	u8	ipx_tctrl;
-	__be32	ipx_dest_net;
-	__be32	ipx_source_net;
-	struct {
-		__be32 netnum;
-		int index;
-	} last_hop;
-};
-
-#include <net/sock.h>
-
-struct ipx_sock {
-	/* struct sock has to be the first member of ipx_sock */
-	struct sock		sk;
-	struct ipx_address	dest_addr;
-	struct ipx_interface	*intrfc;
-	__be16			port;
-#ifdef CONFIG_IPX_INTERN
-	unsigned char		node[IPX_NODE_LEN];
-#endif
-	unsigned short		type;
-	/*
-	 * To handle special ncp connection-handling sockets for mars_nwe,
- 	 * the connection number must be stored in the socket.
-	 */
-	unsigned short		ipx_ncp_conn;
-};
-
-static inline struct ipx_sock *ipx_sk(struct sock *sk)
-{
-	return (struct ipx_sock *)sk;
-}
-
-#define IPX_SKB_CB(__skb) ((struct ipx_cb *)&((__skb)->cb[0]))
-
-#define IPX_MIN_EPHEMERAL_SOCKET	0x4000
-#define IPX_MAX_EPHEMERAL_SOCKET	0x7fff
-
-extern struct list_head ipx_routes;
-extern rwlock_t ipx_routes_lock;
-
-extern struct list_head ipx_interfaces;
-struct ipx_interface *ipx_interfaces_head(void);
-extern spinlock_t ipx_interfaces_lock;
-
-extern struct ipx_interface *ipx_primary_net;
-
-int ipx_proc_init(void);
-void ipx_proc_exit(void);
-
-const char *ipx_frame_name(__be16);
-const char *ipx_device_name(struct ipx_interface *intrfc);
-
-static __inline__ void ipxitf_hold(struct ipx_interface *intrfc)
-{
-	refcount_inc(&intrfc->refcnt);
-}
-
-void ipxitf_down(struct ipx_interface *intrfc);
-struct ipx_interface *ipxitf_find_using_net(__be32 net);
-int ipxitf_send(struct ipx_interface *intrfc, struct sk_buff *skb, char *node);
-__be16 ipx_cksum(struct ipxhdr *packet, int length);
-int ipxrtr_add_route(__be32 network, struct ipx_interface *intrfc,
-		     unsigned char *node);
-void ipxrtr_del_routes(struct ipx_interface *intrfc);
-int ipxrtr_route_packet(struct sock *sk, struct sockaddr_ipx *usipx,
-			struct msghdr *msg, size_t len, int noblock);
-int ipxrtr_route_skb(struct sk_buff *skb);
-struct ipx_route *ipxrtr_lookup(__be32 net);
-int ipxrtr_ioctl(unsigned int cmd, void __user *arg);
-
-static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
-{
-	if (refcount_dec_and_test(&intrfc->refcnt))
-		ipxitf_down(intrfc);
-}
-
-static __inline__ void ipxrtr_hold(struct ipx_route *rt)
-{
-	        refcount_inc(&rt->refcnt);
-}
-
-static __inline__ void ipxrtr_put(struct ipx_route *rt)
-{
-	        if (refcount_dec_and_test(&rt->refcnt))
-			                kfree(rt);
-}
-#endif /* _NET_INET_IPX_H_ */
-- 
2.31.1

