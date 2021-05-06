Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D018375299
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 12:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbhEFKsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 06:48:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234532AbhEFKsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 06:48:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620298054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=s1JQNEEoI2cDh428+nimKECiAHtwefPlNt7lLZ93Myw=;
        b=Px3s1xkQL3W1P8B3atWpKWB27tpuP/ejlk2uBH0I9fgrMf0cHNd3QKd1wxQLghu7BgbMP0
        L83ljtDN+RRa++32y5dmkfb6fDPYb3Wv22UBm/PCZKEQkvcT9zKxkq0gPOJoblI+QFfe/u
        wn5qXOHVT5qZ3rqh45LRvx/fTgDiWnA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-i--LpvtDNQOeQRb1VMIbCQ-1; Thu, 06 May 2021 06:47:33 -0400
X-MC-Unique: i--LpvtDNQOeQRb1VMIbCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 201C018957E4;
        Thu,  6 May 2021 10:47:32 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-144.ams2.redhat.com [10.36.115.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 469125D9E3;
        Thu,  6 May 2021 10:47:31 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2-next] tc: htb: improve burst error messages
Date:   Thu,  6 May 2021 12:42:06 +0200
Message-Id: <2cf5c0b12a53f37fee1f7af9ccc3761cbda6c030.1620297647.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a wrong value is provided for "burst" or "cburst" parameters, the
resulting error message is unclear and can be misleading:

$ tc class add dev dummy0 parent 1: classid 1:1 htb rate 100KBps burst errtrigger
Illegal "buffer"

The message claims an illegal "buffer" is provided, but neither the
inline help nor the man page list "buffer" among the htb parameters, and
the only way to know that "burst", "maxburst" and "buffer" are synonyms
is to look into tc/q_htb.c.

This commit tries to improve this simply changing the error string to
the parameter name provided in the user-given command, clearly pointing
out where the wrong value is.

$ tc class add dev dummy0 parent 1: classid 1:1 htb rate 100KBps burst errtrigger
Illegal "burst"

$ tc class add dev dummy0 parent 1: classid 1:1 htb rate 100Kbps maxburst errtrigger
Illegal "maxburst"

Reported-by: Sebastian Mitterle <smitterl@redhat.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/q_htb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tc/q_htb.c b/tc/q_htb.c
index 42566355..b5f95f67 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -125,6 +125,7 @@ static int htb_parse_class_opt(struct qdisc_util *qu, int argc, char **argv, str
 	unsigned int linklayer  = LINKLAYER_ETHERNET; /* Assume ethernet */
 	struct rtattr *tail;
 	__u64 ceil64 = 0, rate64 = 0;
+	char *param;
 
 	while (argc > 0) {
 		if (matches(*argv, "prio") == 0) {
@@ -160,17 +161,19 @@ static int htb_parse_class_opt(struct qdisc_util *qu, int argc, char **argv, str
 		} else if (matches(*argv, "burst") == 0 ||
 			   strcmp(*argv, "buffer") == 0 ||
 			   strcmp(*argv, "maxburst") == 0) {
+			param = *argv;
 			NEXT_ARG();
 			if (get_size_and_cell(&buffer, &cell_log, *argv) < 0) {
-				explain1("buffer");
+				explain1(param);
 				return -1;
 			}
 		} else if (matches(*argv, "cburst") == 0 ||
 			   strcmp(*argv, "cbuffer") == 0 ||
 			   strcmp(*argv, "cmaxburst") == 0) {
+			param = *argv;
 			NEXT_ARG();
 			if (get_size_and_cell(&cbuffer, &ccell_log, *argv) < 0) {
-				explain1("cbuffer");
+				explain1(param);
 				return -1;
 			}
 		} else if (strcmp(*argv, "ceil") == 0) {
-- 
2.30.2

