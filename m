Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC8B1EC9C9
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgFCGyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgFCGyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:54:51 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB73C05BD43;
        Tue,  2 Jun 2020 23:54:51 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id p5so1050706wrw.9;
        Tue, 02 Jun 2020 23:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iUBsdEKJAkfjHMo0uDdBH4dW4uh7o5mZZx0Dc9KTBTk=;
        b=AwNfjjxS1cUD55/h3hOFycmoypbBI5X42YF3aEolsLoOBplbESjY1f12w174bq7K14
         uzbbtQb+IbyDyQi9SllYzG2/Qw5+QRPMfty5hRTW0/c392B7NG0iMGO3qxnV8UP8qYU/
         xYyQ2K85Q0IS+XVwwqLaqWZzIxHp+zgkrHe5BnexKPewHtWaBDXv3JrSrtCK9s8KxPui
         /ELfDJrRtJGUcsEbeW9q11mKZQ76f94zBLYMMOOFdtYDnui8UAnXmmbrBNQCrzCeG6Gt
         b1E8Zfo6d8LNgebsyC/3C1hjsAqmhcMhGifsS6Z5SmE49JihAMcSbsMHioH03fGWDP7I
         h9xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iUBsdEKJAkfjHMo0uDdBH4dW4uh7o5mZZx0Dc9KTBTk=;
        b=FPvoJhJsc5datV9lNKxiqTL6a3thq6qIJWA05U3DXWxKdkGFKDt/TRxuLa0L4wbRHr
         KKFz/cWJ/Wkpf1/FUXxmX5zcpIEjnfGuLpDCypEFifT7jhokSVev0Nnc7feA3qapvHLB
         0a7rHCJdUk8lNpFRBJo+dolTVlEIDrIF1vSyj9BFlDy0AAL35ASS73IQIt4QUYSzuE4r
         2k6pRJUvYdqAsP06DJTTmwY+MHoiRhP9dDfvOEF8EGfzBj3nX7G4uhJmMpRaIFbDGvCs
         x1OroMsswmcD/JboOK5vKyPrr3acc7ZDF/drSMYehnb5MJnIkzSPNlLwve7e/5xMpcKY
         4yrQ==
X-Gm-Message-State: AOAM531PtcMqX+eIsQ3i7uwHWqbYnb387e55v/66ZA+rN+LR/FWtxF5z
        XuGgWRgsfLc/LA5Qgr+SRpg=
X-Google-Smtp-Source: ABdhPJzcGV71nUSVwGdwK4D4aesXZdcFTXhroW1sMX+bF3SzZMFFR6bPKV/wD7lQn77gMkS415BE7Q==
X-Received: by 2002:adf:9d8e:: with SMTP id p14mr28717754wre.236.1591167290482;
        Tue, 02 Jun 2020 23:54:50 -0700 (PDT)
Received: from ubuntu18_2.cisco.com ([173.38.220.42])
        by smtp.gmail.com with ESMTPSA id r7sm1494357wmb.32.2020.06.02.23.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 23:54:49 -0700 (PDT)
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, ahabdels@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, yuehaibing@huawei.com, eric.dumazet@gmail.com,
        david.lebrun@uclouvain.be
Subject: [net] seg6: fix seg6_validate_srh() to avoid slab-out-of-bounds
Date:   Wed,  3 Jun 2020 06:54:42 +0000
Message-Id: <20200603065442.2745-1-ahabdels@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The seg6_validate_srh() is used to validate SRH for three cases:

case1: SRH of data-plane SRv6 packets to be processed by the Linux kernel.
Case2: SRH of the netlink message received  from user-space (iproute2)
Case3: SRH injected into packets through setsockopt

In case1, the SRH can be encoded in the Reduced way (i.e., first SID is
carried in DA only and not represented as SID in the SRH) and the
seg6_validate_srh() now handles this case correctly.

In case2 and case3, the SRH shouldn’t be encoded in the Reduced way
otherwise we lose the first segment (i.e., the first hop).

The current implementation of the seg6_validate_srh() allow SRH of case2
and case3 to be encoded in the Reduced way. This leads a slab-out-of-bounds
problem.

This patch verifies SRH of case1, case2 and case3. Allowing case1 to be
reduced while preventing SRH of case2 and case3 from being reduced .

