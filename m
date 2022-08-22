Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7658959C473
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbiHVQxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbiHVQxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:53:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6389012630;
        Mon, 22 Aug 2022 09:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06F80B81627;
        Mon, 22 Aug 2022 16:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79671C433D6;
        Mon, 22 Aug 2022 16:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661187208;
        bh=0UO/1sjUciXbaHmT0ts5cKrVjHRxGNC9n1u4W/UM4cg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l0yzDcjj6mGDNSD/foDqACutV/dJDo2U++XuwM/nFjnhjplS3K2cO3+bq5duUyV+O
         f3oTEzmo/Vog5k1FkCtPPxfU3Eio0J0UVjW1lLO5QDCnrTzC4lBejtFLV1vS05ULWt
         avYCyoxdp97Krht2Lgs10qaZNP49yCdLb1OLcwPq0GJZAuisQyo2LJJk0+ivehQhhJ
         ZItueoXRdiYVd+/z/qshNh3T44T/LKa02tKGbo2ID0xXy/ObYPeVHY9GeOhRzh8rvk
         Nd1ebNbgPGrB0le5GT2VT1hFLXyIl4m3Jv9kib8caREjSFxIxnyFMydpL0DhPoKJhq
         fkkiEg0OGoZ7w==
Date:   Mon, 22 Aug 2022 09:53:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "huangguangbin (A)" <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <idosch@nvidia.com>,
        <linux@rempel-privat.de>, <mkubecek@suse.cz>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 0/2] net: ethtool add VxLAN to the NFC API
Message-ID: <20220822095327.00b4ebd5@kernel.org>
In-Reply-To: <5062c7ae-3415-adf6-6488-f9a05177d2c2@huawei.com>
References: <20220817143538.43717-1-huangguangbin2@huawei.com>
        <20220817111656.7f4afaf3@kernel.org>
        <5062c7ae-3415-adf6-6488-f9a05177d2c2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 22:46:14 +0800 huangguangbin (A) wrote:
> 1. I check the manual and implement of TC flower, it doesn't seems
>     to support configuring flows steering to a specific queue.

We got an answer from Sridhar on that one (thanks!)
I know it was discussed so it's a SMOC.

> 2. Our hns3 driver has supported configuring some type of flows
>     steering to a specific queue by ethtool -U command, many users
>     have already use ethtool way.
> 3. In addition, if our driver supports TC flower to configure flows
>     steering to a specific queue, can we allow user to simultaneously
>     use TC flower and ethtool to configure flow rules? Could the rules
>     configured by TC flower be queried by ethtool -u?
>     If two ways can be existing, I think it is more complicated for
>     driver to manage flow rules.

I understand your motivation and these are very valid points.
However, we have to draw the line somewhere. We have at least
three ways of configuring flow offloads (ethtool, nft, tc).
Supporting all of them is a lot of work for the drivers, leading
to a situation where there's no "standard Linux API" because each
vendor picks a slightly different approach :(
TC seems the most popular because of the OVS offload, so my preference
is to pick it over the other APIs.
