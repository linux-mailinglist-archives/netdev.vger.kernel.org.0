Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C484E6EE501
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 17:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbjDYPvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 11:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbjDYPvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 11:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA21AD2A;
        Tue, 25 Apr 2023 08:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7476E626D0;
        Tue, 25 Apr 2023 15:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62036C433D2;
        Tue, 25 Apr 2023 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682437901;
        bh=iFlqifPijavkdaktv7fAZ2L3FnnTuZoO48qo6G/HZVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AIRaBP7XPcOGkEQTebvDXf4yszZAuV81CVjk5ZPc6lJmSy8Oxxj7CZqamC1KLxkuG
         lloBD2Tk7c1rpu8CxbUoKtaliCtWP9QPXMB8aGFX4Z7RHfo9/nBDnGTiLwso4zINRH
         VBYlriANP0S2E7J12MctLlq5uSGA+2MleFjqyJKDxUZ1wKftHgGvkurkrWolPq4vVE
         X14pVPD4R2N7QeHZVgznpV1e4LOq+KHlp61bEcAzUmGpew6dtQ1CBPJVlfevQLnD4+
         YgTYvOZ5NFgM9f9oBzL5FgXPQaSgo4qeiNH1wUQe4YGPktlQzPKOaEksXki4B0TKEz
         vXbFDCPUNYRcA==
Date:   Tue, 25 Apr 2023 08:51:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: Re: [EXT] Re: [net PATCH 5/9] octeontx2-pf: mcs: Fix NULL pointer
 dereferences
Message-ID: <20230425085140.000bbcc1@kernel.org>
In-Reply-To: <CO1PR18MB4666A3A7B44081290B37E375A1679@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <20230423095454.21049-1-gakula@marvell.com>
        <20230423095454.21049-6-gakula@marvell.com>
        <20230423165133.GH4782@unreal>
        <CO1PR18MB4666A3A7B44081290B37E375A1679@CO1PR18MB4666.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 10:29:02 +0000 Subbaraya Sundeep Bhatta wrote:
> >How did you get call to .mdo_del_secy if you didn't add any secy?
> >
> >Thanks
> >  
> It is because of the order of teardown in otx2_remove:
>         cn10k_mcs_free(pf);
>         unregister_netdev(netdev);
> 
> cn10k_mcs_free free the resources and makes cfg as NULL.
> Later unregister_netdev calls mdo_del_secy and finds cfg as NULL.
> Thanks for the review I will change the order and submit next version.

Leon, ack? Looks like the patches got "changes requested" but I see 
no other complaint.
