Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100405961F9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 20:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiHPSHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 14:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236912AbiHPSHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 14:07:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FD185A82;
        Tue, 16 Aug 2022 11:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B644861384;
        Tue, 16 Aug 2022 18:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8882BC433D7;
        Tue, 16 Aug 2022 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660673239;
        bh=wdC60JNH+NYxDVMOzJ91ehWnODXNaR5QzNelPAKX9ls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sIAWpl0S9Dol1xjrzZ7uMx84IAHw9Eqgp40WK17hroEzpOME8bkRYBTNWdBPkZKx/
         7J3H3tYgB4ycNm0VV7DA3PEWa7ULBhg9DOfdzY62rcOo9yNi71dbxNFM5bpONFI8OX
         /pTJnNg2PwZuGyQrWhp4XhYxBqSf+i4KBwAJjH8kumxLzpIqU5dIQTWP3zx1VLM3by
         EVBmvQGvARPfgLcdX5A6ebghntShyq4uF/t9Mp+MNW9i9TZFJugpZfrGfzmxiFSwKc
         L2/gB7+7b/3DcIeWOBQOjYG09UUKH724ulP97ljfJ6T752ShJ7qzYN+nBFu95tXOk3
         lWRYS97zVVaxQ==
Date:   Tue, 16 Aug 2022 11:07:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] vsock: add netdev to vhost/virtio vsock
Message-ID: <20220816110717.5422e976@kernel.org>
In-Reply-To: <20220816123701-mutt-send-email-mst@kernel.org>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
        <5a93c5aad99d79f028d349cb7e3c128c65d5d7e2.1660362668.git.bobby.eshleman@bytedance.com>
        <20220816123701-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Aug 2022 12:38:52 -0400 Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 10:56:06AM -0700, Bobby Eshleman wrote:
> > In order to support usage of qdisc on vsock traffic, this commit
> > introduces a struct net_device to vhost and virtio vsock.
> >=20
> > Two new devices are created, vhost-vsock for vhost and virtio-vsock
> > for virtio. The devices are attached to the respective transports.
> >=20
> > To bypass the usage of the device, the user may "down" the associated
> > network interface using common tools. For example, "ip link set dev
> > virtio-vsock down" lets vsock bypass the net_device and qdisc entirely,
> > simply using the FIFO logic of the prior implementation. =20
>=20
> Ugh. That's quite a hack. Mark my words, at some point we will decide to
> have down mean "down".  Besides, multiple net devices with link up tend
> to confuse userspace. So might want to keep it down at all times
> even short term.

Agreed!

=46rom a cursory look (and Documentation/ would be nice..) it feels
very wrong to me. Do you know of any uses of a netdev which would=20
be semantically similar to what you're doing? Treating netdevs as
buildings blocks for arbitrary message passing solutions is something=20
I dislike quite strongly.

Could you recommend where I can learn more about vsocks?
