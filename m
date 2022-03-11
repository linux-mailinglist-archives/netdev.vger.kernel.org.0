Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07344D5727
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345249AbiCKBKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiCKBKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:10:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A340C1C8C;
        Thu, 10 Mar 2022 17:08:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B02EBB82997;
        Fri, 11 Mar 2022 01:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA54CC340E8;
        Fri, 11 Mar 2022 01:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646960935;
        bh=UZlMxVHtgUhOf3NIn877YeWd/ZtNXQOWjYEbnWchk8w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KDOGWF7PIehsIwJumfOPddh93hUYCEinkGQ0A+0jp2SISTz6VtpranUPwzd3fp/Ch
         mW2zFdHntxs5IZOpDokQ36IOPzbgyp0fmhvay7TKxoxjY2mBysjmDZpsW0XXh35+nr
         nPv5+Henf/Lh36ETHjYYcGIIsq/Q88oKOeX7BgXbaj4DReug/lQ7KW0y+0RxvXY0H6
         /+hEpOD2qu23Kqq98oRJFMg4hoy3X/tlWcvU7YLyPV9eFkIttamjYi3lpI7tT4E9se
         TwrIwlr8OTNQ/+4xbic7kSe5H6D3kruzbdmCenEwuUIgKASmklQtppcNihhcE/Hv0L
         nEvlIHNC1ZF8g==
Date:   Thu, 10 Mar 2022 17:08:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Jiyong Park <jiyong@google.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vsock: each transport cycles only on its own sockets
Message-ID: <20220310170853.0e07140f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310102636-mutt-send-email-mst@kernel.org>
References: <20220310135012.175219-1-jiyong@google.com>
        <20220310141420.lsdchdfcybzmdhnz@sgarzare-redhat>
        <20220310102636-mutt-send-email-mst@kernel.org>
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

On Thu, 10 Mar 2022 10:28:03 -0500 Michael S. Tsirkin wrote:
> On Thu, Mar 10, 2022 at 03:14:20PM +0100, Stefano Garzarella wrote:
> > On Thu, Mar 10, 2022 at 10:50:11PM +0900, Jiyong Park wrote:  
> > > When iterating over sockets using vsock_for_each_connected_socket, make
> > > sure that a transport filters out sockets that don't belong to the
> > > transport.
> > > 
> > > There actually was an issue caused by this; in a nested VM
> > > configuration, destroying the nested VM (which often involves the
> > > closing of /dev/vhost-vsock if there was h2g connections to the nested
> > > VM) kills not only the h2g connections, but also all existing g2h
> > > connections to the (outmost) host which are totally unrelated.
> > > 
> > > Tested: Executed the following steps on Cuttlefish (Android running on a
> > > VM) [1]: (1) Enter into an `adb shell` session - to have a g2h
> > > connection inside the VM, (2) open and then close /dev/vhost-vsock by
> > > `exec 3< /dev/vhost-vsock && exec 3<&-`, (3) observe that the adb
> > > session is not reset.
> > > 
> > > [1] https://android.googlesource.com/device/google/cuttlefish/
> > > 
> > > Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> > > Signed-off-by: Jiyong Park <jiyong@google.com>
> > > ---
> > > Changes in v3:
> > >  - Fixed the build error in vmci_transport.c
> > > Changes in v2:
> > >  - Squashed into a single patch
> > > 
> > > drivers/vhost/vsock.c            | 3 ++-
> > > include/net/af_vsock.h           | 3 ++-
> > > net/vmw_vsock/af_vsock.c         | 9 +++++++--
> > > net/vmw_vsock/virtio_transport.c | 7 +++++--
> > > net/vmw_vsock/vmci_transport.c   | 5 ++++-
> > > 5 files changed, 20 insertions(+), 7 deletions(-)  
> > 
> > It seems okay now, I ran my test suite and everything seems to be fine:
> > 
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> Thanks!
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Not a new regression so I think we should take this in the next cycle,
> let's be careful here especially since previous version was not even
> build-tested by the contributor.

Ack, our build bot ignored it as well :( 

Jiyong, would you mind collecting the tags from Stefano and Michael 
and reposting? I fixed our build bot, it should build test the patch
- I can't re-run on an already ignored patch, sadly.
