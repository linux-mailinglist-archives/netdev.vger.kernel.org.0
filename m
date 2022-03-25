Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FD24E6BF2
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 02:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357262AbiCYBYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353220AbiCYBYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BB8BD8A5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 18:22:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C5FDB8226E
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 01:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA4CC340F6;
        Fri, 25 Mar 2022 01:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648171357;
        bh=eZUZokOez3vbgzqaO/78P9nScmM6gFeYmbjZt29cEmQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fOr6B3FKP/QWSWhIP2mpVzRaGQqRyw7eYwUrriSmflPsG8V6uOQQeHx2y0QOz4a5U
         Q+z2Q3fhzmeLQ2gSkEZs/BuElmDoDWXVNZo5EWPjOj8/OGYHzfs+HXarg6ZPsXxh6B
         HvQ+af5/bEkVF/88B6K02NZ3NVJzZlriT9EVwD9Xc10rnqkvsD74BJ4pLHudhuZlly
         WeQQkLOq4R+LWYAZqjhxyTTgvMsNxDO2q35OtiNo0pzyePGL+peZAUeH81Kt1K+lNI
         4UhUMB3uPkiTzE2zKAW+JVBKk3TCblj2VkFws0uML6prY3ROGN8IP3Z2UWANXQZPJR
         kG55VGYdyaByg==
Date:   Thu, 24 Mar 2022 18:22:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
Subject: Re: [RFCv5 PATCH net-next 04/20] net: replace multiple feature bits
 with netdev features array
Message-ID: <20220324182235.05dd0f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220324154932.17557-5-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-5-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 23:49:16 +0800 Jian Shen wrote:
> There are many netdev_features bits group used in drivers, replace them
> with netdev features array.

Maybe we can avoid the ARRAY_SIZE calls by doing something like:

struct netdev_feature_set {
	unsigned int cnt;
	unsigned short feature_bits[];
};

#define DECLARE_NETDEV_FEATURE_SET(name, features...)    \                               
        static unsigned short __ ## name ## _s [] = {features}; \                               
        struct netdev_feature_set name = {               \                               
                .cnt = ARRAY_SIZE(__ ## name ## _s),     \                               
                .feature_bits = {features},              \                               
        }                                                                       

Then:

DECLARE_NETDEV_FEATURE_SET(siena_offload_features,
			   NETIF_F_IP_CSUM_BIT,
			   NETIF_F_IPV6_CSUM_BIT,
			   NETIF_F_RXHASH_BIT,
			   NETIF_F_NTUPLE_BIT);

etc.?
