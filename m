Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D845A7CFB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiHaMNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiHaMND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:13:03 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC5FD1E2E
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 05:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661947982; x=1693483982;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zxpSWiTAZR6ZAvdqfxXlOFs3pXGCsF/GCbCTJHi8LQk=;
  b=ACDyTaau+DD7aIBZeToEuEeUL8gthXhwN8TxwUwLihymn7qtF16/Xf7y
   D4kNEA6vx13wfi4QhSuntQEIz4jFZ09oWFU8s8M73UX5MmJkburIavFEm
   dH0vwhTkZrTK3aq6wmwYaLZvqPpA6wCwdZdKaoTlvbYj+/qWxrsMlLzo0
   TKlAaEjvk6ryRzjT1bAKc3goz2lN+ba5+iacXZar0zXVxHsYoLcMXICql
   CnK1LG+7JnoolQcAXB6vHOANU5koqmHNrbSYtPHfHnIf3wOKvenAUhFQm
   /EQ+VWjAl9uE8foZehLxTuWSJVwznSzshXFROm55F7MyIlL+pZogUdtga
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="294172478"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="294172478"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 05:13:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="641850711"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 05:12:56 -0700
Date:   Wed, 31 Aug 2022 05:16:05 -0400
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, marcin.szycik@linux.intel.com,
        kurt@linutronix.de, boris.sukholitko@broadcom.com,
        vladbu@nvidia.com, komachi.yoshiki@gmail.com, paulb@nvidia.com,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        simon.horman@corigine.com, pablo@netfilter.org,
        maksym.glubokiy@plvision.eu, intel-wired-lan@lists.osuosl.org,
        jchapman@katalix.com, gnault@redhat.com
Subject: Re: [RFC PATCH net-next v2 5/5] ice: Add L2TPv3 hardware offload
 support
Message-ID: <Yw8m1Zp+StyBCah9@localhost.localdomain>
References: <20220829094412.554018-1-wojciech.drewek@intel.com>
 <20220829094412.554018-6-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829094412.554018-6-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 11:44:12AM +0200, Wojciech Drewek wrote:
> From: Marcin Szycik <marcin.szycik@linux.intel.com>
> 
> Add support for offloading packets based on L2TPv3 session id in switchdev
> mode.
> 
> Example filter:
> tc filter add dev $PF1 ingress prio 1 protocol ip flower ip_proto l2tp \
>     l2tpv3_sid 1234 skip_sw action mirred egress redirect dev $VF1_PR
> 
> Changes in iproute2 are required to be able to specify l2tpv3_sid.
> 
> ICE COMMS DDP package is required to create a filter as it contains L2TPv3
> profiles.
> 

<snip>

ice part looks fine, thanks.
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
