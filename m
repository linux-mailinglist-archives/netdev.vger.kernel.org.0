Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087C6643F2E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 09:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbiLFI66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 03:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbiLFI64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 03:58:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D64131C436;
        Tue,  6 Dec 2022 00:58:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CDB0B818CB;
        Tue,  6 Dec 2022 08:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E59C433D6;
        Tue,  6 Dec 2022 08:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670317132;
        bh=6hC6q62YWRveam3AL7WSGJpsWyeG22u37HMG9JMaXxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JxAx8/GRcTVX4o2aj8TMqSfS3DniSNQTXtVyyWTHnu04UZrE8lIRIkEs2zgajhb+Y
         /d1npkJhZpmQGMB8fzBR2pfIfmr2BRqIOc5wEFItejAUjdzxQEl8M4IE6jA+jWn6fF
         6NjOZ50sauClyO96Npps56VDmWqJ1BjEpu1W0nMoPmjXxPvQSyTNqbyr0YUDeszwK1
         csYOB3+dcqukLq67Tq2clIN2l+ji2Xy0FqjpOJBJhvsbUhv48B1klyrJZqSHjKeFO6
         gBo7ztvCebJZrlewCuMtZ8H3PBpc13UpKAro9bg4Hl1SFT5HnaE/CjPVkx4P+CSxPC
         3NoK9YbbNf7SA==
Date:   Tue, 6 Dec 2022 10:58:47 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
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
Message-ID: <Y48ERxYICkG9lQc1@unreal>
References: <20221129130933.25231-1-vburru@marvell.com>
 <20221129130933.25231-3-vburru@marvell.com>
 <Y4cirWdJipOxmNaT@unreal>
 <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
 <Y4hhpFVsENaM45Ho@unreal>
 <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
 <Y42nerLmNeAIn5w9@unreal>
 <20221205161626.088e383f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205161626.088e383f@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:16:26PM -0800, Jakub Kicinski wrote:
> On Mon, 5 Dec 2022 10:10:34 +0200 Leon Romanovsky wrote:
> > > These messages include periodic keep alive (heartbeat) messages
> > > from FW and control messages from VFs. Every PF will be listening
> > > for its own control messages.  
> > 
> > @netdev, as I said, I don't know if it is valid behaviour in netdev.
> > Can you please comment?
> 
> Polling for control messages every 100ms?  Sure.
> 
> You say "valid in netdev" so perhaps you can educate us where/why it
> would not be?

It doesn't seem right to me that idle device burns CPU cycles, while it
supports interrupts. If it needs "listen to FW", it will be much nicer to
install interrupts immediately and don't wait for netdev.

Thanks
