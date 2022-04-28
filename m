Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39168513D11
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352040AbiD1VMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345697AbiD1VMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:12:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7225AC12D1;
        Thu, 28 Apr 2022 14:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A31B80A28;
        Thu, 28 Apr 2022 21:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDDEC385AE;
        Thu, 28 Apr 2022 21:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651180137;
        bh=HVPy76Yg+bdxuKL5woSF5+gfC8sMIj9SdmIRCNtoYqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nOOPUx3Kp8sKWVlPey4kWhXdNbXoO7nBy7LEdobS/D5QyFIU2dA7Dy2Rwpu2KBgcz
         j8s99zugBkisq5zlVLch9LgJqCzQNRI+wzpkv6FafX4StqPXH2FpzM6c1xnAVe9jmh
         PkqzSD0COvis+Gkjrvtj4nYwX95vXGT0KGFcy0xmyBL0QrIEMPegVCpuT4LKy1sQuZ
         E9Y3lfQNgBN7tU5YjqoP2nJShG+wERHlXwGVcxKlNdC6u7sBVdfda3gR7DsnGCiT1t
         3FeZ9kBstmSIl9+Ktj/ZJl36KLx1PbNqNwU7HD0Y0ES7MY9nG/NzF5klHlaM1DPoAW
         3OP/ayXwJnKgg==
Date:   Thu, 28 Apr 2022 14:08:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Benjamin Coddington" <bcodding@redhat.com>
Cc:     "Hannes Reinecke" <hare@suse.de>,
        "Sagi Grimberg" <sagi@grimberg.me>,
        "Chuck Lever" <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com,
        dev@openvswitch.org
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220428140856.61e53533@kernel.org>
In-Reply-To: <E2BF9CFF-9361-400B-BDEE-CF5E0AFDCA63@redhat.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
        <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
        <20220426080247.19bbb64e@kernel.org>
        <40bc060f-f359-081d-9ba7-fae531cf2cd6@suse.de>
        <20220426170334.3781cd0e@kernel.org>
        <23f497ab-08e3-3a25-26d9-56d94ee92cde@suse.de>
        <20220428063009.0a63a7f9@kernel.org>
        <be7e3c4b-8bb5-e818-1402-ac24cbbcb38c@suse.de>
        <E2BF9CFF-9361-400B-BDEE-CF5E0AFDCA63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 10:09:17 -0400 Benjamin Coddington wrote:
> > Noob reply: wish I knew.  (I somewhat hoped _you_ would've been able to
> > tell me.)
> >
> > Thing is, the only method I could think of for fd passing is the POSIX fd
> > passing via unix_attach_fds()/unix_detach_fds().  But that's AF_UNIX,
> > which really is designed for process-to-process communication, not
> > process-to-kernel.  So you probably have to move a similar logic over to
> > AF_NETLINK. And design a new interface on how fds should be passed over
> > AF_NETLINK.
> >
> > But then you have to face the issue that AF_NELINK is essentially UDP, and
> > you have _no_ idea if and how many processes do listen on the other end.
> > Thing is, you (as the sender) have to copy the fd over to the receiving
> > process, so you'd better _hope_ there is a receiving process.  Not to
> > mention that there might be several processes listening in...

Sort of. I double checked the netlink upcall implementations we have,
they work by user space entity "registering" their netlink address
(portid) at startup. Kernel then directs the upcalls to that address.
But AFAICT there's currently no way for the netlink "server" to see
when a "client" goes away, which makes me slightly uneasy about using
such schemes for security related stuff. The user agent may crash and
something else could grab the same address, I think.

Let me CC OvS who uses it the most, perhaps I'm missing a trick.

My thinking was to use the netlink attribute format (just to reuse the
helpers and parsing, but we can invent a new TLV format if needed) but
create a new socket type specifically for upcalls.

> > And that's something I _definitely_ don't feel comfortable with without
> > guidance from the networking folks, so I didn't pursue it further and we
> > went with the 'accept()' mechanism Chuck implemented.
> >
> > I'm open to suggestions, though.  
> 
> EXPORT_SYMBOL(receive_fd) would allow interesting implementations.
> 
> The kernel keyring facilities have a good API for creating various key_types
> which are able to perform work such as this from userspace contexts.
> 
> I have a working prototype for a keyring key instantiation which allows a
> userspace process to install a kernel fd on its file table.  The problem
> here is how to match/route such fd passing to appropriate processes in
> appropriate namespaces.  I think this problem is shared by all
> kernel-to-userspace upcalls, which I hope we can discuss at LSF/MM.

Almost made me wish I was coming to LFS/MM :)

> I don't think kernel fds are very special as compared to userspace fds.
