Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C428340C04
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 18:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhCRRmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 13:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhCRRmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 13:42:40 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C96EC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 10:42:29 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id l1so1915764pgb.5
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 10:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6zgdcyasL5gSn5/OYTXeeQH0KYbZImL9wAReE+GOzqE=;
        b=pyurb1xKIt2pqi3vgNAudQ3rc0+p7GYbfkxJWy55R6sZUCCeCYREpdzs9DKSwlWPWY
         66LCFHFvfI/Gh6i19xEH06/tvR7otp3iOaP6WwLZ8YR/V7ry8++/aGLub6OgTXqu1h9L
         apmXbyNHEoGvMSbtMlddH7Ws1DuFEI9DKCOeull3kSuzhYqUDxPBEvPtay9VYXb/E/wK
         oVEreWtThLlR+S40ks2vJXKPPOlhtCNX0BNjkeKaVCvqAenyBKZn72x4DaTqYanCanUF
         oTEpnwG4HND/IL0pRwZ56ZWOY5Mk57tYdk9lGRoem2tyWYCrKtq90Rz+9s/1/nGAyte4
         XXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6zgdcyasL5gSn5/OYTXeeQH0KYbZImL9wAReE+GOzqE=;
        b=S523n63XRxEL/dcqnVh+KwbILcEM+0xR2r5HPj/86QyVwBO7UOUOyVdAW2qHwWVAvA
         CwLtLgtX58hBrXLVkMSdWcM2pd6e0VW4r7yE3kdYY9njMyDnQRYd48pjI6YKN5CaEffQ
         +bGVtgRlKr+7bieO2/hRNVJWdQniiJlr7RjtaLNhCOOApNssO/paUT6yzsqIbU+16yph
         jVQ+v8joPBis18eY67RobpiQx60yy75hYaVCchCnfpZ1gTFNNxVTE37/oS6gg7x3c2u2
         gk1iGbTihX4OM0zdRRIlwt2TwVNY/N8V93PzfPhKWjO/PxRpj2j/eSBJXlZhysXvu1C1
         XcDg==
X-Gm-Message-State: AOAM532L/X17q/TIVg1cL/bh2SefWGButFyLl+3/+kqsusmedm77mB7J
        2tQJpVVfu+SRDq74famLd4ejWMp3QrItRQ==
X-Google-Smtp-Source: ABdhPJwyI7nw4Pxp6XPah/6MWcNM3mKrmT3MHO4jw6gkyIzk+zDNC7iBH97oEr6fQwzh/0cSWMWpIw==
X-Received: by 2002:a62:1557:0:b029:20d:6986:627e with SMTP id 84-20020a6215570000b029020d6986627emr5212736pfv.21.1616089347803;
        Thu, 18 Mar 2021 10:42:27 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id q22sm2955718pfk.2.2021.03.18.10.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 10:42:27 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] iplink: remove support for non-netlink configuration
Date:   Thu, 18 Mar 2021 10:42:19 -0700
Message-Id: <20210318174219.85683-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configuration via netlink NEWLINK message was always preferred
method, but iproute2 retained compatiablity mode for older kernels.

The code to use RTM_NEWLINK was introduced way back in 2.6.19 kernel
and there is no longer a requirement to support this backward
compatability.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/iplink.c | 490 ++++------------------------------------------------
 1 file changed, 35 insertions(+), 455 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index faafd7e89d6c..5c4dbf767100 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -33,8 +33,6 @@
 #include "ip_common.h"
 #include "namespace.h"
 
-#define IPLINK_IOCTL_COMPAT	1
-
 #ifndef GSO_MAX_SIZE
 #define GSO_MAX_SIZE		65536
 #endif
@@ -42,9 +40,7 @@
 #define GSO_MAX_SEGS		65535
 #endif
 
-
 static void usage(void) __attribute__((noreturn));
