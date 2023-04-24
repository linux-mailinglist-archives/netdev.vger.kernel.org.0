Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B393A6ECD71
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjDXNXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjDXNXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:23:18 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C905DBB
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:23:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 0877C220002;
        Mon, 24 Apr 2023 15:23:05 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BLW2nJ5aHWey; Mon, 24 Apr 2023 15:23:03 +0200 (CEST)
Received: from [IPV6:2a01:8b81:5400:f500:f3b:96c8:e07b:e570] (unknown [IPv6:2a01:8b81:5400:f500:f3b:96c8:e07b:e570])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 839A7220001;
        Mon, 24 Apr 2023 15:23:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
        s=default; t=1682342583;
        bh=T/AmyUPk8YrcQjcc47MQSqg7TzCL+ipSYuvNpjTpRE4=;
        h=Date:To:Cc:From:Subject:From;
        b=hzNypNmGOlV0IInGR/IJ2R9Af13AxLamVkj3q0cgKBuBBr3+byex2QRgsoxSXfwm9
         O/3n8lzivcR379eisnfbxMUIA/8XgrFNxlrDVLKUcSWTOzZB30yVoO7AwR06XlFWVH
         XStW7ITNLtqwMkbvLr4dHnWwz9RF2e+Z71W7jHaFHjhcU7g0nQ/b1m0RwnM0bAgd9U
         6ow/sF0nZGlT0TzzgFt6E1WFOGfyinFSAJI5KCNrf+eBtIbD8GR+ePSKQwNNc41nmD
         dyCLMZDPS2/d7A3Gjv1ib8KP6H49c9uJMgAs+RixFtN3DOJ3uMIgqgxj/oAtrq9psY
         iCREfNJrkvrVQ==
Message-ID: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
Date:   Mon, 24 Apr 2023 15:23:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US, de-CH-frami
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
From:   Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH ipsec] xfrm: Ensure consistent address families when resolving
 templates
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_state_find() uses `encap_family` of the current template with
the passed local and remote addresses to find a matching state.
This check makes sure that there is no mismatch and out-of-bounds
read in mixed-family scenarios where optional tunnel or BEET mode
templates were skipped that would have changed the addresses to
match the current template's family.

This basically enforces the same check as validate_tmpl(), just at
runtime when one or more optional templates might have been skipped.

Signed-off-by: Tobias Brunner <tobias@strongswan.org>
---
  net/xfrm/xfrm_policy.c | 5 +++++
  1 file changed, 5 insertions(+)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 62be042f2ebc..e6dfa55f1c3a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2440,6 +2440,7 @@ xfrm_tmpl_resolve_one(struct xfrm_policy *policy, const struct flowi *fl,
  	struct net *net = xp_net(policy);
  	int nx;
  	int i, error;
+	unsigned short prev_family = family;
  	xfrm_address_t *daddr = xfrm_flowi_daddr(fl, family);
  	xfrm_address_t *saddr = xfrm_flowi_saddr(fl, family);
  	xfrm_address_t tmp;
@@ -2462,6 +2463,9 @@ xfrm_tmpl_resolve_one(struct xfrm_policy *policy, const struct flowi *fl,
  					goto fail;
  				local = &tmp;
  			}
+		} else if (prev_family != tmpl->encap_family) {
+			error = -EINVAL;
+			goto fail;
  		}
  
  		x = xfrm_state_find(remote, local, fl, tmpl, policy, &error,
@@ -2471,6 +2475,7 @@ xfrm_tmpl_resolve_one(struct xfrm_policy *policy, const struct flowi *fl,
  			xfrm[nx++] = x;
  			daddr = remote;
  			saddr = local;
+			prev_family = tmpl->encap_family;
  			continue;
  		}
  		if (x) {
-- 
2.34.1
