Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A3A618653
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiKCRka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKCRk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:40:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882CF271D
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 10:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667497170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/yEI6YfOqS9FanTmn8SQM26ULDGBj9/hwHdmdeoiHRs=;
        b=Hua/W4SbFBXpMxluS8Md6XnsrP7dHf14eXoFSwJzojUigjX19kKnEy21SpsHJPBRSfdIej
        +ritH+UnBC4lG35/8LY/gMuR23HcRAk2c6sAyQH/2OegSUgL+yvfwc91uLdnh8whnM/1Wk
        PqpMQ9JNTd8KWkZGdljU3MCy6Ro0QUA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-nF8Tshi8PFOO0lNOrJ5B-g-1; Thu, 03 Nov 2022 13:39:29 -0400
X-MC-Unique: nF8Tshi8PFOO0lNOrJ5B-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23D37862FDF;
        Thu,  3 Nov 2022 17:39:29 +0000 (UTC)
Received: from tc2.station (unknown [10.39.192.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 731261415123;
        Thu,  3 Nov 2022 17:39:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] json: do not escape single quotes
Date:   Thu,  3 Nov 2022 18:39:25 +0100
Message-Id: <068673c301bfc5c5d48e06301a2086285a199731.1667497007.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ECMA-404 standard does not include single quote character among the json
escape sequences. This means single quotes does not need to be escaped.

Indeed the single quote escape produces an invalid json output:

$ ip link add "john's" type dummy
$ ip link show "john's"
9: john's: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether c6:8e:53:f6:a3:4b brd ff:ff:ff:ff:ff:ff
$ ip -j link | jq .
parse error: Invalid escape at line 1, column 765

This can be fixed removing the single quote escape in jsonw_puts.
With this patch in place:

$ ip -j link | jq .[].ifname
"lo"
"john's"

Fixes: fcc16c2287bf ("provide common json output formatter")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/json_writer.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/lib/json_writer.c b/lib/json_writer.c
index 88c5eb88..2f3936c2 100644
--- a/lib/json_writer.c
+++ b/lib/json_writer.c
@@ -80,9 +80,6 @@ static void jsonw_puts(json_writer_t *self, const char *str)
 		case '"':
 			fputs("\\\"", self->out);
 			break;
-		case '\'':
-			fputs("\\\'", self->out);
-			break;
 		default:
 			putc(*str, self->out);
 		}
-- 
2.38.1

