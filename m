Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3306EFA91
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236239AbjDZTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDZTCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:02:17 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738CB4EEE;
        Wed, 26 Apr 2023 12:02:15 -0700 (PDT)
Received: from fpc (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 857BF40737C2;
        Wed, 26 Apr 2023 19:02:12 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 857BF40737C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682535732;
        bh=Hci5Fs5rjSIYgfjRizuid/Dg+BFCqJm+5MJ4kJ1cA5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IGuA/mG1zKJtqVB11lfuxKAFYJq+CQfMXIiMrkbY2ZB39b8t5UXf8QoBDqXAMa67j
         TIt/gkqZZccrqZXUrHRK1W6KzAVCx+nI7CGckQUJs1RsKBz9hrOciAmDw6NKXIz7DV
         Wd81qpL6YQu4ughg2AHpNsz+gaPbgCkrtPk9+dQc=
Date:   Wed, 26 Apr 2023 22:02:06 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Hillf Danton <hdanton@sina.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Vallo <kvalo@kernel.org>,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v3 1/2] wifi: ath9k: fix races between ath9k_wmi_cmd and
 ath9k_wmi_ctrl_rx
Message-ID: <20230426190206.ni2au5mpjc5oty67@fpc>
References: <20230425192607.18015-1-pchelkin@ispras.ru>
 <20230425230708.2132-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425230708.2132-1-hdanton@sina.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 26, 2023 at 07:07:08AM +0800, Hillf Danton wrote: 
> Given similar wait timeout[1], just taking lock on the waiter side is not
> enough wrt fixing the race, because in case job done on the waker side,
> waiter needs to wait again after timeout.
> 

As I understand you correctly, you mean the case when a timeout occurs
during ath9k_wmi_ctrl_rx() callback execution. I suppose if a timeout has
occurred on a waiter's side, it should return immediately and doesn't have
to care in which state the callback has been at that moment.

AFAICS, this is controlled properly with taking a wmi_lock on waiter and
waker sides, and there is no data corruption.

If a callback has not managed to do its work entirely (performing a
completion and subsequently waking waiting thread is included here), then,
well, it is considered a timeout, in my opinion.

Your suggestion makes a wmi_cmd call to give a little more chance for the
belated callback to complete (although timeout has actually expired). That
is probably good, but increasing a timeout value makes that job, too. I
don't think it makes any sense on real hardware.

Or do you mean there is data corruption that is properly fixed with your
patch?

That is, I agree there can be a situation when a callback makes all the
logical work it should and it just hasn't got enough time to perform a
completion before a timeout on waiter's side occurs. And this behaviour
can be named "racy". But, technically, this seems to be a rather valid
timeout.

> [1] https://lore.kernel.org/lkml/9d9b9652-c1ac-58e9-2eab-9256c17b1da2@I-love.SAKURA.ne.jp/
> 

I don't think it's a similar case because wait_for_completion_state() is
interruptible while wait_for_completion_timeout() is not.

> A correct fix looks like after putting pieces together
> 
> +++ b/drivers/net/wireless/ath/ath9k/wmi.c
> @@ -238,6 +238,7 @@ static void ath9k_wmi_ctrl_rx(void *priv
>  		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
>  		goto free_skb;
>  	}
> +	wmi->last_seq_id = 0;
>  	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
>  
>  	/* WMI command response */
> @@ -339,9 +340,20 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum
>  
>  	time_left = wait_for_completion_timeout(&wmi->cmd_wait, timeout);
>  	if (!time_left) {
> +		unsigned long flags;
> +		int wait = 0;
> +
>  		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
>  			wmi_cmd_to_name(cmd_id));
> -		wmi->last_seq_id = 0;
> +
> +		spin_lock_irqsave(&wmi->wmi_lock, flags);
> +		if (wmi->last_seq_id == 0) /* job done on the waker side? */
> +			wait = 1;
> +		else
> +			wmi->last_seq_id = 0;
> +		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
> +		if (wait)
> +			wait_for_completion(&wmi->cmd_wait);
>  		mutex_unlock(&wmi->op_mutex);
>  		return -ETIMEDOUT;
>  	}
