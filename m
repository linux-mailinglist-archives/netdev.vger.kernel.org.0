Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE451B5CB9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbgDWNjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:39:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728427AbgDWNju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 09:39:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587649189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=57dMSVnzCmJ5bilGBb9vLm68XEbIGWGDck0dS82c+3E=;
        b=JbPN8TkQ99LXWiPcUpJTuKPnxPHz9PRSImm/WbfqYgtlkWxcwo/064LQGQzIglMhLqpdAq
        zmeRpClYa1tkaeHRiheuJFGp7HO8iMqV2BPfzBTqsydta+IzMV/YE1H3mE1dtebKq8Cgsu
        wFL578IEAKnn4E0/UTDmkiLnNc0qZv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-AcPpI20eNYKscHhNz43yWQ-1; Thu, 23 Apr 2020 09:39:22 -0400
X-MC-Unique: AcPpI20eNYKscHhNz43yWQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BE6C18FE860;
        Thu, 23 Apr 2020 13:39:21 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-154.ams2.redhat.com [10.36.114.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8B471001281;
        Thu, 23 Apr 2020 13:39:19 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     stephen@networkplumber.org, netdev@vger.kernel.org
Cc:     dcaratti@redhat.com
Subject: [PATCH iproute2-next 3/4] ss: allow dumping MPTCP subflow information
Date:   Thu, 23 Apr 2020 15:37:09 +0200
Message-Id: <f0c2afc11fc35a258f8abeab94f1ddea0bd8910d.1587572928.git.pabeni@redhat.com>
In-Reply-To: <cover.1587572928.git.pabeni@redhat.com>
References: <cover.1587572928.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

 [root@f31 packetdrill]# ss -tni

 ESTAB    0        0           192.168.82.247:8080           192.0.2.1:35=
273
          cubic wscale:7,8 [...] tcp-ulp-mptcp flags:Mec token:0000(id:0)=
/5f856c60(id:0) seq:b810457db34209a5 sfseq:1 ssnoff:0 maplen:190

Additionally extends ss manpage to describe the new entry layout.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 man/man8/ss.8 |  5 +++++
 misc/ss.c     | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/man/man8/ss.8 b/man/man8/ss.8
index 023d771b..c80853f9 100644
--- a/man/man8/ss.8
+++ b/man/man8/ss.8
@@ -261,6 +261,11 @@ the pacing rate and max pacing rate
 .TP
 .B rcv_space:<rcv_space>
 a helper variable for TCP internal auto tuning socket receive buffer
+.P
+.TP
+.B tcp-ulp-mptcp flags:[MmBbJjecv] token:<rem_token(rem_id)/loc_token(lo=
c_id)> seq:<sn> sfseq:<ssn> ssnoff:<off> maplen:<maplen>
+MPTCP subflow information
+.P
 .RE
 .TP
 .B \-\-tos
diff --git a/misc/ss.c b/misc/ss.c
index 3ef151fb..ee840149 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -53,6 +53,7 @@
 #include <linux/tipc_netlink.h>
 #include <linux/tipc_sockets_diag.h>
 #include <linux/tls.h>
+#include <linux/mptcp.h>
=20
 /* AF_VSOCK/PF_VSOCK is only provided since glibc 2.18 */
 #ifndef PF_VSOCK
@@ -2836,6 +2837,59 @@ static void tcp_tls_conf(const char *name, struct =
rtattr *attr)
 	}
 }
