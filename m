Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82672488CD
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbgHRPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgHRPLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:11:47 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74301C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 08:11:46 -0700 (PDT)
Received: from katalix.com (unknown [IPv6:2a02:8010:6359:1:21b:21ff:fe6a:7e96])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id C3D3F86B79;
        Tue, 18 Aug 2020 16:11:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1597763495; bh=9FO9uBcbkWGx/f0cwDeGJzFDBTekxIN1JmeltCNtAdI=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        z=From:=20jchapman@katalix.com|To:=20netdev@vger.kernel.org|Cc:=20J
         ames=20Chapman=20<jchapman@katalix.com>|Subject:=20[PATCH=20net-ne
         xt]=20Documentation/networking:=20update=20l2tp=20docs|Date:=20Tue
         ,=2018=20Aug=202020=2016:11:35=20+0100|Message-Id:=20<202008181511
         35.1943-1-jchapman@katalix.com>;
        b=TQEq1mw070+Uz3DtjosGxkxegp4hssFL0MK+gSz1nCaAUeL6H3bW83lJpzbDW7cdG
         LQHGEOXPMA2U7CEIKTmHrbiW3mCcYn9C9VhfKKmNxC0RBF24aPWeg/QwLpONvWjwQ+
         8BoOdHHmk2XRxttHrm3QCfM/buHsMMYWllJ2cU9k0w4STPgKbtaNSU3qdYPcGcQnJI
         u8hvMzGIIJlQVikhZqQStvcDGNxA1VZFpQx62rIIB1/NLEqTVbpuVo/T8ARg7YCxEO
         Alu/uYj9elyuUIp1fQPeLgeBLTvNhR6pV9KGhE2te2svoEglkBotvcVC2azHoSEciN
         0D3P5r2EgF/YQ==
From:   jchapman@katalix.com
To:     netdev@vger.kernel.org
Cc:     James Chapman <jchapman@katalix.com>
Subject: [PATCH net-next] Documentation/networking: update l2tp docs
Date:   Tue, 18 Aug 2020 16:11:35 +0100
Message-Id: <20200818151135.1943-1-jchapman@katalix.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Chapman <jchapman@katalix.com>

Kernel documentation of L2TP has not been kept up to date and lacks
coverage of some L2TP APIs. While addressing this, refactor to improve
readability, separating the parts which focus on user APIs and
internal implementation into sections.

Signed-off-by: James Chapman <jchapman@katalix.com>
---
 Documentation/networking/l2tp.rst | 870 ++++++++++++++++++++----------
 1 file changed, 584 insertions(+), 286 deletions(-)

diff --git a/Documentation/networking/l2tp.rst b/Documentation/networking/l2tp.rst
index a48238a2ec09..7087e369cb7f 100644
--- a/Documentation/networking/l2tp.rst
+++ b/Documentation/networking/l2tp.rst
@@ -4,124 +4,336 @@
 L2TP
 ====
 
-This document describes how to use the kernel's L2TP drivers to
-provide L2TP functionality. L2TP is a protocol that tunnels one or
-more sessions over an IP tunnel. It is commonly used for VPNs
-(L2TP/IPSec) and by ISPs to tunnel subscriber PPP sessions over an IP
-network infrastructure. With L2TPv3, it is also useful as a Layer-2
-tunneling infrastructure.
-
-Features
+Layer 2 Tunneling Protocol (L2TP) allows L2 frames to be tunneled over
+an IP network.
+
+This document covers the kernel's L2TP subsystem. It documents kernel
+APIs for application developers who want to use the L2TP subsystem and
+it provides some technical details about the internal implementation
+which may be useful to kernel developers and maintainers.
+
+Overview
 ========
 
