Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAE4692975
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 22:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbjBJVoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 16:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjBJVoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 16:44:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB693A09D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 13:44:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54F40B825C8
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 21:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61A5C433EF;
        Fri, 10 Feb 2023 21:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676065457;
        bh=p8ahhDJ3SnF4DIXergbrgSIvoxxXjiU9v7L1/ADG02M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DpnHBcIRLRkXIbkkwEdFELpwjJecgZ0jVyc9m6wAY4xiWgVb47kd4ggDGNBrrfXCs
         R6ADse+qhGcbmRD0WzcdXGcVX3XN+XuqiV0/+BCi+2vFPwMM2iaTOo3sOvNaBnqR/S
         RSRHqe3OgFNfRym0WT0Ykqig9A8Pl5Cm3jvUF0ybboIR71cZNOMA1klYR/DtdFYWX6
         zBsOL2ASRz0AUKOpyJ2TUM3LSGs9C+M5NFCnCGQEsjxkTMl6YV2fWOWw3MjEv0pwFy
         rt3OhPYDyUJt++rgLWf/2FOWS/Qao5LHGu/kXzYT3nVx5h0BtpmmW/oE9phlgxwycm
         rPNepRzSMp67w==
Date:   Fri, 10 Feb 2023 13:44:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230210134416.0391f272@kernel.org>
In-Reply-To: <1B1298B2-C884-48BA-A4E8-BBB95C42786B@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
        <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
        <20230208220025.0c3e6591@kernel.org>
        <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
        <20230209180727.0ec328dd@kernel.org>
        <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
        <20230210100915.3fde31dd@kernel.org>
        <1B1298B2-C884-48BA-A4E8-BBB95C42786B@oracle.com>
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

On Fri, 10 Feb 2023 19:04:34 +0000 Chuck Lever III wrote:
> >> v2 of the series used generic netlink for the downcall piece.
> >> I can convert back to using generic netlink for v4 of the
> >> series.  
> > 
> > Would you be able to write the spec for it? I'm happy to help with that
> > as I mentioned.  
> 
> I'm coming from an RPC background, we usually do start from an
> XDR protocol specification. So, I'm used to that, and it might
> give us some new ideas about protocol correctness or
> simplification.

Nice, our thing is completely homegrown and unprofessional.
Hopefully it won't make you run away.

> Point me to a sample spec or maybe a language reference and we
> can discuss it further.

There are only two specs so far in net-next:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/netlink/specs

Neither of these is great (fou is a bit legacy, and ethtool is not
fully expressed), a better example may be this one which is pending 
in the bpf-next tree:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/Documentation/netlink/specs/netdev.yaml

There is a JSON schema spec (which may be useful for checking available
fields quickly):

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/netlink/genetlink.yaml

And (uncharacteristically?), docs:

https://docs.kernel.org/next/userspace-api/netlink/index.html

> > Perhaps you have the user space already hand-written
> > here but in case the mechanism/family gets reused it'd be sad if people
> > had to hand write bindings for other programming languages.  
> 
> Yes, the user space implementation is currently hand-written C,
> but it can easily be converted to machine-generated if you have
> a favorite tool to do that.

I started hacking on a code generator for C in net-next in
tools/net/ynl/ynl-gen-c.py but it's likely bitrotted already.
I don't actually have a strong user in C to justify the time
investment. All the cool kids these days want to use Rust or Go
(and the less cool C++). For development I use Python
(tools/net/ynl/cli.py tools/net/ynl/lib/).

It should work fairly well for generating the kernel bits 
(uAPI header, policy and op tables).