-static int iplink_have_newlink(void);
 
 void iplink_types_usage(void)
 {
@@ -61,25 +57,21 @@ void iplink_types_usage(void)
 
 void iplink_usage(void)
 {
-	if (iplink_have_newlink()) {
-		fprintf(stderr,
-			"Usage: ip link add [link DEV] [ name ] NAME\n"
-			"		    [ txqueuelen PACKETS ]\n"
-			"		    [ address LLADDR ]\n"
-			"		    [ broadcast LLADDR ]\n"
-			"		    [ mtu MTU ] [index IDX ]\n"
-			"		    [ numtxqueues QUEUE_COUNT ]\n"
-			"		    [ numrxqueues QUEUE_COUNT ]\n"
-			"		    type TYPE [ ARGS ]\n"
-			"\n"
-			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
-			"\n"
-			"	ip link set { DEVICE | dev DEVICE | group DEVGROUP }\n"
-			"			[ { up | down } ]\n"
-			"			[ type TYPE ARGS ]\n");
-	} else
-		fprintf(stderr,
-			"Usage: ip link set DEVICE [ { up | down } ]\n");
+	fprintf(stderr,
+		"Usage: ip link add [link DEV] [ name ] NAME\n"
+		"		    [ txqueuelen PACKETS ]\n"
+		"		    [ address LLADDR ]\n"
+		"		    [ broadcast LLADDR ]\n"
+		"		    [ mtu MTU ] [index IDX ]\n"
+		"		    [ numtxqueues QUEUE_COUNT ]\n"
+		"		    [ numrxqueues QUEUE_COUNT ]\n"
+		"		    type TYPE [ ARGS ]\n"
+		"\n"
+		"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
+		"\n"
+		"	ip link set { DEVICE | dev DEVICE | group DEVGROUP }\n"
+		"			[ { up | down } ]\n"
+		"			[ type TYPE ARGS ]\n");
 
 	fprintf(stderr,
 		"		[ arp { on | off } ]\n"
@@ -126,13 +118,11 @@ void iplink_usage(void)
 		"	ip link property add dev DEVICE [ altname NAME .. ]\n"
 		"	ip link property del dev DEVICE [ altname NAME .. ]\n");
 
-	if (iplink_have_newlink()) {
-		fprintf(stderr,
-			"\n"
-			"	ip link help [ TYPE ]\n"
-			"\n");
-		iplink_types_usage();
-	}
+	fprintf(stderr,
+		"\n"
+		"	ip link help [ TYPE ]\n"
+		"\n");
+	iplink_types_usage();
 	exit(-1);
 }
 
@@ -206,51 +196,6 @@ static int get_addr_gen_mode(const char *mode)
 	return -1;
 }
 
-#if IPLINK_IOCTL_COMPAT
-static int have_rtnl_newlink = -1;
-
-static int accept_msg(struct rtnl_ctrl_data *ctrl,
-		      struct nlmsghdr *n, void *arg)
-{
-	struct nlmsgerr *err = (struct nlmsgerr *)NLMSG_DATA(n);
-
-	if (n->nlmsg_type == NLMSG_ERROR &&
-	    (err->error == -EOPNOTSUPP || err->error == -EINVAL))
-		have_rtnl_newlink = 0;
-	else
-		have_rtnl_newlink = 1;
-	return -1;
-}
-
-static int iplink_have_newlink(void)
-{
-	struct {
-		struct nlmsghdr		n;
-		struct ifinfomsg	i;
-		char			buf[1024];
-	} req = {
-		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
-		.n.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK,
-		.n.nlmsg_type = RTM_NEWLINK,
-		.i.ifi_family = AF_UNSPEC,
-	};
-
-	if (have_rtnl_newlink < 0) {
-		if (rtnl_send(&rth, &req.n, req.n.nlmsg_len) < 0) {
-			perror("request send failed");
-			exit(1);
-		}
-		rtnl_listen(&rth, accept_msg, NULL);
-	}
-	return have_rtnl_newlink;
-}
-#else /* IPLINK_IOCTL_COMPAT */
-static int iplink_have_newlink(void)
-{
-	return 1;
-}
-#endif /* ! IPLINK_IOCTL_COMPAT */
-
 static int nl_get_ll_addr_len(const char *ifname)
 {
 	int len;
@@ -1137,364 +1082,6 @@ int iplink_get(char *name, __u32 filt_mask)
 	return 0;
 }
 
