Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C0120AE95
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 10:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgFZIzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 04:55:03 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:48357 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgFZIzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 04:55:03 -0400
Received: from ubuntu18.lan (unknown [109.129.49.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 73B56200F80F;
        Fri, 26 Jun 2020 10:54:48 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 73B56200F80F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593161688;
        bh=MOE16JEZzrfwsMHKy/BogkJ2seN7JervxoM0Q/GYV0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIPehI3OJmO9Y9WD2lLcPLWs2EZC5WrYX/zVoIaNAd2X3P7nG9PMFAZLGC8shzkpv
         F5ojTYV9AwJfYrHVAnUkuqoBAbRFtp7alztgZhc00oc10hzV5hUPVcMDUPE1CECRtY
         mcYAfgEKUjF7GQ/trhcM6xjI0U8rGcMO//abDJBT0dFbz8oVdtudVW6c9FVrUFwPvk
         h1axfh1vWkw16K8xOsK65eY/ePD2Z0hWv84oUM4PNdv2KMExWzC5budNdqBBjPrRgN
         G4f4/mx2ylZh6qdtynEJsF7t03QtvzvlnJUH9MboawmlyHgBd5MOgmWLGy0DFGGNfn
         MzUPwLoqYN4Rw==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     dan.carpenter@oracle.com
Cc:     kbuild@lists.01.org, justin.iurman@uliege.be,
        netdev@vger.kernel.org, lkp@intel.com, kbuild-all@lists.01.org,
        davem@davemloft.net
Subject: [PATCH net-next] Fix unchecked dereference
Date:   Fri, 26 Jun 2020 10:54:35 +0200
Message-Id: <20200626085435.6627-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625105237.GC2549@kadam>
References: <20200625105237.GC2549@kadam>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If rhashtable_remove_fast returns an error, a rollback is applied. In
that case, an unchecked dereference has been fixed.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 net/ipv6/ioam6.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index e414e915bf1e..f1347940245e 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -161,7 +161,8 @@ static int ioam6_genl_delns(struct sk_buff *skb, struct genl_info *info)
 	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
 				     rht_ns_params);
 	if (err) {
-		ns->schema->ns = ns;
+		if (ns->schema)
+			ns->schema->ns = ns;
 		goto out_unlock;
 	}
 
@@ -355,7 +356,8 @@ static int ioam6_genl_delsc(struct sk_buff *skb, struct genl_info *info)
 	err = rhashtable_remove_fast(&nsdata->schemas, &sc->head,
 				     rht_sc_params);
 	if (err) {
-		sc->ns->schema = sc;
+		if (sc->ns)
+			sc->ns->schema = sc;
 		goto out_unlock;
 	}
 
-- 
2.17.1

