Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731CF4D52F1
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiCJUO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:14:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233319AbiCJUOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:14:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E86EAC8A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 12:13:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F61BB8270A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2314C340E9;
        Thu, 10 Mar 2022 20:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646943230;
        bh=s/C9t7zWT5exkjmx+39l9p/4chuJWmCKtKQUGjbWYAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Myn0nITISVqgDOVyL38Scd5SYl5KuTeqhJfL16xReUglmwYgs3HSjO3Di1dQVirJz
         8kgwqv7pWI9VG85z3f1ZJ5rKY9+QIY/iIei4kLQUa+gICf0nkCXAMKgz37A84tUCrg
         hWNLkSu7/PoTNJl6gGI8LQ8aXsnOeWK4Neg8RnK7aZ+yb+sqVAHqqpBdlmMjrZ95Qs
         apw3tuWZjK3iXtoLdfK70iuRbqvhVi/sKg2XC7NKKuW+daL8GCeqVh2jOkZGCV1eFh
         nJTJfW1pwUEItev7Ev1wQ5YFxPYD7p3yvE5i+seNI0tT/h9dhEVnaudqU8jDioifl3
         UdAv87Xy4UwWw==
Date:   Thu, 10 Mar 2022 12:13:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 0/6] devlink: expose instance locking and
 simplify port splitting
Message-ID: <20220310121348.35d8fc41@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yim/wpHAN/d0S9MC@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
        <Yim/wpHAN/d0S9MC@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 11:07:14 +0200 Leon Romanovsky wrote:
> On Wed, Mar 09, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> > This series puts the devlink ports fully under the devlink instance
> > lock's protection. As discussed in the past it implements my preferred
> > solution of exposing the instance lock to the drivers. This way drivers
> > which want to support port splitting can lock the devlink instance
> > themselves on the probe path, and we can take that lock in the core
> > on the split/unsplit paths.
> > 
> > nfp and mlxsw are converted, with slightly deeper changes done in
> > nfp since I'm more familiar with that driver.
> > 
> > Now that the devlink port is protected we can pass a pointer to
> > the drivers, instead of passing a port index and forcing the drivers
> > to do their own lookups. Both nfp and mlxsw can container_of() to
> > their own structures.
> > 
> > I'd appreciate some testing, I don't have access to this HW.
>
> Thanks for pursuing in cleanup this devlink mess.
> 
> Do you plan to send a series that removes devlink_mutex?

I would like to convert enough to explicit locking to allow simpler
reload handling. I'm happy to leave devlink_mutex removal to someone
else, but if there are no takers will do it as well. Let's see how 
it goes.
