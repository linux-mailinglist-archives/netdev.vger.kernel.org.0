Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC0A233E7A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 06:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGaEuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 00:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgGaEuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 00:50:21 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE37C061574;
        Thu, 30 Jul 2020 21:50:21 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id s15so9162953qvv.7;
        Thu, 30 Jul 2020 21:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6BmyvzPtmL92uqePz7MKoJvHsqbaPFKy91FuGn4J6aM=;
        b=i6l58DtETKYbDvaDzHN27Ly/UzsYlzhN5HqPyYRcuuC538WNatf1azS+mQWlENzmOr
         R4gZK7IHf0+5a3RRbN4Wtbh9qZE3XLCKXnPDSORWmPC0vrcGXd9is3gDtvIx4YKQvXl7
         zcEnfibUoAmj8hITpXbSwA4b/4p4yYnR6gAlFuFXbYqcYtEtAe/vcoAdADVN065tE7qw
         WXAcNf1L2s/lshu2sxBwrJPi/5vmb1qWKfKCCiwy+SGFIyzqXsqGGggbJjp+v3yVaN/S
         DG4seX2tBXQq2T9HOqI51HDoLJozcYTOv7lGE2BBY7BFO9tr3f3KJ9npT0hWjKubS1nk
         +tyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6BmyvzPtmL92uqePz7MKoJvHsqbaPFKy91FuGn4J6aM=;
        b=kkJpLUPRCx/izdeg2tShOV4adqocXReDJFiCj+DAmJdewZo0mbsWzsKGY/8ZcNRsGJ
         itFCLGntIn49H4N/nKbkwU6EVT/ntUJQAexYqSV2Ae85yjwcxSX/6ySzviqYvdqRRmjc
         yu5hs0SSEdTOs01laz4tU5mTdbILGLlbqCoJ+73uRTs30jJ6gMBkpU6GMzvcYRA25hlO
         UyQBuVZjoJNORRQt/c1Lku2d8CeqfTEG4UJFizsBGol2O+mrWt7y+AanBoTXUTUp/yZ0
         /I8CZlC88q7eqy0qEfQ8gU997IO5rFCL5duGeCFRc+YQtYThihnKopACZYAqIdVOc/e2
         Hc0A==
X-Gm-Message-State: AOAM533QYZdg5gIXDfvyhKKJu7Uc0A7tthS+WhFRfATdaGbpyZ4yZPI6
        tAHBeZnwYX3OHz8GYTXX5A==
X-Google-Smtp-Source: ABdhPJxIG7qiv+i9D/06CElrwmKpCb43C7xccST5RRJeVQmM4efRjwaM+qxfhjnSVDYpdRxh60e3KA==
X-Received: by 2002:a0c:83c4:: with SMTP id k62mr2410066qva.19.1596171020491;
        Thu, 30 Jul 2020 21:50:20 -0700 (PDT)
