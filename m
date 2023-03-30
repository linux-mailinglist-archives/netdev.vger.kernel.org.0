Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236A86CF93B
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjC3Clp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjC3Cln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:41:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4223F5B89
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 465DDB8257B
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94674C4339B;
        Thu, 30 Mar 2023 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680144087;
        bh=uVvxJyuA/ATSzov4TOfsf51y15DdxIGHl9og7Xbub88=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rd0X7Awd3AZZo2qOy/Y+aIxMOlZCIOoUTV3VQklZj3jAdvMF38kAyDQp3RGmxc22l
         ZSVwyXkX4Q7C7jTuMrBJ7yggs3KoN+nko8IuWtlRYx51BtUQPL883fNkF1jMAVEumt
         LL59FGuye0cj5500RyIg+IhlGyRk5xV1UUKFpkdZSqdJFVNAs0YwENQRFBIHMJCCY5
         ASisvsj9w7hDIcuZwnYmxfyfFoBvXhhMJUcSl51HFHvZL9PL/vXn/KZsAALzPruQJ6
         nlrZLizqm7dD+ntUv6P49NIs/UpsirawL8eGnVNPl+7PAOMKE/uiC4l2xPrfekFTSQ
         l8hhh6XWUr96w==
Date:   Wed, 29 Mar 2023 19:41:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 2/2] nfp: separate the port's upper state with
 lower phy state
Message-ID: <20230329194126.268ffd61@kernel.org>
In-Reply-To: <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-3-louis.peens@corigine.com>
        <20230329122422.52f305f5@kernel.org>
        <DM6PR13MB37057AA65195F85CC16E34BCFC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 01:56:13 +0000 Yinjun Zhang wrote:
> On Wed, 29 Mar 2023 12:24:22 -0700, Jakub Kicinski wrote:
> > On Wed, 29 Mar 2023 16:45:48 +0200 Louis Peens wrote:  
> > > For nic application firmware, enable the ports' phy state at the
> > > beginning. And by default its state doesn't change in pace with
> > > the upper state, unless the ethtool private flag "link_state_detach"
> > > is turned off by:
> > >
> > >  ethtool --set-private-flags <netdev> link_state_detach off
> > >
> > > With this separation, we're able to keep the VF state up while
> > > bringing down the PF.  
> > 
> > This commit message is very confusing. Please rewrite it.  
> 
> How about
> "
> With this separation, the lower phy state of uplink port can be kept
> link-on no matter what the upper admin state is.

What is "upper", in this context? grep the networking code for upper,
is that what you mean?

> Thus the corresponding
> VFs can also link up and communicate with exterior through the uplink
> port.
> "

