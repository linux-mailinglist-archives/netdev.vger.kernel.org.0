Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F32C6E33BD
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 23:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjDOVGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 17:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDOVGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 17:06:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F5DB0
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 14:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681592720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p5y3qt1ic/0kK0H+TbeY6tD9Jioxkayq+/Q9SoCXkDY=;
        b=X1TN2+ofjf6BKMmb5aR4EdcMJpdPMyahuqDN9ZBsKS9jpj9m7j/xPFTcHgmb9R6CDNTFZT
        +9OSsYgH+IzYGKHGtQiA5H08u9N/d8D7mfgjvqAIWmzpTiRr+uPPHYR4fFnOpURgo8RD+M
        Kv5mHqUHprhnGE3mEdu2D+QSYQzDrvw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-cm6IHhQQO-6vS0XajzW_Xw-1; Sat, 15 Apr 2023 17:05:16 -0400
X-MC-Unique: cm6IHhQQO-6vS0XajzW_Xw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 541C68314E8;
        Sat, 15 Apr 2023 21:05:16 +0000 (UTC)
Received: from fs-i40c-03.fs.lab.eng.bos.redhat.com (fs-i40c-03.fs.lab.eng.bos.redhat.com [10.16.224.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B27D11415139;
        Sat, 15 Apr 2023 21:05:15 +0000 (UTC)
From:   Alexander Aring <aahringo@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alex.aring@gmail.com,
        daniel@iogearbox.net, ymittal@redhat.com, mcascell@redhat.com,
        torvalds@linuxfoundation.org, mcr@sandelman.ca
Subject: [PATCH net] net: rpl: fix rpl header size calculation
Date:   Sat, 15 Apr 2023 17:05:06 -0400
Message-Id: <20230415210506.2283603-1-aahringo@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a missing 8 byte for the header size calculation. The
ipv6_rpl_srh_size() is used to check a skb_pull() on skb->data which
points to skb_transport_header(). Currently we only check on the
calculated addresses fields using CmprI and CmprE fields, see:

https://www.rfc-editor.org/rfc/rfc6554#section-3

there is however a missing 8 byte inside the calculation which stands
for the fields before the addresses field.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
---
 net/ipv6/rpl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index 488aec9e1a74..16e19fec18a4 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -32,7 +32,7 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
 size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
 			 unsigned char cmpre)
 {
-	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+	return 8 + (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
 }
 
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
-- 
2.31.1

