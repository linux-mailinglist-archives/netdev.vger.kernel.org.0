Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159C4CAD60
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389785AbfJCRkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:40:02 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:39502 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731560AbfJCRkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:40:01 -0400
Received: by mail-qk1-f194.google.com with SMTP id 4so3211729qki.6;
        Thu, 03 Oct 2019 10:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F4BANh4jYufVlD3yr9K5ti4yNN2QxjNsJv2HL10KC7Q=;
        b=E3CklpvfMzqofh3/d/MYvH+IMRSZL64nyVP7noUQOtvqvLhML7zXDv2JX81PwDTriG
         Mc1vXfC77IHwsRJhCoTCFZflcR0wWMH28iLEoYxwN6lU8qxBmYd3rou5QhT+lrrQn2Jl
         2QNmX3d7XKjYg1dsQjRxDttu8zmPfccNm8dj5UHDsXdn7+6xbyYc0K96CFlKhj2Mp8J3
         e0cmJ3hwN8RXLG2oZyzkYZlQ0GtbRjlrugDkdSxdsfsZv/H8DuYKZuN62gppYQIl+hub
         QMvTM6eKjggx5qazaDHGzB86YoVCMLhVMK8ClwNl7fx+W+kb3IGq2j/j7ng3zpcjiVJH
         WYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F4BANh4jYufVlD3yr9K5ti4yNN2QxjNsJv2HL10KC7Q=;
        b=XoXR5hlPAtMtiCMRAFop6CLgT3UMaWAIglZjAKaCMZjJPkUlQFbkaRFnw2jD0fXhlL
         +8xymWMVjHwUDmOEMRkkhja7dbkghgWHygq7rWftZ1o7/emQ3zC1ltt5Z0AlNmrKr9Vk
         dR9HfuYWGiBfaZlawEQMXj4b83WZpcwV6y9tXjc2zxI+SRflttz9BEsJf1ug+DvEitX6
         gNCqbaV/vNXDZAcOFyH2EHiBX6b7H7TCwDVWdJ7+J4Nkvj5hX0EoydS5Ht9dD9mN1WJE
         EzSJyU785sPmbbW0Du0DImenj3n2bPyTrOgFJPsXZw+DY9RvfUT8kW0GudSAmLqdod3g
         gahw==
X-Gm-Message-State: APjAAAWqEgYViOhCb8ABJjWV/bIYrqo90ZyqccNY7DZAeoCukTiW1+PI
        RzB/VH+UEKYeVUYKmiHENRD+INy1yUj0MlJWruA=
X-Google-Smtp-Source: APXvYqxcw1iiyKTIaWlMALLu1SIiLnBEhqmQUcvXKh/g7GsD/FPGgDPe2jnhBf9a0lyCI4xaSLzIkbeQMvujiaYmftY=
X-Received: by 2002:a05:620a:249:: with SMTP id q9mr5601851qkn.491.1570124400731;
 Thu, 03 Oct 2019 10:40:00 -0700 (PDT)
MIME-Version: 1.0
References: <1570121672-12172-1-git-send-email-zdai@linux.vnet.ibm.com>
In-Reply-To: <1570121672-12172-1-git-send-email-zdai@linux.vnet.ibm.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 3 Oct 2019 10:39:49 -0700
Message-ID: <CAKgT0Udz7vt5C=+6vpFPbys4sODAZtCjrkSvOdgP80rX7Ww+Ng@mail.gmail.com>
Subject: Re: [v1] e1000e: EEH on e1000e adapter detects io perm failure can
 trigger crash
To:     David Dai <zdai@linux.vnet.ibm.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, zdai@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 9:59 AM David Dai <zdai@linux.vnet.ibm.com> wrote:
>
> We see the behavior when EEH e1000e adapter detects io permanent failure,
> it will crash kernel with this stack:
> EEH: Beginning: 'error_detected(permanent failure)'
> EEH: PE#900000 (PCI 0115:90:00.1): Invoking e1000e->error_detected(permanent failure)
> EEH: PE#900000 (PCI 0115:90:00.1): e1000e driver reports: 'disconnect'
> EEH: PE#900000 (PCI 0115:90:00.0): Invoking e1000e->error_detected(permanent failure)
> EEH: PE#900000 (PCI 0115:90:00.0): e1000e driver reports: 'disconnect'
> EEH: Finished:'error_detected(permanent failure)'
> Oops: Exception in kernel mode, sig: 5 [#1]
> NIP [c0000000007b1be0] free_msi_irqs+0xa0/0x280
>  LR [c0000000007b1bd0] free_msi_irqs+0x90/0x280
> Call Trace:
> [c0000004f491ba10] [c0000000007b1bd0] free_msi_irqs+0x90/0x280 (unreliable)
> [c0000004f491ba70] [c0000000007b260c] pci_disable_msi+0x13c/0x180
> [c0000004f491bab0] [d0000000046381ac] e1000_remove+0x234/0x2a0 [e1000e]
> [c0000004f491baf0] [c000000000783cec] pci_device_remove+0x6c/0x120
> [c0000004f491bb30] [c00000000088da6c] device_release_driver_internal+0x2bc/0x3f0
> [c0000004f491bb80] [c00000000076f5a8] pci_stop_and_remove_bus_device+0xb8/0x110
> [c0000004f491bbc0] [c00000000006e890] pci_hp_remove_devices+0x90/0x130
> [c0000004f491bc50] [c00000000004ad34] eeh_handle_normal_event+0x1d4/0x660
> [c0000004f491bd10] [c00000000004bf10] eeh_event_handler+0x1c0/0x1e0
> [c0000004f491bdc0] [c00000000017c4ac] kthread+0x1ac/0x1c0
> [c0000004f491be30] [c00000000000b75c] ret_from_kernel_thread+0x5c/0x80
>
> Basically the e1000e irqs haven't been freed at the time eeh is trying to
> remove the the e1000e device.
> Need to make sure when e1000e_close is called to bring down the NIC,
> if adapter error_state is pci_channel_io_perm_failure, it should also
> bring down the link and free irqs.
>
> Reported-by: Morumuri Srivalli  <smorumu1@in.ibm.com>
> Signed-off-by: David Dai <zdai@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> index d7d56e4..cf618e1 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -4715,7 +4715,8 @@ int e1000e_close(struct net_device *netdev)
>
>         pm_runtime_get_sync(&pdev->dev);
>
> -       if (!test_bit(__E1000_DOWN, &adapter->state)) {
> +       if (!test_bit(__E1000_DOWN, &adapter->state) ||
> +           (adapter->pdev->error_state == pci_channel_io_perm_failure)) {
>                 e1000e_down(adapter, true);
>                 e1000_free_irq(adapter);

It seems like the issue is the fact that e1000_io_error_detected is
calling e1000e_down without the e1000_free_irq() bit. Instead of doing
this couldn't you simply add the following to e1000_is_slot_reset in
the "result = PCI_ERS_RESULT_DISCONNECT" case:
    if (netif_running(netdev)
        e1000_free_irq(adapter);

Alternatively we could look at freeing and reallocating the IRQs in
the event of an error like we do for the e1000e_pm_freeze and
e1000e_pm_thaw cases. That might make more sense since we are dealing
with an error we might want to free and reallocate the IRQ resources
assigned to the device.

Thanks.

- Alex
