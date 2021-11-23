Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441B0459E88
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 09:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhKWIuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 03:50:50 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:42998 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhKWIuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 03:50:44 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4125F218E0;
        Tue, 23 Nov 2021 08:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637657256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HebmXy0b6j5mJpu4iOq+Ee55pjbGM9GIcm2Ag/b4t7Y=;
        b=CXOiiJq0sw1HvF0XQ2WC4sodahGvJJrEsuyMjIEI0s8ypjK/6KB3mmyVChaH07yIG5hVz4
        8w0rEf5hxf+XtJ6xGl753JwJYDY5Iwd1sNvzoBQ8Dv/NqQgLn0FyDPPbuRrB2XYNI3N9Mn
        0bH7o9mOjsn4ngJlmZuFDTr588ErbYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637657256;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HebmXy0b6j5mJpu4iOq+Ee55pjbGM9GIcm2Ag/b4t7Y=;
        b=voB04jql/YBQcoHZJBBAAfq/3k4UT2u8tsaLmvKQ93LtThAUi5x6HjbSm8nsNapcwNNfZi
        rb1+IjfaN/qK9ZCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9EFFF13B58;
        Tue, 23 Nov 2021 08:47:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LgrpIqeqnGG6AgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 23 Nov 2021 08:47:35 +0000
Subject: Re: [PATCH net-next 2/2] mlxsw: pci: Add shutdown method in PCI
 driver
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Danielle Ratson <danieller@nvidia.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20211123075447.3083579-1-idosch@idosch.org>
 <20211123075447.3083579-3-idosch@idosch.org>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <34c443a5-c36b-2a16-adda-222da6dc5238@suse.de>
Date:   Tue, 23 Nov 2021 11:47:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211123075447.3083579-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/23/21 10:54 AM, Ido Schimmel пишет:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> On an arm64 platform with the Spectrum ASIC, after loading and executing
> a new kernel via kexec, the following trace [1] is observed. This seems
> to be caused by the fact that the device is not properly shutdown before
> executing the new kernel.

This should be sent to net tree instead of net-next with Fixes tag added.

> Fix this by implementing a shutdown method which mirrors the remove
> method, as recommended by the kexec maintainer [2][3].
> 
> [1]
> BUG: Bad page state in process devlink pfn:22f73d
> page:fffffe00089dcf40 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
> flags: 0x2ffff00000000000()
> raw: 2ffff00000000000 0000000000000000 ffffffff089d0201 0000000000000000
> raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
> page dumped because: nonzero _refcount
> Modules linked in:
> CPU: 1 PID: 16346 Comm: devlink Tainted: G B 5.8.0-rc6-custom-273020-gac6b365b1bf5 #44
> Hardware name: Marvell Armada 7040 TX4810M (DT)
> Call trace:
>   dump_backtrace+0x0/0x1d0
>   show_stack+0x1c/0x28
>   dump_stack+0xbc/0x118
>   bad_page+0xcc/0xf8
>   check_free_page_bad+0x80/0x88
>   __free_pages_ok+0x3f8/0x418
>   __free_pages+0x38/0x60
>   kmem_freepages+0x200/0x2a8
>   slab_destroy+0x28/0x68
>   slabs_destroy+0x60/0x90
>   ___cache_free+0x1b4/0x358
>   kfree+0xc0/0x1d0
>   skb_free_head+0x2c/0x38
>   skb_release_data+0x110/0x1a0
>   skb_release_all+0x2c/0x38
>   consume_skb+0x38/0x130
>   __dev_kfree_skb_any+0x44/0x50
>   mlxsw_pci_rdq_fini+0x8c/0xb0
>   mlxsw_pci_queue_fini.isra.0+0x28/0x58
>   mlxsw_pci_queue_group_fini+0x58/0x88
>   mlxsw_pci_aqs_fini+0x2c/0x60
>   mlxsw_pci_fini+0x34/0x50
>   mlxsw_core_bus_device_unregister+0x104/0x1d0
>   mlxsw_devlink_core_bus_device_reload_down+0x2c/0x48
>   devlink_reload+0x44/0x158
>   devlink_nl_cmd_reload+0x270/0x290
>   genl_rcv_msg+0x188/0x2f0
>   netlink_rcv_skb+0x5c/0x118
>   genl_rcv+0x3c/0x50
>   netlink_unicast+0x1bc/0x278
>   netlink_sendmsg+0x194/0x390
>   __sys_sendto+0xe0/0x158
>   __arm64_sys_sendto+0x2c/0x38
>   el0_svc_common.constprop.0+0x70/0x168
>   do_el0_svc+0x28/0x88
>   el0_sync_handler+0x88/0x190
>   el0_sync+0x140/0x180
> 
> [2]
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1195432.html
> 
> [3]
> https://patchwork.kernel.org/project/linux-scsi/patch/20170212214920.28866-1-anton@ozlabs.org/#20116693
> 
> Cc: Eric Biederman <ebiederm@xmission.com>
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlxsw/pci.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> index a15c95a10bae..cd3331a077bb 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
> @@ -1973,6 +1973,7 @@ int mlxsw_pci_driver_register(struct pci_driver *pci_driver)
>   {
>   	pci_driver->probe = mlxsw_pci_probe;
>   	pci_driver->remove = mlxsw_pci_remove;
> +	pci_driver->shutdown = mlxsw_pci_remove;
>   	return pci_register_driver(pci_driver);
>   }
>   EXPORT_SYMBOL(mlxsw_pci_driver_register);
> 
