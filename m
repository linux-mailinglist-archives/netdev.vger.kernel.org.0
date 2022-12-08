Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95674647410
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiLHQT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHQT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:19:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC0A98972;
        Thu,  8 Dec 2022 08:19:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15A0D61F96;
        Thu,  8 Dec 2022 16:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6D2C433EF;
        Thu,  8 Dec 2022 16:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670516396;
        bh=M+Jm9v4PbD+01xedeGhK2H9LDFBDPBUKSkXffaF+n4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nrXhlD5XL3j5Ua9Mq2v5wzA2shGW068fVnqoxFM1z57paGvpw4n1xZbuEyjyXfB9j
         gaExw6exvMeKoNHPDC2I9nd3O5xQNkrqv+TYJAvY13SbUt7T5CjSP7NOdFHBs93P6p
         yVbhKZgrUCKCxmOW/W9Ci4CHWY1OcuTOva7LVGmRVqjAZTVijbRKulTrbNUT6Oob1X
         vPyZkToqrE8gb2HzD6NTqpBkhpmzRwbHqig7r8HN/5WMf8ZP2pWyia5ut6oFVk5e0d
         rXxTp8UxmeU7ZNR7ojspfpnhHasD5VrC9UBNjmCTU+3u/t5zIWZhzBEOBxqLCnnDUQ
         ersxppwIOY63Q==
Date:   Thu, 8 Dec 2022 08:19:55 -0800
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
Message-ID: <20221208081955.335ca36c@kernel.org>
In-Reply-To: <Y5Gc6E+mpWeVSBL7@nanopsycho>
References: <Y4nyBwNPjuJFB5Km@nanopsycho>
        <DM6PR11MB4657C8417DEB0B14EC35802E9B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4okm5TrBj+JAJrV@nanopsycho>
        <20221202212206.3619bd5f@kernel.org>
        <Y43IpIQ3C0vGzHQW@nanopsycho>
        <20221205161933.663ea611@kernel.org>
        <Y48CS98KYCMJS9uM@nanopsycho>
        <20221206092705.108ded86@kernel.org>
        <Y5CQ0qddxuUQg8R8@nanopsycho>
        <20221207085941.3b56bc8c@kernel.org>
        <Y5Gc6E+mpWeVSBL7@nanopsycho>
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

On Thu, 8 Dec 2022 09:14:32 +0100 Jiri Pirko wrote:
> >Running DPLL control in a namespace / container.
> >
> >I mean - I generally think netns is overused, but yes, it's what
> >containers use, so I think someone may want to develop their
> >timer controller SW in as a container?  
> 
> The netdevices to control are already in the container. Isn't that
> enough?

For DPLL config we need to delegate the permission.
So we'd need a "is net admin in namespace X" check, no?

> >> Thinking about it a bit more, DPLL itself has no network notion. The
> >> special case is SyncE pin, which is linked to netdevice. Just a small
> >> part of dpll device. And the netdevice already has notion of netns.
> >> Isn't that enough?  
> >
> >So we can't use devlink or netdev. Hm. So what do we do?
> >Make DPLLs only visible in init_net? And require init_net admin?
> >And when someone comes asking we add an explicit "move to netns"
> >command to DPLL?  
> 
> Well, as I wrote. The only part needed to be network namespaced are the
> netdev related pins. And netdevices have netns support. So my question
> again, why is that not enough?

For config which goes thru rtnl, yes, but we also need a caps check for:

+	DPLL_CMD_DEVICE_SET,
+	DPLL_CMD_PIN_SET,
