Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9084357F02E
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 18:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiGWPwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 11:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiGWPws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 11:52:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F5B18B27;
        Sat, 23 Jul 2022 08:52:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15D22B80908;
        Sat, 23 Jul 2022 15:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5790BC341C0;
        Sat, 23 Jul 2022 15:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658591564;
        bh=V3B+rBhVKrFkBpKL7mfwyrOPJrT1zZvNeK4gRIWfZc4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iYKvJER6JYtzAuy49aYd3d5dQp35a2/BWSRs8cuQWPlUQlXp5X8EVf64eX6snqrvI
         FVt4M4LjQmTubcQDT+123eRgBHgNpxW5eYVJnhl79+GPhDFYd6VOiKCUKXvU7slbPY
         hIt4THQNny103wBCpUcUwFkN1edpQX/0IfvLXtFwXBoSIcP6f8fLvlKiRe3agav2DH
         czm3ZlZVuE4XnbwuD+WmHnfwvAdtBfOqmd8PUWLBt+OUytkjGU8bIz/mXtr6T6Oqpp
         k04H/dJVLUgoSCAZZwjezcc0w/qed56qkb44W+ek+wN/v0IRYoDKFi99VIdlkuCvZV
         wCY7cS9b2D2hQ==
Date:   Sat, 23 Jul 2022 08:52:43 -0700
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
Message-ID: <20220723085243.00e4bfa4@kernel.org>
In-Reply-To: <20220722111951.6a2fd39c@kernel.org>
References: <20220721155950.747251-1-alexandr.lobakin@intel.com>
        <20220721111318.1b180762@kernel.org>
        <20220722145514.767592-1-alexandr.lobakin@intel.com>
        <20220722111951.6a2fd39c@kernel.org>
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

On Fri, 22 Jul 2022 11:19:51 -0700 Jakub Kicinski wrote:
> So at the netlink level the field is bigint (LE, don't care about BE).
> Kernel side API is:
> 
> 	nla_get_b8, nla_get_b16, nla_get_b32, nla_get_b64,
> 	nla_get_bitmap
> 	nla_put_b8, nla_put_b16 etc.
> 
> 	u16 my_flags_are_so_toight;
> 
> 	my_flags_are_so_toight = nla_get_b16(attr[BLAA_BLA_BLA_FLAGS]);
> 
> The point is - the representation can be more compact than u64 and will
> therefore encourage anyone who doesn't have a strong reason to use
> fixed size fields to switch to the bigint.

IDK if I convinced you yet, but in case you're typing the code for this
- the types smaller than 4B don't really have to be represented at the
netlink level. Padding will round them up, anyway. But we do want the
32b values there, otherwise we need padding type to align which bloats
the API.
