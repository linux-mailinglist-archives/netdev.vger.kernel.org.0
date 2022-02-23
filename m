Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7804C0AB6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbiBWDvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiBWDvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:51:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EAC65432
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 19:50:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB9C36178D
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 03:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4344C340E7;
        Wed, 23 Feb 2022 03:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645588246;
        bh=FG8lmForCqGlEieSpOkxiGiAcwQuxcaXlYZX+WE/+/c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aAXsn0IYnj9BHOjEfFXnMxgm2mZn7EyJQnPv+3NQmmegjNiiQMghsTBrFei5BGdxV
         hS5F6f9PSG8p07nNuX2BZ4mD1zaREBbBfxJFe75GFDuK+Fpk/1susUMtmbjE6/xFiE
         9jMpzgbUJa8bKwNhC2WMlWji0J54Byn+i+P47897HdhblKQiyluSr650lvSrc2yFh4
         TLRHoethKDVXHF1O5DAdJv6p5YFo0HpfHNyVi/IuY5vHRKQNnge4hndBW3DrD/qCYP
         GM8tCN26IzdMvJ00d49gZ0nDIFgbvJVfjmBE5S+TQWYzCLk3ZNmJWArMOErS1/HJ7x
         wZr9TQ4+UDLiQ==
Date:   Tue, 22 Feb 2022 19:50:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <stephen@networkplumber.org>, <nikolay@cumulusnetworks.com>,
        <idosch@nvidia.com>, <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: Re: [PATCH net-next v2 07/12] rtnetlink: add new rtm tunnel api for
 tunnel id filtering
Message-ID: <20220222195044.06313f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <920ce92c-46e2-3b8a-4d0a-40daaf049b64@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
        <20220222025230.2119189-8-roopa@nvidia.com>
        <20220222172630.44bba0d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <920ce92c-46e2-3b8a-4d0a-40daaf049b64@nvidia.com>
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

On Tue, 22 Feb 2022 18:49:03 -0800 Roopa Prabhu wrote:
> On 2/22/22 5:26 PM, Jakub Kicinski wrote:
> > Why create new RTM_ commands instead of using changelink?
> >
> > I thought we had to add special commands for bridge because
> > if the target of the command is not a bridge device but possibly
> > a bridge port, which could be anything. That's not the case here.
> >
> > Is it only about the convenience of add/del vs changelink where
> > we'd potentially have to pass and parse the entire vni list each time?  
> 
> yes, exactly. that's the reason. My first internal version used 
> changelink and soon realized it was too limiting.
> 
> especially notifications. Its too heavy to notify the full vni list 
> every-time.
> 
> IIRC bridge also went through a similar transition. Now bridge also has 
> RTM_*VLAN commands.

Makes sense. I wasn't quite sure if this isn't over-engineering
 - do deployments really use VxLAN devs with many VNIs?

> Couldn't think of another way than adding a new msg. Tried to keep the 
> name generic for use by potentially other dst/collect metadata devices

Ack, I don't have any better ideas either :)
