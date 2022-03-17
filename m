Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E768B4DCD7A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiCQSV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237448AbiCQSVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E79E223848
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 11:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01850B81C51
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 18:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CCBC340E9;
        Thu, 17 Mar 2022 18:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647541201;
        bh=eUJqw41uIpOW2xfe66AkN/nwzaKOhFRrFk+KYHf3OTQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkj71srBFX00fEMAO0DtxmxQJKDcpumB+MRGgBMXw09RgCH1xaziOmdrrdigmQ/HV
         cptOP2ehT8PgINbwUom2+kvc3U+DwYfs+EHZTXg2mWy52AzA/DMECFshO6zE61CkEt
         hno8ngkjcMWZ/iiPLw1PMavFF88yl6WRDeuP0mO5bGmxLOqkV0fZJjcS7oPNQvO5yr
         M6MoNNssFWFvjeJVgTVrpBT+W7AfdHg0P9E4twR6km9ElVs4XjHUZBr1lbVYR/jDHj
         wUQHomuykmlbQYu3ZePRM8K0Y7eB3Jp9hXOnasefObXp2pv4vlzpeI66X1uE+XhmoI
         Q8abJM1iJZ+cg==
Date:   Thu, 17 Mar 2022 11:19:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        leonro@nvidia.com, saeedm@nvidia.com, idosch@idosch.org,
        Michael Chan <michael.chan@broadcom.com>,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next 1/5] bnxt: use the devlink instance lock to
 protect sriov
Message-ID: <20220317111959.7cad8fb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAHHeUGU5Ppkj+YgCnfkGMzsF_2hUcKeemSqk5_PZreC535EgNg@mail.gmail.com>
References: <20220317042023.1470039-1-kuba@kernel.org>
        <20220317042023.1470039-2-kuba@kernel.org>
        <CACKFLi=O4ffBLgP=Xi_CFzwpFVc+zGRH4pmZ15h_YP-imzNpvw@mail.gmail.com>
        <CAHHeUGU5Ppkj+YgCnfkGMzsF_2hUcKeemSqk5_PZreC535EgNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Mar 2022 23:15:33 +0530 Sriharsha Basavapatna wrote:
> The changes look good to me overall. But I have a few concerns. This
> change introduces a lock that is held across modules and if there's
> any upcall from the driver into devlink that might potentially acquire
> the same lock, then it could result in a deadlock. I'm not familiar
> with the internals of devlink, but just want to make sure this point
> is considered. Also, the driver needs to be aware of this lock and use
> it in new code paths within the driver to synchronize with switchdev
> operations. This may not be so obvious when compared to a driver
> private lock.

That's true, that's why we're adding the new "unlocked" devl_* API.
I'm switching the drivers accordingly, I didn't see any upcalls in 
the relevant parts in bnxt, LMK if I missed something!
