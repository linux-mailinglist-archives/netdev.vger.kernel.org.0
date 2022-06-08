Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B19F54239D
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357461AbiFHCqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388040AbiFHCjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AAE17ED3C
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 17:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1BE86177B
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 00:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0281C34114;
        Wed,  8 Jun 2022 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654647503;
        bh=JPst8MF1UxNkF8vN+tqCJssdV1C1Mq44XnyefYWXr2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PnaPmhArHl+LMYYra0do30IYWxP+Mt5T2Vl7q6QcaQB9116dZhypzaOxXDv4M04gh
         j6c7ldbR05rmsiiW50na6zPIIZfXmup6MyG9W1G6szEWqZe+L8U3ZqO7zfdFsioAWq
         GttVnC0ZhBKTAOcG20K5QZCgJ8VXff7e5frKQ/THp0Zs+mxrser1LKQxG4G+IlvJQW
         lBUuPF32ayhH56YaqU2fMwrdhdebJZqDUUkh15q386sKITkcz5wu/n2PZk1hmNxz6R
         O2x1F3xC24bGFPsgNazAuxvRvKov07A09RcJoTcrsl2FNVNPBk3AnZmUrqhzs0AdLR
         EqTYBONjg1BCg==
Date:   Tue, 7 Jun 2022 17:18:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net] ip_gre: test csum_start instead of transport header
Message-ID: <20220607171821.74bc4f87@kernel.org>
In-Reply-To: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
References: <20220606132107.3582565-1-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Jun 2022 09:21:07 -0400 Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> GRE with TUNNEL_CSUM will apply local checksum offload on
> CHECKSUM_PARTIAL packets.
> 
> ipgre_xmit must validate csum_start after an optional skb_pull,
> else lco_csum may trigger an overflow. The original check was
> 
> 	if (csum && skb_checksum_start(skb) < skb->data)
> 		return -EINVAL;
> 
> This had false positives when skb_checksum_start is undefined:
> when ip_summed is not CHECKSUM_PARTIAL. A discussed refinement
> was straightforward
> 
> 	if (csum && skb->ip_summed == CHECKSUM_PARTIAL &&
> 	    skb_checksum_start(skb) < skb->data)
> 		return -EINVAL;
> 
> But was eventually revised more thoroughly:
> - restrict the check to the only branch where needed, in an
>   uncommon GRE path that uses header_ops and calls skb_pull.
> - test skb_transport_header, which is set along with csum_start
>   in skb_partial_csum_set in the normal header_ops datapath.
> 
> Turns out skbs can arrive in this branch without the transport
> header set, e.g., through BPF redirection.
> 
> Revise the check back to check csum_start directly, and only if
> CHECKSUM_PARTIAL. Do leave the check in the updated location.
> Check field regardless of whether TUNNEL_CSUM is configured.
> 
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Link: https://lore.kernel.org/all/20210902193447.94039-2-willemdebruijn.kernel@gmail.com/T/#u
> Fixes: 8a0ed250f911 ("ip_gre: validate csum_start only on pull")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Missing a CC for Alex, adding now.
