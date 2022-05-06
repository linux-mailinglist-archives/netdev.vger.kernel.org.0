Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2931E51CF6E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 05:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388550AbiEFDcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 23:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388539AbiEFDcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 23:32:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B15644C0;
        Thu,  5 May 2022 20:28:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 219B5B832C4;
        Fri,  6 May 2022 03:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685DEC385AC;
        Fri,  6 May 2022 03:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651807698;
        bh=/Busav/MercVn3U7qos3BeCdpeFW+y8S+aaQ9UEgLOg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=jsBG26qh+s213Ai58L/c76nzSly7WUrMn1CW1KN9i9Ky51OURpsDA8Sue2D1CJ9Sq
         D8CjECh08aUOh24sOOD33Rszb5HqzS3oCrMHt7J9QZ5KK7ThbTIN8fWjSxQGvAxN6Q
         wdSWi/aFNzQ4Fsh/B+YFmhpQTvm3gFaA7Eu/Kznm3H/n3c1g3DKxwrUj8NDa4bbkUr
         dTaDkNqV1drIVgG1E8DYViBhnnKaMxvcP6cr9gNLtlfs6p8gtWeqONXKRInUx3IuES
         matYNYW+DmzRSrK9oWJeilQ6ahPS2ea5Mt7yGypTxX+HYFgfWH2LN7Lpta8o7j2xya
         hf/isN0EBWRXQ==
Message-ID: <366d529e-6149-423a-e012-dbfd9c41baac@kernel.org>
Date:   Thu, 5 May 2022 20:28:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [net PATCH] ipv4: drop dst in multicast routing path
Content-Language: en-US
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, tgraf@suug.ch,
        lokesh.dhoundiyal@alliedtelesis.co.nz
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220505020017.3111846-1-chris.packham@alliedtelesis.co.nz>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220505020017.3111846-1-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/22 7:00 PM, Chris Packham wrote:
> From: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
> 
> kmemleak reports the following when routing multicast traffic over an
> ipsec tunnel.
> 
> Kmemleak output:
> unreferenced object 0x8000000044bebb00 (size 256):
>   comm "softirq", pid 0, jiffies 4294985356 (age 126.810s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 80 00 00 00 05 13 74 80  ..............t.
>     80 00 00 00 04 9b bf f9 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<00000000f83947e0>] __kmalloc+0x1e8/0x300
>     [<00000000b7ed8dca>] metadata_dst_alloc+0x24/0x58
>     [<0000000081d32c20>] __ipgre_rcv+0x100/0x2b8
>     [<00000000824f6cf1>] gre_rcv+0x178/0x540
>     [<00000000ccd4e162>] gre_rcv+0x7c/0xd8
>     [<00000000c024b148>] ip_protocol_deliver_rcu+0x124/0x350
>     [<000000006a483377>] ip_local_deliver_finish+0x54/0x68
>     [<00000000d9271b3a>] ip_local_deliver+0x128/0x168
>     [<00000000bd4968ae>] xfrm_trans_reinject+0xb8/0xf8
>     [<0000000071672a19>] tasklet_action_common.isra.16+0xc4/0x1b0
>     [<0000000062e9c336>] __do_softirq+0x1fc/0x3e0
>     [<00000000013d7914>] irq_exit+0xc4/0xe0
>     [<00000000a4d73e90>] plat_irq_dispatch+0x7c/0x108
>     [<000000000751eb8e>] handle_int+0x16c/0x178
>     [<000000001668023b>] _raw_spin_unlock_irqrestore+0x1c/0x28
> 
> The metadata dst is leaked when ip_route_input_mc() updates the dst for
> the skb. Commit f38a9eb1f77b ("dst: Metadata destinations") correctly
> handled dropping the dst in ip_route_input_slow() but missed the
> multicast case which is handled by ip_route_input_mc(). Drop the dst in
> ip_route_input_mc() avoiding the leak.
> 
> Fixes: f38a9eb1f77b ("dst: Metadata destinations")
> Signed-off-by: Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     We started seeing this leak in our scenario after commit c0d59da79534
>     ("ip_gre: Make none-tun-dst gre tunnel store tunnel info as metadat_dst
>     in recv") but there may be other paths that hit the leak so I've set the
>     fixes tag as f38a9eb1f77b ("dst: Metadata destinations").
> 
>  net/ipv4/route.c | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


