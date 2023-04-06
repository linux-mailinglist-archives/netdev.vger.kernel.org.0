Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6F626D8C30
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjDFA7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjDFA7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:59:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8743959E0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2874E62951
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0ABC433EF;
        Thu,  6 Apr 2023 00:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680742749;
        bh=3LYisg0qyvWhRB/SrCXEzY9m99mQ6FZocWh+/nhxvnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZjZJjrwjiEcXmoVJE1WHZtRcIH91V3oayyKkVRbw46kZGPQaYclqGUb+yPu4JiH62
         maOmwtuCb1PeTqADA+AASxeqx9ab20sxtSo85lR9YumMIJL58i9S7xiuV1F8AN9/b3
         ddMXkEGGV5YzJ7FNIFZQa+eBOOFNxIN/kHomCjL/DNNRfu+Bau9HeDAjdiJeVoZcpL
         zZeasR3tdmbjkm5WrEt4rbdeTs8yjwerSXp9xkW/BoMn2pCMOG1TeY66svq1CI6ovW
         inuUHR8lseXHEOSoryFiSkUxaqye3o0h8obYnXK9Le0PEJhYi5BbSeTwkpyr1YmAnZ
         P96LPGgc75PjQ==
Date:   Wed, 5 Apr 2023 17:59:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmed Zaki <ahmed.zaki@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 1/2] iavf: refactor VLAN filter states
Message-ID: <20230405175908.2d3b504f@kernel.org>
In-Reply-To: <99053387-16ff-9ed0-ef12-7bcbc7a7af2e@intel.com>
References: <20230404172523.451026-1-anthony.l.nguyen@intel.com>
        <20230404172523.451026-2-anthony.l.nguyen@intel.com>
        <20230405171542.3bba2cc8@kernel.org>
        <99053387-16ff-9ed0-ef12-7bcbc7a7af2e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 18:50:55 -0600 Ahmed Zaki wrote:
> On 2023-04-05 18:15, Jakub Kicinski wrote:
> > On Tue,  4 Apr 2023 10:25:21 -0700 Tony Nguyen wrote:  
> >> +	__IAVF_VLAN_INVALID,
> >> +	__IAVF_VLAN_ADD,	/* filter needs to be added */
> >> +	__IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
> >> +	__IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
> >> +	__IAVF_VLAN_REMOVE,	/* filter needs to be removed */  
> > Why the leading underscores?  
> 
> Just following the convention. iavf_tc_state_t and 
> iavf_cloud_filter_state_t have these underscores. Same for iavf_state_t.

What is the convention, tho?  Differently put what is the thing
that would be defined with the same names but without the underscores?

My intuition is that we prefix bit numbers with __, 
then the mask (1 << __BIT_NO) does not have a prefix.

But these are not used as bits anywhere, in fact you're going away 
from bits...
