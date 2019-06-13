Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2729E43991
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbfFMPOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:14:38 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45833 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732248AbfFMPOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 11:14:37 -0400
Received: by mail-qt1-f194.google.com with SMTP id j19so22939979qtr.12
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 08:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BGsJ73w+MLOSe60JnmsACb1QedRcajWtXmOr33e/mjo=;
        b=TIk6TaZO4TZ/AhUlFwcE8EuHlOTKuMCtbbpEXKm/ybIgThy2dofIwB5au1E+jR74Os
         1MmRd17BOaXMr0XaJz/1l+Ti43EvulbRN1tpeaDvQK5IuEm8kt7rF+IyRJp2xBOPd2MT
         JIc7OUETyFHY5SshPqLfXGJzYt0dBR4hHAW0MMBKykPbgHP1dGXq6262bn8gX5ThjibD
         gBJdoAvlT0cjYnulrsxVMRm9qVfZle04Jx7I/4RCxG0HdbzP0FbnEh/4ab6YWPfRg1/R
         W4FCiAqFp5vJLf9pkDQFU2KDlPiA/RbTKRUEy9j03hqc/jfdn29TrKbbci5H3UgWWvc9
         97fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BGsJ73w+MLOSe60JnmsACb1QedRcajWtXmOr33e/mjo=;
        b=ZEEFwPhLaBsmxCMaFwvRXf0QNguSoUyFALz61fBK2K0QG9SMZ6FcmUApfcMnU50WZh
         76nWIeBz5wO2n9Gv8OYbrK0FvymjmL2LZTlRug7yF2iW7Hu+KFiyVc44Odrr6d4k4F5K
         JUo108ZE2GOVIdK33Be0PyukyfbC8h/FjDiawzlIit/2cMxDR76r4g2yS3611D6bHIo5
         k6qd14CX7UOAdjvR+RinM44pBlxQkD7WY5xyWtjsNDucsZf+RAiCPTrRWKbZ77PXaue4
         y2ytxjBXEWyhjhnwr8J56+xycqf21QY9q7MLvroTIvLuYmZhvjJnzJ7sfJesfJ/Oth7m
         OxSA==
X-Gm-Message-State: APjAAAXrPzngLXFNHssIoCIP9jy0Ty76yHbJb5WrT+U2eGhsroYBsl/h
        WF9oJsZ1ZDLNUlDNpmTV3ElkSD4qqKnYvcpxkZg=
X-Google-Smtp-Source: APXvYqxS6vFZSIS1JdK7J4P5jBkmu6GuOrRs6MCYyXVJb+gIEJPiDy09cXbu0ASrGY1bhcoYKq/kYGUZKPHhD5hks/I=
X-Received: by 2002:aed:3e7c:: with SMTP id m57mr71109818qtf.204.1560438875951;
 Thu, 13 Jun 2019 08:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560287477.git.rspmn@arcor.de>
In-Reply-To: <cover.1560287477.git.rspmn@arcor.de>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Thu, 13 Jun 2019 17:14:24 +0200
Message-ID: <CAGRyCJF39NQmwNAUoxFHTSnZ8WCGXKuWVyPoPQ0KnHcAAsmR+A@mail.gmail.com>
Subject: Re: [PATCH 0/4] qmi_wwan: fix QMAP handling
To:     Reinhard Speyerer <rspmn@arcor.de>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Reinhard,

