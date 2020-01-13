Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA8D139A77
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 21:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgAMUDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 15:03:05 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38087 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbgAMUDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 15:03:05 -0500
Received: by mail-pg1-f193.google.com with SMTP id a33so5218873pgm.5
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 12:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dDAqkyD/tpiI4U9+257qc3YqD7LGOrkT6Qv3kWgevuE=;
        b=2MUdmRFc3DM2x6YdfwZWMEm65bzamjR9XdINw9TimbeINbeMnyVtTF0qPit7prP/Uh
         pXy//399Sf5SND8p5Swx/Q7REar6APJSl2dAqoEVZWffC2Rwfuf2KY/vmpRjvLVZu+kI
         oEmcDVABS5SJ2CmoPsHKSxNggmZ5/Sh66PEPV6y0+6FHuXYHyYFkYS0to8/aXHo9//Mk
         qFL/14pNozRgmeOEqlk8rjXJ8WraQT4jaCehig3cHRHD3GydVmphlVMIhLhmZhhwhKg/
         RfmUPrU04QoxTGAlkO2mkR+poQBz34a3VbZRzqmBjZmfnNLrJw6vx5MXis/V8RI7WpaA
         8Z9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dDAqkyD/tpiI4U9+257qc3YqD7LGOrkT6Qv3kWgevuE=;
        b=DstV309p2XOe42Q6fXOOcDNEZnVPK+Jdqu9wpSZXOEXI0jeuD+LJrKC4B/1pThRGBj
         EDzxJDTYxy/GwDJ71bXRMJko+4ia1k4CgXGpC0jSgrt+kE5OdLvKDB4bhNZqyZfyyaFW
         YjD3Tihpq4HpHluq72F0i6sRKvMCG3jDAzA6mZ/me6AWzBvh2hDdgPHBldLEyeV6+tt7
         AeIQZKQfw8Yo16iaE+8Sle9jgm+D3tIcMT+PWN/VvNQJtZCtqoc1lNHK8tQ8+MAZg79d
         +kFwV7X+tCAP3paKbLlFT3EPtP11UAn/X+sRga2DPcVDfZ0caLrXDzuI4a6OxGpoWH0/
         0JDw==
X-Gm-Message-State: APjAAAX0AGdE6FRkNHIE2zFQ13Vz0lzPN7hicbgg8biuXfYQvABUOLAo
        qIlt2EZcgjSnt+MebNziC70Aeg==
X-Google-Smtp-Source: APXvYqz6uphmWGcjboP01vghF9D5x3AKtSgg35fYZqjtVxpHV8z8FCrT50vxWER+r7gDYXSul3DEEg==
X-Received: by 2002:a63:2a49:: with SMTP id q70mr22072600pgq.265.1578945784482;
        Mon, 13 Jan 2020 12:03:04 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 189sm15772620pfw.73.2020.01.13.12.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 12:03:04 -0800 (PST)
Date:   Mon, 13 Jan 2020 12:02:54 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     linux-hyperv@vger.kernel.org, sthemmin@microsoft.com,
        haiyangz@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        sashal@kernel.org, vkuznets@redhat.com, cavery@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Fix memory leak when removing rndis device
Message-ID: <20200113120254.2f61148d@hermes.lan>
In-Reply-To: <20200113192752.1266-1-mgamal@redhat.com>
References: <20200113192752.1266-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jan 2020 21:27:52 +0200
Mohammed Gamal <mgamal@redhat.com> wrote:

> kmemleak detects the following memory leak when hot removing
> a network device:
> 
> unreferenced object 0xffff888083f63600 (size 256):
>   comm "kworker/0:1", pid 12, jiffies 4294831717 (age 1113.676s)
>   hex dump (first 32 bytes):
>     00 40 c7 33 80 88 ff ff 00 00 00 00 10 00 00 00  .@.3............
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>   backtrace:
>     [<00000000d4a8f5be>] rndis_filter_device_add+0x117/0x11c0 [hv_netvsc]
>     [<000000009c02d75b>] netvsc_probe+0x5e7/0xbf0 [hv_netvsc]
>     [<00000000ddafce23>] vmbus_probe+0x74/0x170 [hv_vmbus]
>     [<00000000046e64f1>] really_probe+0x22f/0xb50
>     [<000000005cc35eb7>] driver_probe_device+0x25e/0x370
>     [<0000000043c642b2>] bus_for_each_drv+0x11f/0x1b0
>     [<000000005e3d09f0>] __device_attach+0x1c6/0x2f0
>     [<00000000a72c362f>] bus_probe_device+0x1a6/0x260
>     [<0000000008478399>] device_add+0x10a3/0x18e0
>     [<00000000cf07b48c>] vmbus_device_register+0xe7/0x1e0 [hv_vmbus]
>     [<00000000d46cf032>] vmbus_add_channel_work+0x8ab/0x1770 [hv_vmbus]
>     [<000000002c94bb64>] process_one_work+0x919/0x17d0
>     [<0000000096de6781>] worker_thread+0x87/0xb40
>     [<00000000fbe7397e>] kthread+0x333/0x3f0
>     [<000000004f844269>] ret_from_fork+0x3a/0x50
> 
> rndis_filter_device_add() allocates an instance of struct rndis_device
> which never gets deallocated and rndis_filter_device_remove() sets
> net_device->extension which points to the rndis_device struct to NULL
> without ever freeing the structure first, leaving it dangling.
> 
> This patch fixes this by freeing the structure before setting
> net_device->extension to NULL
> 
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  drivers/net/hyperv/rndis_filter.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
> index 857c4bea451c..d2e094f521a4 100644
> --- a/drivers/net/hyperv/rndis_filter.c
> +++ b/drivers/net/hyperv/rndis_filter.c
> @@ -1443,6 +1443,7 @@ void rndis_filter_device_remove(struct hv_device *dev,
>  	/* Halt and release the rndis device */
>  	rndis_filter_halt_device(net_dev, rndis_dev);
>  
> +	kfree(rndis_dev);
>  	net_dev->extension = NULL;
>  
>  	netvsc_device_remove(dev);

That is one way, but maybe safer to just remove the line that sets
extension to NULL. That way netvsc_device_remove will clean it up:
    netvsc_device_remove -> free_netvsc_device_rcu -> free_netvsc_device.
