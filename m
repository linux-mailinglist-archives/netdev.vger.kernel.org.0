Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133F564511D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLGB06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLGB05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:26:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A77151C27;
        Tue,  6 Dec 2022 17:26:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30CADB81B91;
        Wed,  7 Dec 2022 01:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77237C433D6;
        Wed,  7 Dec 2022 01:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670376413;
        bh=uAhPANtQG8vNwsDMnta3XtQvv7+ogOxGq/VNCkqvbnQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qO6IuAsDB5W4SkID05tr1ksBMwt2O+HHvk6UVnfPs8yyYHGQu5iHwwx0E2d4YDrRX
         FzTi5ZxefSZJxeOeYR/VWwBzNY9SpbUNSaTTQsQehKam374EKBUpaRvJw/tRMCe9vI
         p4Q8lg+j7D/5ZhmJSwZgUGEuoE3+X/E51XECrijSGJ34O3VYnUkn9IOoBQ1WRDs/jd
         D/3Jn+aKWhxW6HRvFn9ZJkkXYdN/NZtu9+WLeA7PpAtnsJuP0Q/XTKhjWVemabyeN6
         ftYXFXjOODufORJC/iEcxRXjH62M3iGbkW5+CpRd1NSo4A0ckGfTIiKVYRxfTR06Tn
         liYIjYbnFm8Qw==
Date:   Tue, 6 Dec 2022 17:26:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <20221206172652.34ed158a@kernel.org>
In-Reply-To: <BYAPR18MB24234E1E6566B47FCA609BF8CC1B9@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
        <20221129130933.25231-3-vburru@marvell.com>
        <Y4cirWdJipOxmNaT@unreal>
        <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y4hhpFVsENaM45Ho@unreal>
        <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y42nerLmNeAIn5w9@unreal>
        <20221205161626.088e383f@kernel.org>
        <Y48ERxYICkG9lQc1@unreal>
        <20221206092352.7a86a744@kernel.org>
        <BYAPR18MB24234E1E6566B47FCA609BF8CC1B9@BYAPR18MB2423.namprd18.prod.outlook.com>
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

On Tue, 6 Dec 2022 21:19:26 +0000 Veerasenareddy Burru wrote:
> > That said, looking at what this set does - how are the VFs configured?
> > That's the showstopper for the series in my mind.  
> 
> VFs are created by writing to sriov_numvfs.

Configured, not enabled.
