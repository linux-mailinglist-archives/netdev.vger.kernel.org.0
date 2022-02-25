Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBF74C4D06
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbiBYR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiBYR5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:57:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0502823932E
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:56:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3C78B832F6
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 17:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1928C340E7;
        Fri, 25 Feb 2022 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645811807;
        bh=WnmozGoXeijHiI9l1Oy/60fdu0tHmecghS1OR6lSTGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AWMI2GKYVn/j6TN3iqyicoPhzMt220UzScN4IX8lQT3mqMX9YrSxTLyVOy5d59sar
         O59vNt9HpUX0Tug1yjSDklc3oGyLoEFAOVKw6GfKwmt+slCgvxOblCcUMn2GXzuNsz
         NSmYNwen4yNXPI8LvogGOdZDF654iklLlNWKH7RfOo7EzPACZ3UxDMrf6R1wPUZVfD
         ze0lUGy3ZtuWp8i3lcBpsFOFP/vJ9DNWAApfqjG7hUuo9EAKDSfzZF4Qvl3cCIQTcp
         3O2IErrkHE6xvQlUvdrCwYv/C8LFlUq0rHf4Kyc1mBKTqW2kgt1uwM1QgQCZF+k0Zi
         ywoH1WHyJ721w==
Date:   Fri, 25 Feb 2022 09:56:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>, <razor@blackwall.org>,
        <roopa@nvidia.com>, <dsahern@gmail.com>, <andrew@lunn.ch>,
        <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 06/14] net: dev: Add hardware stats support
Message-ID: <20220225095645.547a79f0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <874k4meuoj.fsf@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
        <20220224133335.599529-7-idosch@nvidia.com>
        <20220224222244.0dfadb8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8735k7fg53.fsf@nvidia.com>
        <20220225081212.4b1825f2@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <874k4meuoj.fsf@nvidia.com>
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

On Fri, 25 Feb 2022 18:00:11 +0100 Petr Machata wrote:
> > What I meant is take out all the link-level / PHY stuff, I don't think
> > any HW would be reporting these above the physical port. Basically when
> > you look at struct rtnl_link_stats64 we can remove everything starting
> > from and including collisions, right?  
> 
> My thinking is that stats64 is understood, e.g. formatting this in the
> iproute2 suite is just a function call away. I imagine this is similar
> in other userspace tools as well. There are benefits to just reusing
> what exists, despite not being optimal.
> 
> But yeah, those 120 trail bytes are very likely going to be zero.
> I can shave them if you feel strongly about it.

Yeah, if I'm counting right we're reusing like 38% of the fields, only.
We're better off with a new structure.
