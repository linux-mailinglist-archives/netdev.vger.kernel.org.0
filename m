Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092B553999E
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348384AbiEaWmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346543AbiEaWmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:42:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5584E2494D
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 15:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE33E61455
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 22:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149FBC385A9;
        Tue, 31 May 2022 22:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654036920;
        bh=QhT5juI7EqHeP3aenNq6dvHIfW1V6Qz3IQeJ8sJg9Zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S6gSfnmB8s4nhVaNnn2qjxmmvOHBEk/bchmDwob+w+x79atN36h2tN6YarxsPtfgH
         lx+3FWXOXPlzM60hA5yhxct8K/AroyFY78egivH6t+xKCxcYZvpc8JDHdRAGU5Ob4k
         LSlDgX9m1BxdQlLIoP6QgzdSn5eKvwBnLvhn7SXBy4fWpJFTV/SqNflXq/YTrH2rTn
         Z48vfRkxyUfdNAPt3LwJ31m0Ggg2AzHpNX6KxGRpMVRjkK1VeKhflGAGYztO+0zUXg
         Z09N0NdxLEEl6U+bwQhvrNZk+tIgU+xCJXbv7Al2+jRd3w5EfTOr6VOCBoBWG1ErJh
         ynzula92tKGIw==
Date:   Tue, 31 May 2022 15:41:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220531154159.5dbf9d37@kernel.org>
In-Reply-To: <YpZt0mRaeZqrp4gU@nanopsycho>
References: <YpB9cwqcSAMslKLu@nanopsycho>
        <20220527171038.52363749@kernel.org>
        <YpHmrdCmiRagdxvt@nanopsycho>
        <20220528120253.5200f80f@kernel.org>
        <YpM7dWye/i15DBHF@nanopsycho>
        <20220530125408.3a9cb8ed@kernel.org>
        <YpW/n3Nh8fIYOEe+@nanopsycho>
        <20220531080555.29b6ec6b@kernel.org>
        <YpY5iKHR073DNF7D@nanopsycho>
        <20220531090852.2b10c344@kernel.org>
        <YpZt0mRaeZqrp4gU@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 21:34:42 +0200 Jiri Pirko wrote:
> And again, for the record, I strongly believe that a separate dl
> instance for this does not make any sense at all :/ I wonder why you
> still think it does.

For purely software reuse reasons. I think the line cards will require
a lot of the same attributes as the full devlink instance, so making
them a subobject which can have all the same attributes is poor SW arch.
Think about it from OOP perspective, you'd definitely factor all that
stuff out to an abstract class. We can't do that in netlink but whatever
just make it a full dl instance and describe the link between the two.

Most NIC vendors (everyone excluding Netronome?) decided that devlink
instance is equivalent to a bus device which IIUC it was not supposed
to be. It was supposed to be the whole ASIC. If we're okay to stretch
the definition of a dl instance to be "any independently controllable
unit of HW" for NICs then IDK why we can't make a line card a dl
instance.

Are you afraid of hiding dependencies?
