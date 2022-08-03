Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9004B588F60
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238139AbiHCPbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiHCPbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:31:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB296478;
        Wed,  3 Aug 2022 08:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CAD1B822D9;
        Wed,  3 Aug 2022 15:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C66C433C1;
        Wed,  3 Aug 2022 15:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659540663;
        bh=bLeWGvL9ABqKQKqhKdZ8WpLsnIzvsynF384v8qDl9D4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=j7rY/pcyyNLM5lrQ1apLPpN9cCPtWSdO3Stv1ZXQm5VDj0y4rT6P3Nwt71fVb7pTF
         XnX8MuVQYMpqDquHvIKu+xvB6m+6YbObf+NbBHGa5fG7iQTy8K0HceT6JH1oZ/+v2F
         RWuIP2UgWDsqAR46pB1Qa86PI22fVIIur8QAxwb5Nx7jdkBeojTew2iLusnPpdLgdh
         Eo++P1guAhFbD8+PtIDrBERS81vRThjEl2Bzkb2B/jQ9BvNAWIaBuB5lwwIes+MlFF
         e89/XWQwuG1FjtE2ZqteiNT8VkdTOVk+6Ee3JqTm5sJNlvRAN7RUYMnUnxnD2DXcgH
         HRXQ/qa/NogOg==
Message-ID: <6b7dca9a-165c-bffc-9fde-6bd8bd9987e7@kernel.org>
Date:   Wed, 3 Aug 2022 09:31:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2 net 2/4] vxlan: do not use RT_TOS for IPv6 flowlabel
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
 <20220802120935.1363001-3-matthias.may@westermo.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220802120935.1363001-3-matthias.may@westermo.com>
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
> Fixes: 1400615d64cf ("vxlan: allow setting ipv6 traffic class")
> Signed-off-by: Matthias May <matthias.may@westermo.com>
> ---
> v1 -> v2:
>  - Fix spacing of "Fixes" tag.
>  - Add missing CCs
> ---
>  drivers/net/vxlan/vxlan_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


