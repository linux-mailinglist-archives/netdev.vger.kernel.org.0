Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88237682340
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 05:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjAaEfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 23:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjAaEfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 23:35:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178A739BAD
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 20:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA3AB81694
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 04:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415E7C433EF;
        Tue, 31 Jan 2023 04:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675139727;
        bh=E9mLA2duMagozCCdpCTvbsleth15y2O9BuCcT1rxHoM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BVNmBhNaCo16zWNuDAE03Wcan5Xq72zQ/07pLKLGOpE4Gp+iB31OQxZSCiD7FxMiH
         u9l4P7P7u5638eA062FXIdmKz4y4ShbgPlaNHdl0TuIgGz0iIXe1q5bD17MWQ9dw3u
         15FWkifARavrNviajFFdtgZtXrKgYihiMcBMVS9BSgtUxRENORR9Y6Cyh0K8pQ/IVD
         G8grOTlAh+VHAK1GmZYUdZMJFRy3HE7wZhp26peQgPdKT6ZfbA40JH8vF8/nZ27k1O
         CuzZDKe1mnnFBVi4f0ecAGaYAqEOI9CU5RC5Rt4K0kkK1JkzEVAGDwX4Hv0SXjhtbk
         saLvDeYvPvB/A==
Date:   Mon, 30 Jan 2023 20:35:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     netdev <netdev@vger.kernel.org>, "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Message-ID: <20230130203526.52738cba@kernel.org>
In-Reply-To: <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
        <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
        <20230128003212.7f37b45c@kernel.org>
        <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Jan 2023 14:06:49 +0000 Chuck Lever III wrote:
> > On Jan 28, 2023, at 3:32 AM, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote:  
> >> I've designed a way to pass a connected kernel socket endpoint to
> >> user space using the traditional listen/accept mechanism. accept(2)
> >> gives us a well-worn building block that can materialize a connected
> >> socket endpoint as a file descriptor in a specific user space
> >> process. Like any open socket descriptor, the accepted FD can then
> >> be passed to a library such as GnuTLS to perform a TLS handshake.  
> > 
> > I can't bring myself to like the new socket family layer.  
> 
> poll/listen/accept is the simplest and most natural way of
> materializing a socket endpoint in a process that I can think
> of. It's a well-understood building block. What specifically
> is troubling you about it?

poll/listen/accept yes, but that's not the entire socket interface. 
Our overall experience with the TCP ULPs is rather painful, proxying
all the other callbacks here may add another dimension.

Also I have a fear (perhaps unjustified) of reusing constructs which are
cornerstones of the networking stack and treating them as abstractions.

> > I'd like a second opinion on that, if anyone within netdev
> > is willing to share..  
> 
> Hopefully that opinion comes with an alternative way of getting
> a connected kernel socket endpoint up to user space without
> race issues.

If the user application decides the fd, wouldn't that solve the problem
in netlink?

  kernel                          user space

   notification     ---------->
 (new connection awaits)

                    <----------
                                  request (target fd=100)

                    ---------->
   reply
 (fd 100 is installed;
  extra params)

> We need to make some progress on this. If you don't have a
> technical objection, I think we should go with this with the
> idea that eventually something more palatable will come along
> to replace it.
