Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558B966D57C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 05:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235509AbjAQE4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 23:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbjAQE4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 23:56:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351021E9E0;
        Mon, 16 Jan 2023 20:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D903AB810F4;
        Tue, 17 Jan 2023 04:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF547C43396;
        Tue, 17 Jan 2023 04:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673931387;
        bh=T4OPRIPsX71kgN869TP6EvCW0dSoUQicBXmXDQ7B2jI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MPOaae+jNdgHyqwQFvK5Iuc8QHYD86CBcJ6CEHGUXVZSOLS3DWvRnGPT25lvAtP6t
         cuny42hhWOGd8mx1Ozkbh7c3kruW9wFAc3HxwctOgYVCx2KPWGkJ18uUVTxt9Rydxc
         jhg9iPOmDZU769/ZqNlp2Q9nRP6G2ixLft70jaOVxFTzWjFAeDn3vx2dDI6BNiB7lm
         vjE7fphL9hehHLcIM83S+0mh4ysxkDvzInml5/AJvVWbFPh2PI9e0kAopSaRuYdTDO
         juYsP0jqwGog1FBeWDkygwVy9DymWgvuVZARNhUPu54CPaMgL2W24MPDyMbKnOwuYo
         FR+yx57bTCfEQ==
Date:   Mon, 16 Jan 2023 20:56:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        michael.chan@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH net-next v7 1/8] bnxt_en: Add auxiliary driver support
Message-ID: <20230116205625.394596cc@kernel.org>
In-Reply-To: <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
        <20230112202939.19562-2-ajit.khaparde@broadcom.com>
        <20230113221042.5d24bdde@kernel.org>
        <CACZ4nhuKo-h_dcSGuzAm4vJJuuxmnVo8jYO2scCxfqtktbCjfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Jan 2023 12:39:09 -0800 Ajit Khaparde wrote:
> > > +static void bnxt_aux_dev_release(struct device *dev)
> > > +{
> > > +     struct bnxt_aux_dev *bnxt_adev =
> > > +             container_of(dev, struct bnxt_aux_dev, aux_dev.dev);
> > > +     struct bnxt *bp = netdev_priv(bnxt_adev->edev->net);
> > > +
> > > +     bnxt_adev->edev->en_ops = NULL;
> > > +     kfree(bnxt_adev->edev);  
> >
> > And yet the reference counted "release" function accesses the bp->adev
> > like it must exist.
> >
> > This seems odd to me - why do we need refcounting on devices at all
> > if we can free them synchronously? To be clear - I'm not sure this is
> > wrong, just seems odd.  
> I followed the existing implementations in that regard. Thanks

Leon, could you take a look? Is there no problem in assuming bnxt_adev
is still around in the release function?