=20
+static void mptcp_subflow_info(struct rtattr *tb[])
+{
+	u_int32_t flags =3D 0;
+
+	if (tb[MPTCP_SUBFLOW_ATTR_FLAGS]) {
+		char caps[32 + 1] =3D { 0 }, *cap =3D &caps[0];
+
+		flags =3D rta_getattr_u32(tb[MPTCP_SUBFLOW_ATTR_FLAGS]);
+
+		if (flags & MPTCP_SUBFLOW_FLAG_MCAP_REM)
+			*cap++ =3D 'M';
+		if (flags & MPTCP_SUBFLOW_FLAG_MCAP_LOC)
+			*cap++ =3D 'm';
+		if (flags & MPTCP_SUBFLOW_FLAG_JOIN_REM)
+			*cap++ =3D 'J';
+		if (flags & MPTCP_SUBFLOW_FLAG_JOIN_LOC)
+			*cap++ =3D 'j';
+		if (flags & MPTCP_SUBFLOW_FLAG_BKUP_REM)
+			*cap++ =3D 'B';
+		if (flags & MPTCP_SUBFLOW_FLAG_BKUP_LOC)
+			*cap++ =3D 'b';
+		if (flags & MPTCP_SUBFLOW_FLAG_FULLY_ESTABLISHED)
+			*cap++ =3D 'e';
+		if (flags & MPTCP_SUBFLOW_FLAG_CONNECTED)
+			*cap++ =3D 'c';
+		if (flags & MPTCP_SUBFLOW_FLAG_MAPVALID)
+			*cap++ =3D 'v';
+		if (flags)
+			out(" flags:%s", caps);
+	}
+	if (tb[MPTCP_SUBFLOW_ATTR_TOKEN_REM] &&
+	    tb[MPTCP_SUBFLOW_ATTR_TOKEN_LOC] &&
+	    tb[MPTCP_SUBFLOW_ATTR_ID_REM] &&
+	    tb[MPTCP_SUBFLOW_ATTR_ID_LOC])
+		out(" token:%04x(id:%hhu)/%04x(id:%hhu)",
+		    rta_getattr_u32(tb[MPTCP_SUBFLOW_ATTR_TOKEN_REM]),
+		    rta_getattr_u8(tb[MPTCP_SUBFLOW_ATTR_ID_REM]),
+		    rta_getattr_u32(tb[MPTCP_SUBFLOW_ATTR_TOKEN_LOC]),
+		    rta_getattr_u8(tb[MPTCP_SUBFLOW_ATTR_ID_LOC]));
+	if (tb[MPTCP_SUBFLOW_ATTR_MAP_SEQ])
+		out(" seq:%llx",
+		    rta_getattr_u64(tb[MPTCP_SUBFLOW_ATTR_MAP_SEQ]));
+	if (tb[MPTCP_SUBFLOW_ATTR_MAP_SFSEQ])
+		out(" sfseq:%x",
+		    rta_getattr_u32(tb[MPTCP_SUBFLOW_ATTR_MAP_SFSEQ]));
+	if (tb[MPTCP_SUBFLOW_ATTR_SSN_OFFSET])
+		out(" ssnoff:%x",
+		    rta_getattr_u32(tb[MPTCP_SUBFLOW_ATTR_SSN_OFFSET]));
+	if (tb[MPTCP_SUBFLOW_ATTR_MAP_DATALEN])
+		out(" maplen:%x",
+		    rta_getattr_u32(tb[MPTCP_SUBFLOW_ATTR_MAP_DATALEN]));
+}
+
 #define TCPI_HAS_OPT(info, opt) !!(info->tcpi_options & (opt))
=20
 static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_m=
sg *r,
@@ -3012,6 +3066,14 @@ static void tcp_show_info(const struct nlmsghdr *n=
lh, struct inet_diag_msg *r,
 			tcp_tls_conf("rxconf", tlsinfo[TLS_INFO_RXCONF]);
 			tcp_tls_conf("txconf", tlsinfo[TLS_INFO_TXCONF]);
 		}
+		if (ulpinfo[INET_ULP_INFO_MPTCP]) {
+			struct rtattr *sfinfo[MPTCP_SUBFLOW_ATTR_MAX + 1] =3D
+				{ 0 };
+
+			parse_rtattr_nested(sfinfo, MPTCP_SUBFLOW_ATTR_MAX,
+					    ulpinfo[INET_ULP_INFO_MPTCP]);
+			mptcp_subflow_info(sfinfo);
+		}
 	}
 }
=20
--=20
2.21.1

