Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7615FAE86
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJKIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJKIg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:36:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEDA7F10E
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:36:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78F1FB80C90
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 08:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64230C433C1;
        Tue, 11 Oct 2022 08:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665477385;
        bh=iXWh2FLBzFZ6pmHm06dYEW4esZbjpCMbgADUDWpyh9A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWZSfAnNQixOcKy7c3QMpglK0GBvwc8lMbm0As+GLob8RTSDexjZvDO2fAQ9op9f6
         /gPq78X6fPQUPQcpTcMHqx+GHXs5dXa9zRHAsV9Gj5NAKSDgZK9HCYzKbgm0+tDmJZ
         apL1Zzu3wo8gzBvLfxqc8WR32qmdDcOgBAiyNiNoKQkEJKDDEjDQg122WtlWVRCrbA
         kF3g21LLRcRwFr1VYx/nOClCkI+VwJS10mDW6/RjINRHruFr1SkgYuMcO26IR340iI
         yczhxcd+5Mmx+03ErPwfJjQ8yBDW2H/mZb8Y1NEsN2rUE4F6dmFQxPVBz/EBcdBgQ9
         /UiEbEySZKyJA==
Date:   Tue, 11 Oct 2022 11:36:20 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com,
        Huanhuan Wang <huanhuan.wang@corigine.com>,
        chengtian.liu@corigine.com
Subject: Re: [PATCH net-next v2 3/3] nfp: implement xfrm callbacks and expose
 ipsec offload feature to upper layer
Message-ID: <Y0UrBKpN92SstSt/@unreal>
References: <20220927102707.479199-1-simon.horman@corigine.com>
 <20220927102707.479199-4-simon.horman@corigine.com>
 <YzVWsOP1R/FGPYgF@unreal>
 <20221010071434.GB21559@nj-rack01-04.nji.corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010071434.GB21559@nj-rack01-04.nji.corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 03:14:34PM +0800, Yinjun Zhang wrote:
> On Thu, Sep 29, 2022 at 11:26:24AM +0300, Leon Romanovsky wrote:
> > On Tue, Sep 27, 2022 at 12:27:07PM +0200, Simon Horman wrote:
> > 
> > > +	mutex_lock(&ipd->lock);
> > > +
> > > +	if (ipd->sa_free_cnt == 0) {
> > > +		nn_err(nn, "No space for xfrm offload\n");
> > > +		err = -ENOSPC;
> > 
> > Why don't you return EOPNOTSUPP?
> > 
> 
> Here means no available sa. I think ENOSPC is more appropriate than
> EOPNOTSUPP, and it looks like xfrm will fall back to software mode
> when driver returns EOPNOTSUPP.

Yes, and it is exactly what is expected. If device for some reason
doesn't support crypto offload, SW path should be taken instead.

> 
> > > +static void xfrm_invalidate(struct nfp_net *nn, unsigned int saidx, int is_del)
> > > +{
> > > +	struct nfp_net_ipsec_data *ipd = nn->ipsec_data;
> > > +	struct nfp_net_ipsec_sa_data *sa_data;
> > > +	struct nfp_ipsec_cfg_mssg msg;
> > > +	int err;
> > > +
> > > +	sa_data = &ipd->sa_entries[saidx];
> > > +	if (!sa_data->invalidated) {
> > > +		err = nfp_ipsec_cfg_cmd_issue(nn, NFP_IPSEC_CFG_MSSG_INV_SA, saidx, &msg);
> > > +		if (err)
> > > +			nn_warn(nn, "Failed to invalidate SA in hardware\n");
> > > +		sa_data->invalidated = 1;
> > > +	} else if (is_del) {
> > > +		nn_warn(nn, "Unexpected invalidate state for offloaded saidx %d\n", saidx);
> > 
> > You definitely need to clean all these not-possible flows.
> > 
> 
> Do you mean clean those sa entries? We clean them by invalidating them.
> You can see `xfrm_invalidate` is called in `nfp_net_xfrm_del_state`.

No, I means that you can't call to invalidate with "Unexpected ..." state.
You should ensure that free/invalidate/e.t.c logic operates on valid SAs
only.

Thanks
