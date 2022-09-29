Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C91A5EFCB4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiI2SII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbiI2SHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:07:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116421C5CAB;
        Thu, 29 Sep 2022 11:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 242A3B825AB;
        Thu, 29 Sep 2022 18:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B50C433D7;
        Thu, 29 Sep 2022 18:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664474861;
        bh=bATHCkQqOvYiOq+6iIlVslzrcw/VVPy6O2Nw3XfuDYA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AV8kmxeypzHns12CWKRvabNPgtx/NTwjctgLjAe01NNVbYaId8Gc/hhEi+iB3SCpW
         glKy8MJFY+L+1Xdp6s94U/926FjFfuMzRGdR7LAptzXQUnmUN+HbALaYOM/clKkN+e
         n8fJf5Wx0JHUvY1beE/QRgsxpLLUt1LHhB2v6zbln//vPDIjt+RENzh2pr7ryPR1CR
         HwB+LyX/GkMw6J2SHS4Dwj7zNn7N5ShchUfXPdIBoETKILstlOyCiejXtRaHOg5bOP
         nqAEFw/sccSg0bnk4S2DUtCxMzdqPnr7mdqF2S35nK7u59l2m//+Zr/7f10QcYOnyY
         gX8pLoA3V8AiA==
Date:   Thu, 29 Sep 2022 11:07:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        "Junichi Uekawa ( =?UTF-8?B?5LiK5bed57SU5LiA?=) " <uekawa@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929110740.77942060@kernel.org>
In-Reply-To: <20220929122444-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
        <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
        <20220928052738-mutt-send-email-mst@kernel.org>
        <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
        <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
        <20220929031419-mutt-send-email-mst@kernel.org>
        <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
        <20220929034807-mutt-send-email-mst@kernel.org>
        <20220929090731.27cda58c@kernel.org>
        <20220929122444-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 12:25:14 -0400 Michael S. Tsirkin wrote:
> On Thu, Sep 29, 2022 at 09:07:31AM -0700, Jakub Kicinski wrote:
> > On Thu, 29 Sep 2022 03:49:18 -0400 Michael S. Tsirkin wrote:  
> > > net tree would be preferable, my pull for this release is kind of ready ... kuba?  
> > 
> > If we're talking about 6.1 - we can take it, no problem.  
> 
> I think they want it in 6.0 as it fixes a crash.

I thought it's just an OOM leading to send failure. Junichi could you
repost with the tags collected and the header for that stack trace
included? The line that says it's just an OOM...

"someone tried to alloc >32kB because it worked on a freshly booted
system" kind of cases are a dime a dozen, no?..
