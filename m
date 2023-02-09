Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7294C690D27
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 16:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjBIPjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 10:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbjBIPjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 10:39:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5E74226
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 07:39:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6F761AF6
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 15:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5A0C433D2;
        Thu,  9 Feb 2023 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675957160;
        bh=dpYp10QT/Uah4+Szo+4XeT2hB/ytyaXLWqmZB2qafjc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ScpQxbvYrb7v+tFR6KOpWrhGI+BEsAA2Fk0XUvk86Pm059XX1dsmgWL8cjj+Hzjfj
         zW17SrU2vgP4thTjCE3IaLcTRjftvAJmJAVFVN0Dka9JddTlelTM6QT4r1HFOOe2eL
         q1CoQmQFwuD2mRLaLBRz99kOwKZ3KgtZCExbiI0PtYqsKE0wM06WWYM3mG//QgIKy7
         Dh++vf5PrF5ePOqJY83sGynUdKKds6NSXApMIS8ZBCcc6XEg+0FEVHpnKcRCLuNZsv
         Z2if4z+0kn0GOaMMTn+kYq++ZBBxL3BzDt7aD6F5GmuGfitePaVUH692/mFD842C6a
         8hB447h/3ixFw==
Message-ID: <fa2c8381-1a66-31dc-8799-2ce237071adc@kernel.org>
Date:   Thu, 9 Feb 2023 08:39:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/3] ipv6: Fix datagram socket connection with DSCP.
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
References: <cover.1675875519.git.gnault@redhat.com>
 <b827a871f8dbc204f08e7f741242ba7f7d5cb8ab.1675875519.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <b827a871f8dbc204f08e7f741242ba7f7d5cb8ab.1675875519.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/23 10:13 AM, Guillaume Nault wrote:
> Take into account the IPV6_TCLASS socket option (DSCP) in
> ip6_datagram_flow_key_init(). Otherwise fib6_rule_match() can't
> properly match the DSCP value, resulting in invalid route lookup.
> 
> For example:
> 
>   ip route add unreachable table main 2001:db8::10/124
> 
>   ip route add table 100 2001:db8::10/124 dev eth0
>   ip -6 rule add dsfield 0x04 table 100
> 
>   echo test | socat - UDP6:[2001:db8::11]:54321,ipv6-tclass=0x04
> 
> Without this patch, socat fails at connect() time ("No route to host")
> because the fib-rule doesn't jump to table 100 and the lookup ends up
> being done in the main table.
> 
> Fixes: 2cc67cc731d9 ("[IPV6] ROUTE: Routing by Traffic Class.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv6/datagram.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

