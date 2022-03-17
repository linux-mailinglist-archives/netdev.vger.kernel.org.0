Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44AA4DCDC9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiCQSnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiCQSnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:43:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EE72128D7;
        Thu, 17 Mar 2022 11:42:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5CF761024;
        Thu, 17 Mar 2022 18:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F9DC340E9;
        Thu, 17 Mar 2022 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647542524;
        bh=3CSayqNGvGSARMApI7OFbIaO6nPKU7WtKxQpB3Ggkjg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=eM2t0a/SgpBBfjSvaX7fDht1LFrfzxXuFdds5pa7ObRlSzoDj+yITAOYJuImQmqcB
         zcPWxAga6Ucz+MQzcrT4qLZ6INKLCnPOIGlgrtvQAyNFLe69J1IJKH3YurqPCJWHXI
         yZSixMJVRnNlRfZzKzM2SoObnXTTuVn3gxeHShazzRA3J3qSpkuSZ4NDOazJO9rG98
         a0ZESv7ZtkZ/vv+DOlhpvmJ1PRUzVnVZl9VpK0KasWFrnVVYCjrX48Yw1ThrysvTYL
         mNy/8kqGkza8E+tjUvm52mCjUoazz5ZzG+i3eh/DOOvoY3lIIyfTwzP2mzOwGBotVL
         Feq0FKTlpdsQw==
Message-ID: <30d97bfa-fd0a-c7dc-98c6-5d1d0358fb4e@kernel.org>
Date:   Thu, 17 Mar 2022 12:42:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net v2 2/2] selftest: net: Test IPv4 PMTU exceptions with
 DSCP and ECN
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1647519748.git.gnault@redhat.com>
 <6f3853ab347422044d71f394bb991548d30992d3.1647519748.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <6f3853ab347422044d71f394bb991548d30992d3.1647519748.git.gnault@redhat.com>
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
> Add two tests to pmtu.sh, for verifying that PMTU exceptions get
> properly created for routes that don't belong to the main table.
> 
> A fib-rule based on the packet's DSCP field is used to jump to the
> correct table. ECN shouldn't interfere with this process, so each test
> has two components: one that only sets DSCP and one that sets both DSCP
> and ECN.
> 
> One of the test triggers PMTU exceptions using ICMP Echo Requests, the
> other using UDP packets (to test different handlers in the kernel).
> 
> A few adjustments are necessary in the rest of the script to allow
> policy routing scenarios:
> 
>   * Add global variable rt_table that allows setup_routing_*() to
>     add routes to a specific routing table. By default rt_table is set
>     to "main", so existing tests don't need to be modified.
> 
>   * Another global variable, policy_mark, is used to define which
>     dsfield value is used for policy routing. This variable has no
>     effect on tests that don't use policy routing.
> 
>   * The UDP version of the test uses socat. So cleanup() now also need
>     to kill socat PIDs.
> 
>   * route_get_dst_pmtu_from_exception() and route_get_dst_exception()
>     now take an optional third argument specifying the dsfield. If
>     not specified, 0 is used, so existing users don't need to be
>     modified.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  tools/testing/selftests/net/pmtu.sh | 141 +++++++++++++++++++++++++++-
>  1 file changed, 137 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


