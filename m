Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC96439E6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 01:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiLFAYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 19:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLFAYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 19:24:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE451EAFD
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 16:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBF4DCE168C
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 00:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FD8C433D6;
        Tue,  6 Dec 2022 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670286253;
        bh=R/NAs/yH9iyc0AcGhnuB+33KVMbiRY9VLGZvLrqLHcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mOwlrKFR9oJxe9+ybTdy168GBu97t3M3nhqKFTVkRVFgVhHK6iMyfdg2eySBysDww
         5gqjyEkog8SJ+HwJ6CvzrMjiDortleLZ8uiKRrZ2YivUaTtI6gyf7Yu2lZw89YseDt
         dF0c/hfvfu5oIjIYHBdg/nvUE2E7nA/vlBrZsNvy8C2aYYSDtde1OYlnR54z4+dUpL
         XmfSE5HKoRrDqHi0uJ2Nt876weyp1vguFyq+OcFETILpLWTG6mAFYR+a0nPj/piqnj
         ML2yiG4jYlvtKpqofcEha3YsoGeI0UzOX6zGpAbSkpu9ok6efBSgb3fEHOL/8cNtUc
         1hOX0l89cgW8g==
Date:   Mon, 5 Dec 2022 16:24:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Wilczynski, Michal" <michal.wilczynski@intel.com>
Cc:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <przemyslaw.kitszel@intel.com>, <jiri@resnulli.us>,
        <wojciech.drewek@intel.com>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2 0/4] Implement new netlink attributes
 for devlink-rate in iproute2
Message-ID: <20221205162411.1b016789@kernel.org>
In-Reply-To: <24bca169-1f7b-4034-9893-5cd1f1c0ad1b@intel.com>
References: <20221201102626.56390-1-michal.wilczynski@intel.com>
        <20221201085330.5c6cb642@kernel.org>
        <24bca169-1f7b-4034-9893-5cd1f1c0ad1b@intel.com>
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

On Mon, 5 Dec 2022 09:41:26 +0100 Wilczynski, Michal wrote:
> On 12/1/2022 5:53 PM, Jakub Kicinski wrote:
> > On Thu,  1 Dec 2022 11:26:22 +0100 Michal Wilczynski wrote:  
> >> Patch implementing new netlink attributes for devlink-rate got merged to
> >> net-next.
> >> https://lore.kernel.org/netdev/20221115104825.172668-1-michal.wilczynski@intel.com/
> >>
> >> Now there is a need to support these new attributes in the userspace
> >> tool. Implement tx_priority and tx_weight in devlink userspace tool. Update
> >> documentation.  
> > I forgot to ask you - is there anything worth adding to the netdevsim
> > rate selftests to make sure devlink refactoring doesn't break your use
> > case? Probably the ability for the driver to create and destroy the
> > hierarchy?  
> 
> I think it's a great idea, possibility to export the hierarchy from the driver
> is key for our use case. Would you like me to add this to netdevism ?

Great! Yes, netdevsim and a script that exercises it. There are some
rate tests already in

 tools/testing/selftests/drivers/net/netdevsim/devlink.sh

Either just extend that or factor it out to its own script, if the rate
testing gets big. You don't have to be too "unit-testy" it's mostly
about exercising the functionality so that we can catch refactoring
errors.
