Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4D04DBCF8
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349719AbiCQC32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231821AbiCQC31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:29:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCC91D0E3;
        Wed, 16 Mar 2022 19:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A46BB81A71;
        Thu, 17 Mar 2022 02:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74890C340E9;
        Thu, 17 Mar 2022 02:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647484087;
        bh=508jFcvN0UpUX+6aytOfQ3pYs9WHkzMNEjzA8savm3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rVo60UauBBVFJetcQppsANNRhdrZ7f2HT8w/7OmI0RsFKWSPFMfl3LvrolwwNUJ0a
         2hIIEWQXkkFA5rgEh0R9HkL2aN/dwmlZBbB+jshq/g1iClqVuzXT13hAkvz141KA0G
         /9edxx1V8cewAJB5ZwolZsUJe/V2JHXkvurLoexMATkLb44RWKPrs5YK6Py7cJDSpy
         uCpRQNuP5EYa9HoLDi8HPCa7B/jNf+tQzuwHBYN7n104MBbmS2aGLGnxNbyyz79M7u
         lo7giJr+9soD6Xe9mtCYl4RV4hUxHO9Oi6boysQKlwrZGNHi7uLyYE4YVnwF0uyX3Y
         h+v0l+wAyV65A==
Date:   Wed, 16 Mar 2022 19:28:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, jgg@ziepe.ca, yangyingliang@huawei.com,
        arnd@arndb.de, rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: lantiq_etop: add stats support
Message-ID: <20220316192806.1ebc120c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315232733.134340-1-olek2@wp.pl>
References: <20220315232733.134340-1-olek2@wp.pl>
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

On Wed, 16 Mar 2022 00:27:33 +0100 Aleksander Jan Bajkowski wrote:
> This patch adds support for software packet and byte counters.

On a quick look this driver supports multiple queues, so bumping
per-device stats without holding locks (on the rx side) seems racy.
Plus the netdev->stats are deprecated. The "modern" way of implementing
stats is to add the appropriate members to the ring / channel structure
and implement .ndo_get_stats64()
