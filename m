Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54113647AD6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiLIAgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLIAgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:36:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6DA9D2F7;
        Thu,  8 Dec 2022 16:36:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B51AB825BC;
        Fri,  9 Dec 2022 00:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02B0C433D2;
        Fri,  9 Dec 2022 00:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670546196;
        bh=eS8a/870Vq6o+U0jzi3hH5Q2d6yDRgQcjSD+pj6+cK0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YqDPDVPkIoOgfNNPiA/VU2t7Tu4QQkq5Oh/0Ydb3C/pq9+Sp7hgUU6/ECF5arn9xT
         8SsMH/nH7P4nX9Qyz8l0SQFaLVz3JAs3KAMvyGb9eCSzo945CuaNiGZOATp1C+tjma
         1qPP+H9GzkR+/nJI4WfqQU3Xc8kd5gwT6t1g1WWedSn3DMG0zx2uU03kOvkCNZD1bY
         tLflDCXpPO9ZegkGEn6RU/0Py/52DH8pphno1Ek2NytOMpXuwc7Rp+Ynh3FRTVCFBm
         0+aZ9HVv0Cl8klIqnq/UI8IQKtzVqOVkSTimnjtAwUSfiVtID4Avaqa+L8iKHtXbsB
         PW15puTR9owsQ==
Date:   Thu, 8 Dec 2022 16:36:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 4/4] ptp_ocp: implement DPLL ops
Message-ID: <20221208163634.707c6e07@kernel.org>
In-Reply-To: <Y5HI4deFBTvDFIGB@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <20221129213724.10119-5-vfedorenko@novek.ru>
        <Y4dPaHx1kT3A80n/@nanopsycho>
        <DM6PR11MB4657D9753412AD9DEE7FAB7D9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4n0H9BbzaX5pCpQ@nanopsycho>
        <DM6PR11MB465721310114ECA13F556E8A9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <20221206183313.713656f8@kernel.org>
        <Y5CS2lO8WaoPmMbq@nanopsycho>
        <20221207090524.3f562eeb@kernel.org>
        <Y5HI4deFBTvDFIGB@nanopsycho>
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

On Thu, 8 Dec 2022 12:22:09 +0100 Jiri Pirko wrote:
> >To what practical benefit? Where do we draw the line? Do you want
> >PTP clocks to also be auxdevs? DPLL lives in netdev, we don't have
> >to complicate things. auxdev is a Conway's law solution.  
> 
> Auxdev infra is quite simple to implement, I'm not sure what do you mean
> by complicating thing here.

You didn't answer my question - what's the benefit?
We're not faced with A or B choice. We have a A or nothing choice.
Doing nothing is easy.

> >mlx5 already looks like sausage meat, it's already minced so you can
> >fit it there quite easily, but don't force it on non-enterprise devices.  
> 
> Not forcing, just suggesting. It's a low-hanging fruit, why not reach
> it?

What is the fruit?

> >There is non 1:1 relationship with a bus device and subsystem in Linux,
> >LMK when you convinced Greg otherwise.  
> 
> Sure there is not. But maybe that is due to the simple fact that auxdev
> was introduces, what, 2 years back? My point is, we are introducing new
> subsystem, wouldn't it be nice to start it clean?

Still not getting what you think is clean.. Making all driver-facing
objects in the kernel be a fake bus-device?!
