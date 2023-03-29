Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69B36CD91A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjC2MHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjC2MHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD03A4C3B;
        Wed, 29 Mar 2023 05:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C69961CE6;
        Wed, 29 Mar 2023 12:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E07C433D2;
        Wed, 29 Mar 2023 12:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680091609;
        bh=KoCRrZdqWqbYBk9rH55JCrfMS8Ge4UtvpbUnC+we0mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F522+9zlj70x0f1QAoWxdLXjyYpewXusBjcA09CnjRNDMcCrsu8pCpJ1kWVM5jc7i
         9eBWQykT+4N9onR5r3dUrnQTNfqRvC1Ztzlhfz7Cbtj6pQSZb6Afq0W3mchWKMxQGY
         fJuZph6zGh0gdYlQuTUFLMBQikfGVIh53GAN60Xu6O24PTSjp0jy/MPUjX/aUa36k0
         PTqtkNo29oAFhyHWnqGDkQMEh8XxNgy683oQQtYYCAJxWLHUjKxm32SltsM6hAXX/x
         YnnH+ECmmcVBRcecyysMxV0NfZrgAZIvWo7B3QVf6p889Upg5bsfq5rCWUC+tc1cu3
         XSz6uGZZrTQjQ==
Date:   Wed, 29 Mar 2023 15:06:44 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Piotr Raczynski <piotr.raczynski@intel.com>
Subject: Re: [PATCH net 1/4] ice: fix W=1 headers mismatch
Message-ID: <20230329120644.GP831478@unreal>
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
 <20230328172035.3904953-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328172035.3904953-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:20:32AM -0700, Tony Nguyen wrote:
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> 
> make modules W=1 returns:
> .../ice/ice_txrx_lib.c:448: warning: Function parameter or member 'first_idx' not described in 'ice_finalize_xdp_rx'
> .../ice/ice_txrx.c:948: warning: Function parameter or member 'ntc' not described in 'ice_get_rx_buf'
> .../ice/ice_txrx.c:1038: warning: Excess function parameter 'rx_buf' description in 'ice_construct_skb'
> 
> Fix these warnings by adding and deleting the deviant arguments.
> 
> Fixes: 2fba7dc5157b ("ice: Add support for XDP multi-buffer on Rx side")
> Fixes: d7956d81f150 ("ice: Pull out next_to_clean bump out of ice_put_rx_buf()")
> CC: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
