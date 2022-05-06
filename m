Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8A51DFF8
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387347AbiEFUPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiEFUPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:15:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFA094C41A
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651867916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JSTpH1y2N1V0+fhXfufhf9T3dLqxaEiBFM7l2COqazg=;
        b=C4QvPD2vTzrTIxe2bYm3fvyTv+k9+Qid0zRLA4Gag1UaRtJhpiVOmIBPiu1KSYgs/W/O27
        EvHcn0UzLQcEMu6HpHy7cRhNgw4UCq4HSIhT5BCICwziZDQPMJFWzxK51tH9KEV+B1FWUL
        D6EP6x8drCXMjaCDfJEUhpf4kd52Zk8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-YXk_XTb4PX6H2hfmn7_4xw-1; Fri, 06 May 2022 16:11:52 -0400
X-MC-Unique: YXk_XTb4PX6H2hfmn7_4xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5858485A5BC;
        Fri,  6 May 2022 20:11:52 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.195.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B51C020296A9;
        Fri,  6 May 2022 20:11:50 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] tc: em_u32: fix offset parsing
Date:   Fri,  6 May 2022 22:11:46 +0200
Message-Id: <5ceaf48253d515b8c8e0902d939471b3a95f5407.1651867575.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc u32 ematch offset parsing might fail even if nexthdr offset is
aligned to 4. The issue can be reproduced with the following script:

tc qdisc del dev dummy0 root
tc qdisc add dev dummy0 root handle 1: htb r2q 1 default 1
tc class add dev dummy0 parent 1:1 classid 1:108 htb quantum 1000000 \
	rate 1.00mbit ceil 10.00mbit burst 6k

while true; do
if ! tc filter add dev dummy0 protocol all parent 1: prio 1 basic match \
	"meta(vlan mask 0xfff eq 1)" and "u32(u32 0x20011002 0xffffffff \
	at nexthdr+8)" flowid 1:108; then
		exit 0
fi
done

which we expect to produce an endless loop.
With the current code, instead, this ends with:

u32: invalid offset alignment, must be aligned to 4.
... meta(vlan mask 0xfff eq 1) and >>u32(u32 0x20011002 0xffffffff at nexthdr+8)<< ...
... u32(u32 0x20011002 0xffffffff at >>nexthdr+8<<)...
Usage: u32(ALIGN VALUE MASK at [ nexthdr+ ] OFFSET)
where: ALIGN  := { u8 | u16 | u32 }

Example: u32(u16 0x1122 0xffff at nexthdr+4)
Illegal "ematch"

This is caused by memcpy copying into buf an unterminated string.

Fix it using strncpy instead of memcpy.

Fixes: commit 311b41454dc4 ("Add new extended match files.")
Reported-by: Alfred Yang <alf.redyoung@gmail.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/em_u32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/em_u32.c b/tc/em_u32.c
index bc284af4..ea2bf882 100644
--- a/tc/em_u32.c
+++ b/tc/em_u32.c
@@ -84,7 +84,7 @@ static int u32_parse_eopt(struct nlmsghdr *n, struct tcf_ematch_hdr *hdr,
 		char buf[a->len - nh_len + 1];
 
 		offmask = -1;
-		memcpy(buf, a->data + nh_len, a->len - nh_len);
+		strncpy(buf, a->data + nh_len, a->len - nh_len + 1);
 		offset = strtoul(buf, NULL, 0);
 	} else if (!bstrcmp(a, "nexthdr+")) {
 		a = bstr_next(a);
-- 
2.35.1

