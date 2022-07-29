Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4B858507E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbiG2NJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbiG2NI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:08:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF701C56;
        Fri, 29 Jul 2022 06:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XV4FYkS/nsQW9JhqD1MLPoDv6thr9pzmU6vmVArakKA=; b=A+X10RUu2sgNy6OI75yTPLCpL4
        pdimq9m6r+Irwi35Ae5QGvmdLS6ff/m6GGKdMzcSpfRdAH8dhMIxQ4Zk7qSIenpTP10PCFngmHkzt
        AtBagkT7qH0v+R36jBsoAP0qwh+RZLenM7dnMBfgAM+Tjo3PeVfCm0+jwnmJU6F7fysI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oHPjL-00Bv17-Va; Fri, 29 Jul 2022 15:08:39 +0200
Date:   Fri, 29 Jul 2022 15:08:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Cc:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ronak.jain@xilinx.com" <ronak.jain@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "git@xilinx.com" <git@xilinx.com>, "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [PATCH net-next 2/2] net: macb: Add zynqmp SGMII dynamic
 configuration support
Message-ID: <YuPb141ykzLTWLbC@lunn.ch>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-3-git-send-email-radhey.shyam.pandey@amd.com>
 <Yt15J6fO5j9jxFxp@lunn.ch>
 <MN0PR12MB59537FD82D25E5B6BE17D1B6B7959@MN0PR12MB5953.namprd12.prod.outlook.com>
 <Yt7OqU9LXl4SDqYx@lunn.ch>
 <MN0PR12MB5953571B73BE19D01BCF12D4B7949@MN0PR12MB5953.namprd12.prod.outlook.com>
 <MN0PR12MB59535036A5EA7F7EE488FC56B7999@MN0PR12MB5953.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB59535036A5EA7F7EE488FC56B7999@MN0PR12MB5953.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > How robust is this? What if somebody specified a different power domain?
> > 
> > Some background - init_reset_optional() fn is implemented for three
> > platforms i.e., zynqmp, versal, MPFS.
> > 
> > zynqmp_pm_set_gem_config API expect first argument as GEM node id so,
> > power-domain DT property is passed to get node ID.
> > 
> > However, power-domain property is read only if underlying firmware
> > supports configuration of GEM secure space. It's only true for zynqmp SGMII
> > case and for zynqmp power domain is fixed.
> > In addition to it there is an error handling in power-domain property parsing.
> > Hope this answers the question.
> 
> Please let me know the implementation looks fine or needs any modification?

Given that explanation, it looks fine.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
