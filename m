Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05AAF4576E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfFNIZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:25:17 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46940 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfFNIZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:25:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id e5so692326pls.13;
        Fri, 14 Jun 2019 01:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cYQjm9+nQ4ypp+FRu1ITt+gJ3TAafpTWvN1Lz5wgmGg=;
        b=pa828t/YS/IvBHGqpmNujbtEp0+IXJldubilVZmrDz5u0amvVd4Cddb13a5wsmEuVf
         j5+ZOHfdj97QD6m6Um/Jp0JGv/ssgbpSp4ax7Y3/Vqc4LXJGTCICVbvarGYWZrs/LAXq
         7+qUB2vrONKcKWWLjqy/BXdPfUxFpNsrdsRE/DJ/UFsTnLp0NNaFsea3O/Whkxmt1YLA
         UAEHAw51hGAZyfdcvnpdJC55lcLP38JNgIEOCLXns+UhUW+DB919fxd43aRzH/RRTU2H
         NYhrIojcEtxhk9L/4Y//lvoSjMSzq2eLPbBBFt+teqz+MueCsWs0bEDFLIrkdH61o+Uh
         CTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cYQjm9+nQ4ypp+FRu1ITt+gJ3TAafpTWvN1Lz5wgmGg=;
        b=n1IOI9tHM96bKEWK+ySYeva0hZq/fBYpnfaAtqga7yCvIStvWbyhpaXHxAizrX2j3y
         3usz6Uz6lmoxHjFFQcUsIIjbCd7ND4LLq7dGB0e4p7ipcDbw5s9jfcmHniUxpVT5MXxV
         5KieioUk57AGwQPx47d9iiR2jnDmxc8fUIZroASSDp5grD7+zLHDHonuhPmF3WZC10OT
         KmQ1shHV2cT5axyLeXZ9CoijoZ7ljxZED+1ubWVuV90pZvn7KeqowkWSs8ZNEOf84saJ
         Xy/m/kLGgjFZ9vg7l2nveE82K9AQo+t4ZCk2qGSy+ihCTqis2sGSkaZAnbVrHfxqPcLG
         97Cg==
X-Gm-Message-State: APjAAAUBgrQXzPWTKxfZepQ/PcItVQa1uvuF1EnVVPuP2OnZWVBsv5v7
        JfcOkoBBqVy/29tZSC+c0xo7iyHJlVM=
X-Google-Smtp-Source: APXvYqzPgRFJ/x48Zgnl2O9POj+ErP0DBqEjX0xJGoTm2QsM9tDEb6DAC0LnBiALXROot4RrriM7Xw==
X-Received: by 2002:a17:902:2a26:: with SMTP id i35mr53075593plb.315.1560500716131;
        Fri, 14 Jun 2019 01:25:16 -0700 (PDT)
Received: from xy-data.openstacklocal ([159.138.22.150])
        by smtp.gmail.com with ESMTPSA id x14sm2649971pfq.158.2019.06.14.01.25.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 01:25:15 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] af_key: Fix memory leak in key_notify_policy.
Date:   Fri, 14 Jun 2019 16:26:26 +0800
Message-Id: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We leak the allocated out_skb in case pfkey_xfrm_policy2msg() fails.
Fix this by freeing it on error.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/key/af_key.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 4af1e1d..ec414f6 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2443,6 +2443,7 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
 	}
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
 	if (err < 0)
+		kfree_skb(out_skb);
 		goto out;
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
@@ -2695,6 +2696,7 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
 
 	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
 	if (err < 0)
+		kfree_skb(out_skb);
 		return err;
 
 	out_hdr = (struct sadb_msg *) out_skb->data;
-- 
2.7.4