Received: from localhost.localdomain (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id c7sm7801798qta.95.2020.07.30.21.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 21:50:20 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Pravin B Shelar <pshelar@ovn.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: [Linux-kernel-mentees] [PATCH net] openvswitch: Prevent kernel-infoleak in ovs_ct_put_key()
Date:   Fri, 31 Jul 2020 00:48:38 -0400
Message-Id: <20200731044838.213975-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ovs_ct_put_key() is potentially copying uninitialized kernel stack memory
into socket buffers, since the compiler may leave a 3-byte hole at the end
of `struct ovs_key_ct_tuple_ipv4` and `struct ovs_key_ct_tuple_ipv6`. Fix
it by initializing `orig` with memset().

Cc: stable@vger.kernel.org
Fixes: 9dd7f8907c37 ("openvswitch: Add original direction conntrack tuple to sw_flow_key.")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
Reference: https://lwn.net/Articles/417989/

$ pahole -C "ovs_key_ct_tuple_ipv4" net/openvswitch/conntrack.o
struct ovs_key_ct_tuple_ipv4 {
	__be32                     ipv4_src;             /*     0     4 */
	__be32                     ipv4_dst;             /*     4     4 */
	__be16                     src_port;             /*     8     2 */
	__be16                     dst_port;             /*    10     2 */
	__u8                       ipv4_proto;           /*    12     1 */

	/* size: 16, cachelines: 1, members: 5 */
	/* padding: 3 */
	/* last cacheline: 16 bytes */
};
$ pahole -C "ovs_key_ct_tuple_ipv6" net/openvswitch/conntrack.o
struct ovs_key_ct_tuple_ipv6 {
	__be32                     ipv6_src[4];          /*     0    16 */
	__be32                     ipv6_dst[4];          /*    16    16 */
	__be16                     src_port;             /*    32     2 */
	__be16                     dst_port;             /*    34     2 */
	__u8                       ipv6_proto;           /*    36     1 */

	/* size: 40, cachelines: 1, members: 5 */
	/* padding: 3 */
	/* last cacheline: 40 bytes */
};

 net/openvswitch/conntrack.c | 38 +++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4340f25fe390..98d393e70de3 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -276,10 +276,6 @@ void ovs_ct_fill_key(const struct sk_buff *skb, struct sw_flow_key *key)
 	ovs_ct_update_key(skb, NULL, key, false, false);
 }
 
-#define IN6_ADDR_INITIALIZER(ADDR) \
-	{ (ADDR).s6_addr32[0], (ADDR).s6_addr32[1], \
-	  (ADDR).s6_addr32[2], (ADDR).s6_addr32[3] }
-
 int ovs_ct_put_key(const struct sw_flow_key *swkey,
 		   const struct sw_flow_key *output, struct sk_buff *skb)
 {
@@ -301,24 +297,30 @@ int ovs_ct_put_key(const struct sw_flow_key *swkey,
 
 	if (swkey->ct_orig_proto) {
 		if (swkey->eth.type == htons(ETH_P_IP)) {
-			struct ovs_key_ct_tuple_ipv4 orig = {
-				output->ipv4.ct_orig.src,
-				output->ipv4.ct_orig.dst,
-				output->ct.orig_tp.src,
-				output->ct.orig_tp.dst,
-				output->ct_orig_proto,
-			};
+			struct ovs_key_ct_tuple_ipv4 orig;
+
+			memset(&orig, 0, sizeof(orig));
+			orig.ipv4_src = output->ipv4.ct_orig.src;
+			orig.ipv4_dst = output->ipv4.ct_orig.dst;
+			orig.src_port = output->ct.orig_tp.src;
+			orig.dst_port = output->ct.orig_tp.dst;
+			orig.ipv4_proto = output->ct_orig_proto;
+
 			if (nla_put(skb, OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,
 				    sizeof(orig), &orig))
 				return -EMSGSIZE;
 		} else if (swkey->eth.type == htons(ETH_P_IPV6)) {
-			struct ovs_key_ct_tuple_ipv6 orig = {
-				IN6_ADDR_INITIALIZER(output->ipv6.ct_orig.src),
-				IN6_ADDR_INITIALIZER(output->ipv6.ct_orig.dst),
-				output->ct.orig_tp.src,
-				output->ct.orig_tp.dst,
-				output->ct_orig_proto,
-			};
+			struct ovs_key_ct_tuple_ipv6 orig;
+
+			memset(&orig, 0, sizeof(orig));
+			memcpy(orig.ipv6_src, output->ipv6.ct_orig.src.s6_addr32,
+			       sizeof(orig.ipv6_src));
+			memcpy(orig.ipv6_dst, output->ipv6.ct_orig.dst.s6_addr32,
+			       sizeof(orig.ipv6_dst));
+			orig.src_port = output->ct.orig_tp.src;
+			orig.dst_port = output->ct.orig_tp.dst;
+			orig.ipv6_proto = output->ct_orig_proto;
+
 			if (nla_put(skb, OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,
 				    sizeof(orig), &orig))
 				return -EMSGSIZE;
-- 
2.25.1

