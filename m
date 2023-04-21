Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B046EA437
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDUHBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDUHBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:01:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B819B2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:01:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E70C64E11
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ED9C433D2;
        Fri, 21 Apr 2023 07:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682060498;
        bh=WQiAfnXqkhpGaiexK3TsztxrFIXKWhECfXyR7hA/LUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H5FcjSIDakpxBNfSMec30r+vrRAIb6SxQTvBULl82VOmuvx4MKtCqbf1qePDX5oPh
         67y3OPkqShaQmBNqnb+6+Bu32pYWD3eAz0+Ex0BPf8n0Xe+ZATQu3Qu06rb5zxpfB0
         H2gqYnomoWO12LQOVgVL4xNZSCnJmoNTElDOnv1aHu9IeAcRX+JW8FRpDUNtDjRM7N
         wEKEsVDSQyd7B69Hlsl2GCOtk83drkzznlR5NQVRP6jLh5VhTr2g7Z+IVumxeKpkS7
         I3gjnOWtDHcDObhr2UdWKqQ0OpfVfhnpgD9Y1xiD9INUBoWtWnOeY2/jKXcXi9nH5c
         3lx5XR3QIVG7w==
Date:   Fri, 21 Apr 2023 09:01:34 +0200
From:   Simon Horman <horms@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] bonding: Always assign be16 value to vlan_proto
Message-ID: <ZEI0zpDyJtfogO7s@kernel.org>
References: <20230420-bonding-be-vlan-proto-v1-1-754399f51d01@kernel.org>
 <9836.1682020053@famine>
 <20230420202303.iecl2vnkbdm2qfs7@skbuf>
 <16322.1682025812@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16322.1682025812@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 02:23:32PM -0700, Jay Vosburgh wrote:
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> >On Thu, Apr 20, 2023 at 12:47:33PM -0700, Jay Vosburgh wrote:
> >> Simon Horman <horms@kernel.org> wrote:
> >> 
> >> >The type of the vlan_proto field is __be16.
> >> >And most users of the field use it as such.
> >> >
> >> >In the case of setting or testing the field for the
> >> >special VLAN_N_VID value, host byte order is used.
> >> >Which seems incorrect.
> >> >
> >> >Address this issue by converting VLAN_N_VID to __be16.
> >> >
> >> >I don't believe this is a bug because VLAN_N_VID in
> >> >both little-endian (and big-endian) byte order does
> >> >not conflict with any valid values (0 through VLAN_N_VID - 1)
> >> >in big-endian byte order.
> >> 
> >> 	Is that true for all cases, or am I just confused?  Doesn't VLAN
> >> ID 16 match VLAN_N_VID (which is 4096) if byte swapped?
> >> 
> >> 	I.e., on a little endian host, VLAN_N_VID is 0x1000 natively,
> >> and network byte order (big endian) of VLAN ID 16 is also 0x1000.
> >> 
> >> 	Either way, I think the change is fine; VLAN_N_VID is being used
> >> as a sentinel value here, so the only real requirement is that it not
> >> match an actual VLAN ID in network byte order.
> >> 
> >> 	-J
> >
> >In a strange twist of events, VLAN_N_VID is assigned as a sentinel value
> >to a variable which usually holds the output of vlan_dev_vlan_proto(),
> >or i.o.w. values like htons(ETH_P_8021Q), htons(ETH_P_8021AD). It is
> >certainly a confusion of types to assign VLAN_N_VID to it, but at least
> >it's not a valid VLAN protocol.
> >
> >To answer your question, tags->vlan_proto is never compared against a
> >VLAN ID.
> 
> 	Yah, looking again I see that now; I was checking the math on
> Simon's statement about "0 through VLAN_N_VID - 1".
> 
> 	So, I think the patch is correct, but the commit message should
> really explain the reality.  And, perhaps we should use 0 or 0xffff for
> the sentinel, since neither are valid Ethernet protocol IDs.

Hi Jay and Vladimir,

Thanks for your review.

Firstly, sorry for the distraction about the VLAN_N_VID math.  I agree it
was incorrect. I had an out by one bug in my thought process which was
about 0x0fff instead of 0x1000.

Secondly, sorry for missing the central issue that it is a bit weird
to use a VID related value as a sentinel for a protocol field.
I agree it would be best to chose a different value.

In reference to the list of EtherTypes [1]. I think 0 might be ok,
but perhaps not ideal as technically it means a value of 0 for the
IEEE802.3 Length Field (although perhaps it can never mean that in this
context).

OTOH, 0xffff, is 'reserved' ([1] references RFC1701 [2]),
so perhaps it is a good choice.

In any case, I'm open to suggestions.
I'll probably hold off until the v6.5 cycle before reposting,
unless -rc8 appears next week. I'd rather not rush this one
given that I seem to have already got it wrong once.

[1] https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml#ieee-802-numbers-1
[2] https://www.rfc-editor.org/rfc/rfc1701.html
