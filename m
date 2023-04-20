Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191F86E9FBF
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 01:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjDTXVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 19:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbjDTXVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 19:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638E649EF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 16:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F399C618C9
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 23:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A60C433EF;
        Thu, 20 Apr 2023 23:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682032900;
        bh=UWWS88ckAbbbv7dT9lyPBDOyOQ1c5gbIG2dd4Nr6Q+0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B5DM14YjM78BDBqq7yEgPATkm4MtgUek6GaOMEfGK9Pjp+V0YWlkOduUZRjSm17uE
         eAqt2B4v+jubZW/DSCeFbDawX9Xt09JIi0mGusdOI9On+ffZKoP8vM7K4I3uy/mjjk
         G4festEsXoPPfRZhhPa6cnPxjORqpDhTr+XKMjCYsHvwYKPeILb8M5uQtlbqw5kg9D
         BIla9vjLuYOZLA4ThEhVTE7cjhESKy4TQJhcr3Cjedv3brQ1sc2U5vBQgABK2JfRqn
         kV3DGCiHHgEJyqAGZ9rodOnBisLmwX8EPoXeAH4xug+ehdy9o888LybrDN+Z4HCJOh
         HxMlvfwU96ocw==
Date:   Thu, 20 Apr 2023 16:21:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     kernel test robot <lkp@intel.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        oe-kbuild-all@lists.linux.dev,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCH net 1/4] bonding: fix send_peer_notif overflow
Message-ID: <20230420162139.3926e85c@kernel.org>
In-Reply-To: <27709.1682006380@famine>
References: <20230420082230.2968883-2-liuhangbin@gmail.com>
        <202304202222.eUq4Xfv8-lkp@intel.com>
        <27709.1682006380@famine>
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

On Thu, 20 Apr 2023 08:59:40 -0700 Jay Vosburgh wrote:
> >All errors (new ones prefixed by >>, old ones prefixed by <<):
> >  
> >>> ERROR: modpost: "__umoddi3" [drivers/net/bonding/bonding.ko] undefined!  
> 
> 	I assume this is related to send_peer_notif now being u64 in the
> modulus at:
> 
> static bool bond_should_notify_peers(struct bonding *bond)
> {
> [...]
>         if (!slave || !bond->send_peer_notif ||
>             bond->send_peer_notif %
>             max(1, bond->params.peer_notif_delay) != 0 ||
> 
> 	but I'm unsure if this is a real coding error, or some issue
> with the parisc arch specifically?

Coding error, I think. 
An appropriate helper from linux/math64.h should be used.
