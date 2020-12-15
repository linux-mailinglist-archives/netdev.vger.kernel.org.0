Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9E12DB4EF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 21:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgLOURp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 15:17:45 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:20836 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgLOURk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 15:17:40 -0500
Received: from [192.168.42.210] ([93.22.37.143])
        by mwinf5d65 with ME
        id 4kFl2400135JPTR03kFlJF; Tue, 15 Dec 2020 21:15:55 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 15 Dec 2020 21:15:55 +0100
X-ME-IP: 93.22.37.143
Subject: Re: [PATCH] net: allwinner: Fix some resources leak in the error
 handling path of the probe and in the remove function
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     song.bao.hua@hisilicon.com, jernej.skrabec@siol.net,
        f.fainelli@gmail.com, leon@kernel.org, timur@kernel.org,
        netdev@vger.kernel.org, wangyunjian@huawei.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        wens@csie.org, kuba@kernel.org, sr@denx.de, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, hkallweit1@gmail.com
References: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
 <20201215085655.ddacjfvogc3e33vz@gilmour> <20201215091153.GH2809@kadam>
 <20201215113710.wh4ezrvmqbpxd5yi@gilmour>
 <54194e3e-5eb1-d10c-4294-bac8f3933f47@wanadoo.fr>
 <20201215190815.6efzcqko55womf6b@gilmour> <20201215193545.GJ2809@kadam>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <cad6143c-a5bb-37a8-cff1-86b0fb7c8708@wanadoo.fr>
Date:   Tue, 15 Dec 2020 21:15:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201215193545.GJ2809@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/12/2020 à 20:35, Dan Carpenter a écrit :
> On Tue, Dec 15, 2020 at 08:08:15PM +0100, Maxime Ripard wrote:
>> On Tue, Dec 15, 2020 at 07:18:48PM +0100, Christophe JAILLET wrote:
>>> Le 15/12/2020 à 12:37, Maxime Ripard a écrit :
>>>> On Tue, Dec 15, 2020 at 12:11:53PM +0300, Dan Carpenter wrote:
>>>>> On Tue, Dec 15, 2020 at 09:56:55AM +0100, Maxime Ripard wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On Mon, Dec 14, 2020 at 09:21:17PM +0100, Christophe JAILLET wrote:
>>>>>>> 'irq_of_parse_and_map()' should be balanced by a corresponding
>>>>>>> 'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.
>>>>>>
>>>>>> Do you have a source to back that? It's not clear at all from the
>>>>>> documentation for those functions, and couldn't find any user calling it
>>>>>> from the ten-or-so random picks I took.
>>>>>
>>>>> It looks like irq_create_of_mapping() needs to be freed with
>>>>> irq_dispose_mapping() so this is correct.
>>>>
>>>> The doc should be updated first to make that clear then, otherwise we're
>>>> going to fix one user while multiples will have poped up
>>>>
>>>> Maxime
>>>>
>>>
>>> Hi,
>>>
>>> as Dan explained, I think that 'irq_dispose_mapping()' is needed because of
>>> the 'irq_create_of_mapping()" within 'irq_of_parse_and_map()'.
>>>
>>> As you suggest, I'll propose a doc update to make it clear and more future
>>> proof.
>>
>> Thanks :)
>>
>> And if you feel like it, a coccinelle script would be awesome too so
>> that other users get fixed over time
>>
>> Maxime
> 
> Smatch has a new check for resource leaks which hopefully people will
> find useful.
> 
> https://github.com/error27/smatch/blob/master/check_unwind.c

Nice :)
I wasn't aware of it.

> 
> To check for these I would need to add the following lines to the table:
> 
>          { "irq_of_parse_and_map", ALLOC, -1, "$", &int_one, &int_max},
>          { "irq_create_of_mapping", ALLOC, -1, "$", &int_one, &int_max},
>          { "irq_dispose_mapping", RELEASE, 0, "$"},
> 
> The '-1, "$"' means the returned value.  irq_of_parse_and_map() and
> irq_create_of_mapping() return positive int on success.
> 
> The irq_dispose_mapping() frees its zeroth parameter so it's listed as
> '0, "$"'.  We don't care about the returns from irq_dispose_mapping().
> 
> It doesn't apply in this case but if a function frees a struct member
> then that's listed as '0, "$->member_name"'.
> 
> regards,
> dan carpenter
> 

The script I use to try to spot missing release function is:
///
@@
expression  x, y;
identifier f, l;
@@

*       x = irq_of_parse_and_map(...);
         ... when any
*       y = f(...);
         ... when any
*       if (<+... y ...+>)
         {
                 ...
(
*               goto l;
|
*               return ...;
)
                 ...
         }
         ... when any
*l:
         ... when != irq_dispose_mapping(...);
*       return ...;
///

It is likely that some improvement can be made, but it works pretty well 
for what I want.

And I have a collection of alloc/free functions that I manually put in 
place of irq_of_parse_and_map and irq_dispose_mapping.

Up to know, this list is:

// alloc_etherdev/alloc_etherdev_mq/alloc_etherdev_mqs - free_netdev
// alloc_workqueue - destroy_workqueue
// class_register - class_unregister
// clk_get - clk_put
// clk_prepare - clk_unprepare
// create_workqueue - destroy_workqueue
// create_singlethread_workqueue - destroy_workqueue
// 
dev_pm_domain_attach/dev_pm_domain_attach_by_id/dev_pm_domain_attach_by_name 
- dev_pm_domain_detach
// devres_alloc - devres_free
// dma_alloc_coherent - dma_free_coherent
// dma_map_resource - dma_unmap_resource
// dma_map_single - dma_unmap_single
// dma_request_slave_channel - dma_release_channel
// dma_request_chan - dma_release_channel
// framebuffer_alloc - framebuffer_release
// get_device - put_device
// iio_channel_get - iio_channel_release
// ioremap - iounmap
// input_allocate_device - input_free_device
// input_register_handle - input_unregister_handle
// irq_of_parse_and_map / irq_create_of_mapping - irq_dispose_mapping
// kmalloc - kfree
// mempool_alloc - mempool_free
// of_node_get - of_node_put
// of_reserved_mem_device_init - of_reserved_mem_device_release
// pinctrl_register - pinctrl_unregister
// request_irq - free_irq
// request_region - release_region
// request_mem_region - release_mem_region
// reset_control_assert - reset_control_deassert
// scsi_host_alloc - scsi_host_put

// pci_alloc_irq_vectors - pci_free_irq_vectors
// pci_dev_get - pci_dev_put
// pci_enable_device - pci_disable_device
// pci_iomap - pci_iounmap
// pci_request_region - pci_release_region
// pci_request_regions - pci_release_regions

// alloc_skb/__alloc_skb - kfree_skb/__kfree_skb
// dev_alloc_skb - dev_kfree_skb

// spi_dev_get - spi_dev_put
// spi_message_alloc - spi_message_free
// spi_register_master - spi_unregister_master