Reported-by: syzbot+e8c028b62439eac42073@syzkaller.appspotmail.com
Reported-by: YueHaibing <yuehaibing@huawei.com>
Fixes: 0cb7498f234e ("seg6: fix SRH processing to comply with RFC8754")
Signed-off-by: Ahmed Abdelsalam <ahabdels@gmail.com>
---
 include/net/seg6.h       |  2 +-
 net/core/filter.c        |  2 +-
 net/ipv6/ipv6_sockglue.c |  2 +-
 net/ipv6/seg6.c          | 16 ++++++++++------
 net/ipv6/seg6_iptunnel.c |  2 +-
 net/ipv6/seg6_local.c    |  6 +++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index 640724b35273..9d19c15e8545 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -57,7 +57,7 @@ extern void seg6_iptunnel_exit(void);
 extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
 
-extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len);
+extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
 extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
 			     int proto);
 extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
diff --git a/net/core/filter.c b/net/core/filter.c
index ae82bcb03124..472bdb75849f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5012,7 +5012,7 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	int err;
 	struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)hdr;
 
-	if (!seg6_validate_srh(srh, len))
+	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
 	switch (type) {
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 2c843ff5e3a9..20576e87a5f7 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -493,7 +493,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 				struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)
 							  opt->srcrt;
 
-				if (!seg6_validate_srh(srh, optlen))
+				if (!seg6_validate_srh(srh, optlen, false))
 					goto sticky_done;
 				break;
 			}
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 37b434293bda..cd43e831de3e 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -25,7 +25,7 @@
 #include <net/seg6_hmac.h>
 #endif
 
-bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
+bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 {
 	unsigned int tlv_offset;
 	int max_last_entry;
@@ -37,13 +37,17 @@ bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len)
 	if (((srh->hdrlen + 1) << 3) != len)
 		return false;
 
-	max_last_entry = (srh->hdrlen / 2) - 1;
-
-	if (srh->first_segment > max_last_entry)
+	if (!reduced && srh->segments_left > srh->first_segment) {
 		return false;
+	} else {
+		max_last_entry = (srh->hdrlen / 2) - 1;
 
-	if (srh->segments_left > srh->first_segment + 1)
-		return false;
+		if (srh->first_segment > max_last_entry)
+			return false;
+
+		if (srh->segments_left > srh->first_segment + 1)
+			return false;
+	}
 
 	tlv_offset = sizeof(*srh) + ((srh->first_segment + 1) << 4);
 
diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index c7cbfeae94f5..e0e9f48ab14f 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -426,7 +426,7 @@ static int seg6_build_state(struct net *net, struct nlattr *nla,
 	}
 
 	/* verify that SRH is consistent */
-	if (!seg6_validate_srh(tuninfo->srh, tuninfo_len - sizeof(*tuninfo)))
+	if (!seg6_validate_srh(tuninfo->srh, tuninfo_len - sizeof(*tuninfo), false))
 		return -EINVAL;
 
 	newts = lwtunnel_state_alloc(tuninfo_len + sizeof(*slwt));
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 52493423f329..eba23279912d 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -87,7 +87,7 @@ static struct ipv6_sr_hdr *get_srh(struct sk_buff *skb)
 	 */
 	srh = (struct ipv6_sr_hdr *)(skb->data + srhoff);
 
-	if (!seg6_validate_srh(srh, len))
+	if (!seg6_validate_srh(srh, len, true))
 		return NULL;
 
 	return srh;
@@ -495,7 +495,7 @@ bool seg6_bpf_has_valid_srh(struct sk_buff *skb)
 			return false;
 
 		srh->hdrlen = (u8)(srh_state->hdrlen >> 3);
-		if (!seg6_validate_srh(srh, (srh->hdrlen + 1) << 3))
+		if (!seg6_validate_srh(srh, (srh->hdrlen + 1) << 3, true))
 			return false;
 
 		srh_state->valid = true;
@@ -670,7 +670,7 @@ static int parse_nla_srh(struct nlattr **attrs, struct seg6_local_lwt *slwt)
 	if (len < sizeof(*srh) + sizeof(struct in6_addr))
 		return -EINVAL;
 
-	if (!seg6_validate_srh(srh, len))
+	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
 	slwt->srh = kmemdup(srh, len, GFP_KERNEL);
-- 
2.17.1

