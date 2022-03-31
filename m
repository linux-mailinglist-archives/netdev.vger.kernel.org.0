Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65D4ED4F7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 09:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbiCaHrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 03:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiCaHrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 03:47:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687FA1E8CF6;
        Thu, 31 Mar 2022 00:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F1AB81FDC;
        Thu, 31 Mar 2022 07:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198C6C340F0;
        Thu, 31 Mar 2022 07:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648712714;
        bh=8iqEELlQfidAWxPbSPnuzLLq+C/vvjNyUEt2aMmN8aA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gzrLLIkO73a3ko/CKONc+3yRFmcbMWKdX01oTL6GkxvzXvbt7Ikj0iXk8lEA9BJ9U
         LQAjztQEIt9D+vj2nLVrVKYtT37xj0oGe3c16FBMJyfKDSiSHOBE/VPCvLYRb8r+yn
         71coC207ai6tdIH0HT63mVXsp9afiYsSVU49mdjG42m9qbihUg5NbdktqOktrP6ApX
         nQyLCiBNvPy9DpbkXosk2yEK5udJk4QaYJU4b1EJlnh9Cy0AwBkKt39+CwAXxSUHPM
         8BWw6Nt9ayKjUawJPVWn3FFnqoCs40RZ+CEWNrnOFlLwgKl4pRK9egqcrvVLq8dYAx
         R9OD+wbRYe8fA==
Date:   Thu, 31 Mar 2022 10:45:10 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Shannon Nelson <shannon.nelson@oracle.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net] ixgbe: ensure IPsec VF<->PF compatibility
Message-ID: <YkVcBgac41VjNBd7@unreal>
References: <3702fad8a016170947da5f3c521a9251cf0f4a22.1648637865.git.leonro@nvidia.com>
 <b201a3ed-5698-4e91-adc9-34c938e43668@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b201a3ed-5698-4e91-adc9-34c938e43668@pensando.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 09:13:21AM -0700, Shannon Nelson wrote:
> On 3/30/22 4:01 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The VF driver can forward any IPsec flags and such makes the function
> > is not extendable and prone to backward/forward incompatibility.
> > 
> > If new software runs on VF, it won't know that PF configured something
> > completely different as it "knows" only XFRM_OFFLOAD_INBOUND flag.
> > 
> > Fixes: eda0333ac293 ("ixgbe: add VF IPsec management")
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> > There is no simple fix for this VF/PF incompatibility as long as FW
> > doesn't filter/decline unsupported options when convey mailbox from VF
> > to PF.
> > ---
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c | 4 +++-
> >   1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> > index e596e1a9fc75..236f244e3f65 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
> > @@ -903,7 +903,9 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
> >   	/* Tx IPsec offload doesn't seem to work on this
> >   	 * device, so block these requests for now.
> >   	 */
> > -	if (!(sam->flags & XFRM_OFFLOAD_INBOUND)) {
> > +	sam->flags = sam->flags & ~XFRM_OFFLOAD_IPV6;
> > +	if (!(sam->flags & XFRM_OFFLOAD_INBOUND) ||
> > +	    sam->flags & ~XFRM_OFFLOAD_INBOUND) {
> 
> So after stripping the IPV6 flag, you're checking to be sure that INBOUND is
> the only flag enabled, right?
> Could you use
>     if (sam->flags != XFRM_OFFLOAD_INBOUND) {
> instead?

Sure, I'll send new version soon.

Thanks

> 
> sln
> 
> >   		err = -EOPNOTSUPP;
> >   		goto err_out;
> >   	}
> 
