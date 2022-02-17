Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7E4B977D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233618AbiBQEPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:15:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbiBQEPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:15:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD9123BF21;
        Wed, 16 Feb 2022 20:15:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B4D3B81133;
        Thu, 17 Feb 2022 04:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7628C340E9;
        Thu, 17 Feb 2022 04:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645071301;
        bh=YRRLpw0VKlcqtm9MnJNQWnaNd7iJ03Cx31KvjzoR9Z4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pamwRqLxudVb4gak4TrKQxoID4pOFctV7GraLEY0TbnuLdcaupVd5/9BvQqYSoCvS
         GS1GnktWxFONFJUfZH90R6DwgQIMVjnFjbrb6G94j/QoG3cJsSFUC1oQwNbrcsLDQF
         t53SkrM53tcxveN8Aeyh0PjKNgU9OO4tbKPq0h03hCxz+RKBUTK2WapEhoT7gkXEEY
         uW+KAH0QDohW99PonSbAOgCOcMfpf1A2GFYVLri9nvaoBwJHxOUTa1eeCW1ILiBBlu
         wn+FtYmXBvCAk/W6h3xC0Yq4kIh+CwhjyfRMo9Zq15z9SGt86g4TYB/tKviBUGYAhN
         XlCqfUN1s5mLQ==
Date:   Wed, 16 Feb 2022 20:14:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Seth Forshee <sforshee@digitalocean.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vsock: remove vsock from connected table when connect
 is interrupted by a signal
Message-ID: <20220216201459.5a5b58e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216161122.eacdfgljg2c6yeby@sgarzare-redhat>
References: <20220216143222.1614690-1-sforshee@digitalocean.com>
        <20220216161122.eacdfgljg2c6yeby@sgarzare-redhat>
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

On Wed, 16 Feb 2022 17:11:22 +0100 Stefano Garzarella wrote:
> On Wed, Feb 16, 2022 at 08:32:22AM -0600, Seth Forshee wrote:
> >vsock_connect() expects that the socket could already be in the
> >TCP_ESTABLISHED state when the connecting task wakes up with a signal
> >pending. If this happens the socket will be in the connected table, and
> >it is not removed when the socket state is reset. In this situation it's
> >common for the process to retry connect(), and if the connection is
> >successful the socket will be added to the connected table a second
> >time, corrupting the list.
> >
> >Prevent this by calling vsock_remove_connected() if a signal is received
> >while waiting for a connection. This is harmless if the socket is not in
> >the connected table, and if it is in the table then removing it will
> >prevent list corruption from a double add.
> >
> >Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> >---
> > net/vmw_vsock/af_vsock.c | 1 +
> > 1 file changed, 1 insertion(+)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 3235261f138d..38baeb189d4e 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -1401,6 +1401,7 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> > 			sk->sk_state = sk->sk_state == TCP_ESTABLISHED ? TCP_CLOSING : TCP_CLOSE;
> > 			sock->state = SS_UNCONNECTED;
> > 			vsock_transport_cancel_pkt(vsk);
> >+			vsock_remove_connected(vsk);
> > 			goto out_wait;
> > 		} else if (timeout == 0) {
> > 			err = -ETIMEDOUT;
> 
> Thanks for this fix! The patch LGTM:
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> 
> @Dave, @Jakub, since we need this also in stable branches, I was going 
> to suggest adding a Fixes tag, but I'm a little confused: the issue 
> seems to have always been there, so from commit d021c344051a ("VSOCK: 
> Introduce VM Sockets"), but to use vsock_remove_connected() as we are 
> using in this patch, we really need commit d5afa82c977e ("vsock: correct 
> removal of socket from the list").
> 
> Commit d5afa82c977e was introduces in v5.3 and it was backported in 
> v4.19 and v4.14, but not in v4.9.
> So if we want to backport this patch also for v4.9, I think we need 
> commit d5afa82c977e as well.

The fixes tag sounds good. Dunno what's the best way to handle this
case. We can add a mention of the dependency to the patch description.
Personally I'd keep things simple, add the Fixes tag and keep an eye
on the backports, if 4.9 doesn't get it - email Greg and explain.
