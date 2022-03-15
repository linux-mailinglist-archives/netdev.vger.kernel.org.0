Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9624DA326
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbiCOTQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 15:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237169AbiCOTQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 15:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED47BC25
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 12:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70091B816D6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 19:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FD5C340EE;
        Tue, 15 Mar 2022 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647371731;
        bh=BKx4r/NADzd+REzVOTous0fwclhNr7Kq69l948UipTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CKnuIMnbyWmJ8VlIc4aulxWAd5aKH6rqHqwjFrsuX8L3kRovrB1/CBEO5rcylo31h
         71XaH/WmwyMoyeCO5Mqy4JJlfWasvT5kYiepQguKUnZ7QaUu9kBYQoRjsp9YchOJH0
         Sn2tpBEYUtzKo5G3qZqP1kRzdSKqMuH4odmXZYw+4alj3X20HsURVAwbq/z7bCHMz1
         FaTmCbSeK5AMAcaUioCvAc24tdq56toBsnzF2crMjb08NBrp2pnGHcE12G1469rcr4
         NTWDV1AR6hxUXsH59/y5iEpm2EzQMTnLwLhUD4NqFvvTClS4JqEBzHEnq8GQdwIjB6
         Uo+1WaNfb7NMA==
Date:   Tue, 15 Mar 2022 12:15:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <tanhuazhong@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: Re: [RFC net-next 1/2] net: ethtool: add ethtool ability to set/get
 fresh device features
Message-ID: <20220315121529.45f0a9d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315032108.57228-2-wangjie125@huawei.com>
References: <20220315032108.57228-1-wangjie125@huawei.com>
        <20220315032108.57228-2-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 11:21:07 +0800 Jie Wang wrote:
> As tx push is a standard feature for NICs, but netdev_feature which is
> controlled by ethtool -K has reached the maximum specification.
>=20
> so this patch adds a pair of new ethtool messages=EF=BC=9A'ETHTOOL_GDEVFE=
AT' and
> 'ETHTOOL_SDEVFEAT' to be used to set/get features contained entirely to
> drivers. The message processing functions and function hooks in struct
> ethtool_ops are also added.
>=20
> set-devfeatures/show-devfeatures option(s) are designed to provide set
> and get function.
> set cmd:
> root@wj: ethtool --set-devfeatures eth4 tx-push [on | off]
> get cmd:
> root@wj: ethtool --show-devfeatures eth4

I'd be curious to hear more opinions on whether we want to create a new
command or use another method for setting this bit, and on the concept
of "devfeatures" in general.

One immediate feedback is that we're not adding any more commands to
the ioctl API. You'll need to implement it in the netlink version of
the ethtool API.
