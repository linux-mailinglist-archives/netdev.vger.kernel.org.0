Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 624ED3707F4
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhEAQuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:50:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230195AbhEAQuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 May 2021 12:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619887763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jw5wwGEd83lT9BKsEvFCA/28f/uk1ukSk6MUFzJ/Sjo=;
        b=G/sOcmUo2GtX3X3z3g3uqEdfJYc3HuM5qDduZfIGsTJLGaU5VuX9Zyi9/wuBaWFriZT96b
        42am4NoeBj+JdRgOXR8J/7/LWzqe3/SNksyzMTNAh2g0asPsypsufJrOizGbtoiChIkdUF
        tjvJyCaVD+Fp2KPNV7ZI3G1lIsgsR30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-g5FEuM2TMUK9p0MJmGPGNQ-1; Sat, 01 May 2021 12:49:21 -0400
X-MC-Unique: g5FEuM2TMUK9p0MJmGPGNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9F8C8186E1;
        Sat,  1 May 2021 16:49:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-28.ams2.redhat.com [10.36.112.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E65E92B1CD;
        Sat,  1 May 2021 16:49:19 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
Subject: [PATCH iproute2] tc: q_ets: drop dead code from argument parsing
Date:   Sat,  1 May 2021 18:44:35 +0200
Message-Id: <a98f8ff492c5be9f06a6ad6522371230c5721ee7.1619887263.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checking for nbands to be at least 1 at this point is useless. Indeed:
- ets requires "bands", "quanta" or "strict" to be specified
- if "bands" is specified, nbands cannot be negative, see parse_nbands()
- if "strict" is specified, nstrict cannot be negative, see
  parse_nbands()
- if "quantum" is specified, nquanta cannot be negative, see
  parse_quantum()
- if "bands" is not specified, nbands is set to nstrict+nquanta
- the previous if statement takes care of the case when none of them are
  specified and nbands is 0, terminating execution.

Thus nbands cannot be < 1 at this point and this code cannot be executed.

Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 tc/q_ets.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tc/q_ets.c b/tc/q_ets.c
index e7903d50..7380bb2f 100644
--- a/tc/q_ets.c
+++ b/tc/q_ets.c
@@ -147,11 +147,6 @@ parse_priomap:
 		explain();
 		return -1;
 	}
-	if (nbands < 1) {
-		fprintf(stderr, "The number of \"bands\" must be >= 1\n");
-		explain();
-		return -1;
-	}
 	if (nstrict + nquanta > nbands) {
 		fprintf(stderr, "Not enough total bands to cover all the strict bands and quanta\n");
 		explain();
-- 
2.30.2

