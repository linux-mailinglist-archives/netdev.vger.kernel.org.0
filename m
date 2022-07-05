Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDDF567785
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiGETNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiGETNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:13:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151B71B7B5;
        Tue,  5 Jul 2022 12:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5C3C61B18;
        Tue,  5 Jul 2022 19:13:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55818C341C7;
        Tue,  5 Jul 2022 19:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657048409;
        bh=2fD47EYJ8DU5PxNdFvZQ3nFWOAQNfiU3a87fuXvip1Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OrFaTXZ8tUO1+ZVEJelT78P/UuxyQydx5O3S0+mHCYqrg5GJkn/azari59H/6zW33
         oxm1RbFB5t0Gj58Sxu/1NAgRi/3zx2dJFMztVLIgAurUSiQKxpymUTKQLm+70w/HX1
         hOvAu0h5siF3JqnpuNCCd+a6XTGr1mynLyTa3DOpMj8KdTULy41rIVBldGyT66/jVK
         CpyjxU5VmV5BF/yb+ZiYEv34O3lb0WR2f93JOVnGRIqm/ntP0JQZDSNbRnQc6VaF3o
         1SikloQ4+HdZRIhfvv6BvCsL92ng9kHUwZM7kLoTVZFr40jGGDoGO+gif8TA2ZsyqD
         vlThvK5g01S0Q==
Date:   Tue, 5 Jul 2022 12:13:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Max Krummenacher <max.oss.09@gmail.com>,
        Mateusz =?UTF-8?B?Sm/FhGN6eWs=?= <mat.jonczyk@o2.pl>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to
 `cancel_work_sync(&hdev->power_on)` from hci_power_on_sync.
Message-ID: <20220705121327.5b8029e4@kernel.org>
In-Reply-To: <CABBYNZL9yir6tbEnwu8sQMnNG+h-8bMdnkK1Tsqo8AOtc5goGw@mail.gmail.com>
References: <20220614181706.26513-1-max.oss.09@gmail.com>
        <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
        <20220705151446.GA28605@francesco-nb.int.toradex.com>
        <CABBYNZJDkmU_Fgfszrau9CK6DSQM2xGaGwfVyVkjNo7MVtBd8w@mail.gmail.com>
        <20220705113829.4af55980@kernel.org>
        <CABBYNZL9yir6tbEnwu8sQMnNG+h-8bMdnkK1Tsqo8AOtc5goGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 12:00:43 -0700 Luiz Augusto von Dentz wrote:
> > > Ive rebased the patch on top of bluetooth-next and fixed the hash,
> > > lets see if passes CI I might just go ahead and push it.  
> >
> > Thanks for pushing it along, the final version can got thru bluetooth ->  
> > -> net and into 5.19, right?  
> 
> Yep, I will send the pull request in a moment.

Perfect, thank you!!
