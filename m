Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192B21B65C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGJN3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgGJN3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:29:07 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681E2C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 06:29:07 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id u8so2514593qvj.12
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 06:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NTnofLu+9TRuUrULV7euf90Y+NSA28bxeZWC71RJ14I=;
        b=PZn49n8iIbj7rQOCcnHcSS3EJPvscuCmORv8vBGEePioEjiJuEoRVRNGsxX91sZVmS
         tFUYKZfCo+mA8gRmmqrNb3pSEW/HN5tZvgZcoOv0sj+moLzfpkIXBjHrxJbQa6mAjoNF
         Ls+URq3opDcRLyd24m/k0DIy2o1Z88t2gEPK1LrPtVWC8RZ+DJaY0W7dcuR/IFSpWM6K
         YqKUg3TxJtuJ4lJKG3h63M7vTe1IBtuMI+8jwOz4VvqrDfKEwEoiZWw8ibzoujIcUBLk
         N7tAY0FOr2iI2CradLxGVm86Z+vm+/iCExDgVTIVoIMH6BADsIin+Ox8O+aeQJPvgbc4
         h7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NTnofLu+9TRuUrULV7euf90Y+NSA28bxeZWC71RJ14I=;
        b=cmYKRb9N7Ev97AvdDJGLGvgk5fVP/4mlnnJGC7Z3yTY9+gMsqgOWL/ubaWUTxa/twT
         zMzQcp2LyH0e00o33EkhupDAGJZBQtM2Qin61FqY4TgqNzGNDeiuO6UNgB53avhelCsU
         +GcDH7QT/gfIAiN9j2PaxHRSTZG4yrHqP5bCeYg7Gom5tZ5Aa+Q+OlyzlykrRAabSOeG
         PreiK8BRvKxyOzo+pStrprPePCAboIgu+v0QH84tmiJ9Ads6515U/IX6AkM4VbmIWTX7
         yTNwBvvz4p0HtHkcxerlFms9B4Jrl0A+9Dosro3/RQUDf9aEr81b9fZEp9fIQsoDYldw
         K3Fg==
X-Gm-Message-State: AOAM531x0Maih3EDb05ma0Duog7x53KOCKLvClfyYN6JZPN6vk9ZwNf4
        4M8BWmD104s/R638VzavdLCZOHwP
X-Google-Smtp-Source: ABdhPJxEAurLhRcXOI/IHeUJre9M64mcdMPfhmTawOz0hvNICS9lh5HkzyTv/xVOeo2qACnoEK9aag==
X-Received: by 2002:a05:6214:2d2:: with SMTP id g18mr66841169qvu.215.1594387745997;
        Fri, 10 Jul 2020 06:29:05 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:f693:9fff:fef4:3e8a])
        by smtp.gmail.com with ESMTPSA id p25sm7252528qki.107.2020.07.10.06.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 06:29:04 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, eric.dumazet@gmail.com, tom@herbertland.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next v2] icmp: support rfc 4884
Date:   Fri, 10 Jul 2020 09:29:02 -0400
Message-Id: <20200710132902.1957784-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Add setsockopt SOL_IP/IP_RECVERR_4884 to return the offset to an
extension struct if present.

ICMP messages may include an extension structure after the original
datagram. RFC 4884 standardized this behavior. It stores the offset
in words to the extension header in u8 icmphdr.un.reserved[1].

The field is valid only for ICMP types destination unreachable, time
exceeded and parameter problem, if length is at least 128 bytes and
entire packet does not exceed 576 bytes.

Return the offset to the start of the extension struct when reading an
ICMP error from the error queue, if it matches the above constraints.

Do not return the raw u8 field. Return the offset from the start of
the user buffer, in bytes. The kernel does not return the network and
transport headers, so subtract those.

Also validate the headers. Return the offset regardless of validation,
as an invalid extension must still not be misinterpreted as part of
the original datagram. Note that !invalid does not imply valid. If
the extension version does not match, no validation can take place,
for instance.

For backward compatibility, make this optional, set by setsockopt
SOL_IP/IP_RECVERR_RFC4884. For API example and feature test, see
github.com/wdebruij/kerneltools/blob/master/tests/recv_icmp_v2.c

For forward compatibility, reserve only setsockopt value 1, leaving
other bits for additional icmp extensions.

