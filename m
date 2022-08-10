Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52AD58F23E
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 20:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiHJSWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 14:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiHJSWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 14:22:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DAF79A66
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:22:15 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p6-20020a170902e74600b0016f3f326f62so10071770plf.16
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=1bJZHgI4TM5n+2sjjy595rXA6yNmy+Fd9F0yw9vX1iI=;
        b=eFE+GVEfNfLdabWO91rLq5wvHIVlPjhEFDqAt1E5tWFit7pxmHADR7f8uKIcFWhsv9
         pWuCH9gab8hlv4+reSKR98vubiSCGKmuFfs5UoaJOvMn7EAbdo7/2InZijg0NwqvecXs
         hzMGQR+DX3Rh2HYOdOkYR8W4JOoFEs2rYAPG94cMemSd+43itoVT8BKnwJfAn0HFBXzP
         gw0Sxwnw+FbS1++6nCUa5iVaHXXGvOsv0b0Py2U6IuYzuI9Fy0F63ideYef54RfNORvh
         YeHX1D4a8Z4dEwdRCP7VVjH4JRtNnOe9M+MD5So9akQAU1+G11Sr3TRFvxZFuytbgvh8
         q2ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=1bJZHgI4TM5n+2sjjy595rXA6yNmy+Fd9F0yw9vX1iI=;
        b=DPQbczft7/tRBnqKPPMqqpk67RMhv0m6NhOy9yP3RpahtlPn0q2IbntCMt2VGXAefr
         mCB4cvbyH+CV9fqywanI11VCkmpbGMm71KZqUnULm9MVhT3rZ3qCg0plZzOPfMaHgyTc
         ARm0vd89VYyiaXqU8c3pazd2byd0ifCshFCDCa7LMy5qxNTO5W1+O078IXaPpUt57cFp
         h01Jkkn2jiz8YKKndDnGVzkM/1fSXTm8cosdIL7F+Z1nVgx7oFDkj2e8o12fto1w4twV
         cjHYXYnko44MllP6e5Bty7wBDtCXlYubjucYwHdSAwY9/yx3h/SuibQQaJuvGMdpZRiX
         QxKA==
X-Gm-Message-State: ACgBeo2I6nkz8ZeUOzOioIsAgeoITxLAUqEsE66aTCub1O370Jf6Ev25
        wREtcsF8DcR/5isBHg4pT5/Gl6tRUfpQ7W/FKes=
X-Google-Smtp-Source: AA6agR7n7QpxSjVDmQA4b7kPKgTpxr/J0UvIOPErxQPW7pnyoT2Si5GtETHnR2jEOuTumofhuNJlaR+sCbyMDqA/Wps=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a05:6a00:1a88:b0:52f:52df:ce1d with
 SMTP id e8-20020a056a001a8800b0052f52dfce1dmr14672868pfv.13.1660155735265;
 Wed, 10 Aug 2022 11:22:15 -0700 (PDT)
Reply-To: Benedict Wong <benedictwong@google.com>
Date:   Wed, 10 Aug 2022 18:22:09 +0000
In-Reply-To: <20220810182210.721493-1-benedictwong@google.com>
Message-Id: <20220810182210.721493-2-benedictwong@google.com>
Mime-Version: 1.0
References: <20220810182210.721493-1-benedictwong@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH ipsec 1/2] xfrm: Check policy for nested XFRM packets in xfrm_input
From:   Benedict Wong <benedictwong@google.com>
To:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change ensures that all nested XFRM packets have their policy
checked before decryption of the next layer, so that policies are
verified at each intermediate step of the decryption process.

This is necessary especially for nested tunnels, as the IP addresses,
protocol and ports may all change, thus not matching the previous
policies. In order to ensure that packets match the relevant inbound
templates, the xfrm_policy_check should be done before handing off to
the inner XFRM protocol to decrypt and decapsulate.

Test: Tested against Android Kernel Unit Tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
Change-Id: I20c5abf39512d7f6cf438c0921a78a84e281b4e9
---
 net/xfrm/xfrm_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 144238a50f3d..b24df8a44585 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -585,6 +585,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
+		// If nested tunnel, check outer states before context is lost.
+		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL
+				&& sp->len > 0
+				&& !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
+			goto drop;
+		}
+
 		skb->mark = xfrm_smark_get(skb->mark, x);
 
 		sp->xvec[sp->len++] = x;
-- 
2.37.1.595.g718a3a8f04-goog

