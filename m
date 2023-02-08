Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F138868EDD1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjBHLW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjBHLWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:22:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC01347EC7
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:21:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2119B81D42
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 11:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD80EC433D2;
        Wed,  8 Feb 2023 11:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675855287;
        bh=1R9AmkcQ6/Uqekti0Ux/nqUZaNj0C1VgtqNVfxm4SJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twqHT6LAZTg/86bOOFg7INy9SBw3H3r6PoeqeHHSsDkxlayNkKU1CixKJdispjQi/
         ZKIHQA42gMoPALoW6Ym+Ym4H0ysixbluBB/bxkhL+9Vpg/OQ70iZ70lzpyctsChE2D
         JTV5OadQa9kkib7tzo2AWY75ojKjmWYq0pi0Bn52FV1xoZD+cQu2Ug2oLorCoR/8In
         No6F8xHeyPQtEFjjxBXdWQhzSwbqR5Nv1OFGvejsWAcSFWJCcPtKAA+4cb852/MOX/
         Xd7yUODcqw659UhiSPrziU3L1GXaR6QZUuPGRFkuNBwHY2At74wuloVeIZi1oqYHvO
         k0dMN50TDZIYg==
Date:   Wed, 8 Feb 2023 13:21:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, Fei Qin <fei.qin@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH/RFC net-next 1/2] devlink: expose port function commands
 to assign VFs to multiple netdevs
Message-ID: <Y+OFspnA69XxCnpI@unreal>
References: <20230206153603.2801791-1-simon.horman@corigine.com>
 <20230206153603.2801791-2-simon.horman@corigine.com>
 <20230206184227.64d46170@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206184227.64d46170@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:42:27PM -0800, Jakub Kicinski wrote:
> On Mon,  6 Feb 2023 16:36:02 +0100 Simon Horman wrote:
> > +VF assignment setup
> > +---------------------------
> > +In some cases, NICs could have multiple physical ports per PF. Users can assign VFs to
> > +different ports.
> 
> Please make sure you run make htmldocs when changing docs,
> this will warn.
> 
> > +- Get count of VFs assigned to physical port::
> > +
> > +    $ devlink port show pci/0000:82:00.0/0
> > +    pci/0000:82:00.0/0: type eth netdev enp130s0np0 flavour physical port 0 splittable true lanes 4
> 
> Physical port has VFs? My knee jerk reaction is that allocating
> resources via devlink is fine but this seems to lean a bit into
> forwarding. How do other vendors do it? What's the mapping of VFs
> to ports?

I don't understand the meaning of VFs here. If we are talking about PCI
VFs, other vendors follow PCI spec "9.3.3.3.1 VF Enable" section, which
talks about having one bit to enable all VFs at once. All these VFs will
have separate netdevs.

> 
> What do you suggest should happen when user enables switchdev mode?
> 
