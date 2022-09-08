Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A655B24A2
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 19:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiIHRad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 13:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiIHRaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 13:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C67221BC
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662658169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=yd9DlqRTL8ppphh+h2DjZYhW5J5U8NhV4/fGSoXGbJg=;
        b=BDor1gSzk/wfj2M24qhx7H6hG3EXixnXPmWQ9neWkpM9ajXNy8pIoCX69eZe8UiFPXtAR7
        5AeskdILeYOmsAZ+F716HQMOdiK0/THzzEAY8ePW3tLKQOE6kfECYrNo9kmRM9QIY7+h7z
        vZw7UByxrM1dnXQXdnfzerEQWHRRF1g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-maPknd-RO4OOZuxWrG3wSg-1; Thu, 08 Sep 2022 13:29:28 -0400
X-MC-Unique: maPknd-RO4OOZuxWrG3wSg-1
Received: by mail-wm1-f71.google.com with SMTP id c188-20020a1c35c5000000b003b2dee5fb58so1504532wma.5
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 10:29:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yd9DlqRTL8ppphh+h2DjZYhW5J5U8NhV4/fGSoXGbJg=;
        b=GNQD77GBP2JAb49f29cCYG/6hbkHk7HJ2GgrYujqv9tekdhr5+Bem5OLM9jLT5NCY7
         Iz+gYHwwca/KuswtQ6i0AE6rcujl1Pb9JE9o/TozIqzA5mqVpdD4CuYl69Bl81jF3HFL
         n6kOnfqB1f2nUTF8m3K2x0Rdq+6oZ5HjYOddTliN8+KFJywls5+1teZ5TgkOsaM5ePeE
         IrnmmBdZoZMVIZHJa3ducz4pXSasYOItVirJwQzyW2hBPLF6Q22qjxLTvzMQkK1bZ6Os
         p/Bcq3nlPtXYTAEE0n5ZHud9qmMFENG5iqZdgX/o+Fc1yxR2w1N3b7TNkyLVzldqd55o
         yzzQ==
X-Gm-Message-State: ACgBeo0qCnkPzCdQX74ggs+YbNdLXLAvc5Ip8EORKOz8poOWgOEQgTH4
        BRa7tcKYmsrEI1+EmbRtWLpCkOR6TbrIjQJbRGhkQYL0rfbvP8T32bc0z6pJt1lNNSKsdVNIWKa
        46I5vVdPcVJfiekeh
X-Received: by 2002:a05:6000:1888:b0:222:c96d:862f with SMTP id a8-20020a056000188800b00222c96d862fmr5643695wri.706.1662658166934;
        Thu, 08 Sep 2022 10:29:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5V0DdOkPCMr/j9FXcN2Chx+sxIgGKRIrEdUufGLwbGlRX2krS4Ks0T5x/cHIPBQAMZevmdkg==
X-Received: by 2002:a05:6000:1888:b0:222:c96d:862f with SMTP id a8-20020a056000188800b00222c96d862fmr5643683wri.706.1662658166747;
        Thu, 08 Sep 2022 10:29:26 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003a844885f88sm3302678wml.22.2022.09.08.10.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 10:29:25 -0700 (PDT)
Date:   Thu, 8 Sep 2022 19:29:23 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] netfilter: rpfilter: Remove unused variable 'ret'.
Message-ID: <a6201a69efe67d91ef62e1c3b25baa5f30bbbb7a.1662658015.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 91a178258aea ("netfilter: rpfilter: Convert
rpfilter_lookup_reverse to new dev helper") removed the need for the
'ret' variable. This went unnoticed because of the __maybe_unused
annotation.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8cd3224d913e..8183bbcabb4a 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -33,7 +33,6 @@ static bool rpfilter_lookup_reverse(struct net *net, struct flowi4 *fl4,
 				const struct net_device *dev, u8 flags)
 {
 	struct fib_result res;
-	int ret __maybe_unused;
 
 	if (fib_lookup(net, fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return false;
-- 
2.21.3

