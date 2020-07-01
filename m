Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4746921164F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgGAWxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGAWxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:53:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E12DC08C5C1;
        Wed,  1 Jul 2020 15:53:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A501314A8D68C;
        Wed,  1 Jul 2020 15:53:49 -0700 (PDT)
Date:   Wed, 01 Jul 2020 15:53:48 -0700 (PDT)
Message-Id: <20200701.155348.853858023908987046.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, huyn@mellanox.com,
        saeedm@mellanox.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jeffrey.t.kirsher@intel.com, kuba@kernel.org,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next] bonding: allow xfrm offload setup
 post-module-load
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630184941.65165-1-jarod@redhat.com>
References: <20200630184941.65165-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 15:53:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Tue, 30 Jun 2020 14:49:41 -0400

> At the moment, bonding xfrm crypto offload can only be set up if the bonding
> module is loaded with active-backup mode already set. We need to be able to
> make this work with bonds set to AB after the bonding driver has already
> been loaded.
> 
> So what's done here is:
> 
> 1) move #define BOND_XFRM_FEATURES to net/bonding.h so it can be used
> by both bond_main.c and bond_options.c
> 2) set BOND_XFRM_FEATURES in bond_dev->hw_features universally, rather than
> only when loading in AB mode
> 3) wire up xfrmdev_ops universally too
> 4) disable BOND_XFRM_FEATURES in bond_dev->features if not AB
> 5) exit early (non-AB case) from bond_ipsec_offload_ok, to prevent a
> performance hit from traversing into the underlying drivers
> 5) toggle BOND_XFRM_FEATURES in bond_dev->wanted_features and call
> netdev_change_features() from bond_option_mode_set()
> 
> In my local testing, I can change bonding modes back and forth on the fly,
> have hardware offload work when I'm in AB, and see no performance penalty
> to non-AB software encryption, despite having xfrm bits all wired up for
> all modes now.
> 
> Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
> Reported-by: Huy Nguyen <huyn@mellanox.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied, thanks.
