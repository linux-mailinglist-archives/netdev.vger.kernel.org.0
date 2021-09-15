Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B747F40C2B0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbhIOJZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:25:13 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:57710 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhIOJZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:25:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DA9C93EA68;
        Wed, 15 Sep 2021 11:23:45 +0200 (CEST)
Date:   Wed, 15 Sep 2021 11:23:43 +0200
From:   Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ath9k: interrupt fixes on queue reset
Message-ID: <YUG7n24qcn/AmuT8@sellars>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
 <87a6kf6iip.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a6kf6iip.fsf@toke.dk>
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Tue, Sep 14, 2021 at 09:53:34PM +0200, Toke Høiland-Jørgensen wrote:
> Linus Lüssing <linus.luessing@c0d3.blue> writes:
> 
> > Hi,
> >
> > The following are two patches for ath9k to fix a potential interrupt
> > storm (PATCH 2/3) and to fix potentially resetting the wifi chip while
> > its interrupts were accidentally reenabled (PATCH 3/3).
> 
> Uhh, interesting - nice debugging work! What's the user-level symptom of
> this? I.e., when this triggers does the device just appear to hang, or
> does it cause reboots, or?
> 
> -Toke
> 

For PATCH 2/3 the user-level symptom was that the system would
hang for a few seconds and would then silently reboot without any notice
on the serial console. And after disabling CONFIG_ATH79_WDT the
system would "hang" indefinitely without any notice on the console
without a reboot (while JTAG/gdb showed that it was entering ath_isr()
again and again and wasn't doing anything else).

For PATCH 3/3 I don't have a specific user-level symptom. But from
looking at the git history it seemed to me that the ath9k hw
interrupts (AR_IER, AR_INTR_ASYNC_ENABLE and AR_INTR_ASYNC_ENABLE off)
should be disabled during a reset:

  4668cce527ac ath9k: disable the tasklet before taking the PCU lock
  eaf04a691566 ath9k: Disable beacon tasklet during reset
  872b5d814f99 ath9k: do not access hardware on IRQs during reset
  e3f31175a3ee ath9k: fix race condition in irq processing during hardware reset

Maybe someone else on these lists might know what issues this can
cause exactly?

Regards, Linus
