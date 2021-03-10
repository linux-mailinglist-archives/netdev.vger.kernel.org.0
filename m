Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7B1333768
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhCJIfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:35:40 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58426 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhCJIfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:35:21 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615365319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KNVv9IVPxme33ODhBvY9HeZ8n0HmbebZpSdkkLbTl8w=;
        b=xfcn6vZDFxE8PRpzk6pS7M+ebcY4niw6TUF7ZHp9kuQg/NUkf9Cl0sp6cBgeuRhOwjsv4n
        6kiZ/RexPCwPtrvtgw3YaZSy/74AyJhGo1wiG2jmbqZlcMEQUvpFXNI/vUw7wqbywoKrYK
        NqyMhuocQ698IZO1jv5Ts0taF01QuAanHRqnFHcO+iEVFmNA2p5mnEGzpnzVSM7O1fIwuQ
        SIiAKhVr0BMGmhHSXnWDgBZ83AfYFaAb55Lpcwj6t5B+uAQsAfAj88wHnY5V7eRWZeKzJC
        t02OHr1r//zhTizh5lwXtvfoua49UHnjG7o/KlA3k7QiRYlLQMQ1qnx7kOBXvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615365319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KNVv9IVPxme33ODhBvY9HeZ8n0HmbebZpSdkkLbTl8w=;
        b=9Gm97OGZ8/wBob3qxo3W9D+xqmPG4Mhj//BKk0KKZET0EAIo5+tOK5O1kbF76YtX9/VoJT
        SAU2q1mI3E4g07Ag==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [patch 07/14] tasklets: Prevent tasklet_unlock_spin_wait() deadlock on RT
In-Reply-To: <20210309152154.jqi62ep2ndkpoikc@linutronix.de>
References: <20210309084203.995862150@linutronix.de> <20210309084241.988908275@linutronix.de> <20210309150036.5rcecmmz2wbu4ypc@linutronix.de> <20210309152154.jqi62ep2ndkpoikc@linutronix.de>
Date:   Wed, 10 Mar 2021 09:35:18 +0100
Message-ID: <87y2ev4da1.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09 2021 at 16:21, Sebastian Andrzej Siewior wrote:

> On 2021-03-09 16:00:37 [+0100], To Thomas Gleixner wrote:
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 07c7329d21aa7..1c14ccd351091 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -663,15 +663,6 @@ static inline int tasklet_trylock(struct tasklet_struct *t)
>>  void tasklet_unlock(struct tasklet_struct *t);
>>  void tasklet_unlock_wait(struct tasklet_struct *t);
>>  
>> -/*
>> - * Do not use in new code. Waiting for tasklets from atomic contexts is
>> - * error prone and should be avoided.
>> - */
>> -static inline void tasklet_unlock_spin_wait(struct tasklet_struct *t)
>> -{
>> -	while (test_bit(TASKLET_STATE_RUN, &t->state))
>> -		cpu_relax();
>> -}
>
> Look at that. The forward declaration for tasklet_unlock_spin_wait()
> should have remained. Sorry for that.

No idea how I managed to mess that up and fail to notice. Brown
paperbags to the rescue.

Thanks,

        tglx
