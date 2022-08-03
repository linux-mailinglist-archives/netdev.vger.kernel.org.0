Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3F1588F5D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiHCPbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbiHCPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:30:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0033C5FC5;
        Wed,  3 Aug 2022 08:30:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ED75B822D8;
        Wed,  3 Aug 2022 15:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B7DC433C1;
        Wed,  3 Aug 2022 15:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659540648;
        bh=qveOF7M+/THb5XqsBFIqmR62rxGDFMrgJivac9Qqmr4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Q354d5utkUKbbRk2IUMsye67BTsDOiNjH/AXCIWe3mPbNwUW67vsEJBG4GPnI5al5
         QjhrsvPeGesev1kTAsnmw4vW/zaJegFugXy7yVL4m1fo4x8/oZ3YLTsgDn8JY40kJS
         NAAVXdjs4gQHNIEgADnt6Hifvt3uHbfjuAgrqXJOMfl2zFhVZDv6V4NIsBwz5iBsMh
         6Y1MoHih29xbm9kHKAGzz0NMUE2sB/vO+5KmNcMUQiLsjgOc6siYcbgf1PsBlbwdsY
         viA0kvhPQbWCD6PNMpB0Myc1TjyxFkYn/+8PebgbFPmUwp+uFUmr896lHXELEmJ3+W
         UzorkMOgoWqPw==
Message-ID: <e5fa55d1-b690-a672-0a9b-b6e31930f08c@kernel.org>
Date:   Wed, 3 Aug 2022 09:30:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net 1/4] geneve: do not use RT_TOS for IPv6 flowlabel
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
 <20220802120935.1363001-2-matthias.may@westermo.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220802120935.1363001-2-matthias.may@westermo.com>
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
> Fixes: 3a56f86f1be6a ("geneve: handle ipv6 priority like ipv4 tos")
> Signed-off-by: Matthias May <matthias.may@westermo.com>
> ---
> v1 -> v2:
>  - Fix spacing of "Fixes" tag.
>  - Add missing CCs
> ---
>  drivers/net/geneve.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
