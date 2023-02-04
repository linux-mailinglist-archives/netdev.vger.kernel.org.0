Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74E068ABC3
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjBDRu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbjBDRuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:50:25 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3C626878
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:50:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id bx22so5052590pjb.3
        for <netdev@vger.kernel.org>; Sat, 04 Feb 2023 09:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=theori.io; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HLhSD+4EnhA2jA0rYzg2T5h/GAY3OSYZnky84OrpAO0=;
        b=VsBlacRWrjjCKgXHeNo03hhveTjQqQP25NxofnRkiX1bcPNgMytqmpsvA7SMC/7GqO
         q7dJUGVi7h3ckncK9XAo9sJC5xydPPpaVZ125zM/xLzzLf3R0bg/TIAss0CW3KIhyJRG
         15FNEs6jF2EJHD2ID8TpXtADXuzySUn0D+EAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HLhSD+4EnhA2jA0rYzg2T5h/GAY3OSYZnky84OrpAO0=;
        b=XN6ZezVzmydTqwiMhnjoD5VefFC9Bi6ns6lJN1rMi8GUoJjR6YchujBZkQS7y4dOb+
         o/Y0L8MqpH/dtHt72+ltIV5gm7YlR3rS+W8MsUOjQPqHZTW9krErdiYw6K1ic586zDi2
         gcSpuTYCvnHqmdNKqpqiajXw2hdPmBLyfN1YTsslCUS6Fmx8A4nRtIq9tijdgeudkVza
         cjBVPcO0I3CXFXdRtnrs7gyQY/ulSpd17VCXYgBa3QlMDjtNN2U0KVlLgOHupcH8AE5I
         sZpEtMlhweX+7PyAGMbnm4Bk5KxFN8A48sMmA07S9/1314VXrRhvzvDvnZ0930LQfJ7o
         1LwA==
X-Gm-Message-State: AO0yUKXFjt7PxZ+F+aZv78KzJdNVSxktdH+NIiIib3OZHQPA7bW4Re61
        GWkklXTAVMB5LXO2ofUDobqCFw==
X-Google-Smtp-Source: AK7set8Qr3fpRH3PpivMu1tKvAuQfVOPgXmmXZea3KibscJpGO8/ZnYxyDhrnlSjTbopVcv9iPpvjA==
X-Received: by 2002:a17:902:f201:b0:198:ec2d:8a09 with SMTP id m1-20020a170902f20100b00198ec2d8a09mr3397596plc.18.1675533023337;
        Sat, 04 Feb 2023 09:50:23 -0800 (PST)
Received: from ubuntu ([39.115.108.115])
        by smtp.gmail.com with ESMTPSA id j12-20020a170902c3cc00b001949b915188sm3732475plj.12.2023.02.04.09.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 09:50:22 -0800 (PST)
Date:   Sat, 4 Feb 2023 09:50:18 -0800
From:   Hyunwoo Kim <v4bel@theori.io>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     v4bel@theori.io, imv4bel@gmail.com, netdev@vger.kernel.org
Subject: [PATCH] af_key: Fix heap information leak
Message-ID: <20230204175018.GA7246@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since x->calg etc. are allocated with kmalloc, information
in kernel heap can be leaked using netlink socket on
systems without CONFIG_INIT_ON_ALLOC_DEFAULT_ON.

Signed-off-by: Hyunwoo Kim <v4bel@theori.io>
---
 net/key/af_key.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 2bdbcec781cd..9a7adcaf6aa3 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1174,7 +1174,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 		}
 		if (key)
 			keysize = (key->sadb_key_bits + 7) / 8;
-		x->aalg = kmalloc(sizeof(*x->aalg) + keysize, GFP_KERNEL);
+		x->aalg = kzalloc(sizeof(*x->aalg) + keysize, GFP_KERNEL);
 		if (!x->aalg) {
 			err = -ENOMEM;
 			goto out;
@@ -1196,7 +1196,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 				err = -ENOSYS;
 				goto out;
 			}
-			x->calg = kmalloc(sizeof(*x->calg), GFP_KERNEL);
+			x->calg = kzalloc(sizeof(*x->calg), GFP_KERNEL);
 			if (!x->calg) {
 				err = -ENOMEM;
 				goto out;
@@ -1213,7 +1213,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 			key = (struct sadb_key*) ext_hdrs[SADB_EXT_KEY_ENCRYPT-1];
 			if (key)
 				keysize = (key->sadb_key_bits + 7) / 8;
-			x->ealg = kmalloc(sizeof(*x->ealg) + keysize, GFP_KERNEL);
+			x->ealg = kzalloc(sizeof(*x->ealg) + keysize, GFP_KERNEL);
 			if (!x->ealg) {
 				err = -ENOMEM;
 				goto out;
@@ -1261,7 +1261,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 		const struct sadb_x_nat_t_type* n_type;
 		struct xfrm_encap_tmpl *natt;
 
-		x->encap = kmalloc(sizeof(*x->encap), GFP_KERNEL);
+		x->encap = kzalloc(sizeof(*x->encap), GFP_KERNEL);
 		if (!x->encap) {
 			err = -ENOMEM;
 			goto out;
-- 
2.25.1