-L2TPv2 (PPP over L2TP (UDP tunnels)).
-L2TPv3 ethernet pseudowires.
-L2TPv3 PPP pseudowires.
-L2TPv3 IP encapsulation.
-Netlink sockets for L2TPv3 configuration management.
-
-History
-=======
-
-The original pppol2tp driver was introduced in 2.6.23 and provided
-L2TPv2 functionality (rfc2661). L2TPv2 is used to tunnel one or more PPP
-sessions over a UDP tunnel.
-
-L2TPv3 (rfc3931) changes the protocol to allow different frame types
-to be passed over an L2TP tunnel by moving the PPP-specific parts of
-the protocol out of the core L2TP packet headers. Each frame type is
-known as a pseudowire type. Ethernet, PPP, HDLC, Frame Relay and ATM
-pseudowires for L2TP are defined in separate RFC standards. Another
-change for L2TPv3 is that it can be carried directly over IP with no
-UDP header (UDP is optional). It is also possible to create static
-unmanaged L2TPv3 tunnels manually without a control protocol
-(userspace daemon) to manage them.
-
-To support L2TPv3, the original pppol2tp driver was split up to
-separate the L2TP and PPP functionality. Existing L2TPv2 userspace
-apps should be unaffected as the original pppol2tp sockets API is
-retained. L2TPv3, however, uses netlink to manage L2TPv3 tunnels and
-sessions.
-
-Design
-======
-
-The L2TP protocol separates control and data frames.  The L2TP kernel
-drivers handle only L2TP data frames; control frames are always
-handled by userspace. L2TP control frames carry messages between L2TP
-clients/servers and are used to setup / teardown tunnels and
-sessions. An L2TP client or server is implemented in userspace.
-
-Each L2TP tunnel is implemented using a UDP or L2TPIP socket; L2TPIP
-provides L2TPv3 IP encapsulation (no UDP) and is implemented using a
-new l2tpip socket family. The tunnel socket is typically created by
-userspace, though for unmanaged L2TPv3 tunnels, the socket can also be
-created by the kernel. Each L2TP session (pseudowire) gets a network
-interface instance. In the case of PPP, these interfaces are created
-indirectly by pppd using a pppol2tp socket. In the case of ethernet,
-the netdevice is created upon a netlink request to create an L2TPv3
-ethernet pseudowire.
-
-For PPP, the PPPoL2TP driver, net/l2tp/l2tp_ppp.c, provides a
-mechanism by which PPP frames carried through an L2TP session are
-passed through the kernel's PPP subsystem. The standard PPP daemon,
-pppd, handles all PPP interaction with the peer. PPP network
-interfaces are created for each local PPP endpoint. The kernel's PPP
-subsystem arranges for PPP control frames to be delivered to pppd,
-while data frames are forwarded as usual.
-
-For ethernet, the L2TPETH driver, net/l2tp/l2tp_eth.c, implements a
-netdevice driver, managing virtual ethernet devices, one per
-pseudowire. These interfaces can be managed using standard Linux tools
-such as "ip" and "ifconfig". If only IP frames are passed over the
-tunnel, the interface can be given an IP addresses of itself and its
-peer. If non-IP frames are to be passed over the tunnel, the interface
-can be added to a bridge using brctl. All L2TP datapath protocol
-functions are handled by the L2TP core driver.
-
-Each tunnel and session within a tunnel is assigned a unique tunnel_id
-and session_id. These ids are carried in the L2TP header of every
-control and data packet. (Actually, in L2TPv3, the tunnel_id isn't
-present in data frames - it is inferred from the IP connection on
-which the packet was received.) The L2TP driver uses the ids to lookup
-internal tunnel and/or session contexts to determine how to handle the
-packet. Zero tunnel / session ids are treated specially - zero ids are
-never assigned to tunnels or sessions in the network. In the driver,
-the tunnel context keeps a reference to the tunnel UDP or L2TPIP
-socket. The session context holds data that lets the driver interface
-to the kernel's network frame type subsystems, i.e. PPP, ethernet.
-
-Userspace Programming
-=====================
-
-For L2TPv2, there are a number of requirements on the userspace L2TP
-daemon in order to use the pppol2tp driver.
-
-1. Use a UDP socket per tunnel.
-
-2. Create a single PPPoL2TP socket per tunnel bound to a special null
-   session id. This is used only for communicating with the driver but
-   must remain open while the tunnel is active. Opening this tunnel
-   management socket causes the driver to mark the tunnel socket as an
-   L2TP UDP encapsulation socket and flags it for use by the
-   referenced tunnel id. This hooks up the UDP receive path via
-   udp_encap_rcv() in net/ipv4/udp.c. PPP data frames are never passed
-   in this special PPPoX socket.
-
-3. Create a PPPoL2TP socket per L2TP session. This is typically done
-   by starting pppd with the pppol2tp plugin and appropriate
-   arguments. A PPPoL2TP tunnel management socket (Step 2) must be
-   created before the first PPPoL2TP session socket is created.
+The kernel's L2TP subsystem implements the datapath for L2TPv2 and
+L2TPv3. L2TPv2 is carried over UDP. L2TPv3 is carried over UDP or
+directly over IP (protocol 115).
+
+The L2TP RFCs define two basic kinds of L2TP packets: control packets
+(the "control plane"), and data packets (the "data plane"). The kernel
+deals only with data packets. The more complex control packets are
+handled by user space.
+
+An L2TP tunnel carries one or more L2TP sessions. Each tunnel is
+associated with a socket. Each session is associated with a virtual
+netdevice, e.g. ``pppN``, ``l2tpethN``, through which data frames pass to/from
+L2TP. Fields in the L2TP header identify the tunnel or session and
+whether it is a control or data packet. When tunnels and sessions are
+set up using the Linux kernel API, we're just setting up the L2TP data
+path. All aspects of the control protocol are to be handled by user
+space.
+
+This split in responsibilities leads to a natural sequence of
+operations when establishing tunnels and sessions. The procedure looks
+like this:
+
+    1) Create a tunnel socket. Exchange L2TP control protocol messages
+       with the peer over that socket in order to establish a tunnel.
+
+    2) Create a tunnel context in the kernel, using information
+       obtained from the peer using the control protocol messages.
+
+    3) Exchange L2TP control protocol messages with the peer over the
+       tunnel socket in order to establish a session.
+
+    4) Create a session context in the kernel using information
+       obtained from the peer using the control protocol messages.
+
+L2TP APIs
+=========
+
+This section documents each userspace API of the L2TP subsystem.
+
+Tunnel Sockets
+--------------
+
+L2TPv2 always uses UDP. L2TPv3 may use UDP or IP encapsulation.
+
+To create a tunnel socket for use by L2TP, the standard POSIX
+socket API is used.
+
+For example, for a tunnel using IPv4 addresses and UDP encapsulation::
+
+    int sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
+
+Or for a tunnel using IPv6 addresses and IP encapsulation::
+
+    int sockfd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_L2TP);
+
+UDP socket programming doesn't need to be covered here.
+
+IPPROTO_L2TP is an IP protocol type implemented by the kernel's L2TP
+subsystem. The L2TPIP socket address is defined in struct
+sockaddr_l2tpip and struct sockaddr_l2tpip6 at
+`include/uapi/linux/l2tp.h`_. The address includes the L2TP tunnel
+(connection) id. To use L2TP IP encapsulation, an L2TPv3 application
+should bind the L2TPIP socket using the locally assigned
+tunnel id. When the peer's tunnel id and IP address is known, a
+connect must be done.
+
+If the L2TP application needs to handle L2TPv3 tunnel setup requests
+from peers using L2TPIP, it must open a dedicated L2TPIP
+socket to listen for those requests and bind the socket using tunnel
+id 0 since tunnel setup requests are addressed to tunnel id 0.
+
+An L2TP tunnel and all of its sessions are automatically closed when
+its tunnel socket is closed.
+
+Netlink API
+-----------
+
+L2TP applications use netlink to manage L2TP tunnel and session
+instances in the kernel. The L2TP netlink API is defined in
+`include/uapi/linux/l2tp.h`_.
+
+L2TP uses `Generic Netlink`_ (GENL). Several commands are defined:
+Create, Delete, Modify and Get for tunnel and session
+instances, e.g. ``L2TP_CMD_TUNNEL_CREATE``. The API header lists the
+netlink attribute types that can be used with each command.
+
+Tunnel and session instances are identified by a locally unique
+32-bit id.  L2TP tunnel ids are given by ``L2TP_ATTR_CONN_ID`` and
+``L2TP_ATTR_PEER_CONN_ID`` attributes and L2TP session ids are given
+by ``L2TP_ATTR_SESSION_ID`` and ``L2TP_ATTR_PEER_SESSION_ID``
+attributes. If netlink is used to manage L2TPv2 tunnel and session
+instances, the L2TPv2 16-bit tunnel/session id is cast to a 32-bit
+value in these attributes.
+
+In the ``L2TP_CMD_TUNNEL_CREATE`` command, ``L2TP_ATTR_FD`` tells the
+kernel the tunnel socket fd being used. If not specified, the kernel
+creates a kernel socket for the tunnel, using IP parameters set in
+``L2TP_ATTR_IP[6]_SADDR``, ``L2TP_ATTR_IP[6]_DADDR``,
+``L2TP_ATTR_UDP_SPORT``, ``L2TP_ATTR_UDP_DPORT`` attributes. Kernel
+sockets are used to implement unmanaged L2TPv3 tunnels (iproute2's "ip
+l2tp" commands). If ``L2TP_ATTR_FD`` is given, it must be a socket fd
+that is already bound and connected. There is more information about
+unmanaged tunnels later in this document.
+
+``L2TP_CMD_TUNNEL_CREATE`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            Y        Sets the tunnel (connection) id.
+PEER_CONN_ID       Y        Sets the peer tunnel (connection) id.
+PROTO_VERSION      Y        Protocol version. 2 or 3.
+ENCAP_TYPE         Y        Encapsulation type: UDP or IP.
+FD                 N        Tunnel socket file descriptor.
+UDP_CSUM           N        Enable IPv4 UDP checksums. Used only if FD is not set.
+UDP_ZERO_CSUM6_TX  N        Zero IPv6 UDP checksum on transmit. Used only if FD is not set.
+UDP_ZERO_CSUM6_RX  N        Zero IPv6 UDP checksum on receive. Used only if FD is not set.
+IP_SADDR           N        IPv4 source address. Used only if FD is not set.
+IP_DADDR           N        IPv4 destination address. Used only if FD is not set.
+UDP_SPORT          N        UDP source port. Used only if FD is not set.
+UDP_DPORT          N        UDP destination port. Used only if FD is not set.
+IP6_SADDR          N        IPv6 source address. Used only if FD is not set.
+IP6_DADDR          N        IPv6 destination address. Used only if FD is not set.
+DEBUG              N        Debug flags.
+================== ======== ===
+
+``L2TP_CMD_TUNNEL_DESTROY`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            Y        Identifies the tunnel id to be destroyed.
+================== ======== ===
+
+``L2TP_CMD_TUNNEL_MODIFY`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            Y        Identifies the tunnel id to be modified.
+DEBUG              N        Debug flags.
+================== ======== ===
+
+``L2TP_CMD_TUNNEL_GET`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            N        Identifies the tunnel id to be queried. Ignored in DUMP requests.
+================== ======== ===
+
+``L2TP_CMD_SESSION_CREATE`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            Y        The parent tunnel id.
+SESSION_ID         Y        Sets the session id.
+PEER_SESSION_ID    Y        Sets the parent session id.
+PW_TYPE            Y        Sets the pseudowire type. 
+DEBUG              N        Debug flags.
+RECV_SEQ           N        Enable rx data sequence numbers.
+SEND_SEQ           N        Enable tx data sequence numbers.
+LNS_MODE           N        Enable LNS mode (auto-enable data sequence numbers).
+RECV_TIMEOUT       N        Timeout to wait when reordering received packets.
+L2SPEC_TYPE        N        Sets layer2-specific-sublayer type (L2TPv3 only).
+COOKIE             N        Sets optional cookie (L2TPv3 only).
+PEER_COOKIE        N        Sets optional peer cookie (L2TPv3 only).
+IFNAME             N        Sets interface name (L2TPv3 only).
+================== ======== ===
+
+For Ethernet session types, this will create an l2tpeth virtual
+interface which can then be configured as required. For PPP session
+types, a PPPoL2TP socket must also be opened and connected, mapping it
+onto the new session. This is covered in "PPPoL2TP Sockets" later.
+
+``L2TP_CMD_SESSION_DESTROY`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            Y        Identifies the parent tunnel id of the session to be destroyed.
+SESSION_ID         Y        Identifies the session id to be destroyed.
+IFNAME             N        Identifies the session by interface name. If set, this overrides any CONN_ID and SESSION_ID attributes. Currently supported for L2TPv3 Ethernet sessions only.
+================== ======== ===
+
+``L2TP_CMD_SESSION_MODIFY`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            Y        Identifies the parent tunnel id of the session to be modified.
+SESSION_ID         Y        Identifies the session id to be modified.
+IFNAME             N        Identifies the session by interface name. If set, this overrides any CONN_ID and SESSION_ID attributes. Currently supported for L2TPv3 Ethernet sessions only.
+DEBUG              N        Debug flags.
+RECV_SEQ           N        Enable rx data sequence numbers.
+SEND_SEQ           N        Enable tx data sequence numbers.
+LNS_MODE           N        Enable LNS mode (auto-enable data sequence numbers).
+RECV_TIMEOUT       N        Timeout to wait when reordering received packets.
+================== ======== ===
+
+``L2TP_CMD_SESSION_GET`` attributes:-
+
+================== ======== ===
+Attribute          Required Use
+================== ======== ===
+CONN_ID            N        Identifies the tunnel id to be queried. Ignored for DUMP requests.    
+SESSION_ID         N        Identifies the session id to be queried. Ignored for DUMP requests.
+IFNAME             N        Identifies the session by interface name. If set, this overrides any CONN_ID and SESSION_ID attributes. Ignored for DUMP requests. Currently supported for L2TPv3 Ethernet sessions only.
+================== ======== ===
+
+Application developers should refer to `include/uapi/linux/l2tp.h`_ for
+netlink command and attribute definitions.
+
+Sample userspace code using libmnl_:
+
+  - Open L2TP netlink socket::
+
+	struct nl_sock *nl_sock;
+	int l2tp_nl_family_id;
+
+	nl_sock = nl_socket_alloc();
+	genl_connect(nl_sock);
+	genl_id = genl_ctrl_resolve(nl_sock, L2TP_GENL_NAME);
+
+  - Create a tunnel::
+
+	struct nlmsghdr *nlh;
+	struct genlmsghdr *gnlh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = genl_id; /* assigned to genl socket */
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	gnlh = mnl_nlmsg_put_extra_header(nlh, sizeof(*gnlh));
+	gnlh->cmd = L2TP_CMD_TUNNEL_CREATE;
+	gnlh->version = L2TP_GENL_VERSION;
+	gnlh->reserved = 0;
+
+	mnl_attr_put_u32(nlh, L2TP_ATTR_FD, tunl_sock_fd);
+	mnl_attr_put_u32(nlh, L2TP_ATTR_CONN_ID, tid);
+	mnl_attr_put_u32(nlh, L2TP_ATTR_PEER_CONN_ID, peer_tid);
+	mnl_attr_put_u8(nlh, L2TP_ATTR_PROTO_VERSION, protocol_version);
+	mnl_attr_put_u16(nlh, L2TP_ATTR_ENCAP_TYPE, encap);
+
+  - Create a session::
+
+	struct nlmsghdr *nlh;
+	struct genlmsghdr *gnlh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = genl_id; /* assigned to genl socket */
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	gnlh = mnl_nlmsg_put_extra_header(nlh, sizeof(*gnlh));
+	gnlh->cmd = L2TP_CMD_SESSION_CREATE;
+	gnlh->version = L2TP_GENL_VERSION;
+	gnlh->reserved = 0;
+
+	mnl_attr_put_u32(nlh, L2TP_ATTR_CONN_ID, tid);
+	mnl_attr_put_u32(nlh, L2TP_ATTR_PEER_CONN_ID, peer_tid);
+	mnl_attr_put_u32(nlh, L2TP_ATTR_SESSION_ID, sid);
+	mnl_attr_put_u32(nlh, L2TP_ATTR_PEER_SESSION_ID, peer_sid);
+	mnl_attr_put_u16(nlh, L2TP_ATTR_PW_TYPE, pwtype);
+	/* there are other session options which can be set using netlink
+	 * attributes during session creation -- see l2tp.h
+	 */
+
+  - Delete a session::
+
+	struct nlmsghdr *nlh;
+	struct genlmsghdr *gnlh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = genl_id; /* assigned to genl socket */
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	gnlh = mnl_nlmsg_put_extra_header(nlh, sizeof(*gnlh));
+	gnlh->cmd = L2TP_CMD_SESSION_DELETE;
+	gnlh->version = L2TP_GENL_VERSION;
+	gnlh->reserved = 0;
+
+	mnl_attr_put_u32(nlh, L2TP_ATTR_CONN_ID, tid);
+	mnl_attr_put_u32(nlh, L2TP_ATTR_SESSION_ID, sid);
+
+  - Delete a tunnel and all of its sessions (if any)::
+
+	struct nlmsghdr *nlh;
+	struct genlmsghdr *gnlh;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type = genl_id; /* assigned to genl socket */
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
+	nlh->nlmsg_seq = seq;
+
+	gnlh = mnl_nlmsg_put_extra_header(nlh, sizeof(*gnlh));
+	gnlh->cmd = L2TP_CMD_TUNNEL_DELETE;
+	gnlh->version = L2TP_GENL_VERSION;
+	gnlh->reserved = 0;
+
+	mnl_attr_put_u32(nlh, L2TP_ATTR_CONN_ID, tid);
+
+PPPoL2TP Session Socket API
+---------------------------
+
+For PPP session types, a PPPoL2TP socket must be opened and connected
+to the L2TP session.
 
 When creating PPPoL2TP sockets, the application provides information
-to the driver about the socket in a socket connect() call. Source and
-destination tunnel and session ids are provided, as well as the file
-descriptor of a UDP socket. See struct pppol2tp_addr in
-include/linux/if_pppol2tp.h. Note that zero tunnel / session ids are
-treated specially. When creating the per-tunnel PPPoL2TP management
-socket in Step 2 above, zero source and destination session ids are
-specified, which tells the driver to prepare the supplied UDP file
-descriptor for use as an L2TP tunnel socket.
+to the kernel about the tunnel and session in a socket connect()
+call. Source and destination tunnel and session ids are provided, as
+well as the file descriptor of a UDP or L2TPIP socket. See struct
+pppol2tp_addr in `include/linux/if_pppol2tp.h`_. For historical reasons,
+there are unfortunately slightly different address structures for
+L2TPv2/L2TPv3 IPv4/IPv6 tunnels and userspace must use the appropriate
+structure that matches the tunnel socket type.
 
 Userspace may control behavior of the tunnel or session using
 setsockopt and ioctl on the PPPoX socket. The following socket
@@ -138,52 +350,89 @@ LNSMODE     - 0 => act as LAC.
 REORDERTO   reorder timeout (in millisecs). If 0, don't try to reorder.
 =========   ===========================================================
 
-Only the DEBUG option is supported by the special tunnel management
-PPPoX socket.
-
 In addition to the standard PPP ioctls, a PPPIOCGL2TPSTATS is provided
 to retrieve tunnel and session statistics from the kernel using the
 PPPoX socket of the appropriate tunnel or session.
 
-For L2TPv3, userspace must use the netlink API defined in
-include/linux/l2tp.h to manage tunnel and session contexts. The
-general procedure to create a new L2TP tunnel with one session is:-
-
-1. Open a GENL socket using L2TP_GENL_NAME for configuring the kernel
-   using netlink.
+Sample userspace code:
 
-2. Create a UDP or L2TPIP socket for the tunnel.
+  - Create session PPPoX data socket::
 
-3. Create a new L2TP tunnel using a L2TP_CMD_TUNNEL_CREATE
-   request. Set attributes according to desired tunnel parameters,
-   referencing the UDP or L2TPIP socket created in the previous step.
+	struct sockaddr_pppol2tp sax;
+	int fd;
 
-4. Create a new L2TP session in the tunnel using a
-   L2TP_CMD_SESSION_CREATE request.
+	/* Note, the tunnel socket must be bound already, else it will not be ready */
+	sax.sa_family = AF_PPPOX;
+	sax.sa_protocol = PX_PROTO_OL2TP;
+	sax.pppol2tp.fd = tunnel_fd;
+	sax.pppol2tp.addr.sin_addr.s_addr = addr->sin_addr.s_addr;
+	sax.pppol2tp.addr.sin_port = addr->sin_port;
+	sax.pppol2tp.addr.sin_family = AF_INET;
+	sax.pppol2tp.s_tunnel  = tunnel_id;
+	sax.pppol2tp.s_session = session_id;
+	sax.pppol2tp.d_tunnel  = peer_tunnel_id;
+	sax.pppol2tp.d_session = peer_session_id;
 
-The tunnel and all of its sessions are closed when the tunnel socket
-is closed. The netlink API may also be used to delete sessions and
-tunnels. Configuration and status info may be set or read using netlink.
+	/* session_fd is the fd of the session's PPPoL2TP socket.
+	 * tunnel_fd is the fd of the tunnel UDP / L2TPIP socket.
+	 */
+	fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
+	if (fd < 0 ) {
+		return -errno;
+	}
+	return 0;
 
-The L2TP driver also supports static (unmanaged) L2TPv3 tunnels. These
-are where there is no L2TP control message exchange with the peer to
-setup the tunnel; the tunnel is configured manually at each end of the
-tunnel. There is no need for an L2TP userspace application in this
-case -- the tunnel socket is created by the kernel and configured
-using parameters sent in the L2TP_CMD_TUNNEL_CREATE netlink
-request. The "ip" utility of iproute2 has commands for managing static
-L2TPv3 tunnels; do "ip l2tp help" for more information.
+Old L2TPv2-only API
+-------------------
+
+When L2TP was first added to the Linux kernel in 2.6.23, it
+implemented only L2TPv2 and did not include a netlink API. Instead,
+tunnel and session instances in the kernel were managed directly using
+only PPPoL2TP sockets. The PPPoL2TP socket is used as described in
+section "PPPoL2TP Session Socket API" but tunnel and session instances
+are automatically created on a connect() of the socket instead of
+being created by a separate netlink request:
+
+    - Tunnels are managed using a tunnel management socket which is a
+      dedicated PPPoL2TP socket, connected to (invalid) session
+      id 0. The L2TP tunnel instance is created when the PPPoL2TP
+      tunnel management socket is connected and is destroyed when the
+      socket is closed.
+
+    - Session instances are created in the kernel when a PPPoL2TP
+      socket is connected to a non-zero session id. Session parameters
+      are set using setsockopt. The L2TP session instance is destroyed
+      when the socket is closed.
+
+This API is still supported but its use is discouraged. Instead, new
+L2TPv2 applications should use netlink to first create the tunnel and
+session, then create a PPPoL2TP socket for the session.
+
+Unmanaged L2TPv3 tunnels
+------------------------
+
+The kernel L2TP subsystem also supports static (unmanaged) L2TPv3
+tunnels. Unmanaged tunnels have no userspace tunnel socket, and
+exchange no control messages with the peer to set up the tunnel; the
+tunnel is configured manually at each end of the tunnel. All
+configuration is done using netlink. There is no need for an L2TP
+userspace application in this case -- the tunnel socket is created by
+the kernel and configured using parameters sent in the
+``L2TP_CMD_TUNNEL_CREATE`` netlink request. The ``ip`` utility of ``iproute2``
+has commands for managing static L2TPv3 tunnels; do ``ip l2tp help`` for
+more information.
 
 Debugging
-=========
+---------
 
-The driver supports a flexible debug scheme where kernel trace
+The L2TP subsystem offers a debug scheme where kernel trace
 messages may be optionally enabled per tunnel and per session. Care is
 needed when debugging a live system since the messages are not
 rate-limited and a busy system could be swamped. Userspace uses
-setsockopt on the PPPoX socket to set a debug mask.
+setsockopt on the PPPoX socket to set a debug mask, or ``L2TP_ATTR_DEBUG``
+in netlink Create and Modify commands.
 
-The following debug mask bits are available:
+The following debug mask bits are defined:-
 
 ================  ==============================
 L2TP_MSG_DEBUG    verbose debug (if compiled in)
@@ -192,167 +441,216 @@ L2TP_MSG_SEQ      sequence numbers handling
 L2TP_MSG_DATA     data packets
 ================  ==============================
 
+Sessions inherit default debug flags from the parent tunnel.
+
 If enabled, files under a l2tp debugfs directory can be used to dump
 kernel state about L2TP tunnels and sessions. To access it, the
 debugfs filesystem must first be mounted::
 
-	# mount -t debugfs debugfs /debug
+    # mount -t debugfs debugfs /debug
 
 Files under the l2tp directory can then be accessed::
 
-	# cat /debug/l2tp/tunnels
+    # cat /debug/l2tp/tunnels
 
 The debugfs files should not be used by applications to obtain L2TP
 state information because the file format is subject to change. It is
 implemented to provide extra debug information to help diagnose
-problems.) Users should use the netlink API.
+problems. Applications should instead use the netlink API.
 
 /proc/net/pppol2tp is also provided for backwards compatibility with
-the original pppol2tp driver. It lists information about L2TPv2
+the original pppol2tp code. It lists information about L2TPv2
 tunnels and sessions only. Its use is discouraged.
 
-Unmanaged L2TPv3 Tunnels
-========================
-
-Some commercial L2TP products support unmanaged L2TPv3 ethernet
-tunnels, where there is no L2TP control protocol; tunnels are
-configured at each side manually. New commands are available in
-iproute2's ip utility to support this.
-
-To create an L2TPv3 ethernet pseudowire between local host 192.168.1.1
-and peer 192.168.1.2, using IP addresses 10.5.1.1 and 10.5.1.2 for the
-tunnel endpoints::
-
-	# ip l2tp add tunnel tunnel_id 1 peer_tunnel_id 1 udp_sport 5000 \
-	  udp_dport 5000 encap udp local 192.168.1.1 remote 192.168.1.2
-	# ip l2tp add session tunnel_id 1 session_id 1 peer_session_id 1
-	# ip -s -d show dev l2tpeth0
-	# ip addr add 10.5.1.2/32 peer 10.5.1.1/32 dev l2tpeth0
-	# ip li set dev l2tpeth0 up
-
-Choose IP addresses to be the address of a local IP interface and that
-of the remote system. The IP addresses of the l2tpeth0 interface can be
-anything suitable.
-
-Repeat the above at the peer, with ports, tunnel/session ids and IP
-addresses reversed.  The tunnel and session IDs can be any non-zero
-32-bit number, but the values must be reversed at the peer.
-
-========================       ===================
-Host 1                         Host2
-========================       ===================
-udp_sport=5000                 udp_sport=5001
-udp_dport=5001                 udp_dport=5000
-tunnel_id=42                   tunnel_id=45
-peer_tunnel_id=45              peer_tunnel_id=42
-session_id=128                 session_id=5196755
-peer_session_id=5196755        peer_session_id=128
-========================       ===================
-
-When done at both ends of the tunnel, it should be possible to send
-data over the network. e.g.::
-
-	# ping 10.5.1.1
-
-
-Sample Userspace Code
-=====================
-
-1. Create tunnel management PPPoX socket::
-
-	kernel_fd = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
-	if (kernel_fd >= 0) {
-		struct sockaddr_pppol2tp sax;
-		struct sockaddr_in const *peer_addr;
-
-		peer_addr = l2tp_tunnel_get_peer_addr(tunnel);
-		memset(&sax, 0, sizeof(sax));
-		sax.sa_family = AF_PPPOX;
-		sax.sa_protocol = PX_PROTO_OL2TP;
-		sax.pppol2tp.fd = udp_fd;       /* fd of tunnel UDP socket */
-		sax.pppol2tp.addr.sin_addr.s_addr = peer_addr->sin_addr.s_addr;
-		sax.pppol2tp.addr.sin_port = peer_addr->sin_port;
-		sax.pppol2tp.addr.sin_family = AF_INET;
-		sax.pppol2tp.s_tunnel = tunnel_id;
-		sax.pppol2tp.s_session = 0;     /* special case: mgmt socket */
-		sax.pppol2tp.d_tunnel = 0;
-		sax.pppol2tp.d_session = 0;     /* special case: mgmt socket */
-
-		if(connect(kernel_fd, (struct sockaddr *)&sax, sizeof(sax) ) < 0 ) {
-			perror("connect failed");
-			result = -errno;
-			goto err;
-		}
-	}
-
-2. Create session PPPoX data socket::
-
-	struct sockaddr_pppol2tp sax;
-	int fd;
-
-	/* Note, the target socket must be bound already, else it will not be ready */
-	sax.sa_family = AF_PPPOX;
-	sax.sa_protocol = PX_PROTO_OL2TP;
-	sax.pppol2tp.fd = tunnel_fd;
-	sax.pppol2tp.addr.sin_addr.s_addr = addr->sin_addr.s_addr;
-	sax.pppol2tp.addr.sin_port = addr->sin_port;
-	sax.pppol2tp.addr.sin_family = AF_INET;
-	sax.pppol2tp.s_tunnel  = tunnel_id;
-	sax.pppol2tp.s_session = session_id;
-	sax.pppol2tp.d_tunnel  = peer_tunnel_id;
-	sax.pppol2tp.d_session = peer_session_id;
-
-	/* session_fd is the fd of the session's PPPoL2TP socket.
-	 * tunnel_fd is the fd of the tunnel UDP socket.
-	 */
-	fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
-	if (fd < 0 )    {
-		return -errno;
-	}
-	return 0;
-
 Internal Implementation
 =======================
 
-The driver keeps a struct l2tp_tunnel context per L2TP tunnel and a
-struct l2tp_session context for each session. The l2tp_tunnel is
-always associated with a UDP or L2TP/IP socket and keeps a list of
-sessions in the tunnel. The l2tp_session context keeps kernel state
-about the session. It has private data which is used for data specific
-to the session type. With L2TPv2, the session always carried PPP
-traffic. With L2TPv3, the session can also carry ethernet frames
-(ethernet pseudowire) or other data types such as ATM, HDLC or Frame
-Relay.
-
-When a tunnel is first opened, the reference count on the socket is
-increased using sock_hold(). This ensures that the kernel socket
-cannot be removed while L2TP's data structures reference it.
-
-Some L2TP sessions also have a socket (PPP pseudowires) while others
-do not (ethernet pseudowires). We can't use the socket reference count
-as the reference count for session contexts. The L2TP implementation
-therefore has its own internal reference counts on the session
-contexts.
-
-To Do
-=====
-
-Add L2TP tunnel switching support. This would route tunneled traffic
-from one L2TP tunnel into another. Specified in
-http://tools.ietf.org/html/draft-ietf-l2tpext-tunnel-switching-08
-
-Add L2TPv3 VLAN pseudowire support.
-
-Add L2TPv3 IP pseudowire support.
-
-Add L2TPv3 ATM pseudowire support.
+This section is for kernel developers and maintainers.
+
+Sockets
+-------
+
+UDP sockets are implemented by the networking core. When an L2TP
+tunnel is created using a UDP socket, the socket is set up as an
+encapsulated UDP socket by setting encap_rcv and encap_destroy
+callbacks on the UDP socket. l2tp_udp_encap_recv is called when
+packets are received on the socket. l2tp_udp_encap_destroy is called
+when userspace closes the socket.
+
+L2TPIP sockets are implemented in `net/l2tp/l2tp_ip.c`_ and
+`net/l2tp/l2tp_ip6.c`_.
+
+Tunnels
+-------
+
+The kernel keeps a struct l2tp_tunnel context per L2TP tunnel. The
+l2tp_tunnel is always associated with a UDP or L2TP/IP socket and
+keeps a list of sessions in the tunnel. When a tunnel is first
+registered with L2TP core, the reference count on the socket is
+increased. This ensures that the socket cannot be removed while L2TP's
+data structures reference it.
+
+Tunnels are identified by a unique tunnel id. The id is 16-bit for
+L2TPv2 and 32-bit for L2TPv3. Internally, the id is stored as a 32-bit
+value.
+
+Tunnels are kept in a per-net list, indexed by tunnel id. The tunnel
+id namespace is shared by L2TPv2 and L2TPv3. The tunnel context can be
+derived from the socket's sk_user_data.
+
+Handling tunnel socket close is perhaps the most tricky part of the
+L2TP implementation. If userspace closes a tunnel socket, the L2TP
+tunnel and all of its sessions must be closed and destroyed. Since the
+tunnel context holds a ref on the tunnel socket, the socket's sk_destruct
+won't be called until the tunnel sock_put's its socket. For UDP
+sockets, when userspace closes the tunnel socket, the socket's
+encap_destroy handler is invoked, which L2TP uses to initiate its
+tunnel close actions. For L2TPIP sockets, the socket's close handler
+initiates the same tunnel close actions. All sessions are first
+closed. Each session drops its tunnel ref. When the tunnel ref reaches
+zero, the tunnel puts its socket ref. When the socket is eventually
+destroyed, it's sk_destruct finally frees the L2TP tunnel context.
+
+Sessions
+--------
+
+The kernel keeps a struct l2tp_session context for each session.  Each
+session has private data which is used for data specific to the
+session type. With L2TPv2, the session always carries PPP
+traffic. With L2TPv3, the session can carry Ethernet frames
+(Ethernet pseudowire) or other data types such as PPP, ATM, HDLC or
+Frame Relay. Linux currently implements only Ethernet and PPP session types.
+
+Some L2TP session types also have a socket (PPP pseudowires) while others
+do not (Ethernet pseudowires). We can't therefore use the socket
+reference count as the reference count for session contexts. The L2TP
+implementation therefore has its own internal reference counts on the
+session contexts.
+
+Like tunnels, L2TP sessions are identified by a unique
+session id. Just as with tunnel ids, the session id is 16-bit for
+L2TPv2 and 32-bit for L2TPv3. Internally, the id is stored as a 32-bit
+value.
+
+Sessions hold a ref on their parent tunnel to ensure that the tunnel
+stays extant while one or more sessions references it.
+
+Sessions are kept in a per-tunnel list, indexed by session id. L2TPv3
+sessions are also kept in a per-net list indexed by session id,
+because L2TPv3 session ids are unique across all tunnels and L2TPv3
+data packets do not contain a tunnel id in the header. This list is
+therefore needed to find the session context associated with a
+received data packet when the tunnel context cannot be derived from
+the tunnel socket.
+
+Although the L2TPv3 RFC specifies that L2TPv3 session ids are not
+scoped by the tunnel, the kernel does not police this for L2TPv3 UDP
+tunnels and does not add sessions of L2TPv3 UDP tunnels into the
+per-net session list. In the UDP receive code, we must trust that the
+tunnel can be identified using the tunnel socket's sk_user_data and
+lookup the session in the tunnel's session list instead of the per-net
+session list.
+
+PPP
+---
+
+`net/l2tp/l2tp_ppp.c`_ implements the PPPoL2TP socket family. Each PPP session
+has a PPPoL2TP socket.
+
+The PPPoL2TP socket's sk_user_data references the
+l2tp_session.
+
+Userspace sends and receives PPP packets over L2TP using a PPPoL2TP
+socket. Only PPP control frames pass over this socket: PPP data
+packets are handled entirely by the kernel, passing between the L2TP
+session and its associated ``pppN`` netdev through the PPP channel
+interface of the kernel PPP subsystem.
+
+The L2TP PPP implementation handles the closing of a PPPoL2TP socket
+by closing its corresponding L2TP session. This is complicated because
+it must consider racing with netlink session create/destroy requests
+and pppol2tp_connect trying to reconnect with a session that is in the
+process of being closed. Unlike tunnels, PPP sessions do not hold a
+ref on their associated socket, so code must be careful to sock_hold
+the socket where necessary. For all the details, see commit
+3d609342cc04129ff7568e19316ce3d7451a27e8.
+
+Ethernet
+--------
+
+`net/l2tp/l2tp_eth.c`_ implements L2TPv3 Ethernet pseudowires. It manages
+a netdev for each session.
+
+L2TP Ethernet sessions are created and destroyed by netlink request,
+or are destroyed when the tunnel is destroyed. Unlike PPP sessions,
+Ethernet sessions do not have an associated socket.
 
 Miscellaneous
 =============
 
-The L2TP drivers were developed as part of the OpenL2TP project by
-Katalix Systems Ltd. OpenL2TP is a full-featured L2TP client / server,
-designed from the ground up to have the L2TP datapath in the
-kernel. The project also implemented the pppol2tp plugin for pppd
-which allows pppd to use the kernel driver. Details can be found at
-http://www.openl2tp.org.
+RFCs
+----
+
+The kernel code implements the datapath features specified in the
+following RFCs:
+
+======= =============== ===================================
+RFC2661 L2TPv2          https://tools.ietf.org/html/rfc2661
+RFC3931 L2TPv3          https://tools.ietf.org/html/rfc3931
+RFC4719 L2TPv3 Ethernet https://tools.ietf.org/html/rfc4719
+======= =============== ===================================
+
+Implementations
+---------------
+
+A number of open source applications use the L2TP kernel subsystem:
+
+============ ==============================================
+iproute2     https://github.com/shemminger/iproute2
+go-l2tp      https://github.com/katalix/go-l2tp
+tunneldigger https://github.com/wlanslovenija/tunneldigger
+xl2tpd       https://github.com/xelerance/xl2tpd
+============ ==============================================
+
+Limitations
+-----------
+
+The current implementation has a number of limitations:
+
+  1) Multiple UDP sockets with the same 5-tuple address cannot be
+     used. The kernel's tunnel context is identified using private
+     data associated with the socket so it is important that each
+     socket is uniquely identified by its address.
+
+  2) Interfacing with openvswitch is not yet implemented. It may be
+     useful to map OVS Ethernet and VLAN ports into L2TPv3 tunnels.
+
+  3) VLAN pseudowires are implemented using an ``l2tpethN`` interface
+     configured with a VLAN sub-interface. Since L2TPv3 VLAN
+     pseudowires carry one and only one VLAN, it may be better to use
+     a single netdevice rather than an ``l2tpethN`` and ``l2tpethN``:M
+     pair per VLAN session. The netlink attribute
+     ``L2TP_ATTR_VLAN_ID`` was added for this, but it was never
+     implemented.
+
+Testing
+-------
+
+Unmanaged L2TPv3 Ethernet features are tested by the kernel's built-in
+selftests. See `tools/testing/selftests/net/l2tp.sh`_.
+
+Another test suite, l2tp-ktest_, covers all
+of the L2TP APIs and tunnel/session types. This may be integrated into
+the kernel's built-in L2TP selftests in the future.
+
+.. Links
+.. _Generic Netlink: generic_netlink.html
+.. _libmnl: https://www.netfilter.org/projects/libmnl
+.. _include/uapi/linux/l2tp.h: ../../../include/uapi/linux/l2tp.h
+.. _include/linux/if_pppol2tp.h: ../../../include/linux/if_pppol2tp.h
+.. _net/l2tp/l2tp_ip.c: ../../../net/l2tp/l2tp_ip.c
+.. _net/l2tp/l2tp_ip6.c: ../../../net/l2tp/l2tp_ip6.c
+.. _net/l2tp/l2tp_ppp.c: ../../../net/l2tp/l2tp_ppp.c
+.. _net/l2tp/l2tp_eth.c: ../../../net/l2tp/l2tp_eth.c
+.. _tools/testing/selftests/net/l2tp.sh: ../../../tools/testing/selftests/net/l2tp.sh
+.. _l2tp-ktest: https://github.com/katalix/l2tp-ktest
-- 
2.17.1

