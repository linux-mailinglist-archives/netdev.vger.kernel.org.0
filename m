Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3BE6CF9DB
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjC3D62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjC3D60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:58:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08B110A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:58:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49AD461ED2
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56762C433D2;
        Thu, 30 Mar 2023 03:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680148704;
        bh=QcyJGithp2yLIazCp1BTXMRLKjHyP0ZL6MZWaFSxtIw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gVYNariDaQvTUjOx0an7vNpRhi4MudfZvLKY0pu1tniltB7kx25vfKOEoH94ETokk
         5/YgCD7MjM7ROSxXq/jRGj2mQ6BQ+pYSpR6eJyqGsR2lctY/srF25AXOy0HxX013HA
         nblC4JhUuMRvqkNYpFSY0oFnETBGP0uOU0BYDEogSmox9qaeYEAobbKVpd1JWrWvvy
         bz099L0JpcKy7BJLqgALxCtM1H6/Emm0Tob4btpyUHU3EWmd3pyxgtlfRK05G7CBSO
         OoMGsLj9rG5CztfdhdI0zN0DHLMMg6hTg+00KDwTfJ1H4Wz1tt8sCjT+IPMFBHGC6F
         kMxyITAABDAaw==
Date:   Wed, 29 Mar 2023 20:58:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Message-ID: <20230329205823.6737512b@kernel.org>
In-Reply-To: <DM6PR13MB37050D1FEE2A6C13A68C9325FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
        <20230329122227.1d662169@kernel.org>
        <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329193831.2eb48e3c@kernel.org>
        <DM6PR13MB3705DBC0A077D7BC80929AA8FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20230329201029.0fff8d9d@kernel.org>
        <DM6PR13MB37050D1FEE2A6C13A68C9325FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
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

On Thu, 30 Mar 2023 03:27:56 +0000 Yinjun Zhang wrote:
> > > Yes, phys_port_name is still there. But some users prefer to use dev_port.
> > > I don't add this new attr, it's already existed since
> > > 3f85944fe207 ("net: Add sysfs file for port number").
> > > I just make the attr's value correct.  
> > 
> > You're using a different ID than phys_port_name, as far as I can tell :(
> > When the port is not split will id == label, always?  
> 
> You got the point. We create netdevs according to the port sequence in
> eth_table from management firmware. I think M-FW will make sure
> the sequence matches the port label id.

Alright, then, with an improved commit message this patch should 
be fine.
