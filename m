Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8B85FC76F
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJLOeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJLOeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:34:08 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC803CA8A5;
        Wed, 12 Oct 2022 07:34:06 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MnZsM3YYXz4xGQ;
        Thu, 13 Oct 2022 01:33:59 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1665585241;
        bh=ZwzUyoEZ0QyY2/E7GFhwabiJeQLIx//6F4mXwQYP97E=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Ex1DBVWxo4dVZXYC/c3s2BRZC+uHoJKi2xOwQm6ownsPzATmCcA6UI2Ot2eQnW/fT
         QYzmIK1I5c0faUhON0YJpUrPWfWg9KE6Yka/0wA9GAsW9Vp8MNIQQNeRhYs+CAWk24
         vgQfX5nvT2+/clEQ4y9+GKLtgGQCbpuh96nqjlZTr2jTMp7Ya2xSyN/L7t5RgeeiOX
         U8I6bb4WUzWNag8WpglJJ29hxVssdCZdpfCnabrVUcGHx0kL+uWeF1fBgc/5OKvfGs
         hyRHG2d7m5iRmnSfAvH0sXgFQKp9JsUV5g+WgYyjTMvZ+EY6NObWrmtwJFVUEVKpTE
         4XZY0iUdjZztw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        wangdeming@inspur.com, xiujianfeng@huawei.com,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [GIT PULL] virtio: fixes, features
In-Reply-To: <87mta1marq.fsf@mpe.ellerman.id.au>
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au>
 <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au>
Date:   Thu, 13 Oct 2022 01:33:59 +1100
Message-ID: <87edvdm7qg.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:
> [ Cc += Bjorn & linux-pci ]
>
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> On Wed, Oct 12, 2022 at 05:21:24PM +1100, Michael Ellerman wrote:
>>> "Michael S. Tsirkin" <mst@redhat.com> writes:
> ...
>>> > ----------------------------------------------------------------
>>> > virtio: fixes, features
>>> >
>>> > 9k mtu perf improvements
>>> > vdpa feature provisioning
>>> > virtio blk SECURE ERASE support
>>> >
>>> > Fixes, cleanups all over the place.
>>> >
>>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> >
>>> > ----------------------------------------------------------------
>>> > Alvaro Karsz (1):
>>> >       virtio_blk: add SECURE ERASE command support
>>> >
>>> > Angus Chen (1):
>>> >       virtio_pci: don't try to use intxif pin is zero
>>> 
>>> This commit breaks virtio_pci for me on powerpc, when running as a qemu
>>> guest.
>>> 
>>> vp_find_vqs() bails out because pci_dev->pin == 0.
>>> 
>>> But pci_dev->irq is populated correctly, so vp_find_vqs_intx() would
>>> succeed if we called it - which is what the code used to do.
>>> 
>>> I think this happens because pci_dev->pin is not populated in
>>> pci_assign_irq().
>>> 
>>> I would absolutely believe this is bug in our PCI code, but I think it
>>> may also affect other platforms that use of_irq_parse_and_map_pci().
>>
>> How about fixing this in of_irq_parse_and_map_pci then?
>> Something like the below maybe?
>> 
>> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
>> index 196834ed44fe..504c4d75c83f 100644
>> --- a/drivers/pci/of.c
>> +++ b/drivers/pci/of.c
>> @@ -446,6 +446,8 @@ static int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *
>>  	if (pin == 0)
>>  		return -ENODEV;
>>  
>> +	pdev->pin = pin;
>> +
>>  	/* Local interrupt-map in the device node? Use it! */
>>  	if (of_get_property(dn, "interrupt-map", NULL)) {
>>  		pin = pci_swizzle_interrupt_pin(pdev, pin);

Backing up a bit. Should the virtio code be looking at pci_dev->pin in
the first place?

Shouldn't it be checking pci_dev->irq instead?

The original commit talks about irq being 0 and colliding with the timer
interrupt.

But all (most?) platforms have converged on 0 meaning NO_IRQ since quite
a fews ago AFAIK.

And the timer irq == 0 is a special case AIUI:
  https://lore.kernel.org/all/CA+55aFwiLp1z+2mzkrFsid1WZQ0TQkcn8F2E6NL_AVR+m1fZ2w@mail.gmail.com/

cheers
