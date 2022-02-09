Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FF14AF543
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235860AbiBIPbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235830AbiBIPbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:31:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF6FC0613CA;
        Wed,  9 Feb 2022 07:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1CE4612BC;
        Wed,  9 Feb 2022 15:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB57CC340EE;
        Wed,  9 Feb 2022 15:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644420670;
        bh=SUAzX1bOQ4ppezYoKe/edVyDT5rR66sLPDNtd0vmzQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ei3v4Nz0xNmANAZoJ8XBAoFp6tWEQUNoN3RIrLSzNfbCB40fI1q9bvFb55lPDKgrX
         zYcEMoGPppx6L9uOm+kX+C+fLjFtgrO4van2gNG32G44/vvwAYpJdkAnfRv2RIXmJC
         x3HMrQgjuYdS5bXIxrNbTeBjchSVsUz/TOxJGLN+W1ZPEDF3UFJeMXzT1aLSMGaW1P
         bnkDcFJ4hWGewGeFNM0Opbfn6vuoojcXE1Pmx682m8S1iy0fd2p8kZLljDZ9g3+kT4
         LaRYlli1lz9ibTZrIbv3KtzXWWfCOjzI8rwC2il7Q+Ix1AEHdOfN2d+5JYKSfThOo0
         sO3i4KW3Dl7sw==
Date:   Wed, 9 Feb 2022 07:31:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     yajun.deng@linux.dev
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dev: introduce netdev_drop_inc()
Message-ID: <20220209073108.7f82306f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e95e51e3cdf771650ae64d5295e1178a@linux.dev>
References: <20220208195306.05a1760f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220208162729.41b62ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20220208064318.1075849-1-yajun.deng@linux.dev>
        <753bb02bfa8c2cf5c08c63c31f193f90@linux.dev>
        <e95e51e3cdf771650ae64d5295e1178a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Feb 2022 07:27:44 +0000 yajun.deng@linux.dev wrote:
> February 9, 2022 11:53 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:
> > IIRC perf support filters, I think with -f? We can't add a tracepoint
> > for every combination of attributes.  
> 
> Yes, we can use a command like this: " sudo perf record -g -a -e skb:kfree_skb --filter 'protocol == 0x0800' ",
> However, only the filter is defined in kfree_skb tracepoint are available.
> 
> The purpose of this patch is record {rx_dropped, tx_dropped, rx_nohandler} in struct net_device, to distinguish 
> with struct net_device_stats. 
> 
> We don't have any tracepoint records {rx_dropped, tx_dropped, rx_nohandler} in struct net_device now. 
> Can we add {rx_dropped, tx_dropped, rx_nohandler} in kfree_skb tracepoint?  like this:
> 
>         TP_STRUCT__entry(
>                 __field(void *,         skbaddr)
>                 __field(void *,         location)
>                 __field(unsigned short, protocol)
>                 __field(enum skb_drop_reason,   reason)
>                 __field(unsigned long,  rx_dropped)
>                 __field(unsigned long,  tx_dropped)
>                 __field(unsigned long,  rx_nohandler)
> 
>         ),
> 
>         TP_fast_assign(
>                 __entry->skbaddr = skb;
>                 __entry->location = location;
>                 __entry->protocol = ntohs(skb->protocol);
>                 __entry->reason = reason;
>                 __entry->rx_dropped   = (unsigned long)atomic_long_read(&skb->dev->rx_dropped);
>                 __entry->tx_dropped   = (unsigned long)atomic_long_read(&skb->dev->tx_dropped);
>                 __entry->rx_nohandler = (unsigned long)atomic_long_read(&skb->dev->rx_nohandler);
>         ),
> 
> If so, we can record this but not add a tracepoint.

You can use bpftrace to dereference extra information.
