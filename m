Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE0E49E101
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiA0LdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:33:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35616 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240422AbiA0LdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 06:33:13 -0500
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643283192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mYuhfjkgxLhE5J8QB5lsf+7ptUPDT96pRbbQPehAdC8=;
        b=XZCFerNUAmzCKjtqqGZwMhE9HSLl1QSDm2Q8IIOFsTVkH0Ajuh7tbVE3b450WaT3A5txzB
        h+M8uUgiQFmnLlpOlJR8+PZ6naF2+gpYPSawH9bTTZb6jMnXy8q7msFSx34FUYYiPT+Z8o
        kg0PCUg5FDRvNQn/tNgZYUtv5fmgkeUg+W2ouBsbS3Uyz+6iilSrRrSf3ZaPp5brxJ0tWg
        8rU+bFShHVDZmV4DlAxV/xw/Ub2+a9arOZc4gCByObSBEJS2rUqzLr5/AGk0jA7oonhXdJ
        SiGhhT4K75i/WNxqqMQc2k/ucIbPqYMekysfWa6QeXXYxFppvAvz9TtPOj48Ng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643283192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mYuhfjkgxLhE5J8QB5lsf+7ptUPDT96pRbbQPehAdC8=;
        b=GhwP9tvTaIPi+tfKsIwn4x++BLWbtaW9ubbbR0b2mwK09vTxnXqK716l0qaHvLBem+lW0L
        odIz4rEwqEU8I/Bw==
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 0/7] Provide and use generic_handle_irq_safe() where appropriate.
Date:   Thu, 27 Jan 2022 12:32:56 +0100
Message-Id: <20220127113303.3012207-1-bigeasy@linutronix.de>
MIME-Version: 1.0
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

Sebastian


