Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC2C4A4734
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 13:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359430AbiAaMeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 07:34:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:59374 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbiAaMe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 07:34:29 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643632468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dBEcvYbqh//2SnFN4JWRklzkIk5olbEekSf6NVi12CY=;
        b=yNZw9EXdb1mDwgxZOVAqVOHqbkDbwhiToYVizl0NUvcbg02zHcXDZFlrsEYqZbiqir84YN
        fo7so0sY/5unvwFx2o5YLNwgNctM6VnaPMeDuGlWpK9/z1SZnKBke+HRXZ1k2JqjgxcDBX
        w1qQ4WthhO3RuhmD6ENYU5Rh04gyVDDQMn7p+bWxrAhWEs2wgGfsDBe+Ts+oDiFbB38GSi
        EYO5tE6N5z5KM9qRdvmlgprX6i0vaOiTN1okppQLcnWO1vLwyAlnSvqqJ2mOtCUWJ4ZIIx
        zUHSmieBmCo/2NHEa6eTi6qpR8/NSDEnSau0yvPh+WR/aeMpzF1mnMRaYfSP4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643632468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dBEcvYbqh//2SnFN4JWRklzkIk5olbEekSf6NVi12CY=;
        b=ke3JpB/kI9Ysv7q2qZM4iV96Dcn8lW3H1+UnjRbVekC1PwvCwqvPwSUA4TNEDdiaWZJXep
        5hoRRl/crBvrm7Dw==
To:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v2 0/7] Provide and use generic_handle_irq_safe() where appropriate.
Date:   Mon, 31 Jan 2022 13:33:57 +0100
Message-Id: <20220131123404.175438-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

generic_handle_irq() must be used from primary IRQ-handler (chain
handler/ interrupt controller entry). It is low level code and the
function expects that interrupts are disabled at entry point.

This isn't the case for invocations from tasklets, workqueues or the
primary interrupt handler on PREEMPT_RT. Once this gets noticed a
"local_irq_disable|safe()" is added. To avoid further confusion this
series adds generic_handle_irq_safe() which can be used from any context
and adds a few user.

v2=E2=80=A6v1:
 - Redo kernel-doc for generic_handle_irq_safe() in #1.
 - Use generic_handle_irq_safe() instead of generic_handle_irq() in the
   patch description where I accidently used the wrong one.

v1:
   https://lore.kernel.org/all/20220127113303.3012207-1-bigeasy@linutronix.=
de/

Sebastian
