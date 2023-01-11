Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE79C666455
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 21:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbjAKUEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 15:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239828AbjAKUD5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 15:03:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C94B1788B
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 12:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36BA761D9E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 20:00:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B395C433EF;
        Wed, 11 Jan 2023 20:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673467204;
        bh=qgJNqM3+kp0zizn5PFEcOI75AhUSZP0wLsh8uzioG84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j73NaQussgqxXVKb+30niT8xcBreCT6S8zOyqp1o1OpmOe8lO7yd6CNHHVW7eQT0p
         DhRhZB4KLUGboWO8AQz3HKq4lVy2beIJodXX+OSmd2m87ZQ6+0VSK3Ng3ZCVWFQ4Ag
         diKHqL7qwCDvJFJ9DDLwZZryJTw+tiQQpfkXkp01ld1WfLC+XPKe7diNLb2Xv6r1Bj
         DDt70kmWyaaM0GVYZuEzo/0fdBYZYlTUPjXbYLroSy9ul9wiSMuRWPlLlvaIDltfjS
         QHxs4BWHI1jVrlD3yrUoFKOJm2qA/XSRUKlVwqEmz654dvAhAa8a6EL2rptRc9axJj
         1S2XXZczG71Tg==
Date:   Wed, 11 Jan 2023 12:00:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arinzon, David" <darinzon@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230111120003.1a2e2357@kernel.org>
In-Reply-To: <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
        <20230109164500.7801c017@kernel.org>
        <574f532839dd4e93834dbfc776059245@amazon.com>
        <20230110124418.76f4b1f8@kernel.org>
        <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
        <20230111110043.036409d0@kernel.org>
        <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
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

On Wed, 11 Jan 2023 19:31:39 +0000 Arinzon, David wrote:
> If the packet network headers are not within the size of the LLQ entry, then the packet will
> be dropped. So I'll say that c) describes the impact the best given that certain types of
> traffic will not succeed or have disruptions due to dropped TX packets.

I see. Sounds like it could be a fit for
DEVLINK_ATTR_ESWITCH_INLINE_MODE ? But that one configures the depth of
the headers copied inline, rather than bytes. We could add a value for
"tunneled" and have that imply 256B LLQ in case of ena.

The other option is to introduce the concept of "max length of inline
data" to ethtool, and add a new netlink attribute to ethtool -g.

Either way - the length of "inline|push" data is not a ena-specific
concept, so using private knobs (devlink params or ethtool flags) is
not appropriate upstream. We should add a bona fide uAPI for it.
