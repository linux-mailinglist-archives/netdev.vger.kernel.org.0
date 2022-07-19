Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B2B579030
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbiGSB4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiGSB4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:56:47 -0400
Received: from smtp98.ord1c.emailsrvr.com (smtp98.ord1c.emailsrvr.com [108.166.43.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABAA27CF7
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 18:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1658195191;
        bh=MgEHdSfGZ/JLyQodpcbcklFZdwyaDRVrgVMjX46yIWo=;
        h=From:To:Subject:Date:From;
        b=Qhy4tJVQeDdA0V8SoX82v1dwfYzYlVhBu1RqAw/NAHk0miyvLyi6JJXHeILwvwnlY
         Pw47M3OGrB2B+c2YCwXzDocU9KJ8Nu6jjS3824OzHacW0gFCFXzqSVqEuh1mWbwNQ1
         zGp5k+GAERRVWL2O75tbNiY4T5jfajEcjr31z7G0=
X-Auth-ID: antonio@openvpn.net
Received: by smtp13.relay.ord1c.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 2F26BA013B;
        Mon, 18 Jul 2022 21:46:29 -0400 (EDT)
From:   Antonio Quartulli <antonio@openvpn.net>
To:     netdev@vger.kernel.org
Cc:     Antonio Quartulli <antonio@openvpn.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [RFC 1/1] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
Date:   Tue, 19 Jul 2022 03:47:04 +0200
Message-Id: <20220719014704.21346-2-antonio@openvpn.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220719014704.21346-1-antonio@openvpn.net>
References: <20220719014704.21346-1-antonio@openvpn.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: d34e7317-6ebb-43b3-b845-a9b2dd2374c9-2-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OpenVPN is a userspace software existing since around 2005 that allows
users to create secure tunnels.

So far OpenVPN has implemented all operations in userspace, which
implies several back and forth between kernel and user land in order to
process packets (encapsulate/decapsulate, encrypt/decrypt, rerouting..).

With ovpn-dco, we intend to move the fast path (data channel) entirely
in kernel space and thus improve user measured throughput over the
tunnel.

ovpn-dco is implemented as a simple virtual network device driver, that
can be manipulated by means of the standard RTNL APIs. A device of kind
'ovpn-dco' allows only IPv4/6 traffic and can be of type:
* P2P (peer-to-peer): any packet sent over the interface will be
  encapsulated and transmitted to the other side (typical OpenVPN
  client behaviour);
* P2MP (point-to-multipoint): packets sent over the interface are
  transmitted to peers based on existing routes (typical OpenVPN
  server behaviour).

After the interface has been created, OpenVPN in userspace can
configure it using a new Netlink API. Specifically it is possible
to manage peers, configure per-peer keys and exchange packets with
userspace.

The OpenVPN control channel is multiplexed over the same transport
socket by means of OP codes. Anything that is not DATA_V2 (OpenVPN
OP code for data traffic) is sent to userspace and handled there.
This way the ovpn-dco codebase is kept as compact as possible while
focusing on handling data traffic only.

Any OpenVPN control feature (like cipher negotiation, TLS handshake,
rekeying, etc.) is still fully handled by the userspace process.

When userspace establishes a new connection with a peer, it first
performs the handshake and then passes the socket to ovpn-dco, which
takes ownership. From this moment on ovpn-dco will handle data traffic
for the new peer. When control packets are received on the link, they
are forwarded to userspace via Netlink.

(this approach is somewhat inspired by hostapd+mac80211)

Some events (like peer deletion) are sent to a Netlink multicast group.

Although it wasn't easy to convince the community, ovpn-dco implements
only a limited number of the data-channel features supported by the
userspace program.

Each feature that made it to ovpn-dco was attentively vetted to
avoid carrying too much legacy along with us (and to give a clear cut to
old and probalby-not-so-useful features).

Notably, only encryption using AEAD ciphers (specifically
ChaCha20Poly1305 and AES-GCM) was implemented. Supporting any other
cipher out there was not deemed useful.

As explained above, in case of P2MP mode, OpenVPN will use the main system
routing table to decide which packet goes to which peer. This implies
that no routing table was re-implemented in ovpn-dco.

This kernel module can be enabled by selecting the CONFIG_OVPN_DCO entry
in the networking drivers section.

Cc: David Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
---
 MAINTAINERS                        |    8 +
 drivers/net/Kconfig                |   19 +
 drivers/net/Makefile               |    1 +
 drivers/net/ovpn-dco/Makefile      |   21 +
 drivers/net/ovpn-dco/addr.h        |   41 +
 drivers/net/ovpn-dco/bind.c        |   62 ++
 drivers/net/ovpn-dco/bind.h        |   67 ++
 drivers/net/ovpn-dco/crypto.c      |  154 ++++
 drivers/net/ovpn-dco/crypto.h      |  144 ++++
 drivers/net/ovpn-dco/crypto_aead.c |  369 +++++++++
 drivers/net/ovpn-dco/crypto_aead.h |   27 +
 drivers/net/ovpn-dco/main.c        |  281 +++++++
 drivers/net/ovpn-dco/main.h        |   39 +
 drivers/net/ovpn-dco/netlink.c     | 1132 ++++++++++++++++++++++++++++
 drivers/net/ovpn-dco/netlink.h     |   22 +
 drivers/net/ovpn-dco/ovpn.c        |  597 +++++++++++++++
 drivers/net/ovpn-dco/ovpn.h        |   43 ++
 drivers/net/ovpn-dco/ovpnstruct.h  |   59 ++
 drivers/net/ovpn-dco/peer.c        |  878 +++++++++++++++++++++
 drivers/net/ovpn-dco/peer.h        |  168 +++++
 drivers/net/ovpn-dco/pktid.c       |  127 ++++
 drivers/net/ovpn-dco/pktid.h       |  116 +++
 drivers/net/ovpn-dco/proto.h       |  101 +++
 drivers/net/ovpn-dco/rcu.h         |   21 +
 drivers/net/ovpn-dco/skb.h         |   54 ++
 drivers/net/ovpn-dco/sock.c        |  134 ++++
 drivers/net/ovpn-dco/sock.h        |   54 ++
 drivers/net/ovpn-dco/stats.c       |   20 +
 drivers/net/ovpn-dco/stats.h       |   67 ++
 drivers/net/ovpn-dco/tcp.c         |  324 ++++++++
 drivers/net/ovpn-dco/tcp.h         |   38 +
 drivers/net/ovpn-dco/udp.c         |  338 +++++++++
 drivers/net/ovpn-dco/udp.h         |   25 +
 include/net/netlink.h              |    1 +
 include/uapi/linux/ovpn_dco.h      |  265 +++++++
 include/uapi/linux/udp.h           |    1 +
 36 files changed, 5818 insertions(+)
 create mode 100644 drivers/net/ovpn-dco/Makefile
 create mode 100644 drivers/net/ovpn-dco/addr.h
 create mode 100644 drivers/net/ovpn-dco/bind.c
 create mode 100644 drivers/net/ovpn-dco/bind.h
 create mode 100644 drivers/net/ovpn-dco/crypto.c
 create mode 100644 drivers/net/ovpn-dco/crypto.h
 create mode 100644 drivers/net/ovpn-dco/crypto_aead.c
 create mode 100644 drivers/net/ovpn-dco/crypto_aead.h
 create mode 100644 drivers/net/ovpn-dco/main.c
 create mode 100644 drivers/net/ovpn-dco/main.h
 create mode 100644 drivers/net/ovpn-dco/netlink.c
 create mode 100644 drivers/net/ovpn-dco/netlink.h
 create mode 100644 drivers/net/ovpn-dco/ovpn.c
 create mode 100644 drivers/net/ovpn-dco/ovpn.h
 create mode 100644 drivers/net/ovpn-dco/ovpnstruct.h
 create mode 100644 drivers/net/ovpn-dco/peer.c
 create mode 100644 drivers/net/ovpn-dco/peer.h
 create mode 100644 drivers/net/ovpn-dco/pktid.c
 create mode 100644 drivers/net/ovpn-dco/pktid.h
 create mode 100644 drivers/net/ovpn-dco/proto.h
 create mode 100644 drivers/net/ovpn-dco/rcu.h
 create mode 100644 drivers/net/ovpn-dco/skb.h
 create mode 100644 drivers/net/ovpn-dco/sock.c
 create mode 100644 drivers/net/ovpn-dco/sock.h
 create mode 100644 drivers/net/ovpn-dco/stats.c
 create mode 100644 drivers/net/ovpn-dco/stats.h
 create mode 100644 drivers/net/ovpn-dco/tcp.c
 create mode 100644 drivers/net/ovpn-dco/tcp.h
 create mode 100644 drivers/net/ovpn-dco/udp.c
 create mode 100644 drivers/net/ovpn-dco/udp.h
 create mode 100644 include/uapi/linux/ovpn_dco.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 66738c8330db..1120a44f694e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15104,6 +15104,14 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
 F:	Documentation/filesystems/overlayfs.rst
 F:	fs/overlayfs/
 
+OVPN-DCO NETWORK DRIVER
+M:	Antonio Quartulli <antonio@openvpn.net>
+L:	openvpn-devel@lists.sourceforge.net (moderated for non-subscribers)
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	drivers/net/ovpn-dco/
+F:	include/uapi/linux/ovpn_dco.h
+
 P54 WIRELESS DRIVER
 M:	Christian Lamparter <chunkeey@googlemail.com>
 L:	linux-wireless@vger.kernel.org
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 94c889802566..349866bd4448 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -116,6 +116,25 @@ config WIREGUARD_DEBUG
 
 	  Say N here unless you know what you're doing.
 
+config OVPN_DCO
+	tristate "OpenVPN data channel offload"
+	depends on NET && INET
+	select NET_UDP_TUNNEL
+	select DST_CACHE
+	select CRYPTO
+	select CRYPTO_AES
+	select CRYPTO_GCM
+	select CRYPTO_CHACHA20POLY1305
+	help
+	  This module enhances the performance of an OpenVPN connection by
+	  allowing the user to offload the data channel processing to
+	  kernelspace.
+	  Connection handshake, parameters negotiation and other non-data
+	  related mechanisms are still performed in userspace.
+
+	  The OpenVPN userspace software at version 2.6 or higher is required
+	  to use this functionality.
+
 config EQUALIZER
 	tristate "EQL (serial line load balancing) support"
 	help
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 3f1192d3c52d..8ed151e8d233 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_IPVLAN) += ipvlan/
 obj-$(CONFIG_IPVTAP) += ipvlan/
 obj-$(CONFIG_DUMMY) += dummy.o
 obj-$(CONFIG_WIREGUARD) += wireguard/
+obj-$(CONFIG_OVPN_DCO) += ovpn-dco/
 obj-$(CONFIG_EQUALIZER) += eql.o
 obj-$(CONFIG_IFB) += ifb.o
 obj-$(CONFIG_MACSEC) += macsec.o
diff --git a/drivers/net/ovpn-dco/Makefile b/drivers/net/ovpn-dco/Makefile
new file mode 100644
index 000000000000..7efefe8f13a9
--- /dev/null
+++ b/drivers/net/ovpn-dco/Makefile
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# ovpn-dco -- OpenVPN data channel offload
+#
+# Copyright (C) 2020-2022 OpenVPN, Inc.
+#
+# Author:	Antonio Quartulli <antonio@openvpn.net>
+
+obj-$(CONFIG_OVPN_DCO) += ovpn-dco.o
+ovpn-dco-y += main.o
+ovpn-dco-y += bind.o
+ovpn-dco-y += crypto.o
+ovpn-dco-y += ovpn.o
+ovpn-dco-y += peer.o
+ovpn-dco-y += sock.o
+ovpn-dco-y += stats.o
+ovpn-dco-y += netlink.o
+ovpn-dco-y += crypto_aead.o
+ovpn-dco-y += pktid.o
+ovpn-dco-y += tcp.o
+ovpn-dco-y += udp.o
diff --git a/drivers/net/ovpn-dco/addr.h b/drivers/net/ovpn-dco/addr.h
new file mode 100644
index 000000000000..3d6ad0fc15af
--- /dev/null
+++ b/drivers/net/ovpn-dco/addr.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNADDR_H_
+#define _NET_OVPN_DCO_OVPNADDR_H_
+
+#include "crypto.h"
+
+#include <linux/jhash.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <net/ipv6.h>
+
+/* our basic transport layer address */
+struct ovpn_sockaddr {
+	union {
+		struct sockaddr_in in4;
+		struct sockaddr_in6 in6;
+	};
+};
+
+/* Translate skb->protocol value to AF_INET or AF_INET6 */
+static inline unsigned short skb_protocol_to_family(const struct sk_buff *skb)
+{
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return AF_INET;
+	case htons(ETH_P_IPV6):
+		return AF_INET6;
+	default:
+		return 0;
+	}
+}
+
+#endif /* _NET_OVPN_DCO_OVPNADDR_H_ */
diff --git a/drivers/net/ovpn-dco/bind.c b/drivers/net/ovpn-dco/bind.c
new file mode 100644
index 000000000000..107697ea983e
--- /dev/null
+++ b/drivers/net/ovpn-dco/bind.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2012-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "ovpn.h"
+#include "bind.h"
+#include "peer.h"
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/socket.h>
+#include <linux/types.h>
+
+/* Given a remote sockaddr, compute the skb hash
+ * and get a dst_entry so we can send packets to the remote.
+ * Called from process context or softirq (must be indicated with
+ * process_context bool).
+ */
+struct ovpn_bind *ovpn_bind_from_sockaddr(const struct sockaddr_storage *ss)
+{
+	struct ovpn_bind *bind;
+	size_t sa_len;
+
+	if (ss->ss_family == AF_INET)
+		sa_len = sizeof(struct sockaddr_in);
+	else if (ss->ss_family == AF_INET6)
+		sa_len = sizeof(struct sockaddr_in6);
+	else
+		return ERR_PTR(-EAFNOSUPPORT);
+
+	bind = kzalloc(sizeof(*bind), GFP_ATOMIC);
+	if (unlikely(!bind))
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(&bind->sa, ss, sa_len);
+
+	return bind;
+}
+
+static void ovpn_bind_release_rcu(struct rcu_head *head)
+{
+	struct ovpn_bind *bind = container_of(head, struct ovpn_bind, rcu);
+
+	kfree(bind);
+}
+
+void ovpn_bind_reset(struct ovpn_peer *peer, struct ovpn_bind *new)
+{
+	struct ovpn_bind *old;
+
+	spin_lock_bh(&peer->lock);
+	old = rcu_replace_pointer(peer->bind, new, true);
+	spin_unlock_bh(&peer->lock);
+
+	if (old)
+		call_rcu(&old->rcu, ovpn_bind_release_rcu);
+}
diff --git a/drivers/net/ovpn-dco/bind.h b/drivers/net/ovpn-dco/bind.h
new file mode 100644
index 000000000000..a562e471acae
--- /dev/null
+++ b/drivers/net/ovpn-dco/bind.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OVPN -- OpenVPN protocol accelerator for Linux
+ *  Copyright (C) 2012-2022 OpenVPN, Inc.
+ *  All rights reserved.
+ *  Author: James Yonan <james@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNBIND_H_
+#define _NET_OVPN_DCO_OVPNBIND_H_
+
+#include "addr.h"
+#include "rcu.h"
+
+#include <net/ip.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+
+struct ovpn_peer;
+
+struct ovpn_bind {
+	struct ovpn_sockaddr sa;  /* remote sockaddr */
+
+	union {
+		struct in_addr ipv4;
+		struct in6_addr ipv6;
+	} local;
+
+	struct rcu_head rcu;
+};
+
+static inline bool ovpn_bind_skb_src_match(const struct ovpn_bind *bind, struct sk_buff *skb)
+{
+	const unsigned short family = skb_protocol_to_family(skb);
+	const struct ovpn_sockaddr *sa = &bind->sa;
+
+	if (unlikely(!bind))
+		return false;
+
+	if (unlikely(sa->in4.sin_family != family))
+		return false;
+
+	switch (family) {
+	case AF_INET:
+		if (unlikely(sa->in4.sin_addr.s_addr != ip_hdr(skb)->saddr))
+			return false;
+
+		if (unlikely(sa->in4.sin_port != udp_hdr(skb)->source))
+			return false;
+		break;
+	case AF_INET6:
+		if (unlikely(!ipv6_addr_equal(&sa->in6.sin6_addr, &ipv6_hdr(skb)->saddr)))
+			return false;
+
+		if (unlikely(sa->in6.sin6_port != udp_hdr(skb)->source))
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+struct ovpn_bind *ovpn_bind_from_sockaddr(const struct sockaddr_storage *sa);
+void ovpn_bind_reset(struct ovpn_peer *peer, struct ovpn_bind *bind);
+
+#endif /* _NET_OVPN_DCO_OVPNBIND_H_ */
diff --git a/drivers/net/ovpn-dco/crypto.c b/drivers/net/ovpn-dco/crypto.c
new file mode 100644
index 000000000000..fcc3a351ba9d
--- /dev/null
+++ b/drivers/net/ovpn-dco/crypto.c
@@ -0,0 +1,154 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "crypto_aead.h"
+#include "crypto.h"
+
+#include <uapi/linux/ovpn_dco.h>
+
+static void ovpn_ks_destroy_rcu(struct rcu_head *head)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	ks = container_of(head, struct ovpn_crypto_key_slot, rcu);
+	ovpn_aead_crypto_key_slot_destroy(ks);
+}
+
+void ovpn_crypto_key_slot_release(struct kref *kref)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	ks = container_of(kref, struct ovpn_crypto_key_slot, refcount);
+	call_rcu(&ks->rcu, ovpn_ks_destroy_rcu);
+}
+
+/* can only be invoked when all peer references have been dropped (i.e. RCU
+ * release routine)
+ */
+void ovpn_crypto_state_release(struct ovpn_crypto_state *cs)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	ks = rcu_access_pointer(cs->primary);
+	if (ks) {
+		RCU_INIT_POINTER(cs->primary, NULL);
+		ovpn_crypto_key_slot_put(ks);
+	}
+
+	ks = rcu_access_pointer(cs->secondary);
+	if (ks) {
+		RCU_INIT_POINTER(cs->secondary, NULL);
+		ovpn_crypto_key_slot_put(ks);
+	}
+
+	mutex_destroy(&cs->mutex);
+}
+
+/* removes the primary key from the crypto context */
+void ovpn_crypto_kill_primary(struct ovpn_crypto_state *cs)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	mutex_lock(&cs->mutex);
+	ks = rcu_replace_pointer(cs->primary, NULL, lockdep_is_held(&cs->mutex));
+	ovpn_crypto_key_slot_put(ks);
+	mutex_unlock(&cs->mutex);
+}
+
+/* Reset the ovpn_crypto_state object in a way that is atomic
+ * to RCU readers.
+ */
+int ovpn_crypto_state_reset(struct ovpn_crypto_state *cs,
+			    const struct ovpn_peer_key_reset *pkr)
+	__must_hold(cs->mutex)
+{
+	struct ovpn_crypto_key_slot *old = NULL;
+	struct ovpn_crypto_key_slot *new;
+
+	lockdep_assert_held(&cs->mutex);
+
+	new = ovpn_aead_crypto_key_slot_new(&pkr->key);
+	if (IS_ERR(new))
+		return PTR_ERR(new);
+
+	switch (pkr->slot) {
+	case OVPN_KEY_SLOT_PRIMARY:
+		old = rcu_replace_pointer(cs->primary, new,
+					  lockdep_is_held(&cs->mutex));
+		break;
+	case OVPN_KEY_SLOT_SECONDARY:
+		old = rcu_replace_pointer(cs->secondary, new,
+					  lockdep_is_held(&cs->mutex));
+		break;
+	default:
+		goto free_key;
+	}
+
+	if (old)
+		ovpn_crypto_key_slot_put(old);
+
+	return 0;
+free_key:
+	ovpn_crypto_key_slot_put(new);
+	return -EINVAL;
+}
+
+void ovpn_crypto_key_slot_delete(struct ovpn_crypto_state *cs,
+				 enum ovpn_key_slot slot)
+{
+	struct ovpn_crypto_key_slot *ks = NULL;
+
+	mutex_lock(&cs->mutex);
+	switch (slot) {
+	case OVPN_KEY_SLOT_PRIMARY:
+		ks = rcu_replace_pointer(cs->primary, NULL,
+					 lockdep_is_held(&cs->mutex));
+		break;
+	case OVPN_KEY_SLOT_SECONDARY:
+		ks = rcu_replace_pointer(cs->secondary, NULL,
+					 lockdep_is_held(&cs->mutex));
+		break;
+	default:
+		pr_warn("Invalid slot to release: %u\n", slot);
+		break;
+	}
+	mutex_unlock(&cs->mutex);
+
+	if (!ks) {
+		pr_debug("Key slot already released: %u\n", slot);
+		return;
+	}
+	pr_debug("deleting key slot %u, key_id=%u\n", slot, ks->key_id);
+
+	ovpn_crypto_key_slot_put(ks);
+}
+
+/* this swap is not atomic, but there will be a very short time frame where the
+ * old_secondary key won't be available. This should not be a big deal as most
+ * likely both peers are already using the new primary at this point.
+ */
+void ovpn_crypto_key_slots_swap(struct ovpn_crypto_state *cs)
+{
+	const struct ovpn_crypto_key_slot *old_primary, *old_secondary;
+
+	mutex_lock(&cs->mutex);
+
+	old_secondary = rcu_dereference_protected(cs->secondary,
+						  lockdep_is_held(&cs->mutex));
+	old_primary = rcu_replace_pointer(cs->primary, old_secondary,
+					  lockdep_is_held(&cs->mutex));
+	rcu_assign_pointer(cs->secondary, old_primary);
+
+	pr_debug("key swapped: %u <-> %u\n",
+		 old_primary ? old_primary->key_id : 0,
+		 old_secondary ? old_secondary->key_id : 0);
+
+	mutex_unlock(&cs->mutex);
+}
diff --git a/drivers/net/ovpn-dco/crypto.h b/drivers/net/ovpn-dco/crypto.h
new file mode 100644
index 000000000000..79f580e54a63
--- /dev/null
+++ b/drivers/net/ovpn-dco/crypto.h
@@ -0,0 +1,144 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNCRYPTO_H_
+#define _NET_OVPN_DCO_OVPNCRYPTO_H_
+
+#include "main.h"
+#include "pktid.h"
+
+#include <uapi/linux/ovpn_dco.h>
+#include <linux/skbuff.h>
+
+struct ovpn_peer;
+struct ovpn_crypto_key_slot;
+
+/* info needed for both encrypt and decrypt directions */
+struct ovpn_key_direction {
+	const u8 *cipher_key;
+	size_t cipher_key_size;
+	const u8 *nonce_tail; /* only needed for GCM modes */
+	size_t nonce_tail_size; /* only needed for GCM modes */
+};
+
+/* all info for a particular symmetric key (primary or secondary) */
+struct ovpn_key_config {
+	enum ovpn_cipher_alg cipher_alg;
+	u8 key_id;
+	struct ovpn_key_direction encrypt;
+	struct ovpn_key_direction decrypt;
+};
+
+/* used to pass settings from netlink to the crypto engine */
+struct ovpn_peer_key_reset {
+	enum ovpn_key_slot slot;
+	struct ovpn_key_config key;
+};
+
+struct ovpn_crypto_key_slot {
+	u8 key_id;
+
+	struct crypto_aead *encrypt;
+	struct crypto_aead *decrypt;
+	struct ovpn_nonce_tail nonce_tail_xmit;
+	struct ovpn_nonce_tail nonce_tail_recv;
+
+	struct ovpn_pktid_recv pid_recv ____cacheline_aligned_in_smp;
+	struct ovpn_pktid_xmit pid_xmit ____cacheline_aligned_in_smp;
+	struct kref refcount;
+	struct rcu_head rcu;
+};
+
+struct ovpn_crypto_state {
+	struct ovpn_crypto_key_slot __rcu *primary;
+	struct ovpn_crypto_key_slot __rcu *secondary;
+
+	/* protects primary and secondary slots */
+	struct mutex mutex;
+};
+
+static inline bool ovpn_crypto_key_slot_hold(struct ovpn_crypto_key_slot *ks)
+{
+	return kref_get_unless_zero(&ks->refcount);
+}
+
+static inline void ovpn_crypto_state_init(struct ovpn_crypto_state *cs)
+{
+	RCU_INIT_POINTER(cs->primary, NULL);
+	RCU_INIT_POINTER(cs->secondary, NULL);
+	mutex_init(&cs->mutex);
+}
+
+static inline struct ovpn_crypto_key_slot *
+ovpn_crypto_key_id_to_slot(const struct ovpn_crypto_state *cs, u8 key_id)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	if (unlikely(!cs))
+		return NULL;
+
+	rcu_read_lock();
+	ks = rcu_dereference(cs->primary);
+	if (ks && ks->key_id == key_id) {
+		if (unlikely(!ovpn_crypto_key_slot_hold(ks)))
+			ks = NULL;
+		goto out;
+	}
+
+	ks = rcu_dereference(cs->secondary);
+	if (ks && ks->key_id == key_id) {
+		if (unlikely(!ovpn_crypto_key_slot_hold(ks)))
+			ks = NULL;
+		goto out;
+	}
+
+	/* when both key slots are occupied but no matching key ID is found, ks has to be reset to
+	 * NULL to avoid carrying a stale pointer
+	 */
+	ks = NULL;
+out:
+	rcu_read_unlock();
+
+	return ks;
+}
+
+static inline struct ovpn_crypto_key_slot *
+ovpn_crypto_key_slot_primary(const struct ovpn_crypto_state *cs)
+{
+	struct ovpn_crypto_key_slot *ks;
+
+	rcu_read_lock();
+	ks = rcu_dereference(cs->primary);
+	if (unlikely(ks && !ovpn_crypto_key_slot_hold(ks)))
+		ks = NULL;
+	rcu_read_unlock();
+
+	return ks;
+}
+
+void ovpn_crypto_key_slot_release(struct kref *kref);
+
+static inline void ovpn_crypto_key_slot_put(struct ovpn_crypto_key_slot *ks)
+{
+	kref_put(&ks->refcount, ovpn_crypto_key_slot_release);
+}
+
+int ovpn_crypto_state_reset(struct ovpn_crypto_state *cs,
+			    const struct ovpn_peer_key_reset *pkr);
+
+void ovpn_crypto_key_slot_delete(struct ovpn_crypto_state *cs,
+				 enum ovpn_key_slot slot);
+
+void ovpn_crypto_state_release(struct ovpn_crypto_state *cs);
+
+void ovpn_crypto_key_slots_swap(struct ovpn_crypto_state *cs);
+
+void ovpn_crypto_kill_primary(struct ovpn_crypto_state *cs);
+
+#endif /* _NET_OVPN_DCO_OVPNCRYPTO_H_ */
diff --git a/drivers/net/ovpn-dco/crypto_aead.c b/drivers/net/ovpn-dco/crypto_aead.c
new file mode 100644
index 000000000000..1dd9bab6e029
--- /dev/null
+++ b/drivers/net/ovpn-dco/crypto_aead.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "crypto_aead.h"
+#include "crypto.h"
+#include "pktid.h"
+#include "proto.h"
+#include "skb.h"
+
+#include <crypto/aead.h>
+#include <linux/skbuff.h>
+#include <linux/printk.h>
+
+#define AUTH_TAG_SIZE	16
+
+static int ovpn_aead_encap_overhead(const struct ovpn_crypto_key_slot *ks)
+{
+	return  OVPN_OP_SIZE_V2 +			/* OP header size */
+		4 +					/* Packet ID */
+		crypto_aead_authsize(ks->encrypt);	/* Auth Tag */
+}
+
+int ovpn_aead_encrypt(struct ovpn_crypto_key_slot *ks, struct sk_buff *skb, u32 peer_id)
+{
+	const unsigned int tag_size = crypto_aead_authsize(ks->encrypt);
+	const unsigned int head_size = ovpn_aead_encap_overhead(ks);
+	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	struct sk_buff *trailer;
+	u8 iv[NONCE_SIZE];
+	int nfrags, ret;
+	u32 pktid, op;
+
+	/* Sample AEAD header format:
+	 * 48000001 00000005 7e7046bd 444a7e28 cc6387b1 64a4d6c1 380275a...
+	 * [ OP32 ] [seq # ] [             auth tag            ] [ payload ... ]
+	 *          [4-byte
+	 *          IV head]
+	 */
+
+	/* check that there's enough headroom in the skb for packet
+	 * encapsulation, after adding network header and encryption overhead
+	 */
+	if (unlikely(skb_cow_head(skb, OVPN_HEAD_ROOM + head_size)))
+		return -ENOBUFS;
+
+	/* get number of skb frags and ensure that packet data is writable */
+	nfrags = skb_cow_data(skb, 0, &trailer);
+	if (unlikely(nfrags < 0))
+		return nfrags;
+
+	if (unlikely(nfrags + 2 > ARRAY_SIZE(sg)))
+		return -ENOSPC;
+
+	req = aead_request_alloc(ks->encrypt, GFP_KERNEL);
+	if (unlikely(!req))
+		return -ENOMEM;
+
+	/* sg table:
+	 * 0: op, wire nonce (AD, len=OVPN_OP_SIZE_V2+NONCE_WIRE_SIZE),
+	 * 1, 2, 3, ..., n: payload,
+	 * n+1: auth_tag (len=tag_size)
+	 */
+	sg_init_table(sg, nfrags + 2);
+
+	/* build scatterlist to encrypt packet payload */
+	ret = skb_to_sgvec_nomark(skb, sg + 1, 0, skb->len);
+	if (unlikely(nfrags != ret)) {
+		ret = -EINVAL;
+		goto free_req;
+	}
+
+	/* append auth_tag onto scatterlist */
+	__skb_push(skb, tag_size);
+	sg_set_buf(sg + nfrags + 1, skb->data, tag_size);
+
+	/* obtain packet ID, which is used both as a first
+	 * 4 bytes of nonce and last 4 bytes of associated data.
+	 */
+	ret = ovpn_pktid_xmit_next(&ks->pid_xmit, &pktid);
+	if (unlikely(ret < 0))
+		goto free_req;
+
+	/* concat 4 bytes packet id and 8 bytes nonce tail into 12 bytes nonce */
+	ovpn_pktid_aead_write(pktid, &ks->nonce_tail_xmit, iv);
+
+	/* make space for packet id and push it to the front */
+	__skb_push(skb, NONCE_WIRE_SIZE);
+	memcpy(skb->data, iv, NONCE_WIRE_SIZE);
+
+	/* add packet op as head of additional data */
+	op = ovpn_opcode_compose(OVPN_DATA_V2, ks->key_id, peer_id);
+	__skb_push(skb, OVPN_OP_SIZE_V2);
+	BUILD_BUG_ON(sizeof(op) != OVPN_OP_SIZE_V2);
+	*((__force __be32 *)skb->data) = htonl(op);
+
+	/* AEAD Additional data */
+	sg_set_buf(sg, skb->data, OVPN_OP_SIZE_V2 + NONCE_WIRE_SIZE);
+
+	/* setup async crypto operation */
+	aead_request_set_tfm(req, ks->encrypt);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				       CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_req_done, &wait);
+	aead_request_set_crypt(req, sg, sg, skb->len - head_size, iv);
+	aead_request_set_ad(req, OVPN_OP_SIZE_V2 + NONCE_WIRE_SIZE);
+
+	/* encrypt it */
+	ret = crypto_wait_req(crypto_aead_encrypt(req), &wait);
+	if (ret < 0)
+		pr_err_ratelimited("%s: encrypt failed: %d\n", __func__, ret);
+
+free_req:
+	aead_request_free(req);
+	return ret;
+}
+
+int ovpn_aead_decrypt(struct ovpn_crypto_key_slot *ks, struct sk_buff *skb)
+{
+	const unsigned int tag_size = crypto_aead_authsize(ks->decrypt);
+	struct scatterlist sg[MAX_SKB_FRAGS + 2];
+	int ret, payload_len, nfrags;
+	u8 *sg_data, iv[NONCE_SIZE];
+	unsigned int payload_offset;
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	struct sk_buff *trailer;
+	unsigned int sg_len;
+	__be32 *pid;
+
+	payload_offset = OVPN_OP_SIZE_V2 + NONCE_WIRE_SIZE + tag_size;
+	payload_len = skb->len - payload_offset;
+
+	/* sanity check on packet size, payload size must be >= 0 */
+	if (unlikely(payload_len < 0))
+		return -EINVAL;
+
+	/* Prepare the skb data buffer to be accessed up until the auth tag.
+	 * This is required because this area is directly mapped into the sg list.
+	 */
+	if (unlikely(!pskb_may_pull(skb, payload_offset)))
+		return -ENODATA;
+
+	/* get number of skb frags and ensure that packet data is writable */
+	nfrags = skb_cow_data(skb, 0, &trailer);
+	if (unlikely(nfrags < 0))
+		return nfrags;
+
+	if (unlikely(nfrags + 2 > ARRAY_SIZE(sg)))
+		return -ENOSPC;
+
+	req = aead_request_alloc(ks->decrypt, GFP_KERNEL);
+	if (unlikely(!req))
+		return -ENOMEM;
+
+	/* sg table:
+	 * 0: op, wire nonce (AD, len=OVPN_OP_SIZE_V2+NONCE_WIRE_SIZE),
+	 * 1, 2, 3, ..., n: payload,
+	 * n+1: auth_tag (len=tag_size)
+	 */
+	sg_init_table(sg, nfrags + 2);
+
+	/* packet op is head of additional data */
+	sg_data = skb->data;
+	sg_len = OVPN_OP_SIZE_V2 + NONCE_WIRE_SIZE;
+	sg_set_buf(sg, sg_data, sg_len);
+
+	/* build scatterlist to decrypt packet payload */
+	ret = skb_to_sgvec_nomark(skb, sg + 1, payload_offset, payload_len);
+	if (unlikely(nfrags != ret)) {
+		ret = -EINVAL;
+		goto free_req;
+	}
+
+	/* append auth_tag onto scatterlist */
+	sg_set_buf(sg + nfrags + 1, skb->data + sg_len, tag_size);
+
+	/* copy nonce into IV buffer */
+	memcpy(iv, skb->data + OVPN_OP_SIZE_V2, NONCE_WIRE_SIZE);
+	memcpy(iv + NONCE_WIRE_SIZE, ks->nonce_tail_recv.u8,
+	       sizeof(struct ovpn_nonce_tail));
+
+	/* setup async crypto operation */
+	aead_request_set_tfm(req, ks->decrypt);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				       CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_req_done, &wait);
+	aead_request_set_crypt(req, sg, sg, payload_len + tag_size, iv);
+
+	aead_request_set_ad(req, NONCE_WIRE_SIZE + OVPN_OP_SIZE_V2);
+
+	/* decrypt it */
+	ret = crypto_wait_req(crypto_aead_decrypt(req), &wait);
+	if (ret < 0) {
+		pr_err_ratelimited("%s: decrypt failed: %d\n", __func__, ret);
+		goto free_req;
+	}
+
+	/* PID sits after the op */
+	pid = (__force __be32 *)(skb->data + OVPN_OP_SIZE_V2);
+	ret = ovpn_pktid_recv(&ks->pid_recv, ntohl(*pid), 0);
+	if (unlikely(ret < 0))
+		goto free_req;
+
+	/* point to encapsulated IP packet */
+	__skb_pull(skb, payload_offset);
+
+free_req:
+	aead_request_free(req);
+	return ret;
+}
+
+/* Initialize a struct crypto_aead object */
+struct crypto_aead *ovpn_aead_init(const char *title, const char *alg_name,
+				   const unsigned char *key, unsigned int keylen)
+{
+	struct crypto_aead *aead;
+	int ret;
+
+	aead = crypto_alloc_aead(alg_name, 0, 0);
+	if (IS_ERR(aead)) {
+		ret = PTR_ERR(aead);
+		pr_err("%s crypto_alloc_aead failed, err=%d\n", title, ret);
+		aead = NULL;
+		goto error;
+	}
+
+	ret = crypto_aead_setkey(aead, key, keylen);
+	if (ret) {
+		pr_err("%s crypto_aead_setkey size=%u failed, err=%d\n", title,
+		       keylen, ret);
+		goto error;
+	}
+
+	ret = crypto_aead_setauthsize(aead, AUTH_TAG_SIZE);
+	if (ret) {
+		pr_err("%s crypto_aead_setauthsize failed, err=%d\n", title,
+		       ret);
+		goto error;
+	}
+
+	/* basic AEAD assumption */
+	if (crypto_aead_ivsize(aead) != NONCE_SIZE) {
+		pr_err("%s IV size must be %d\n", title, NONCE_SIZE);
+		ret = -EINVAL;
+		goto error;
+	}
+
+	pr_debug("********* Cipher %s (%s)\n", alg_name, title);
+	pr_debug("*** IV size=%u\n", crypto_aead_ivsize(aead));
+	pr_debug("*** req size=%u\n", crypto_aead_reqsize(aead));
+	pr_debug("*** block size=%u\n", crypto_aead_blocksize(aead));
+	pr_debug("*** auth size=%u\n", crypto_aead_authsize(aead));
+	pr_debug("*** alignmask=0x%x\n", crypto_aead_alignmask(aead));
+
+	return aead;
+
+error:
+	crypto_free_aead(aead);
+	return ERR_PTR(ret);
+}
+
+void ovpn_aead_crypto_key_slot_destroy(struct ovpn_crypto_key_slot *ks)
+{
+	if (!ks)
+		return;
+
+	crypto_free_aead(ks->encrypt);
+	crypto_free_aead(ks->decrypt);
+	kfree(ks);
+}
+
+static struct ovpn_crypto_key_slot *
+ovpn_aead_crypto_key_slot_init(enum ovpn_cipher_alg alg,
+			       const unsigned char *encrypt_key,
+			       unsigned int encrypt_keylen,
+			       const unsigned char *decrypt_key,
+			       unsigned int decrypt_keylen,
+			       const unsigned char *encrypt_nonce_tail,
+			       unsigned int encrypt_nonce_tail_len,
+			       const unsigned char *decrypt_nonce_tail,
+			       unsigned int decrypt_nonce_tail_len,
+			       u16 key_id)
+{
+	struct ovpn_crypto_key_slot *ks = NULL;
+	const char *alg_name;
+	int ret;
+
+	/* validate crypto alg */
+	switch (alg) {
+	case OVPN_CIPHER_ALG_AES_GCM:
+		alg_name = "gcm(aes)";
+		break;
+	case OVPN_CIPHER_ALG_CHACHA20_POLY1305:
+		alg_name = "rfc7539(chacha20,poly1305)";
+		break;
+	default:
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	/* build the key slot */
+	ks = kmalloc(sizeof(*ks), GFP_KERNEL);
+	if (!ks)
+		return ERR_PTR(-ENOMEM);
+
+	ks->encrypt = NULL;
+	ks->decrypt = NULL;
+	kref_init(&ks->refcount);
+	ks->key_id = key_id;
+
+	ks->encrypt = ovpn_aead_init("encrypt", alg_name, encrypt_key,
+				     encrypt_keylen);
+	if (IS_ERR(ks->encrypt)) {
+		ret = PTR_ERR(ks->encrypt);
+		ks->encrypt = NULL;
+		goto destroy_ks;
+	}
+
+	ks->decrypt = ovpn_aead_init("decrypt", alg_name, decrypt_key,
+				     decrypt_keylen);
+	if (IS_ERR(ks->decrypt)) {
+		ret = PTR_ERR(ks->decrypt);
+		ks->decrypt = NULL;
+		goto destroy_ks;
+	}
+
+	if (sizeof(struct ovpn_nonce_tail) != encrypt_nonce_tail_len ||
+	    sizeof(struct ovpn_nonce_tail) != decrypt_nonce_tail_len) {
+		ret = -EINVAL;
+		goto destroy_ks;
+	}
+
+	memcpy(ks->nonce_tail_xmit.u8, encrypt_nonce_tail,
+	       sizeof(struct ovpn_nonce_tail));
+	memcpy(ks->nonce_tail_recv.u8, decrypt_nonce_tail,
+	       sizeof(struct ovpn_nonce_tail));
+
+	/* init packet ID generation/validation */
+	ovpn_pktid_xmit_init(&ks->pid_xmit);
+	ovpn_pktid_recv_init(&ks->pid_recv);
+
+	return ks;
+
+destroy_ks:
+	ovpn_aead_crypto_key_slot_destroy(ks);
+	return ERR_PTR(ret);
+}
+
+struct ovpn_crypto_key_slot *
+ovpn_aead_crypto_key_slot_new(const struct ovpn_key_config *kc)
+{
+	return ovpn_aead_crypto_key_slot_init(kc->cipher_alg,
+					      kc->encrypt.cipher_key,
+					      kc->encrypt.cipher_key_size,
+					      kc->decrypt.cipher_key,
+					      kc->decrypt.cipher_key_size,
+					      kc->encrypt.nonce_tail,
+					      kc->encrypt.nonce_tail_size,
+					      kc->decrypt.nonce_tail,
+					      kc->decrypt.nonce_tail_size,
+					      kc->key_id);
+}
diff --git a/drivers/net/ovpn-dco/crypto_aead.h b/drivers/net/ovpn-dco/crypto_aead.h
new file mode 100644
index 000000000000..1e3054e7d5a4
--- /dev/null
+++ b/drivers/net/ovpn-dco/crypto_aead.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNAEAD_H_
+#define _NET_OVPN_DCO_OVPNAEAD_H_
+
+#include "crypto.h"
+
+#include <asm/types.h>
+#include <linux/skbuff.h>
+
+struct crypto_aead *ovpn_aead_init(const char *title, const char *alg_name,
+				   const unsigned char *key, unsigned int keylen);
+
+int ovpn_aead_encrypt(struct ovpn_crypto_key_slot *ks, struct sk_buff *skb, u32 peer_id);
+int ovpn_aead_decrypt(struct ovpn_crypto_key_slot *ks, struct sk_buff *skb);
+
+struct ovpn_crypto_key_slot *ovpn_aead_crypto_key_slot_new(const struct ovpn_key_config *kc);
+void ovpn_aead_crypto_key_slot_destroy(struct ovpn_crypto_key_slot *ks);
+
+#endif /* _NET_OVPN_DCO_OVPNAEAD_H_ */
diff --git a/drivers/net/ovpn-dco/main.c b/drivers/net/ovpn-dco/main.c
new file mode 100644
index 000000000000..1bc077c62e3c
--- /dev/null
+++ b/drivers/net/ovpn-dco/main.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ *		James Yonan <james@openvpn.net>
+ */
+
+#include "main.h"
+
+#include "ovpn.h"
+#include "ovpnstruct.h"
+#include "netlink.h"
+
+#include <linux/ethtool.h>
+#include <linux/genetlink.h>
+#include <linux/inetdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/lockdep.h>
+#include <linux/rcupdate.h>
+#include <linux/net.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/version.h>
+
+#include <net/ip_tunnels.h>
+
+/* Driver info */
+#define DRV_NAME	"ovpn-dco"
+#define DRV_VERSION	OVPN_DCO_VERSION
+#define DRV_DESCRIPTION	"OpenVPN data channel offload (ovpn-dco)"
+#define DRV_COPYRIGHT	"(C) 2020-2022 OpenVPN, Inc."
+
+static void ovpn_struct_free(struct net_device *net)
+{
+	struct ovpn_struct *ovpn = netdev_priv(net);
+
+	security_tun_dev_free_security(ovpn->security);
+	free_percpu(net->tstats);
+	flush_workqueue(ovpn->crypto_wq);
+	flush_workqueue(ovpn->events_wq);
+	destroy_workqueue(ovpn->crypto_wq);
+	destroy_workqueue(ovpn->events_wq);
+	rcu_barrier();
+}
+
+/* Net device open */
+static int ovpn_net_open(struct net_device *dev)
+{
+	struct in_device *dev_v4 = __in_dev_get_rtnl(dev);
+
+	if (dev_v4) {
+		/* disable redirects as Linux gets confused by ovpn-dco handling same-LAN routing */
+		IN_DEV_CONF_SET(dev_v4, SEND_REDIRECTS, false);
+		IPV4_DEVCONF_ALL(dev_net(dev), SEND_REDIRECTS) = false;
+	}
+
+	netif_tx_start_all_queues(dev);
+	return 0;
+}
+
+/* Net device stop -- called prior to device unload */
+static int ovpn_net_stop(struct net_device *dev)
+{
+	netif_tx_stop_all_queues(dev);
+	return 0;
+}
+
+static int ovpn_net_change_mtu(struct net_device *dev, int new_mtu)
+{
+	if (new_mtu < IPV4_MIN_MTU ||
+	    new_mtu + dev->hard_header_len > IP_MAX_MTU)
+		return -EINVAL;
+
+	dev->mtu = new_mtu;
+
+	return 0;
+}
+
+/*******************************************
+ * ovpn ethtool ops
+ *******************************************/
+
+static int ovpn_get_link_ksettings(struct net_device *dev,
+				   struct ethtool_link_ksettings *cmd)
+{
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported, 0);
+	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising, 0);
+	cmd->base.speed	= SPEED_1000;
+	cmd->base.duplex = DUPLEX_FULL;
+	cmd->base.port = PORT_TP;
+	cmd->base.phy_address = 0;
+	cmd->base.transceiver = XCVR_INTERNAL;
+	cmd->base.autoneg = AUTONEG_DISABLE;
+
+	return 0;
+}
+
+static void ovpn_get_drvinfo(struct net_device *dev,
+			     struct ethtool_drvinfo *info)
+{
+	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
+	strscpy(info->version, DRV_VERSION, sizeof(info->version));
+	strscpy(info->bus_info, "ovpn", sizeof(info->bus_info));
+}
+
+bool ovpn_dev_is_valid(const struct net_device *dev)
+{
+	return dev->netdev_ops->ndo_start_xmit == ovpn_net_xmit;
+}
+
+/*******************************************
+ * ovpn exported methods
+ *******************************************/
+
+static const struct net_device_ops ovpn_netdev_ops = {
+	.ndo_change_mtu		= ovpn_net_change_mtu,
+	.ndo_open		= ovpn_net_open,
+	.ndo_stop		= ovpn_net_stop,
+	.ndo_start_xmit		= ovpn_net_xmit,
+	.ndo_get_stats64        = dev_get_tstats64,
+};
+
+static const struct ethtool_ops ovpn_ethtool_ops = {
+	.get_link_ksettings	= ovpn_get_link_ksettings,
+	.get_drvinfo		= ovpn_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_ts_info		= ethtool_op_get_ts_info,
+};
+
+static void ovpn_setup(struct net_device *dev)
+{
+	/* compute the overhead considering AEAD encryption */
+	const int overhead = sizeof(u32) + NONCE_WIRE_SIZE + 16 + sizeof(struct udphdr) +
+			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
+
+	netdev_features_t feat = NETIF_F_SG | NETIF_F_LLTX |
+				 NETIF_F_HW_CSUM | NETIF_F_RXCSUM | NETIF_F_GSO |
+				 NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA;
+
+	dev->ethtool_ops = &ovpn_ethtool_ops;
+	dev->needs_free_netdev = true;
+
+	dev->netdev_ops = &ovpn_netdev_ops;
+
+	dev->priv_destructor = ovpn_struct_free;
+
+	/* Point-to-Point TUN Device */
+	dev->hard_header_len = 0;
+	dev->addr_len = 0;
+	dev->mtu = ETH_DATA_LEN - overhead;
+	dev->max_mtu = INT_MAX - overhead;
+
+	/* Zero header length */
+	dev->type = ARPHRD_NONE;
+	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
+
+	dev->features |= feat;
+	dev->hw_features |= feat;
+	dev->hw_enc_features |= feat;
+
+	dev->needed_headroom = OVPN_HEAD_ROOM;
+	dev->needed_tailroom = OVPN_MAX_PADDING;
+}
+
+static const struct nla_policy ovpn_policy[IFLA_OVPN_MAX + 1] = {
+	[IFLA_OVPN_MODE] = NLA_POLICY_RANGE(NLA_U8, __OVPN_MODE_FIRST,
+					    __OVPN_MODE_AFTER_LAST - 1),
+};
+
+static int ovpn_newlink(struct net *src_net, struct net_device *dev, struct nlattr *tb[],
+			struct nlattr *data[], struct netlink_ext_ack *extack)
+{
+	struct ovpn_struct *ovpn = netdev_priv(dev);
+	int ret;
+
+	ret = security_tun_dev_create();
+	if (ret < 0)
+		return ret;
+
+	ret = ovpn_struct_init(dev);
+	if (ret < 0)
+		return ret;
+
+	ovpn->mode = OVPN_MODE_P2P;
+	if (data && data[IFLA_OVPN_MODE]) {
+		ovpn->mode = nla_get_u8(data[IFLA_OVPN_MODE]);
+		pr_debug("%s: setting device (%s) mode: %u\n", __func__, dev->name, ovpn->mode);
+	}
+
+	return register_netdevice(dev);
+}
+
+static void ovpn_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct ovpn_struct *ovpn = netdev_priv(dev);
+
+	switch (ovpn->mode) {
+	case OVPN_MODE_P2P:
+		ovpn_peer_release_p2p(ovpn);
+		break;
+	default:
+		ovpn_peers_free(ovpn);
+		break;
+	}
+
+	unregister_netdevice_queue(dev, head);
+}
+
+/**
+ * ovpn_num_queues - define number of queues to allocate per device
+ *
+ * The value returned by this function is used to decide how many RX and TX
+ * queues to allocate when creating the netdev object
+ *
+ * Return the number of queues to allocate
+ */
+static unsigned int ovpn_num_queues(void)
+{
+	return num_online_cpus();
+}
+
+static struct rtnl_link_ops ovpn_link_ops __read_mostly = {
+	.kind			= DRV_NAME,
+	.priv_size		= sizeof(struct ovpn_struct),
+	.setup			= ovpn_setup,
+	.policy			= ovpn_policy,
+	.maxtype		= IFLA_OVPN_MAX,
+	.newlink		= ovpn_newlink,
+	.dellink		= ovpn_dellink,
+	.get_num_tx_queues	= ovpn_num_queues,
+	.get_num_rx_queues	= ovpn_num_queues,
+};
+
+static int __init ovpn_init(void)
+{
+	int err = 0;
+
+	pr_info("%s %s -- %s\n", DRV_DESCRIPTION, DRV_VERSION, DRV_COPYRIGHT);
+
+	/* init RTNL link ops */
+	err = rtnl_link_register(&ovpn_link_ops);
+	if (err) {
+		pr_err("ovpn: can't register RTNL link ops\n");
+		goto err;
+	}
+
+	err = ovpn_netlink_register();
+	if (err) {
+		pr_err("ovpn: can't register netlink family\n");
+		goto err_rtnl_unregister;
+	}
+
+	return 0;
+
+err_rtnl_unregister:
+	rtnl_link_unregister(&ovpn_link_ops);
+err:
+	pr_err("ovpn: initialization failed, error status=%d\n", err);
+	return err;
+}
+
+static __exit void ovpn_cleanup(void)
+{
+	rtnl_link_unregister(&ovpn_link_ops);
+	ovpn_netlink_unregister();
+	rcu_barrier(); /* because we use call_rcu */
+}
+
+module_init(ovpn_init);
+module_exit(ovpn_cleanup);
+
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_AUTHOR(DRV_COPYRIGHT);
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+MODULE_ALIAS_RTNL_LINK(DRV_NAME);
+MODULE_ALIAS_GENL_FAMILY(OVPN_NL_NAME);
diff --git a/drivers/net/ovpn-dco/main.h b/drivers/net/ovpn-dco/main.h
new file mode 100644
index 000000000000..5407d403201e
--- /dev/null
+++ b/drivers/net/ovpn-dco/main.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_MAIN_H_
+#define _NET_OVPN_DCO_MAIN_H_
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/printk.h>
+#include <linux/udp.h>
+
+#ifndef OVPN_DCO_VERSION
+#define OVPN_DCO_VERSION "2.0.0"
+#endif
+
+/* Our UDP encapsulation types, must be unique
+ * (other values in include/uapi/linux/udp.h)
+ */
+#define UDP_ENCAP_OVPNINUDP 100  /* transport layer */
+
+struct net_device;
+bool ovpn_dev_is_valid(const struct net_device *dev);
+
+#define SKB_HEADER_LEN                                       \
+	(max(sizeof(struct iphdr), sizeof(struct ipv6hdr)) + \
+	 sizeof(struct udphdr) + NET_SKB_PAD)
+
+#define OVPN_HEAD_ROOM ALIGN(16 + SKB_HEADER_LEN, 4)
+#define OVPN_MAX_PADDING 16
+#define OVPN_QUEUE_LEN 1024
+#define OVPN_MAX_TUN_QUEUE_LEN 0x10000
+
+#endif /* _NET_OVPN_DCO_OVPN_DCO_H_ */
diff --git a/drivers/net/ovpn-dco/netlink.c b/drivers/net/ovpn-dco/netlink.c
new file mode 100644
index 000000000000..8e5fb2e17306
--- /dev/null
+++ b/drivers/net/ovpn-dco/netlink.c
@@ -0,0 +1,1132 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "ovpn.h"
+#include "peer.h"
+#include "proto.h"
+#include "netlink.h"
+#include "ovpnstruct.h"
+#include "udp.h"
+
+#include <uapi/linux/ovpn_dco.h>
+
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <linux/rcupdate.h>
+#include <linux/socket.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <net/genetlink.h>
+#include <uapi/linux/in.h>
+#include <uapi/linux/in6.h>
+
+/** The ovpn-dco netlink family */
+static struct genl_family ovpn_netlink_family;
+
+enum ovpn_netlink_multicast_groups {
+	OVPN_MCGRP_PEERS,
+};
+
+static const struct genl_multicast_group ovpn_netlink_mcgrps[] = {
+	[OVPN_MCGRP_PEERS] = { .name = OVPN_NL_MULTICAST_GROUP_PEERS },
+};
+
+/** Key direction policy. Can be used for configuring an encryption and a decryption key */
+static const struct nla_policy ovpn_netlink_policy_key_dir[OVPN_KEY_DIR_ATTR_MAX + 1] = {
+	[OVPN_KEY_DIR_ATTR_CIPHER_KEY] = NLA_POLICY_MAX_LEN(U8_MAX),
+	[OVPN_KEY_DIR_ATTR_NONCE_TAIL] = NLA_POLICY_EXACT_LEN(NONCE_TAIL_SIZE),
+};
+
+/** CMD_NEW_KEY policy */
+static const struct nla_policy ovpn_netlink_policy_new_key[OVPN_NEW_KEY_ATTR_MAX + 1] = {
+	[OVPN_NEW_KEY_ATTR_PEER_ID] = { .type = NLA_U32 },
+	[OVPN_NEW_KEY_ATTR_KEY_SLOT] = NLA_POLICY_RANGE(NLA_U8, __OVPN_KEY_SLOT_FIRST,
+							__OVPN_KEY_SLOT_AFTER_LAST - 1),
+	[OVPN_NEW_KEY_ATTR_KEY_ID] = { .type = NLA_U8 },
+	[OVPN_NEW_KEY_ATTR_CIPHER_ALG] = { .type = NLA_U16 },
+	[OVPN_NEW_KEY_ATTR_ENCRYPT_KEY] = NLA_POLICY_NESTED(ovpn_netlink_policy_key_dir),
+	[OVPN_NEW_KEY_ATTR_DECRYPT_KEY] = NLA_POLICY_NESTED(ovpn_netlink_policy_key_dir),
+};
+
+/** CMD_DEL_KEY policy */
+static const struct nla_policy ovpn_netlink_policy_del_key[OVPN_DEL_KEY_ATTR_MAX + 1] = {
+	[OVPN_DEL_KEY_ATTR_PEER_ID] = { .type = NLA_U32 },
+	[OVPN_DEL_KEY_ATTR_KEY_SLOT] = NLA_POLICY_RANGE(NLA_U8, __OVPN_KEY_SLOT_FIRST,
+							__OVPN_KEY_SLOT_AFTER_LAST - 1),
+};
+
+/** CMD_SWAP_KEYS policy */
+static const struct nla_policy ovpn_netlink_policy_swap_keys[OVPN_SWAP_KEYS_ATTR_MAX + 1] = {
+	[OVPN_SWAP_KEYS_ATTR_PEER_ID] = { .type = NLA_U32 },
+};
+
+/** CMD_NEW_PEER policy */
+static const struct nla_policy ovpn_netlink_policy_new_peer[OVPN_NEW_PEER_ATTR_MAX + 1] = {
+	[OVPN_NEW_PEER_ATTR_PEER_ID] = { .type = NLA_U32 },
+	[OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE] = NLA_POLICY_MIN_LEN(sizeof(struct sockaddr)),
+	[OVPN_NEW_PEER_ATTR_SOCKET] = { .type = NLA_U32 },
+	[OVPN_NEW_PEER_ATTR_IPV4] = { .type = NLA_U32 },
+	[OVPN_NEW_PEER_ATTR_IPV6] = NLA_POLICY_EXACT_LEN(sizeof(struct in6_addr)),
+	[OVPN_NEW_PEER_ATTR_LOCAL_IP] = NLA_POLICY_MAX_LEN(sizeof(struct in6_addr)),
+};
+
+/** CMD_SET_PEER policy */
+static const struct nla_policy ovpn_netlink_policy_set_peer[OVPN_SET_PEER_ATTR_MAX + 1] = {
+	[OVPN_SET_PEER_ATTR_PEER_ID] = { .type = NLA_U32 },
+	[OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL] = { .type = NLA_U32 },
+	[OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT] = { .type = NLA_U32 },
+};
+
+/** CMD_DEL_PEER policy */
+static const struct nla_policy ovpn_netlink_policy_del_peer[OVPN_DEL_PEER_ATTR_MAX + 1] = {
+	[OVPN_DEL_PEER_ATTR_REASON] = NLA_POLICY_RANGE(NLA_U8, __OVPN_DEL_PEER_REASON_FIRST,
+						       __OVPN_DEL_PEER_REASON_AFTER_LAST - 1),
+	[OVPN_DEL_PEER_ATTR_PEER_ID] = { .type = NLA_U32 },
+};
+
+/** CMD_GET_PEER policy */
+static const struct nla_policy ovpn_netlink_policy_get_peer[OVPN_GET_PEER_ATTR_MAX + 1] = {
+	[OVPN_GET_PEER_ATTR_PEER_ID] = { .type = NLA_U32 },
+};
+
+/** CMD_PACKET polocy */
+static const struct nla_policy ovpn_netlink_policy_packet[OVPN_PACKET_ATTR_MAX + 1] = {
+	[OVPN_PACKET_ATTR_PEER_ID] = { .type = NLA_U32 },
+	[OVPN_PACKET_ATTR_PACKET] = NLA_POLICY_MAX_LEN(U16_MAX),
+};
+
+/** Generic message container policy */
+static const struct nla_policy ovpn_netlink_policy[OVPN_ATTR_MAX + 1] = {
+	[OVPN_ATTR_IFINDEX] = { .type = NLA_U32 },
+	[OVPN_ATTR_NEW_PEER] = NLA_POLICY_NESTED(ovpn_netlink_policy_new_peer),
+	[OVPN_ATTR_SET_PEER] = NLA_POLICY_NESTED(ovpn_netlink_policy_set_peer),
+	[OVPN_ATTR_DEL_PEER] = NLA_POLICY_NESTED(ovpn_netlink_policy_del_peer),
+	[OVPN_ATTR_GET_PEER] = NLA_POLICY_NESTED(ovpn_netlink_policy_get_peer),
+	[OVPN_ATTR_NEW_KEY] = NLA_POLICY_NESTED(ovpn_netlink_policy_new_key),
+	[OVPN_ATTR_SWAP_KEYS] = NLA_POLICY_NESTED(ovpn_netlink_policy_swap_keys),
+	[OVPN_ATTR_DEL_KEY] = NLA_POLICY_NESTED(ovpn_netlink_policy_del_key),
+	[OVPN_ATTR_PACKET] = NLA_POLICY_NESTED(ovpn_netlink_policy_packet),
+};
+
+static struct net_device *
+ovpn_get_dev_from_attrs(struct net *net, struct nlattr **attrs)
+{
+	struct net_device *dev;
+	int ifindex;
+
+	if (!attrs[OVPN_ATTR_IFINDEX])
+		return ERR_PTR(-EINVAL);
+
+	ifindex = nla_get_u32(attrs[OVPN_ATTR_IFINDEX]);
+
+	dev = dev_get_by_index(net, ifindex);
+	if (!dev)
+		return ERR_PTR(-ENODEV);
+
+	if (!ovpn_dev_is_valid(dev))
+		goto err_put_dev;
+
+	return dev;
+
+err_put_dev:
+	dev_put(dev);
+
+	return ERR_PTR(-EINVAL);
+}
+
+/**
+ * ovpn_pre_doit() - Prepare ovpn genl doit request
+ * @ops: requested netlink operation
+ * @skb: Netlink message with request data
+ * @info: receiver information
+ *
+ * Return: 0 on success or negative error number in case of failure
+ */
+static int ovpn_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
+			 struct genl_info *info)
+{
+	struct net *net = genl_info_net(info);
+	struct net_device *dev;
+
+	dev = ovpn_get_dev_from_attrs(net, info->attrs);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	info->user_ptr[0] = netdev_priv(dev);
+
+	return 0;
+}
+
+/**
+ * ovpn_post_doit() - complete ovpn genl doit request
+ * @ops: requested netlink operation
+ * @skb: Netlink message with request data
+ * @info: receiver information
+ */
+static void ovpn_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
+			   struct genl_info *info)
+{
+	struct ovpn_struct *ovpn;
+
+	ovpn = info->user_ptr[0];
+	dev_put(ovpn->dev);
+}
+
+static int ovpn_netlink_get_key_dir(struct genl_info *info, struct nlattr *key,
+				    enum ovpn_cipher_alg cipher,
+				    struct ovpn_key_direction *dir)
+{
+	struct nlattr *attr, *attrs[OVPN_KEY_DIR_ATTR_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(attrs, OVPN_KEY_DIR_ATTR_MAX, key, NULL, info->extack);
+	if (ret)
+		return ret;
+
+	switch (cipher) {
+	case OVPN_CIPHER_ALG_AES_GCM:
+	case OVPN_CIPHER_ALG_CHACHA20_POLY1305:
+		attr = attrs[OVPN_KEY_DIR_ATTR_CIPHER_KEY];
+		if (!attr)
+			return -EINVAL;
+
+		dir->cipher_key = nla_data(attr);
+		dir->cipher_key_size = nla_len(attr);
+
+		attr = attrs[OVPN_KEY_DIR_ATTR_NONCE_TAIL];
+		/* These algorithms require a 96bit nonce,
+		 * Construct it by combining 4-bytes packet id and
+		 * 8-bytes nonce-tail from userspace
+		 */
+		if (!attr)
+			return -EINVAL;
+
+		dir->nonce_tail = nla_data(attr);
+		dir->nonce_tail_size = nla_len(attr);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ovpn_netlink_new_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_NEW_KEY_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	struct ovpn_peer_key_reset pkr;
+	struct ovpn_peer *peer;
+	u32 peer_id;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_NEW_KEY])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_NEW_KEY_ATTR_MAX, info->attrs[OVPN_ATTR_NEW_KEY],
+			       NULL, info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_NEW_KEY_ATTR_PEER_ID] ||
+	    !attrs[OVPN_NEW_KEY_ATTR_KEY_SLOT] ||
+	    !attrs[OVPN_NEW_KEY_ATTR_KEY_ID] ||
+	    !attrs[OVPN_NEW_KEY_ATTR_CIPHER_ALG] ||
+	    !attrs[OVPN_NEW_KEY_ATTR_ENCRYPT_KEY] ||
+	    !attrs[OVPN_NEW_KEY_ATTR_DECRYPT_KEY])
+		return -EINVAL;
+
+	peer_id = nla_get_u32(attrs[OVPN_NEW_KEY_ATTR_PEER_ID]);
+	pkr.slot = nla_get_u8(attrs[OVPN_NEW_KEY_ATTR_KEY_SLOT]);
+	pkr.key.key_id = nla_get_u16(attrs[OVPN_NEW_KEY_ATTR_KEY_ID]);
+
+	pkr.key.cipher_alg = nla_get_u16(attrs[OVPN_NEW_KEY_ATTR_CIPHER_ALG]);
+
+	ret = ovpn_netlink_get_key_dir(info, attrs[OVPN_NEW_KEY_ATTR_ENCRYPT_KEY],
+				       pkr.key.cipher_alg, &pkr.key.encrypt);
+	if (ret < 0)
+		return ret;
+
+	ret = ovpn_netlink_get_key_dir(info, attrs[OVPN_NEW_KEY_ATTR_DECRYPT_KEY],
+				       pkr.key.cipher_alg, &pkr.key.decrypt);
+	if (ret < 0)
+		return ret;
+
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (!peer) {
+		pr_debug("%s: no peer with id %u to set key for\n", __func__, peer_id);
+		return -ENOENT;
+	}
+
+	mutex_lock(&peer->crypto.mutex);
+	ret = ovpn_crypto_state_reset(&peer->crypto, &pkr);
+	if (ret < 0) {
+		pr_debug("%s: cannot install new key for peer %u\n", __func__, peer_id);
+		goto unlock;
+	}
+
+	pr_debug("%s: new key installed (id=%u) for peer %u\n", __func__, pkr.key.key_id, peer_id);
+unlock:
+	mutex_unlock(&peer->crypto.mutex);
+	ovpn_peer_put(peer);
+	return ret;
+}
+
+static int ovpn_netlink_del_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_DEL_KEY_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	enum ovpn_key_slot slot;
+	struct ovpn_peer *peer;
+	u32 peer_id;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_DEL_KEY])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_DEL_KEY_ATTR_MAX, info->attrs[OVPN_ATTR_DEL_KEY], NULL,
+			       info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_DEL_KEY_ATTR_PEER_ID] || !attrs[OVPN_DEL_KEY_ATTR_KEY_SLOT])
+		return -EINVAL;
+
+	peer_id = nla_get_u32(attrs[OVPN_DEL_KEY_ATTR_PEER_ID]);
+	slot = nla_get_u8(attrs[OVPN_DEL_KEY_ATTR_KEY_SLOT]);
+
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (!peer)
+		return -ENOENT;
+
+	ovpn_crypto_key_slot_delete(&peer->crypto, slot);
+	ovpn_peer_put(peer);
+
+	return 0;
+}
+
+static int ovpn_netlink_swap_keys(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_SWAP_KEYS_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	struct ovpn_peer *peer;
+	u32 peer_id;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_SWAP_KEYS])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_SWAP_KEYS_ATTR_MAX, info->attrs[OVPN_ATTR_SWAP_KEYS],
+			       NULL, info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_SWAP_KEYS_ATTR_PEER_ID])
+		return -EINVAL;
+
+	peer_id = nla_get_u32(attrs[OVPN_SWAP_KEYS_ATTR_PEER_ID]);
+
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (!peer)
+		return -ENOENT;
+
+	ovpn_crypto_key_slots_swap(&peer->crypto);
+	ovpn_peer_put(peer);
+
+	return 0;
+}
+
+static int ovpn_netlink_new_peer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_NEW_PEER_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	struct sockaddr_storage *ss = NULL;
+	struct sockaddr_in mapped;
+	struct sockaddr_in6 *in6;
+	struct ovpn_peer *peer;
+	size_t sa_len, ip_len;
+	struct socket *sock;
+	u8 *local_ip = NULL;
+	u32 sockfd, id;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_NEW_PEER])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_NEW_PEER_ATTR_MAX, info->attrs[OVPN_ATTR_NEW_PEER], NULL,
+			       info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_NEW_PEER_ATTR_PEER_ID] || !attrs[OVPN_NEW_PEER_ATTR_SOCKET] ||
+	    (!attrs[OVPN_NEW_PEER_ATTR_IPV4] && !attrs[OVPN_NEW_PEER_ATTR_IPV6])) {
+		pr_debug("%s: basic attributes missing\n", __func__);
+		return -EINVAL;
+	}
+
+	/* lookup the fd in the kernel table and extract the socket object */
+	sockfd = nla_get_u32(attrs[OVPN_NEW_PEER_ATTR_SOCKET]);
+	/* sockfd_lookup() increases sock's refcounter */
+	sock = sockfd_lookup(sockfd, &ret);
+	if (!sock) {
+		pr_debug("%s: cannot lookup peer socket (fd=%u): %d\n", __func__, sockfd, ret);
+		return -ENOTSOCK;
+	}
+
+	/* Only when using UDP as transport protocol the remote endpoint must be configured
+	 * so that ovpn-dco knows where to send packets to.
+	 *
+	 * In case of TCP, the socket is connected to the peer and ovpn-dco will just send bytes
+	 * over it, without the need to specify a destination.
+	 */
+	if (sock->sk->sk_protocol == IPPROTO_UDP) {
+		ret = -EINVAL;
+
+		if (!attrs[OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE]) {
+			pr_err("%s: cannot add UDP peer with no remote endpoint\n", __func__);
+			goto sockfd_release;
+		}
+
+		ss = nla_data(attrs[OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE]);
+		sa_len = nla_len(attrs[OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE]);
+		switch (sa_len) {
+		case sizeof(struct sockaddr_in):
+			if (ss->ss_family == AF_INET)
+				/* valid sockaddr */
+				break;
+
+			pr_err("%s: remote sockaddr_in has invalid family\n", __func__);
+			goto sockfd_release;
+		case sizeof(struct sockaddr_in6):
+			if (ss->ss_family == AF_INET6)
+				/* valid sockaddr */
+				break;
+
+			pr_err("%s: remote sockaddr_in6 has invalid family\n", __func__);
+			goto sockfd_release;
+		default:
+			pr_err("%s: invalid size for sockaddr\n", __func__);
+			goto sockfd_release;
+		}
+
+		if (ss->ss_family == AF_INET6) {
+			in6 = (struct sockaddr_in6 *)ss;
+
+			if (ipv6_addr_type(&in6->sin6_addr) & IPV6_ADDR_MAPPED) {
+				mapped.sin_family = AF_INET;
+				mapped.sin_addr.s_addr = in6->sin6_addr.s6_addr32[3];
+				mapped.sin_port = in6->sin6_port;
+				ss = (struct sockaddr_storage *)&mapped;
+			}
+		}
+
+		/* When using UDP we may be talking over socket bound to 0.0.0.0/::.
+		 * In this case, if the host has multiple IPs, we need to make sure
+		 * that outgoing traffic has as source IP the same address that the
+		 * peer is using to reach us.
+		 *
+		 * Since early control packets were all forwarded to userspace, we
+		 * need the latter to tell us what IP has to be used.
+		 */
+		if (attrs[OVPN_NEW_PEER_ATTR_LOCAL_IP]) {
+			ip_len = nla_len(attrs[OVPN_NEW_PEER_ATTR_LOCAL_IP]);
+			local_ip = nla_data(attrs[OVPN_NEW_PEER_ATTR_LOCAL_IP]);
+
+			if (ip_len == sizeof(struct in_addr)) {
+				if (ss->ss_family != AF_INET) {
+					pr_debug("%s: the specified local IP is IPv4, but the peer endpoint is not\n", __func__);
+					goto sockfd_release;
+				}
+			} else if (ip_len == sizeof(struct in6_addr)) {
+				bool is_mapped = ipv6_addr_type((struct in6_addr *)local_ip) &
+						 IPV6_ADDR_MAPPED;
+
+				if (ss->ss_family != AF_INET6 && !is_mapped) {
+					pr_debug("%s: the specified local IP is IPv6, but the peer endpoint is not\n", __func__);
+					goto sockfd_release;
+				}
+
+				if (is_mapped)
+					/* this is an IPv6-mapped IPv4 address, therefore extract
+					 * the actual v4 address from the last 4 bytes
+					 */
+					local_ip += 12;
+			} else {
+				pr_debug("%s: invalid length %zu for local IP\n", __func__, ip_len);
+				goto sockfd_release;
+			}
+		}
+
+		/* sanity checks passed */
+		ret = 0;
+	}
+
+	id = nla_get_u32(attrs[OVPN_NEW_PEER_ATTR_PEER_ID]);
+	peer = ovpn_peer_new(ovpn, ss, sock, id, local_ip);
+	if (IS_ERR(peer)) {
+		pr_err("%s: cannot create new peer object for peer %u %pIScp\n", __func__, id, ss);
+		ret = PTR_ERR(peer);
+		goto sockfd_release;
+	}
+
+	if (attrs[OVPN_NEW_PEER_ATTR_IPV4]) {
+		if (nla_len(attrs[OVPN_NEW_PEER_ATTR_IPV4]) != sizeof(struct in_addr)) {
+			ret = -EINVAL;
+			goto peer_release;
+		}
+
+		peer->vpn_addrs.ipv4.s_addr = nla_get_be32(attrs[OVPN_NEW_PEER_ATTR_IPV4]);
+	}
+
+	if (attrs[OVPN_NEW_PEER_ATTR_IPV6]) {
+		if (nla_len(attrs[OVPN_NEW_PEER_ATTR_IPV6]) != sizeof(struct in6_addr)) {
+			ret = -EINVAL;
+			goto peer_release;
+		}
+
+		memcpy(&peer->vpn_addrs.ipv6, nla_data(attrs[OVPN_NEW_PEER_ATTR_IPV6]),
+		       sizeof(struct in6_addr));
+	}
+
+	pr_debug("%s: adding peer with endpoint=%pIScp/%s id=%u VPN-IPv4=%pI4 VPN-IPv6=%pI6c\n",
+		 __func__, ss, sock->sk->sk_prot_creator->name, peer->id,
+		 &peer->vpn_addrs.ipv4.s_addr, &peer->vpn_addrs.ipv6);
+
+	ret = ovpn_peer_add(ovpn, peer);
+	if (ret < 0) {
+		pr_err("%s: cannot add new peer (id=%u) to hashtable: %d\n", __func__, peer->id,
+		       ret);
+		goto peer_release;
+	}
+
+	return 0;
+
+peer_release:
+	/* release right away because peer is not really used in any context */
+	ovpn_peer_release(peer);
+	return ret;
+
+sockfd_release:
+	sockfd_put(sock);
+	return ret;
+}
+
+static int ovpn_netlink_set_peer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_SET_PEER_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	u32 peer_id, interv, timeout;
+	bool keepalive_set = false;
+	struct ovpn_peer *peer;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_SET_PEER])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_SET_PEER_ATTR_MAX, info->attrs[OVPN_ATTR_SET_PEER], NULL,
+			       info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_SET_PEER_ATTR_PEER_ID])
+		return -EINVAL;
+
+	peer_id = nla_get_u32(attrs[OVPN_SET_PEER_ATTR_PEER_ID]);
+
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (!peer)
+		return -ENOENT;
+
+	/* when setting the keepalive, both parameters have to be configured */
+	if (attrs[OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL] &&
+	    attrs[OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT]) {
+		keepalive_set = true;
+		interv = nla_get_u32(attrs[OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL]);
+		timeout = nla_get_u32(attrs[OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT]);
+	}
+
+	if (keepalive_set)
+		ovpn_peer_keepalive_set(peer, interv, timeout);
+
+	ovpn_peer_put(peer);
+	return 0;
+}
+
+static int ovpn_netlink_send_peer(struct sk_buff *skb, const struct ovpn_peer *peer, u32 portid,
+				  u32 seq, int flags)
+{
+	const struct ovpn_bind *bind;
+	struct nlattr *attr;
+	void *hdr;
+
+	hdr = genlmsg_put(skb, portid, seq, &ovpn_netlink_family, flags, OVPN_CMD_GET_PEER);
+	if (!hdr) {
+		pr_debug("%s: cannot create message header\n", __func__);
+		return -EMSGSIZE;
+	}
+
+	attr = nla_nest_start(skb, OVPN_ATTR_GET_PEER);
+	if (!attr) {
+		pr_debug("%s: cannot create submessage\n", __func__);
+		goto err;
+	}
+
+	if (nla_put_u32(skb, OVPN_GET_PEER_RESP_ATTR_PEER_ID, peer->id))
+		goto err;
+
+	if (peer->vpn_addrs.ipv4.s_addr != htonl(INADDR_ANY))
+		if (nla_put(skb, OVPN_GET_PEER_RESP_ATTR_IPV4, sizeof(peer->vpn_addrs.ipv4),
+			    &peer->vpn_addrs.ipv4))
+			goto err;
+
+	if (memcmp(&peer->vpn_addrs.ipv6, &in6addr_any, sizeof(peer->vpn_addrs.ipv6)))
+		if (nla_put(skb, OVPN_GET_PEER_RESP_ATTR_IPV6, sizeof(peer->vpn_addrs.ipv6),
+			    &peer->vpn_addrs.ipv6))
+			goto err;
+
+	if (nla_put_u32(skb, OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_INTERVAL,
+			peer->keepalive_interval) ||
+	    nla_put_u32(skb, OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_TIMEOUT,
+			peer->keepalive_timeout))
+		goto err;
+
+	rcu_read_lock();
+	bind = rcu_dereference(peer->bind);
+	if (bind) {
+		if (bind->sa.in4.sin_family == AF_INET) {
+			if (nla_put(skb, OVPN_GET_PEER_RESP_ATTR_SOCKADDR_REMOTE,
+				    sizeof(bind->sa.in4), &bind->sa.in4) ||
+			    nla_put(skb, OVPN_GET_PEER_RESP_ATTR_LOCAL_IP,
+				    sizeof(bind->local.ipv4), &bind->local.ipv4))
+				goto err_unlock;
+		} else if (bind->sa.in4.sin_family == AF_INET6) {
+			if (nla_put(skb, OVPN_GET_PEER_RESP_ATTR_SOCKADDR_REMOTE,
+				    sizeof(bind->sa.in6), &bind->sa.in6) ||
+			    nla_put(skb, OVPN_GET_PEER_RESP_ATTR_LOCAL_IP,
+				    sizeof(bind->local.ipv6), &bind->local.ipv6))
+				goto err_unlock;
+		}
+	}
+	rcu_read_unlock();
+
+	if (nla_put_net16(skb, OVPN_GET_PEER_RESP_ATTR_LOCAL_PORT,
+			  inet_sk(peer->sock->sock->sk)->inet_sport) ||
+	    /* RX stats */
+	    nla_put_u64_64bit(skb, OVPN_GET_PEER_RESP_ATTR_RX_BYTES,
+			      atomic64_read(&peer->stats.rx.bytes),
+			      OVPN_GET_PEER_RESP_ATTR_UNSPEC) ||
+	    nla_put_u32(skb, OVPN_GET_PEER_RESP_ATTR_RX_PACKETS,
+			atomic_read(&peer->stats.rx.packets)) ||
+	    /* TX stats */
+	    nla_put_u64_64bit(skb, OVPN_GET_PEER_RESP_ATTR_TX_BYTES,
+			      atomic64_read(&peer->stats.tx.bytes),
+			      OVPN_GET_PEER_RESP_ATTR_UNSPEC) ||
+	    nla_put_u32(skb, OVPN_GET_PEER_RESP_ATTR_TX_PACKETS,
+			atomic_read(&peer->stats.tx.packets)))
+		goto err;
+
+	nla_nest_end(skb, attr);
+	genlmsg_end(skb, hdr);
+
+	return 0;
+err_unlock:
+	rcu_read_unlock();
+err:
+	genlmsg_cancel(skb, hdr);
+	return -EMSGSIZE;
+}
+
+static int ovpn_netlink_get_peer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_SET_PEER_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	struct ovpn_peer *peer;
+	struct sk_buff *msg;
+	u32 peer_id;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_GET_PEER])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_GET_PEER_ATTR_MAX, info->attrs[OVPN_ATTR_GET_PEER], NULL,
+			       info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_GET_PEER_ATTR_PEER_ID])
+		return -EINVAL;
+
+	peer_id = nla_get_u32(attrs[OVPN_GET_PEER_ATTR_PEER_ID]);
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (!peer)
+		return -ENOENT;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = ovpn_netlink_send_peer(msg, peer, info->snd_portid, info->snd_seq, 0);
+	if (ret < 0) {
+		nlmsg_free(msg);
+		goto err;
+	}
+
+	ret = genlmsg_reply(msg, info);
+err:
+	ovpn_peer_put(peer);
+	return ret;
+}
+
+static int ovpn_netlink_dump_done(struct netlink_callback *cb)
+{
+	struct ovpn_struct *ovpn = (struct ovpn_struct *)cb->args[0];
+
+	dev_put(ovpn->dev);
+	return 0;
+}
+
+static int ovpn_netlink_dump_prepare(struct netlink_callback *cb)
+{
+	struct net *netns = sock_net(cb->skb->sk);
+	struct nlattr **attrbuf;
+	struct net_device *dev;
+	int ret;
+
+	attrbuf = kcalloc(OVPN_ATTR_MAX + 1, sizeof(*attrbuf), GFP_KERNEL);
+	if (!attrbuf)
+		return -ENOMEM;
+
+	ret = nlmsg_parse_deprecated(cb->nlh, GENL_HDRLEN, attrbuf, OVPN_ATTR_MAX,
+				     ovpn_netlink_policy, NULL);
+	if (ret < 0)
+		goto err;
+
+	dev = ovpn_get_dev_from_attrs(netns, attrbuf);
+	if (IS_ERR(dev)) {
+		ret = PTR_ERR(dev);
+		goto err;
+	}
+
+	cb->args[0] = (long)netdev_priv(dev);
+	ret = 0;
+err:
+	kfree(attrbuf);
+	return ret;
+}
+
+static int ovpn_netlink_dump_peers(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct ovpn_struct *ovpn = (struct ovpn_struct *)cb->args[0];
+	int ret, bkt, last_idx = cb->args[1], dumped = 0;
+	struct ovpn_peer *peer;
+
+	if (!ovpn) {
+		ret = ovpn_netlink_dump_prepare(cb);
+		if (ret < 0) {
+			pr_debug("%s: cannot prepare for dump: %d\n", __func__, ret);
+			return ret;
+		}
+
+		ovpn = (struct ovpn_struct *)cb->args[0];
+	}
+
+	rcu_read_lock();
+	hash_for_each_rcu(ovpn->peers.by_id, bkt, peer, hash_entry_id) {
+		/* skip already dumped peers that were dumped by previous invocations */
+		if (last_idx > 0) {
+			last_idx--;
+			continue;
+		}
+
+		if (ovpn_netlink_send_peer(skb, peer, NETLINK_CB(cb->skb).portid,
+					   cb->nlh->nlmsg_seq, NLM_F_MULTI) < 0)
+			break;
+
+		/* count peers being dumped during this invocation */
+		dumped++;
+	}
+	rcu_read_unlock();
+
+	/* sum up peers dumped in this message, so that at the next invocation
+	 * we can continue from where we left
+	 */
+	cb->args[1] += dumped;
+
+	return skb->len;
+}
+
+static int ovpn_netlink_del_peer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_SET_PEER_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	struct ovpn_peer *peer;
+	u32 peer_id;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_DEL_PEER])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_DEL_PEER_ATTR_MAX, info->attrs[OVPN_ATTR_DEL_PEER], NULL,
+			       info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_DEL_PEER_ATTR_PEER_ID])
+		return -EINVAL;
+
+	peer_id = nla_get_u32(attrs[OVPN_DEL_PEER_ATTR_PEER_ID]);
+
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (!peer)
+		return -ENOENT;
+
+	pr_debug("%s: peer id=%u\n", __func__, peer->id);
+	ret = ovpn_peer_del(peer, OVPN_DEL_PEER_REASON_USERSPACE);
+	ovpn_peer_put(peer);
+
+	return ret;
+}
+
+static int ovpn_netlink_register_packet(struct sk_buff *skb,
+					struct genl_info *info)
+{
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+
+	/* only one registered process per interface is allowed for now */
+	if (ovpn->registered_nl_portid_set) {
+		pr_debug("%s: userspace listener already registered\n",
+			 __func__);
+		return -EBUSY;
+	}
+
+	pr_debug("%s: registering userspace at %u\n", __func__,
+		 info->snd_portid);
+
+	ovpn->registered_nl_portid = info->snd_portid;
+	ovpn->registered_nl_portid_set = true;
+
+	return 0;
+}
+
+static int ovpn_netlink_packet(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *attrs[OVPN_PACKET_ATTR_MAX + 1];
+	struct ovpn_struct *ovpn = info->user_ptr[0];
+	const u8 *packet;
+	u32 peer_id;
+	size_t len;
+	u8 opcode;
+	int ret;
+
+	if (!info->attrs[OVPN_ATTR_PACKET])
+		return -EINVAL;
+
+	ret = nla_parse_nested(attrs, OVPN_PACKET_ATTR_MAX, info->attrs[OVPN_ATTR_PACKET],
+			       NULL, info->extack);
+	if (ret)
+		return ret;
+
+	if (!attrs[OVPN_PACKET_ATTR_PACKET] || !attrs[OVPN_PACKET_ATTR_PEER_ID]) {
+		pr_debug("received netlink packet with no payload\n");
+		return -EINVAL;
+	}
+
+	peer_id = nla_get_u32(attrs[OVPN_PACKET_ATTR_PEER_ID]);
+
+	len = nla_len(attrs[OVPN_PACKET_ATTR_PACKET]);
+
+	if (len < 4 || len > ovpn->dev->mtu) {
+		pr_debug("%s: invalid packet size %zu (min is 4, max is MTU: %u)\n", __func__, len,
+			 ovpn->dev->mtu);
+		return -EINVAL;
+	}
+
+	packet = nla_data(attrs[OVPN_PACKET_ATTR_PACKET]);
+	opcode = ovpn_opcode_from_byte(packet[0]);
+
+	/* reject data packets from userspace as they could lead to IV reuse */
+	if (opcode == OVPN_DATA_V1 || opcode == OVPN_DATA_V2) {
+		pr_debug("%s: rejecting data packet from userspace (opcode=%u)\n", __func__,
+			 opcode);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: sending userspace packet to peer %u...\n", __func__, peer_id);
+
+	return ovpn_send_data(ovpn, peer_id, packet, len);
+}
+
+static const struct genl_ops ovpn_netlink_ops[] = {
+	{
+		.cmd = OVPN_CMD_NEW_PEER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_new_peer,
+	},
+	{
+		.cmd = OVPN_CMD_SET_PEER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_set_peer,
+	},
+	{
+		.cmd = OVPN_CMD_DEL_PEER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_del_peer,
+	},
+	{
+		.cmd = OVPN_CMD_GET_PEER,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_get_peer,
+		.dumpit = ovpn_netlink_dump_peers,
+		.done = ovpn_netlink_dump_done,
+	},
+	{
+		.cmd = OVPN_CMD_NEW_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_new_key,
+	},
+	{
+		.cmd = OVPN_CMD_DEL_KEY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_del_key,
+	},
+	{
+		.cmd = OVPN_CMD_SWAP_KEYS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_swap_keys,
+	},
+	{
+		.cmd = OVPN_CMD_REGISTER_PACKET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_register_packet,
+	},
+	{
+		.cmd = OVPN_CMD_PACKET,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = GENL_ADMIN_PERM,
+		.doit = ovpn_netlink_packet,
+	},
+};
+
+static struct genl_family ovpn_netlink_family __ro_after_init = {
+	.hdrsize = 0,
+	.name = OVPN_NL_NAME,
+	.version = 1,
+	.maxattr = OVPN_ATTR_MAX,
+	.policy = ovpn_netlink_policy,
+	.netnsok = true,
+	.pre_doit = ovpn_pre_doit,
+	.post_doit = ovpn_post_doit,
+	.module = THIS_MODULE,
+	.ops = ovpn_netlink_ops,
+	.n_ops = ARRAY_SIZE(ovpn_netlink_ops),
+	.mcgrps = ovpn_netlink_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(ovpn_netlink_mcgrps),
+};
+
+int ovpn_netlink_notify_del_peer(struct ovpn_peer *peer)
+{
+	struct sk_buff *msg;
+	struct nlattr *attr;
+	void *hdr;
+	int ret;
+
+	pr_info("%s: deleting peer with id %u, reason %d\n", peer->ovpn->dev->name,
+		peer->id, peer->delete_reason);
+
+	msg = nlmsg_new(100, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &ovpn_netlink_family, 0,
+			  OVPN_CMD_DEL_PEER);
+	if (!hdr) {
+		ret = -ENOBUFS;
+		goto err_free_msg;
+	}
+
+	if (nla_put_u32(msg, OVPN_ATTR_IFINDEX, peer->ovpn->dev->ifindex)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	attr = nla_nest_start(msg, OVPN_ATTR_DEL_PEER);
+	if (!attr) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	if (nla_put_u8(msg, OVPN_DEL_PEER_ATTR_REASON, peer->delete_reason)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	if (nla_put_u32(msg, OVPN_DEL_PEER_ATTR_PEER_ID, peer->id)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	nla_nest_end(msg, attr);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&ovpn_netlink_family, dev_net(peer->ovpn->dev),
+				msg, 0, OVPN_MCGRP_PEERS, GFP_KERNEL);
+
+	return 0;
+
+err_free_msg:
+	nlmsg_free(msg);
+	return ret;
+}
+
+int ovpn_netlink_send_packet(struct ovpn_struct *ovpn, const struct ovpn_peer *peer,
+			     const u8 *buf, size_t len)
+{
+	struct nlattr *attr;
+	struct sk_buff *msg;
+	void *hdr;
+	int ret;
+
+	if (!ovpn->registered_nl_portid_set) {
+		pr_warn_ratelimited("%s: no userspace listener\n", __func__);
+		return 0;
+	}
+
+	pr_debug("%s: sending packet to userspace, len: %zd\n", __func__, len);
+
+	msg = nlmsg_new(100 + len, GFP_ATOMIC);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = genlmsg_put(msg, 0, 0, &ovpn_netlink_family, 0,
+			  OVPN_CMD_PACKET);
+	if (!hdr) {
+		ret = -ENOBUFS;
+		goto err_free_msg;
+	}
+
+	if (nla_put_u32(msg, OVPN_ATTR_IFINDEX, ovpn->dev->ifindex)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	attr = nla_nest_start(msg, OVPN_ATTR_PACKET);
+	if (!attr) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	if (nla_put(msg, OVPN_PACKET_ATTR_PACKET, len, buf)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	if (nla_put_u32(msg, OVPN_PACKET_ATTR_PEER_ID, peer->id)) {
+		ret = -EMSGSIZE;
+		goto err_free_msg;
+	}
+
+	nla_nest_end(msg, attr);
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_unicast(dev_net(ovpn->dev), msg,
+			       ovpn->registered_nl_portid);
+
+err_free_msg:
+	nlmsg_free(msg);
+	return ret;
+}
+
+static int ovpn_netlink_notify(struct notifier_block *nb, unsigned long state,
+			       void *_notify)
+{
+	struct netlink_notify *notify = _notify;
+	struct ovpn_struct *ovpn;
+	struct net_device *dev;
+	struct net *netns;
+	bool found = false;
+
+	if (state != NETLINK_URELEASE || notify->protocol != NETLINK_GENERIC)
+		return NOTIFY_DONE;
+
+	rcu_read_lock();
+	for_each_net_rcu(netns) {
+		for_each_netdev_rcu(netns, dev) {
+			if (!ovpn_dev_is_valid(dev))
+				continue;
+
+			ovpn = netdev_priv(dev);
+			if (notify->portid != ovpn->registered_nl_portid)
+				continue;
+
+			found = true;
+			pr_debug("%s: deregistering userspace listener\n",
+				 __func__);
+			ovpn->registered_nl_portid_set = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	/* if no interface matched our purposes, pass the notification along */
+	if (!found)
+		return NOTIFY_DONE;
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block ovpn_netlink_notifier = {
+	.notifier_call = ovpn_netlink_notify,
+};
+
+int ovpn_netlink_init(struct ovpn_struct *ovpn)
+{
+	ovpn->registered_nl_portid_set = false;
+
+	return 0;
+}
+
+/**
+ * ovpn_netlink_register() - register the ovpn genl netlink family
+ */
+int __init ovpn_netlink_register(void)
+{
+	int ret;
+
+	ret = genl_register_family(&ovpn_netlink_family);
+	if (ret)
+		return ret;
+
+	ret = netlink_register_notifier(&ovpn_netlink_notifier);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	genl_unregister_family(&ovpn_netlink_family);
+	return ret;
+}
+
+/**
+ * ovpn_netlink_unregister() - unregister the ovpn genl netlink family
+ */
+void __exit ovpn_netlink_unregister(void)
+{
+	netlink_unregister_notifier(&ovpn_netlink_notifier);
+	genl_unregister_family(&ovpn_netlink_family);
+}
diff --git a/drivers/net/ovpn-dco/netlink.h b/drivers/net/ovpn-dco/netlink.h
new file mode 100644
index 000000000000..843daf052c03
--- /dev/null
+++ b/drivers/net/ovpn-dco/netlink.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_NETLINK_H_
+#define _NET_OVPN_DCO_NETLINK_H_
+
+struct ovpn_struct;
+struct ovpn_peer;
+
+int ovpn_netlink_init(struct ovpn_struct *ovpn);
+int ovpn_netlink_register(void);
+void ovpn_netlink_unregister(void);
+int ovpn_netlink_send_packet(struct ovpn_struct *ovpn, const struct ovpn_peer *peer,
+			     const u8 *buf, size_t len);
+int ovpn_netlink_notify_del_peer(struct ovpn_peer *peer);
+
+#endif /* _NET_OVPN_DCO_NETLINK_H_ */
diff --git a/drivers/net/ovpn-dco/ovpn.c b/drivers/net/ovpn-dco/ovpn.c
new file mode 100644
index 000000000000..c2cc247a13da
--- /dev/null
+++ b/drivers/net/ovpn-dco/ovpn.c
@@ -0,0 +1,597 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "bind.h"
+#include "netlink.h"
+#include "ovpn.h"
+#include "sock.h"
+#include "peer.h"
+#include "stats.h"
+#include "proto.h"
+#include "crypto.h"
+#include "crypto_aead.h"
+#include "skb.h"
+#include "tcp.h"
+#include "udp.h"
+
+#include <linux/workqueue.h>
+#include <uapi/linux/if_ether.h>
+
+static const unsigned char ovpn_keepalive_message[] = {
+	0x2a, 0x18, 0x7b, 0xf3, 0x64, 0x1e, 0xb4, 0xcb,
+	0x07, 0xed, 0x2d, 0x0a, 0x98, 0x1f, 0xc7, 0x48
+};
+
+static const unsigned char ovpn_explicit_exit_notify_message[] = {
+	0x28, 0x7f, 0x34, 0x6b, 0xd4, 0xef, 0x7a, 0x81,
+	0x2d, 0x56, 0xb8, 0xd3, 0xaf, 0xc5, 0x45, 0x9c,
+	6 // OCC_EXIT
+};
+
+/* Is keepalive message?
+ * Assumes that single byte at skb->data is defined.
+ */
+static bool ovpn_is_keepalive(struct sk_buff *skb)
+{
+	if (*skb->data != OVPN_KEEPALIVE_FIRST_BYTE)
+		return false;
+
+	if (!pskb_may_pull(skb, sizeof(ovpn_keepalive_message)))
+		return false;
+
+	return !memcmp(skb->data, ovpn_keepalive_message,
+		       sizeof(ovpn_keepalive_message));
+}
+
+int ovpn_struct_init(struct net_device *dev)
+{
+	struct ovpn_struct *ovpn = netdev_priv(dev);
+	int err;
+
+	memset(ovpn, 0, sizeof(*ovpn));
+
+	ovpn->dev = dev;
+
+	err = ovpn_netlink_init(ovpn);
+	if (err < 0)
+		return err;
+
+	spin_lock_init(&ovpn->lock);
+	spin_lock_init(&ovpn->peers.lock);
+
+	ovpn->crypto_wq = alloc_workqueue("ovpn-crypto-wq-%s",
+					  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0,
+					  dev->name);
+	if (!ovpn->crypto_wq)
+		return -ENOMEM;
+
+	ovpn->events_wq = alloc_workqueue("ovpn-event-wq-%s", WQ_MEM_RECLAIM, 0, dev->name);
+	if (!ovpn->events_wq)
+		return -ENOMEM;
+
+	dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!dev->tstats)
+		return -ENOMEM;
+
+	err = security_tun_dev_alloc_security(&ovpn->security);
+	if (err < 0)
+		return err;
+
+	/* kernel -> userspace tun queue length */
+	ovpn->max_tun_queue_len = OVPN_MAX_TUN_QUEUE_LEN;
+
+	return 0;
+}
+
+/* Called after decrypt to write IP packet to tun netdev.
+ * This method is expected to manage/free skb.
+ */
+static void tun_netdev_write(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	/* packet integrity was verified on the VPN layer - no need to perform
+	 * any additional check along the stack
+	 */
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->csum_level = ~0;
+
+	/* skb hash for transport packet no longer valid after decapsulation */
+	skb_clear_hash(skb);
+
+	/* post-decrypt scrub -- prepare to inject encapsulated packet onto tun
+	 * interface, based on __skb_tunnel_rx() in dst.h
+	 */
+	skb->dev = peer->ovpn->dev;
+	skb_set_queue_mapping(skb, 0);
+	skb_scrub_packet(skb, true);
+
+	skb_reset_network_header(skb);
+	skb_reset_transport_header(skb);
+	skb_probe_transport_header(skb);
+	skb_reset_inner_headers(skb);
+
+	/* update per-cpu RX stats with the stored size of encrypted packet */
+
+	/* we are in softirq context - hence no locking nor disable preemption needed */
+	dev_sw_netstats_rx_add(peer->ovpn->dev, OVPN_SKB_CB(skb)->rx_stats_size);
+
+	/* cause packet to be "received" by tun interface */
+	napi_gro_receive(&peer->napi, skb);
+}
+
+int ovpn_napi_poll(struct napi_struct *napi, int budget)
+{
+	struct ovpn_peer *peer = container_of(napi, struct ovpn_peer, napi);
+	struct sk_buff *skb;
+	int work_done = 0;
+
+	if (unlikely(budget <= 0))
+		return 0;
+	/* this function should schedule at most 'budget' number of
+	 * packets for delivery to the tun interface.
+	 * If in the queue we have more packets than what allowed by the
+	 * budget, the next polling will take care of those
+	 */
+	while ((work_done < budget) &&
+	       (skb = ptr_ring_consume_bh(&peer->netif_rx_ring))) {
+		tun_netdev_write(peer, skb);
+		work_done++;
+	}
+
+	if (work_done < budget)
+		napi_complete_done(napi, work_done);
+
+	return work_done;
+}
+
+static int ovpn_transport_to_userspace(struct ovpn_struct *ovpn, const struct ovpn_peer *peer,
+				       struct sk_buff *skb)
+{
+	int ret;
+
+	ret = skb_linearize(skb);
+	if (ret < 0)
+		return ret;
+
+	ret = ovpn_netlink_send_packet(ovpn, peer, skb->data, skb->len);
+	if (ret < 0)
+		return ret;
+
+	consume_skb(skb);
+	return 0;
+}
+
+/* Entry point for processing an incoming packet (in skb form)
+ *
+ * Enqueue the packet and schedule RX consumer.
+ * Reference to peer is dropped only in case of success.
+ *
+ * Return 0  if the packet was handled (and consumed)
+ * Return <0 in case of error (return value is error code)
+ */
+int ovpn_recv(struct ovpn_struct *ovpn, struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	int ret;
+
+	/* At this point we know the packet is from a configured peer.
+	 * DATA_V2 packets are handled in kernel space, the rest goes to user space.
+	 *
+	 * Packets are sent to userspace via netlink API in order to be consistenbt across
+	 * UDP and TCP.
+	 */
+	if (unlikely(ovpn_opcode_from_skb(skb, 0) != OVPN_DATA_V2)) {
+		ret = ovpn_transport_to_userspace(ovpn, peer, skb);
+		if (ret < 0)
+			return ret;
+
+		ovpn_peer_put(peer);
+		return 0;
+	}
+
+	ret = ptr_ring_produce_bh(&peer->rx_ring, skb);
+	if (unlikely(ret < 0))
+		return -ENOSPC;
+
+	if (!queue_work(ovpn->crypto_wq, &peer->decrypt_work))
+		ovpn_peer_put(peer);
+
+	return 0;
+}
+
+static int ovpn_decrypt_one(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	struct ovpn_peer *allowed_peer = NULL;
+	struct ovpn_crypto_key_slot *ks;
+	unsigned int rx_stats_size;
+	__be16 proto;
+	int ret = -1;
+	u8 key_id;
+
+	/* save original packet size for stats accounting */
+	OVPN_SKB_CB(skb)->rx_stats_size = skb->len;
+
+	/* get the key slot matching the key Id in the received packet */
+	key_id = ovpn_key_id_from_skb(skb);
+	ks = ovpn_crypto_key_id_to_slot(&peer->crypto, key_id);
+	if (unlikely(!ks)) {
+		pr_info_ratelimited("%s: no available key for peer %u, key-id: %u\n", __func__,
+				    peer->id, key_id);
+		goto drop;
+	}
+
+	/* decrypt */
+	ret = ovpn_aead_decrypt(ks, skb);
+
+	ovpn_crypto_key_slot_put(ks);
+
+	if (unlikely(ret < 0)) {
+		pr_err_ratelimited("%s: error during decryption for peer %u, key-id %u: %d\n",
+				   __func__, peer->id, key_id, ret);
+		goto drop;
+	}
+
+	/* note event of authenticated packet received for keepalive */
+	ovpn_peer_keepalive_recv_reset(peer);
+
+	/* update source and destination endpoint for this peer */
+	if (peer->sock->sock->sk->sk_protocol == IPPROTO_UDP)
+		ovpn_peer_update_local_endpoint(peer, skb);
+
+	/* increment RX stats */
+	rx_stats_size = OVPN_SKB_CB(skb)->rx_stats_size;
+	ovpn_peer_stats_increment_rx(&peer->stats, rx_stats_size);
+
+	/* check if this is a valid datapacket that has to be delivered to the
+	 * tun interface
+	 */
+	skb_reset_network_header(skb);
+	proto = ovpn_ip_check_protocol(skb);
+	if (unlikely(!proto)) {
+		/* check if null packet */
+		if (unlikely(!pskb_may_pull(skb, 1))) {
+			ret = -EINVAL;
+			goto drop;
+		}
+
+		/* check if special OpenVPN message */
+		if (ovpn_is_keepalive(skb)) {
+			pr_debug("%s: ping received from peer with id %u\n", __func__, peer->id);
+			/* not an error */
+			consume_skb(skb);
+			/* inform the caller that NAPI should not be scheduled
+			 * for this packet
+			 */
+			return -1;
+		}
+
+		ret = -EPROTONOSUPPORT;
+		goto drop;
+	}
+	skb->protocol = proto;
+
+	/* perform Reverse Path Filtering (RPF) */
+	allowed_peer = ovpn_peer_lookup_vpn_addr(peer->ovpn, skb, true);
+	if (unlikely(allowed_peer != peer)) {
+		ret = -EPERM;
+		goto drop;
+	}
+
+	ret = ptr_ring_produce_bh(&peer->netif_rx_ring, skb);
+drop:
+	if (likely(allowed_peer))
+		ovpn_peer_put(allowed_peer);
+
+	if (unlikely(ret < 0))
+		kfree_skb(skb);
+
+	return ret;
+}
+
+/* pick packet from RX queue, decrypt and forward it to the tun device */
+void ovpn_decrypt_work(struct work_struct *work)
+{
+	struct ovpn_peer *peer;
+	struct sk_buff *skb;
+
+	peer = container_of(work, struct ovpn_peer, decrypt_work);
+	while ((skb = ptr_ring_consume_bh(&peer->rx_ring))) {
+		if (likely(ovpn_decrypt_one(peer, skb) == 0)) {
+			/* if a packet has been enqueued for NAPI, signal
+			 * availability to the networking stack
+			 */
+			local_bh_disable();
+			napi_schedule(&peer->napi);
+			local_bh_enable();
+		}
+
+		/* give a chance to be rescheduled if needed */
+		cond_resched();
+	}
+	ovpn_peer_put(peer);
+}
+
+static bool ovpn_encrypt_one(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	struct ovpn_crypto_key_slot *ks;
+	bool success = false;
+	int ret;
+
+	/* get primary key to be used for encrypting data */
+	ks = ovpn_crypto_key_slot_primary(&peer->crypto);
+	if (unlikely(!ks)) {
+		pr_info_ratelimited("%s: error while retrieving primary key slot\n", __func__);
+		return false;
+	}
+
+	if (unlikely(skb->ip_summed == CHECKSUM_PARTIAL &&
+		     skb_checksum_help(skb))) {
+		pr_err_ratelimited("%s: cannot compute checksum for outgoing packet\n", __func__);
+		goto err;
+	}
+
+	ovpn_peer_stats_increment_tx(&peer->stats, skb->len);
+
+	/* encrypt */
+	ret = ovpn_aead_encrypt(ks, skb, peer->id);
+	if (unlikely(ret < 0)) {
+		/* if we ran out of IVs we must kill the key as it can't be used anymore */
+		if (ret == -ERANGE) {
+			pr_warn("%s: killing primary key as we ran out of IVs\n", __func__);
+			ovpn_crypto_kill_primary(&peer->crypto);
+			goto err;
+		}
+		pr_err_ratelimited("%s: error during encryption for peer %u, key-id %u: %d\n",
+				   __func__, peer->id, ks->key_id, ret);
+		goto err;
+	}
+
+	success = true;
+err:
+	ovpn_crypto_key_slot_put(ks);
+	return success;
+}
+
+/* Process packets in TX queue in a transport-specific way.
+ *
+ * UDP transport - encrypt and send across the tunnel.
+ * TCP transport - encrypt and put into TCP TX queue.
+ */
+void ovpn_encrypt_work(struct work_struct *work)
+{
+	struct sk_buff *skb, *curr, *next;
+	struct ovpn_peer *peer;
+
+	peer = container_of(work, struct ovpn_peer, encrypt_work);
+	while ((skb = ptr_ring_consume_bh(&peer->tx_ring))) {
+		/* this might be a GSO-segmented skb list: process each skb
+		 * independently
+		 */
+		skb_list_walk_safe(skb, curr, next) {
+			/* if one segment fails encryption, we drop the entire
+			 * packet, because it does not really make sense to send
+			 * only part of it at this point
+			 */
+			if (unlikely(!ovpn_encrypt_one(peer, curr))) {
+				kfree_skb_list(skb);
+				skb = NULL;
+				break;
+			}
+		}
+
+		/* successful encryption */
+		if (skb) {
+			skb_list_walk_safe(skb, curr, next) {
+				skb_mark_not_on_list(curr);
+
+				switch (peer->sock->sock->sk->sk_protocol) {
+				case IPPROTO_UDP:
+					ovpn_udp_send_skb(peer->ovpn, peer, curr);
+					break;
+				case IPPROTO_TCP:
+					ovpn_tcp_send_skb(peer, curr);
+					break;
+				default:
+					/* no transport configured yet */
+					consume_skb(skb);
+					break;
+				}
+			}
+
+			/* note event of authenticated packet xmit for keepalive */
+			ovpn_peer_keepalive_xmit_reset(peer);
+		}
+
+		/* give a chance to be rescheduled if needed */
+		cond_resched();
+	}
+	ovpn_peer_put(peer);
+}
+
+/* Put skb into TX queue and schedule a consumer */
+static void ovpn_queue_skb(struct ovpn_struct *ovpn, struct sk_buff *skb, struct ovpn_peer *peer)
+{
+	int ret;
+
+	if (likely(!peer))
+		peer = ovpn_peer_lookup_vpn_addr(ovpn, skb, false);
+	if (unlikely(!peer)) {
+		net_dbg_ratelimited("%s: no peer to send data to\n", ovpn->dev->name);
+		goto drop;
+	}
+
+	ret = ptr_ring_produce_bh(&peer->tx_ring, skb);
+	if (unlikely(ret < 0)) {
+		pr_err_ratelimited("%s: cannot queue packet to TX ring\n", __func__);
+		goto drop;
+	}
+
+	if (!queue_work(ovpn->crypto_wq, &peer->encrypt_work))
+		ovpn_peer_put(peer);
+
+	return;
+drop:
+	if (peer)
+		ovpn_peer_put(peer);
+	kfree_skb_list(skb);
+}
+
+/* Net device start xmit
+ */
+netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ovpn_struct *ovpn = netdev_priv(dev);
+	struct sk_buff *segments, *tmp, *curr, *next;
+	struct sk_buff_head skb_list;
+	__be16 proto;
+	int ret;
+
+	/* reset netfilter state */
+	nf_reset_ct(skb);
+
+	/* verify IP header size in network packet */
+	proto = ovpn_ip_check_protocol(skb);
+	if (unlikely(!proto || skb->protocol != proto)) {
+		net_dbg_ratelimited("%s: dropping malformed payload packet\n",
+				    dev->name);
+		goto drop;
+	}
+
+	if (skb_is_gso(skb)) {
+		segments = skb_gso_segment(skb, 0);
+		if (IS_ERR(segments)) {
+			ret = PTR_ERR(segments);
+			net_dbg_ratelimited("%s: cannot segment packet: %d\n", dev->name, ret);
+			goto drop;
+		}
+
+		consume_skb(skb);
+		skb = segments;
+	}
+
+	/* from this moment on, "skb" might be a list */
+
+	__skb_queue_head_init(&skb_list);
+	skb_list_walk_safe(skb, curr, next) {
+		skb_mark_not_on_list(curr);
+
+		tmp = skb_share_check(curr, GFP_ATOMIC);
+		if (unlikely(!tmp)) {
+			kfree_skb_list(next);
+			net_dbg_ratelimited("%s: skb_share_check failed\n", dev->name);
+			goto drop_list;
+		}
+
+		__skb_queue_tail(&skb_list, tmp);
+	}
+	skb_list.prev->next = NULL;
+
+	ovpn_queue_skb(ovpn, skb_list.next, NULL);
+
+	return NETDEV_TX_OK;
+
+drop_list:
+	skb_queue_walk_safe(&skb_list, curr, next)
+		kfree_skb(curr);
+drop:
+	skb_tx_error(skb);
+	kfree_skb_list(skb);
+	return NET_XMIT_DROP;
+}
+
+/* Encrypt and transmit a special message to peer, such as keepalive
+ * or explicit-exit-notify.  Called from softirq context.
+ * Assumes that caller holds a reference to peer.
+ */
+static void ovpn_xmit_special(struct ovpn_peer *peer, const void *data,
+			      const unsigned int len)
+{
+	struct ovpn_struct *ovpn;
+	struct sk_buff *skb;
+
+	ovpn = peer->ovpn;
+	if (unlikely(!ovpn))
+		return;
+
+	skb = alloc_skb(256 + len, GFP_ATOMIC);
+	if (unlikely(!skb))
+		return;
+
+	skb_reserve(skb, 128);
+	skb->priority = TC_PRIO_BESTEFFORT;
+	memcpy(__skb_put(skb, len), data, len);
+
+	/* increase reference counter when passing peer to sending queue */
+	if (!ovpn_peer_hold(peer)) {
+		pr_debug("%s: cannot hold peer reference for sending special packet\n", __func__);
+		kfree_skb(skb);
+		return;
+	}
+
+	ovpn_queue_skb(ovpn, skb, peer);
+}
+
+void ovpn_keepalive_xmit(struct ovpn_peer *peer)
+{
+	ovpn_xmit_special(peer, ovpn_keepalive_message,
+			  sizeof(ovpn_keepalive_message));
+}
+
+/* Transmit explicit exit notification.
+ * Called from process context.
+ */
+void ovpn_explicit_exit_notify_xmit(struct ovpn_peer *peer)
+{
+	ovpn_xmit_special(peer, ovpn_explicit_exit_notify_message,
+			  sizeof(ovpn_explicit_exit_notify_message));
+}
+
+/* Copy buffer into skb and send it across the tunnel.
+ *
+ * For UDP transport: just sent the skb to peer
+ * For TCP transport: put skb into TX queue
+ */
+int ovpn_send_data(struct ovpn_struct *ovpn, u32 peer_id, const u8 *data, size_t len)
+{
+	u16 skb_len = SKB_HEADER_LEN + len;
+	struct ovpn_peer *peer;
+	struct sk_buff *skb;
+	bool tcp = false;
+	int ret = 0;
+
+	peer = ovpn_peer_lookup_id(ovpn, peer_id);
+	if (unlikely(!peer)) {
+		pr_debug("no peer to send data to\n");
+		return -EHOSTUNREACH;
+	}
+
+	if (peer->sock->sock->sk->sk_protocol == IPPROTO_TCP) {
+		skb_len += sizeof(u16);
+		tcp = true;
+	}
+
+	skb = alloc_skb(skb_len, GFP_ATOMIC);
+	if (unlikely(!skb)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skb_reserve(skb, SKB_HEADER_LEN);
+	skb_put_data(skb, data, len);
+
+	/* prepend TCP packet with size, as required by OpenVPN protocol */
+	if (tcp) {
+		*(__be16 *)__skb_push(skb, sizeof(u16)) = htons(len);
+		ovpn_queue_tcp_skb(peer, skb);
+	} else {
+		ovpn_udp_send_skb(ovpn, peer, skb);
+	}
+out:
+	ovpn_peer_put(peer);
+	return ret;
+}
diff --git a/drivers/net/ovpn-dco/ovpn.h b/drivers/net/ovpn-dco/ovpn.h
new file mode 100644
index 000000000000..9364fd5dd309
--- /dev/null
+++ b/drivers/net/ovpn-dco/ovpn.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPN_H_
+#define _NET_OVPN_DCO_OVPN_H_
+
+#include "main.h"
+#include "peer.h"
+#include "sock.h"
+#include "ovpnstruct.h"
+
+#include <linux/workqueue.h>
+#include <linux/types.h>
+#include <net/sock.h>
+
+struct ovpn_struct;
+struct net_device;
+
+int ovpn_struct_init(struct net_device *dev);
+
+u16 ovpn_select_queue(struct net_device *dev, struct sk_buff *skb,
+		      struct net_device *sb_dev);
+
+void ovpn_keepalive_xmit(struct ovpn_peer *peer);
+void ovpn_explicit_exit_notify_xmit(struct ovpn_peer *peer);
+
+netdev_tx_t ovpn_net_xmit(struct sk_buff *skb, struct net_device *dev);
+
+int ovpn_recv(struct ovpn_struct *ovpn, struct ovpn_peer *peer, struct sk_buff *skb);
+
+void ovpn_encrypt_work(struct work_struct *work);
+void ovpn_decrypt_work(struct work_struct *work);
+int ovpn_napi_poll(struct napi_struct *napi, int budget);
+
+int ovpn_send_data(struct ovpn_struct *ovpn, u32 peer_id, const u8 *data, size_t len);
+
+#endif /* _NET_OVPN_DCO_OVPN_H_ */
diff --git a/drivers/net/ovpn-dco/ovpnstruct.h b/drivers/net/ovpn-dco/ovpnstruct.h
new file mode 100644
index 000000000000..f9bc559609cd
--- /dev/null
+++ b/drivers/net/ovpn-dco/ovpnstruct.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNSTRUCT_H_
+#define _NET_OVPN_DCO_OVPNSTRUCT_H_
+
+#include "peer.h"
+
+#include <uapi/linux/ovpn_dco.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+/* Our state per ovpn interface */
+struct ovpn_struct {
+	/* read-mostly objects in this section */
+	struct net_device *dev;
+
+	/* device operation mode (i.e. P2P, MP) */
+	enum ovpn_mode mode;
+
+	/* protect writing to the ovpn_struct object */
+	spinlock_t lock;
+
+	/* workqueue used to schedule crypto work that may sleep */
+	struct workqueue_struct *crypto_wq;
+	/* workqueue used to schedule generic event that may sleep or that need
+	 * to be performed out of softirq context
+	 */
+	struct workqueue_struct *events_wq;
+
+	/* list of known peers */
+	struct {
+		DECLARE_HASHTABLE(by_id, 12);
+		DECLARE_HASHTABLE(by_transp_addr, 12);
+		DECLARE_HASHTABLE(by_vpn_addr, 12);
+		/* protects write access to any of the hashtables above */
+		spinlock_t lock;
+	} peers;
+
+	/* for p2p mode */
+	struct ovpn_peer __rcu *peer;
+
+	unsigned int max_tun_queue_len;
+
+	netdev_features_t set_features;
+
+	void *security;
+
+	u32 registered_nl_portid;
+	bool registered_nl_portid_set;
+};
+
+#endif /* _NET_OVPN_DCO_OVPNSTRUCT_H_ */
diff --git a/drivers/net/ovpn-dco/peer.c b/drivers/net/ovpn-dco/peer.c
new file mode 100644
index 000000000000..da6f745e2bee
--- /dev/null
+++ b/drivers/net/ovpn-dco/peer.c
@@ -0,0 +1,878 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "ovpn.h"
+#include "bind.h"
+#include "crypto.h"
+#include "peer.h"
+#include "netlink.h"
+#include "tcp.h"
+
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/list.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+
+static void ovpn_peer_ping(struct timer_list *t)
+{
+	struct ovpn_peer *peer = from_timer(peer, t, keepalive_xmit);
+
+	pr_debug("%s: sending ping to peer %u\n", __func__, peer->id);
+	ovpn_keepalive_xmit(peer);
+}
+
+static void ovpn_peer_expire(struct timer_list *t)
+{
+	struct ovpn_peer *peer = from_timer(peer, t, keepalive_recv);
+
+	pr_debug("%s: peer %u expired\n", __func__, peer->id);
+	ovpn_peer_del(peer, OVPN_DEL_PEER_REASON_EXPIRED);
+}
+
+/* Construct a new peer */
+static struct ovpn_peer *ovpn_peer_create(struct ovpn_struct *ovpn, u32 id)
+{
+	struct ovpn_peer *peer;
+	int ret;
+
+	/* alloc and init peer object */
+	peer = kzalloc(sizeof(*peer), GFP_KERNEL);
+	if (!peer)
+		return ERR_PTR(-ENOMEM);
+
+	peer->id = id;
+	peer->halt = false;
+	peer->ovpn = ovpn;
+
+	peer->vpn_addrs.ipv4.s_addr = htonl(INADDR_ANY);
+	peer->vpn_addrs.ipv6 = in6addr_any;
+
+	RCU_INIT_POINTER(peer->bind, NULL);
+	ovpn_crypto_state_init(&peer->crypto);
+	spin_lock_init(&peer->lock);
+	kref_init(&peer->refcount);
+	ovpn_peer_stats_init(&peer->stats);
+
+	INIT_WORK(&peer->encrypt_work, ovpn_encrypt_work);
+	INIT_WORK(&peer->decrypt_work, ovpn_decrypt_work);
+
+	ret = dst_cache_init(&peer->dst_cache, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("%s: cannot initialize dst cache\n", __func__);
+		goto err;
+	}
+
+	ret = ptr_ring_init(&peer->tx_ring, OVPN_QUEUE_LEN, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("%s: cannot allocate TX ring\n", __func__);
+		goto err_dst_cache;
+	}
+
+	ret = ptr_ring_init(&peer->rx_ring, OVPN_QUEUE_LEN, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("%s: cannot allocate RX ring\n", __func__);
+		goto err_tx_ring;
+	}
+
+	ret = ptr_ring_init(&peer->netif_rx_ring, OVPN_QUEUE_LEN, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("%s: cannot allocate NETIF RX ring\n", __func__);
+		goto err_rx_ring;
+	}
+
+	/* configure and start NAPI */
+	netif_tx_napi_add(ovpn->dev, &peer->napi, ovpn_napi_poll,
+			  NAPI_POLL_WEIGHT);
+	napi_enable(&peer->napi);
+
+	dev_hold(ovpn->dev);
+
+	timer_setup(&peer->keepalive_xmit, ovpn_peer_ping, 0);
+	timer_setup(&peer->keepalive_recv, ovpn_peer_expire, 0);
+
+	return peer;
+err_rx_ring:
+	ptr_ring_cleanup(&peer->rx_ring, NULL);
+err_tx_ring:
+	ptr_ring_cleanup(&peer->tx_ring, NULL);
+err_dst_cache:
+	dst_cache_destroy(&peer->dst_cache);
+err:
+	kfree(peer);
+	return ERR_PTR(ret);
+}
+
+/* Reset the ovpn_sockaddr associated with a peer */
+static int ovpn_peer_reset_sockaddr(struct ovpn_peer *peer, const struct sockaddr_storage *ss,
+				    const u8 *local_ip)
+{
+	struct ovpn_bind *bind;
+	size_t ip_len;
+
+	/* create new ovpn_bind object */
+	bind = ovpn_bind_from_sockaddr(ss);
+	if (IS_ERR(bind))
+		return PTR_ERR(bind);
+
+	if (local_ip) {
+		if (ss->ss_family == AF_INET) {
+			ip_len = sizeof(struct in_addr);
+		} else if (ss->ss_family == AF_INET6) {
+			ip_len = sizeof(struct in6_addr);
+		} else {
+			pr_debug("%s: invalid family for remote endpoint\n", __func__);
+			kfree(bind);
+			return -EINVAL;
+		}
+
+		memcpy(&bind->local, local_ip, ip_len);
+	}
+
+	/* set binding */
+	ovpn_bind_reset(peer, bind);
+
+	return 0;
+}
+
+void ovpn_peer_float(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	struct sockaddr_storage ss;
+	const u8 *local_ip = NULL;
+	struct sockaddr_in6 *sa6;
+	struct sockaddr_in *sa;
+	struct ovpn_bind *bind;
+	sa_family_t family;
+
+	rcu_read_lock();
+	bind = rcu_dereference(peer->bind);
+	if (unlikely(!bind))
+		goto unlock;
+
+	if (likely(ovpn_bind_skb_src_match(bind, skb)))
+		goto unlock;
+
+	family = skb_protocol_to_family(skb);
+
+	if (bind->sa.in4.sin_family == family)
+		local_ip = (u8 *)&bind->local;
+
+	switch (family) {
+	case AF_INET:
+		sa = (struct sockaddr_in *)&ss;
+		sa->sin_family = AF_INET;
+		sa->sin_addr.s_addr = ip_hdr(skb)->saddr;
+		sa->sin_port = udp_hdr(skb)->source;
+		break;
+	case AF_INET6:
+		sa6 = (struct sockaddr_in6 *)&ss;
+		sa6->sin6_family = AF_INET6;
+		sa6->sin6_addr = ipv6_hdr(skb)->saddr;
+		sa6->sin6_port = udp_hdr(skb)->source;
+		sa6->sin6_scope_id = ipv6_iface_scope_id(&ipv6_hdr(skb)->saddr, skb->skb_iif);
+		break;
+	default:
+		goto unlock;
+	}
+
+	pr_debug("%s: peer %d floated to %pIScp", __func__, peer->id, &ss);
+	ovpn_peer_reset_sockaddr(peer, (struct sockaddr_storage *)&ss, local_ip);
+unlock:
+	rcu_read_unlock();
+}
+
+static void ovpn_peer_timer_delete_all(struct ovpn_peer *peer)
+{
+	del_timer_sync(&peer->keepalive_xmit);
+	del_timer_sync(&peer->keepalive_recv);
+}
+
+static void ovpn_peer_free(struct ovpn_peer *peer)
+{
+	ovpn_bind_reset(peer, NULL);
+	ovpn_peer_timer_delete_all(peer);
+
+	WARN_ON(!__ptr_ring_empty(&peer->tx_ring));
+	ptr_ring_cleanup(&peer->tx_ring, NULL);
+	WARN_ON(!__ptr_ring_empty(&peer->rx_ring));
+	ptr_ring_cleanup(&peer->rx_ring, NULL);
+	WARN_ON(!__ptr_ring_empty(&peer->netif_rx_ring));
+	ptr_ring_cleanup(&peer->netif_rx_ring, NULL);
+
+	dst_cache_destroy(&peer->dst_cache);
+
+	dev_put(peer->ovpn->dev);
+
+	kfree(peer);
+}
+
+static void ovpn_peer_release_rcu(struct rcu_head *head)
+{
+	struct ovpn_peer *peer = container_of(head, struct ovpn_peer, rcu);
+
+	ovpn_crypto_state_release(&peer->crypto);
+	ovpn_peer_free(peer);
+}
+
+void ovpn_peer_release(struct ovpn_peer *peer)
+{
+	napi_disable(&peer->napi);
+	netif_napi_del(&peer->napi);
+
+	if (peer->sock)
+		ovpn_socket_put(peer->sock);
+
+	call_rcu(&peer->rcu, ovpn_peer_release_rcu);
+}
+
+static void ovpn_peer_delete_work(struct work_struct *work)
+{
+	struct ovpn_peer *peer = container_of(work, struct ovpn_peer,
+					      delete_work);
+	ovpn_peer_release(peer);
+	ovpn_netlink_notify_del_peer(peer);
+}
+
+/* Use with kref_put calls, when releasing refcount
+ * on ovpn_peer objects.  This method should only
+ * be called from process context with config_mutex held.
+ */
+void ovpn_peer_release_kref(struct kref *kref)
+{
+	struct ovpn_peer *peer = container_of(kref, struct ovpn_peer, refcount);
+
+	INIT_WORK(&peer->delete_work, ovpn_peer_delete_work);
+	queue_work(peer->ovpn->events_wq, &peer->delete_work);
+}
+
+struct ovpn_peer *ovpn_peer_new(struct ovpn_struct *ovpn, const struct sockaddr_storage *sa,
+				struct socket *sock, u32 id, uint8_t *local_ip)
+{
+	struct ovpn_peer *peer;
+	int ret;
+
+	/* create new peer */
+	peer = ovpn_peer_create(ovpn, id);
+	if (IS_ERR(peer))
+		return peer;
+
+	if (sock->sk->sk_protocol == IPPROTO_UDP) {
+		/* a UDP peer must have a remote endpoint */
+		if (!sa) {
+			ovpn_peer_release(peer);
+			return ERR_PTR(-EINVAL);
+		}
+
+		/* set peer sockaddr */
+		ret = ovpn_peer_reset_sockaddr(peer, sa, local_ip);
+		if (ret < 0) {
+			ovpn_peer_release(peer);
+			return ERR_PTR(ret);
+		}
+	}
+
+	peer->sock = ovpn_socket_new(sock, peer);
+	if (IS_ERR(peer->sock)) {
+		peer->sock = NULL;
+		ovpn_peer_release(peer);
+		return ERR_PTR(-ENOTSOCK);
+	}
+
+	/* schedule initial TCP RX work only after having assigned peer->sock */
+	if (peer->sock->sock->sk->sk_protocol == IPPROTO_TCP)
+		queue_work(peer->ovpn->events_wq, &peer->tcp.rx_work);
+
+	return peer;
+}
+
+/* Configure keepalive parameters */
+void ovpn_peer_keepalive_set(struct ovpn_peer *peer, u32 interval, u32 timeout)
+{
+	u32 delta;
+
+	pr_debug("%s: scheduling keepalive for peer %u: interval=%u timeout=%u\n", __func__,
+		 peer->id, interval, timeout);
+
+	peer->keepalive_interval = interval;
+	if (interval > 0) {
+		delta = msecs_to_jiffies(interval * MSEC_PER_SEC);
+		mod_timer(&peer->keepalive_xmit, jiffies + delta);
+	} else {
+		del_timer(&peer->keepalive_xmit);
+	}
+
+	peer->keepalive_timeout = timeout;
+	if (timeout) {
+		delta = msecs_to_jiffies(timeout * MSEC_PER_SEC);
+		mod_timer(&peer->keepalive_recv, jiffies + delta);
+	} else {
+		del_timer(&peer->keepalive_recv);
+	}
+}
+
+#define ovpn_peer_index(_tbl, _key, _key_len)		\
+	(jhash(_key, _key_len, 0) % HASH_SIZE(_tbl))	\
+
+static struct ovpn_peer *ovpn_peer_lookup_vpn_addr4(struct hlist_head *head, __be32 *addr)
+{
+	struct ovpn_peer *tmp, *peer = NULL;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, head, hash_entry_addr4) {
+		if (*addr != tmp->vpn_addrs.ipv4.s_addr)
+			continue;
+
+		if (!ovpn_peer_hold(tmp))
+			continue;
+
+		peer = tmp;
+		break;
+	}
+	rcu_read_unlock();
+
+	return peer;
+}
+
+static struct ovpn_peer *ovpn_peer_lookup_vpn_addr6(struct hlist_head *head, struct in6_addr *addr)
+{
+	struct ovpn_peer *tmp, *peer = NULL;
+	int i;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, head, hash_entry_addr6) {
+		for (i = 0; i < 4; i++) {
+			if (addr->s6_addr32[i] != tmp->vpn_addrs.ipv6.s6_addr32[i])
+				continue;
+		}
+
+		if (!ovpn_peer_hold(tmp))
+			continue;
+
+		peer = tmp;
+		break;
+	}
+	rcu_read_unlock();
+
+	return peer;
+}
+
+static struct rtable *ovpn_gw4(struct ovpn_struct *ovpn, __be32 dst)
+{
+	struct rtable *rt;
+	struct flowi4 fl = {
+		.daddr = dst
+	};
+
+	rt = ip_route_output_flow(dev_net(ovpn->dev), &fl, NULL);
+	if (IS_ERR(rt)) {
+		net_dbg_ratelimited("%s: no route to host %pI4\n", __func__, &dst);
+		/* if we end up here this packet is probably going to be thrown away later */
+		return NULL;
+	}
+
+	if (!rt->rt_uses_gateway) {
+		ip_rt_put(rt);
+		rt = NULL;
+	}
+
+	return rt;
+}
+
+static struct rt6_info *ovpn_gw6(struct ovpn_struct *ovpn, const struct in6_addr *dst)
+{
+	struct rt6_info *rt;
+	struct flowi6 fl = {
+		.daddr = *dst,
+	};
+
+	rt = (struct rt6_info *)ipv6_stub->ipv6_dst_lookup_flow(dev_net(ovpn->dev), NULL, &fl,
+								NULL);
+	if (IS_ERR(rt)) {
+		net_dbg_ratelimited("%s: no route to host %pI6\n", __func__, dst);
+		/* if we end up here this packet is probably going to be thrown away later */
+		return NULL;
+	}
+
+	if (!(rt->rt6i_flags & RTF_GATEWAY)) {
+		dst_release((struct dst_entry *)rt);
+		rt = NULL;
+	}
+
+	return rt;
+}
+
+/**
+ * ovpn_peer_lookup_vpn_addr() - Lookup peer to send skb to
+ *
+ * This function takes a tunnel packet and looks up the peer to send it to
+ * after encapsulation. The skb is expected to be the in-tunnel packet, without
+ * any OpenVPN related header.
+ *
+ * Assume that the IP header is accessible in the skb data.
+ *
+ * @ovpn: the private data representing the current VPN session
+ * @skb: the skb to extract the destination address from
+ *
+ * Return the peer if found or NULL otherwise.
+ */
+struct ovpn_peer *ovpn_peer_lookup_vpn_addr(struct ovpn_struct *ovpn, struct sk_buff *skb,
+					    bool use_src)
+{
+	struct ovpn_peer *tmp, *peer = NULL;
+	struct hlist_head *head;
+	struct rt6_info *rt6i = NULL;
+	struct rtable *rt = NULL;
+	sa_family_t sa_fam;
+	struct in6_addr *addr6;
+	__be32 addr4;
+	u32 index;
+
+	/* in P2P mode, no matter the destination, packets are always sent to the single peer
+	 * listening on the other side
+	 */
+	if (ovpn->mode == OVPN_MODE_P2P) {
+		rcu_read_lock();
+		tmp = rcu_dereference(ovpn->peer);
+		if (likely(tmp && ovpn_peer_hold(tmp)))
+			peer = tmp;
+		rcu_read_unlock();
+		return peer;
+	}
+
+	sa_fam = skb_protocol_to_family(skb);
+
+	switch (sa_fam) {
+	case AF_INET:
+		if (use_src)
+			addr4 = ip_hdr(skb)->saddr;
+		else
+			addr4 = ip_hdr(skb)->daddr;
+		rt = ovpn_gw4(ovpn, addr4);
+		if (rt)
+			addr4 = rt->rt_gw4;
+
+		index = ovpn_peer_index(ovpn->peers.by_vpn_addr, &addr4, sizeof(addr4));
+		head = &ovpn->peers.by_vpn_addr[index];
+
+		peer = ovpn_peer_lookup_vpn_addr4(head, &addr4);
+		break;
+	case AF_INET6:
+		if (use_src)
+			addr6 = &ipv6_hdr(skb)->saddr;
+		else
+			addr6 = &ipv6_hdr(skb)->daddr;
+		rt6i = ovpn_gw6(ovpn, addr6);
+		if (rt6i)
+			addr6 = &rt6i->rt6i_gateway;
+
+		index = ovpn_peer_index(ovpn->peers.by_vpn_addr, addr6, sizeof(*addr6));
+		head = &ovpn->peers.by_vpn_addr[index];
+
+		peer = ovpn_peer_lookup_vpn_addr6(head, addr6);
+		break;
+	}
+
+	if (rt)
+		ip_rt_put(rt);
+	if (rt6i)
+		dst_release((struct dst_entry *)rt6i);
+
+	return peer;
+}
+
+static bool ovpn_peer_transp_match(struct ovpn_peer *peer, struct sockaddr_storage *ss)
+{
+	struct ovpn_bind *bind = rcu_dereference(peer->bind);
+	struct sockaddr_in6 *sa6;
+	struct sockaddr_in *sa4;
+
+	if (unlikely(!bind))
+		return false;
+
+	if (ss->ss_family != bind->sa.in4.sin_family)
+		return false;
+
+	switch (ss->ss_family) {
+	case AF_INET:
+		sa4 = (struct sockaddr_in *)ss;
+		if (sa4->sin_addr.s_addr != bind->sa.in4.sin_addr.s_addr)
+			return false;
+		if (sa4->sin_port != bind->sa.in4.sin_port)
+			return false;
+		break;
+	case AF_INET6:
+		sa6 = (struct sockaddr_in6 *)ss;
+		if (memcmp(&sa6->sin6_addr, &bind->sa.in6.sin6_addr, sizeof(struct in6_addr)))
+			return false;
+		if (sa6->sin6_port != bind->sa.in6.sin6_port)
+			return false;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static bool ovpn_peer_skb_to_sockaddr(struct sk_buff *skb, struct sockaddr_storage *ss)
+{
+	struct sockaddr_in6 *sa6;
+	struct sockaddr_in *sa4;
+
+	ss->ss_family = skb_protocol_to_family(skb);
+	switch (ss->ss_family) {
+	case AF_INET:
+		sa4 = (struct sockaddr_in *)ss;
+		sa4->sin_family = AF_INET;
+		sa4->sin_addr.s_addr = ip_hdr(skb)->saddr;
+		sa4->sin_port = udp_hdr(skb)->source;
+		break;
+	case AF_INET6:
+		sa6 = (struct sockaddr_in6 *)ss;
+		sa6->sin6_family = AF_INET6;
+		sa6->sin6_addr = ipv6_hdr(skb)->saddr;
+		sa6->sin6_port = udp_hdr(skb)->source;
+		break;
+	default:
+		return false;
+	}
+
+	return true;
+}
+
+static struct ovpn_peer *ovpn_peer_lookup_transp_addr_p2p(struct ovpn_struct *ovpn,
+							  struct sockaddr_storage *ss)
+{
+	struct ovpn_peer *tmp, *peer = NULL;
+
+	rcu_read_lock();
+	tmp = rcu_dereference(ovpn->peer);
+	if (likely(tmp && ovpn_peer_transp_match(tmp, ss) && ovpn_peer_hold(tmp)))
+		peer = tmp;
+	rcu_read_unlock();
+
+	return peer;
+}
+
+struct ovpn_peer *ovpn_peer_lookup_transp_addr(struct ovpn_struct *ovpn, struct sk_buff *skb)
+{
+	struct ovpn_peer *peer = NULL, *tmp;
+	struct sockaddr_storage ss = { 0 };
+	struct hlist_head *head;
+	size_t sa_len;
+	bool found;
+	u32 index;
+
+	if (unlikely(!ovpn_peer_skb_to_sockaddr(skb, &ss)))
+		return NULL;
+
+	if (ovpn->mode == OVPN_MODE_P2P)
+		return ovpn_peer_lookup_transp_addr_p2p(ovpn, &ss);
+
+	switch (ss.ss_family) {
+	case AF_INET:
+		sa_len = sizeof(struct sockaddr_in);
+		break;
+	case AF_INET6:
+		sa_len = sizeof(struct sockaddr_in6);
+		break;
+	default:
+		return NULL;
+	}
+
+	index = ovpn_peer_index(ovpn->peers.by_transp_addr, &ss, sa_len);
+	head = &ovpn->peers.by_transp_addr[index];
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, head, hash_entry_transp_addr) {
+		found = ovpn_peer_transp_match(tmp, &ss);
+		if (!found)
+			continue;
+
+		if (!ovpn_peer_hold(tmp))
+			continue;
+
+		peer = tmp;
+		break;
+	}
+	rcu_read_unlock();
+
+	return peer;
+}
+
+static struct ovpn_peer *ovpn_peer_lookup_id_p2p(struct ovpn_struct *ovpn, u32 peer_id)
+{
+	struct ovpn_peer *tmp, *peer = NULL;
+
+	rcu_read_lock();
+	tmp = rcu_dereference(ovpn->peer);
+	if (likely(tmp && tmp->id == peer_id && ovpn_peer_hold(tmp)))
+		peer = tmp;
+	rcu_read_unlock();
+
+	return peer;
+}
+
+struct ovpn_peer *ovpn_peer_lookup_id(struct ovpn_struct *ovpn, u32 peer_id)
+{
+	struct ovpn_peer *tmp,  *peer = NULL;
+	struct hlist_head *head;
+	u32 index;
+
+	if (ovpn->mode == OVPN_MODE_P2P)
+		return ovpn_peer_lookup_id_p2p(ovpn, peer_id);
+
+	index = ovpn_peer_index(ovpn->peers.by_id, &peer_id, sizeof(peer_id));
+	head = &ovpn->peers.by_id[index];
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(tmp, head, hash_entry_id) {
+		if (tmp->id != peer_id)
+			continue;
+
+		if (!ovpn_peer_hold(tmp))
+			continue;
+
+		peer = tmp;
+		break;
+	}
+	rcu_read_unlock();
+
+	return peer;
+}
+
+void ovpn_peer_update_local_endpoint(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	struct ovpn_bind *bind;
+
+	rcu_read_lock();
+	bind = rcu_dereference(peer->bind);
+	if (unlikely(!bind))
+		goto unlock;
+
+	switch (skb_protocol_to_family(skb)) {
+	case AF_INET:
+		if (unlikely(bind->local.ipv4.s_addr != ip_hdr(skb)->daddr)) {
+			pr_debug("%s: learning local IPv4 for peer %d (%pI4 -> %pI4)\n", __func__,
+				 peer->id, &bind->local.ipv4.s_addr, &ip_hdr(skb)->daddr);
+			bind->local.ipv4.s_addr = ip_hdr(skb)->daddr;
+		}
+		break;
+	case AF_INET6:
+		if (unlikely(memcmp(&bind->local.ipv6, &ipv6_hdr(skb)->daddr,
+				    sizeof(bind->local.ipv6)))) {
+			pr_debug("%s: learning local IPv6 for peer %d (%pI6c -> %pI6c\n", __func__,
+				 peer->id, &bind->local.ipv6, &ipv6_hdr(skb)->daddr);
+			bind->local.ipv6 = ipv6_hdr(skb)->daddr;
+		}
+		break;
+	default:
+		break;
+	}
+unlock:
+	rcu_read_unlock();
+}
+
+static int ovpn_peer_add_mp(struct ovpn_struct *ovpn, struct ovpn_peer *peer)
+{
+	struct sockaddr_storage sa = { 0 };
+	struct sockaddr_in6 *sa6;
+	struct sockaddr_in *sa4;
+	struct ovpn_bind *bind;
+	struct ovpn_peer *tmp;
+	size_t salen;
+	int ret = 0;
+	u32 index;
+
+	spin_lock_bh(&ovpn->peers.lock);
+	/* do not add duplicates */
+	tmp = ovpn_peer_lookup_id(ovpn, peer->id);
+	if (tmp) {
+		ovpn_peer_put(tmp);
+		ret = -EEXIST;
+		goto unlock;
+	}
+
+	hlist_del_init_rcu(&peer->hash_entry_transp_addr);
+	bind = rcu_dereference_protected(peer->bind, true);
+	/* peers connected via UDP have bind == NULL */
+	if (bind) {
+		switch (bind->sa.in4.sin_family) {
+		case AF_INET:
+			sa4 = (struct sockaddr_in *)&sa;
+
+			sa4->sin_family = AF_INET;
+			sa4->sin_addr.s_addr = bind->sa.in4.sin_addr.s_addr;
+			sa4->sin_port = bind->sa.in4.sin_port;
+			salen = sizeof(*sa4);
+			break;
+		case AF_INET6:
+			sa6 = (struct sockaddr_in6 *)&sa;
+
+			sa6->sin6_family = AF_INET6;
+			sa6->sin6_addr = bind->sa.in6.sin6_addr;
+			sa6->sin6_port = bind->sa.in6.sin6_port;
+			salen = sizeof(*sa6);
+			break;
+		default:
+			ret = -EPROTONOSUPPORT;
+			goto unlock;
+		}
+
+		index = ovpn_peer_index(ovpn->peers.by_transp_addr, &sa, salen);
+		hlist_add_head_rcu(&peer->hash_entry_transp_addr,
+				   &ovpn->peers.by_transp_addr[index]);
+	}
+
+	index = ovpn_peer_index(ovpn->peers.by_id, &peer->id, sizeof(peer->id));
+	hlist_add_head_rcu(&peer->hash_entry_id, &ovpn->peers.by_id[index]);
+
+	if (peer->vpn_addrs.ipv4.s_addr != htonl(INADDR_ANY)) {
+		index = ovpn_peer_index(ovpn->peers.by_vpn_addr, &peer->vpn_addrs.ipv4,
+					sizeof(peer->vpn_addrs.ipv4));
+		hlist_add_head_rcu(&peer->hash_entry_addr4, &ovpn->peers.by_vpn_addr[index]);
+	}
+
+	hlist_del_init_rcu(&peer->hash_entry_addr6);
+	if (memcmp(&peer->vpn_addrs.ipv6, &in6addr_any, sizeof(peer->vpn_addrs.ipv6))) {
+		index = ovpn_peer_index(ovpn->peers.by_vpn_addr, &peer->vpn_addrs.ipv6,
+					sizeof(peer->vpn_addrs.ipv6));
+		hlist_add_head_rcu(&peer->hash_entry_addr6, &ovpn->peers.by_vpn_addr[index]);
+	}
+
+unlock:
+	spin_unlock_bh(&ovpn->peers.lock);
+
+	return ret;
+}
+
+static int ovpn_peer_add_p2p(struct ovpn_struct *ovpn, struct ovpn_peer *peer)
+{
+	struct ovpn_peer *tmp;
+
+	spin_lock_bh(&ovpn->lock);
+	/* in p2p mode it is possible to have a single peer only, therefore the
+	 * old one is released and substituted by the new one
+	 */
+	tmp = rcu_dereference(ovpn->peer);
+	if (tmp) {
+		tmp->delete_reason = OVPN_DEL_PEER_REASON_TEARDOWN;
+		ovpn_peer_put(tmp);
+	}
+
+	rcu_assign_pointer(ovpn->peer, peer);
+	spin_unlock_bh(&ovpn->lock);
+
+	return 0;
+}
+
+/* assume refcounter was increased by caller */
+int ovpn_peer_add(struct ovpn_struct *ovpn, struct ovpn_peer *peer)
+{
+	switch (ovpn->mode) {
+	case OVPN_MODE_MP:
+		return ovpn_peer_add_mp(ovpn, peer);
+	case OVPN_MODE_P2P:
+		return ovpn_peer_add_p2p(ovpn, peer);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void ovpn_peer_unhash(struct ovpn_peer *peer, enum ovpn_del_peer_reason reason)
+{
+	hlist_del_init_rcu(&peer->hash_entry_id);
+	hlist_del_init_rcu(&peer->hash_entry_addr4);
+	hlist_del_init_rcu(&peer->hash_entry_addr6);
+	hlist_del_init_rcu(&peer->hash_entry_transp_addr);
+
+	ovpn_peer_put(peer);
+	peer->delete_reason = reason;
+}
+
+static int ovpn_peer_del_mp(struct ovpn_peer *peer, enum ovpn_del_peer_reason reason)
+{
+	struct ovpn_peer *tmp;
+	int ret = 0;
+
+	spin_lock_bh(&peer->ovpn->peers.lock);
+	tmp = ovpn_peer_lookup_id(peer->ovpn, peer->id);
+	if (tmp != peer) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+	ovpn_peer_unhash(peer, reason);
+
+unlock:
+	spin_unlock_bh(&peer->ovpn->peers.lock);
+
+	if (tmp)
+		ovpn_peer_put(tmp);
+
+	return ret;
+}
+
+static int ovpn_peer_del_p2p(struct ovpn_peer *peer, enum ovpn_del_peer_reason reason)
+{
+	struct ovpn_peer *tmp;
+	int ret = -ENOENT;
+
+	spin_lock_bh(&peer->ovpn->lock);
+	tmp = rcu_dereference(peer->ovpn->peer);
+	if (tmp != peer)
+		goto unlock;
+
+	ovpn_peer_put(tmp);
+	tmp->delete_reason = reason;
+	RCU_INIT_POINTER(peer->ovpn->peer, NULL);
+	ret = 0;
+
+unlock:
+	spin_unlock_bh(&peer->ovpn->lock);
+
+	return ret;
+}
+
+void ovpn_peer_release_p2p(struct ovpn_struct *ovpn)
+{
+	struct ovpn_peer *tmp;
+
+	rcu_read_lock();
+	tmp = rcu_dereference(ovpn->peer);
+	if (!tmp)
+		goto unlock;
+
+	ovpn_peer_del_p2p(tmp, OVPN_DEL_PEER_REASON_TEARDOWN);
+unlock:
+	rcu_read_unlock();
+}
+
+int ovpn_peer_del(struct ovpn_peer *peer, enum ovpn_del_peer_reason reason)
+{
+	switch (peer->ovpn->mode) {
+	case OVPN_MODE_MP:
+		return ovpn_peer_del_mp(peer, reason);
+	case OVPN_MODE_P2P:
+		return ovpn_peer_del_p2p(peer, reason);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+void ovpn_peers_free(struct ovpn_struct *ovpn)
+{
+	struct hlist_node *tmp;
+	struct ovpn_peer *peer;
+	int bkt;
+
+	spin_lock_bh(&ovpn->peers.lock);
+	hash_for_each_safe(ovpn->peers.by_id, bkt, tmp, peer, hash_entry_id)
+		ovpn_peer_unhash(peer, OVPN_DEL_PEER_REASON_TEARDOWN);
+	spin_unlock_bh(&ovpn->peers.lock);
+}
diff --git a/drivers/net/ovpn-dco/peer.h b/drivers/net/ovpn-dco/peer.h
new file mode 100644
index 000000000000..b759c2c9da48
--- /dev/null
+++ b/drivers/net/ovpn-dco/peer.h
@@ -0,0 +1,168 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNPEER_H_
+#define _NET_OVPN_DCO_OVPNPEER_H_
+
+#include "addr.h"
+#include "bind.h"
+#include "sock.h"
+#include "stats.h"
+
+#include <linux/timer.h>
+#include <linux/ptr_ring.h>
+#include <net/dst_cache.h>
+
+struct ovpn_peer {
+	struct ovpn_struct *ovpn;
+
+	u32 id;
+
+	struct {
+		struct in_addr ipv4;
+		struct in6_addr ipv6;
+	} vpn_addrs;
+
+	struct hlist_node hash_entry_id;
+	struct hlist_node hash_entry_addr4;
+	struct hlist_node hash_entry_addr6;
+	struct hlist_node hash_entry_transp_addr;
+
+	/* work objects to handle encryption/decryption of packets.
+	 * these works are queued on the ovpn->crypt_wq workqueue.
+	 */
+	struct work_struct encrypt_work;
+	struct work_struct decrypt_work;
+
+	struct ptr_ring tx_ring;
+	struct ptr_ring rx_ring;
+	struct ptr_ring netif_rx_ring;
+
+	struct napi_struct napi;
+
+	struct ovpn_socket *sock;
+
+	/* state of the TCP reading. Needed to keep track of how much of a single packet has already
+	 * been read from the stream and how much is missing
+	 */
+	struct {
+		struct ptr_ring tx_ring;
+		struct work_struct tx_work;
+		struct work_struct rx_work;
+
+		u8 raw_len[sizeof(u16)];
+		struct sk_buff *skb;
+		u16 offset;
+		u16 data_len;
+		struct {
+			void (*sk_state_change)(struct sock *sk);
+			void (*sk_data_ready)(struct sock *sk);
+			void (*sk_write_space)(struct sock *sk);
+		} sk_cb;
+	} tcp;
+
+	struct dst_cache dst_cache;
+
+	/* our crypto state */
+	struct ovpn_crypto_state crypto;
+
+	/* our binding to peer, protected by spinlock */
+	struct ovpn_bind __rcu *bind;
+
+	/* timer used to send periodic ping messages to the other peer, if no
+	 * other data was sent within the past keepalive_interval seconds
+	 */
+	struct timer_list keepalive_xmit;
+	/* keepalive interval in seconds */
+	unsigned long keepalive_interval;
+
+	/* timer used to mark a peer as expired when no data is received for
+	 * keepalive_timeout seconds
+	 */
+	struct timer_list keepalive_recv;
+	/* keepalive timeout in seconds */
+	unsigned long keepalive_timeout;
+
+	/* true if ovpn_peer_mark_delete was called */
+	bool halt;
+
+	/* per-peer rx/tx stats */
+	struct ovpn_peer_stats stats;
+
+	/* why peer was deleted - keepalive timeout, module removed etc */
+	enum ovpn_del_peer_reason delete_reason;
+
+	/* protects binding to peer (bind) and timers
+	 * (keepalive_xmit, keepalive_expire)
+	 */
+	spinlock_t lock;
+
+	/* needed because crypto methods can go async */
+	struct kref refcount;
+
+	/* needed to free a peer in an RCU safe way */
+	struct rcu_head rcu;
+
+	/* needed to notify userspace about deletion */
+	struct work_struct delete_work;
+};
+
+void ovpn_peer_release_kref(struct kref *kref);
+void ovpn_peer_release(struct ovpn_peer *peer);
+
+static inline bool ovpn_peer_hold(struct ovpn_peer *peer)
+{
+	return kref_get_unless_zero(&peer->refcount);
+}
+
+static inline void ovpn_peer_put(struct ovpn_peer *peer)
+{
+	kref_put(&peer->refcount, ovpn_peer_release_kref);
+}
+
+static inline void ovpn_peer_keepalive_recv_reset(struct ovpn_peer *peer)
+{
+	u32 delta = msecs_to_jiffies(peer->keepalive_timeout * MSEC_PER_SEC);
+
+	if (unlikely(!delta))
+		return;
+
+	mod_timer(&peer->keepalive_recv, jiffies + delta);
+}
+
+static inline void ovpn_peer_keepalive_xmit_reset(struct ovpn_peer *peer)
+{
+	u32 delta = msecs_to_jiffies(peer->keepalive_interval * MSEC_PER_SEC);
+
+	if (unlikely(!delta))
+		return;
+
+	mod_timer(&peer->keepalive_xmit, jiffies + delta);
+}
+
+struct ovpn_peer *ovpn_peer_new(struct ovpn_struct *ovpn, const struct sockaddr_storage *sa,
+				struct socket *sock, u32 id, uint8_t *local_ip);
+
+void ovpn_peer_keepalive_set(struct ovpn_peer *peer, u32 interval, u32 timeout);
+
+int ovpn_peer_add(struct ovpn_struct *ovpn, struct ovpn_peer *peer);
+int ovpn_peer_del(struct ovpn_peer *peer, enum ovpn_del_peer_reason reason);
+struct ovpn_peer *ovpn_peer_find(struct ovpn_struct *ovpn, u32 peer_id);
+void ovpn_peer_release_p2p(struct ovpn_struct *ovpn);
+void ovpn_peers_free(struct ovpn_struct *ovpn);
+
+struct ovpn_peer *ovpn_peer_lookup_transp_addr(struct ovpn_struct *ovpn, struct sk_buff *skb);
+struct ovpn_peer *ovpn_peer_lookup_vpn_addr(struct ovpn_struct *ovpn, struct sk_buff *skb,
+					    bool use_src);
+struct ovpn_peer *ovpn_peer_lookup_id(struct ovpn_struct *ovpn, u32 peer_id);
+
+void ovpn_peer_update_local_endpoint(struct ovpn_peer *peer, struct sk_buff *skb);
+void ovpn_peer_float(struct ovpn_peer *peer, struct sk_buff *skb);
+
+#endif /* _NET_OVPN_DCO_OVPNPEER_H_ */
diff --git a/drivers/net/ovpn-dco/pktid.c b/drivers/net/ovpn-dco/pktid.c
new file mode 100644
index 000000000000..fcde8fba5156
--- /dev/null
+++ b/drivers/net/ovpn-dco/pktid.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ *		James Yonan <james@openvpn.net>
+ */
+
+#include "pktid.h"
+
+#include <linux/atomic.h>
+#include <linux/jiffies.h>
+
+void ovpn_pktid_xmit_init(struct ovpn_pktid_xmit *pid)
+{
+	atomic64_set(&pid->seq_num, 1);
+	pid->tcp_linear = NULL;
+}
+
+void ovpn_pktid_recv_init(struct ovpn_pktid_recv *pr)
+{
+	memset(pr, 0, sizeof(*pr));
+	spin_lock_init(&pr->lock);
+}
+
+/* Packet replay detection.
+ * Allows ID backtrack of up to REPLAY_WINDOW_SIZE - 1.
+ */
+int ovpn_pktid_recv(struct ovpn_pktid_recv *pr, u32 pkt_id, u32 pkt_time)
+{
+	const unsigned long now = jiffies;
+	int ret;
+
+	spin_lock(&pr->lock);
+
+	/* expire backtracks at or below pr->id after PKTID_RECV_EXPIRE time */
+	if (unlikely(time_after_eq(now, pr->expire)))
+		pr->id_floor = pr->id;
+
+	/* ID must not be zero */
+	if (unlikely(pkt_id == 0)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* time changed? */
+	if (unlikely(pkt_time != pr->time)) {
+		if (pkt_time > pr->time) {
+			/* time moved forward, accept */
+			pr->base = 0;
+			pr->extent = 0;
+			pr->id = 0;
+			pr->time = pkt_time;
+			pr->id_floor = 0;
+		} else {
+			/* time moved backward, reject */
+			ret = -ETIME;
+			goto out;
+		}
+	}
+
+	if (likely(pkt_id == pr->id + 1)) {
+		/* well-formed ID sequence (incremented by 1) */
+		pr->base = REPLAY_INDEX(pr->base, -1);
+		pr->history[pr->base / 8] |= (1 << (pr->base % 8));
+		if (pr->extent < REPLAY_WINDOW_SIZE)
+			++pr->extent;
+		pr->id = pkt_id;
+	} else if (pkt_id > pr->id) {
+		/* ID jumped forward by more than one */
+		const unsigned int delta = pkt_id - pr->id;
+
+		if (delta < REPLAY_WINDOW_SIZE) {
+			unsigned int i;
+
+			pr->base = REPLAY_INDEX(pr->base, -delta);
+			pr->history[pr->base / 8] |= (1 << (pr->base % 8));
+			pr->extent += delta;
+			if (pr->extent > REPLAY_WINDOW_SIZE)
+				pr->extent = REPLAY_WINDOW_SIZE;
+			for (i = 1; i < delta; ++i) {
+				unsigned int newb = REPLAY_INDEX(pr->base, i);
+
+				pr->history[newb / 8] &= ~BIT(newb % 8);
+			}
+		} else {
+			pr->base = 0;
+			pr->extent = REPLAY_WINDOW_SIZE;
+			memset(pr->history, 0, sizeof(pr->history));
+			pr->history[0] = 1;
+		}
+		pr->id = pkt_id;
+	} else {
+		/* ID backtrack */
+		const unsigned int delta = pr->id - pkt_id;
+
+		if (delta > pr->max_backtrack)
+			pr->max_backtrack = delta;
+		if (delta < pr->extent) {
+			if (pkt_id > pr->id_floor) {
+				const unsigned int ri = REPLAY_INDEX(pr->base,
+								     delta);
+				u8 *p = &pr->history[ri / 8];
+				const u8 mask = (1 << (ri % 8));
+
+				if (*p & mask) {
+					ret = -EINVAL;
+					goto out;
+				}
+				*p |= mask;
+			} else {
+				ret = -EINVAL;
+				goto out;
+			}
+		} else {
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	pr->expire = now + PKTID_RECV_EXPIRE;
+	ret = 0;
+out:
+	spin_unlock(&pr->lock);
+	return ret;
+}
diff --git a/drivers/net/ovpn-dco/pktid.h b/drivers/net/ovpn-dco/pktid.h
new file mode 100644
index 000000000000..2447bb37ba55
--- /dev/null
+++ b/drivers/net/ovpn-dco/pktid.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ *		James Yonan <james@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNPKTID_H_
+#define _NET_OVPN_DCO_OVPNPKTID_H_
+
+#include "main.h"
+
+/* When the OpenVPN protocol is run in AEAD mode, use
+ * the OpenVPN packet ID as the AEAD nonce:
+ *
+ *    00000005 521c3b01 4308c041
+ *    [seq # ] [  nonce_tail   ]
+ *    [     12-byte full IV    ] -> NONCE_SIZE
+ *    [4-bytes                   -> NONCE_WIRE_SIZE
+ *    on wire]
+ */
+
+/* OpenVPN nonce size */
+#define NONCE_SIZE 12
+/* amount of bytes of the nonce received from user space */
+#define NONCE_TAIL_SIZE 8
+
+/* OpenVPN nonce size reduced by 8-byte nonce tail -- this is the
+ * size of the AEAD Associated Data (AD) sent over the wire
+ * and is normally the head of the IV
+ */
+#define NONCE_WIRE_SIZE (NONCE_SIZE - sizeof(struct ovpn_nonce_tail))
+
+/* If no packets received for this length of time, set a backtrack floor
+ * at highest received packet ID thus far.
+ */
+#define PKTID_RECV_EXPIRE (30 * HZ)
+
+/* Last 8 bytes of AEAD nonce
+ * Provided by userspace and usually derived from
+ * key material generated during TLS handshake
+ */
+struct ovpn_nonce_tail {
+	u8 u8[NONCE_TAIL_SIZE];
+};
+
+/* Packet-ID state for transmitter */
+struct ovpn_pktid_xmit {
+	atomic64_t seq_num;
+	struct ovpn_tcp_linear *tcp_linear;
+};
+
+/* replay window sizing in bytes = 2^REPLAY_WINDOW_ORDER */
+#define REPLAY_WINDOW_ORDER 8
+
+#define REPLAY_WINDOW_BYTES BIT(REPLAY_WINDOW_ORDER)
+#define REPLAY_WINDOW_SIZE  (REPLAY_WINDOW_BYTES * 8)
+#define REPLAY_INDEX(base, i) (((base) + (i)) & (REPLAY_WINDOW_SIZE - 1))
+
+/* Packet-ID state for receiver.
+ * Other than lock member, can be zeroed to initialize.
+ */
+struct ovpn_pktid_recv {
+	/* "sliding window" bitmask of recent packet IDs received */
+	u8 history[REPLAY_WINDOW_BYTES];
+	/* bit position of deque base in history */
+	unsigned int base;
+	/* extent (in bits) of deque in history */
+	unsigned int extent;
+	/* expiration of history in jiffies */
+	unsigned long expire;
+	/* highest sequence number received */
+	u32 id;
+	/* highest time stamp received */
+	u32 time;
+	/* we will only accept backtrack IDs > id_floor */
+	u32 id_floor;
+	unsigned int max_backtrack;
+	/* protects entire pktd ID state */
+	spinlock_t lock;
+};
+
+/* Get the next packet ID for xmit */
+static inline int ovpn_pktid_xmit_next(struct ovpn_pktid_xmit *pid, u32 *pktid)
+{
+	const s64 seq_num = atomic64_fetch_add_unless(&pid->seq_num, 1,
+						      0x100000000LL);
+	/* when the 32bit space is over, we return an error because the packet ID is used to create
+	 * the cipher IV and we do not want to re-use the same value more than once
+	 */
+	if (unlikely(seq_num == 0x100000000LL))
+		return -ERANGE;
+
+	*pktid = (u32)seq_num;
+
+	return 0;
+}
+
+/* Write 12-byte AEAD IV to dest */
+static inline void ovpn_pktid_aead_write(const u32 pktid,
+					 const struct ovpn_nonce_tail *nt,
+					 unsigned char *dest)
+{
+	*(__force __be32 *)(dest) = htonl(pktid);
+	BUILD_BUG_ON(4 + sizeof(struct ovpn_nonce_tail) != NONCE_SIZE);
+	memcpy(dest + 4, nt->u8, sizeof(struct ovpn_nonce_tail));
+}
+
+void ovpn_pktid_xmit_init(struct ovpn_pktid_xmit *pid);
+void ovpn_pktid_recv_init(struct ovpn_pktid_recv *pr);
+
+int ovpn_pktid_recv(struct ovpn_pktid_recv *pr, u32 pkt_id, u32 pkt_time);
+
+#endif /* _NET_OVPN_DCO_OVPNPKTID_H_ */
diff --git a/drivers/net/ovpn-dco/proto.h b/drivers/net/ovpn-dco/proto.h
new file mode 100644
index 000000000000..875529021c1b
--- /dev/null
+++ b/drivers/net/ovpn-dco/proto.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ *		James Yonan <james@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNPROTO_H_
+#define _NET_OVPN_DCO_OVPNPROTO_H_
+
+#include "main.h"
+
+#include <linux/skbuff.h>
+
+/* Methods for operating on the initial command
+ * byte of the OpenVPN protocol.
+ */
+
+/* packet opcode (high 5 bits) and key-id (low 3 bits) are combined in
+ * one byte
+ */
+#define OVPN_KEY_ID_MASK 0x07
+#define OVPN_OPCODE_SHIFT 3
+#define OVPN_OPCODE_MASK 0x1F
+/* upper bounds on opcode and key ID */
+#define OVPN_KEY_ID_MAX (OVPN_KEY_ID_MASK + 1)
+#define OVPN_OPCODE_MAX (OVPN_OPCODE_MASK + 1)
+/* packet opcodes of interest to us */
+#define OVPN_DATA_V1 6 /* data channel V1 packet */
+#define OVPN_DATA_V2 9 /* data channel V2 packet */
+/* size of initial packet opcode */
+#define OVPN_OP_SIZE_V1 1
+#define OVPN_OP_SIZE_V2	4
+#define OVPN_PEER_ID_MASK 0x00FFFFFF
+#define OVPN_PEER_ID_UNDEF 0x00FFFFFF
+/* first byte of keepalive message */
+#define OVPN_KEEPALIVE_FIRST_BYTE 0x2a
+/* first byte of exit message */
+#define OVPN_EXPLICIT_EXIT_NOTIFY_FIRST_BYTE 0x28
+
+/**
+ * Extract the OP code from the specified byte
+ *
+ * Return the OP code
+ */
+static inline u8 ovpn_opcode_from_byte(u8 byte)
+{
+	return byte >> OVPN_OPCODE_SHIFT;
+}
+
+/**
+ * Extract the OP code from the skb head.
+ *
+ * Note: this function assumes that the skb head was pulled enough
+ * to access the first byte.
+ *
+ * Return the OP code
+ */
+static inline u8 ovpn_opcode_from_skb(const struct sk_buff *skb, u16 offset)
+{
+	return ovpn_opcode_from_byte(*(skb->data + offset));
+}
+
+/**
+ * Extract the key ID from the skb head.
+ *
+ * Note: this function assumes that the skb head was pulled enough
+ * to access the first byte.
+ *
+ * Return the key ID
+ */
+
+static inline u8 ovpn_key_id_from_skb(const struct sk_buff *skb)
+{
+	return *skb->data & OVPN_KEY_ID_MASK;
+}
+
+/**
+ * Extract the peer ID from the skb head.
+ *
+ * Note: this function assumes that the skb head was pulled enough
+ * to access the first 4 bytes.
+ *
+ * Return the peer ID.
+ */
+
+static inline u32 ovpn_peer_id_from_skb(const struct sk_buff *skb, u16 offset)
+{
+	return ntohl(*(__be32 *)(skb->data + offset)) & OVPN_PEER_ID_MASK;
+}
+
+static inline u32 ovpn_opcode_compose(u8 opcode, u8 key_id, u32 peer_id)
+{
+	const u8 op = (opcode << OVPN_OPCODE_SHIFT) | (key_id & OVPN_KEY_ID_MASK);
+
+	return (op << 24) | (peer_id & OVPN_PEER_ID_MASK);
+}
+
+#endif /* _NET_OVPN_DCO_OVPNPROTO_H_ */
diff --git a/drivers/net/ovpn-dco/rcu.h b/drivers/net/ovpn-dco/rcu.h
new file mode 100644
index 000000000000..02a50f49ba2e
--- /dev/null
+++ b/drivers/net/ovpn-dco/rcu.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNRCU_H_
+#define _NET_OVPN_DCO_OVPNRCU_H_
+
+static inline void ovpn_rcu_lockdep_assert_held(void)
+{
+#ifdef CONFIG_PROVE_RCU
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "ovpn-dco RCU read lock not held");
+#endif
+}
+
+#endif /* _NET_OVPN_DCO_OVPNRCU_H_ */
diff --git a/drivers/net/ovpn-dco/skb.h b/drivers/net/ovpn-dco/skb.h
new file mode 100644
index 000000000000..d38dc2da01df
--- /dev/null
+++ b/drivers/net/ovpn-dco/skb.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ *		James Yonan <james@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_SKB_H_
+#define _NET_OVPN_DCO_SKB_H_
+
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/socket.h>
+#include <linux/types.h>
+
+#define OVPN_SKB_CB(skb) ((struct ovpn_skb_cb *)&((skb)->cb))
+
+struct ovpn_skb_cb {
+	/* original recv packet size for stats accounting */
+	unsigned int rx_stats_size;
+
+	union {
+		struct in_addr ipv4;
+		struct in6_addr ipv6;
+	} local;
+	sa_family_t sa_fam;
+};
+
+/* Return IP protocol version from skb header.
+ * Return 0 if protocol is not IPv4/IPv6 or cannot be read.
+ */
+static inline __be16 ovpn_ip_check_protocol(struct sk_buff *skb)
+{
+	__be16 proto = 0;
+
+	/* skb could be non-linear,
+	 * make sure IP header is in non-fragmented part
+	 */
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+		return 0;
+
+	if (ip_hdr(skb)->version == 4)
+		proto = htons(ETH_P_IP);
+	else if (ip_hdr(skb)->version == 6)
+		proto = htons(ETH_P_IPV6);
+
+	return proto;
+}
+
+#endif /* _NET_OVPN_DCO_SKB_H_ */
diff --git a/drivers/net/ovpn-dco/sock.c b/drivers/net/ovpn-dco/sock.c
new file mode 100644
index 000000000000..e92a4a9b952e
--- /dev/null
+++ b/drivers/net/ovpn-dco/sock.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "ovpn.h"
+#include "peer.h"
+#include "sock.h"
+#include "rcu.h"
+#include "tcp.h"
+#include "udp.h"
+
+#include <net/udp.h>
+#include <net/udp_tunnel.h>
+
+/* Finalize release of socket, called after RCU grace period */
+static void ovpn_socket_detach(struct socket *sock)
+{
+	if (!sock)
+		return;
+
+	if (sock->sk->sk_protocol == IPPROTO_UDP)
+		ovpn_udp_socket_detach(sock);
+	else if (sock->sk->sk_protocol == IPPROTO_TCP)
+		ovpn_tcp_socket_detach(sock);
+
+	sockfd_put(sock);
+}
+
+void ovpn_socket_release_kref(struct kref *kref)
+{
+	struct ovpn_socket *sock = container_of(kref, struct ovpn_socket, refcount);
+
+	ovpn_socket_detach(sock->sock);
+	kfree_rcu(sock, rcu);
+}
+
+static bool ovpn_socket_hold(struct ovpn_socket *sock)
+{
+	return kref_get_unless_zero(&sock->refcount);
+}
+
+static struct ovpn_socket *ovpn_socket_get(struct socket *sock)
+{
+	struct ovpn_socket *ovpn_sock;
+
+	rcu_read_lock();
+	ovpn_sock = rcu_dereference_sk_user_data(sock->sk);
+	if (!ovpn_socket_hold(ovpn_sock)) {
+		pr_warn("%s: found ovpn_socket with ref = 0\n", __func__);
+		ovpn_sock = NULL;
+	}
+	rcu_read_unlock();
+
+	return ovpn_sock;
+}
+
+/* Finalize release of socket, called after RCU grace period */
+static int ovpn_socket_attach(struct socket *sock, struct ovpn_peer *peer)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (!sock || !peer)
+		return -EINVAL;
+
+	if (sock->sk->sk_protocol == IPPROTO_UDP)
+		ret = ovpn_udp_socket_attach(sock, peer->ovpn);
+	else if (sock->sk->sk_protocol == IPPROTO_TCP)
+		ret = ovpn_tcp_socket_attach(sock, peer);
+
+	return ret;
+}
+
+struct ovpn_struct *ovpn_from_udp_sock(struct sock *sk)
+{
+	struct ovpn_socket *ovpn_sock;
+
+	ovpn_rcu_lockdep_assert_held();
+
+	if (unlikely(READ_ONCE(udp_sk(sk)->encap_type) != UDP_ENCAP_OVPNINUDP))
+		return NULL;
+
+	ovpn_sock = rcu_dereference_sk_user_data(sk);
+	if (unlikely(!ovpn_sock))
+		return NULL;
+
+	/* make sure that sk matches our stored transport socket */
+	if (unlikely(!ovpn_sock->sock || sk != ovpn_sock->sock->sk))
+		return NULL;
+
+	return ovpn_sock->ovpn;
+}
+
+struct ovpn_socket *ovpn_socket_new(struct socket *sock, struct ovpn_peer *peer)
+{
+	struct ovpn_socket *ovpn_sock;
+	int ret;
+
+	ret = ovpn_socket_attach(sock, peer);
+	if (ret < 0 && ret != -EALREADY)
+		return ERR_PTR(ret);
+
+	/* if this socket is already owned by this interface, just increase the refcounter */
+	if (ret == -EALREADY) {
+		/* caller is expected to increase the sock refcounter before passing it to this
+		 * function. For this reason we drop it if not needed, like when this socket is
+		 * already owned.
+		 */
+		ovpn_sock = ovpn_socket_get(sock);
+		sockfd_put(sock);
+		return ovpn_sock;
+	}
+
+	ovpn_sock = kzalloc(sizeof(*ovpn_sock), GFP_KERNEL);
+	if (!ovpn_sock)
+		return ERR_PTR(-ENOMEM);
+
+	ovpn_sock->ovpn = peer->ovpn;
+	ovpn_sock->sock = sock;
+	kref_init(&ovpn_sock->refcount);
+
+	/* TCP sockets are per-peer, therefore they are linked to their unique peer */
+	if (sock->sk->sk_protocol == IPPROTO_TCP)
+		ovpn_sock->peer = peer;
+
+	rcu_assign_sk_user_data(sock->sk, ovpn_sock);
+
+	return ovpn_sock;
+}
diff --git a/drivers/net/ovpn-dco/sock.h b/drivers/net/ovpn-dco/sock.h
new file mode 100644
index 000000000000..9e79c1b5fe04
--- /dev/null
+++ b/drivers/net/ovpn-dco/sock.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_SOCK_H_
+#define _NET_OVPN_DCO_SOCK_H_
+
+#include <linux/net.h>
+#include <linux/kref.h>
+#include <net/sock.h>
+
+#include "peer.h"
+
+struct ovpn_struct;
+
+/**
+ * struct ovpn_socket - a kernel socket referenced in the ovpn-dco code
+ */
+struct ovpn_socket {
+	union {
+		/** @ovpn: the VPN session object owning this socket (UDP only) */
+		struct ovpn_struct *ovpn;
+
+		/** @peer: the unique peer transmitting over this socket (TCP only) */
+		struct ovpn_peer *peer;
+	};
+
+	/** @sock: the kernel socket */
+	struct socket *sock;
+
+	/** @refcount: amount of contexts currently referencing this object */
+	struct kref refcount;
+
+	/** @rcu: member used to schedule RCU destructor callback */
+	struct rcu_head rcu;
+};
+
+struct ovpn_struct *ovpn_from_udp_sock(struct sock *sk);
+
+void ovpn_socket_release_kref(struct kref *kref);
+
+static inline void ovpn_socket_put(struct ovpn_socket *sock)
+{
+	kref_put(&sock->refcount, ovpn_socket_release_kref);
+}
+
+struct ovpn_socket *ovpn_socket_new(struct socket *sock, struct ovpn_peer *peer);
+
+#endif /* _NET_OVPN_DCO_SOCK_H_ */
diff --git a/drivers/net/ovpn-dco/stats.c b/drivers/net/ovpn-dco/stats.c
new file mode 100644
index 000000000000..ee000b2a2177
--- /dev/null
+++ b/drivers/net/ovpn-dco/stats.c
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "stats.h"
+
+void ovpn_peer_stats_init(struct ovpn_peer_stats *ps)
+{
+	atomic64_set(&ps->rx.bytes, 0);
+	atomic_set(&ps->rx.packets, 0);
+
+	atomic64_set(&ps->tx.bytes, 0);
+	atomic_set(&ps->tx.packets, 0);
+}
diff --git a/drivers/net/ovpn-dco/stats.h b/drivers/net/ovpn-dco/stats.h
new file mode 100644
index 000000000000..3aa6bdc049c6
--- /dev/null
+++ b/drivers/net/ovpn-dco/stats.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2020-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ *		Lev Stipakov <lev@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_OVPNSTATS_H_
+#define _NET_OVPN_DCO_OVPNSTATS_H_
+
+#include <linux/atomic.h>
+#include <linux/jiffies.h>
+
+struct ovpn_struct;
+
+/* per-peer stats, measured on transport layer */
+
+/* one stat */
+struct ovpn_peer_stat {
+	atomic64_t bytes;
+	atomic_t packets;
+};
+
+/* rx and tx stats, enabled by notify_per != 0 or period != 0 */
+struct ovpn_peer_stats {
+	struct ovpn_peer_stat rx;
+	struct ovpn_peer_stat tx;
+};
+
+/* struct for OVPN_ERR_STATS */
+
+struct ovpn_err_stat {
+	unsigned int category;
+	int errcode;
+	u64 count;
+};
+
+struct ovpn_err_stats {
+	/* total stats, returned by kovpn */
+	unsigned int total_stats;
+	/* number of stats dimensioned below */
+	unsigned int n_stats;
+	struct ovpn_err_stat stats[];
+};
+
+void ovpn_peer_stats_init(struct ovpn_peer_stats *ps);
+
+static inline void ovpn_peer_stats_increment(struct ovpn_peer_stat *stat, const unsigned int n)
+{
+	atomic64_add(n, &stat->bytes);
+	atomic_inc(&stat->packets);
+}
+
+static inline void ovpn_peer_stats_increment_rx(struct ovpn_peer_stats *stats, const unsigned int n)
+{
+	ovpn_peer_stats_increment(&stats->rx, n);
+}
+
+static inline void ovpn_peer_stats_increment_tx(struct ovpn_peer_stats *stats, const unsigned int n)
+{
+	ovpn_peer_stats_increment(&stats->tx, n);
+}
+
+#endif /* _NET_OVPN_DCO_OVPNSTATS_H_ */
diff --git a/drivers/net/ovpn-dco/tcp.c b/drivers/net/ovpn-dco/tcp.c
new file mode 100644
index 000000000000..a91174e88ccd
--- /dev/null
+++ b/drivers/net/ovpn-dco/tcp.c
@@ -0,0 +1,324 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "ovpnstruct.h"
+#include "ovpn.h"
+#include "peer.h"
+#include "skb.h"
+#include "tcp.h"
+
+#include <linux/ptr_ring.h>
+#include <linux/skbuff.h>
+#include <net/route.h>
+
+static void ovpn_tcp_state_change(struct sock *sk)
+{
+}
+
+static void ovpn_tcp_data_ready(struct sock *sk)
+{
+	struct ovpn_socket *sock;
+
+	rcu_read_lock();
+	sock = rcu_dereference_sk_user_data(sk);
+	rcu_read_unlock();
+
+	if (!sock || !sock->peer)
+		return;
+
+	queue_work(sock->peer->ovpn->events_wq, &sock->peer->tcp.rx_work);
+}
+
+static void ovpn_tcp_write_space(struct sock *sk)
+{
+	struct ovpn_socket *sock;
+
+	rcu_read_lock();
+	sock = rcu_dereference_sk_user_data(sk);
+	rcu_read_unlock();
+
+	if (!sock || !sock->peer)
+		return;
+
+	queue_work(sock->peer->ovpn->events_wq, &sock->peer->tcp.tx_work);
+}
+
+static void ovpn_destroy_skb(void *skb)
+{
+	consume_skb(skb);
+}
+
+void ovpn_tcp_socket_detach(struct socket *sock)
+{
+	struct ovpn_socket *ovpn_sock;
+	struct ovpn_peer *peer;
+
+	if (!sock)
+		return;
+
+	rcu_read_lock();
+	ovpn_sock = rcu_dereference_sk_user_data(sock->sk);
+	rcu_read_unlock();
+
+	if (!ovpn_sock->peer)
+		return;
+
+	peer = ovpn_sock->peer;
+
+	/* restore CBs that were saved in ovpn_sock_set_tcp_cb() */
+	write_lock_bh(&sock->sk->sk_callback_lock);
+	sock->sk->sk_state_change = peer->tcp.sk_cb.sk_state_change;
+	sock->sk->sk_data_ready = peer->tcp.sk_cb.sk_data_ready;
+	sock->sk->sk_write_space = peer->tcp.sk_cb.sk_write_space;
+	rcu_assign_sk_user_data(sock->sk, NULL);
+	write_unlock_bh(&sock->sk->sk_callback_lock);
+
+	/* cancel any ongoing work. Done after removing the CBs so that these workers cannot be
+	 * re-armed
+	 */
+	cancel_work_sync(&peer->tcp.tx_work);
+	cancel_work_sync(&peer->tcp.rx_work);
+
+	ptr_ring_cleanup(&peer->tcp.tx_ring, ovpn_destroy_skb);
+}
+
+/* Try to send one skb (or part of it) over the TCP stream.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ *
+ * Note that the skb is modified by putting away the data being sent, therefore
+ * the caller should check if skb->len is zero to understand if the full skb was
+ * sent or not.
+ */
+static int ovpn_tcp_send_one(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL };
+	struct kvec iv = { 0 };
+	int ret;
+
+	if (skb_linearize(skb) < 0) {
+		pr_err_ratelimited("%s: can't linearize packet\n", __func__);
+		return -ENOMEM;
+	}
+
+	/* initialize iv structure now as skb_linearize() may have changed skb->data */
+	iv.iov_base = skb->data;
+	iv.iov_len = skb->len;
+
+	ret = kernel_sendmsg(peer->sock->sock, &msg, &iv, 1, iv.iov_len);
+	if (ret > 0) {
+		__skb_pull(skb, ret);
+
+		/* since we update per-cpu stats in process context,
+		 * we need to disable softirqs
+		 */
+		local_bh_disable();
+		dev_sw_netstats_tx_add(peer->ovpn->dev, 1, ret);
+		local_bh_enable();
+
+		return 0;
+	}
+
+	return ret;
+}
+
+/* Process packets in TCP TX queue */
+static void ovpn_tcp_tx_work(struct work_struct *work)
+{
+	struct ovpn_peer *peer;
+	struct sk_buff *skb;
+	int ret;
+
+	peer = container_of(work, struct ovpn_peer, tcp.tx_work);
+	while ((skb = __ptr_ring_peek(&peer->tcp.tx_ring))) {
+		ret = ovpn_tcp_send_one(peer, skb);
+		if (ret < 0 && ret != -EAGAIN) {
+			pr_warn_ratelimited("%s: cannot send TCP packet to peer %u: %d\n", __func__,
+					    peer->id, ret);
+			/* in case of TCP error stop sending loop and delete peer */
+			ovpn_peer_del(peer, OVPN_DEL_PEER_REASON_TRANSPORT_ERROR);
+			break;
+		} else if (!skb->len) {
+			/* skb was entirely consumed and can now be removed from the ring */
+			__ptr_ring_discard_one(&peer->tcp.tx_ring);
+			consume_skb(skb);
+		}
+
+		/* give a chance to be rescheduled if needed */
+		cond_resched();
+	}
+}
+
+static int ovpn_tcp_rx_one(struct ovpn_peer *peer)
+{
+	struct msghdr msg = { .msg_flags = MSG_DONTWAIT | MSG_NOSIGNAL };
+	struct ovpn_skb_cb *cb;
+	int status, ret;
+
+	/* no skb allocated means that we have to read (or finish reading) the 2 bytes prefix
+	 * containing the actual packet size.
+	 */
+	if (!peer->tcp.skb) {
+		struct kvec iv = {
+			.iov_base = peer->tcp.raw_len + peer->tcp.offset,
+			.iov_len = sizeof(u16) - peer->tcp.offset,
+		};
+
+		ret = kernel_recvmsg(peer->sock->sock, &msg, &iv, 1, iv.iov_len, msg.msg_flags);
+		if (ret <= 0)
+			return ret;
+
+		peer->tcp.offset += ret;
+		/* the entire packet size was read, prepare skb for reading data */
+		if (peer->tcp.offset == sizeof(u16)) {
+			u16 len = ntohs(*(__be16 *)peer->tcp.raw_len);
+			/* invalid packet length: this is a fatal TCP error */
+			if (!len) {
+				pr_err("%s: received invalid packet length\n", __func__);
+				return -EINVAL;
+			}
+
+			peer->tcp.skb = netdev_alloc_skb_ip_align(peer->ovpn->dev, len);
+			peer->tcp.offset = 0;
+			peer->tcp.data_len = len;
+		}
+	} else {
+		struct kvec iv = {
+			.iov_base = peer->tcp.skb->data + peer->tcp.offset,
+			.iov_len = peer->tcp.data_len - peer->tcp.offset,
+		};
+
+		ret = kernel_recvmsg(peer->sock->sock, &msg, &iv, 1, iv.iov_len, msg.msg_flags);
+		if (ret <= 0)
+			return ret;
+
+		peer->tcp.offset += ret;
+		/* full packet received, send it up for processing */
+		if (peer->tcp.offset == peer->tcp.data_len) {
+			/* update the skb data structure with the amount of data written by
+			 * kernel_recvmsg()
+			 */
+			skb_put(peer->tcp.skb, peer->tcp.data_len);
+
+			/* do not perform IP caching for TCP connections */
+			cb = OVPN_SKB_CB(peer->tcp.skb);
+			cb->sa_fam = AF_UNSPEC;
+
+			/* hold reference to peer as requird by ovpn_recv() */
+			ovpn_peer_hold(peer);
+			status = ovpn_recv(peer->ovpn, peer, peer->tcp.skb);
+			/* skb not consumed - free it now */
+			if (unlikely(status < 0))
+				kfree_skb(peer->tcp.skb);
+
+			peer->tcp.skb = NULL;
+			peer->tcp.offset = 0;
+			peer->tcp.data_len = 0;
+		}
+	}
+
+	return ret;
+}
+
+static void ovpn_tcp_rx_work(struct work_struct *work)
+{
+	struct ovpn_peer *peer = container_of(work, struct ovpn_peer, tcp.rx_work);
+	int ret;
+
+	while (true) {
+		/* give a chance to be rescheduled if needed */
+		cond_resched();
+
+		ret = ovpn_tcp_rx_one(peer);
+		if (ret <= 0)
+			break;
+	}
+
+	if (ret < 0 && ret != -EAGAIN)
+		pr_err("%s: TCP socket error: %d\n", __func__, ret);
+}
+
+/* Put packet into TCP TX queue and schedule a consumer */
+void ovpn_queue_tcp_skb(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	int ret;
+
+	ret = ptr_ring_produce_bh(&peer->tcp.tx_ring, skb);
+	if (ret < 0) {
+		kfree_skb_list(skb);
+		return;
+	}
+
+	queue_work(peer->ovpn->events_wq, &peer->tcp.tx_work);
+}
+
+/* Set TCP encapsulation callbacks */
+int ovpn_tcp_socket_attach(struct socket *sock, struct ovpn_peer *peer)
+{
+	void *old_data;
+	int ret;
+
+	INIT_WORK(&peer->tcp.tx_work, ovpn_tcp_tx_work);
+	INIT_WORK(&peer->tcp.rx_work, ovpn_tcp_rx_work);
+
+	ret = ptr_ring_init(&peer->tcp.tx_ring, OVPN_QUEUE_LEN, GFP_KERNEL);
+	if (ret < 0) {
+		pr_err("cannot allocate TCP TX ring\n");
+		return ret;
+	}
+
+	peer->tcp.skb = NULL;
+	peer->tcp.offset = 0;
+	peer->tcp.data_len = 0;
+
+	write_lock_bh(&sock->sk->sk_callback_lock);
+
+	/* make sure no pre-existing encapsulation handler exists */
+	rcu_read_lock();
+	old_data = rcu_dereference_sk_user_data(sock->sk);
+	rcu_read_unlock();
+	if (old_data) {
+		pr_err("provided socket already taken by other user\n");
+		ret = -EBUSY;
+		goto err;
+	}
+
+	/* sanity check */
+	if (sock->sk->sk_protocol != IPPROTO_TCP) {
+		pr_err("expected TCP socket\n");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* only a fully connected socket are expected. Connection should be handled in userspace */
+	if (sock->sk->sk_state != TCP_ESTABLISHED) {
+		pr_err("unexpected state for TCP socket: %d\n", sock->sk->sk_state);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* save current CBs so that they can be restored upon socket release */
+	peer->tcp.sk_cb.sk_state_change = sock->sk->sk_state_change;
+	peer->tcp.sk_cb.sk_data_ready = sock->sk->sk_data_ready;
+	peer->tcp.sk_cb.sk_write_space = sock->sk->sk_write_space;
+
+	/* assign our static CBs */
+	sock->sk->sk_state_change = ovpn_tcp_state_change;
+	sock->sk->sk_data_ready = ovpn_tcp_data_ready;
+	sock->sk->sk_write_space = ovpn_tcp_write_space;
+
+	write_unlock_bh(&sock->sk->sk_callback_lock);
+
+	return 0;
+err:
+	write_unlock_bh(&sock->sk->sk_callback_lock);
+	ptr_ring_cleanup(&peer->tcp.tx_ring, NULL);
+
+	return ret;
+}
diff --git a/drivers/net/ovpn-dco/tcp.h b/drivers/net/ovpn-dco/tcp.h
new file mode 100644
index 000000000000..d243a8e1c34e
--- /dev/null
+++ b/drivers/net/ovpn-dco/tcp.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_TCP_H_
+#define _NET_OVPN_DCO_TCP_H_
+
+#include "peer.h"
+
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+void ovpn_queue_tcp_skb(struct ovpn_peer *peer, struct sk_buff *skb);
+
+int ovpn_tcp_socket_attach(struct socket *sock, struct ovpn_peer *peer);
+void ovpn_tcp_socket_detach(struct socket *sock);
+
+/* Prepare skb and enqueue it for sending to peer.
+ *
+ * Preparation consist in prepending the skb payload with its size.
+ * Required by the OpenVPN protocol in order to extract packets from
+ * the TCP stream on the receiver side.
+ */
+static inline void ovpn_tcp_send_skb(struct ovpn_peer *peer, struct sk_buff *skb)
+{
+	u16 len = skb->len;
+
+	*(__be16 *)__skb_push(skb, sizeof(u16)) = htons(len);
+	ovpn_queue_tcp_skb(peer, skb);
+}
+
+#endif /* _NET_OVPN_DCO_TCP_H_ */
diff --git a/drivers/net/ovpn-dco/udp.c b/drivers/net/ovpn-dco/udp.c
new file mode 100644
index 000000000000..3517d083a31d
--- /dev/null
+++ b/drivers/net/ovpn-dco/udp.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#include "main.h"
+#include "bind.h"
+#include "ovpn.h"
+#include "ovpnstruct.h"
+#include "peer.h"
+#include "proto.h"
+#include "skb.h"
+#include "udp.h"
+
+#include <linux/inetdevice.h>
+#include <linux/skbuff.h>
+#include <linux/socket.h>
+#include <net/addrconf.h>
+#include <net/dst_cache.h>
+#include <net/route.h>
+#include <net/ipv6_stubs.h>
+#include <net/udp_tunnel.h>
+
+/**
+ * ovpn_udp_encap_recv() - Start processing a received UDP packet.
+ * If the first byte of the payload is DATA_V2, the packet is further processed,
+ * otherwise it is forwarded to the UDP stack for delivery to user space.
+ *
+ * @sk: the socket the packet was received on
+ * @skb: the sk_buff containing the actual packet
+ *
+ * Return codes:
+ *  0 : we consumed or dropped packet
+ * >0 : skb should be passed up to userspace as UDP (packet not consumed)
+ * <0 : skb should be resubmitted as proto -N (packet not consumed)
+ */
+static int ovpn_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
+{
+	struct ovpn_peer *peer = NULL;
+	struct ovpn_struct *ovpn;
+	u32 peer_id;
+	u8 opcode;
+	int ret;
+
+	ovpn = ovpn_from_udp_sock(sk);
+	if (unlikely(!ovpn)) {
+		pr_err_ratelimited("%s: cannot obtain ovpn object from UDP socket\n", __func__);
+		goto drop;
+	}
+
+	/* Make sure the first 4 bytes of the skb data buffer after the UDP header are accessible.
+	 * They are required to fetch the OP code, the key ID and the peer ID.
+	 */
+	if (unlikely(!pskb_may_pull(skb, sizeof(struct udphdr) + 4))) {
+		pr_debug_ratelimited("%s: packet too small\n", __func__);
+		goto drop;
+	}
+
+	opcode = ovpn_opcode_from_skb(skb, sizeof(struct udphdr));
+	if (likely(opcode == OVPN_DATA_V2)) {
+		peer_id = ovpn_peer_id_from_skb(skb, sizeof(struct udphdr));
+		/* some OpenVPN server implementations send data packets with the peer-id set to
+		 * undef. In this case we skip the peer lookup by peer-id and we try with the
+		 * transport address
+		 */
+		if (peer_id != OVPN_PEER_ID_UNDEF) {
+			peer = ovpn_peer_lookup_id(ovpn, peer_id);
+			if (!peer) {
+				pr_err_ratelimited("%s: received data from unknown peer (id: %d)\n",
+						   __func__, peer_id);
+				goto drop;
+			}
+
+			/* check if this peer changed it's IP address and update state */
+			ovpn_peer_float(peer, skb);
+		}
+	}
+
+	if (!peer) {
+		/* might be a control packet or a data packet with undef peer-id */
+		peer = ovpn_peer_lookup_transp_addr(ovpn, skb);
+		if (unlikely(!peer)) {
+			if (opcode != OVPN_DATA_V2) {
+				pr_debug("%s: control packet from unknown peer, sending to userspace",
+					 __func__);
+				return 1;
+			}
+
+			pr_debug("%s: received data with undef peer-id from unknown source\n",
+				 __func__);
+			goto drop;
+		}
+	}
+
+	/* pop off outer UDP header */
+	__skb_pull(skb, sizeof(struct udphdr));
+
+	ret = ovpn_recv(ovpn, peer, skb);
+	if (unlikely(ret < 0)) {
+		pr_err_ratelimited("%s: cannot handle incoming packet: %d\n", __func__, ret);
+		goto drop;
+	}
+
+	/* should this be a non DATA_V2 packet, ret will be >0 and this will instruct the UDP
+	 * stack to continue processing this packet as usual (i.e. deliver to user space)
+	 */
+	return ret;
+
+drop:
+	if (peer)
+		ovpn_peer_put(peer);
+	kfree_skb(skb);
+	return 0;
+}
+
+static int ovpn_udp4_output(struct ovpn_struct *ovpn, struct ovpn_bind *bind,
+			    struct dst_cache *cache, struct sock *sk,
+			    struct sk_buff *skb)
+{
+	struct rtable *rt;
+	struct flowi4 fl = {
+		.saddr = bind->local.ipv4.s_addr,
+		.daddr = bind->sa.in4.sin_addr.s_addr,
+		.fl4_sport = inet_sk(sk)->inet_sport,
+		.fl4_dport = bind->sa.in4.sin_port,
+		.flowi4_proto = sk->sk_protocol,
+		.flowi4_mark = sk->sk_mark,
+	};
+	int ret;
+
+	local_bh_disable();
+	rt = dst_cache_get_ip4(cache, &fl.saddr);
+	if (rt)
+		goto transmit;
+
+	if (unlikely(!inet_confirm_addr(sock_net(sk), NULL, 0, fl.saddr, RT_SCOPE_HOST))) {
+		/* we may end up here when the cached address is not usable anymore.
+		 * In this case we reset address/cache and perform a new look up
+		 */
+		fl.saddr = 0;
+		bind->local.ipv4.s_addr = 0;
+		dst_cache_reset(cache);
+	}
+
+	rt = ip_route_output_flow(sock_net(sk), &fl, sk);
+	if (IS_ERR(rt) && PTR_ERR(rt) == -EINVAL) {
+		fl.saddr = 0;
+		bind->local.ipv4.s_addr = 0;
+		dst_cache_reset(cache);
+
+		rt = ip_route_output_flow(sock_net(sk), &fl, sk);
+	}
+
+	if (IS_ERR(rt)) {
+		ret = PTR_ERR(rt);
+		net_dbg_ratelimited("%s: no route to host %pISpc: %d\n", ovpn->dev->name,
+				    &bind->sa.in4, ret);
+		goto err;
+	}
+	dst_cache_set_ip4(cache, &rt->dst, fl.saddr);
+
+transmit:
+	udp_tunnel_xmit_skb(rt, sk, skb, fl.saddr, fl.daddr, 0,
+			    ip4_dst_hoplimit(&rt->dst), 0, fl.fl4_sport,
+			    fl.fl4_dport, false, sk->sk_no_check_tx);
+	ret = 0;
+err:
+	local_bh_enable();
+	return ret;
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+static int ovpn_udp6_output(struct ovpn_struct *ovpn, struct ovpn_bind *bind,
+			    struct dst_cache *cache, struct sock *sk,
+			    struct sk_buff *skb)
+{
+	struct dst_entry *dst;
+	int ret;
+
+	struct flowi6 fl = {
+		.saddr = bind->local.ipv6,
+		.daddr = bind->sa.in6.sin6_addr,
+		.fl6_sport = inet_sk(sk)->inet_sport,
+		.fl6_dport = bind->sa.in6.sin6_port,
+		.flowi6_proto = sk->sk_protocol,
+		.flowi6_mark = sk->sk_mark,
+		.flowi6_oif = bind->sa.in6.sin6_scope_id,
+	};
+
+	local_bh_disable();
+	dst = dst_cache_get_ip6(cache, &fl.saddr);
+	if (dst)
+		goto transmit;
+
+	if (unlikely(!ipv6_chk_addr(sock_net(sk), &fl.saddr, NULL, 0))) {
+		/* we may end up here when the cached address is not usable anymore.
+		 * In this case we reset address/cache and perform a new look up
+		 */
+		fl.saddr = in6addr_any;
+		bind->local.ipv6 = in6addr_any;
+		dst_cache_reset(cache);
+	}
+
+	dst = ipv6_stub->ipv6_dst_lookup_flow(sock_net(sk), sk, &fl, NULL);
+	if (IS_ERR(dst)) {
+		ret = PTR_ERR(dst);
+		net_dbg_ratelimited("%s: no route to host %pISpc: %d\n", ovpn->dev->name,
+				    &bind->sa.in6, ret);
+		goto err;
+	}
+	dst_cache_set_ip6(cache, dst, &fl.saddr);
+
+transmit:
+	udp_tunnel6_xmit_skb(dst, sk, skb, skb->dev, &fl.saddr, &fl.daddr, 0,
+			     ip6_dst_hoplimit(dst), 0, fl.fl6_sport,
+			     fl.fl6_dport, udp_get_no_check6_tx(sk));
+	ret = 0;
+err:
+	local_bh_enable();
+	return ret;
+}
+#endif
+
+/* Transmit skb utilizing kernel-provided UDP tunneling framework.
+ *
+ * rcu_read_lock should be held on entry.
+ * On return, the skb is consumed.
+ */
+static int ovpn_udp_output(struct ovpn_struct *ovpn, struct ovpn_bind *bind,
+			   struct dst_cache *cache, struct sock *sk,
+			   struct sk_buff *skb)
+{
+	int ret;
+
+	ovpn_rcu_lockdep_assert_held();
+
+	/* set sk to null if skb is already orphaned */
+	if (!skb->destructor)
+		skb->sk = NULL;
+
+	switch (bind->sa.in4.sin_family) {
+	case AF_INET:
+		ret = ovpn_udp4_output(ovpn, bind, cache, sk, skb);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		ret = ovpn_udp6_output(ovpn, bind, cache, sk, skb);
+		break;
+#endif
+	default:
+		ret = -EAFNOSUPPORT;
+		break;
+	}
+
+	return ret;
+}
+
+void ovpn_udp_send_skb(struct ovpn_struct *ovpn, struct ovpn_peer *peer,
+		       struct sk_buff *skb)
+{
+	struct ovpn_bind *bind;
+	struct socket *sock;
+	int ret = -1;
+
+	skb->dev = ovpn->dev;
+	/* no checksum performed at this layer */
+	skb->ip_summed = CHECKSUM_NONE;
+
+	/* get socket info */
+	sock = peer->sock->sock;
+	if (unlikely(!sock)) {
+		pr_debug_ratelimited("%s: no sock for remote peer\n", __func__);
+		goto out;
+	}
+
+	rcu_read_lock();
+	/* get binding */
+	bind = rcu_dereference(peer->bind);
+	if (unlikely(!bind)) {
+		pr_debug_ratelimited("%s: no bind for remote peer\n", __func__);
+		goto out_unlock;
+	}
+
+	/* crypto layer -> transport (UDP) */
+	ret = ovpn_udp_output(ovpn, bind, &peer->dst_cache, sock->sk, skb);
+
+out_unlock:
+	rcu_read_unlock();
+out:
+	if (ret < 0)
+		kfree_skb(skb);
+}
+
+/* Set UDP encapsulation callbacks */
+int ovpn_udp_socket_attach(struct socket *sock, struct ovpn_struct *ovpn)
+{
+	struct udp_tunnel_sock_cfg cfg = {
+		.sk_user_data = ovpn,
+		.encap_type = UDP_ENCAP_OVPNINUDP,
+		.encap_rcv = ovpn_udp_encap_recv,
+	};
+	struct ovpn_socket *old_data;
+
+	/* sanity check */
+	if (sock->sk->sk_protocol != IPPROTO_UDP) {
+		pr_err("%s: expected UDP socket\n", __func__);
+		return -EINVAL;
+	}
+
+	/* make sure no pre-existing encapsulation handler exists */
+	rcu_read_lock();
+	old_data = rcu_dereference_sk_user_data(sock->sk);
+	rcu_read_unlock();
+	if (old_data) {
+		if (old_data->ovpn == ovpn) {
+			pr_debug("%s: provided socket already owned by this interface\n", __func__);
+			return -EALREADY;
+		}
+
+		pr_err("%s: provided socket already taken by other user\n", __func__);
+		return -EBUSY;
+	}
+
+	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &cfg);
+
+	return 0;
+}
+
+/* Detach socket from encapsulation handler and/or other callbacks */
+void ovpn_udp_socket_detach(struct socket *sock)
+{
+	struct udp_tunnel_sock_cfg cfg = { };
+
+	setup_udp_tunnel_sock(sock_net(sock->sk), sock, &cfg);
+}
diff --git a/drivers/net/ovpn-dco/udp.h b/drivers/net/ovpn-dco/udp.h
new file mode 100644
index 000000000000..be94fb74669b
--- /dev/null
+++ b/drivers/net/ovpn-dco/udp.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _NET_OVPN_DCO_UDP_H_
+#define _NET_OVPN_DCO_UDP_H_
+
+#include "peer.h"
+#include "ovpnstruct.h"
+
+#include <linux/net.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/sock.h>
+
+int ovpn_udp_socket_attach(struct socket *sock, struct ovpn_struct *ovpn);
+void ovpn_udp_socket_detach(struct socket *sock);
+void ovpn_udp_send_skb(struct ovpn_struct *ovpn, struct ovpn_peer *peer,
+		       struct sk_buff *skb);
+
+#endif /* _NET_OVPN_DCO_UDP_H_ */
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 7a2a9d3144ba..335f44871529 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -441,6 +441,7 @@ struct nla_policy {
 	.max = _len						\
 }
 #define NLA_POLICY_MIN_LEN(_len)	NLA_POLICY_MIN(NLA_BINARY, _len)
+#define NLA_POLICY_MAX_LEN(_len)	NLA_POLICY_MAX(NLA_BINARY, _len)
 
 /**
  * struct nl_info - netlink source information
diff --git a/include/uapi/linux/ovpn_dco.h b/include/uapi/linux/ovpn_dco.h
new file mode 100644
index 000000000000..6afee8b3fedd
--- /dev/null
+++ b/include/uapi/linux/ovpn_dco.h
@@ -0,0 +1,265 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ *  OpenVPN data channel accelerator
+ *
+ *  Copyright (C) 2019-2022 OpenVPN, Inc.
+ *
+ *  Author:	James Yonan <james@openvpn.net>
+ *		Antonio Quartulli <antonio@openvpn.net>
+ */
+
+#ifndef _UAPI_LINUX_OVPN_DCO_H_
+#define _UAPI_LINUX_OVPN_DCO_H_
+
+#define OVPN_NL_NAME "ovpn-dco"
+
+#define OVPN_NL_MULTICAST_GROUP_PEERS "peers"
+
+/**
+ * enum ovpn_nl_commands - supported netlink commands
+ */
+enum ovpn_nl_commands {
+	/**
+	 * @OVPN_CMD_UNSPEC: unspecified command to catch errors
+	 */
+	OVPN_CMD_UNSPEC = 0,
+
+	/**
+	 * @OVPN_CMD_NEW_PEER: Configure peer with its crypto keys
+	 */
+	OVPN_CMD_NEW_PEER,
+
+	/**
+	 * @OVPN_CMD_SET_PEER: Tweak parameters for an existing peer
+	 */
+	OVPN_CMD_SET_PEER,
+
+	/**
+	 * @OVPN_CMD_DEL_PEER: Remove peer from internal table
+	 */
+	OVPN_CMD_DEL_PEER,
+
+	OVPN_CMD_NEW_KEY,
+
+	OVPN_CMD_SWAP_KEYS,
+
+	OVPN_CMD_DEL_KEY,
+
+	/**
+	 * @OVPN_CMD_REGISTER_PACKET: Register for specific packet types to be
+	 * forwarded to userspace
+	 */
+	OVPN_CMD_REGISTER_PACKET,
+
+	/**
+	 * @OVPN_CMD_PACKET: Send a packet from userspace to kernelspace. Also
+	 * used to send to userspace packets for which a process had registered
+	 * with OVPN_CMD_REGISTER_PACKET
+	 */
+	OVPN_CMD_PACKET,
+
+	/**
+	 * @OVPN_CMD_GET_PEER: Retrieve the status of a peer or all peers
+	 */
+	OVPN_CMD_GET_PEER,
+};
+
+enum ovpn_cipher_alg {
+	/**
+	 * @OVPN_CIPHER_ALG_NONE: No encryption - reserved for debugging only
+	 */
+	OVPN_CIPHER_ALG_NONE = 0,
+	/**
+	 * @OVPN_CIPHER_ALG_AES_GCM: AES-GCM AEAD cipher with any allowed key size
+	 */
+	OVPN_CIPHER_ALG_AES_GCM,
+	/**
+	 * @OVPN_CIPHER_ALG_CHACHA20_POLY1305: ChaCha20Poly1305 AEAD cipher
+	 */
+	OVPN_CIPHER_ALG_CHACHA20_POLY1305,
+};
+
+enum ovpn_del_peer_reason {
+	__OVPN_DEL_PEER_REASON_FIRST,
+	OVPN_DEL_PEER_REASON_TEARDOWN = __OVPN_DEL_PEER_REASON_FIRST,
+	OVPN_DEL_PEER_REASON_USERSPACE,
+	OVPN_DEL_PEER_REASON_EXPIRED,
+	OVPN_DEL_PEER_REASON_TRANSPORT_ERROR,
+	__OVPN_DEL_PEER_REASON_AFTER_LAST
+};
+
+enum ovpn_key_slot {
+	__OVPN_KEY_SLOT_FIRST,
+	OVPN_KEY_SLOT_PRIMARY = __OVPN_KEY_SLOT_FIRST,
+	OVPN_KEY_SLOT_SECONDARY,
+	__OVPN_KEY_SLOT_AFTER_LAST,
+};
+
+enum ovpn_netlink_attrs {
+	OVPN_ATTR_UNSPEC = 0,
+	OVPN_ATTR_IFINDEX,
+	OVPN_ATTR_NEW_PEER,
+	OVPN_ATTR_SET_PEER,
+	OVPN_ATTR_DEL_PEER,
+	OVPN_ATTR_NEW_KEY,
+	OVPN_ATTR_SWAP_KEYS,
+	OVPN_ATTR_DEL_KEY,
+	OVPN_ATTR_PACKET,
+	OVPN_ATTR_GET_PEER,
+
+	__OVPN_ATTR_AFTER_LAST,
+	OVPN_ATTR_MAX = __OVPN_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_key_dir_attrs {
+	OVPN_KEY_DIR_ATTR_UNSPEC = 0,
+	OVPN_KEY_DIR_ATTR_CIPHER_KEY,
+	OVPN_KEY_DIR_ATTR_NONCE_TAIL,
+
+	__OVPN_KEY_DIR_ATTR_AFTER_LAST,
+	OVPN_KEY_DIR_ATTR_MAX = __OVPN_KEY_DIR_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_new_key_attrs {
+	OVPN_NEW_KEY_ATTR_UNSPEC = 0,
+	OVPN_NEW_KEY_ATTR_PEER_ID,
+	OVPN_NEW_KEY_ATTR_KEY_SLOT,
+	OVPN_NEW_KEY_ATTR_KEY_ID,
+	OVPN_NEW_KEY_ATTR_CIPHER_ALG,
+	OVPN_NEW_KEY_ATTR_ENCRYPT_KEY,
+	OVPN_NEW_KEY_ATTR_DECRYPT_KEY,
+
+	__OVPN_NEW_KEY_ATTR_AFTER_LAST,
+	OVPN_NEW_KEY_ATTR_MAX = __OVPN_NEW_KEY_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_del_key_attrs {
+	OVPN_DEL_KEY_ATTR_UNSPEC = 0,
+	OVPN_DEL_KEY_ATTR_PEER_ID,
+	OVPN_DEL_KEY_ATTR_KEY_SLOT,
+
+	__OVPN_DEL_KEY_ATTR_AFTER_LAST,
+	OVPN_DEL_KEY_ATTR_MAX = __OVPN_DEL_KEY_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_swap_keys_attrs {
+	OVPN_SWAP_KEYS_ATTR_UNSPEC = 0,
+	OVPN_SWAP_KEYS_ATTR_PEER_ID,
+
+	__OVPN_SWAP_KEYS_ATTR_AFTER_LAST,
+	OVPN_SWAP_KEYS_ATTR_MAX = __OVPN_SWAP_KEYS_ATTR_AFTER_LAST - 1,
+
+};
+
+enum ovpn_netlink_new_peer_attrs {
+	OVPN_NEW_PEER_ATTR_UNSPEC = 0,
+	OVPN_NEW_PEER_ATTR_PEER_ID,
+	OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE,
+	OVPN_NEW_PEER_ATTR_SOCKET,
+	OVPN_NEW_PEER_ATTR_IPV4,
+	OVPN_NEW_PEER_ATTR_IPV6,
+	OVPN_NEW_PEER_ATTR_LOCAL_IP,
+
+	__OVPN_NEW_PEER_ATTR_AFTER_LAST,
+	OVPN_NEW_PEER_ATTR_MAX = __OVPN_NEW_PEER_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_set_peer_attrs {
+	OVPN_SET_PEER_ATTR_UNSPEC = 0,
+	OVPN_SET_PEER_ATTR_PEER_ID,
+	OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL,
+	OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT,
+
+	__OVPN_SET_PEER_ATTR_AFTER_LAST,
+	OVPN_SET_PEER_ATTR_MAX = __OVPN_SET_PEER_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_del_peer_attrs {
+	OVPN_DEL_PEER_ATTR_UNSPEC = 0,
+	OVPN_DEL_PEER_ATTR_REASON,
+	OVPN_DEL_PEER_ATTR_PEER_ID,
+
+	__OVPN_DEL_PEER_ATTR_AFTER_LAST,
+	OVPN_DEL_PEER_ATTR_MAX = __OVPN_DEL_PEER_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_get_peer_attrs {
+	OVPN_GET_PEER_ATTR_UNSPEC = 0,
+	OVPN_GET_PEER_ATTR_PEER_ID,
+
+	__OVPN_GET_PEER_ATTR_AFTER_LAST,
+	OVPN_GET_PEER_ATTR_MAX = __OVPN_GET_PEER_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_get_peer_response_attrs {
+	OVPN_GET_PEER_RESP_ATTR_UNSPEC = 0,
+	OVPN_GET_PEER_RESP_ATTR_PEER_ID,
+	OVPN_GET_PEER_RESP_ATTR_SOCKADDR_REMOTE,
+	OVPN_GET_PEER_RESP_ATTR_IPV4,
+	OVPN_GET_PEER_RESP_ATTR_IPV6,
+	OVPN_GET_PEER_RESP_ATTR_LOCAL_IP,
+	OVPN_GET_PEER_RESP_ATTR_LOCAL_PORT,
+	OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_INTERVAL,
+	OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_TIMEOUT,
+	OVPN_GET_PEER_RESP_ATTR_RX_BYTES,
+	OVPN_GET_PEER_RESP_ATTR_TX_BYTES,
+	OVPN_GET_PEER_RESP_ATTR_RX_PACKETS,
+	OVPN_GET_PEER_RESP_ATTR_TX_PACKETS,
+
+	__OVPN_GET_PEER_RESP_ATTR_AFTER_LAST,
+	OVPN_GET_PEER_RESP_ATTR_MAX = __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_peer_stats_attrs {
+	OVPN_PEER_STATS_ATTR_UNSPEC = 0,
+	OVPN_PEER_STATS_BYTES,
+	OVPN_PEER_STATS_PACKETS,
+
+	__OVPN_PEER_STATS_ATTR_AFTER_LAST,
+	OVPN_PEER_STATS_ATTR_MAX = __OVPN_PEER_STATS_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_peer_attrs {
+	OVPN_PEER_ATTR_UNSPEC = 0,
+	OVPN_PEER_ATTR_PEER_ID,
+	OVPN_PEER_ATTR_SOCKADDR_REMOTE,
+	OVPN_PEER_ATTR_IPV4,
+	OVPN_PEER_ATTR_IPV6,
+	OVPN_PEER_ATTR_LOCAL_IP,
+	OVPN_PEER_ATTR_KEEPALIVE_INTERVAL,
+	OVPN_PEER_ATTR_KEEPALIVE_TIMEOUT,
+	OVPN_PEER_ATTR_ENCRYPT_KEY,
+	OVPN_PEER_ATTR_DECRYPT_KEY,
+	OVPN_PEER_ATTR_RX_STATS,
+	OVPN_PEER_ATTR_TX_STATS,
+
+	__OVPN_PEER_ATTR_AFTER_LAST,
+	OVPN_PEER_ATTR_MAX = __OVPN_PEER_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_netlink_packet_attrs {
+	OVPN_PACKET_ATTR_UNSPEC = 0,
+	OVPN_PACKET_ATTR_PACKET,
+	OVPN_PACKET_ATTR_PEER_ID,
+
+	__OVPN_PACKET_ATTR_AFTER_LAST,
+	OVPN_PACKET_ATTR_MAX = __OVPN_PACKET_ATTR_AFTER_LAST - 1,
+};
+
+enum ovpn_ifla_attrs {
+	IFLA_OVPN_UNSPEC = 0,
+	IFLA_OVPN_MODE,
+
+	__IFLA_OVPN_AFTER_LAST,
+	IFLA_OVPN_MAX = __IFLA_OVPN_AFTER_LAST - 1,
+};
+
+enum ovpn_mode {
+	__OVPN_MODE_FIRST = 0,
+	OVPN_MODE_P2P = __OVPN_MODE_FIRST,
+	OVPN_MODE_MP,
+
+	__OVPN_MODE_AFTER_LAST,
+};
+
+#endif /* _UAPI_LINUX_OVPN_DCO_H_ */
diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
index 4828794efcf8..8008c762e6b8 100644
--- a/include/uapi/linux/udp.h
+++ b/include/uapi/linux/udp.h
@@ -43,5 +43,6 @@ struct udphdr {
 #define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
 #define UDP_ENCAP_RXRPC		6
 #define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
+#define UDP_ENCAP_OVPNINUDP	8 /* OpenVPN over UDP connection */
 
 #endif /* _UAPI_LINUX_UDP_H */
-- 
2.35.1

