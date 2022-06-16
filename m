Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4271954E665
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377471AbiFPPvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbiFPPvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:51:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E0C427DE;
        Thu, 16 Jun 2022 08:51:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 950D260BAD;
        Thu, 16 Jun 2022 15:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4FFC34114;
        Thu, 16 Jun 2022 15:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655394661;
        bh=PaJOcCCOZMISwlBFFb5mPfz00LQCHmckbNW4/JT3HXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AJwMwl3EcuRXCCpQxreHZ6QaquYE/XW383MEso/dl9qitr2DVDmVF6thuxBSgQ/pG
         kSOWLWpUDJCutV6kF3GPsZAp56WVvvze0QpwMVBfO3uOQtoAmzikVSDv4l8QK6AUlz
         89MAdBBNXGy3ib+sAKGjK5Ozjj6stT+yVu8a7qB5Ov4G0GXSd5Po0XO0YQmc6Vpq2v
         3oE6ItDnKNuTH0O5fpnhi/77bCHAmZ7TQrOVoB+P2PJFABV9XcbRAkKfPudPBb4APH
         jPIAtTE+8di9C+A0CkXE48GvMs+Cw8+G2EHH1oA9AYUtC9bRiQlj7I1MgPhvPL/iQE
         eoJFHesoxzsSw==
Date:   Thu, 16 Jun 2022 08:50:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?5qKB5paH6Z+s?= <wentao_liang_g@163.com>
Cc:     jdmason@kudzu.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH net v2]vexy: Fix a use-after-free bug in
 vxge-main.c
Message-ID: <20220616085059.680dc215@kernel.org>
In-Reply-To: <1f10f9f8.6c02.1816cb0dc51.Coremail.wentao_liang_g@163.com>
References: <20220615013816.6593-1-Wentao_Liang_g@163.com>
        <20220615195050.6e4785ef@kernel.org>
        <1f10f9f8.6c02.1816cb0dc51.Coremail.wentao_liang_g@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 21:25:39 +0800 (CST) =E6=A2=81=E6=96=87=E9=9F=AC wrote:
> >The driver is not called "vexy" as far as I can tell.
> > =20
> >> The pointer vdev points to a memory region adjacent to a net_device
> >> structure ndev, which is a field of hldev. At line 4740, the invocation
> >> to vxge_device_unregister unregisters device hldev, and it also releas=
es
> >> the memory region pointed by vdev->bar0. At line 4743, the freed memory
> >> region is referenced (i.e., iounmap(vdev->bar0)), resulting in a
> >> use-after-free vulnerability. We can fix the bug by calling iounmap
> >> before vxge_device_unregister. =20
> >
> >Are you sure the bar0 is not needed by the netdev? You're freeing =20
> >memory that the netdev may need until it's unregistered. =20

> We try unregister the device in a patched kernel. The device is successfu=
lly
>  removed and there is not any warning or exception. See the following=20
> snapshot. I use lspci to list pci devices, we can see that the device=20
> (00:03.0 Unclassified ...Gigabit ethernet PCIe (rev 10)) is removed safel=
y.=20
> Thus, I believe that the bar0 is not needed when freeing the device.

You need to reply in plain text, no HTML, the mailing lit rejects
emails with HTML in them.

No errors happening during a test is not a sufficient proof of
correctness. You need to analyze the driver and figure out what bar0=20
is used for.

Alternatively just save the address of bar0 to a local variable, let
the netdev unregister happen, and then call *unmap() on the local
variable. That won't move the unmap and avoid the UAF.

But please LMK how you use these cards first.

> /************************************************************************=
********/
> root@kernel:~# lspci
> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM=20
> Controller
> 00:01.0 VGA compatible controller: Device 1234:1111 (rev 02)
> 00:02.0 Ethernet controller: Intel Corporation 82574L Gigabit Network=20
> Connection
> 00:03.0 Unclassified device [00ff]: Exar Corp. X3100 Series 10 Gigabit=20
> Ethernet PCIe (rev 10)

Is this a real NIC card, or just a emulated / virtualized one?=20
Do you use it day to day?=20

> 00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI=20
> Controller #1 (rev 03)
> 00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI=20
> Controller #2 (rev 03)
> 00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI=20
> Controller #3 (rev 03)
> 00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI=
=20
> Controller #1 (rev 03)
> 00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface=20
> Controller (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6
>  port SATA Controller [AHCI mode] (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller=20
> (rev 02)
> root@kernel:~# echo 1 > /sys/bus/pci/devices/0000:00:03.0/remove
> root@kernel:~# lspci
> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
>  Controller
> 00:01.0 VGA compatible controller: Device 1234:1111 (rev 02)
> 00:02.0 Ethernet controller: Intel Corporation 82574L Gigabit Network
>  Connection
> 00:1d.0 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
>  Controller #1 (rev 03)
> 00:1d.1 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
>  Controller #2 (rev 03)
> 00:1d.2 USB controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
>  Controller #3 (rev 03)
> 00:1d.7 USB controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
>  Controller #1 (rev 03)
> 00:1f.0 ISA bridge: Intel Corporation 82801IB (ICH9) LPC Interface=20
> Controller (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6=
=20
> port SATA Controller [AHCI mode] (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus=20
> Controller (rev 02)
