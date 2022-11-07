Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFD5561ECC1
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiKGITA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiKGIS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:18:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB59CBCD;
        Mon,  7 Nov 2022 00:18:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8842460F2A;
        Mon,  7 Nov 2022 08:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62522C433D7;
        Mon,  7 Nov 2022 08:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667809138;
        bh=3dF2QAjPMfoUQc5YaxUYmnqWeYAkdfF2bIY7ZZsXg2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aMJ5ZGb5OuAqEChpPrsX/OlVBsRQIeCVT/pMh0OcbLoIKLwgHY0b+Ic+OX+LbcI6z
         8GcPGi2t63iQV/nw6FcBcjnhReunsBVTFKc5ZFBDPB9DDjnuACeimIZX97c/Wacm5M
         aF3BK3v7OooCi1NnzkBxUsLlfgawWZSaX5hg90DqmdOVMiuCRhwG7nEt6i6FbGoqHY
         sdzYMmAPFD5egSyrOSXLErRQUkeotN5OD3mk1BoSdqQ173xZrZnNvl+ch+/S7vW5hq
         FaLCG40nhKpy7IgwavlOSmUh0uKCfC9tbJphyjc55Xk8mZMf2rQ/kRSvMRjo5E9idR
         Xdwg0c7IpoP0g==
Date:   Mon, 7 Nov 2022 10:18:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 1/9] octeon_ep: wait for firmware ready
Message-ID: <Y2i/bdCAgQa95du8@unreal>
References: <20221107072524.9485-1-vburru@marvell.com>
 <20221107072524.9485-2-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107072524.9485-2-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 11:25:15PM -0800, Veerasenareddy Burru wrote:
> Make driver initialize the device only after firmware is ready
>  - add async device setup routine.
>  - poll firmware status register.
>  - once firmware is ready, call async device setup routine.

Please don't do it. It is extremely hard to do it right. The proposed
code that has combination of atomics used as a locks together with absence
of proper locking from PCI and driver cores supports my claim.

Thanks
