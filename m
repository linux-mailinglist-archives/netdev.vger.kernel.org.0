Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FEE1C0143
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbgD3QFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727881AbgD3QEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:41 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 744C924986;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262677;
        bh=rrNYgRcpWkdSep/WQY2hFQorzKqx1bD3JKZOdAGsSbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrGIZRYkno4mmN5yPzkGYtTza+sR9W50g+bp0HGYuDJ/IKCrnxi0SHpEbKx+NEwtv
         CsZ6xHFtcfEsg2ICS6lUhxnnqXVaJYrxb4T5RwMv9GiHQbfuYTWcAGpwYvgeuZVaGS
         PGkqyQDa1WcvWn2phrxcGEPZR3p15nd8NbpB0PaI=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGC-MH; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 26/37] docs: networking: convert rxrpc.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:21 +0200
Message-Id: <ee69f21bd6340b53453760f3c08bfb203277e24c.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- use autonumbered list markups;
- mark code blocks and literals as such;
- mark tables as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/filesystems/afs.rst             |   2 +-
 Documentation/networking/index.rst            |   1 +
 .../networking/{rxrpc.txt => rxrpc.rst}       | 306 +++++++++---------
 MAINTAINERS                                   |   2 +-
 net/rxrpc/Kconfig                             |   6 +-
 net/rxrpc/sysctl.c                            |   2 +-
 6 files changed, 167 insertions(+), 152 deletions(-)
 rename Documentation/networking/{rxrpc.txt => rxrpc.rst} (85%)

diff --git a/Documentation/filesystems/afs.rst b/Documentation/filesystems/afs.rst
index c4ec39a5966e..cada9464d6bd 100644
--- a/Documentation/filesystems/afs.rst
+++ b/Documentation/filesystems/afs.rst
@@ -70,7 +70,7 @@ list of volume location server IP addresses::
 The first module is the AF_RXRPC network protocol driver.  This provides the
 RxRPC remote operation protocol and may also be accessed from userspace.  See:
 
-	Documentation/networking/rxrpc.txt
+	Documentation/networking/rxrpc.rst
 
 The second module is the kerberos RxRPC security driver, and the third module
 is the actual filesystem driver for the AFS filesystem.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index bc3b04a2edde..cd307b9601fa 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -99,6 +99,7 @@ Contents:
    ray_cs
    rds
    regulatory
+   rxrpc
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/rxrpc.txt b/Documentation/networking/rxrpc.rst
similarity index 85%
rename from Documentation/networking/rxrpc.txt
rename to Documentation/networking/rxrpc.rst
index 180e07d956a7..5ad35113d0f4 100644
--- a/Documentation/networking/rxrpc.txt
+++ b/Documentation/networking/rxrpc.rst
@@ -1,6 +1,8 @@
-			    ======================
-			    RxRPC NETWORK PROTOCOL
-			    ======================
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+RxRPC Network Protocol
+======================
 
 The RxRPC protocol driver provides a reliable two-phase transport on top of UDP
 that can be used to perform RxRPC remote operations.  This is done over sockets
@@ -9,36 +11,35 @@ receive data, aborts and errors.
 
 Contents of this document:
 
