Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2996DBF7F
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 12:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDIKlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 06:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDIKlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 06:41:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7DA4692
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 03:41:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F033E60B3C
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 10:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F2CC433EF;
        Sun,  9 Apr 2023 10:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681036859;
        bh=2RJVcO5SskZnIJtxfSItu7apn74vrFXPIo6OOXEbo0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H3BoJRMVp1Tf8CWV3bcdXhJlPiIyzt4YS1SfQm9f+Oy9M+5661K6xJ1jqiQC167HN
         /x7uHRpudgAikvbBrVrWZvW/T6jkhVfAI1hGsClBKN7VzgDzAZj4EeDJIYoAa/cE8r
         JE9B27l7etqBeTnjZcG3FQRjuQK1U6ppmNExEMc4WyEQVF+ORjsdqly4GlRCWWlj0q
         XKDlPu/yESW+sLlpBqizJtf5+kUZoI6WJv8gQ7uI2U2gB3RM1teg8igevEiDP0AHNc
         UnF+wyY/4pwemze+Sy0mT+FUOW47qxy2ZsO42HWvhXREh9gyF165HYV3R3cDspGuDC
         JvsyBVO0gPV0Q==
Date:   Sun, 9 Apr 2023 13:40:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Ahmed Zaki <ahmed.zaki@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net v2 2/2] iavf: remove active_cvlans and active_svlans
 bitmaps
Message-ID: <20230409104055.GP14869@unreal>
References: <20230407210730.3046149-1-anthony.l.nguyen@intel.com>
 <20230407210730.3046149-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407210730.3046149-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 07, 2023 at 02:07:30PM -0700, Tony Nguyen wrote:
> From: Ahmed Zaki <ahmed.zaki@intel.com>
> 
> The VLAN filters info is currently being held in a list and 2 bitmaps
> (active_cvlans and active_svlans). We are experiencing some racing where
> data is not in sync in the list and bitmaps. For example, the VLAN is
> initially added to the list but only when the PF replies, it is added to
> the bitmap. If a user adds many V2 VLANS before the PF responds:
> 
>     while [ $((i++)) ]
>         ip l add l eth0 name eth0.$i type vlan id $i
> 
> we might end up with more VLAN list entries than the designated limit.
> Also, The "ip link show" will show more links added than the PF limit.
> 
> On the other and, the bitmaps are only used to check the number of VLAN
> filters and to re-enable the filters when the interface goes from DOWN to
> UP.
> 
> This patch gets rid of the bitmaps and uses the list only. To do that,
> the states of the VLAN filter are modified:
> 1 - IAVF_VLAN_REMOVE: the entry needs to be totally removed after informing
>   the PF. This is the "ip link del eth0.$i" path.
> 2 - IAVF_VLAN_DISABLE: (new) the netdev went down. The filter needs to be
>   removed from the PF and then marked INACTIVE.
> 3 - IAVF_VLAN_INACTIVE: (new) no PF filter exists, but the user did not
>   delete the VLAN.
> 
> Fixes: 48ccc43ecf10 ("iavf: Add support VIRTCHNL_VF_OFFLOAD_VLAN_V2 during netdev config")
> Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf.h        |  7 +--
>  drivers/net/ethernet/intel/iavf/iavf_main.c   | 40 +++++++----------
>  .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 45 ++++++++++---------
>  3 files changed, 45 insertions(+), 47 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
