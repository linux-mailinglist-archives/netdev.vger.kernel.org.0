Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A45251DD5E
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 18:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357859AbiEFQRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 12:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443610AbiEFQR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 12:17:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5886FA3F;
        Fri,  6 May 2022 09:13:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC7B8CE377B;
        Fri,  6 May 2022 16:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B578EC385A9;
        Fri,  6 May 2022 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651853604;
        bh=RNXYPpzzqTC2kkQ/NsqO9QLdya4gsEDpth7e/HPVT+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LT4wRNGj/d9pk/wbLYfrZDYgHSM0i1N7zd6BMTvTZ1ta0NhbLRdJsG7Qu0WV4TPAR
         6wLXugpRfuV2N7fxJFJj8VxNEmXmmFfWe2DMGVa85SOpxQMMsp6Z6dPdFOUJ/J4rFP
         U/FuaDF/jo8D9gWOoj3DIomtcrU3enEv1ndNvNWfN8V9ba4kp34ek25GcrksW1BeKZ
         byd4+8KA2RD1yjz/T109mx2Qih/XKiMmiEtJdewHdqGwdWzPEtRoCss6XMVjHuQ46d
         TIBqgHNkDyyQFMn8xkyuHnoSxo30HwSJNJkpbyqk7xWMhrHVj69bbhG40RIj9ozUds
         9+kMDmkypfgpA==
Date:   Fri, 6 May 2022 09:13:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] drivers, ixgbe: show VF statistics
Message-ID: <20220506091322.1be7ee6e@kernel.org>
In-Reply-To: <20220506064440.57940-1-mheyne@amazon.de>
References: <20220504201632.2a41a3b9@kernel.org>
        <20220506064440.57940-1-mheyne@amazon.de>
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

On Fri, 6 May 2022 06:44:40 +0000 Maximilian Heyne wrote:
> On 2022-05-04T20:16:32-07:00   Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > On Tue, 3 May 2022 15:00:17 +0000 Maximilian Heyne wrote:  
> > > +		for (i = 0; i < adapter->num_vfs; i++) {
> > > +			ethtool_sprintf(&p, "VF %u Rx Packets", i);
> > > +			ethtool_sprintf(&p, "VF %u Rx Bytes", i);
> > > +			ethtool_sprintf(&p, "VF %u Tx Packets", i);
> > > +			ethtool_sprintf(&p, "VF %u Tx Bytes", i);
> > > +			ethtool_sprintf(&p, "VF %u MC Packets", i);
> > > +		}  
> > 
> > Please drop the ethtool stats. We've been trying to avoid duplicating
> > the same stats in ethtool and iproute2 for a while now.
> 
> I can see the point that standard metrics should only be reported via the
> iproute2 interface. However, in this special case this patch was
> intended to converge the out-of-tree driver with the in-tree version.
> These missing stats were breaking our userspace. If we now switch
> solely to iproute2 based statistics both driver versions would
> diverge even more. So depending on where a user gets the ixgbe driver
> from, they have to work-around.
> 
> I can change the patch as requested, but it will contradict the inital
> intention. At least Intel should then port this change to the
> external driver as well. Let's get a statement from them.

Ack, but we really want people to move towards using standard stats.

Can you change the user space to first try reading the stats via
iproute2/rtnetlink? And fallback to random ethtool strings if not
available? That way it will work with any driver implementing the
standard API. Long term that'll make everyone's life easier.

Out-of-tree code cannot be an argument upstream, otherwise we'd
completely lose control over our APIs. Vendors could ship whatever
in their out of tree repo and then force us to accept it upstream.

It's disappointing to see the vendor letting the uAPI of the out of
tree driver diverge from upstream, especially a driver this mature.
