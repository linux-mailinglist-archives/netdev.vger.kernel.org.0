Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966464371E2
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJVGio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbhJVGii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 02:38:38 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7442C061766;
        Thu, 21 Oct 2021 23:36:21 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id a20-20020a1c7f14000000b003231d13ee3cso2172799wmd.3;
        Thu, 21 Oct 2021 23:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sVupCt1NbGHaxE4sy+Ut1rFdUNCXquJ9cOxmfS4P2+o=;
        b=mjqEdSsIMQ0kBruWl7XBJZvP4I0esKYoY4I3flCd7qE/c5x1w2OIyMUIcBAbEyLfCJ
         eOWDl+/7hF0XH2ENnZMybjmHKF064Vlelc+0cODnuVSzltiacA3N67d/1HIjFoDYWlui
         rgWs/4XvxzrTy1jQf2JuCqPJvr20NDTxN1MeF5Rwa7BmGZ0k3w6Et2oedB041OoWsq2V
         mmXl++/ty1n4yxKsC1mPDrYy7RtiPKqScdrKn4mA4zsqXJBYoFoGrOtB5xumom9qe3bC
         JL3BEbvd5PUkqN9CSscRhWAx/PTmfLhlavTU/UYBb6V4xzfNudFKB+yQ06P2ypFiVdXW
         fqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVupCt1NbGHaxE4sy+Ut1rFdUNCXquJ9cOxmfS4P2+o=;
        b=fhBc8nA1TL7vmJQfp7FH8+p9XtN6xclO+FZ8tdjhggQHEHxfVq1xeu8GeTl9DZX20g
         QD3e2+0n3waH2RXD2AzhKCkW5m2m4TOvOsUqZvBNGvJY9N05Tfgf7gA02oNhvE+F3iJW
         K0BHyCw6qyfoS7zB/6Z8VZeXu76/eMQvmK0ii/XLCtjjA9JYMumB2lDLGcTGJoeMeg1b
         E5FKv6+B3pG8EOZX6ZT1tWGlP6uObLFteXy2A3FFGN4ZtuxNAO5CC5n+IQ/goqwfUwFg
         rMVqHi1khHk5rJPsH+iyjEhr2sF5s+D/y412oDmwycvOUUywPHQ9BEQ155CxQfyAFFik
         inDw==
X-Gm-Message-State: AOAM530pidscPZAO6xxYrBQr4XVRQo4yzChoyerPu7mf1qwSG/Pu6mIC
        VfeopaACTFN8QeMW9Z/uHT8nkxnyg5Ivhw==
X-Google-Smtp-Source: ABdhPJytfZBUsMFPj/eT07cNw3ISYcy5Lgo6xPkXBgk+Br8Q+e3SvypXKlGiPg8dF4hSmmRz5JJU4w==
X-Received: by 2002:a05:600c:410e:: with SMTP id j14mr12035231wmi.49.1634884580180;
        Thu, 21 Oct 2021 23:36:20 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c7sm4099733wrp.51.2021.10.21.23.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 23:36:19 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH net 2/4] security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
Date:   Fri, 22 Oct 2021 02:36:10 -0400
Message-Id: <ba8724d10da0f7545e5b91d1540a984c2b398a6a.1634884487.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1634884487.git.lucien.xin@gmail.com>
References: <cover.1634884487.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The asoc created when receives the INIT chunk is a temporary one, it
will be delete after INIT_ACK chunk is replied. So for the real asoc
created in sctp_sf_do_5_1D_ce() when receives the COOKIE_ECHO chunk,
security_sctp_assoc_request() should also be called.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/security/SCTP.rst | 15 +++++++++------
 net/sctp/sm_statefuns.c         |  5 +++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index 415b548d9ce0..9a38067762e5 100644
--- a/Documentation/security/SCTP.rst
+++ b/Documentation/security/SCTP.rst
@@ -151,9 +151,9 @@ establishing an association.
          INIT --------------------------------------------->
                                                    sctp_sf_do_5_1B_init()
                                                  Respond to an INIT chunk.
-                                             SCTP peer endpoint "A" is
-                                             asking for an association. Call
-                                             security_sctp_assoc_request()
+                                             SCTP peer endpoint "A" is asking
+                                             for an temporary association.
+                                             Call security_sctp_assoc_request()
                                              to set the peer label if first
                                              association.
                                              If not first association, check
@@ -163,9 +163,12 @@ establishing an association.
           |                                       discard the packet.
           |
     COOKIE ECHO ------------------------------------------>
-                                                          |
-                                                          |
-                                                          |
+                                                  sctp_sf_do_5_1D_ce()
+                                             Respond to an COOKIE ECHO chunk.
+                                             Confirm the cookie and create an
+                                             permanent association.
+                                             Call security_sctp_assoc_request() to
+                                             do the same as for INIT chunk Response.
           <------------------------------------------- COOKIE ACK
           |                                               |
     sctp_sf_do_5_1E_ca                                    |
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 3206374209bc..b818532c3fc2 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -781,6 +781,11 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 		}
 	}
 
+	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
+		sctp_association_free(new_asoc);
+		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
+	}
+
 	/* Delay state machine commands until later.
 	 *
 	 * Re-build the bind address for the association is done in
-- 
2.27.0