-#if IPLINK_IOCTL_COMPAT
-static int get_ctl_fd(void)
-{
-	int s_errno;
-	int fd;
-
-	fd = socket(PF_INET, SOCK_DGRAM, 0);
-	if (fd >= 0)
-		return fd;
-	s_errno = errno;
-	fd = socket(PF_PACKET, SOCK_DGRAM, 0);
-	if (fd >= 0)
-		return fd;
-	fd = socket(PF_INET6, SOCK_DGRAM, 0);
-	if (fd >= 0)
-		return fd;
-	errno = s_errno;
-	perror("Cannot create control socket");
-	return -1;
-}
-
-static int do_chflags(const char *dev, __u32 flags, __u32 mask)
-{
-	struct ifreq ifr;
-	int fd;
-	int err;
-
-	strlcpy(ifr.ifr_name, dev, IFNAMSIZ);
-	fd = get_ctl_fd();
-	if (fd < 0)
-		return -1;
-	err = ioctl(fd, SIOCGIFFLAGS, &ifr);
-	if (err) {
-		perror("SIOCGIFFLAGS");
-		close(fd);
-		return -1;
-	}
-	if ((ifr.ifr_flags^flags)&mask) {
-		ifr.ifr_flags &= ~mask;
-		ifr.ifr_flags |= mask&flags;
-		err = ioctl(fd, SIOCSIFFLAGS, &ifr);
-		if (err)
-			perror("SIOCSIFFLAGS");
-	}
-	close(fd);
-	return err;
-}
-
-static int do_changename(const char *dev, const char *newdev)
-{
-	struct ifreq ifr;
-	int fd;
-	int err;
-
-	strlcpy(ifr.ifr_name, dev, IFNAMSIZ);
-	strlcpy(ifr.ifr_newname, newdev, IFNAMSIZ);
-	fd = get_ctl_fd();
-	if (fd < 0)
-		return -1;
-	err = ioctl(fd, SIOCSIFNAME, &ifr);
-	if (err) {
-		perror("SIOCSIFNAME");
-		close(fd);
-		return -1;
-	}
-	close(fd);
-	return err;
-}
-
-static int set_qlen(const char *dev, int qlen)
-{
-	struct ifreq ifr = { .ifr_qlen = qlen };
-	int s;
-
-	s = get_ctl_fd();
-	if (s < 0)
-		return -1;
-
-	strlcpy(ifr.ifr_name, dev, IFNAMSIZ);
-	if (ioctl(s, SIOCSIFTXQLEN, &ifr) < 0) {
-		perror("SIOCSIFXQLEN");
-		close(s);
-		return -1;
-	}
-	close(s);
-
-	return 0;
-}
-
-static int set_mtu(const char *dev, int mtu)
-{
-	struct ifreq ifr = { .ifr_mtu = mtu };
-	int s;
-
-	s = get_ctl_fd();
-	if (s < 0)
-		return -1;
-
-	strlcpy(ifr.ifr_name, dev, IFNAMSIZ);
-	if (ioctl(s, SIOCSIFMTU, &ifr) < 0) {
-		perror("SIOCSIFMTU");
-		close(s);
-		return -1;
-	}
-	close(s);
-
-	return 0;
-}
-
-static int get_address(const char *dev, int *htype)
-{
-	struct ifreq ifr = {};
-	struct sockaddr_ll me = {
-		.sll_family = AF_PACKET,
-		.sll_protocol = htons(ETH_P_LOOP),
-	};
-	socklen_t alen;
-	int s;
-
-	s = socket(PF_PACKET, SOCK_DGRAM, 0);
-	if (s < 0) {
-		perror("socket(PF_PACKET)");
-		return -1;
-	}
-
-	strlcpy(ifr.ifr_name, dev, IFNAMSIZ);
-	if (ioctl(s, SIOCGIFINDEX, &ifr) < 0) {
-		perror("SIOCGIFINDEX");
-		close(s);
-		return -1;
-	}
-
-	me.sll_ifindex = ifr.ifr_ifindex;
-	if (bind(s, (struct sockaddr *)&me, sizeof(me)) == -1) {
-		perror("bind");
-		close(s);
-		return -1;
-	}
-
-	alen = sizeof(me);
-	if (getsockname(s, (struct sockaddr *)&me, &alen) == -1) {
-		perror("getsockname");
-		close(s);
-		return -1;
-	}
-	close(s);
-	*htype = me.sll_hatype;
-	return me.sll_halen;
-}
-
-static int parse_address(const char *dev, int hatype, int halen,
-		char *lla, struct ifreq *ifr)
-{
-	int alen;
-
-	memset(ifr, 0, sizeof(*ifr));
-	strlcpy(ifr->ifr_name, dev, IFNAMSIZ);
-	ifr->ifr_hwaddr.sa_family = hatype;
-	alen = ll_addr_a2n(ifr->ifr_hwaddr.sa_data, 14, lla);
-	if (alen < 0)
-		return -1;
-	if (alen != halen) {
-		fprintf(stderr,
-			"Wrong address (%s) length: expected %d bytes\n",
-			lla, halen);
-		return -1;
-	}
-	return 0;
-}
-
-static int set_address(struct ifreq *ifr, int brd)
-{
-	int s;
-
-	s = get_ctl_fd();
-	if (s < 0)
-		return -1;
-	if (ioctl(s, brd?SIOCSIFHWBROADCAST:SIOCSIFHWADDR, ifr) < 0) {
-		perror(brd?"SIOCSIFHWBROADCAST":"SIOCSIFHWADDR");
-		close(s);
-		return -1;
-	}
-	close(s);
-	return 0;
-}
-
-static int do_set(int argc, char **argv)
-{
-	char *dev = NULL;
-	__u32 mask = 0;
-	__u32 flags = 0;
-	int qlen = -1;
-	int mtu = -1;
-	char *newaddr = NULL;
-	char *newbrd = NULL;
-	struct ifreq ifr0, ifr1;
-	char *newname = NULL;
-	int htype, halen;
-
-	while (argc > 0) {
-		if (strcmp(*argv, "up") == 0) {
-			mask |= IFF_UP;
-			flags |= IFF_UP;
-		} else if (strcmp(*argv, "down") == 0) {
-			mask |= IFF_UP;
-			flags &= ~IFF_UP;
-		} else if (strcmp(*argv, "name") == 0) {
-			NEXT_ARG();
-			if (check_ifname(*argv))
-				invarg("\"name\" not a valid ifname", *argv);
-			newname = *argv;
-		} else if (matches(*argv, "address") == 0) {
-			NEXT_ARG();
-			newaddr = *argv;
-		} else if (matches(*argv, "broadcast") == 0 ||
-			   strcmp(*argv, "brd") == 0) {
-			NEXT_ARG();
-			newbrd = *argv;
-		} else if (matches(*argv, "txqueuelen") == 0 ||
-			   strcmp(*argv, "qlen") == 0 ||
-			   matches(*argv, "txqlen") == 0) {
-			NEXT_ARG();
-			if (qlen != -1)
-				duparg("txqueuelen", *argv);
-			if (get_integer(&qlen,  *argv, 0))
-				invarg("Invalid \"txqueuelen\" value\n", *argv);
-		} else if (strcmp(*argv, "mtu") == 0) {
-			NEXT_ARG();
-			if (mtu != -1)
-				duparg("mtu", *argv);
-			if (get_integer(&mtu, *argv, 0))
-				invarg("Invalid \"mtu\" value\n", *argv);
-		} else if (strcmp(*argv, "multicast") == 0) {
-			NEXT_ARG();
-			mask |= IFF_MULTICAST;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_MULTICAST;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_MULTICAST;
-			else
-				return on_off("multicast", *argv);
-		} else if (strcmp(*argv, "allmulticast") == 0) {
-			NEXT_ARG();
-			mask |= IFF_ALLMULTI;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_ALLMULTI;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_ALLMULTI;
-			else
-				return on_off("allmulticast", *argv);
-		} else if (strcmp(*argv, "promisc") == 0) {
-			NEXT_ARG();
-			mask |= IFF_PROMISC;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_PROMISC;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_PROMISC;
-			else
-				return on_off("promisc", *argv);
-		} else if (strcmp(*argv, "trailers") == 0) {
-			NEXT_ARG();
-			mask |= IFF_NOTRAILERS;
-
-			if (strcmp(*argv, "off") == 0)
-				flags |= IFF_NOTRAILERS;
-			else if (strcmp(*argv, "on") == 0)
-				flags &= ~IFF_NOTRAILERS;
-			else
-				return on_off("trailers", *argv);
-		} else if (strcmp(*argv, "arp") == 0) {
-			NEXT_ARG();
-			mask |= IFF_NOARP;
-
-			if (strcmp(*argv, "on") == 0)
-				flags &= ~IFF_NOARP;
-			else if (strcmp(*argv, "off") == 0)
-				flags |= IFF_NOARP;
-			else
-				return on_off("arp", *argv);
-		} else if (matches(*argv, "dynamic") == 0) {
-			NEXT_ARG();
-			mask |= IFF_DYNAMIC;
-
-			if (strcmp(*argv, "on") == 0)
-				flags |= IFF_DYNAMIC;
-			else if (strcmp(*argv, "off") == 0)
-				flags &= ~IFF_DYNAMIC;
-			else
-				return on_off("dynamic", *argv);
-		} else {
-			if (strcmp(*argv, "dev") == 0)
-				NEXT_ARG();
-			else if (matches(*argv, "help") == 0)
-				usage();
-
-			if (dev)
-				duparg2("dev", *argv);
-			if (check_ifname(*argv))
-				invarg("\"dev\" not a valid ifname", *argv);
-			dev = *argv;
-		}
-		argc--; argv++;
-	}
-
-	if (!dev) {
-		fprintf(stderr,
-			"Not enough of information: \"dev\" argument is required.\n");
-		exit(-1);
-	}
-
-	if (newaddr || newbrd) {
-		halen = get_address(dev, &htype);
-		if (halen < 0)
-			return -1;
-		if (newaddr) {
-			if (parse_address(dev, htype, halen,
-					  newaddr, &ifr0) < 0)
-				return -1;
-		}
-		if (newbrd) {
-			if (parse_address(dev, htype, halen,
-					  newbrd, &ifr1) < 0)
-				return -1;
-		}
-	}
-
-	if (newname && strcmp(dev, newname)) {
-		if (do_changename(dev, newname) < 0)
-			return -1;
-		dev = newname;
-	}
-	if (qlen != -1) {
-		if (set_qlen(dev, qlen) < 0)
-			return -1;
-	}
-	if (mtu != -1) {
-		if (set_mtu(dev, mtu) < 0)
-			return -1;
-	}
-	if (newaddr || newbrd) {
-		if (newbrd) {
-			if (set_address(&ifr1, 1) < 0)
-				return -1;
-		}
-		if (newaddr) {
-			if (set_address(&ifr0, 0) < 0)
-				return -1;
-		}
-	}
-	if (mask)
-		return do_chflags(dev, flags, mask);
-	return 0;
-}
-#endif /* IPLINK_IOCTL_COMPAT */
-
 static void print_mpls_stats(FILE *fp, struct rtattr *attr)
 {
 	struct rtattr *mrtb[MPLS_STATS_MAX+1];
@@ -1730,28 +1317,21 @@ int do_iplink(int argc, char **argv)
 	if (argc < 1)
 		return ipaddr_list_link(0, NULL);
 
-	if (iplink_have_newlink()) {
-		if (matches(*argv, "add") == 0)
-			return iplink_modify(RTM_NEWLINK,
-					     NLM_F_CREATE|NLM_F_EXCL,
-					     argc-1, argv+1);
-		if (matches(*argv, "set") == 0 ||
-		    matches(*argv, "change") == 0)
-			return iplink_modify(RTM_NEWLINK, 0,
-					     argc-1, argv+1);
-		if (matches(*argv, "replace") == 0)
-			return iplink_modify(RTM_NEWLINK,
-					     NLM_F_CREATE|NLM_F_REPLACE,
-					     argc-1, argv+1);
-		if (matches(*argv, "delete") == 0)
-			return iplink_modify(RTM_DELLINK, 0,
-					     argc-1, argv+1);
-	} else {
-#if IPLINK_IOCTL_COMPAT
-		if (matches(*argv, "set") == 0)
-			return do_set(argc-1, argv+1);
-#endif
-	}
+	if (matches(*argv, "add") == 0)
+		return iplink_modify(RTM_NEWLINK,
+				     NLM_F_CREATE|NLM_F_EXCL,
+				     argc-1, argv+1);
+	if (matches(*argv, "set") == 0 ||
+	    matches(*argv, "change") == 0)
+		return iplink_modify(RTM_NEWLINK, 0,
+				     argc-1, argv+1);
+	if (matches(*argv, "replace") == 0)
+		return iplink_modify(RTM_NEWLINK,
+				     NLM_F_CREATE|NLM_F_REPLACE,
+				     argc-1, argv+1);
+	if (matches(*argv, "delete") == 0)
+		return iplink_modify(RTM_DELLINK, 0,
+				     argc-1, argv+1);
 
 	if (matches(*argv, "show") == 0 ||
 	    matches(*argv, "lst") == 0 ||
-- 
2.30.2

