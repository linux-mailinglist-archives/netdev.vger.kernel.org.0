Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750144EC8CA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348412AbiC3Pxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344935AbiC3Pxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:53:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCC5DBC;
        Wed, 30 Mar 2022 08:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B0D0B81D7C;
        Wed, 30 Mar 2022 15:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7001EC340EC;
        Wed, 30 Mar 2022 15:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648655516;
        bh=1pUS2wJLudc1jkoub3g8WBHIEAC+pseXQcvY3pZfMu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Am+WCxZTX2ITKAVP1o3qsr1gOdGMuaYiyHkH/+EeJjkLJMeHxAGQjWSYSmKc1pcKC
         4SOCgd+UMk5FsYlLEu+tu3mg47i11olIyeGVD9pvutsC6gjIrFX9olST43xxIAu1qU
         Hc62eLt3TXXNEagEoDSBjwTjg++wOKoA+wrDBXyK1llsJjD5E+QCCUeySXEov7u4MM
         s7XONWYwwKb1GwB5ytvtdcT6Q6znOaTj7ERLF2P8m3baOlOi68j0oHOkEvzV5/bNgL
         CvZWHhZRHwJG9HFnmojGDwQ5DPqx3fbVYne3oKRmKZHLVktVGOTnWqx4b2BLST7h7V
         jz0t7rEqBEVjg==
Date:   Wed, 30 Mar 2022 08:51:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Message-ID: <20220330085154.34440715@kernel.org>
In-Reply-To: <c1ec0612-063b-dbfa-e10a-986786178c93@linux.ibm.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
        <20220329175421.4a6325d9@kernel.org>
        <d2e45c4a-ed34-10d3-58cd-01b1c19bd004@blackwall.org>
        <c1ec0612-063b-dbfa-e10a-986786178c93@linux.ibm.com>
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

On Wed, 30 Mar 2022 13:14:12 +0200 Alexandra Winter wrote:
> >> This patch in no way addresses (2). But then, again, if we put 
> >> a macvlan on top of a bridge master it will shotgun its GARPS all 
> >> the same. So it's not like veth would be special in that regard.
> >>
> >> Nik, what am I missing?
> > 
> > If we're talking about macvlan -> bridge -> bond then the bond flap's
> > notify peers shouldn't reach the macvlan.

Hm, right. I'm missing a step in my understanding. As you say bridge
does not seem to be re-broadcasting the event to its master. So how
does Alexandra catch this kind of an event? :S

	case NETDEV_NOTIFY_PEERS:
		/* propagate to peer of a bridge attached veth */
		if (netif_is_bridge_master(dev)) {  

IIUC bond will notify with dev == bond netdev. Where is the event with
dev == br generated?

> > Generally broadcast traffic
> > is quite expensive for the bridge, I have patches that improve on the
> > technical side (consider ports only for the same bcast domain), but you also
> > wouldn't want unnecessary bcast packets being sent around. :)
> > There are setups with tens of bond devices and propagating that to all would be
> > very expensive, but most of all unnecessary. It would also hurt setups with
> > a lot of vlan devices on the bridge. There are setups with hundreds of vlans
> > and hundreds of macvlans on top, propagating it up would send it to all of
> > them and that wouldn't scale at all, these mostly have IP addresses too.

Ack.

> > Perhaps we can enable propagation on a per-port or per-bridge basis, then we
> > can avoid these walks. That is, make it opt-in.

Maybe opt-out? But assuming the event is only generated on
active/backup switch over - when would it be okay to ignore
the notification?

> >>> It also seems difficult to avoid re-bouncing the notifier.  
> >>
> >> syzbot will make short work of this patch, I think the potential
> >> for infinite loops has to be addressed somehow. IIUC this is the 
> >> first instance of forwarding those notifiers to a peer rather
> >> than within a upper <> lower device hierarchy which is a DAG.  
> 
> My concern was about the Hangbin's alternative proposal to notify all
> bridge ports. I hope in my porposal I was able to avoid infinite loops.

Possibly I'm confused as to where the notification for bridge master
gets sent..
