Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAE4510CD3
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356196AbiDZXu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242818AbiDZXu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:50:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F1333E88;
        Tue, 26 Apr 2022 16:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53BBCB82111;
        Tue, 26 Apr 2022 23:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A101DC385A0;
        Tue, 26 Apr 2022 23:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651016834;
        bh=aldCnNd4EyeN6oO79S0ufp4A5mLgFgvG7eBHbO6bp0Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YV/uvMOOQZ+SOpxLMocOmVBQQRUgAcb+25R4Avl1bprJuYj4xUDMDANomomg7Kq17
         PXYMW1oXzKkztaE6Kh0K1gA3a5pw+VSPKIOcxxF58ITApQhovH43NSB3azVyDnvjPJ
         8HxFU+4TQisTlylymFg2gpNC/LCgCBL592Cp85+/wUhTOUrQKC0r7PfpWi1BrP/Jp1
         EZDIDzrGPsg+Kwgc9Tg4CiaNJ0ALZ/iV4JJ2cQmu3HeKQI7/8wS7B9T3cdZhBoFIUv
         1lTxjBcstBNgeHUvJt0EX5W1WLw4cuGfeq2SzQLlun5JrKE1gcwJWDnmlnsocRIRfL
         9CB+n91A6+MZg==
Date:   Tue, 26 Apr 2022 16:47:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "simo@redhat.com" <simo@redhat.com>
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220426164712.068e365c@kernel.org>
In-Reply-To: <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <E8809EC2-D49A-4171-8C88-D5E24FFA4079@oracle.com>
        <20220426075504.18be4ee2@kernel.org>
        <BA6BB8F6-3A2A-427B-A5D7-30B5F778B7E0@oracle.com>
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

On Tue, 26 Apr 2022 15:58:29 +0000 Chuck Lever III wrote:
> > On Apr 26, 2022, at 10:55 AM, Jakub Kicinski <kuba@kernel.org> wrote:
> >> The RPC-with-TLS standard allows unencrypted RPC traffic on the connection
> >> before sending ClientHello. I think we'd like to stick with creating the
> >> socket in the kernel, for this reason and for the reasons Hannes mentions
> >> in his reply.  
> > 
> > Umpf, I presume that's reviewed by security people in IETF so I guess
> > it's done right this time (tm).  
> 
> > Your wording seems careful not to imply that you actually need that,
> > tho. Am I over-interpreting?  
> 
> RPC-with-TLS requires one RPC as a "starttls" token. That could be
> done in user space as part of the handshake, but it is currently
> done in the kernel to enable the user agent to be shared with other
> kernel consumers of TLS. Keep in mind that we already have two
> real consumers: NVMe and RPC-with-TLS; and possibly QUIC.
> 
> You asserted earlier that creating sockets in user space "scales
> better" but did not provide any data. Can we see some? How well
> does it need to scale for storage protocols that use long-lived
> connections?

I meant scale with the number of possible crypto protocols, 
I mentioned three there.

> Also, why has no-one mentioned the NBD on TLS implementation to
> us before? I will try to review that code soon.

Oops, maybe that thing had never seen the light of a public mailing
list then :S Dave Watson was working on it at Facebook, but he since
moved to greener pastures.

> > This set does not even have selftests.  
> 
> I can include unit tests with the prototype. Someone needs to
> educate me on what is the preferred unit test paradigm for this
> type of subsystem. Examples in the current kernel code base would
> help too.

Whatever level of testing makes you as an engineer comfortable
with saying "this test suite is sufficient"? ;)

For TLS we have tools/testing/selftests/net/tls.c - it's hardly
an example of excellence but, you know, it catches bugs here and 
there.

> > Plus there are more protocols being actively worked on (QUIC, PSP etc.)
> > Having per ULP special sauce to invoke a user space helper is not the
> > paradigm we chose, and the time as inopportune as ever to change that.  
> 
> When we started discussing TLS handshake requirements with some
> community members several years ago, creating the socket in
> kernel and passing it up to a user agent was the suggested design.
> Has that recommendation changed since then?

Hm, do you remember who you discussed it with? Would be good 
to loop those folks in. I wasn't involved at the beginning of the 
TLS work, I know second hand that HW offload and nbd were involved 
and that the design went thru some serious re-architecting along 
the way. In the beginning there was a separate socket for control
records, and that was nacked.

But also (and perhaps most importantly) I'm not really objecting 
to creating the socket in the kernel. I'm primarily objecting to 
a second type of a special TLS socket which has TLS semantics.

> I'd prefer an in-kernel handshake implementation over a user
> space one (even one that is sharable amongst transports and ULPs
> as my proposal is intended to be). However, so far we've been told
> that an in-kernel handshake implementation is a non-starter.
> 
> But in the abstract, we agree that having a single TLS handshake
> mechanism for kernel consumers is preferable.

For some definition of "we" which doesn't not include me?
