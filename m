Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE2044E994
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhKLPLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:11:20 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:33200 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbhKLPLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:11:20 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A51BF1FD66;
        Fri, 12 Nov 2021 15:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636729708; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/1fHuKFgBgw4hV9neRtlv0mhDFE9RH72dHARJzHv1I=;
        b=xtrQ8QYB3cUMrRALhmU2GVhy5qCSwkncdTDYv8X/uzjEvgbRxFg9ONxcBgbQYRmOUyEQyK
        tAjfGVNDCgmSRWmUL4ZzgI7RqWLxci/N2PRZFMI8nFLk9YBc5yamlaQ9Xsy2NalJQyOW1T
        NheZ+hlSfc5JUObB3gdaT4rgN96hGnk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636729708;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/1fHuKFgBgw4hV9neRtlv0mhDFE9RH72dHARJzHv1I=;
        b=yV692aDYuglUylNYIkwp5IllmIK0n2maEnXKbTY6x+MHHLLPNYBopF0S5G4+HkbXW4SsEh
        94Q7RMSvaS8PtEBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E313213C75;
        Fri, 12 Nov 2021 15:08:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DSBBM2uDjmGXVgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Fri, 12 Nov 2021 15:08:27 +0000
Subject: Re: [PATCH] net: igbvf: fix double free in `igbvf_probe`
To:     Letu Ren <fantasquex@gmail.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
References: <20211112142002.23156-1-fantasquex@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <4246e551-8963-e6aa-a70a-7a7005c7316b@suse.de>
Date:   Fri, 12 Nov 2021 18:08:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211112142002.23156-1-fantasquex@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/12/21 5:20 PM, Letu Ren пишет:
> In `igbvf_probe`, if register_netdev() fails, the program will go to
> label err_hw_init, and then to label err_ioremap. In free_netdev() which
> is just below label err_ioremap, there is `list_for_each_entry_safe` and
> `netif_napi_del` which aims to delete all entries in `dev->napi_list`.
> The program has added an entry `adapter->rx_ring->napi` which is added by
> `netif_napi_add` in igbvf_alloc_queues(). However, adapter->rx_ring has
> been freed below label err_hw_init. So this a UAF.
> 
> In terms of how to patch the problem, we can refer to igbvf_remove() and
> delete the entry before `adapter->rx_ring`.
> 
> The KASAN logs are as follows:
> 
> [   35.126075] BUG: KASAN: use-after-free in free_netdev+0x1fd/0x450
> [   35.127170] Read of size 8 at addr ffff88810126d990 by task modprobe/366
> [   35.128360]
> [   35.128643] CPU: 1 PID: 366 Comm: modprobe Not tainted 5.15.0-rc2+ #14
> [   35.129789] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
> [   35.131749] Call Trace:
> [   35.132199]  dump_stack_lvl+0x59/0x7b
> [   35.132865]  print_address_description+0x7c/0x3b0
> [   35.133707]  ? free_netdev+0x1fd/0x450
> [   35.134378]  __kasan_report+0x160/0x1c0
> [   35.135063]  ? free_netdev+0x1fd/0x450
> [   35.135738]  kasan_report+0x4b/0x70
> [   35.136367]  free_netdev+0x1fd/0x450
> [   35.137006]  igbvf_probe+0x121d/0x1a10 [igbvf]
> [   35.137808]  ? igbvf_vlan_rx_add_vid+0x100/0x100 [igbvf]
> [   35.138751]  local_pci_probe+0x13c/0x1f0
> [   35.139461]  pci_device_probe+0x37e/0x6c0
> [   35.165526]
> [   35.165806] Allocated by task 366:
> [   35.166414]  ____kasan_kmalloc+0xc4/0xf0
> [   35.167117]  foo_kmem_cache_alloc_trace+0x3c/0x50 [igbvf]
> [   35.168078]  igbvf_probe+0x9c5/0x1a10 [igbvf]
> [   35.168866]  local_pci_probe+0x13c/0x1f0
> [   35.169565]  pci_device_probe+0x37e/0x6c0
> [   35.179713]
> [   35.179993] Freed by task 366:
> [   35.180539]  kasan_set_track+0x4c/0x80
> [   35.181211]  kasan_set_free_info+0x1f/0x40
> [   35.181942]  ____kasan_slab_free+0x103/0x140
> [   35.182703]  kfree+0xe3/0x250
> [   35.183239]  igbvf_probe+0x1173/0x1a10 [igbvf]
> [   35.184040]  local_pci_probe+0x13c/0x1f0
> 
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Please add Fixes tag
> Signed-off-by: Letu Ren <fantasquex@gmail.com>
> ---
>   drivers/net/ethernet/intel/igbvf/netdev.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
> index d32e72d953c8..d051918dfdff 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
> @@ -2861,6 +2861,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	return 0;
>   
>   err_hw_init:
> +	netif_napi_del(&adapter->rx_ring->napi);
>   	kfree(adapter->tx_ring);
>   	kfree(adapter->rx_ring);
>   err_sw_init:
> 