Changes
  v1->v2:
  - convert word offset to byte offset from start of user buffer
    - return in ee_data as u8 may be insufficient
  - define extension struct and object header structs
  - return len only if constraints met
  - if returning len, also validate

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 include/linux/icmp.h          |  4 ++
 include/net/inet_sock.h       |  1 +
 include/uapi/linux/errqueue.h | 14 ++++++-
 include/uapi/linux/icmp.h     | 22 +++++++++++
 include/uapi/linux/in.h       |  1 +
 net/ipv4/icmp.c               | 71 +++++++++++++++++++++++++++++++++++
 net/ipv4/ip_sockglue.c        | 12 ++++++
 7 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/include/linux/icmp.h b/include/linux/icmp.h
index 81ca84ce3119..8fc38a34cb20 100644
--- a/include/linux/icmp.h
+++ b/include/linux/icmp.h
@@ -15,6 +15,7 @@
 
 #include <linux/skbuff.h>
 #include <uapi/linux/icmp.h>
+#include <uapi/linux/errqueue.h>
 
 static inline struct icmphdr *icmp_hdr(const struct sk_buff *skb)
 {
@@ -35,4 +36,7 @@ static inline bool icmp_is_err(int type)
 	return false;
 }
 
+void ip_icmp_error_rfc4884(const struct sk_buff *skb,
+			   struct sock_ee_data_rfc4884 *out);
+
 #endif	/* _LINUX_ICMP_H */
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index a7ce00af6c44..a3702d1d4875 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -225,6 +225,7 @@ struct inet_sock {
 				mc_all:1,
 				nodefrag:1;
 	__u8			bind_address_no_port:1,
+				recverr_rfc4884:1,
 				defer_connect:1; /* Indicates that fastopen_connect is set
 						  * and cookie exists so we defer connect
 						  * until first data frame is written
diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
index ca5cb3e3c6df..3c70e8ac14b8 100644
--- a/include/uapi/linux/errqueue.h
+++ b/include/uapi/linux/errqueue.h
@@ -5,6 +5,13 @@
 #include <linux/types.h>
 #include <linux/time_types.h>
 
+/* RFC 4884: return offset to extension struct + validation */
+struct sock_ee_data_rfc4884 {
+	__u16	len;
+	__u8	flags;
+	__u8	reserved;
+};
+
 struct sock_extended_err {
 	__u32	ee_errno;	
 	__u8	ee_origin;
@@ -12,7 +19,10 @@ struct sock_extended_err {
 	__u8	ee_code;
 	__u8	ee_pad;
 	__u32   ee_info;
-	__u32   ee_data;
+	union	{
+		__u32   ee_data;
+		struct sock_ee_data_rfc4884 ee_rfc4884;
+	};
 };
 
 #define SO_EE_ORIGIN_NONE	0
@@ -31,6 +41,8 @@ struct sock_extended_err {
 #define SO_EE_CODE_TXTIME_INVALID_PARAM	1
 #define SO_EE_CODE_TXTIME_MISSED	2
 
+#define SO_EE_RFC4884_FLAG_INVALID	1
+
 /**
  *	struct scm_timestamping - timestamps exposed through cmsg
  *
diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index 5589eeb791ca..fb169a50895e 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -19,6 +19,7 @@
 #define _UAPI_LINUX_ICMP_H
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 #define ICMP_ECHOREPLY		0	/* Echo Reply			*/
 #define ICMP_DEST_UNREACH	3	/* Destination Unreachable	*/
@@ -95,5 +96,26 @@ struct icmp_filter {
 	__u32		data;
 };
 
+/* RFC 4884 extension struct: one per message */
+struct icmp_ext_hdr {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8		reserved1:4,
+			version:4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8		version:4,
+			reserved1:4;
+#else
+#error	"Please fix <asm/byteorder.h>"
+#endif
+	__u8		reserved2;
+	__sum16		checksum;
+};
+
+/* RFC 4884 extension object header: one for each object */
+struct icmp_extobj_hdr {
+	__be16		length;
+	__u8		class_num;
+	__u8		class_type;
+};
 
 #endif /* _UAPI_LINUX_ICMP_H */
diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 8533bf07450f..3d0d8231dc19 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -123,6 +123,7 @@ struct in_addr {
 #define IP_CHECKSUM	23
 #define IP_BIND_ADDRESS_NO_PORT	24
 #define IP_RECVFRAGSIZE	25
+#define IP_RECVERR_RFC4884	26
 
 /* IP_MTU_DISCOVER values */
 #define IP_PMTUDISC_DONT		0	/* Never send DF frames */
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 956a806649f7..730f5a87ae6f 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1116,6 +1116,77 @@ int icmp_rcv(struct sk_buff *skb)
 	goto drop;
 }
 
+static bool ip_icmp_error_rfc4884_validate(const struct sk_buff *skb, int off)
+{
+	struct icmp_extobj_hdr *objh, _objh;
+	struct icmp_ext_hdr *exth, _exth;
+	u16 olen;
+
+	exth = skb_header_pointer(skb, off, sizeof(_exth), &_exth);
+	if (!exth)
+		return false;
+	if (exth->version != 2)
+		return true;
+
+	if (exth->checksum &&
+	    csum_fold(skb_checksum(skb, off, skb->len - off, 0)))
+		return false;
+
+	off += sizeof(_exth);
+	while (off < skb->len) {
+		objh = skb_header_pointer(skb, off, sizeof(_objh), &_objh);
+		if (!objh)
+			return false;
+
+		olen = ntohs(objh->length);
+		if (olen < sizeof(_objh))
+			return false;
+
+		off += olen;
+		if (off > skb->len)
+			return false;
+	}
+
+	return true;
+}
+
+void ip_icmp_error_rfc4884(const struct sk_buff *skb,
+			   struct sock_ee_data_rfc4884 *out)
+{
+	int hlen, off;
+
+	switch (icmp_hdr(skb)->type) {
+	case ICMP_DEST_UNREACH:
+	case ICMP_TIME_EXCEEDED:
+	case ICMP_PARAMETERPROB:
+		break;
+	default:
+		return;
+	}
+
+	/* outer headers up to inner iph. skb->data is at inner payload */
+	hlen = -skb_transport_offset(skb) - sizeof(struct icmphdr);
+
+	/* per rfc 791: maximum packet length of 576 bytes */
+	if (hlen + skb->len > 576)
+		return;
+
+	/* per rfc 4884: minimal datagram length of 128 bytes */
+	off = icmp_hdr(skb)->un.reserved[1] * sizeof(u32);
+	if (off < 128)
+		return;
+
+	/* kernel has stripped headers: return payload offset in bytes */
+	off -= hlen;
+	if (off + sizeof(struct icmp_ext_hdr) > skb->len)
+		return;
+
+	out->len = off;
+
+	if (!ip_icmp_error_rfc4884_validate(skb, off))
+		out->flags |= SO_EE_RFC4884_FLAG_INVALID;
+}
+
 int icmp_err(struct sk_buff *skb, u32 info)
 {
 	struct iphdr *iph = (struct iphdr *)skb->data;
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 84ec3703c909..138c6bca4793 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -411,6 +411,9 @@ void ip_icmp_error(struct sock *sk, struct sk_buff *skb, int err,
 	serr->port = port;
 
 	if (skb_pull(skb, payload - skb->data)) {
+		if (inet_sk(sk)->recverr_rfc4884)
+			ip_icmp_error_rfc4884(skb, &serr->ee.ee_rfc4884);
+
 		skb_reset_transport_header(skb);
 		if (sock_queue_err_skb(sk, skb) == 0)
 			return;
@@ -755,6 +758,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case IP_RECVORIGDSTADDR:
 	case IP_CHECKSUM:
 	case IP_RECVFRAGSIZE:
+	case IP_RECVERR_RFC4884:
 		if (optlen >= sizeof(int)) {
 			if (get_user(val, (int __user *) optval))
 				return -EFAULT;
@@ -914,6 +918,11 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 		if (!val)
 			skb_queue_purge(&sk->sk_error_queue);
 		break;
+	case IP_RECVERR_RFC4884:
+		if (val < 0 || val > 1)
+			goto e_inval;
+		inet->recverr_rfc4884 = !!val;
+		break;
 	case IP_MULTICAST_TTL:
 		if (sk->sk_type == SOCK_STREAM)
 			goto e_inval;
@@ -1588,6 +1597,9 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	case IP_RECVERR:
 		val = inet->recverr;
 		break;
+	case IP_RECVERR_RFC4884:
+		val = inet->recverr_rfc4884;
+		break;
 	case IP_MULTICAST_TTL:
 		val = inet->mc_ttl;
 		break;
-- 
2.27.0.383.g050319c2ae-goog

