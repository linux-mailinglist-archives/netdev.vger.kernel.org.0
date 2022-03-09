Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 243004D3468
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 17:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbiCIQZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 11:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiCIQVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 11:21:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967C4145E2F;
        Wed,  9 Mar 2022 08:17:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B22B81E05;
        Wed,  9 Mar 2022 16:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF76C340E8;
        Wed,  9 Mar 2022 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842653;
        bh=QAmRrDrdiT5Y2sWjZcvxHoImW4DfIKnXr2i8gdVrJF0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ojpq7M9CgybSnjoHDlCiu5Zm3kRb8WKLe7rXNPmS55fSiI4Xz4kpnuOgt01JX+Zam
         bOjToLlrttkXkmRhHt5Jto5V14XcOZRBjt6PkLzCNBmSTB/VG8APfqVK73aW63ZzyJ
         BLfwEmBJb1W/WvIr5NusMC7gqUe+doFtFuFShFVrlSV1ol7EsYwgTeveTa6FV+16d0
         TbVTfG1TJwjWjG0Wce+UqdtQvNBmpjcEplrD14ixAlU+W27EuZfJjE8kvwTqr1eF7M
         9ZseG3/gLaaXnm3m+HV7tYzcM2hmIv3Let6M3ZFUou4IKS/ziqF31uu2502nebCUFm
         9lzu5tqhhmBLw==
Date:   Wed, 9 Mar 2022 08:17:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Roi Dayan <roid@nvidia.com>,
        Johannes Berg <johannes@sipsolutions.net>, dev@openvswitch.org,
        Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Message-ID: <20220309081732.1eafee91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9b6e166e-fd10-4242-1ad9-a6ab1ddb0c95@ovn.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
        <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
        <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
        <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
        <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
        <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
        <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
        <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
        <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
        <20220308081731.3588b495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6f0feae8-ecb4-ca1d-133e-1013ce9e8b4f@ovn.org>
        <20220308121617.3f638793@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <81250230-a845-b03f-6600-b716c02f5137@nvidia.com>
        <9b6e166e-fd10-4242-1ad9-a6ab1ddb0c95@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 14:43:07 +0100 Ilya Maximets wrote:
> >> It's a bit of an uncharted territory, hard to say what's right.
> >> It may be a little easier to code up the rejection if we have
> >> the types defined (which I think we need to do in
> >> __parse_flow_nlattrs()? seems OvS does its own nla parsing?)  
> 
> Ack.  And, yes, __parse_flow_nlattrs() seems to be the right spot.
> OVS has lots of nested attributes with some special treatment in a
> few cases and dependency tracking, AFAICT, so it parses attributes
> on it's own.  Is there a better way?

Looks like OvS has extra requirements like attributes can't be
duplicated and zeroed out attrs are ignored. I don't think generic
parsers can do that today, although the former seems like a useful
addition.

A problem for another time.

> >> Johannes, any preference?
> >
> > so why not again just flat enum without ifdefs and without values
> > commented out? even if we leave values in comments like above it doesn't
> > mean the userspace won't use them by mistake and send to the kernel.
> > but the kernel will probably ignore as not being used and at least
> > there won't be a conflict again even if by mistake.. and it's easiest
> > to read.  
> 
> OK.  Seems like we have some votes and a reason (explicit reject) to have
> them defined.  This will also make current user space and kernel definitions
> equal.  Let me put together a patch and we'll continue the discussion there.

Thanks!
