Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928CA644A4B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiLFR1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233884AbiLFR1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:27:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D60C391CF;
        Tue,  6 Dec 2022 09:27:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D41F0B817C2;
        Tue,  6 Dec 2022 17:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DE3C433C1;
        Tue,  6 Dec 2022 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670347626;
        bh=oafyIq8uK2j+Mag0YlB41XnYyQUDRVR0LHwRFJ1Cdo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OiBBCRdNWxGJxwz2+xmYS6Gmsa57Il10d9uoIbkK4ip0265csPbH79N+0/ZFPyylP
         OZ8mkB0FDxw0buCniMpKYeq1CuLjeo0ANClW5LZHnli7posC+/sCo+dphax4v4cAso
         +POy50McFb9H2eCMD+U2Z2x3K762ZwHIe18wk/5iE6IDeghuz98UKNEnS+atwP2Swk
         shk5UAdkcxDlLUB6s39pM8wmPqJtrpHBd3NuPKPO/SAvxIFsd9dK2MEB6ObEJASIL+
         eZkR4vJhd8i5OshcTSQoHpDs0x+e7X1GsXSdd7JaDH03MIybIMJgfCHOhOFsFeqlS0
         fMvAMjZNTjVUQ==
Date:   Tue, 6 Dec 2022 09:27:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vadim Fedorenko <vadfed@fb.com>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        "Olech, Milena" <milena.olech@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
Subject: Re: [RFC PATCH v4 2/4] dpll: Add DPLL framework base functions
Message-ID: <20221206092705.108ded86@kernel.org>
In-Reply-To: <Y48CS98KYCMJS9uM@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <20221129213724.10119-3-vfedorenko@novek.ru>
        <Y4eGxb2i7uwdkh1T@nanopsycho>
        <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4nyBwNPjuJFB5Km@nanopsycho>
        <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4okm5TrBj+JAJrV@nanopsycho>
        <20221202212206.3619bd5f@kernel.org>
        <Y43IpIQ3C0vGzHQW@nanopsycho>
        <20221205161933.663ea611@kernel.org>
        <Y48CS98KYCMJS9uM@nanopsycho>
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

On Tue, 6 Dec 2022 09:50:19 +0100 Jiri Pirko wrote:
>> Yeah, that's a slightly tricky one. We'd probably need some form 
>> of second order association. Easiest if we link it to a devlink
>> instance, I reckon. The OCP clock card does not have netdevs so we
>> can't follow the namespace of netdevs (which would be the second
>> option).  
> 
> Why do we need this association at all?

Someone someday may want netns delegation and if we don't have the
support from the start we may break backward compat introducing it.
