Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D6DC765
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410461AbfJROcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:32:03 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:52880 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408046AbfJROcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:32:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1571409120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DySkX1/HW4huis6e998NWRv5hnIE5IRYVcrxXXxSoUo=;
        b=I7PnxZNledLze6nde4UewSf2NY82nhHqPVn/zp4bS7Uiu3W5JJGxmjtuAheTzDzoTxDya0
        QMiGaBx+o3aZwE/j7Hxvxnq/bE6EaIwQD6KxDMM78A0AeT98z4yClAQuw3ZAVjvXgbG3zR
        MEK6whnkoKvie+nKaWUItnBCKTmKgT0=
From:   Sven Eckelmann <sven@narfation.org>
To:     syzbot <syzbot+0183453ce4de8bdf9214@syzkaller.appspotmail.com>
Cc:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, glider@google.com,
        linux-kernel@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com,
        Petko Manolov <petkan@nucleusys.com>, linux-usb@vger.kernel.org
Subject: Re: KMSAN: uninit-value in batadv_hard_if_event
Date:   Fri, 18 Oct 2019 16:31:22 +0200
Message-ID: <5289022.tfFiBPLraV@bentobox>
In-Reply-To: <0000000000006120c905952febbd@google.com>
References: <0000000000006120c905952febbd@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2007484.toOGgChZoC"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart2007484.toOGgChZoC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi,

not sure whether this is now a bug in batman-adv or in the rtl8150 driver. See 
my comments inline.

On Friday, 18 October 2019 16:12:08 CEST syzbot wrote:
[...]
> usb 1-1: config 0 has no interface number 0
> usb 1-1: New USB device found, idVendor=0411, idProduct=0012,  
> bcdDevice=56.5f
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> usb 1-1: config 0 descriptor??
> =====================================================
> BUG: KMSAN: uninit-value in batadv_check_known_mac_addr  
> net/batman-adv/hard-interface.c:511 [inline]
> BUG: KMSAN: uninit-value in batadv_hardif_add_interface  
> net/batman-adv/hard-interface.c:942 [inline]
> BUG: KMSAN: uninit-value in batadv_hard_if_event+0x23c0/0x3260  
> net/batman-adv/hard-interface.c:1032
> CPU: 0 PID: 13223 Comm: kworker/0:3 Not tainted 5.4.0-rc3+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x191/0x1f0 lib/dump_stack.c:113
>   kmsan_report+0x14a/0x2f0 mm/kmsan/kmsan_report.c:109
>   __msan_warning+0x73/0xf0 mm/kmsan/kmsan_instr.c:245
>   batadv_check_known_mac_addr net/batman-adv/hard-interface.c:511 [inline]
>   batadv_hardif_add_interface net/batman-adv/hard-interface.c:942 [inline]
>   batadv_hard_if_event+0x23c0/0x3260 net/batman-adv/hard-interface.c:1032
>   notifier_call_chain kernel/notifier.c:95 [inline]
[...]

The line in batman-adv is (batadv_check_known_mac_addr):

		if (!batadv_compare_eth(hard_iface->net_dev->dev_addr,
					net_dev->dev_addr))

So it goes through the list of ethernet interfaces (which are currently 
attached to a batadv interface) and compares it with the new device's MAC 
address. And it seems like the new device doesn't have the mac address part 
initialized yet.

Is this allowed in NETDEV_REGISTER/NETDEV_POST_TYPE_CHANGE?

> Uninit was stored to memory at:
>   kmsan_save_stack_with_flags mm/kmsan/kmsan.c:150 [inline]
>   kmsan_internal_chain_origin+0xbd/0x170 mm/kmsan/kmsan.c:317
>   kmsan_memcpy_memmove_metadata+0x25c/0x2e0 mm/kmsan/kmsan.c:253
>   kmsan_memcpy_metadata+0xb/0x10 mm/kmsan/kmsan.c:273
>   __msan_memcpy+0x56/0x70 mm/kmsan/kmsan_instr.c:129
>   set_ethernet_addr drivers/net/usb/rtl8150.c:282 [inline]
>   rtl8150_probe+0x1143/0x14a0 drivers/net/usb/rtl8150.c:912

This looks like it should store the mac address at this point.

    static inline void set_ethernet_addr(rtl8150_t * dev)
    {
    	u8 node_id[6];
    
    	get_registers(dev, IDR, sizeof(node_id), node_id);
    	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
    }

But it seems more like get_registers failed and the uninitialized was still 
copied to the mac address. Thus causing the KMSAN error in batman-adv.

Is this interpretation of the KMSAN output correct or do I miss something?

Kind regards,
	Sven
--nextPart2007484.toOGgChZoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl2pzLoACgkQXYcKB8Em
e0YlDBAArGIj5OfEJ9SEXvItxPo2GeYYlnDPblRArpABHQ4SHFNhNKnkrd078q/S
KZ47suZByfyXAfONnzVdUIw/Y4VkBT3cMEXIzhPNihNRd2S3NushhzmDgY2MQs5K
QcGBXGMo3SvpbyQXSp+E4RNwQxHr/ITLu0ccbkwtsQlADfaZcoBc2E5gKpDzE0Ny
nUqIhT1urnTTQ7AdIVmKN0goU5BoaZTEq5zmmzLHYsTo/XzSlm+sbWrWW+I8FLE3
F7G3K/qgVk8fepylkLOhnEwS9aZ2HG9Z99zLyzvOEmggWw2xlMb+ywdXe1BN2zaY
Zi+FZvn7uEnmBNVVDH5BAvuiYxMhDmqFSDyeBOJOXn2PqPKfX05VW6Ub3wlNzveI
3t/l9KvfzN6QKLlJnjM36d1+7P1Hd5UzshnJMKZ7yXGgwYl7c7cPCFMnozTeMbDF
hHbW2DgRH7ulQpxV9u4TiN6Z0xLYBr9dOkMe9CnIIW582qyfmiTNRjyiZfw/qL9g
B26MGkeobiVriBDXrP51ZoTN/3OfK3cHXCIBMdaSkgW2UkVO8+O9S5pzZSiQip8b
99As3Yys7Y+oq6QHBcRDNttA8mjJYsI/g1jW3NvEJhGijDAsKPPLrUl8+BkLBFkp
E3poDpKL5JGmk3B239CNUR7GTZqGvcI1mOgS2fJ/t0Ap4JMw5RU=
=R9zW
-----END PGP SIGNATURE-----

--nextPart2007484.toOGgChZoC--



