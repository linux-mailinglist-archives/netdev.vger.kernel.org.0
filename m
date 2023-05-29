Return-Path: <netdev+bounces-6154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED01B714EB5
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FE4C1C209A4
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCB5947D;
	Mon, 29 May 2023 16:59:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F56720EA
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:59:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D070CB2
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 09:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685379569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/hczKNvEs8rYx2QWH9PqcaAJErqIPIGgeFhyFfVIZ5Y=;
	b=JKgdrP3aeyGTYfMQ4CoLTL2xqpEF2VwhtvBsdRzRnDLAXYMDsOFJIk/k9iUKfuxRItFche
	e4qcbXKExNOrymt8QUu31HxGkRI31eiZnvDPuGaQlvhPpSsEpefJvyHjEYE4g1Hh1uXrci
	XbBo21ynvAAaRBCsxNRFYJklnSIRiII=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-e1yIy2kQPhe6Q6cHr7TnHg-1; Mon, 29 May 2023 12:59:26 -0400
X-MC-Unique: e1yIy2kQPhe6Q6cHr7TnHg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F09F3825BA2;
	Mon, 29 May 2023 16:59:26 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.39.193.238])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF092492B00;
	Mon, 29 May 2023 16:59:24 +0000 (UTC)
From: Andrea Claudi <aclaudi@redhat.com>
To: netdev@vger.kernel.org
Cc: stephen@networkplumber.org,
	dsahern@gmail.com,
	me@pmachata.org
Subject: [PATCH iproute2] ipstats: fix message reporting error
Date: Mon, 29 May 2023 18:59:15 +0200
Message-Id: <e8875ce96124d1f30acf6a237d0a67f2194d13a6.1685379264.git.aclaudi@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

strerror() accepts any integer as arguments, but returns meaningful
error descriptions only for positive integers.

ipstats code uses strerror on a code path where either err is 0 or
-ENOMEM, thus resulting in a useless error message.

Fix this using errno and moving the error printing closer to the only
function populating it in this code path.

Fixes: df0b2c6d0098 ("ipstats: Add a shell of "show" command")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 ip/ipstats.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/ip/ipstats.c b/ip/ipstats.c
index dadded14..3f94ff1e 100644
--- a/ip/ipstats.c
+++ b/ip/ipstats.c
@@ -88,8 +88,11 @@ ipstats_stat_show_attrs_alloc_tb(struct ipstats_stat_show_attrs *attrs,
 		return 0;
 
 	attrs->tbs[group] = calloc(ifla_max + 1, sizeof(*attrs->tbs[group]));
-	if (attrs->tbs[group] == NULL)
-		return -ENOMEM;
+	if (attrs->tbs[group] == NULL) {
+		fprintf(stderr, "Error parsing netlink answer: %s\n",
+			strerror(errno));
+		return -errno;
+	}
 
 	if (group == 0)
 		err = parse_rtattr(attrs->tbs[group], ifla_max,
@@ -755,11 +758,8 @@ ipstats_process_ifsm(struct nlmsghdr *answer,
 	}
 
 	err = ipstats_stat_show_attrs_alloc_tb(&show_attrs, 0);
-	if (err != 0) {
-		fprintf(stderr, "Error parsing netlink answer: %s\n",
-			strerror(err));
+	if (err)
 		return err;
-	}
 
 	dev = ll_index_to_name(show_attrs.ifsm->ifindex);
 
-- 
2.40.1


