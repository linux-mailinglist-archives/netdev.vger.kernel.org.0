Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1F46439DA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 01:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiLFATj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 19:19:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLFATi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 19:19:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300DCFAFE;
        Mon,  5 Dec 2022 16:19:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8A64B8125A;
        Tue,  6 Dec 2022 00:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B244C433D6;
        Tue,  6 Dec 2022 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670285974;
        bh=dLQQ0NWaWk52bmt/xT4H3e0ztNisUGBWj/+Cz/N6eJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IAewbV2I0ijd6AwZgCGYqfcwpr/mnsPvs+LJpPtl8/EDfdf+sGkxnOjVZZOlY7N4V
         N/l9aVxWIVgnNLSq2mkEa125lYI7CjSuJ9E5MwCWNCSvrgDh2e5yhciKE6AEuzSrt4
         nXQ//j4VRO3OP62IElpc4kIxTXgkIIcSby10mK40TnQnIaxPMQLLtxGq4n4ab8xcg8
         /eo1hLP6K08B9CHN/Z3XvG4ZDWmiYapldPyt5XaktjmQpoDB1Ks8IvBTDmp5Q+JOTP
         LGHKs741J9pr+Q/j1811cwQCMBN5Kp8ACpbuWwwwp0g/C5/4RjGyjMDByPO1LnhnU1
         4w6V1x226XDdg==
Date:   Mon, 5 Dec 2022 16:19:33 -0800
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
Message-ID: <20221205161933.663ea611@kernel.org>
In-Reply-To: <Y43IpIQ3C0vGzHQW@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <20221129213724.10119-3-vfedorenko@novek.ru>
        <Y4eGxb2i7uwdkh1T@nanopsycho>
        <DM6PR11MB4657DE713E4E83E09DFCFA4B9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4nyBwNPjuJFB5Km@nanopsycho>
        <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4okm5TrBj+JAJrV@nanopsycho>
        <20221202212206.3619bd5f@kernel.org>
        <Y43IpIQ3C0vGzHQW@nanopsycho>
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

On Mon, 5 Dec 2022 11:32:04 +0100 Jiri Pirko wrote:
> >> I believe we should do it only the other way around. Assign
> >> dpll_pin pointer to struct net_device and expose this over new attr
> >> IFLA_DPLL_PIN over RT netlink.  
> >
> >The ID table is global, what's the relationship between DPLLs
> >and net namespaces? We tie DPLLs to a devlink instance which
> >has a namespace? We pretend namespaces don't exist? :S  
> 
> Well, if would be odd to put dpll itself into a namespace. It might not
> have anything to do with networking, for example in case of ptp_ocp.
> What would mean for a dpll to be in a net namespace?

Yeah, that's a slightly tricky one. We'd probably need some form 
of second order association. Easiest if we link it to a devlink
instance, I reckon. The OCP clock card does not have netdevs so we
can't follow the namespace of netdevs (which would be the second
option).
