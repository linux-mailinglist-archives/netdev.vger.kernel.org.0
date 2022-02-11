Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F34B2C97
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 19:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352481AbiBKSPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 13:15:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243798AbiBKSPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 13:15:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBA6CEC;
        Fri, 11 Feb 2022 10:15:15 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644603314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Jch/i8uwHhLcWwzAXjXbpVM1d+fcbfplWSgVCHBbLA=;
        b=4D/q+XgJSZYSQlhj03Sz02vFzH0GlhuNwlthKN6riQhMDD5++CNjRWRcUMnZgTF6IBP3g+
        oVovZg1UiRbqNOfXL0Ug7sEEW4I3gnhSbXiXYVhaBj8SJYSe2JWU3L8TKTnBfBv8NavXia
        PyE9hT1yki7U6ColR/pFgse4NAZ/XUCOOMQ9vWvtJ3Wf6CwrwuYA8smeI/TJiIi1F/bnNA
        ICPcSYmM6pbexOSlIEOuzn25pRO4Bxmw6wAdc3bITdm6KueiS+ZXZavgXe1fqxcpMkZDPn
        q8/SFFbpIkYrb4pOWN4iyRS8zM59QXHJ0V6VD/B2dZShpq1NX8pyPrf8htxzpQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644603314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Jch/i8uwHhLcWwzAXjXbpVM1d+fcbfplWSgVCHBbLA=;
        b=KXgaU3Wb016ElAJR2Uy5MlhgU1MfzTrdx0FxVToYcGImm6/t7L7V1ELxpOGiJMCXbJpX1K
        HuuVJ5o6ZABaOlBA==
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
Subject: [PATCH v4 0/7] Provide and use generic_handle_irq_safe() where appropriate.
Date:   Fri, 11 Feb 2022 19:14:53 +0100
Message-Id: <20220211181500.1856198-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

handler/ interrupt controller entry). It is low level code and the
function expects that interrupts are disabled at entry point.

This isn't the case for invocations from tasklets, workqueues or the
primary interrupt handler on PREEMPT_RT. Once this gets noticed a
"local_irq_disable|safe()" is added. To avoid further confusion this
series adds generic_handle_irq_safe() which can be used from any context
and adds a few user.

v2=E2=80=A6v4:
  - Correct kernel doc for generic_handle_irq_safe() as per Wolfram Sang.
  - Use "misc" instead of "mfd" for the hi6421-spmi-pmic driver.

v2=E2=80=A6v1:
 https://lore.kernel.org/all/20220131123404.175438-1-bigeasy@linutronix.de/
 - Redo kernel-doc for generic_handle_irq_safe() in #1.
 - Use generic_handle_irq_safe() instead of generic_handle_irq() in the
   patch description where I accidently used the wrong one.
v1:
 https://lore.kernel.org/all/20220127113303.3012207-1-bigeasy@linutronix.de/


