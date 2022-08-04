Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435C1589900
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 10:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiHDIJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 04:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiHDIJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 04:09:07 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A7861DB7;
        Thu,  4 Aug 2022 01:09:05 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id 87CCF30B294D;
        Thu,  4 Aug 2022 10:08:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=75y5J
        ihEG2zLOJnx73++LBd8iSlW3eLMfTDQnzOg4NQ=; b=Cv7Sk9VnZ7IJDtv6R8aTV
        BozUZHu89RzaeEEqx2/5JE/gJqiX1K2cFQQ8+nj0ghbdWy+OKgznB3zXAuOww4dF
        vI7lM2EcgGcG+rpGti9RkQB2qcSOPJa6xZZ9KUiIQw+RtZ2VI+4ybbx2txZL2Sve
        oxJ9djkz/pRrpLak9zRzv7616qjnq4fA3xhU47hO1rT+/Po1BjnRH+NKMoQBBcOq
        oISakBCuNMH2T+iRCzuqJR53QuXdL/5NJFa+9P1RpNr4IXo49pSMxgXAME0uEMoE
        5pytxVXTvWiooMjh63WRNsB+Wq0E+tNo3d/0vukToyflaGdVwunk0IFGrFSXoT0V
        A==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id 97D3B30B2951;
        Thu,  4 Aug 2022 10:08:33 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 27488XpM012874;
        Thu, 4 Aug 2022 10:08:33 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 27488XhV012873;
        Thu, 4 Aug 2022 10:08:33 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>
Subject: Re: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Thu, 4 Aug 2022 10:08:25 +0200
User-Agent: KMail/1.9.10
Cc:     Vincent Mailhol <vincent.mailhol@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Jiri Novak <jnovak@fel.cvut.cz>,
        Oliver Hartkopp <socketcan@hartkopp.net>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz> <202208020937.54675.pisa@cmp.felk.cvut.cz> <20220803090436.o3c7khieckxwmj5y@pengutronix.de>
In-Reply-To: <20220803090436.o3c7khieckxwmj5y@pengutronix.de>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202208041008.25730.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Wednesday 03 of August 2022 11:04:36 Marc Kleine-Budde wrote:
> On 02.08.2022 09:37:54, Pavel Pisa wrote:
> > See 2.14.1 Loopback mode
> > SETTINGS[ILBP]=1.
> >
> > in the datasheet
> >
> >   http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/doc/Datasheet.pdf
>
> BTW: the datasheet says:
> | 3.1.36 RX_DATA
> |
> | ... this register must be read by 32 bit access.
>
> While there is a section that uses 8-bit accessed on that register:

Congratulation to watchfull reading.

The FPGA design is done so that 32, 16 and 8-bits read writes
are supported. But when you read only part of the RX data
register then you lose rest because FIFO advances to the next
32-bit word. That is reasonable solution for 32-bit systems.

There has been added option in 3.0 version to switch into mode
where FIFO doe not advance when RX_DATA is read, then you can
read it by 8 or 16 bits. If MODES[RXBAM]=0 is set. Then advance
to the next world is requested by COMMAND[RXRPMV] bit.
Ondrej Ille considered that mode for for some embedded
use of the core connected to some small MCU. But this
mode causes great overhead in the driver, multiple reads
of RX_DATA followed by write to to COMMAND. I would consider
only default 32-bit mode for Linux driver.  

In the fact, to connect to 16-bit systems, my preference would
be to add option into design to select if Rx FIFO advances
by read of LSB or MSB of the RX_DATA register.

Anyway, command register needs at least 16-bit accesses
for now to correctly command operation, for 8-bit it would
require catch one written byte into latch and combine
it with another one written to the other part and this
would require locking around each command write...

For priority register we need at least 16-bit single write
cycle access when 4 TX buffers are used in FIFO configuration.

I do not intend to complicate driver for all these edge cases
when our target on regular Linux systems is utilize 32-bit
busses...

Actual driver uses only 32-bit access exclusively...

Thanks for the checks and suggestions,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

