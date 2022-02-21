Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FBB4BDC3E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355163AbiBUKgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:36:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355182AbiBUKf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:35:59 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1191140EF;
        Mon, 21 Feb 2022 01:57:32 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645437450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CbvypUV4PljgvnNET61NtCqtxN9TG2dxR/pcJjN8TKk=;
        b=Z1PtO3+o0SylAySoCVISwmJoQ/VDToBIk/QWBbSsyPUPxvKz4lEmz/FtewIfJxUP1WFSgX
        CkPsHINPU/jaMa09H51sIvO35dc7q6pgc+CLG/k14SsmA9PDo0wDmvtM2ejAXjdfL4C/6c
        Q66kJqhzEMb0cY1wnZPkgBQ7+t4LcIZwAT7aMaSY8qYLeWGYlMrLPufSNep14AgxtCOmiR
        EIMwZ8zVAFh4lWS0wPv/IT7833I40UFZIJ6KPlh6GpS1sEKf+LGHXVOvkDI7Dww4Vk0tRy
        6hPW2W5UPBPLteNTnx+gu78G6NU3TiQ7b2fAaD/Bjm1XtACv4i4WSg7JhQaIZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645437450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CbvypUV4PljgvnNET61NtCqtxN9TG2dxR/pcJjN8TKk=;
        b=y78lXjA5DpGSvbgDzZAMDOKwtFxAoVIuHQELT/smmXEPXBj9QptRh1I2zqMkiPUhfbxDSR
        ux63licBrEo4dvCQ==
To:     Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH v4 0/7] Provide and use generic_handle_irq_safe() where
 appropriate.
In-Reply-To: <YgvJ1fCUYmaV0Mbx@google.com>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
 <Ygu6UewoPbYC9yPa@google.com> <Ygu9xtrMxxq36FRH@linutronix.de>
 <YgvD1HpN2oyalDmj@google.com> <YgvH4ROUQVgusBdA@linutronix.de>
 <YgvJ1fCUYmaV0Mbx@google.com>
Date:   Mon, 21 Feb 2022 10:57:29 +0100
Message-ID: <87a6ekleye.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee,

On Tue, Feb 15 2022 at 15:42, Lee Jones wrote:
> On Tue, 15 Feb 2022, Sebastian Andrzej Siewior wrote:
>> Either way it remains bisect-able since each driver is changed
>> individually. There is no need to merge them in one go but since it is
>> that small it probably makes sense. But I don't do the logistics here.
>
> Okay, this is what I was asking.
>
> So there aren't any hard dependencies between the driver changes?
>
> Only the drivers are dependent on the API.

Correct.

> So, if we choose to do so, we can merge the API and then subsequently
> add the users one by one into their respective subsystem, in any
> order.  This would save on creating an immutable topic branch which we
> all pull from.
>
> What is your preference Thomas?

I suggest doing it the following way:

 1) I apply 1/7 on top of -rc5 and tag it

 2) Driver maintainers who want to merge via their trees pull that tag
    apply the relevant driver changes

 3) I collect the leftovers and merge them via irq/core

Does that make sense?

Thanks,

        tglx
