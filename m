Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95072644A41
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 18:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiLFRX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 12:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiLFRXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 12:23:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC44611815;
        Tue,  6 Dec 2022 09:23:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46308617EE;
        Tue,  6 Dec 2022 17:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE62C433D6;
        Tue,  6 Dec 2022 17:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670347433;
        bh=vgsf/phjQqqxA2RXgd59v2QIQaSndvp5aqVRHaKGzH0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k/VuipSm0Q/fHh/G09DN+GXdetyGbjLuSKqLWxsfcuCxqeIiftAoOqCE3H3jkSqTg
         K4O0coC3QoqwBsX8Q3gYRBExaOnIRORzzES7WkV/AxNIc9ZFmNVbf2ozcHnSzedmBZ
         J2Fx6MbQcYPkjuF1aWQrrZk9zEFw0ualkNx4EEeK38sqQQuCCbBsKN4QoW26xJnHpM
         lPijvEmkB5TIBELnOyIpykYCzrFR/v3ngwUcq4t0y9rwUaMId/86XhjnUh6wXEE+8N
         AujAtdGTVY661w30gyNBihpQuUU5YgWYome/Kva1z1EWvHp0onJFPmT6z84ucmwyEU
         BQgZ4BUrdn9cg==
Date:   Tue, 6 Dec 2022 09:23:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Message-ID: <20221206092352.7a86a744@kernel.org>
In-Reply-To: <Y48ERxYICkG9lQc1@unreal>
References: <20221129130933.25231-1-vburru@marvell.com>
        <20221129130933.25231-3-vburru@marvell.com>
        <Y4cirWdJipOxmNaT@unreal>
        <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y4hhpFVsENaM45Ho@unreal>
        <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y42nerLmNeAIn5w9@unreal>
        <20221205161626.088e383f@kernel.org>
        <Y48ERxYICkG9lQc1@unreal>
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

On Tue, 6 Dec 2022 10:58:47 +0200 Leon Romanovsky wrote:
> > Polling for control messages every 100ms?  Sure.
> > 
> > You say "valid in netdev" so perhaps you can educate us where/why it
> > would not be?  
> 
> It doesn't seem right to me that idle device burns CPU cycles, while it
> supports interrupts. If it needs "listen to FW", it will be much nicer to
> install interrupts immediately and don't wait for netdev.

No doubt, if there is an alternative we can push for it to be
implemented. I guess this being yet another "IPU" there could
be possible workarounds in FW? As always with IPUs - hard to tell :/

If there is no alternative - it is what it is. 
It's up to customers to buy good HW.

That said, looking at what this set does - how are the VFs configured?
That's the showstopper for the series in my mind.
