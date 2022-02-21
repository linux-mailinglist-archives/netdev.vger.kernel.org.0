Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F3D4BE73F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356471AbiBULd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:33:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356454AbiBULd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:33:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CB2DF35;
        Mon, 21 Feb 2022 03:33:04 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645443182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DDK33/3302m/AxEjlqU7JR5WuOZd5Q+b5EdJBto11HM=;
        b=4YWj9EREiqE/4z9lRjzJiDCe2ileZomSn6vZTDKEA8y5hupG1tPoR9ME40N7lwiDuHKnd6
        bcQu7W7k5DaojT3yK5NmzHCUrcF1n8VlVruftElI4NfwOO8ZQPS3UnAfpZb8xa/xHf/iqP
        i5I/K0uVgBgff9mnMZa0DYj/Kapi0TG3lgoiu+44QmimuDoQM3430lXOiok7/pUQia5GpH
        Ylj14nB7AMUylwdSAC/roiPE0FO9S6u7A7esTSu4jHDP9twbIL+yA6N2rmuvblNGmoKJTQ
        ZVXctRztuqb5og+i/uU7LPW3OfyMcFO7dLcu04vjiF2XKZMsKMpzgB5Ud+K9Fw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645443182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DDK33/3302m/AxEjlqU7JR5WuOZd5Q+b5EdJBto11HM=;
        b=DzX8bC47wbA5MEoCl2FNLvxhuTBdRP0FKtqmoDsNab1UVrwMOS5/w3bVrPlaMJTRrjXqJy
        jWEr89tMGCNNl/DA==
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
In-Reply-To: <87a6ekleye.ffs@tglx>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
 <Ygu6UewoPbYC9yPa@google.com> <Ygu9xtrMxxq36FRH@linutronix.de>
 <YgvD1HpN2oyalDmj@google.com> <YgvH4ROUQVgusBdA@linutronix.de>
 <YgvJ1fCUYmaV0Mbx@google.com> <87a6ekleye.ffs@tglx>
Date:   Mon, 21 Feb 2022 12:33:02 +0100
Message-ID: <875yp8laj5.ffs@tglx>
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

Lee & al!

On Mon, Feb 21 2022 at 10:57, Thomas Gleixner wrote:
> On Tue, Feb 15 2022 at 15:42, Lee Jones wrote:
>> What is your preference Thomas?
>
> I suggest doing it the following way:
>
>  1) I apply 1/7 on top of -rc5 and tag it

That's what I did now. The tag to pull from is:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-api-2022-02-21

>  2) Driver maintainers who want to merge via their trees pull that tag
>     apply the relevant driver changes
>
>  3) I collect the leftovers and merge them via irq/core

So everyone who wants to merge the relevant driver changes, please pull
and let me know which driver patch(es) you merged. I'll pick up the
leftovers after -rc6.

Thanks,

        tglx
