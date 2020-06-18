Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66B501FEF72
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 12:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgFRKNt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 06:13:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46100 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726573AbgFRKNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 06:13:48 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-o38nMvC5PIGpR8Fd0CQVyg-1; Thu, 18 Jun 2020 06:13:45 -0400
X-MC-Unique: o38nMvC5PIGpR8Fd0CQVyg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D519D10059AF;
        Thu, 18 Jun 2020 10:13:44 +0000 (UTC)
Received: from hog.localdomain, (unknown [10.40.193.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C03161C4;
        Thu, 18 Jun 2020 10:13:43 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: [PATCH net] geneve: allow changing DF behavior after creation
Date:   Thu, 18 Jun 2020 12:13:22 +0200
Message-Id: <3b72fc01841507f8439a90f618ef6f6240b9463f.1592473442.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, trying to change the DF parameter of a geneve device does
nothing:

    # ip -d link show geneve1
    14: geneve1: <snip>
        link/ether <snip>
        geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
    # ip link set geneve1 type geneve id 1 df unset
    # ip -d link show geneve1
    14: geneve1: <snip>
        link/ether <snip>
        geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>

We just need to update the value in geneve_changelink.

Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/geneve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 75266580b586..4661ef865807 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1649,6 +1649,7 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
 	geneve->collect_md = metadata;
 	geneve->use_udp6_rx_checksums = use_udp6_rx_checksums;
 	geneve->ttl_inherit = ttl_inherit;
+	geneve->df = df;
 	geneve_unquiesce(geneve, gs4, gs6);
 
 	return 0;
-- 
2.27.0

