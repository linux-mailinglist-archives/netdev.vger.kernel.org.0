Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543AD532FE8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 19:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbiEXR54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 13:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiEXR5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 13:57:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059403A71A;
        Tue, 24 May 2022 10:57:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52011B818BF;
        Tue, 24 May 2022 17:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF54C34100;
        Tue, 24 May 2022 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653415071;
        bh=eg0N2/yPxi9Pc0epjBxRy7XA62HE3hr1H9ejUyHsHqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mJ+iGIDjTKWVblTbASJ7D3SEyARQlYYTdBRt5pC239+EAFIaWuGMlXS3dGkGcRhEu
         O+HzwEW/4y3TYiRdeCWzs6F60mBU+eimORD/rdX/7FBWZmT/oSaWLn/11huNxv89q0
         q6mEUsN7CQLDiAPlzGmO+aqM/XJ1OutysvdtKFKp6lDo2pUWDsceE6y+uwxTkKt9kb
         QYIiudnMESlxCbtc0nMPcoyOMtPNNCbD8n7CxloC7RvbOGubHSkm+v4eMxzVtwYg1K
         44ZP+qP81aYQDjVgcv9kv/zkleLLlXvu/9iCJ3h2Pkvnzz+HVl8MuI3CcpcOY6vVRy
         209S+jFuFAe4Q==
Date:   Tue, 24 May 2022 10:57:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Olivier Matz <olivier.matz@6wind.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, intel-wired-lan@osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH net v2 0/2] ixgbe: fix promiscuous mode on VF
Message-ID: <20220524105749.6690938f@kernel.org>
In-Reply-To: <YoyLUEk9n1uXHscH@platinum>
References: <20220406095252.22338-1-olivier.matz@6wind.com>
        <YmaLWN0aGIKCzkHP@platinum>
        <YoyLUEk9n1uXHscH@platinum>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 May 2022 09:37:52 +0200 Olivier Matz wrote:
> On Mon, Apr 25, 2022 at 01:51:53PM +0200, Olivier Matz wrote:
> > On Wed, Apr 06, 2022 at 11:52:50AM +0200, Olivier Matz wrote:  
> > > These 2 patches fix issues related to the promiscuous mode on VF.
> > > 
> > > Comments are welcome,
> > > Olivier
> > > 
> > > Cc: stable@vger.kernel.org
> > > Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > > 
> > > Changes since v1:
> > > - resend with CC intel-wired-lan
> > > - remove CC Hiroshi Shimamoto (address does not exist anymore)
> > > 
> > > Olivier Matz (2):
> > >   ixgbe: fix bcast packets Rx on VF after promisc removal
> > >   ixgbe: fix unexpected VLAN Rx in promisc mode on VF
> > > 
> > >  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)  
> > 
> > Any feedback about this patchset?
> > Comments are welcome.  
> 
> I didn't get feedback for this patchset until now. Am I doing things
> correctly? Am I targeting the appropriate mailing lists and people?
> 
> Please let me know if I missed something.

You are doing this correctly.. adding a couple more Intel folks.
