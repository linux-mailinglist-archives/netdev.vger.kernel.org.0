Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F97570A1E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 20:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiGKSsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 14:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKSsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 14:48:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10FE813E0E;
        Mon, 11 Jul 2022 11:48:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E411614C1;
        Mon, 11 Jul 2022 18:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A561BC341CA;
        Mon, 11 Jul 2022 18:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657565296;
        bh=X0wkjmHG3OfgyaFyrzn6qOP72SWpx1Vvzd2obV7bFCA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VtXHSR56wbUCDhG3/Wt0hmbYDaEQzAn7aVfYmCQFqBoxc6CjDehO4IJU58ylH6YJ4
         daiCXBOscKG/364xbpFnH/Xq3VOhPmB4MCOamRlYjAjksSBfQ1IhR8uqJ+T5HOheTR
         UNVG2R4BxL7kL9o8Iy6I9u9+6xb4o/s3VfGuD9ENRw/gDrOlLO1mHVWNzXUJq2y5l3
         8iQg0Oc+LSTsGLg7/PS/uXRRiXfQtrqexNsSbYfVe3gSTmPJrv6uGTBvX2rWDli7VF
         mHyxB6lGuYtIeMXGUEM0bSj2VlMVuF3kyWcV68YPM1h7ZDU1ZAw/REOA6MGXrtu/Wn
         lMWLfd6oFabpg==
Date:   Mon, 11 Jul 2022 11:48:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        ecree.xilinx@gmail.com, linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/2] sfc: Add EF100 BAR config support
Message-ID: <20220711114806.2724b349@kernel.org>
In-Reply-To: <Yswn7p+OWODbT7AR@gmail.com>
References: <165719918216.28149.7678451615870416505.stgit@palantir17.mph.net>
        <20220707155500.GA305857@bhelgaas>
        <Yswn7p+OWODbT7AR@gmail.com>
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

On Mon, 11 Jul 2022 14:38:54 +0100 Martin Habets wrote:
> > Normally drivers rely on the PCI Vendor and Device ID to learn the
> > number of BARs and their layouts.  I guess this series implies that
> > doesn't work on this device?  And the user needs to manually specify
> > what kind of device this is?  
> 
> When a new PCI device is added (like a VF) it always starts of with
> the register layout for an EF100 network device. This is hardcoded,
> i.e. it cannot be customised.
> The layout can be changed after bootup, and only after the sfc driver has
> bound to the device.
> The PCI Vendor and Device ID do not change when the layout is changed.
> 
> For vDPA specifically we return the Xilinx PCI Vendor and our device ID
> to the vDPA framework via struct vdpa_config_opts.

So it's switching between ethernet and vdpa? Isn't there a general
problem for configuring vdpa capabilities (net vs storage etc) and
shouldn't we seek to solve your BAR format switch in a similar fashion
rather than adding PCI device attrs, which I believe is not done for
anything vDPA-related?

> > I'm confused about how this is supposed to work.  What if the driver
> > is built-in and claims a device before the user can specify the
> > register layout?  
> 
> The bar_config file will only exist once the sfc driver has bound to
> the device. So in fact we count on that driver getting loaded.
> When a new value is written to bar_config it is the sfc driver that
> instructs the NIC to change the register layout.

When you say "driver bound" you mean the VF driver, right?

> > What if the user specifies the wrong layout and the
> > driver writes to the wrong registers?  
> 
> We have specific hardware and driver requirements for this sort of
> situation. For example, the register layouts must have some common
> registers (to ensure some compatibility).
> A layout that is too different will require a separate device ID.
> A driver that writes to the wrong register is a bug.
> 
> Maybe the name "bar_config" is causing most of the confusion here.
> Internally we also talk about "function profiles" or "personalities",
> but we thought such a name would be too vague.
