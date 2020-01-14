Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D817413AD5C
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgANPRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:17:55 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38478 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgANPRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:17:54 -0500
Received: by mail-pf1-f194.google.com with SMTP id x185so6734314pfc.5;
        Tue, 14 Jan 2020 07:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NccOTQjRE3K/mry3ktyfcVSqMgiS7x0ndgHbwmuP8TQ=;
        b=eZt7jWyj1lFcAl+nxOMeOUkRlU/C5B9gtr1fYUIkxqtPV7ZLoHlFBT9L+nnBkuVvsI
         76KXt4W1Sc/eX0hJHYnfXtkmSrjtCzlZ4knqTozpPeGS4awMa/uhW5RKe5F5IK2KxtcC
         hSzOwtndvb3vc2n6un8ZoX7X3QF2T/PHZVi/kZFTqibdl06MqwPVw9EtcTZ7Xbs72esb
         OBxlvh7+wXJQbjJw+voB2QhTM2w3dpqxOA2xLLooA4mWpZxvX4FsZPnXWCM99GvyABb/
         hJDBBKujbLMqDpB5XfxABB6VDerelAx8BJIceJDqMh0DTximUuNaWkMvTKfp2kbMGLGf
         M9sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NccOTQjRE3K/mry3ktyfcVSqMgiS7x0ndgHbwmuP8TQ=;
        b=i47GzduhUsvnFM57j1NA7YQ8xQhWXKR5r5r9QlXL0uTfTv2PZ4u7wFQP8Qif3c/wkM
         PWjf5decpgSCE6sudoJAoj0E+lEjyEY61lqwj1TALuDdIf87b9pUnuI3hIYlcc8kvYFc
         3ilQa8UGVnbYS9WlOUaCn6iw5PgKLknLFpomr8J3FGoOe8UfpX95PA2RpuUUqMmDmuPc
         XeiUjk7Nx2fDaTQ06/R+Vo3kJlbWhk5/OTP54P1a5np9VbsfCfTrS2QhliVSjUagl51a
         k3T1ZaRCRrDuXMqXSmfYypCyE/K7lkn1sKRkygTxaI+XCGFKPTTLSksVzc1Rbis6di6b
         viPg==
X-Gm-Message-State: APjAAAU4I3C1rklI4BT/MTdYdBaknLnfWdEEW/HPphC9GMVAlBDpmDA/
        CWoiYMtWElIF13Tjm+FXXPs=
X-Google-Smtp-Source: APXvYqzwNEAFXEtPiRfWUAnOnIb8U9kJ3KgFoweLCKDYPBx7VAISFddFFf8Pt91PMer7e3JiwzH0Jw==
X-Received: by 2002:a63:b005:: with SMTP id h5mr26671855pgf.67.1579015073738;
        Tue, 14 Jan 2020 07:17:53 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s131sm20232099pfs.135.2020.01.14.07.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2020 07:17:52 -0800 (PST)
Subject: Re: [PATCH] can, slip: Protect tty->disc_data access with RCU
To:     Richard Palethorpe <rpalethorpe@suse.com>,
        linux-can@vger.kernel.org
Cc:     syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Tyler Hall <tylerwhall@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
References: <0000000000002b81b70590a83ad7@google.com>
 <20200114143244.20739-1-rpalethorpe@suse.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <19d5e4c6-72f4-631f-2ccd-b5df660a5ef6@gmail.com>
Date:   Tue, 14 Jan 2020 07:17:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200114143244.20739-1-rpalethorpe@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/14/20 6:32 AM, Richard Palethorpe wrote:
> write_wakeup can happen in parallel with close where tty->disc_data is set
> to NULL. So we a) need to check if tty->disc_data is NULL and b) ensure it
> is an atomic operation. Otherwise accessing tty->disc_data could result in
> a NULL pointer deref or access to some random location.
> 
> This problem was found by Syzkaller on slcan, but the same issue appears to
> exist in slip where slcan was copied from.
> 
> A fix which didn't use RCU was posted by Hillf Danton.
> 
> Fixes: 661f7fda21b1 ("slip: Fix deadlock in write_wakeup")
> Fixes: a8e83b17536a ("slcan: Port write_wakeup deadlock fix from slip")
> Reported-by: syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com
> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Tyler Hall <tylerwhall@gmail.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: syzkaller@googlegroups.com
> ---
> 
> Note, that mabye RCU should also applied to receive_buf as that also happens
> in interrupt context. So if the pointer assignment is split by the compiler
> then sl may point somewhere unexpected?
> 
>  drivers/net/can/slcan.c | 11 +++++++++--
>  drivers/net/slip/slip.c | 11 +++++++++--
>  2 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
> index 2e57122f02fb..ee029aae69d4 100644
> --- a/drivers/net/can/slcan.c
> +++ b/drivers/net/can/slcan.c
> @@ -344,7 +344,14 @@ static void slcan_transmit(struct work_struct *work)
>   */
>  static void slcan_write_wakeup(struct tty_struct *tty)
>  {
> -	struct slcan *sl = tty->disc_data;
> +	struct slcan *sl;
> +
> +	rcu_read_lock();
> +	sl = rcu_dereference(tty->disc_data);
> +	rcu_read_unlock();

This rcu_read_lock()/rcu_read_unlock() pair is not protecting anything.

Right after rcu_read_unlock(), sl validity can not be guaranteed.

> +
> +	if (!sl)
> +		return;
>  
>  	schedule_work(&sl->tx_work);
>  }
> @@ -644,7 +651,7 @@ static void slcan_close(struct tty_struct *tty)
>  		return;
>  
>  	spin_lock_bh(&sl->lock);
> -	tty->disc_data = NULL;
> +	rcu_assign_pointer(tty->disc_data, NULL);
>  	sl->tty = NULL;
>  	spin_unlock_bh(&sl->lock);



Where is the rcu grace period before freeing enforced ?

>  
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 2a91c192659f..dfed9f0b8646 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -452,7 +452,14 @@ static void slip_transmit(struct work_struct *work)
>   */
>  static void slip_write_wakeup(struct tty_struct *tty)
>  {
> -	struct slip *sl = tty->disc_data;
> +	struct slip *sl;
> +
> +	rcu_read_lock();
> +	sl = rcu_dereference(tty->disc_data);
> +	rcu_read_unlock();

Same here.

> +
> +	if (!sl)
> +		return;
>  
>  	schedule_work(&sl->tx_work);
>  }
> @@ -882,7 +889,7 @@ static void slip_close(struct tty_struct *tty)
>  		return;
>  
>  	spin_lock_bh(&sl->lock);
> -	tty->disc_data = NULL;
> +	rcu_assign_pointer(tty->disc_data, NULL);
>  	sl->tty = NULL;
>  	spin_unlock_bh(&sl->lock);
>  
> 
