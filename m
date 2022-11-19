Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AD5630AE4
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 03:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiKSC5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 21:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKSC5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 21:57:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F13A3172
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 18:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9211362831
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 02:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6BEC433D6;
        Sat, 19 Nov 2022 02:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668826662;
        bh=ikfrrSAjWplmJBJX4Ns3wk0dfEr31LBhidt9Ip54FjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=guqxxf8M4uBrFFclMb/lR8HFYizaolzZUUbar4nV4ZRBM7O0HRjWvVSreUNHwNO45
         QeWVRI+TweCcDWAc0w6rOm1vSbqua4M+dph/TL22UtB6oMenYTxhziRrmX+mRe4Lou
         0mOhcmBqW49BLoW2as8ZUg9Z5cGUzc+J+d/JhDZ/QkJhgIshm+47kUNkhP8gQNVz8t
         xIinGVxElVB/yjsOTrJfpOS8+Y2LsBC5B1+Rnb5A5gGucRXvLZHx1eaMhcy1Hillbr
         brknT9ZktNzZk9FbX2MhnGNb654Mt8w4zE6jtG6QaEDFH+ii2mQFUKauOVbn/98QVW
         iewC2nzl5L/2g==
Date:   Fri, 18 Nov 2022 18:57:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>
Subject: Re: [PATCH net] ixgbe: fix pci device refcount leak
Message-ID: <20221118185740.0eb4e5e3@kernel.org>
In-Reply-To: <20221118020445.814751-1-yangyingliang@huawei.com>
References: <20221118020445.814751-1-yangyingliang@huawei.com>
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

On Fri, 18 Nov 2022 10:04:45 +0800 Yang Yingliang wrote:
> As comment of pci_get_domain_bus_and_slot() says, it returns
> a pci device with refcount increment, when finish using it,
> the caller must decrement the reference count by calling
> pci_dev_put().
> 
> In ixgbe_get_first_secondary_devfn() and ixgbe_x550em_a_has_mii(),
> pci_dev_put() is called to avoid leak.

here as well the CC list is incomplete.
