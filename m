Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533176E9B2A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDTSAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjDTSAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCD41BF6
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17E64617BF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013C8C433EF;
        Thu, 20 Apr 2023 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682013609;
        bh=LS09uxLJbf9LC+lghJxGrWQzyC2mmc3DRvkV0UgAGrU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCWYSmgQ+7oh8bjf0gbDhNepTGdoAzsPLigf16Rz7ZCrgrog2X/Cs7KGDzPgCVxCk
         Elg3b2DcJ1E67L0Ni8pPYT5o5DcBj23vgZ7PHPGj+XbPZ0vzMHExqMbosWRBb65oVy
         10sjxTIJqwVUunlPVZdiSyZwlquDN8ksJV0APm+NGRXESpwFB+j2O+8+ah1tWFNOHN
         Hrnp8wj2TMvY5asAce2SSWC45dQGv4yVvXasUWUqZbVrLVjEf3VKBNO7IxDvVj+Nfc
         Gwo7oEJcY3Cpft212szx6aocWCPrnyagcRxTNnhFqKTYj8JWunOWC4QWf8/sGvCva0
         4/ZM0Wj/yPNMQ==
Date:   Thu, 20 Apr 2023 11:00:07 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v10 2/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230420180007.GA2836977@dev-arch.thelio-3990X>
References: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
 <168174194627.9520.9141674093687429487.stgit@91.116.238.104.host.secureserver.net>
 <20230420175638.GA2835317@dev-arch.thelio-3990X>
 <7AF72C2D-32CC-4A5E-89BD-07704A6A19D3@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7AF72C2D-32CC-4A5E-89BD-07704A6A19D3@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 05:57:44PM +0000, Chuck Lever III wrote:
> 
> 
> > On Apr 20, 2023, at 1:56 PM, Nathan Chancellor <nathan@kernel.org> wrote:
> > 
> > Hi Chuck,
> > 
> > On Mon, Apr 17, 2023 at 10:32:26AM -0400, Chuck Lever wrote:
> >> From: Chuck Lever <chuck.lever@oracle.com>
> >> 
> >> When a kernel consumer needs a transport layer security session, it
> >> first needs a handshake to negotiate and establish a session. This
> >> negotiation can be done in user space via one of the several
> >> existing library implementations, or it can be done in the kernel.
> >> 
> >> No in-kernel handshake implementations yet exist. In their absence,
> >> we add a netlink service that can:
> >> 
> >> a. Notify a user space daemon that a handshake is needed.
> >> 
> >> b. Once notified, the daemon calls the kernel back via this
> >>   netlink service to get the handshake parameters, including an
> >>   open socket on which to establish the session.
> >> 
> >> c. Once the handshake is complete, the daemon reports the
> >>   session status and other information via a second netlink
> >>   operation. This operation marks that it is safe for the
> >>   kernel to use the open socket and the security session
> >>   established there.
> >> 
> >> The notification service uses a multicast group. Each handshake
> >> mechanism (eg, tlshd) adopts its own group number so that the
> >> handshake services are completely independent of one another. The
> >> kernel can then tell via netlink_has_listeners() whether a handshake
> >> service is active and prepared to handle a handshake request.
> >> 
> >> A new netlink operation, ACCEPT, acts like accept(2) in that it
> >> instantiates a file descriptor in the user space daemon's fd table.
> >> If this operation is successful, the reply carries the fd number,
> >> which can be treated as an open and ready file descriptor.
> >> 
> >> While user space is performing the handshake, the kernel keeps its
> >> muddy paws off the open socket. A second new netlink operation,
> >> DONE, indicates that the user space daemon is finished with the
> >> socket and it is safe for the kernel to use again. The operation
> >> also indicates whether a session was established successfully.
> >> 
> >> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> > ...
> >> net/handshake/netlink.c                    |  312 ++++++++++++++++++++++++++
> > ...
> >> +static struct pernet_operations __net_initdata handshake_genl_net_ops = {
> >> + .init = handshake_net_init,
> >> + .exit = handshake_net_exit,
> >> + .id = &handshake_net_id,
> >> + .size = sizeof(struct handshake_net),
> >> +};
> > ...
> >> +static void __exit handshake_exit(void)
> >> +{
> >> + unregister_pernet_subsys(&handshake_genl_net_ops);
> >> + handshake_net_id = 0;
> >> +
> >> + handshake_req_hash_destroy();
> >> + genl_unregister_family(&handshake_nl_family);
> >> +}
> >> +
> >> +module_init(handshake_init);
> >> +module_exit(handshake_exit);
> > 
> > I am not sure if this has been reported yet but it appears this
> > introduces a section mismatch warning in several configurations
> > according to KernelCI:
> > 
> > https://lore.kernel.org/6441748e.170a0220.531bd.8013@mx.google.com/
> > 
> >  $ make -skj"$(nproc)" ARCH=mips CROSS_COMPILE=mips-linux- O=build jazz_defconfig all
> >  ...
> >  WARNING: modpost: vmlinux.o: section mismatch in reference: handshake_exit (section: .exit.text) -> handshake_genl_net_ops (section: .init.data)
> > 
> > I guess '__net_initdata' should be dropped from handshake_genl_net_ops?
> 
> Thanks, Geert just sent a patch to fix that.

Ha, I did check lore for an existing report or patch before I wrote the
mail but not before I sent it... Sorry for the noise!

Cheers,
Nathan
