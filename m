Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF927B495
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgI1SgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:36:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40446 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgI1SgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:36:00 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601318158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2q0+ELPoZ5eyuPnX8ffs96ygX/los/7drukV7oWsx/4=;
        b=yG8QS3MZe+ukoPMvaKn69smtxPS5qDSENJbro5P5ogvchdoZnzj/5OTvmEBBH5VaA3CAAZ
        zcmb9b/5fPIgNVPJ++k0XOKgb8DwPrOUT4UEteborj7PdqTGXvkzDhUn42lJo9kLVN0SFp
        3XBBq3jqtkaGBfM/lX3J1ATtoAgRX7dI+aB6WedW9sTO9tyjhZ/o1KGFSw1/8UCXa+BCsp
        RoHJFy9qS+srhHsXjC50laTO/NCFoAWMUVilYmsIkHDzVSEfrwo0bP7lCLaQiXCMvW4i7T
        Y667dxrhW1CBUXPCyqqU8L8o9G91F4aPM37k2jvbCnnOH1Xdowg0LtKasq1Q+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601318158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2q0+ELPoZ5eyuPnX8ffs96ygX/los/7drukV7oWsx/4=;
        b=Lu+UQmBL6hgNN4B167UoD/kUuJ5sFTUJtYQztdeIdoemwdHDwUkUqvqpmQNk25Qp5Lctac
        +YROudbC8bzGLLBg==
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>,
        davem@davemloft.net, hchunhui@mail.ustc.edu.cn, hdanton@sina.com,
        ja@ssi.bg, jmorris@namei.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: WARNING in hrtimer_forward
In-Reply-To: <20200928171137.16804-1-hdanton@sina.com>
References: <0000000000007d5ec805b04c5fc8@google.com> <20200928171137.16804-1-hdanton@sina.com>
Date:   Mon, 28 Sep 2020 20:35:58 +0200
Message-ID: <87mu19kaup.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29 2020 at 01:11, Hillf Danton wrote:
> On Mon, 28 Sep 2020 18:13:42 +0200 Thomas Gleixner wrote:
>> So the timer was armed at some point and then the expiry which does the
>> forward races with the ioctl which starts the timer. Lack of
>> serialization or such ...
>
> To make syzbot happy, s/hrtimer_is_queued/hrtimer_active/ can close
> that race but this warning looks benign.

Why only make sysbot happy? It's clearly an issue and the warning is not
benign simply because forwarding a queued timer is an absolute NONO.
timers (both timer_list and hrtimer) need external synchronization.

> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -1698,7 +1698,7 @@ static int mac80211_hwsim_config(struct
>  
>  	if (!data->started || !data->beacon_int)
>  		hrtimer_cancel(&data->beacon_timer);
> -	else if (!hrtimer_is_queued(&data->beacon_timer)) {
> +	else if (!hrtimer_active(&data->beacon_timer)) {
>  		u64 tsf = mac80211_hwsim_get_tsf(hw, NULL);
>  		u32 bcn_int = data->beacon_int;
>  		u64 until_tbtt = bcn_int - do_div(tsf, bcn_int);
> @@ -1768,7 +1768,7 @@ static void mac80211_hwsim_bss_info_chan
>  			  info->enable_beacon, info->beacon_int);
>  		vp->bcn_en = info->enable_beacon;
>  		if (data->started &&
> -		    !hrtimer_is_queued(&data->beacon_timer) &&
> +		    !hrtimer_active(&data->beacon_timer) &&
>  		    info->enable_beacon) {
>  			u64 tsf, until_tbtt;
>  			u32 bcn_int;

Looks about right.

Thanks,

        tglx


   
