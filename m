Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5396D6BAA21
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjCOH4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbjCOH4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:56:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD6631E34
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:55:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6701B61BBB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA79C433EF;
        Wed, 15 Mar 2023 07:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866958;
        bh=mAKeWec/ey597ZUaIrZXFDk+lzSVeeKrtz4YMEhU9Xg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UNg1ikCmRqqvHjy9mUXFUpRaHeZLAAWb8O+9EDTgM0nzmDqo3aoLBxjjDPQpH7t0N
         XvIrPiNejDM/P2W0bF+41SeHaQ0cqkvkO6G8gR+DQISi3lXHv15ASy3Y9khaVeaMy9
         psV/Db6qmF4GpQR9668tIsffqRcRrDR1AXkvNCYsMHNjjD5RQCN5+OsSrCs4jrnhpN
         aslbQXdgf66zcNKeuNQBtXDO/DdTsMus6MEfd5w47bPv/CXmDGqdV8cIrA/gNDh4xI
         24kUKgY4EshAseTHmjiGsfU2jFbWFctRxVroVvaUKUoN1wZ0S25kQGi0eucqHBgyBf
         lCuPmpFCWLUHQ==
Date:   Wed, 15 Mar 2023 00:55:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        j.vosburgh@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2 1/4] bonding: add bond_ether_setup helper
Message-ID: <20230315005557.10e7984f@kernel.org>
In-Reply-To: <20230314111426.1254998-2-razor@blackwall.org>
References: <20230314111426.1254998-1-razor@blackwall.org>
        <20230314111426.1254998-2-razor@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 13:14:23 +0200 Nikolay Aleksandrov wrote:
> +/* ether_setup() resets bond_dev's flags so we always have to restore
> + * IFF_MASTER, and only restore IFF_SLAVE if it was set
> + */
> +static void bond_ether_setup(struct net_device *bond_dev)
> +{
> +	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
> +
> +	ether_setup(bond_dev);
> +	bond_dev->flags |= IFF_MASTER | slave_flag;
> +	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
> +}
> +

We can't split this from patch 2, it's going to generate a warning
under normal build flags, people may have WERROR set these days..
