Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AD6BAB20
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjCOIuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbjCOIuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767CF5FE9B
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A021561C32
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABD4C433D2;
        Wed, 15 Mar 2023 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870205;
        bh=fgukv3n8xfj62642YKapebgijcy4zFCZnncbzsx+nBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SvljE9mnIN8oCeXWjgbatfudgEHuuW+gOItMYEiyyVYIGyIwmw9r78PoE0DYzywGb
         Lg4tETU+iaeN6XKb5JjfmgH+MThJviH+JReyaePzxGSLdCaOfThAm4Wuz08tgtZAy7
         2Kkv7ZZ8iv5C3E+76ASas02GljO4tJzXSIh4XrjKjNbZL7qhm7wJIHhT8G7rrOr6iQ
         nVlT2E34wgLfk9Q0p46tzPMKVAz7PDwp+lJ07kTuIZJxikTqO/CQkEZZYIaKW5ZzmE
         l3ZtKsXWw5p/rvL/5kGIi3S7kpi3KL5WC2nr8VycnSS4DPAL/2ptbRYnT4aq/+sNBv
         7s/GyPU+Hoaag==
Date:   Wed, 15 Mar 2023 10:50:00 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 2/3] iavf: fix non-tunneled IPv6 UDP packet type and
 hashing
Message-ID: <20230315085000.GP36557@unreal>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
 <20230314174423.1048526-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314174423.1048526-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 10:44:22AM -0700, Tony Nguyen wrote:
> From: Alexander Lobakin <aleksander.lobakin@intel.com>
> 
> Currently, IAVF's decode_rx_desc_ptype() correctly reports payload type
> of L4 for IPv4 UDP packets and IPv{4,6} TCP, but only L3 for IPv6 UDP.
> Originally, i40e, ice and iavf were affected.
> Commit 73df8c9e3e3d ("i40e: Correct UDP packet header for non_tunnel-ipv6")
> fixed that in i40e, then
> commit 638a0c8c8861 ("ice: fix incorrect payload indicator on PTYPE")
> fixed that for ice.
> IPv6 UDP is L4 obviously. Fix it and make iavf report correct L4 hash
> type for such packets, so that the stack won't calculate it on CPU when
> needs it.
> 
> Fixes: 206812b5fccb ("i40e/i40evf: i40e implementation for skb_set_hash")
> Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
