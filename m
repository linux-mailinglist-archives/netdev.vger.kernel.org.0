Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C134EBD53
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 11:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244628AbiC3JMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 05:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244627AbiC3JMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 05:12:14 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8DF1DBABA;
        Wed, 30 Mar 2022 02:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648631428; x=1680167428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oVBDcKhQPIannLiyreJRo3QEwR2EwOYqp0Enn3LLlPU=;
  b=Yr1ZIyRQv0GdOE2Bd2km1ts9AU+eBiPh/HTyO7JrJ7bOzgCTNw9+tqza
   QjqQ/LKwAes0s+EGDbM5xIerfhsp0+IIAo2et+J3A4M0GMCh9lUcgBjNP
   pOXAFf3WaJE27akbXyandOOh8AM+/NGmQcKOpKUrZ9mjBCzLYMGZc9Gty
   jVCzGvX8rtjCg+7GrXGHmk9V1ZpFFJL+cND9D3fvn0q4iP73LktSEPN8+
   azLLSEL5qqNPajLqxar5lLxVwb62T7nRG5mx7I/mZSFfcoJawl66xr5Mi
   b3IfHsqyKYDtCJRN/tV14IwEzL9vo0WCBxyDvZKt5shuvn7jaFU8Tx0gC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10301"; a="258323052"
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="258323052"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2022 02:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,222,1643702400"; 
   d="scan'208";a="787940080"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 30 Mar 2022 02:10:08 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 22U9A6qw001631;
        Wed, 30 Mar 2022 10:10:06 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 net-next 5/5] ice: switch: convert packet template match code to rodata
Date:   Wed, 30 Mar 2022 11:07:34 +0200
Message-Id: <20220330090734.2725099-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <PH0PR11MB5782637EA9771D3ED4E56012FD1E9@PH0PR11MB5782.namprd11.prod.outlook.com>
References: <20220321105954.843154-1-alexandr.lobakin@intel.com> <20220321105954.843154-6-alexandr.lobakin@intel.com> <PH0PR11MB5782637EA9771D3ED4E56012FD1E9@PH0PR11MB5782.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>
Date: Tue, 29 Mar 2022 15:12:44 +0000

> Hi Alex,
> 
> > -----Original Message-----
> > From: Lobakin, Alexandr <alexandr.lobakin@intel.com>
> > Sent: poniedzialek, 21 marca 2022 12:00
> > To: intel-wired-lan@lists.osuosl.org
> > Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; Michal Swiatkowski
> > <michal.swiatkowski@linux.intel.com>; Drewek, Wojciech <wojciech.drewek@intel.com>; Marcin Szycik
> > <marcin.szycik@linux.intel.com>; Szapar-Mudlaw, Martyna <martyna.szapar-mudlaw@intel.com>; David S. Miller
> > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: [PATCH v4 net-next 5/5] ice: switch: convert packet template match code to rodata
> >
> > Trade text size for rodata size and replace tons of nested if-elses
> > to the const mask match based structs. The almost entire
> > ice_find_dummy_packet() now becomes just one plain while-increment
> > loop. The order in ice_dummy_pkt_profiles[] should be same with the
> > if-elses order previously, as masks become less and less strict
> > through the array to follow the original code flow.
> > Apart from removing 80 locs of 4-level if-elses, it brings a solid
> > text size optimization:
> >
> > add/remove: 0/1 grow/shrink: 1/1 up/down: 2/-1058 (-1056)
> > Function                                     old     new   delta
> > ice_fill_adv_dummy_packet                    289     291      +2
> > ice_adv_add_update_vsi_list                  201       -    -201
> > ice_add_adv_rule                            2950    2093    -857
> > Total: Before=414512, After=413456, chg -0.25%
> > add/remove: 53/52 grow/shrink: 0/0 up/down: 4660/-3988 (672)
> > RO Data                                      old     new   delta
> > ice_dummy_pkt_profiles                         -     672    +672
> > Total: Before=37895, After=38567, chg +1.77%
> >
> > Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Tested-by: Marcin Szycik <marcin.szycik@linux.intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_switch.c | 215 ++++++++++----------
> >  1 file changed, 108 insertions(+), 107 deletions(-)

--- 8< ---

> > +	ICE_PKT_PROFILE(vlan_udp, ICE_PKT_INNER_UDP | ICE_PKT_VLAN),
> > +	ICE_PKT_PROFILE(udp, ICE_PKT_INNER_UDP),
> > +	ICE_PKT_PROFILE(vlan_tcp_ipv6, ICE_PKT_INNER_IPV6 | ICE_PKT_VLAN),
> > +	ICE_PKT_PROFILE(tcp_ipv6, ICE_PKT_INNER_IPV6),
> 
> I think that in both "vlan_tcp_ipv6" and "tcp_ipv6" we should use ICE_PKT_OUTER_IPV6 instead
> of ICE_PKT_INNER_IPV6. We are not dealing with tunnels in those cases so inner addresses are 
> incorrect here.

Oh, some copy'n'paste braino indeed.
I'll send a fixup to Tony in a moment.

> 
> Thanks,
> Wojtek

Great catch, thanks for noticing!

> 
> > +	ICE_PKT_PROFILE(vlan_tcp, ICE_PKT_VLAN),
> > +	ICE_PKT_PROFILE(tcp, 0),
> > +};

--- 8< ---

> > --
> > 2.35.1

Al
