Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2313255F551
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 06:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiF2Ejs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 00:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiF2Ejr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 00:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EA79FDD
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 21:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F04D611B4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 04:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9279EC34114;
        Wed, 29 Jun 2022 04:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656477584;
        bh=ToYVgHxUr2q1MypuuAGuqsYxH7HBrPqNKx+bYOmEhGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bWtYWzH8HeicbyY/C9SAoXhsNzZA8O8//neTmPfJCjq+Dih126wTa9ttJaGM/Snic
         8vSXl+jc4M9sb4MGgB6d4ThcTgXvO0EC/FwE5DBvJpdFwdViqKWHnQ/qhYRdhnD/ap
         XoPUvAbRX4WDVdMeEX3GBUoRyFPYPZD5bcCDaBKWz7+ZI0e4kGsQD1fmMfB2JUUMR9
         zaYxEcTd75xKDAYfNnPNn7y7Qr3mRj/c1LjlkKOjk8yD+BFoXBM/IkHta7pN4u9vtu
         x8s2T9H7LLxd2mx47AXKByGAzZQbnTpHPpAZAJtWlMa2eQYm2ml7jSYjD2rsy/H7mU
         hgnhdRWqZCQJw==
Date:   Tue, 28 Jun 2022 21:39:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Szycik <marcin.szycik@linux.intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, xiyou.wangcong@gmail.com,
        jesse.brandeburg@intel.com, gustavoars@kernel.org,
        baowen.zheng@corigine.com, boris.sukholitko@broadcom.com,
        edumazet@google.com, jhs@mojatatu.com, jiri@resnulli.us,
        kurt@linutronix.de, pablo@netfilter.org, pabeni@redhat.com,
        paulb@nvidia.com, simon.horman@corigine.com,
        komachi.yoshiki@gmail.com, zhangkaiheb@126.com,
        intel-wired-lan@lists.osuosl.org,
        michal.swiatkowski@linux.intel.com, wojciech.drewek@intel.com,
        alexandr.lobakin@intel.com
Subject: Re: [RFC PATCH net-next v2 0/4] ice: PPPoE offload support
Message-ID: <20220628213942.06210e78@kernel.org>
In-Reply-To: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
References: <20220628112918.11296-1-marcin.szycik@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 13:29:14 +0200 Marcin Szycik wrote:
> Add support for dissecting PPPoE and PPP-specific fields in flow dissector:
> PPPoE session id and PPP protocol type. Add support for those fields in
> tc-flower and support offloading PPPoE. Finally, add support for hardware
> offload of PPPoE packets in switchdev mode in ice driver.
> 
> Example filter:
> tc filter add dev $PF1 ingress protocol ppp_ses prio 1 flower pppoe_sid \
>     1234 ppp_proto ip skip_sw action mirred egress redirect dev $VF1_PR
> 
> Changes in iproute2 are required to use the new fields (will be submitted
> soon).
> 
> ICE COMMS DDP package is required to create a filter in ice.
> 
> Note: currently matching on vlan + PPPoE fields is not supported. Patch [0]
> will add this feature.

Please make sure to CC Guillaume Nault <gnault@redhat.com> 
and PPP folks from MAINTAINERS.
