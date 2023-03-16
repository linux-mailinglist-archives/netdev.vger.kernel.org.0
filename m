Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5676BD3F4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjCPPhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjCPPhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:37:04 -0400
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D8B9759
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:34:44 -0700 (PDT)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-544781e30easo19108807b3.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OsCMtllsV7F8O6hrof2lMj6Iq6sUWmbGkir1umoA/5M=;
        b=n497xDjosRrHGITf+UWM6+NNdk75c08+ULnrn8CgZive06Ejtyfv8pvm1wnYRLy5mg
         xulpMZ/kUI+A4Gtsd5koByg2l9ebo6N3pF+WZnnCP6xFcJ+PiTMcS+A1zdAOvGb1GGRR
         tUjdUGpDv/D+B645Zz7pXdgp35/9P4kcl7fCDib0xRq06M6VU/Fjvhrg50+BcTUcaNX4
         FomqCUU9EPmIgVeWuNO7v9aAtxRIZN57eTqqXeLHSU3Ye0SzcEC9YsQqbpGsMTnSc7tV
         cwFvvmP8O+S8AU7Dn/B7k5A8jHYdHKYq/V7bDGBMNdUV6pxtUwkC3diw8pGzrfJa0vAX
         TPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OsCMtllsV7F8O6hrof2lMj6Iq6sUWmbGkir1umoA/5M=;
        b=qMp16RNtq+xpro0uoPSuclYTKTW98QVbnfv4iUkAd55aRmwrpJn6e+v3Z/RAe75hZ6
         ixURnYRjjlcItBZiS+zW5jyu755WwG6zFsASnZxiQ2sS0sOvxhyjn9K85dfcrbIGJ6qJ
         alIwhz56mdNm9dXHqN7kLIEEn7ZFYjN414Wr21jomd0CXd0/wQ+xeSJ6HVEHBJez59jT
         im482joh607ial25/tX4XtC5MPQi4k+WWNUMVIyQKkzGUE7RSUT1nbGyqKknvEOYsL1Z
         59VPy4K0LJ+LJQ4LKirhk8Wky9PAlGBu0/n9JmkFoMGDu/SiAooSBmrC6NmID4mJ6Qhc
         3txw==
X-Gm-Message-State: AO0yUKVjtVmXw3IcWbmyebYs+q0Ly3ZaZK8jdLWUsmyk/k7BXFn/QJjN
        y7G2MInphdg5YX7E/NxP02mKlkI5mHEOsg==
X-Google-Smtp-Source: AK7set/4kk5/sgEGURGNoYx3QprLMikb2VTMd51yuT9EPkziIX/hUQz4Eqmuc0izBIag/tL+LNGVlSGrETY25g==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1105:b0:b4f:c5a5:f224 with SMTP
 id o5-20020a056902110500b00b4fc5a5f224mr3564175ybu.8.1678980734327; Thu, 16
 Mar 2023 08:32:14 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:32:00 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-7-edumazet@google.com>
Subject: [PATCH v2 net-next 6/8] ipv6: raw: constify raw_v6_match() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clarifies raw_v6_match() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/rawv6.h | 2 +-
 net/ipv6/raw.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/rawv6.h b/include/net/rawv6.h
index bc70909625f60dcd819f50a258841d20e5ba0c68..82810cbe37984437569186783f39f166e89cb9b8 100644
--- a/include/net/rawv6.h
+++ b/include/net/rawv6.h
@@ -6,7 +6,7 @@
 #include <net/raw.h>
 
 extern struct raw_hashinfo raw_v6_hashinfo;
-bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v6_match(struct net *net, const struct sock *sk, unsigned short num,
 		  const struct in6_addr *loc_addr,
 		  const struct in6_addr *rmt_addr, int dif, int sdif);
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index bac9ba747bdecf8df24acb6c980a822d8f237403..6ac2f2690c44c96e9ac4cb7368ee7abdbeaf4334 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -64,7 +64,7 @@
 struct raw_hashinfo raw_v6_hashinfo;
 EXPORT_SYMBOL_GPL(raw_v6_hashinfo);
 
-bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v6_match(struct net *net, const struct sock *sk, unsigned short num,
 		  const struct in6_addr *loc_addr,
 		  const struct in6_addr *rmt_addr, int dif, int sdif)
 {
-- 
2.40.0.rc2.332.ga46443480c-goog