- (*) Overview.
+ (#) Overview.
 
- (*) RxRPC protocol summary.
+ (#) RxRPC protocol summary.
 
- (*) AF_RXRPC driver model.
+ (#) AF_RXRPC driver model.
 
- (*) Control messages.
+ (#) Control messages.
 
- (*) Socket options.
+ (#) Socket options.
 
- (*) Security.
+ (#) Security.
 
- (*) Example client usage.
+ (#) Example client usage.
 
- (*) Example server usage.
+ (#) Example server usage.
 
- (*) AF_RXRPC kernel interface.
+ (#) AF_RXRPC kernel interface.
 
- (*) Configurable parameters.
+ (#) Configurable parameters.
 
 
-========
-OVERVIEW
+Overview
 ========
 
 RxRPC is a two-layer protocol.  There is a session layer which provides
 reliable virtual connections using UDP over IPv4 (or IPv6) as the transport
 layer, but implements a real network protocol; and there's the presentation
 layer which renders structured data to binary blobs and back again using XDR
-(as does SunRPC):
+(as does SunRPC)::
 
 		+-------------+
 		| Application |
@@ -85,31 +86,30 @@ The Andrew File System (AFS) is an example of an application that uses this and
 that has both kernel (filesystem) and userspace (utility) components.
 
 
-======================
-RXRPC PROTOCOL SUMMARY
+RxRPC Protocol Summary
 ======================
 
 An overview of the RxRPC protocol:
 
- (*) RxRPC sits on top of another networking protocol (UDP is the only option
+ (#) RxRPC sits on top of another networking protocol (UDP is the only option
      currently), and uses this to provide network transport.  UDP ports, for
      example, provide transport endpoints.
 
- (*) RxRPC supports multiple virtual "connections" from any given transport
+ (#) RxRPC supports multiple virtual "connections" from any given transport
      endpoint, thus allowing the endpoints to be shared, even to the same
      remote endpoint.
 
- (*) Each connection goes to a particular "service".  A connection may not go
+ (#) Each connection goes to a particular "service".  A connection may not go
      to multiple services.  A service may be considered the RxRPC equivalent of
      a port number.  AF_RXRPC permits multiple services to share an endpoint.
 
- (*) Client-originating packets are marked, thus a transport endpoint can be
+ (#) Client-originating packets are marked, thus a transport endpoint can be
      shared between client and server connections (connections have a
      direction).
 
- (*) Up to a billion connections may be supported concurrently between one
+ (#) Up to a billion connections may be supported concurrently between one
      local transport endpoint and one service on one remote endpoint.  An RxRPC
-     connection is described by seven numbers:
+     connection is described by seven numbers::
 
 	Local address	}
 	Local port	} Transport (UDP) address
@@ -119,22 +119,22 @@ An overview of the RxRPC protocol:
 	Connection ID
 	Service ID
 
- (*) Each RxRPC operation is a "call".  A connection may make up to four
+ (#) Each RxRPC operation is a "call".  A connection may make up to four
      billion calls, but only up to four calls may be in progress on a
      connection at any one time.
 
- (*) Calls are two-phase and asymmetric: the client sends its request data,
+ (#) Calls are two-phase and asymmetric: the client sends its request data,
      which the service receives; then the service transmits the reply data
      which the client receives.
 
- (*) The data blobs are of indefinite size, the end of a phase is marked with a
+ (#) The data blobs are of indefinite size, the end of a phase is marked with a
      flag in the packet.  The number of packets of data making up one blob may
      not exceed 4 billion, however, as this would cause the sequence number to
      wrap.
 
- (*) The first four bytes of the request data are the service operation ID.
+ (#) The first four bytes of the request data are the service operation ID.
 
- (*) Security is negotiated on a per-connection basis.  The connection is
+ (#) Security is negotiated on a per-connection basis.  The connection is
      initiated by the first data packet on it arriving.  If security is
      requested, the server then issues a "challenge" and then the client
      replies with a "response".  If the response is successful, the security is
@@ -143,146 +143,145 @@ An overview of the RxRPC protocol:
      connection lapse before the client, the security will be renegotiated if
      the client uses the connection again.
 
- (*) Calls use ACK packets to handle reliability.  Data packets are also
+ (#) Calls use ACK packets to handle reliability.  Data packets are also
      explicitly sequenced per call.
 
- (*) There are two types of positive acknowledgment: hard-ACKs and soft-ACKs.
+ (#) There are two types of positive acknowledgment: hard-ACKs and soft-ACKs.
      A hard-ACK indicates to the far side that all the data received to a point
      has been received and processed; a soft-ACK indicates that the data has
      been received but may yet be discarded and re-requested.  The sender may
      not discard any transmittable packets until they've been hard-ACK'd.
 
- (*) Reception of a reply data packet implicitly hard-ACK's all the data
+ (#) Reception of a reply data packet implicitly hard-ACK's all the data
      packets that make up the request.
 
- (*) An call is complete when the request has been sent, the reply has been
+ (#) An call is complete when the request has been sent, the reply has been
      received and the final hard-ACK on the last packet of the reply has
      reached the server.
 
- (*) An call may be aborted by either end at any time up to its completion.
+ (#) An call may be aborted by either end at any time up to its completion.
 
 
-=====================
-AF_RXRPC DRIVER MODEL
+AF_RXRPC Driver Model
 =====================
 
 About the AF_RXRPC driver:
 
- (*) The AF_RXRPC protocol transparently uses internal sockets of the transport
+ (#) The AF_RXRPC protocol transparently uses internal sockets of the transport
      protocol to represent transport endpoints.
 
- (*) AF_RXRPC sockets map onto RxRPC connection bundles.  Actual RxRPC
+ (#) AF_RXRPC sockets map onto RxRPC connection bundles.  Actual RxRPC
      connections are handled transparently.  One client socket may be used to
      make multiple simultaneous calls to the same service.  One server socket
      may handle calls from many clients.
 
- (*) Additional parallel client connections will be initiated to support extra
+ (#) Additional parallel client connections will be initiated to support extra
      concurrent calls, up to a tunable limit.
 
- (*) Each connection is retained for a certain amount of time [tunable] after
+ (#) Each connection is retained for a certain amount of time [tunable] after
      the last call currently using it has completed in case a new call is made
      that could reuse it.
 
- (*) Each internal UDP socket is retained [tunable] for a certain amount of
+ (#) Each internal UDP socket is retained [tunable] for a certain amount of
      time [tunable] after the last connection using it discarded, in case a new
      connection is made that could use it.
 
- (*) A client-side connection is only shared between calls if they have have
+ (#) A client-side connection is only shared between calls if they have have
      the same key struct describing their security (and assuming the calls
      would otherwise share the connection).  Non-secured calls would also be
      able to share connections with each other.
 
- (*) A server-side connection is shared if the client says it is.
+ (#) A server-side connection is shared if the client says it is.
 
- (*) ACK'ing is handled by the protocol driver automatically, including ping
+ (#) ACK'ing is handled by the protocol driver automatically, including ping
      replying.
 
- (*) SO_KEEPALIVE automatically pings the other side to keep the connection
+ (#) SO_KEEPALIVE automatically pings the other side to keep the connection
      alive [TODO].
 
- (*) If an ICMP error is received, all calls affected by that error will be
+ (#) If an ICMP error is received, all calls affected by that error will be
      aborted with an appropriate network error passed through recvmsg().
 
 
 Interaction with the user of the RxRPC socket:
 
- (*) A socket is made into a server socket by binding an address with a
+ (#) A socket is made into a server socket by binding an address with a
      non-zero service ID.
 
- (*) In the client, sending a request is achieved with one or more sendmsgs,
+ (#) In the client, sending a request is achieved with one or more sendmsgs,
      followed by the reply being received with one or more recvmsgs.
 
- (*) The first sendmsg for a request to be sent from a client contains a tag to
+ (#) The first sendmsg for a request to be sent from a client contains a tag to
      be used in all other sendmsgs or recvmsgs associated with that call.  The
      tag is carried in the control data.
 
- (*) connect() is used to supply a default destination address for a client
+ (#) connect() is used to supply a default destination address for a client
      socket.  This may be overridden by supplying an alternate address to the
      first sendmsg() of a call (struct msghdr::msg_name).
 
- (*) If connect() is called on an unbound client, a random local port will
+ (#) If connect() is called on an unbound client, a random local port will
      bound before the operation takes place.
 
- (*) A server socket may also be used to make client calls.  To do this, the
+ (#) A server socket may also be used to make client calls.  To do this, the
      first sendmsg() of the call must specify the target address.  The server's
      transport endpoint is used to send the packets.
 
- (*) Once the application has received the last message associated with a call,
+ (#) Once the application has received the last message associated with a call,
      the tag is guaranteed not to be seen again, and so it can be used to pin
      client resources.  A new call can then be initiated with the same tag
      without fear of interference.
 
- (*) In the server, a request is received with one or more recvmsgs, then the
+ (#) In the server, a request is received with one or more recvmsgs, then the
      the reply is transmitted with one or more sendmsgs, and then the final ACK
      is received with a last recvmsg.
 
- (*) When sending data for a call, sendmsg is given MSG_MORE if there's more
+ (#) When sending data for a call, sendmsg is given MSG_MORE if there's more
      data to come on that call.
 
- (*) When receiving data for a call, recvmsg flags MSG_MORE if there's more
+ (#) When receiving data for a call, recvmsg flags MSG_MORE if there's more
      data to come for that call.
 
- (*) When receiving data or messages for a call, MSG_EOR is flagged by recvmsg
+ (#) When receiving data or messages for a call, MSG_EOR is flagged by recvmsg
      to indicate the terminal message for that call.
 
- (*) A call may be aborted by adding an abort control message to the control
+ (#) A call may be aborted by adding an abort control message to the control
      data.  Issuing an abort terminates the kernel's use of that call's tag.
      Any messages waiting in the receive queue for that call will be discarded.
 
- (*) Aborts, busy notifications and challenge packets are delivered by recvmsg,
+ (#) Aborts, busy notifications and challenge packets are delivered by recvmsg,
      and control data messages will be set to indicate the context.  Receiving
      an abort or a busy message terminates the kernel's use of that call's tag.
 
- (*) The control data part of the msghdr struct is used for a number of things:
+ (#) The control data part of the msghdr struct is used for a number of things:
 
-     (*) The tag of the intended or affected call.
+     (#) The tag of the intended or affected call.
 
-     (*) Sending or receiving errors, aborts and busy notifications.
+     (#) Sending or receiving errors, aborts and busy notifications.
 
-     (*) Notifications of incoming calls.
+     (#) Notifications of incoming calls.
 
-     (*) Sending debug requests and receiving debug replies [TODO].
+     (#) Sending debug requests and receiving debug replies [TODO].
 
- (*) When the kernel has received and set up an incoming call, it sends a
+ (#) When the kernel has received and set up an incoming call, it sends a
      message to server application to let it know there's a new call awaiting
      its acceptance [recvmsg reports a special control message].  The server
      application then uses sendmsg to assign a tag to the new call.  Once that
      is done, the first part of the request data will be delivered by recvmsg.
 
- (*) The server application has to provide the server socket with a keyring of
+ (#) The server application has to provide the server socket with a keyring of
      secret keys corresponding to the security types it permits.  When a secure
      connection is being set up, the kernel looks up the appropriate secret key
      in the keyring and then sends a challenge packet to the client and
      receives a response packet.  The kernel then checks the authorisation of
      the packet and either aborts the connection or sets up the security.
 
- (*) The name of the key a client will use to secure its communications is
+ (#) The name of the key a client will use to secure its communications is
      nominated by a socket option.
 
 
 Notes on sendmsg:
 
- (*) MSG_WAITALL can be set to tell sendmsg to ignore signals if the peer is
+ (#) MSG_WAITALL can be set to tell sendmsg to ignore signals if the peer is
      making progress at accepting packets within a reasonable time such that we
      manage to queue up all the data for transmission.  This requires the
      client to accept at least one packet per 2*RTT time period.
@@ -294,7 +293,7 @@ Notes on sendmsg:
 
 Notes on recvmsg:
 
- (*) If there's a sequence of data messages belonging to a particular call on
+ (#) If there's a sequence of data messages belonging to a particular call on
      the receive queue, then recvmsg will keep working through them until:
 
      (a) it meets the end of that call's received data,
@@ -320,13 +319,13 @@ Notes on recvmsg:
      flagged.
 
 
-================
-CONTROL MESSAGES
+Control Messages
 ================
 
 AF_RXRPC makes use of control messages in sendmsg() and recvmsg() to multiplex
 calls, to invoke certain actions and to report certain conditions.  These are:
 
+	=======================	=== ===========	===============================
 	MESSAGE ID		SRT DATA	MEANING
 	=======================	=== ===========	===============================
 	RXRPC_USER_CALL_ID	sr- User ID	App's call specifier
@@ -340,10 +339,11 @@ calls, to invoke certain actions and to report certain conditions.  These are:
 	RXRPC_EXCLUSIVE_CALL	s-- n/a		Make an exclusive client call
 	RXRPC_UPGRADE_SERVICE	s-- n/a		Client call can be upgraded
 	RXRPC_TX_LENGTH		s-- data len	Total length of Tx data
+	=======================	=== ===========	===============================
 
 	(SRT = usable in Sendmsg / delivered by Recvmsg / Terminal message)
 
- (*) RXRPC_USER_CALL_ID
+ (#) RXRPC_USER_CALL_ID
 
      This is used to indicate the application's call ID.  It's an unsigned long
      that the app specifies in the client by attaching it to the first data
@@ -351,7 +351,7 @@ calls, to invoke certain actions and to report certain conditions.  These are:
      message.  recvmsg() passes it in conjunction with all messages except
      those of the RXRPC_NEW_CALL message.
 
- (*) RXRPC_ABORT
+ (#) RXRPC_ABORT
 
      This is can be used by an application to abort a call by passing it to
      sendmsg, or it can be delivered by recvmsg to indicate a remote abort was
@@ -359,13 +359,13 @@ calls, to invoke certain actions and to report certain conditions.  These are:
      specify the call affected.  If an abort is being sent, then error EBADSLT
      will be returned if there is no call with that user ID.
 
- (*) RXRPC_ACK
+ (#) RXRPC_ACK
 
      This is delivered to a server application to indicate that the final ACK
      of a call was received from the client.  It will be associated with an
      RXRPC_USER_CALL_ID to indicate the call that's now complete.
 
- (*) RXRPC_NET_ERROR
+ (#) RXRPC_NET_ERROR
 
      This is delivered to an application to indicate that an ICMP error message
      was encountered in the process of trying to talk to the peer.  An
@@ -373,13 +373,13 @@ calls, to invoke certain actions and to report certain conditions.  These are:
      indicating the problem, and an RXRPC_USER_CALL_ID will indicate the call
      affected.
 
- (*) RXRPC_BUSY
+ (#) RXRPC_BUSY
 
      This is delivered to a client application to indicate that a call was
      rejected by the server due to the server being busy.  It will be
      associated with an RXRPC_USER_CALL_ID to indicate the rejected call.
 
- (*) RXRPC_LOCAL_ERROR
+ (#) RXRPC_LOCAL_ERROR
 
      This is delivered to an application to indicate that a local error was
      encountered and that a call has been aborted because of it.  An
@@ -387,13 +387,13 @@ calls, to invoke certain actions and to report certain conditions.  These are:
      indicating the problem, and an RXRPC_USER_CALL_ID will indicate the call
      affected.
 
- (*) RXRPC_NEW_CALL
+ (#) RXRPC_NEW_CALL
 
      This is delivered to indicate to a server application that a new call has
      arrived and is awaiting acceptance.  No user ID is associated with this,
      as a user ID must subsequently be assigned by doing an RXRPC_ACCEPT.
 
- (*) RXRPC_ACCEPT
+ (#) RXRPC_ACCEPT
 
      This is used by a server application to attempt to accept a call and
      assign it a user ID.  It should be associated with an RXRPC_USER_CALL_ID
@@ -402,12 +402,12 @@ calls, to invoke certain actions and to report certain conditions.  These are:
      return error ENODATA.  If the user ID is already in use by another call,
      then error EBADSLT will be returned.
 
- (*) RXRPC_EXCLUSIVE_CALL
+ (#) RXRPC_EXCLUSIVE_CALL
 
      This is used to indicate that a client call should be made on a one-off
      connection.  The connection is discarded once the call has terminated.
 
- (*) RXRPC_UPGRADE_SERVICE
+ (#) RXRPC_UPGRADE_SERVICE
 
      This is used to make a client call to probe if the specified service ID
      may be upgraded by the server.  The caller must check msg_name returned to
@@ -419,7 +419,7 @@ calls, to invoke certain actions and to report certain conditions.  These are:
      future communication to that server and RXRPC_UPGRADE_SERVICE should no
      longer be set.
 
- (*) RXRPC_TX_LENGTH
+ (#) RXRPC_TX_LENGTH
 
      This is used to inform the kernel of the total amount of data that is
      going to be transmitted by a call (whether in a client request or a
@@ -443,7 +443,7 @@ SOCKET OPTIONS
 
 AF_RXRPC sockets support a few socket options at the SOL_RXRPC level:
 
- (*) RXRPC_SECURITY_KEY
+ (#) RXRPC_SECURITY_KEY
 
      This is used to specify the description of the key to be used.  The key is
      extracted from the calling process's keyrings with request_key() and
@@ -452,17 +452,17 @@ AF_RXRPC sockets support a few socket options at the SOL_RXRPC level:
      The optval pointer points to the description string, and optlen indicates
      how long the string is, without the NUL terminator.
 
- (*) RXRPC_SECURITY_KEYRING
+ (#) RXRPC_SECURITY_KEYRING
 
      Similar to above but specifies a keyring of server secret keys to use (key
      type "keyring").  See the "Security" section.
 
- (*) RXRPC_EXCLUSIVE_CONNECTION
+ (#) RXRPC_EXCLUSIVE_CONNECTION
 
      This is used to request that new connections should be used for each call
      made subsequently on this socket.  optval should be NULL and optlen 0.
 
- (*) RXRPC_MIN_SECURITY_LEVEL
+ (#) RXRPC_MIN_SECURITY_LEVEL
 
      This is used to specify the minimum security level required for calls on
      this socket.  optval must point to an int containing one of the following
@@ -482,14 +482,14 @@ AF_RXRPC sockets support a few socket options at the SOL_RXRPC level:
 	 Encrypted checksum plus entire packet padded and encrypted, including
 	 actual packet length.
 
- (*) RXRPC_UPGRADEABLE_SERVICE
+ (#) RXRPC_UPGRADEABLE_SERVICE
 
      This is used to indicate that a service socket with two bindings may
      upgrade one bound service to the other if requested by the client.  optval
      must point to an array of two unsigned short ints.  The first is the
      service ID to upgrade from and the second the service ID to upgrade to.
 
- (*) RXRPC_SUPPORTED_CMSG
+ (#) RXRPC_SUPPORTED_CMSG
 
      This is a read-only option that writes an int into the buffer indicating
      the highest control message type supported.
@@ -509,7 +509,7 @@ found at:
 	http://people.redhat.com/~dhowells/rxrpc/klog.c
 
 The payload provided to add_key() on the client should be of the following
-form:
+form::
 
 	struct rxrpc_key_sec2_v1 {
 		uint16_t	security_index;	/* 2 */
@@ -546,14 +546,14 @@ EXAMPLE CLIENT USAGE
 
 A client would issue an operation by:
 
- (1) An RxRPC socket is set up by:
+ (1) An RxRPC socket is set up by::
 
 	client = socket(AF_RXRPC, SOCK_DGRAM, PF_INET);
 
      Where the third parameter indicates the protocol family of the transport
      socket used - usually IPv4 but it can also be IPv6 [TODO].
 
- (2) A local address can optionally be bound:
+ (2) A local address can optionally be bound::
 
 	struct sockaddr_rxrpc srx = {
 		.srx_family	= AF_RXRPC,
@@ -570,20 +570,20 @@ A client would issue an operation by:
      several unrelated RxRPC sockets.  Security is handled on a basis of
      per-RxRPC virtual connection.
 
- (3) The security is set:
+ (3) The security is set::
 
 	const char *key = "AFS:cambridge.redhat.com";
 	setsockopt(client, SOL_RXRPC, RXRPC_SECURITY_KEY, key, strlen(key));
 
      This issues a request_key() to get the key representing the security
-     context.  The minimum security level can be set:
+     context.  The minimum security level can be set::
 
 	unsigned int sec = RXRPC_SECURITY_ENCRYPTED;
 	setsockopt(client, SOL_RXRPC, RXRPC_MIN_SECURITY_LEVEL,
 		   &sec, sizeof(sec));
 
  (4) The server to be contacted can then be specified (alternatively this can
-     be done through sendmsg):
+     be done through sendmsg)::
 
 	struct sockaddr_rxrpc srx = {
 		.srx_family	= AF_RXRPC,
@@ -598,7 +598,9 @@ A client would issue an operation by:
  (5) The request data should then be posted to the server socket using a series
      of sendmsg() calls, each with the following control message attached:
 
-	RXRPC_USER_CALL_ID	- specifies the user ID for this call
+	==================	===================================
+	RXRPC_USER_CALL_ID	specifies the user ID for this call
+	==================	===================================
 
      MSG_MORE should be set in msghdr::msg_flags on all but the last part of
      the request.  Multiple requests may be made simultaneously.
@@ -635,13 +637,12 @@ any more calls (further calls to the same destination will be blocked until the
 probe is concluded).
 
 
-====================
-EXAMPLE SERVER USAGE
+Example Server Usage
 ====================
 
 A server would be set up to accept operations in the following manner:
 
- (1) An RxRPC socket is created by:
+ (1) An RxRPC socket is created by::
 
 	server = socket(AF_RXRPC, SOCK_DGRAM, PF_INET);
 
@@ -649,7 +650,7 @@ A server would be set up to accept operations in the following manner:
      socket used - usually IPv4.
 
  (2) Security is set up if desired by giving the socket a keyring with server
-     secret keys in it:
+     secret keys in it::
 
 	keyring = add_key("keyring", "AFSkeys", NULL, 0,
 			  KEY_SPEC_PROCESS_KEYRING);
@@ -663,7 +664,7 @@ A server would be set up to accept operations in the following manner:
      The keyring can be manipulated after it has been given to the socket. This
      permits the server to add more keys, replace keys, etc. while it is live.
 
- (3) A local address must then be bound:
+ (3) A local address must then be bound::
 
 	struct sockaddr_rxrpc srx = {
 		.srx_family	= AF_RXRPC,
@@ -680,7 +681,7 @@ A server would be set up to accept operations in the following manner:
      should be called twice.
 
  (4) If service upgrading is required, first two service IDs must have been
-     bound and then the following option must be set:
+     bound and then the following option must be set::
 
 	unsigned short service_ids[2] = { from_ID, to_ID };
 	setsockopt(server, SOL_RXRPC, RXRPC_UPGRADEABLE_SERVICE,
@@ -690,14 +691,14 @@ A server would be set up to accept operations in the following manner:
      to_ID if they request it.  This will be reflected in msg_name obtained
      through recvmsg() when the request data is delivered to userspace.
 
- (5) The server is then set to listen out for incoming calls:
+ (5) The server is then set to listen out for incoming calls::
 
 	listen(server, 100);
 
  (6) The kernel notifies the server of pending incoming connections by sending
      it a message for each.  This is received with recvmsg() on the server
      socket.  It has no data, and has a single dataless control message
-     attached:
+     attached::
 
 	RXRPC_NEW_CALL
 
@@ -709,8 +710,10 @@ A server would be set up to accept operations in the following manner:
  (7) The server then accepts the new call by issuing a sendmsg() with two
      pieces of control data and no actual data:
 
-	RXRPC_ACCEPT		- indicate connection acceptance
-	RXRPC_USER_CALL_ID	- specify user ID for this call
+	==================	==============================
+	RXRPC_ACCEPT		indicate connection acceptance
+	RXRPC_USER_CALL_ID	specify user ID for this call
+	==================	==============================
 
  (8) The first request data packet will then be posted to the server socket for
      recvmsg() to pick up.  At that point, the RxRPC address for the call can
@@ -722,12 +725,17 @@ A server would be set up to accept operations in the following manner:
 
      All data will be delivered with the following control message attached:
 
-	RXRPC_USER_CALL_ID	- specifies the user ID for this call
+
+	==================	===================================
+	RXRPC_USER_CALL_ID	specifies the user ID for this call
+	==================	===================================
 
  (9) The reply data should then be posted to the server socket using a series
      of sendmsg() calls, each with the following control messages attached:
 
-	RXRPC_USER_CALL_ID	- specifies the user ID for this call
+	==================	===================================
+	RXRPC_USER_CALL_ID	specifies the user ID for this call
+	==================	===================================
 
      MSG_MORE should be set in msghdr::msg_flags on all but the last message
      for a particular call.
@@ -736,8 +744,10 @@ A server would be set up to accept operations in the following manner:
      when it is received.  It will take the form of a dataless message with two
      control messages attached:
 
-	RXRPC_USER_CALL_ID	- specifies the user ID for this call
-	RXRPC_ACK		- indicates final ACK (no data)
+	==================	===================================
+	RXRPC_USER_CALL_ID	specifies the user ID for this call
+	RXRPC_ACK		indicates final ACK (no data)
+	==================	===================================
 
      MSG_EOR will be flagged to indicate that this is the final message for
      this call.
@@ -746,8 +756,10 @@ A server would be set up to accept operations in the following manner:
      aborted by calling sendmsg() with a dataless message with the following
      control messages attached:
 
-	RXRPC_USER_CALL_ID	- specifies the user ID for this call
-	RXRPC_ABORT		- indicates abort code (4 byte data)
+	==================	===================================
+	RXRPC_USER_CALL_ID	specifies the user ID for this call
+	RXRPC_ABORT		indicates abort code (4 byte data)
+	==================	===================================
 
      Any packets waiting in the socket's receive queue will be discarded if
      this is issued.
@@ -757,8 +769,7 @@ the one server socket, using control messages on sendmsg() and recvmsg() to
 determine the call affected.
 
 
-=========================
-AF_RXRPC KERNEL INTERFACE
+AF_RXRPC Kernel Interface
 =========================
 
 The AF_RXRPC module also provides an interface for use by in-kernel utilities
@@ -786,7 +797,7 @@ then it passes this to the kernel interface functions.
 
 The kernel interface functions are as follows:
 
- (*) Begin a new client call.
+ (#) Begin a new client call::
 
 	struct rxrpc_call *
 	rxrpc_kernel_begin_call(struct socket *sock,
@@ -837,7 +848,7 @@ The kernel interface functions are as follows:
      returned.  The caller now holds a reference on this and it must be
      properly ended.
 
- (*) End a client call.
+ (#) End a client call::
 
 	void rxrpc_kernel_end_call(struct socket *sock,
 				   struct rxrpc_call *call);
@@ -846,7 +857,7 @@ The kernel interface functions are as follows:
      from AF_RXRPC's knowledge and will not be seen again in association with
      the specified call.
 
- (*) Send data through a call.
+ (#) Send data through a call::
 
 	typedef void (*rxrpc_notify_end_tx_t)(struct sock *sk,
 					      unsigned long user_call_ID,
@@ -872,7 +883,7 @@ The kernel interface functions are as follows:
      called with the call-state spinlock held to prevent any reply or final ACK
      from being delivered first.
 
- (*) Receive data from a call.
+ (#) Receive data from a call::
 
 	int rxrpc_kernel_recv_data(struct socket *sock,
 				   struct rxrpc_call *call,
@@ -902,12 +913,14 @@ The kernel interface functions are as follows:
       more data was available, EMSGSIZE is returned.
 
       If a remote ABORT is detected, the abort code received will be stored in
-      *_abort and ECONNABORTED will be returned.
+      ``*_abort`` and ECONNABORTED will be returned.
 
       The service ID that the call ended up with is returned into *_service.
       This can be used to see if a call got a service upgrade.
 
- (*) Abort a call.
+ (#) Abort a call??
+
+     ::
 
 	void rxrpc_kernel_abort_call(struct socket *sock,
 				     struct rxrpc_call *call,
@@ -916,7 +929,7 @@ The kernel interface functions are as follows:
      This is used to abort a call if it's still in an abortable state.  The
      abort code specified will be placed in the ABORT message sent.
 
- (*) Intercept received RxRPC messages.
+ (#) Intercept received RxRPC messages::
 
 	typedef void (*rxrpc_interceptor_t)(struct sock *sk,
 					    unsigned long user_call_ID,
@@ -937,7 +950,8 @@ The kernel interface functions are as follows:
 
      The skb->mark field indicates the type of message:
 
-	MARK				MEANING
+	===============================	=======================================
+	Mark				Meaning
 	===============================	=======================================
 	RXRPC_SKB_MARK_DATA		Data message
 	RXRPC_SKB_MARK_FINAL_ACK	Final ACK received for an incoming call
@@ -946,6 +960,7 @@ The kernel interface functions are as follows:
 	RXRPC_SKB_MARK_NET_ERROR	Network error detected
 	RXRPC_SKB_MARK_LOCAL_ERROR	Local error encountered
 	RXRPC_SKB_MARK_NEW_CALL		New incoming call awaiting acceptance
+	===============================	=======================================
 
      The remote abort message can be probed with rxrpc_kernel_get_abort_code().
      The two error messages can be probed with rxrpc_kernel_get_error_number().
@@ -961,7 +976,7 @@ The kernel interface functions are as follows:
      is possible to get extra refs on all types of message for later freeing,
      but this may pin the state of a call until the message is finally freed.
 
- (*) Accept an incoming call.
+ (#) Accept an incoming call::
 
 	struct rxrpc_call *
 	rxrpc_kernel_accept_call(struct socket *sock,
@@ -975,7 +990,7 @@ The kernel interface functions are as follows:
      returned.  The caller now holds a reference on this and it must be
      properly ended.
 
- (*) Reject an incoming call.
+ (#) Reject an incoming call::
 
 	int rxrpc_kernel_reject_call(struct socket *sock);
 
@@ -984,21 +999,21 @@ The kernel interface functions are as follows:
      Other errors may be returned if the call had been aborted (-ECONNABORTED)
      or had timed out (-ETIME).
 
- (*) Allocate a null key for doing anonymous security.
+ (#) Allocate a null key for doing anonymous security::
 
 	struct key *rxrpc_get_null_key(const char *keyname);
 
      This is used to allocate a null RxRPC key that can be used to indicate
      anonymous security for a particular domain.
 
- (*) Get the peer address of a call.
+ (#) Get the peer address of a call::
 
 	void rxrpc_kernel_get_peer(struct socket *sock, struct rxrpc_call *call,
 				   struct sockaddr_rxrpc *_srx);
 
      This is used to find the remote peer address of a call.
 
- (*) Set the total transmit data size on a call.
+ (#) Set the total transmit data size on a call::
 
 	void rxrpc_kernel_set_tx_length(struct socket *sock,
 					struct rxrpc_call *call,
@@ -1009,14 +1024,14 @@ The kernel interface functions are as follows:
      size should be set when the call is begun.  tx_total_len may not be less
      than zero.
 
- (*) Get call RTT.
+ (#) Get call RTT::
 
 	u64 rxrpc_kernel_get_rtt(struct socket *sock, struct rxrpc_call *call);
 
      Get the RTT time to the peer in use by a call.  The value returned is in
      nanoseconds.
 
- (*) Check call still alive.
+ (#) Check call still alive::
 
 	bool rxrpc_kernel_check_life(struct socket *sock,
 				     struct rxrpc_call *call,
@@ -1024,7 +1039,7 @@ The kernel interface functions are as follows:
 	void rxrpc_kernel_probe_life(struct socket *sock,
 				     struct rxrpc_call *call);
 
-     The first function passes back in *_life a number that is updated when
+     The first function passes back in ``*_life`` a number that is updated when
      ACKs are received from the peer (notably including PING RESPONSE ACKs
      which we can elicit by sending PING ACKs to see if the call still exists
      on the server).  The caller should compare the numbers of two calls to see
@@ -1040,7 +1055,7 @@ The kernel interface functions are as follows:
      first function to change.  Note that this must be called in TASK_RUNNING
      state.
 
- (*) Get reply timestamp.
+ (#) Get reply timestamp::
 
 	bool rxrpc_kernel_get_reply_time(struct socket *sock,
 					 struct rxrpc_call *call,
@@ -1048,10 +1063,10 @@ The kernel interface functions are as follows:
 
      This allows the timestamp on the first DATA packet of the reply of a
      client call to be queried, provided that it is still in the Rx ring.  If
-     successful, the timestamp will be stored into *_ts and true will be
+     successful, the timestamp will be stored into ``*_ts`` and true will be
      returned; false will be returned otherwise.
 
- (*) Get remote client epoch.
+ (#) Get remote client epoch::
 
 	u32 rxrpc_kernel_get_epoch(struct socket *sock,
 				   struct rxrpc_call *call)
@@ -1065,7 +1080,7 @@ The kernel interface functions are as follows:
      This value can be used to determine if the remote client has been
      restarted as it shouldn't change otherwise.
 
- (*) Set the maxmimum lifespan on a call.
+ (#) Set the maxmimum lifespan on a call::
 
 	void rxrpc_kernel_set_max_life(struct socket *sock,
 				       struct rxrpc_call *call,
@@ -1076,14 +1091,13 @@ The kernel interface functions are as follows:
      aborted and -ETIME or -ETIMEDOUT will be returned.
 
 
-=======================
-CONFIGURABLE PARAMETERS
+Configurable Parameters
 =======================
 
 The RxRPC protocol driver has a number of configurable parameters that can be
 adjusted through sysctls in /proc/net/rxrpc/:
 
- (*) req_ack_delay
+ (#) req_ack_delay
 
      The amount of time in milliseconds after receiving a packet with the
      request-ack flag set before we honour the flag and actually send the
@@ -1093,60 +1107,60 @@ adjusted through sysctls in /proc/net/rxrpc/:
      reception window is full (to a maximum of 255 packets), so delaying the
      ACK permits several packets to be ACK'd in one go.
 
- (*) soft_ack_delay
+ (#) soft_ack_delay
 
      The amount of time in milliseconds after receiving a new packet before we
      generate a soft-ACK to tell the sender that it doesn't need to resend.
 
- (*) idle_ack_delay
+ (#) idle_ack_delay
 
      The amount of time in milliseconds after all the packets currently in the
      received queue have been consumed before we generate a hard-ACK to tell
      the sender it can free its buffers, assuming no other reason occurs that
      we would send an ACK.
 
- (*) resend_timeout
+ (#) resend_timeout
 
      The amount of time in milliseconds after transmitting a packet before we
      transmit it again, assuming no ACK is received from the receiver telling
      us they got it.
 
- (*) max_call_lifetime
+ (#) max_call_lifetime
 
      The maximum amount of time in seconds that a call may be in progress
      before we preemptively kill it.
 
- (*) dead_call_expiry
+ (#) dead_call_expiry
 
      The amount of time in seconds before we remove a dead call from the call
      list.  Dead calls are kept around for a little while for the purpose of
      repeating ACK and ABORT packets.
 
- (*) connection_expiry
+ (#) connection_expiry
 
      The amount of time in seconds after a connection was last used before we
      remove it from the connection list.  While a connection is in existence,
      it serves as a placeholder for negotiated security; when it is deleted,
      the security must be renegotiated.
 
- (*) transport_expiry
+ (#) transport_expiry
 
      The amount of time in seconds after a transport was last used before we
      remove it from the transport list.  While a transport is in existence, it
      serves to anchor the peer data and keeps the connection ID counter.
 
- (*) rxrpc_rx_window_size
+ (#) rxrpc_rx_window_size
 
      The size of the receive window in packets.  This is the maximum number of
      unconsumed received packets we're willing to hold in memory for any
      particular call.
 
- (*) rxrpc_rx_mtu
+ (#) rxrpc_rx_mtu
 
      The maximum packet MTU size that we're willing to receive in bytes.  This
      indicates to the peer whether we're willing to accept jumbo packets.
 
- (*) rxrpc_rx_jumbo_max
+ (#) rxrpc_rx_jumbo_max
 
      The maximum number of packets that we're willing to accept in a jumbo
      packet.  Non-terminal packets in a jumbo packet must contain a four byte
diff --git a/MAINTAINERS b/MAINTAINERS
index caab14c5c12b..93e1b253ae51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14637,7 +14637,7 @@ M:	David Howells <dhowells@redhat.com>
 L:	linux-afs@lists.infradead.org
 S:	Supported
 W:	https://www.infradead.org/~dhowells/kafs/
-F:	Documentation/networking/rxrpc.txt
+F:	Documentation/networking/rxrpc.rst
 F:	include/keys/rxrpc-type.h
 F:	include/net/af_rxrpc.h
 F:	include/trace/events/rxrpc.h
diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 57ebb29c26ad..d706bb408365 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -18,7 +18,7 @@ config AF_RXRPC
 	  This module at the moment only supports client operations and is
 	  currently incomplete.
 
-	  See Documentation/networking/rxrpc.txt.
+	  See Documentation/networking/rxrpc.rst.
 
 config AF_RXRPC_IPV6
 	bool "IPv6 support for RxRPC"
@@ -41,7 +41,7 @@ config AF_RXRPC_DEBUG
 	help
 	  Say Y here to make runtime controllable debugging messages appear.
 
-	  See Documentation/networking/rxrpc.txt.
+	  See Documentation/networking/rxrpc.rst.
 
 
 config RXKAD
@@ -56,4 +56,4 @@ config RXKAD
 	  Provide kerberos 4 and AFS kaserver security handling for AF_RXRPC
 	  through the use of the key retention service.
 
-	  See Documentation/networking/rxrpc.txt.
+	  See Documentation/networking/rxrpc.rst.
diff --git a/net/rxrpc/sysctl.c b/net/rxrpc/sysctl.c
index 2bbb38161851..174e903e18de 100644
--- a/net/rxrpc/sysctl.c
+++ b/net/rxrpc/sysctl.c
@@ -21,7 +21,7 @@ static const unsigned long max_jiffies = MAX_JIFFY_OFFSET;
 /*
  * RxRPC operating parameters.
  *
- * See Documentation/networking/rxrpc.txt and the variable definitions for more
+ * See Documentation/networking/rxrpc.rst and the variable definitions for more
  * information on the individual parameters.
  */
 static struct ctl_table rxrpc_sysctl_table[] = {
-- 
2.25.4

