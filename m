Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F254DCDC7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237529AbiCQSln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237519AbiCQSlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:41:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3562F2128D7;
        Thu, 17 Mar 2022 11:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B5261739;
        Thu, 17 Mar 2022 18:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76000C340E9;
        Thu, 17 Mar 2022 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647542425;
        bh=iIu1V23+6QwynGK7oa/GN5GSITG4WWL20FQ8vV5zwJw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BsgoW73Z0ZEjGdDzrnb7dJiPRBwqkKM3mnMb+JwDYVSkTQU5tHAU54XPyD2fEF+GX
         VpY2UYcEr/InN4CSWeSdpgaHzut+IwBihrAh6JB7veCponOzGtjU+whyYA695zYsau
         zKG1REuebsb2dMcV202ykf2r0KPC+ePZpriILmUU75WHzCtcaqc/esHglVXPpFu+iX
         qV1y+NddKSgxLpdI2O9XFVNLragRHJ86zaWtJkDATRL0EGu2ojyJ1o2ZAnrgQ03Sy5
         ujaprGTile1OFMb+LSG1Ue008CY8LEsgdxohduJqVKoOdur1NanYeXReCnOfl2+KUH
         OPFZISZAPNA/Q==
Message-ID: <50e99bc2-b0ca-1e83-004d-ca550294cc95@kernel.org>
Date:   Thu, 17 Mar 2022 12:40:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net v2 1/2] ipv4: Fix route lookups when handling ICMP
 redirects and PMTU updates
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1647519748.git.gnault@redhat.com>
 <8cbc1e6f2319dd50d4289bec6604174484ca615c.1647519748.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <8cbc1e6f2319dd50d4289bec6604174484ca615c.1647519748.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 6:45 AM, Guillaume Nault wrote:
> The PMTU update and ICMP redirect helper functions initialise their fl4
> variable with either __build_flow_key() or build_sk_flow_key(). These
> initialisation functions always set ->flowi4_scope with
> RT_SCOPE_UNIVERSE and might set the ECN bits of ->flowi4_tos. This is
> not a problem when the route lookup is later done via
> ip_route_output_key_hash(), which properly clears the ECN bits from
> ->flowi4_tos and initialises ->flowi4_scope based on the RTO_ONLINK
> flag. However, some helpers call fib_lookup() directly, without
> sanitising the tos and scope fields, so the route lookup can fail and,
> as a result, the ICMP redirect or PMTU update aren't taken into
> account.
> 
> Fix this by extracting the ->flowi4_tos and ->flowi4_scope sanitisation
> code into ip_rt_fix_tos(), then use this function in handlers that call
> fib_lookup() directly.
> 
> Note 1: We can't sanitise ->flowi4_tos and ->flowi4_scope in a central
> place (like __build_flow_key() or flowi4_init_output()), because
> ip_route_output_key_hash() expects non-sanitised values. When called
> with sanitised values, it can erroneously overwrite RT_SCOPE_LINK with
> RT_SCOPE_UNIVERSE in ->flowi4_scope. Therefore we have to be careful to
> sanitise the values only for those paths that don't call
> ip_route_output_key_hash().
> 
> Note 2: The problem is mostly about sanitising ->flowi4_tos. Having
> ->flowi4_scope initialised with RT_SCOPE_UNIVERSE instead of
> RT_SCOPE_LINK probably wasn't really a problem: sockets with the
> SOCK_LOCALROUTE flag set (those that'd result in RTO_ONLINK being set)
> normally shouldn't receive ICMP redirects or PMTU updates.
> 
> Fixes: 4895c771c7f0 ("ipv4: Add FIB nexthop exceptions.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv4/route.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

