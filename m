Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AAD50DF20
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiDYLrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbiDYLra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:47:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F84713CD3;
        Mon, 25 Apr 2022 04:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10092B815FB;
        Mon, 25 Apr 2022 11:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AFBC385A7;
        Mon, 25 Apr 2022 11:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650887062;
        bh=OY5n8Tf6FRAIGU2dwPUI6YZQVZF9hrq2Cr1EDl5MgqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dcjfg1vVXfHd4xFonI1m+L+oWisypUpzk5TLXBrtfxjq8P1mufmssIZ/KyhzrHJhl
         Sc1YyVwp84N7nK7z9whVE9lnnSzc6Fq4kDiby6nrvXtITlp/aTiwwejG8FhUkoR5HE
         M+LMyCSXj/uag/MCnYOGcGn9mVAHwso90ZAlBPBM=
Date:   Mon, 25 Apr 2022 13:44:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Mark Mielke <mark.mielke@gmail.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Antti Antinoja <antti@fennosys.fi>
Subject: Re: [ovs-dev] [PATCH] openvswitch: Ensure nf_ct_put is not called
 with null pointer
Message-ID: <YmaJlOS1YtPaq0EC@kroah.com>
References: <20220409094036.20051-1-mark.mielke@gmail.com>
 <YlL6uN9WDPtFri0p@strlen.de>
 <590d44a1-ca27-c171-de87-fe57fc07dff5@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590d44a1-ca27-c171-de87-fe57fc07dff5@ovn.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 12:36:54PM +0200, Ilya Maximets wrote:
> On 4/10/22 17:41, Florian Westphal wrote:
> > Mark Mielke <mark.mielke@gmail.com> wrote:
> >> A recent commit replaced calls to nf_conntrack_put() with calls
> >> to nf_ct_put(). nf_conntrack_put() permitted the caller to pass
> >> null without side effects, while nf_ct_put() performs WARN_ON()
> >> and proceeds to try and de-reference the pointer. ovs-vswitchd
> >> triggers the warning on startup:
> >>
> >> [   22.178881] WARNING: CPU: 69 PID: 2157 at include/net/netfilter/nf_conntrack.h:176 __ovs_ct_lookup+0x4e2/0x6a0 [openvswitch]
> >> ...
> >> [   22.213573] Call Trace:
> >> [   22.214318]  <TASK>
> >> [   22.215064]  ovs_ct_execute+0x49c/0x7f0 [openvswitch]
> >> ...
> >> Cc: stable@vger.kernel.org
> >> Fixes: 408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")
> > 
> > Actually, no.  As Pablo Neira just pointed out to me Upstream kernel is fine.
> > The preceeding commit made nf_ct_out() a noop when ct is NULL.
> 
> Hi, Florian.
> 
> There is a problem on 5.15 longterm tree where the offending commit
> got backported, but the previous one was not, so it triggers an issue
> while loading the openvswitch module.
> 
> To be more clear, v5.15.35 contains the following commit:
>   408bdcfce8df ("net: prefer nf_ct_put instead of nf_conntrack_put")
> backported as commit 72dd9e61fa319bc44020c2d365275fc8f6799bff, but
> it doesn't have the previous one:
>   6ae7989c9af0 ("netfilter: conntrack: avoid useless indirection during conntrack destruction")
> that adds the NULL pointer check to the nf_ct_put().
> 
> Either 6ae7989c9af0 should be backported to 5.15 or 72dd9e61fa31
> reverted on that tree.

I've backported the needed commit now, thanks.

greg k-h
