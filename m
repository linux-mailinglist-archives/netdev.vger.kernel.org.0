Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169F74F8078
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343648AbiDGN03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 09:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242980AbiDGN02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 09:26:28 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4930E70852;
        Thu,  7 Apr 2022 06:24:25 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c4so8088063qtx.1;
        Thu, 07 Apr 2022 06:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e9BBEGFkRoWtf1TNB9g9Peh7Pm7yimLQ1/ZYuWqvj4k=;
        b=H7r2oqUBDNUF5WBh4tekAv6rapssaMxLG85MIqgiMYveJbo889WVaMOMwdIT8R2EDK
         RsHM2mD7VyjKL/ubHbFVkQNyViPWZ0wwuSTInVWVkXOs85+dljwhq5ozMsi3cUNgdwpa
         BP/1GkuAGderktJwZ9ANXmzsF/nI8LCEAXC3/zQAOroJn9g3AziXr8m6Ras/eWDwcJ++
         hZKG2LvEXIrKPjBj8UmO7K0WqCnE26PfMvPZmxzlfPTT0XD8+5CjvaNuJANDHZqFEw3j
         FcUkcmFN2myKAexJ8wCRDgHy/nrc14PqwqC0kAJ2eJ8EVh7japyqJWynfdi1xeBONChw
         v2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e9BBEGFkRoWtf1TNB9g9Peh7Pm7yimLQ1/ZYuWqvj4k=;
        b=kC7p2I7PUbdLlRGLqdSpETWGesHva7vsKqY0FGsXtiGMU2JqvH3pEzrvvzBMCnkcz6
         Ikg8DpJEcEMAS1ji+nkvHfHQVQptKnd7TR0wA81KSKdqxZHd9KE6rUCjuxw4v7hbAkMa
         ok4sV8lM1aqtwPeRHnqPo9xRrD4HQ3QQTIp/mt9a11bprPukfKbPD8c5swQSerKrioUM
         jC5kpGLtDGZYsIzvd30L+YLIXokVEZPo6+yYbbG0On8ihnpeOVQ99e7XOnJB+aJGrXjb
         BpFazOb/4nLi5vAQ8eQVG+RPoIPwo7ZcMqZlJm2nW9KH3YosHRPyWEW3PhxC4DcESIKZ
         e5kA==
X-Gm-Message-State: AOAM530b86t5APCk79FObY6TcZmby8Uqo59saWmJRmr193Ml4AnQfP6b
        sVMeSNbWl+UgDZr5D8Ms6f85PO4i+dnVqA==
X-Google-Smtp-Source: ABdhPJw0FNsu9hUpAXB0WdYjlJhtbbWePi+1le8SBKjMj2TRkQx+B0z/7wrcqB/HwugZwfJYgimeOg==
X-Received: by 2002:a05:622a:4089:b0:2eb:b4bd:8fa4 with SMTP id cg9-20020a05622a408900b002ebb4bd8fa4mr11389743qtb.157.1649337864445;
        Thu, 07 Apr 2022 06:24:24 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bk18-20020a05620a1a1200b00680c72b7bf4sm13164195qkb.93.2022.04.07.06.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:24:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, omosnace@redhat.com
Subject: [PATCHv2 net] sctp: use the correct skb for security_sctp_assoc_request
Date:   Thu,  7 Apr 2022 09:24:22 -0400
Message-Id: <71becb489e51284edf0c11fc15246f4ed4cef5b6.1649337862.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yi Chen reported an unexpected sctp connection abort, and it occurred when
COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
is included in chunk->head_skb instead of chunk->skb, it failed to check
IP header version in security_sctp_assoc_request().

According to Ondrej, SELinux only looks at IP header (address and IPsec
options) and XFRM state data, and these are all included in head_skb for
SCTP HW GSO packets. So fix it by using head_skb when calling
security_sctp_assoc_request() in processing COOKIE_ECHO.

v1->v2:
  - As Ondrej noticed, chunk->head_skb should also be used for
    security_sctp_assoc_established() in sctp_sf_do_5_1E_ca().

Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
Reported-by: Yi Chen <yiche@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 7f342bc12735..52edee1322fc 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -781,7 +781,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
-	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
@@ -932,7 +932,7 @@ enum sctp_disposition sctp_sf_do_5_1E_ca(struct net *net,
 
 	/* Set peer label for connection. */
 	if (security_sctp_assoc_established((struct sctp_association *)asoc,
-					    chunk->skb))
+					    chunk->head_skb ?: chunk->skb))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	/* Verify that the chunk length for the COOKIE-ACK is OK.
@@ -2262,7 +2262,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 	}
 
 	/* Update socket peer label if first association. */
-	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+	if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
 		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
-- 
2.31.1

