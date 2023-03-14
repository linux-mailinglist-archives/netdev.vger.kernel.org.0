Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A296B9CA9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbjCNRNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjCNRN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:13:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AD5B2558;
        Tue, 14 Mar 2023 10:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39A936184A;
        Tue, 14 Mar 2023 17:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C34BC433D2;
        Tue, 14 Mar 2023 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678813994;
        bh=3EG/KqnCYBhNqm2nyk0gyujI8TGKF/mLi6HG6scr/GA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U6vcq4phSJfbDANhHI1VBRfknuhY8hZCiyMl9EQadyaSebAPx37rxi4g/cHiWLh0d
         Q8CStGViTHBh1U+gduchsYj52Z1UpuyQ60anuoSegizHXHm68uA5g5XMwXMNieO3RF
         gkAP6Ks8lxZ+8dxBXJH4gDy6l7vtfGVF5RXuEj//99pu6e8cx+nSGREvn10yUGBuyL
         y1Ju5HEpe4X5TWpQp1CWblHYmduA4as2JnuqOPePKN38kAxikxnhC7vZ522s/IqF/F
         1zp9iVKjl+erQrGnzwPEsUOQ+hQ20JHjRZCJqY01LKe1yTOKEuY/i3GAkl5R79C6XO
         pKziX5FHk4Whg==
Date:   Tue, 14 Mar 2023 18:13:10 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Shawn Bohrer <sbohrer@cloudflare.com>
Cc:     toshiaki.makita1@gmail.com, toke@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH] veth: Fix use after free in XDP_REDIRECT
Message-ID: <ZBCrJhy6TAi8fE15@lore-desk>
References: <ZBCSAsUBeNvTPj/s@JNXK7M3>
 <20230314153351.2201328-1-sbohrer@cloudflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IRIFQ0q/8cliYCNI"
Content-Disposition: inline
In-Reply-To: <20230314153351.2201328-1-sbohrer@cloudflare.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IRIFQ0q/8cliYCNI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> 718a18a0c8a67f97781e40bdef7cdd055c430996 "veth: Rework veth_xdp_rcv_skb
> in order to accept non-linear skb" introduced a bug where it tried to
> use pskb_expand_head() if the headroom was less than
> XDP_PACKET_HEADROOM.  This however uses kmalloc to expand the head,
> which will later allow consume_skb() to free the skb while is it still
> in use by AF_XDP.
>=20
> Previously if the headroom was less than XDP_PACKET_HEADROOM we
> continued on to allocate a new skb from pages so this restores that
> behavior.
>=20
> BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
> Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
>=20
> CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G        =
   O       6.1.4-cloudflare-kasan-2023.1.2 #1
> Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3=
B10.03 06/21/2018
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x34/0x48
>   print_report+0x170/0x473
>   ? __xsk_rcv+0x18d/0x2c0
>   kasan_report+0xad/0x130
>   ? __xsk_rcv+0x18d/0x2c0
>   kasan_check_range+0x149/0x1a0
>   memcpy+0x20/0x60
>   __xsk_rcv+0x18d/0x2c0
>   __xsk_map_redirect+0x1f3/0x490
>   ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>   xdp_do_redirect+0x5ca/0xd60
>   veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
>   ? __netif_receive_skb_list_core+0x671/0x920
>   ? veth_xdp+0x670/0x670 [veth]
>   veth_xdp_rcv+0x304/0xa20 [veth]
>   ? do_xdp_generic+0x150/0x150
>   ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
>   ? _raw_spin_lock_bh+0xe0/0xe0
>   ? newidle_balance+0x887/0xe30
>   ? __perf_event_task_sched_in+0xdb/0x800
>   veth_poll+0x139/0x571 [veth]
>   ? veth_xdp_rcv+0xa20/0xa20 [veth]
>   ? _raw_spin_unlock+0x39/0x70
>   ? finish_task_switch.isra.0+0x17e/0x7d0
>   ? __switch_to+0x5cf/0x1070
>   ? __schedule+0x95b/0x2640
>   ? io_schedule_timeout+0x160/0x160
>   __napi_poll+0xa1/0x440
>   napi_threaded_poll+0x3d1/0x460
>   ? __napi_poll+0x440/0x440
>   ? __kthread_parkme+0xc6/0x1f0
>   ? __napi_poll+0x440/0x440
>   kthread+0x2a2/0x340
>   ? kthread_complete_and_exit+0x20/0x20
>   ret_from_fork+0x22/0x30
>   </TASK>
>=20
> Freed by task 148640:
>   kasan_save_stack+0x23/0x50
>   kasan_set_track+0x21/0x30
>   kasan_save_free_info+0x2a/0x40
>   ____kasan_slab_free+0x169/0x1d0
>   slab_free_freelist_hook+0xd2/0x190
>   __kmem_cache_free+0x1a1/0x2f0
>   skb_release_data+0x449/0x600
>   consume_skb+0x9f/0x1c0
>   veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
>   veth_xdp_rcv+0x304/0xa20 [veth]
>   veth_poll+0x139/0x571 [veth]
>   __napi_poll+0xa1/0x440
>   napi_threaded_poll+0x3d1/0x460
>   kthread+0x2a2/0x340
>   ret_from_fork+0x22/0x30
>=20
> The buggy address belongs to the object at ffff888976250000
>   which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 340 bytes inside of
>   2048-byte region [ffff888976250000, ffff888976250800)
>=20
> The buggy address belongs to the physical page:
> page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 inde=
x:0x0 pfn:0x976250
> head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
> flags: 0x2ffff800010200(slab|head|node=3D0|zone=3D2|lastcpupid=3D0x1ffff)
> raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
> raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>=20
> Memory state around the buggy address:
>   ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> > ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                   ^
>   ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>=20
> Fixes: 718a18a0c8a6 ("veth: Rework veth_xdp_rcv_skb in order to accept no=
n-linear skb")
> Signed-off-by: Shawn Bohrer <sbohrer@cloudflare.com>

Thx for fixing it.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  drivers/net/veth.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 1bb54de7124d..6b10aa3883c5 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -708,7 +708,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_r=
q *rq,
>  	u32 frame_sz;
> =20
>  	if (skb_shared(skb) || skb_head_is_locked(skb) ||
> -	    skb_shinfo(skb)->nr_frags) {
> +	    skb_shinfo(skb)->nr_frags || skb_headroom(skb) < XDP_PACKET_HEADROO=
M) {
>  		u32 size, len, max_head_size, off;
>  		struct sk_buff *nskb;
>  		struct page *page;
> @@ -773,9 +773,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_r=
q *rq,
> =20
>  		consume_skb(skb);
>  		skb =3D nskb;
> -	} else if (skb_headroom(skb) < XDP_PACKET_HEADROOM &&
> -		   pskb_expand_head(skb, VETH_XDP_HEADROOM, 0, GFP_ATOMIC)) {
> -		goto drop;
>  	}
> =20
>  	/* SKB "head" area always have tailroom for skb_shared_info */
> --=20
> 2.34.1
>=20

--IRIFQ0q/8cliYCNI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZBCrJgAKCRA6cBh0uS2t
rJ7KAPsEzzhaCu9reMFPepsk6VFiqR6fscdeIRKFJjcs8enwHwD/YkbPjM+gIuZx
wiVCyW+a6PPEuHrbqvg77KVcC5DhVww=
=YhAe
-----END PGP SIGNATURE-----

--IRIFQ0q/8cliYCNI--
