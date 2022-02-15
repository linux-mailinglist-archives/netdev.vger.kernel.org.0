Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2724B62A6
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiBOF1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:27:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbiBOF1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:27:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E0EC7D6D
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 21:27:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DD85613EA
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 05:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AAA2C340F0;
        Tue, 15 Feb 2022 05:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644902830;
        bh=DaKBDVREXkojcQOUu4dKWWTiFCgzF1qjpT/apl+0IZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b93FVyL1gJiyzbG9cqYp6xvNYt1x4Sxsa8KjjxRdobQBbPwfoUqES+m/frPTBQpL+
         DBO5P5eFRZ4P+Q74pVnD6PpA8t96cQMneoe0Vf0Po8N0n/9SqalW/cjgClw9p2yJbO
         0ftR1VYlfEl+rb2ND45u+pal5c3ssjABZoyiy6zsPH9oFot8JHicuq9aCur82pRl3u
         VcYAgtqQEO2+web1OZLM2DQGUh2HX3z5Frm1iKf2VPmZpg2EbIl6gYJ/iMTqjIUiTX
         2KcN/fziMVagpqb1XdNo7C6kDgWw0gYJ+hOrsBD5quqEEeGglKc1xF9CoTv/YKlIDm
         AXZmCFZHnEiCQ==
Date:   Mon, 14 Feb 2022 21:27:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net v2 1/1] openvswitch: Fix setting ipv6 fields causing
 hw csum failure
Message-ID: <20220214212708.7e69482a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214124851.14400-1-paulb@nvidia.com>
References: <20220214124851.14400-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 14:48:51 +0200 Paul Blakey wrote:
> Ipv6 ttl, label and tos fields are modified without first
> pulling/pushing the ipv6 header, which would have updated
> the hw csum (if available). This might cause csum validation
> when sending the packet to the stack, as can be seen in
> the trace below.
> 
> Fix this by updating skb->csum if available.

> Fixes: 3fdbd1ce11e5 ("openvswitch: add ipv6 'set' action")
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  Changelog:
>     v1->v2:
>       Replaced push pull rcsum checksum calc with actual checksum calc

Well, what I had in mind was an skb helper which would take skb, u32
new_val, u32 old_val, but this works, too.

Please fix the new sparse warnings tho, and..

> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 076774034bb9..3725801cb040 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -423,12 +423,44 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
>  	memcpy(addr, new_addr, sizeof(__be32[4]));
>  }
>  
> -static void set_ipv6_fl(struct ipv6hdr *nh, u32 fl, u32 mask)
> +static void set_ipv6_dsfield(struct sk_buff *skb, struct ipv6hdr *nh, __u8 ipv6_tclass, __u8 mask)
>  {
> +	__u8 old_ipv6_tclass = ipv6_get_dsfield(nh);

use normal u8, __u8 is for uAPI.

