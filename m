Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00129D75E
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbgJ1WX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:23:26 -0400
Received: from depni-mx.sinp.msu.ru ([213.131.7.21]:25 "EHLO
        depni-mx.sinp.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732961AbgJ1WXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:23:03 -0400
X-Greylist: delayed 2401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Oct 2020 18:23:02 EDT
Received: from spider (unknown [176.192.246.239])
        by depni-mx.sinp.msu.ru (Postfix) with ESMTPSA id 16E1E1BF43D;
        Wed, 28 Oct 2020 14:43:37 +0300 (MSK)
From:   Serge Belyshev <belyshev@depni.sinp.msu.ru>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] r8169: fix operation under forced interrupt threading
References: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com>
Date:   Wed, 28 Oct 2020 14:43:33 +0300
In-Reply-To: <4d3ef84a-c812-5072-918a-22a6f6468310@gmail.com> (Heiner
        Kallweit's message of "Sun, 18 Oct 2020 18:38:59 +0200")
Message-ID: <877drabmoq.fsf@depni.sinp.msu.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> For several network drivers it was reported that using
> __napi_schedule_irqoff() is unsafe with forced threading. One way to
> fix this is switching back to __napi_schedule, but then we lose the
> benefit of the irqoff version in general. As stated by Eric it doesn't
> make sense to make the minimal hard irq handlers in drivers using NAPI
> a thread. Therefore ensure that the hard irq handler is never
> thread-ified.
>
> Fixes: 9a899a35b0d6 ("r8169: switch to napi_schedule_irqoff")
> Link: https://lkml.org/lkml/2020/10/18/19
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 7d366b036..3b6ddc706 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
...

Hi!  This patch actually breaks r8169 with threadirqs on an old box
where it was working before:

[    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA790FX-DQ6/GA-MA790FX-DQ6, BIOS F7g 07/19/2010
...
[    1.072676] r8169 0000:02:00.0 eth0: RTL8168b/8111b, 00:1a:4d:5d:6b:c3, XID 380, IRQ 18
...
[    8.850099] genirq: Flags mismatch irq 18. 00010080 (eth0) vs. 00002080 (ahci[0000:05:00.0])

(error is reported to userspace, interface failed to bring up).
Reverting the patch fixes the problem.