Il giorno mer 12 giu 2019 alle ore 19:02 Reinhard Speyerer
<rspmn@arcor.de> ha scritto:
>
> This series addresses the following issues observed when using the
> QMAP support of the qmi_wwan driver:
>
> 1. The QMAP code in the qmi_wwan driver is based on the CodeAurora
>    GobiNet driver ([1], [2]) which does not process QMAP padding
>    in the RX path correctly. This causes qmimux_rx_fixup() to pass
>    incorrect data to the IP stack when padding is used.
>
> 2. qmimux devices currently lack proper network device usage statistics.
>
> 3. RCU stalls on device disconnect with QMAP activated like this
>
>    # echo Y > /sys/class/net/wwan0/qmi/raw_ip
>    # echo 1 > /sys/class/net/wwan0/qmi/add_mux
>    # echo 2 > /sys/class/net/wwan0/qmi/add_mux
>    # echo 3 > /sys/class/net/wwan0/qmi/add_mux
>
>    have been observed in certain setups:
>
>    [ 2273.676593] option1 ttyUSB16: GSM modem (1-port) converter now disc=
onnected from ttyUSB16
>    [ 2273.676617] option 6-1.2:1.0: device disconnected
>    [ 2273.676774] WARNING: CPU: 1 PID: 141 at kernel/rcu/tree_plugin.h:34=
2 rcu_note_context_switch+0x2a/0x3d0
>    [ 2273.676776] Modules linked in: option qmi_wwan cdc_mbim cdc_ncm qcs=
erial cdc_wdm usb_wwan sierra sierra_net usbnet mii edd coretemp iptable_ma=
ngle ip6_tables iptable_filter ip_tables cdc_acm dm_mod dax iTCO_wdt evdev =
iTCO_vendor_support sg ftdi_sio usbserial e1000e ptp pps_core i2c_i801 ehci=
_pci button lpc_ich i2c_core mfd_core uhci_hcd ehci_hcd rtc_cmos usbcore us=
b_common sd_mod fan ata_piix thermal
>    [ 2273.676817] CPU: 1 PID: 141 Comm: kworker/1:1 Not tainted 4.19.38-r=
sp-1 #1
>    [ 2273.676819] Hardware name: Not Applicable   Not Applicable  /CX-GS/=
GM45-GL40             , BIOS V1.11      03/23/2011
>    [ 2273.676828] Workqueue: usb_hub_wq hub_event [usbcore]
>    [ 2273.676832] EIP: rcu_note_context_switch+0x2a/0x3d0
>    [ 2273.676834] Code: 55 89 e5 57 56 89 c6 53 83 ec 14 89 45 f0 e8 5d f=
f ff ff 89 f0 64 8b 3d 24 a6 86 c0 84 c0 8b 87 04 02 00 00 75 7a 85 c0 7e 7=
a <0f> 0b 80 bf 08 02 00 00 00 0f 84 87 00 00 00 e8 b2 e2 ff ff bb dc
>    [ 2273.676836] EAX: 00000001 EBX: f614bc00 ECX: 00000001 EDX: c0715b81
>    [ 2273.676838] ESI: 00000000 EDI: f18beb40 EBP: f1a3dc20 ESP: f1a3dc00
>    [ 2273.676840] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00=
010002
>    [ 2273.676842] CR0: 80050033 CR2: b7e97230 CR3: 2f9c4000 CR4: 000406b0
>    [ 2273.676843] Call Trace:
>    [ 2273.676847]  ? preempt_count_add+0xa5/0xc0
>    [ 2273.676852]  __schedule+0x4e/0x4f0
>    [ 2273.676855]  ? __queue_work+0xf1/0x2a0
>    [ 2273.676858]  ? _raw_spin_lock_irqsave+0x14/0x40
>    [ 2273.676860]  ? preempt_count_add+0x52/0xc0
>    [ 2273.676862]  schedule+0x33/0x80
>    [ 2273.676865]  _synchronize_rcu_expedited+0x24e/0x280
>    [ 2273.676867]  ? rcu_accelerate_cbs_unlocked+0x70/0x70
>    [ 2273.676871]  ? wait_woken+0x70/0x70
>    [ 2273.676873]  ? rcu_accelerate_cbs_unlocked+0x70/0x70
>    [ 2273.676875]  ? _synchronize_rcu_expedited+0x280/0x280
>    [ 2273.676877]  synchronize_rcu_expedited+0x22/0x30
>    [ 2273.676881]  synchronize_net+0x25/0x30
>    [ 2273.676885]  dev_deactivate_many+0x133/0x230
>    [ 2273.676887]  ? preempt_count_add+0xa5/0xc0
>    [ 2273.676890]  __dev_close_many+0x4d/0xc0
>    [ 2273.676892]  ? skb_dequeue+0x40/0x50
>    [ 2273.676895]  dev_close_many+0x5d/0xd0
>    [ 2273.676898]  rollback_registered_many+0xbf/0x4c0
>    [ 2273.676901]  ? raw_notifier_call_chain+0x1a/0x20
>    [ 2273.676904]  ? call_netdevice_notifiers_info+0x23/0x60
>    [ 2273.676906]  ? netdev_master_upper_dev_get+0xe/0x70
>    [ 2273.676908]  rollback_registered+0x1f/0x30
>    [ 2273.676911]  unregister_netdevice_queue+0x47/0xb0
>    [ 2273.676915]  qmimux_unregister_device+0x1f/0x30 [qmi_wwan]
>    [ 2273.676917]  qmi_wwan_disconnect+0x5d/0x90 [qmi_wwan]
>    ...
>    [ 2273.677001] ---[ end trace 0fcc5f88496b485a ]---
>    [ 2294.679136] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
>    [ 2294.679140] rcu:  Tasks blocked on level-0 rcu_node (CPUs 0-1): P14=
1
>    [ 2294.679144] rcu:  (detected by 0, t=3D21002 jiffies, g=3D265857, q=
=3D8446)
>    [ 2294.679148] kworker/1:1     D    0   141      2 0x80000000
>
>
> In addition the permitted QMAP mux_id value range is extended for
> compatibility with ip(8) and the rmnet driver.
>
> Reinhard
>

I tested your patch-set with LM940 and it seems working properly.

If you think it is worth, the tag

Tested-by: Daniele Palmas <dnlplm@gmail.com>

can be added.

By the way, not related to your patches, but I've received reports of
throughput tests with LM960
(dl-max-datagrams=3D32,dl-datagram-max-size=3D16384, single PDN, UDP)
reaching around 1.15 Gbps in downlink, so the driver seems to be
working pretty well. This, however, requires usbnet rx_urb_size to be
changed (currently I'm just modifying the parent network adapter MTU
to achieve this).

Thanks,
Daniele

> [1]: https://portland.source.codeaurora.org/patches/quic/gobi
> [2]: https://portland.source.codeaurora.org/quic/qsdk/oss/lklm/gobinet/
>
> Reinhard Speyerer (4):
>   qmi_wwan: add support for QMAP padding in the RX path
>   qmi_wwan: add network device usage statistics for qmimux devices
>   qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
>   qmi_wwan: extend permitted QMAP mux_id value range
>
>  Documentation/ABI/testing/sysfs-class-net-qmi |   4 +-
>  drivers/net/usb/qmi_wwan.c                    | 103 ++++++++++++++++++++=
++----
>  2 files changed, 91 insertions(+), 16 deletions(-)
>
> --
> 2.11.0
>
