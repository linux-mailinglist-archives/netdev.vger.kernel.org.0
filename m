Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D232B4D44F6
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 11:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236789AbiCJKuP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Mar 2022 05:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiCJKuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 05:50:15 -0500
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00C19205E4
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 02:49:13 -0800 (PST)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-pjo9osJ8MzG1buYxyCRHyg-1; Thu, 10 Mar 2022 05:49:09 -0500
X-MC-Unique: pjo9osJ8MzG1buYxyCRHyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19932800423;
        Thu, 10 Mar 2022 10:49:08 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.193.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DEE922E19;
        Thu, 10 Mar 2022 10:49:04 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jordy Zomer <jordy@pwning.systems>, Xiumei Mu <xmu@redhat.com>
Subject: [PATCH ipsec] esp6: fix check on ipv6_skip_exthdr's return value
Date:   Thu, 10 Mar 2022 11:49:00 +0100
Message-Id: <4215f33e156b9bf7259d3efb5c7b888f45c7f9b8.1646748826.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=sd@queasysnail.net
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
introduced an incorrect check, which leads to all ESP packets over
either TCPv6 or UDPv6 encapsulation being dropped. In this particular
case, offset is negative, since skb->data points to the ESP header in
the following chain of headers, while skb->network_header points to
the IPv6 header:

    IPv6 | ext | ... | ext | UDP | ESP | ...

That doesn't seem to be a problem, especially considering that if we
reach esp6_input_done2, we're guaranteed to have a full set of headers
available (otherwise the packet would have been dropped earlier in the
stack). However, it means that the return value will (intentionally)
be negative. We can make the test more specific, as the expected
return value of ipv6_skip_exthdr will be the (negated) size of either
a UDP header, or a TCP header with possible options.

In the future, we should probably either make ipv6_skip_exthdr
explicitly accept negative offsets (and adjust its return value for
error cases), or make ipv6_skip_exthdr only take non-negative
offsets (and audit all callers).

Fixes: 5f9c55c8066b ("ipv6: check return value of ipv6_skip_exthdr")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/ipv6/esp6.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b0ffbcd5432d..55d604c9b3b3 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -812,8 +812,7 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 		struct tcphdr *th;
 
 		offset = ipv6_skip_exthdr(skb, offset, &nexthdr, &frag_off);
-
-		if (offset < 0) {
+		if (offset == -1) {
 			err = -EINVAL;
 			goto out;
 		}
-- 
2.35.1

