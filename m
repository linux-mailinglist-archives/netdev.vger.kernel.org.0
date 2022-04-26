Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3151014C
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351874AbiDZPGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348182AbiDZPF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:05:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF9F6D4FA;
        Tue, 26 Apr 2022 08:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37C71618B3;
        Tue, 26 Apr 2022 15:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A504C385AC;
        Tue, 26 Apr 2022 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650985369;
        bh=UqLxJFH9O9G7EGONJdF7zaPGDT+Gp5Rj4MUtQs90Rw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AffRiqDdE3sz/LCauzO5r2DR1u8X3ZBhcg7XT7VKTU3vrSH6dNifdcC9oPMhnaaRD
         tooa/9C3ApCFhD//EgeHVZ82iVkKzlYd2B6UqG57bnBNJ0fPNqq6OhT/hX0c5vDWeh
         rgfmRxorcK/qZvO1uhoIRGxhWmZumkGnIeQXAV1Tf0QSVEqf9IVRlvkmQOcSCXdhy8
         0J9ZWL6F67+N2w8N8QWxhosFSa49dwqVNg3/FVKrcvf/IpkP/UKcxgzgEYl7pzBJwa
         ++gNj9yu0l2OoOLlPC4pNJ0y7KuGlv4TJ5jfpzGVJ/jrYBuytNv8GWIdigaG0WTmsx
         eQ7dmMOvblH/w==
Date:   Tue, 26 Apr 2022 08:02:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Hannes Reinecke <hare@suse.de>,
        Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ak@tempesta-tech.com, borisp@nvidia.com, simo@redhat.com
Subject: Re: [PATCH RFC 4/5] net/tls: Add support for PF_TLSH (a TLS
 handshake listener)
Message-ID: <20220426080247.19bbb64e@kernel.org>
In-Reply-To: <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
References: <165030051838.5073.8699008789153780301.stgit@oracle-102.nfsv4.dev>
        <165030059051.5073.16723746870370826608.stgit@oracle-102.nfsv4.dev>
        <20220425101459.15484d17@kernel.org>
        <66077b73-c1a4-d2ae-c8e4-3e19e9053171@suse.de>
        <1fca2eda-83e4-fe39-13c8-0e5e7553689b@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 17:29:03 +0300 Sagi Grimberg wrote:
> >> Create the socket in user space, do all the handshakes you need there
> >> and then pass it to the kernel.=C2=A0 This is how NBD + TLS works.=C2=
=A0 Scales
> >> better and requires much less kernel code.
> >> =20
> > But we can't, as the existing mechanisms (at least for NVMe) creates th=
e=20
> > socket in-kernel.
> > Having to create the socket in userspace would require a completely new=
=20
> > interface for nvme and will not be backwards compatible. =20
>=20
> And we will still need the upcall anyways when we reconnect=20
> (re-establish the socket)

That totally flew over my head, I have zero familiarity with in-kernel
storage network users :S

In all honesty the tls code in the kernel is a bit of a dumping ground.
People come, dump a bunch of code and disappear. Nobody seems to care
that the result is still (years in) not ready for production use :/
Until a month ago it'd break connections even under moderate memory
pressure. This set does not even have selftests.

Plus there are more protocols being actively worked on (QUIC, PSP etc.)
Having per ULP special sauce to invoke a user space helper is not the
paradigm we chose, and the time as inopportune as ever to change that.
