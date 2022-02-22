Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18624C02C4
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 21:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbiBVUDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 15:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiBVUDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 15:03:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452F7CD5DB;
        Tue, 22 Feb 2022 12:03:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9BB1B80AD0;
        Tue, 22 Feb 2022 20:03:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44D2C340E8;
        Tue, 22 Feb 2022 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645560183;
        bh=bARya+5AojzCiqimk+yisv0RgHtnw56CKKTarijTxmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y/AhqouUMfcglgJ6gxXppwvkehVW7t0SWEsn6Kupq2EIQ9rTu4WOY9fum5gOylfr8
         pG8K2RVIBnpbKnOBgEc67J5/4ghNPan17C4eNnpIdAYRM04B6SweKkmkJHpi83gRf+
         3Exn0pPGoe4tcRVzkuYMpHRWsFz4uz8GGenF8ziOxCjDa/54lio8Yjl4f0BSeASGAT
         yCAdjKdlMU7ebNthUBFt07J8+AEEyIRLeSNmn2fDMjOaKTV8b2udtC/e0L/GsxSksk
         HFmovAgOFO5oJHu1WuHwLUc3opu+FbnXzCeqEWIR6c/rp8UnvMTixfpsbAnVdGbM2t
         9U8zDZOC67y6w==
Date:   Tue, 22 Feb 2022 12:03:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Juergen Gross <jgross@suse.com>,
        Marek =?UTF-8?B?TWFyY3p5a293c2tpLUc=?= =?UTF-8?B?w7NyZWNraQ==?= 
        <marmarek@invisiblethingslab.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        "moderated list:XEN HYPERVISOR INTERFACE" 
        <xen-devel@lists.xenproject.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] xen/netfront: destroy queues before real_num_tx_queues
 is zeroed
Message-ID: <20220222120301.10af2737@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
References: <20220220134202.2187485-1-marmarek@invisiblethingslab.com>
        <3786b4ef-68e7-5735-0841-fcbae07f7e54@suse.com>
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

On Mon, 21 Feb 2022 07:27:32 +0100 Juergen Gross wrote:
> On 20.02.22 14:42, Marek Marczykowski-G=C3=B3recki wrote:
> > xennet_destroy_queues() relies on info->netdev->real_num_tx_queues to
> > delete queues. Since d7dac083414eb5bb99a6d2ed53dc2c1b405224e5
> > ("net-sysfs: update the queue counts in the unregistration path"),
> > unregister_netdev() indirectly sets real_num_tx_queues to 0. Those two
> > facts together means, that xennet_destroy_queues() called from
> > xennet_remove() cannot do its job, because it's called after
> > unregister_netdev(). This results in kfree-ing queues that are still
> > linked in napi, which ultimately crashes:
> >=20
> >      BUG: kernel NULL pointer dereference, address: 0000000000000000
> >      #PF: supervisor read access in kernel mode
> >      #PF: error_code(0x0000) - not-present page
> >      PGD 0 P4D 0
> >      Oops: 0000 [#1] PREEMPT SMP PTI
> >      CPU: 1 PID: 52 Comm: xenwatch Tainted: G        W         5.16.10-=
1.32.fc32.qubes.x86_64+ #226
> >      RIP: 0010:free_netdev+0xa3/0x1a0
> >      Code: ff 48 89 df e8 2e e9 00 00 48 8b 43 50 48 8b 08 48 8d b8 a0 =
fe ff ff 48 8d a9 a0 fe ff ff 49 39 c4 75 26 eb 47 e8 ed c1 66 ff <48> 8b 8=
5 60 01 00 00 48 8d 95 60 01 00 00 48 89 ef 48 2d 60 01 00
> >      RSP: 0000:ffffc90000bcfd00 EFLAGS: 00010286
> >      RAX: 0000000000000000 RBX: ffff88800edad000 RCX: 0000000000000000
> >      RDX: 0000000000000001 RSI: ffffc90000bcfc30 RDI: 00000000ffffffff
> >      RBP: fffffffffffffea0 R08: 0000000000000000 R09: 0000000000000000
> >      R10: 0000000000000000 R11: 0000000000000001 R12: ffff88800edad050
> >      R13: ffff8880065f8f88 R14: 0000000000000000 R15: ffff8880066c6680
> >      FS:  0000000000000000(0000) GS:ffff8880f3300000(0000) knlGS:000000=
0000000000
> >      CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >      CR2: 0000000000000000 CR3: 00000000e998c006 CR4: 00000000003706e0
> >      Call Trace:
> >       <TASK>
> >       xennet_remove+0x13d/0x300 [xen_netfront]
> >       xenbus_dev_remove+0x6d/0xf0
> >       __device_release_driver+0x17a/0x240
> >       device_release_driver+0x24/0x30
> >       bus_remove_device+0xd8/0x140
> >       device_del+0x18b/0x410
> >       ? _raw_spin_unlock+0x16/0x30
> >       ? klist_iter_exit+0x14/0x20
> >       ? xenbus_dev_request_and_reply+0x80/0x80
> >       device_unregister+0x13/0x60
> >       xenbus_dev_changed+0x18e/0x1f0
> >       xenwatch_thread+0xc0/0x1a0
> >       ? do_wait_intr_irq+0xa0/0xa0
> >       kthread+0x16b/0x190
> >       ? set_kthread_struct+0x40/0x40
> >       ret_from_fork+0x22/0x30
> >       </TASK>
> >=20
> > Fix this by calling xennet_destroy_queues() from xennet_close() too,
> > when real_num_tx_queues is still available. This ensures that queues are
> > destroyed when real_num_tx_queues is set to 0, regardless of how
> > unregister_netdev() was called.
> >=20
> > Originally reported at
> > https://github.com/QubesOS/qubes-issues/issues/7257
> >=20
> > Fixes: d7dac083414eb5bb9 ("net-sysfs: update the queue counts in the un=
registration path")
> > Cc: stable@vger.kernel.org # 5.16+
> > Signed-off-by: Marek Marczykowski-G=C3=B3recki <marmarek@invisiblething=
slab.com>
> >=20
> > ---
> > While this fixes the issue, I'm not sure if that is the correct thing
> > to do. xennet_remove() calls xennet_destroy_queues() under rtnl_lock,
> > which may be important here? Just moving xennet_destroy_queues() before=
 =20
>=20
> I checked some of the call paths leading to xennet_close(), and all of
> those contained an ASSERT_RTNL(), so it seems the rtnl_lock is already
> taken here. Could you test with adding an ASSERT_RTNL() in
> xennet_destroy_queues()?
>=20
> > unregister_netdev() in xennet_remove() did not helped - it crashed in
> > another way (use-after-free in xennet_close()). =20
>=20
> Yes, this would need to basically do the xennet_close() handling in
> xennet_destroy() instead, which I believe is not really an option.

I think the patch makes open/close asymmetric, tho. After ifup ; ifdown;
the next ifup will fail because queues are already destroyed, no?
IOW xennet_open() expects the queues were created at an earlier stage.

Maybe we can move the destroy to ndo_uninit? (and create to ndo_init?)
