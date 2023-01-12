Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE791667EFE
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 20:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbjALTZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 14:25:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240203AbjALTYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 14:24:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A2E1D0D6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 11:14:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B43B81FF6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2192FC433EF;
        Thu, 12 Jan 2023 19:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673550891;
        bh=saV/tQHscwTp/w0sksVXGA/Cjas4M75TH/eZPXFxs0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RD0NuINsZub50eF9vyt2J/qoHyOAvTVyGS7AFlrck+s6ZbAQ7HtY+tn23UAJhzNZY
         9dhpBWfSbm1HuSvLMi7wTBo7h7Ol6rLplebMPIU4t45/iWOO69km8P5q82OALmPLKV
         4n3Or9IeLxelsy1sYX5TleGNtj9p00Aq/f0NTSFFa2ATosWY+KjBlrHxd3/s5pNoW8
         jd1mS+XOV0hkqGooXDaNfn+vXlvUMxc8YMmNYCgb/3y3z6Ip5y8cGPMWtx+XASaKOv
         mfonPHQT6/wyGlQ6R9zikoZdhIKkQ1YIsnj292wUzHN6DX6A0Qx9yiFMxyS9JIXuM3
         FbmQ8m7g1AMmA==
Date:   Thu, 12 Jan 2023 11:14:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net v2] ice: Fix deadlock on the rtnl_mutex
Message-ID: <20230112111450.2eefe7b6@kernel.org>
In-Reply-To: <DM4PR11MB5293E8540016AA8AB2E139F587FD9@DM4PR11MB5293.namprd11.prod.outlook.com>
References: <20230105120518.29776-1-mateusz.palczewski@intel.com>
        <20230105104517.79cd83ed@kernel.org>
        <DM4PR11MB5293E8540016AA8AB2E139F587FD9@DM4PR11MB5293.namprd11.prod.outlook.com>
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

On Thu, 12 Jan 2023 13:31:06 +0000 Palczewski, Mateusz wrote:
> >Why do cases which jump to err_vectors no need any changes?  
>
> During my testing I saw no issues with cases when goto err_vectors
> were used. Did You manage to have other results? 

I'm just reviewing the code.

Exhaustively testing all the cases is probably very hard,
which is why we generally try to reason about the code
from first principles.

IOW "it didn't fail in my testing" is rarely a sufficient proof
upstream.
