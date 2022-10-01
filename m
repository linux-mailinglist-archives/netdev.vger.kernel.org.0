Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533A95F17AF
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 02:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiJAAzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 20:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJAAy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 20:54:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A4E2F01B;
        Fri, 30 Sep 2022 17:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92EC9B827A1;
        Sat,  1 Oct 2022 00:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A773AC433D6;
        Sat,  1 Oct 2022 00:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664585694;
        bh=o/Ev9gMwsPF3krUN9RG4ffs3+D3ve0KjtmBjCHaIChs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHKr5jJRh8dZmcthCHMQkPI7gwSvG8FD3SmcU4HrLLbvrBNkppUemBQOcFD9q4C9k
         616tzgVI5FOe3/9Owy6uRjRHpPruRXOr1CSAbv3gFHxj0UezFxjCWbsIr0ghCifHHV
         PsU6kGaKcaBm93yrnHnGqG8aW2Cud4gdo6SPSyMudECIR5LkgUfdf3MN0JP9WcGvXg
         MYoujwePJLub6u2KcmKHl4nQgWDFKYmYAsZ3bxW+SUrfyYYzNh+PfVQ99lGwQAxICe
         omttKelWJfTBE6s6nSmgU9tWyDlM9nHKp0eTINJMzNZBY6IKkaFhgO6TrQpbzty84B
         ZOr6+43JMeG/Q==
Date:   Fri, 30 Sep 2022 17:54:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v2 1/6] net: dcb: add new pcp selector to app
 object
Message-ID: <20220930175452.1937dadd@kernel.org>
In-Reply-To: <87leq1uiyc.fsf@nvidia.com>
References: <20220929185207.2183473-1-daniel.machon@microchip.com>
        <20220929185207.2183473-2-daniel.machon@microchip.com>
        <87leq1uiyc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Sep 2022 14:20:50 +0200 Petr Machata wrote:
> > @@ -1495,7 +1536,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
> >  		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
> >  			struct dcb_app *app_data;
> >
> > -			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
> > +			if (!dcbnl_app_attr_type_validate(nla_type(attr)))  
> 
> Oh no! It wasn't validating the DCB_ATTR_IEEE_APP_TABLE nest against a
> policy! Instead it was just skipping whatever is not DCB_ATTR_IEEE_APP.
> 
> So userspace was permitted to shove random crap down here, and it would
> just quietly be ignored. We can't start reinterpreting some of that crap
> as information. We also can't start bouncing it.

Are you saying that we can't start interpreting new attr types?

"Traditionally" netlink ignored new attr types so from that perspective
starting to interpret new types is pretty "run of the mill" for netlink.
IOW *_deprecated() parsing routines do not use NL_VALIDATE_MAXTYPE.

That does put netlink in a bit of a special category when it comes to
input validation, but really putting in a random but valid attr is much
harder than not initializing a struct member. Is there user space which
does that?

Sorry if I'm misinterpreting the situation.

> This needs to be done differently.
> 
> One API "hole" that I see is that payload with size < struct dcb_app
> gets bounced.
> 
> We can pack the new stuff into a smaller payload. The inner attribute
> would not be DCB_ATTR_DCB_APP, but say DCB_ATTR_DCB_PCP, which would
> imply the selector. The payload can be struct { u8 prio; u16 proto; }.
> This would have been bounced by the old UAPI, so we know no userspace
> makes use of that.
> 
> We can treat the output similarly.
