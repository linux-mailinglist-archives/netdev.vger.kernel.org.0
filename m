Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214FB13A209
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgANH0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:26:20 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36136 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729251AbgANH0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:26:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so12462301wma.1;
        Mon, 13 Jan 2020 23:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiCYJM3p9g7mHv0l5QKjZySrGo0xYWEW7P1c+G0gG1c=;
        b=urYHp5WgdiyJ2FzUrZ/THbwnHqQb0dyutWCLTmLe4JGZPuzC1dX24dm19mpDIuE5NS
         rJxRUh5a+BrMBk7NcuOAymQmWxifFDDdaMy7XZIQjnZuevBhszaFWU1YyCzXu8AwsUL9
         tkpn8hChejNFAHUzqsomQ/JGTZFP7LTVPiM6b6s+lsGzKxSXrqOQIQaxJDMtXKz9ve3v
         rYrpBzunWTWIsb67/8E7E88YQLEeMAGph6oKpdOx+kA06RgmNsaqgcixJCf4hKG7AxMW
         TdEabt/0QSxM5ztEwQ97b33Po0K3hVCoC3/SpYg/zRp21Z8QcWMT08TB+x5O1C59L/g0
         1BMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiCYJM3p9g7mHv0l5QKjZySrGo0xYWEW7P1c+G0gG1c=;
        b=XLyfq1UWIbu2lYqpwH/gX93xx1ArHm6yjaOWyQ8Xqr0pPNgn49Uyw0FmsQrvWcnA8M
         tlmIVDIWpMiHySCvluHE88CMatqqgm3y3N4XXlDa20pys078d84q4lBwr47fwNHZLIDG
         Wx1mu5V7wrW0f9sEzzcrvU0jZZjY9V822BcG1Q78N9nBE1IVm3Zd4Ow5a9i9HIbcGhcy
         z4Xw+/HBpmzH9mT1FxSXvhr/FBn9WyHdIYffzZvkJr1vaQaYHOhrwEzIsvT7zZzc0Oku
         0wQaQ5udSBG4oplOxYFMYLErTecP8VTM3O2atvF1btgSXrp5Gqao39jnNTo/8tlWEzr2
         Gliw==
X-Gm-Message-State: APjAAAVbNxWs4mC+Sprnr6+sDlN044124OJzKjirifkeLwAUr3JZ3DBB
        rETCBrPwKQIa/titXx35v2gDFXYAVzk=
X-Google-Smtp-Source: APXvYqzWOIZiK56I9jxXqr/hFmvMYuAe8Tix/5WvctTLmTQUntV+dzrWxzBlZTItUj0mvuKBXlKLGw==
X-Received: by 2002:a7b:c1c7:: with SMTP id a7mr23865170wmj.168.1578986776918;
        Mon, 13 Jan 2020 23:26:16 -0800 (PST)
Received: from localhost.localdomain (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id n10sm18247510wrt.14.2020.01.13.23.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 23:26:15 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Cc:     Eyal Birger <eyal.birger@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: [NET] netfilter: nat: fix ICMP header corruption on ICMP errors
Date:   Tue, 14 Jan 2020 09:25:48 +0200
Message-Id: <20200114072548.23426-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
manipulation function for the outer packet on ICMP errors.

However, icmp_manip_pkt() assumes the packet is an ICMP echo packet
and therefore that the ICMP header's 'un' field is an ICMP echo id.

This is not correct for ICMP error packets, and leads to bogus bytes
being written the ICMP header, which can be wrongfully regarded as
'length' bytes by RFC 4884 compliant receivers.

Fix by assigning the 'id' field only for ICMP echo packets similar
to the treatment in ICMPv6.

Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Fixes: 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/netfilter/nf_nat_proto.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 0a59c14b5177..92ef91c120f4 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -233,9 +233,12 @@ icmp_manip_pkt(struct sk_buff *skb,
 		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
-	inet_proto_csum_replace2(&hdr->checksum, skb,
-				 hdr->un.echo.id, tuple->src.u.icmp.id, false);
-	hdr->un.echo.id = tuple->src.u.icmp.id;
+	if (hdr->type == ICMP_ECHO || hdr->type == ICMP_ECHOREPLY) {
+		inet_proto_csum_replace2(&hdr->checksum, skb,
+					 hdr->un.echo.id, tuple->src.u.icmp.id,
+					 false);
+		hdr->un.echo.id = tuple->src.u.icmp.id;
+	}
 	return true;
 }
 
-- 
2.20.1

