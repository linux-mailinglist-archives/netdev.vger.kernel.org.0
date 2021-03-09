Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62046332A44
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbhCIPWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:22:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:53654 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhCIPV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:21:57 -0500
Date:   Tue, 9 Mar 2021 16:21:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615303316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMzJIAXAV30j1DWB/JqGaPTwHrsv+jgx0jyX1dMqhMo=;
        b=ftswzIWj+SpSqfoTdsjF9jYwsUZ7QmSJS28/2TmLeNwsNz3k9sItFtSmMQHJzTTAHn1l73
        X+AI4oxoI9xuqHQn5N6yGS5zmQBFXR0sTTbBaSkyJmPokZkhKGw5Rt7yRIYgOKSlxAKO0/
        iWLjf9J4+Z1WYG8e1cBqukW+PvN+5Ehe98iK5Rn4W18d+n8AQp/tUbMjdvpHpBfRWh+hv0
        dTH35w1YOniiaqyYXdtLhDSVEwB9BzITsk5FUychB6d1PBB4HBn0l/ucowPnKkeX1cn/Qr
        OsWuvmgbW5tqyJ46C2kczn/yc1oKeJZzac9Ax/3fHVAWZ8+U6G4IkveXKBd7nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615303316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dMzJIAXAV30j1DWB/JqGaPTwHrsv+jgx0jyX1dMqhMo=;
        b=7I+TC8Pc4LH6B4D6vhEbJbVGv2HrVwmyRUmFwd62TcoO/FW4sNuDVvS4FldBwqa7cxztZ3
        iHD0Tkwptxth9xAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Subject: Re: [patch 07/14] tasklets: Prevent tasklet_unlock_spin_wait()
 deadlock on RT
Message-ID: <20210309152154.jqi62ep2ndkpoikc@linutronix.de>
References: <20210309084203.995862150@linutronix.de>
 <20210309084241.988908275@linutronix.de>
 <20210309150036.5rcecmmz2wbu4ypc@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210309150036.5rcecmmz2wbu4ypc@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-09 16:00:37 [+0100], To Thomas Gleixner wrote:
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 07c7329d21aa7..1c14ccd351091 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -663,15 +663,6 @@ static inline int tasklet_trylock(struct tasklet_struct *t)
>  void tasklet_unlock(struct tasklet_struct *t);
>  void tasklet_unlock_wait(struct tasklet_struct *t);
>  
> -/*
> - * Do not use in new code. Waiting for tasklets from atomic contexts is
> - * error prone and should be avoided.
> - */
> -static inline void tasklet_unlock_spin_wait(struct tasklet_struct *t)
> -{
> -	while (test_bit(TASKLET_STATE_RUN, &t->state))
> -		cpu_relax();
> -}

Look at that. The forward declaration for tasklet_unlock_spin_wait()
should have remained. Sorry for that.

Sebastian
