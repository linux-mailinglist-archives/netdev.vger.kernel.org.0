Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6477588F6C
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiHCPc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238225AbiHCPbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9277013E8E;
        Wed,  3 Aug 2022 08:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAAD61706;
        Wed,  3 Aug 2022 15:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08FCC43470;
        Wed,  3 Aug 2022 15:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659540701;
        bh=a+i52MSBiS0GrRb3scpYMp/RWIBph7+5yoxdXSzi4ok=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SFobtsPRKF8Ap3ajfdo9moRzGOBN9aCV263UmaWG6Na7q5h/7juAxdYaKPoOLOl8V
         tS9puAy4pl/vQaa35sJ8T81rdvxzSFvUWKQbq6OaT6nrILDPK6N7HYSnXhAYg9Ppc7
         wZbh3oa4S5NIYlgXGQHhU+PJ8mCk+CYJhsWa0+JMoEKZflG3X1u0NfLqRKQJ2L06HA
         EoMAxfPfO4wJlqvPWm+mtNZdF3Fy4VnhHEEWElk5NT1BkxHqjtWvaM4YHTHunMLsqY
         WZKd8+y3GPleih2D94eKlx+xmJTX0wlM5OCU5jhNEJPR4qGGyDL+l+4RZ/RH3CX9Mu
         6z2x4Uj/0XPJA==
Message-ID: <2e9e7f28-02b5-382e-87fe-57cec9c2f6c8@kernel.org>
Date:   Wed, 3 Aug 2022 09:31:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net 4/4] ipv6: do not use RT_TOS for IPv6 flowlabel
Content-Language: en-US
To:     Matthias May <matthias.may@westermo.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        saeedm@nvidia.com, leon@kernel.org, roid@nvidia.com,
        maord@nvidia.com, lariel@nvidia.com, vladbu@nvidia.com,
        cmi@nvidia.com, gnault@redhat.com, yoshfuji@linux-ipv6.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-rdma@vger.kernel.org, nicolas.dichtel@6wind.com,
        eyal.birger@gmail.com, jesse@nicira.com, linville@tuxdriver.com,
        daniel@iogearbox.net, hadarh@mellanox.com, ogerlitz@mellanox.com,
        willemb@google.com, martin.varghese@nokia.com
References: <20220802120935.1363001-1-matthias.may@westermo.com>
 <20220802120935.1363001-5-matthias.may@westermo.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220802120935.1363001-5-matthias.may@westermo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/22 6:09 AM, Matthias May wrote:
> According to Guillaume Nault RT_TOS should never be used for IPv6.
> 
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Matthias May <matthias.may@westermo.com>
> ---
> v1 -> v2:
>  - Fix spacing of "Fixes" tag.
>  - Add missing CCs
> ---
>  net/ipv6/ip6_output.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>


