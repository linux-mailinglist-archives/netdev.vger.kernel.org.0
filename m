Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B7E4AC6A6
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345381AbiBGRAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343527AbiBGQxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:53:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF88C0401D1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:53:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6505C60F7A
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 16:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957D3C004E1;
        Mon,  7 Feb 2022 16:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644252792;
        bh=9xgrwPEn/g4YyYx554mF8FNtm4bXKbSfRxz7jPbPSPc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q1iDppTosDHWlbyyBKPXQxZwdXU2wy56KHeYkvFMAy87DJ5D9sIZyL+StkVu01x8d
         7eRacYKUxbjMVy3ATBiyoTdTm4S0ji/XRFyn0lpw8eSlos7CTgo1OD7BoQ50+AA25T
         MmvE0Ofq68EgqhJY8nJcCDxIc5dpR/F62rfVMyam4gcQJiKUpkFtazt2rgJCJKj9Xe
         DmrgsO3sNWyhmCOST7QaZVh5iao4y1BIRhl/Sw9Oyz7btc8vZl5+TB382bGGc4Zdqj
         7hKFCvULlHoUp4qT6Z45r8DLmUYffKcmHR8+q1WTgLpwdTBNyuPFJd8BgUQ5wA8d9y
         7vmnOPGB+rC8g==
Date:   Mon, 7 Feb 2022 08:53:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
Message-ID: <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
        <20220128151922.1016841-2-ihuguet@redhat.com>
        <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Mon, 7 Feb 2022 16:03:01 +0100 =C3=8D=C3=B1igo Huguet wrote:
> On Fri, Jan 28, 2022 at 11:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 28 Jan 2022 16:19:21 +0100 =C3=8D=C3=B1igo Huguet wrote: =20
> > > Handling channels from CPUs in different NUMA node can penalize
> > > performance, so better configure only one channel per core in the same
> > > NUMA node than the NIC, and not per each core in the system.
> > >
> > > Fallback to all other online cores if there are not online CPUs in lo=
cal
> > > NUMA node. =20
> >
> > I think we should make netif_get_num_default_rss_queues() do a similar
> > thing. Instead of min(8, num_online_cpus()) we should default to
> > num_cores / 2 (that's physical cores, not threads). From what I've seen
> > this appears to strike a good balance between wasting resources on
> > pointless queues per hyperthread, and scaling up for CPUs which have
> > many wimpy cores.
> > =20
>=20
> I have a few busy weeks coming, but I can do this after that.
>=20
> With num_cores / 2 you divide by 2 because you're assuming 2 NUMA
> nodes, or just the plain number 2?

Plain number 2, it's just a heuristic which seems to work okay.
One queue per core (IOW without the /2) is still way too many queues
for normal DC workloads.
