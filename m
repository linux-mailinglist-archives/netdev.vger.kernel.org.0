Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C70B5442D6D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhKBMFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhKBMFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:05:32 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EECC061766;
        Tue,  2 Nov 2021 05:02:57 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id b17so9619948qvl.9;
        Tue, 02 Nov 2021 05:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Itc6JPAI1Gr16g6VMaVP9VVwLYdkvvzpZY0wbOSMqoU=;
        b=ZXAb8ESI69ifPDSgl3LU1GoiZxHkmgbasUkBt3CeWI+U3yIQ5UVH+kynHuwfoVTzje
         koxFZ8vtNibAaoUa3tGiM4+gQtIVX7GAzWM1PDwuJR6Ys0qwcyfKpjtzJLwB/E8NqfUn
         UTE2EUMQWSB3JTIfwSXQMR6l+Y1F2miwPJOFPX+NqX6dPyvF3inoXXomKX181eCSjRy6
         jhHH4Ourdqhnf4DaQtzObRhTCVUmCEPjxYyTVSzrv7EKUs+2CT427g4/uCPdLsg6qVBZ
         OZJ0AcEH5TGFO174IwAAWf7EDI3cJu2VUa2RLe2tqgr0IDlNYfWRXxfNMHbSpZALQxsP
         2T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Itc6JPAI1Gr16g6VMaVP9VVwLYdkvvzpZY0wbOSMqoU=;
        b=n6l4EyJvyab5QLy6KlR1r6xw/j39zc/2vTPy3H3J9F2ccTwPFQAwmxCE7HArWBCwov
         3wz5T/aefUivVtxai/MdHq+kN5LY0vSf5auPf0YU/BpTIK0ceBAS9JmUI64znZ6N96RK
         NzwUQeBuzXGThqH0eqdz9ywD9QbhJE8NFKo8AA70AdSh63craqgJfPiYB4GW5GrNpEb2
         ZptYEgGF7Z0E4eHZTmtt+ZCHk8rRKBJPy4umNEwiI5ykGAS3vXLurimkUHx0rsRuRgJV
         mPGG/mlfvr0HIdzI8F5F7j1E3/SW4tOPxlUwkFPj2uTvzKMDUXrgfl7xzcY0kohBmypk
         Z28w==
X-Gm-Message-State: AOAM532mfMzzu1V6ZPWZi1S51Dt0tak2miTqxhshUN+Gy75sSvDFEWQh
        IbGeLJcs8hFNGK/mqGOmQEVCDsbW1cNKy3yX
X-Google-Smtp-Source: ABdhPJycWf0K5fGjTWIIKaNv0iNcyVweB3bGkCPI8pQgGrt8QAs/Nk5bc9DgyoW+/v7Ji/qEbCfvEQ==
X-Received: by 2002:ad4:4e48:: with SMTP id eb8mr25212508qvb.28.1635854576414;
        Tue, 02 Nov 2021 05:02:56 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w9sm12498988qko.19.2021.11.02.05.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 05:02:55 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        James Morris <jmorris@namei.org>,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCHv2 net 2/4] security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce
Date:   Tue,  2 Nov 2021 08:02:48 -0400
Message-Id: <d0ff6b2fe8ffb54ea1efcaff74350549b8bfdcd5.1635854268.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1635854268.git.lucien.xin@gmail.com>
References: <cover.1635854268.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The asoc created when receives the INIT chunk is a temporary one, it
will be deleted after INIT_ACK chunk is replied. So for the real asoc
created in sctp_sf_do_5_1D_ce() when the COOKIE_ECHO chunk is received,
security_sctp_assoc_request() should also be called.

v1->v2:
  - fix some typo and grammar errors, noticed by Ondrej.

Fixes: 72e89f50084c ("security: Add support for SCTP security hooks")
Reported-by: Prashanth Prahlad <pprahlad@redhat.com>
Reviewed-by: Richard Haines <richard_c_haines@btinternet.com>
Tested-by: Richard Haines <richard_c_haines@btinternet.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/security/SCTP.rst | 15 +++++++++------
 net/sctp/sm_statefuns.c         |  5 +++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/security/SCTP.rst b/Documentation/security/SCTP.rst
index 415b548d9ce0..d5fd6ccc3dcb 100644
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
+                                             for a temporary association.
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
+                                             Confirm the cookie and create a
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

