Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B174D540A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 22:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344201AbiCJWAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343762AbiCJWAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:00:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCE4FFF9B;
        Thu, 10 Mar 2022 13:59:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E17E9B82883;
        Thu, 10 Mar 2022 21:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49848C340E8;
        Thu, 10 Mar 2022 21:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949542;
        bh=UkTta+mJNOiFDvaEmTZvAluAm01tKTqeCObiTi1om6s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EfLj4rQ5ncUAmzUrV1VxHBVwUHfRsjkyhGeidtsw1TgfV1+ucYcO9p0kGuYxUQ1/m
         LZZsyVuR3mFA82Ns0Dy5obJTr37C28pPokJys+lYABbHXTq7gVuyIjHtuGfHN52Ukc
         erEKcE0/rRIODCLkZf420AZymkR0jOvw86TGRH9ElYHGF0GGtvguN4uCYvhkI2BjsU
         nYa98vSPRuFJduEA75K3SncU8j7qNCJtRch4an24KWEzIriauRHNt6ruG0h/HXV2n8
         IMMOt02fGEIoxbes5r7ELa1uIg7QMicasHiz70gUpJu5bjmSww48U1DWKDZdr8Znbh
         MC0FczHVY7kXg==
Date:   Thu, 10 Mar 2022 13:59:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     netdev@vger.kernel.org, Petr Oros <poros@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net] ice: Fix race condition during interface enslave
Message-ID: <20220310135901.39b1abdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310171641.3863659-1-ivecera@redhat.com>
References: <20220310171641.3863659-1-ivecera@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 18:16:41 +0100 Ivan Vecera wrote:
> Commit 5dbbbd01cbba83 ("ice: Avoid RTNL lock when re-creating
> auxiliary device") changes a process of re-creation of aux device
> so ice_plug_aux_dev() is called from ice_service_task() context.
> This unfortunately opens a race window that can result in dead-lock
> when interface has left LAG and immediately enters LAG again.
> 
> Reproducer:
> ```
> #!/bin/sh
> 
> ip link add lag0 type bond mode 1 miimon 100
> ip link set lag0
> 
> for n in {1..10}; do
>         echo Cycle: $n
>         ip link set ens7f0 master lag0
>         sleep 1
>         ip link set ens7f0 nomaster
> done

What's the priority on this one? The loop max of 10 seems a little
worrying.

Tony, Jesse, is it important enough to push into 5.17 or do you prefer
to take it via the normal path and do full QA? The blamed patch come
in to 5.17-rc it seems.
