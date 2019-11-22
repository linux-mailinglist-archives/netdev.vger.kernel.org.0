Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C35107A75
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKVWSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:18:11 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:39350 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVWSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 17:18:10 -0500
Received: by mail-il1-f194.google.com with SMTP id a7so8424666ild.6;
        Fri, 22 Nov 2019 14:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OcMwtQEtA1kBJVjI97wDUd/HBiETecLR0KIP2QKCP7A=;
        b=p9b6N/JqsFMqVAv2bqrpHxMY4MFM8rQcF/vNqlPkeeuOkfYUvUKeFexbEgsvyMk+UR
         gfGnNgftG620wXUYLsn3kj6rQWK6pC8ouNXdQxz5XzQZhw6tkbBiU9y3U4S4Nlz5WuB1
         JjH9cRhD7DnvylG4L5CR+HJ4R4NdKsZADP8Y2ty8LsPZk4f3eKJ4zmENkV3FoMhVVty6
         tlMZkV+k2H455vOFR05NNDuu9kg7LzvPsqk2zAjzb6/83MkRW6QNSRP7tc2t90/ENNok
         uHiQR1c14Drr5/Ar0BKDTDHz1xXa2MbcoIavib5DVKEVEq2p/DCWkgXab31ES0VLwXBR
         r/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OcMwtQEtA1kBJVjI97wDUd/HBiETecLR0KIP2QKCP7A=;
        b=mWFKgJFqLAYgTmadIsPGYaiDFb9LhVa2oQ3WWfdwYlNswU9qaFwYhaorPiiQVZCpz0
         evxsyvk1cCgwjODYKvt4EAMKpDD3e8s/l93YPAf6vdnMYSyAH8+x11IVPVDSfiTqJyBW
         GlD9VXnLh26epuNY7quvSFJyTbI9tJZkggjT3X4i0Gf+nz6JTFl7W8mxeF+IjTJeq6cL
         atLEktro8OWfJCMc1SoDIlzuEzcXT0+X4tRh0Jaq4QIkfsyvQpfLTP4K8jTkjlZ38X7X
         y5onaYFYSyACm0ah8zft4aI8T5rIElpz8MACENPX4Wy7p7qoLLI80sx8u+xOKZyCVl+k
         WD+g==
X-Gm-Message-State: APjAAAVYscyvRSutwYtFfbJa8PKFqaYCMX6dAFDxi5kOLooK/SRQ9UjW
        khCEkR7AXvi5si2XFhI8tlI=
X-Google-Smtp-Source: APXvYqwiXN1tlkkC6bY7gBRG1YbHPHmBp+O662RAbnjqt7qAkMI5QriegNMQU/s44MG32bJuBC1Iuw==
X-Received: by 2002:a92:6802:: with SMTP id d2mr5133576ilc.173.1574461090007;
        Fri, 22 Nov 2019 14:18:10 -0800 (PST)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id o184sm3323935ila.45.2019.11.22.14.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 14:18:09 -0800 (PST)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] sctp: Fix memory leak in sctp_sf_do_5_2_4_dupcook
Date:   Fri, 22 Nov 2019 16:17:56 -0600
Message-Id: <20191122221759.32271-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of sctp_sf_do_5_2_4_dupcook() the allocated
new_asoc is leaked if security_sctp_assoc_request() fails. Release it
via sctp_association_free().

Fixes: 2277c7cd75e3 ("sctp: Add LSM hooks")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/sctp/sm_statefuns.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 0c21c52fc408..4ab8208a2dd4 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2160,8 +2160,10 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
 
 	/* Update socket peer label if first association. */
 	if (security_sctp_assoc_request((struct sctp_endpoint *)ep,
-					chunk->skb))
+					chunk->skb)) {
+		sctp_association_free(new_asoc);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
 
 	/* Set temp so that it won't be added into hashtable */
 	new_asoc->temp = 1;
-- 
2.17.1

