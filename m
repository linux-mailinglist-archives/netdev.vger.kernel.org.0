Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D32B3B1BA8
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhFWN5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:57:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38949 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230334AbhFWN5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 09:57:23 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3A56F5C0103;
        Wed, 23 Jun 2021 09:55:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 23 Jun 2021 09:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vtmGXF2gOg0tenqHe
        +3xsWB/EUrU/lgdMIbnAB9fmQ8=; b=iwVPWyMG+LNHewDIK6Rx3fGc5ygfrj6zn
        Unaw9MHZWNhXz7vipKcmMDGb7NajawvlVXHyXGILtNbhs/ncoicwIHvNmQB00oBi
        qr2WDMTwP+FsdpX961V6rUddATyKqG+rUwbwqINoNZPwJ61uCjhXBUxOYEyLk66S
        IFNs/GIn0qQrxwuQNJxDAPECRTM8Wm2hEugClddaq7KqbVHMXMmWq2nhZPPuEcF2
        QxCdsuYH59phBzFpT3yRy1afu+dGZbIZMeYIx1C2EUG/XeICJ5/FyYULAZYP6BNU
        X+nSK/poTHEceyTF4f4hlMstfRYxm3iDLLVDJHKcYOoW21HOhSm2g==
X-ME-Sender: <xms:OD3TYDkJOWSCDUrtBg2_X4YSkVSyIarCzVA07LYPLD2Gj2QfVHw2yA>
    <xme:OD3TYG0_FCH7pBOX-PLI0yd2_A10rwVzhS0yfExsFyeybPehhIcX0mSBbKehF3wtW
    l0eLWzddNIVIcdT30k>
X-ME-Received: <xmr:OD3TYJpHdzwf1dd3Gb2qQ_GOMEAt6j3lk0eAm3enwF2xf38-tI5j7YVhcHTiuzT8SerhMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegfedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepofgrrhhthihnrghsucfruhhmphhuthhishcuoehmsehlrghmsggu
    rgdrlhhtqeenucggtffrrghtthgvrhhnpedvvdeguedvheejgeeutdeuffehfeffhfdtge
    eujeekudduiefggeekgeejfffgheenucffohhmrghinhepkhekshdrihhonecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmheslhgrmhgsuggrrd
    hlth
X-ME-Proxy: <xmx:OD3TYLlE-bvYc5KX50DrN7UnkBDJm_35c_017q-JJgq1kH_ImnvhoQ>
    <xmx:OD3TYB09sAE5PZSgdkUELd1rmCMxej-yV3fEV6ublysFPXjH3UT13w>
    <xmx:OD3TYKuvlAyHGjlgOwBhO65nySv6mvVDmUNqkUGi0y3oCD7V1tYfIg>
    <xmx:OT3TYKw_pXaSkhEC4E8rsmlqGEbqrItkzK0uWVXaCYXG-8BfZ9HTvw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 09:55:03 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        m@lambda.lt, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH net-next v2 1/2] net: retrieve netns cookie via getsocketopt
Date:   Wed, 23 Jun 2021 15:56:45 +0200
Message-Id: <20210623135646.1632083-1-m@lambda.lt>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's getting more common to run nested container environments for
testing cloud software. One of such examples is Kind [1] which runs a
Kubernetes cluster in Docker containers on a single host. Each container
acts as a Kubernetes node, and thus can run any Pod (aka container)
inside the former. This approach simplifies testing a lot, as it
eliminates complicated VM setups.

Unfortunately, such a setup breaks some functionality when cgroupv2 BPF
programs are used for load-balancing. The load-balancer BPF program
needs to detect whether a request originates from the host netns or a
container netns in order to allow some access, e.g. to a service via a
loopback IP address. Typically, the programs detect this by comparing
netns cookies with the one of the init ns via a call to
bpf_get_netns_cookie(NULL). However, in nested environments the latter
cannot be used given the Kubernetes node's netns is outside the init ns.
To fix this, we need to pass the Kubernetes node netns cookie to the
program in a different way: by extending getsockopt() with a
SO_NETNS_COOKIE option, the orchestrator which runs in the Kubernetes
node netns can retrieve the cookie and pass it to the program instead.

Thus, this is following up on Eric's commit 3d368ab87cf6 ("net:
initialize net->net_cookie at netns setup") to allow retrieval via
SO_NETNS_COOKIE.  This is also in line in how we retrieve socket cookie
via SO_COOKIE.

  [1] https://kind.sigs.k8s.io/

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Martynas Pumputis <m@lambda.lt>
Cc: Eric Dumazet <edumazet@google.com>
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 include/uapi/asm-generic/socket.h     | 2 ++
 net/core/sock.c                       | 7 +++++++
 6 files changed, 17 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 57420356ce4c..6b3daba60987 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -127,6 +127,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index 2d949969313b..cdf404a831b2 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -138,6 +138,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index f60904329bbc..5b5351cdcb33 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -119,6 +119,8 @@
 #define SO_PREFER_BUSY_POLL	0x4043
 #define SO_BUSY_POLL_BUDGET	0x4044
 
+#define SO_NETNS_COOKIE		0x4045
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 848a22fbac20..92675dc380fa 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -120,6 +120,8 @@
 #define SO_PREFER_BUSY_POLL	 0x0048
 #define SO_BUSY_POLL_BUDGET	 0x0049
 
+#define SO_NETNS_COOKIE          0x0050
+
 #if !defined(__KERNEL__)
 
 
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 4dcd13d097a9..d588c244ec2f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -122,6 +122,8 @@
 #define SO_PREFER_BUSY_POLL	69
 #define SO_BUSY_POLL_BUDGET	70
 
+#define SO_NETNS_COOKIE		71
+
 #if !defined(__KERNEL__)
 
 #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
diff --git a/net/core/sock.c b/net/core/sock.c
index ddfa88082a2b..a2337b37eba6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1635,6 +1635,13 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		v.val = sk->sk_bound_dev_if;
 		break;
 
+	case SO_NETNS_COOKIE:
+		lv = sizeof(u64);
+		if (len != lv)
+			return -EINVAL;
+		v.val64 = sock_net(sk)->net_cookie;
+		break;
+
 	default:
 		/* We implement the SO_SNDLOWAT etc to not be settable
 		 * (1003.1g 7).
-- 
2.32.0

