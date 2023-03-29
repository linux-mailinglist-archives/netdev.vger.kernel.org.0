Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43816CD922
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjC2MIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjC2MIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:08:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF7130FF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:08:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DCC6B822DD
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5530BC433EF;
        Wed, 29 Mar 2023 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680091720;
        bh=dvAtVFPSBMcvAe7MdB7RZivYYsuhsWS7nQzMfGFoNcA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hD8g2+fduYm4UbHckeypqrr7zodyEqtqg4Y0jk03MtSym7ZsGr28QWnGT81DAHHD8
         ON8dIOwNVKQ83Kre/5t/UCqaoYnq22b3db0I72d+vGhPfsWTrHbIga6HQKFlT7Rd/S
         PWdHdXyPbwc1+Efls+mx9ips2bRNYPjg05+ObU3rzti/mU0A5qbiKLdYAz3a+Ueolp
         Ht0B16rqNNnTmUUqvg6EhfKHxk+WoHrUeR/FgWnk2YfJzMc48r6tdwzdNurgiTIMMy
         PmKVUXFWdkq9dO70CoJ0o+Z/4OFnDAOgghYgEefecsi2IMvk1XOA6uqVr9seJ6Yuiv
         j7DlkONngy1nA==
Date:   Wed, 29 Mar 2023 15:08:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Junfeng Guo <junfeng.guo@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 3/4] ice: add profile conflict check for AVF FDIR
Message-ID: <20230329120836.GS831478@unreal>
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
 <20230328172035.3904953-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328172035.3904953-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:20:34AM -0700, Tony Nguyen wrote:
> From: Junfeng Guo <junfeng.guo@intel.com>
> 
> Add profile conflict check while adding some FDIR rules to avoid
> unexpected flow behavior, rules may have conflict including:
>         IPv4 <---> {IPv4_UDP, IPv4_TCP, IPv4_SCTP}
>         IPv6 <---> {IPv6_UDP, IPv6_TCP, IPv6_SCTP}
> 
> For example, when we create an FDIR rule for IPv4, this rule will work
> on packets including IPv4, IPv4_UDP, IPv4_TCP and IPv4_SCTP. But if we
> then create an FDIR rule for IPv4_UDP and then destroy it, the first
> FDIR rule for IPv4 cannot work on pkt IPv4_UDP then.
> 
> To prevent this unexpected behavior, we add restriction in software
> when creating FDIR rules by adding necessary profile conflict check.
> 
> Fixes: 1f7ea1cd6a37 ("ice: Enable FDIR Configure for AVF")
> Signed-off-by: Junfeng Guo <junfeng.guo@intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  .../ethernet/intel/ice/ice_virtchnl_fdir.c    | 73 +++++++++++++++++++
>  1 file changed, 73 insertions(+)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
