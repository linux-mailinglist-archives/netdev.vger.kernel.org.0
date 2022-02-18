Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D44BBC2D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237023AbiBRP2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:28:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237016AbiBRP2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:28:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D347F253BD6
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 07:28:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949B8B825AF
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 15:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E340C340E9;
        Fri, 18 Feb 2022 15:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645198093;
        bh=28nqtieS0oXSJNNXPkBBLjr2kbyx3yMvLg/a8/IKqPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WEF7WXtqUSdesP/DyE+ZfTVlXdC6S+eiDE7vtk6K7ouaw7SFNugNjEqlZ8cSE2y4G
         JD1abpxceZzaE/kg2YMkh4W7COCpfZZgEpgduaPL+sMALL8R90XHXrRLsttGBHTc60
         tDbUay+ScytwYP93m2PJAuj8IRv/uow/t1E0hgpwdvYIGJ6bEgrmGzEa+36mbkL77b
         criJNiriUA/2r3cyQY1VZO/A4FhNAqnRebsweIzSiPPVXPy1r0pBGFuRMgEKxHP4lP
         WUZjlQVBXIh5xrFG1yRvp84ZWbf0CToSArThlsDC1h0mK+WZhxToRVk5wgP/tJUARX
         vVi5qUhq5iTug==
Date:   Fri, 18 Feb 2022 07:28:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next] net: avoid quadratic behavior in
 netdev_wait_allrefs_any()
Message-ID: <20220218072811.72bf7276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218065430.2613262-1-eric.dumazet@gmail.com>
References: <20220218065430.2613262-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Feb 2022 22:54:30 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> If the list of devices has N elements, netdev_wait_allrefs_any()
> is called N times, and linkwatch_forget_dev() is called N*(N-1)/2 times.
> 
> Fix this by calling linkwatch_forget_dev() only once per device.
> 
> Fixes: faab39f63c1f ("net: allow out-of-order netdev unregistration")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Yup, I was on the fence on this one, I went for keeping all linkwatch
stuff in one function and minimal changes. Clearly underestimated the
number of netdevs your cases are destroying at once :)
