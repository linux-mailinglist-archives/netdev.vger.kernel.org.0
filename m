Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5816C4063
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCVC2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCVC2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:28:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F7720058
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 19:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8A9961F19
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 02:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6B0C433EF;
        Wed, 22 Mar 2023 02:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679452114;
        bh=HovZ2sXmU8iM02tE4arDfrKzjV08qXfZqz+CpXmKK2U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MXAfie6uVLPKK/gOmAXRMtvBDDvIVYAxrMtrVfgqAWiLPq8NoHepPUOMNkHUmHqVU
         rBqy0p/N+Z3SA3+DwczieQ4bjSa3M/yQnVZcKmGUTu1+jFNWjx5XckhFMiT3pj3zRV
         4siWV85at3hm0sAzwjDONY49/ODuR/LzrYtv8/kKwxDlk6MgilVal+xgLQ4tJ07y9f
         hNQzvYTnAyueMdFzM5HFsu3SRXo96DfcsySewfvXBkk51Zbmd+E3mYCXhqMF15N43O
         69BWneSE1A9nWH94O41urMbfUY7Zvu8bM3RucN0nWf/vlLETixNpNLAVPylEh8Q6uF
         My7VaRN263+2A==
Message-ID: <43d833dd-2e1f-d225-bb56-6eed43243cb2@kernel.org>
Date:   Tue, 21 Mar 2023 20:28:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 1/3] net: ipv4: Allow changing IPv4 address
 protocol
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Ido Schimmel <idosch@nvidia.com>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>
References: <cover.1679399108.git.petrm@nvidia.com>
 <6ffecb0f77dc6e444e3a130a09b4fd5d717e6504.1679399108.git.petrm@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <6ffecb0f77dc6e444e3a130a09b4fd5d717e6504.1679399108.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/23 5:51 AM, Petr Machata wrote:
> When IP address protocol field was added in commit 47f0bd503210 ("net: Add
> new protocol attribute to IP addresses"), the semantics included the
> ability to change the protocol for IPv6 addresses, but not for IPv4
> addresses. It seems this was not deliberate, but rather by accident.
> 
> A userspace that wants to change the protocol of an address might drop and
> recreate the address, but that disrupts routing and is just impractical.
> 
> So in this patch, when an IPv4 address is replaced (through RTM_NEWADDR
> request with NLM_F_REPLACE flag), update the proto at the address to the
> one given in the request, or zero if none is given. This matches the
> behavior of IPv6. Previously, any new value given was simply ignored.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/devinet.c | 3 +++
>  1 file changed, 3 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


