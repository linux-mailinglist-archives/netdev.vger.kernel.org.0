Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232C8C11FD
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 21:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbfI1TPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 15:15:10 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33488 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfI1TPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Sep 2019 15:15:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iEIBE-0002ob-V4; Sat, 28 Sep 2019 21:14:57 +0200
Message-ID: <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
Subject: Re: [PATCH net v4 07/12] macvlan: use dynamic lockdep key instead
 of subclass
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Date:   Sat, 28 Sep 2019 21:14:54 +0200
In-Reply-To: <20190928164843.31800-8-ap420073@gmail.com> (sfid-20190928_185005_320479_39029157)
References: <20190928164843.31800-1-ap420073@gmail.com>
         <20190928164843.31800-8-ap420073@gmail.com>
         (sfid-20190928_185005_320479_39029157)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I hadn't seen the previous patchsets of this, and looking briefly in the
archives didn't really seem to say anything about this.


However, I'm wondering now: patches 2-7 of this patchset look basically
all identical in a way:
 * you set the addr_list_lock's class to a newly registered key inside
   the netdev (or rather the private struct, but doesn't make a big
   difference)
 * you set each TX queue's _xmit_lock's class similarly
 * you set the qdisc_tx_busylock/qdisc_running_key

The first two of these look pretty much completely identical.

Would it perhaps make sense to just do that for *every* netdev? Many of
those netdevs won't ever nest so it wouldn't really be useful, but I'm
not convinced it would put that much more strain on lockdep - if
anything, people are probably creating more VLANs than regular PF/VF
netdevs anyway?

I didn't see any discussion on this, but perhaps I missed it? The cost
would be a bigger netdev struct (when lockdep is enabled), but we
already have that for all the VLANs etc. it's just in the private data,
so it's not a _huge_ difference really I'd think, and this is quite a
bit of code for each device type now.

Alternatively, maybe there could just be some common helper code:

struct nested_netdev_lockdep {
	struct lock_class_key xmit_lock_key;
	struct lock_class_key addr_lock_key;
};

void netdev_init_nested_lockdep(struct net_device *dev,
				struct netsted_netdev_lockdep *l)
{
	/* ... */
}

so you just have to embed a "struct nested_netdev_lockdep" in your
private data structure and call the common code.

Or maybe make that

void netdev_init_nested_lockdep(
	struct net_device *dev,
	struct
netsted_netdev_lockdep *l,
	struct lock_class_key
*qdisc_tx_busylock_key,
	struct lock_class_key *qdisc_running_key)

so you can't really get that part wrong either?


> @@ -922,6 +938,9 @@ static void macvlan_uninit(struct net_device *dev)
>  	port->count -= 1;
>  	if (!port->count)
>  		macvlan_port_destroy(port->dev);
> +
> +	lockdep_unregister_key(&vlan->addr_lock_key);
> +	lockdep_unregister_key(&vlan->xmit_lock_key);
>  }

OK, so I guess you need an equivalent "deinit" function too -
netdev_deinit_nested_lockdep() or so.


What's not really clear to me is why the qdisc locks can actually stay
the same at all levels? Can they just never nest? But then why are they
different per device type?

Thanks,
johannes

