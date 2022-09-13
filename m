Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C14405B6B40
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 11:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiIMJ7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 05:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiIMJ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 05:59:51 -0400
Received: from mail.tkos.co.il (wiki.tkos.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422A36435
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 02:59:40 -0700 (PDT)
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.tkos.co.il (Postfix) with ESMTPS id 64E4C44071E;
        Tue, 13 Sep 2022 12:58:13 +0300 (IDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1663063093;
        bh=pLu9dFGfPDsWYv5XITtpDJnb/Q8PFr0ccWHxdzwMl6w=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=f+Dl+WD1LDmIo5T8+5DB0nCxPFAuo39IBbsOGaVDwp8YDMUOVCLlSLXZ90L9MZeHG
         tFRHLQmbMij4mDyAuiFGtrljRJNuvZ8CvUUJV8B/p7tzAxqXEZfIasD/NozFQuo3f5
         lIPOiXUPlm27MAekQhmQtE2kduhpjZVLV1aCvmOdqT6zXnAtdcG/Spk3DopYhTrQaA
         o55LgQ/uvRYLSkQ9+0kmOr1xRdyKmDb5R09NzaLlJDZeFx3/M+uyWDgtIbey9BHl/w
         yuW6NSrdOeemjHnkSeW1PmcdjfQPKvxetObDjR36liqt00HIQEDFx735AZR+ogSRrl
         Z5rP/lMQdoCgg==
References: <5934427dadd3065b125b80c38a111320677fa723.1663055018.git.baruch@tkos.co.il>
 <YyA1sfZRuoka8yhl@shell.armlinux.org.uk>
User-agent: mu4e 1.8.7; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Baruch Siach <baruch.siach@siklu.com>
Subject: Re: [PATCH] net: sfp: workaround GPIO input signals bounce
Date:   Tue, 13 Sep 2022 12:54:26 +0300
In-reply-to: <YyA1sfZRuoka8yhl@shell.armlinux.org.uk>
Message-ID: <87czbz1to6.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Tue, Sep 13 2022, Russell King (Oracle) wrote:
> On Tue, Sep 13, 2022 at 10:43:38AM +0300, Baruch Siach wrote:
>> From: Baruch Siach <baruch.siach@siklu.com>
>> 
>> Add a trivial debounce to avoid miss of state changes when there is no
>> proper hardware debounce on the input signals. Otherwise a GPIO might
>> randomly indicate high level when the signal is actually going down,
>> and vice versa.
>> 
>> This fixes observed miss of link up event when LOS signal goes down on
>> Armada 8040 based system with an optical SFP module.
>
> NAK. This needs more inteligent handling. For systems where we poll,
> your code introduces a 100us delay each time we poll and there has
> been no change.

I think we can avoid delay in the poll case by skipping the delay loop
when sfp->need_poll is true.

I'll send v2 with that fixed tomorrow.

Thanks for reviewing,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
