Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3214B57D30F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGUSNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbiGUSN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:13:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3673A4BD17;
        Thu, 21 Jul 2022 11:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF580B82622;
        Thu, 21 Jul 2022 18:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA36C341C0;
        Thu, 21 Jul 2022 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658427200;
        bh=o7Ajqh4ip0EDKvBQD/BCfqETTVSXVTTnryidSxFBYvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cEPKlEoDKc8HGoHpA3jgppwqv2mcNYotwx6Mema6orQqvYnJ24aYrJ2bMQztoR+Ba
         zEhokZkuiKhruUC8EqJjmgWX+5O87/ZtCTnb/CYOXq0syFoEFxFx/XndHcC5ZUmZmv
         0jRg7TZ6SXCedM69vLq1lwxUNoahDcS8TjbV8ofDgtkXaOH0uixAEuxpFW9G6paEii
         VWU1eH24Y2rO0r1py7RgPzRnqM6pRV5PHUBAlhLohByQ4PnD9TSUNelSqGMcwrKDW0
         zefwC5JemY+Alq6KfPHyuTBBr5X/B93+l9MFq/Ldv0V3SAKz3t589D3RyuzR2gXwUw
         ztCdC0Da7qU/Q==
Date:   Thu, 21 Jul 2022 11:13:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] netlink: add 'bitmap' attribute type and
 API
Message-ID: <20220721111318.1b180762@kernel.org>
In-Reply-To: <20220721155950.747251-1-alexandr.lobakin@intel.com>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 17:59:46 +0200 Alexander Lobakin wrote:
> BTW, Ethtool bitsets provide similar functionality, but it operates
> with u32s (u64 is more convenient and optimal on most platforms) and
> Netlink bitmaps is a generic interface providing policies and data
> verification (Ethtool bitsets are declared simply as %NLA_BINARY),
> generic getters/setters etc.

Are you saying we don't need the other two features ethtool bitmaps
provide? Masking and compact vs named representations?

I think that straight up bitmap with a fixed word is awkward and leads
to too much boilerplate code. People will avoid using it. What about
implementing a bigint type instead? Needing more than 64b is extremely
rare, so in 99% of the cases the code outside of parsing can keep using
its u8/u16/u32.
