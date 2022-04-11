Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53244FC549
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbiDKTve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 15:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349727AbiDKTv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 15:51:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A951900E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 12:49:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5E3DB81896
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 19:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415F5C385A3;
        Mon, 11 Apr 2022 19:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649706551;
        bh=gZxB0KdeZCuJ/fKDoX2iVL6LT+jLWDmJDtAdRJgkmVs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OoL0z4lSmg4RpqE5Ukiax339HSlBW6XQ1JxlZRa/WcHBzg6Jhlc/0sCqLh+pQV6Qi
         BzqMpLDb4aVwZgR+Ix9vZNvdDiqWVBEjk4WkQHjn1HZtnpwU3nnfDgpCcGqNkumVXH
         zc5c9WD3RcNV8YGW54eDW22L595OowxGXBDu4Y5qC+Lv63E3bzHEjPDa/Yk+54dfDA
         6B5RUNofiNpMdS2y46kEBZ+AvUoR9TbDKYfnX22a2k40Ilti5S+xL58oPmHmXnxhaQ
         kkuCRtdsHoWZjm6U9WgWFw66dCSONJL+/8RzzxUqgD75l62fzalznS8qUPxGMk53ml
         EofReIvm1bBwQ==
Date:   Mon, 11 Apr 2022 12:49:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        idosch@idosch.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering
 support
Message-ID: <20220411124910.772dc7a0@kernel.org>
In-Reply-To: <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
References: <20220411172934.1813604-1-razor@blackwall.org>
        <0d08b6ce-53bb-bffa-4f04-ede9bfc8ab63@nvidia.com>
        <c46ac324-34a2-ca0c-7c8c-35dc9c1aa0ab@blackwall.org>
        <92f578b7-347e-22c7-be83-cae4dce101f6@blackwall.org>
        <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
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

On Mon, 11 Apr 2022 12:22:24 -0700 Roopa Prabhu wrote:
> >> I thought about that option, but I didn't like overloading delneigh like that.
> >> del currently requires a mac address and we need to either signal the device supports> a null mac, or we should push that verification to ndo_fdb_del users. Also we'll have  
> > that's the only thing, overloading delneigh with a flush-behaviour (multi-del or whatever)
> > would require to push the mac check to ndo_fdb_del implementers
> >
> > I don't mind going that road if others agree that we should do it through delneigh
> > + a bit/option to signal flush, instead of a new rtm type.
> >  
> >> attributes which are flush-specific and will work only when flushing as opposed to when
> >> deleting a specific mac, so handling them in the different cases can become a pain.  
> > scratch the specific attributes, those can be adapted for both cases
> >  
> >> MDBs will need DELMDB to be modified in a similar way.
> >>
> >> IMO a separate flush op is cleaner, but I don't have a strong preference.
> >> This can very easily be adapted to delneigh with just a bit more mechanical changes
> >> if the mac check is pushed to the ndo implementers.
> >>
> >> FLUSHNEIGH can easily work for neighs, just need another address family rtnl_register
> >> that implements it, the new ndo is just for PF_BRIDGE. :)  
> 
> all great points. My only reason to explore RTM_DELNEIGH is to see if we 
> can find a recipe to support similar bulk deletes of other objects 
> handled via rtm msgs in the future. Plus, it allows you to maintain 
> symmetry between flush requests and object delete notification msg types.
> 
> Lets see if there are other opinions.

I'd vote for reusing RTM_DELNEIGH, but that's purely based on
intuition, I don't know this code. I'd also lean towards core
creating struct net_bridge_fdb_flush_desc rather than piping
raw netlink attrs thru. Lastly feels like fdb ops should find 
a new home rather than ndos, but that's largely unrelated..
