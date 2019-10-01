Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05D26C2BC7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 04:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfJACBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 22:01:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40798 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfJACBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 22:01:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id d26so3049662pgl.7
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 19:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t7NCYht/hKPrWnhRNMLRXCGKEG3wZX2G57GLtW79ZFU=;
        b=no5cFROCHp5qPGZfCGsc1G8V/iMfUe+B+SjUpkzevsoYKGHOJ2ob0gQkB1Xx+NEZdl
         Xsyrgpm8L4fJlS2oF78ANoHfwnD1K7K+pCCK8Bgjk5KQsThPi7TgWP2Jn9pvPCklcEqU
         8Xl5CoJl91Wc0XutCcPYa49zJzZuJjXiViXdx/N6Efc97PIFgdfNeXdxRvS8d2FOvpAT
         VQ2bAH5biAttuyY2ierT+XueGhqk/q3W+zCHy8WkYHbHxz6paMbH9f9P4xeHVjDVydcf
         yCdo6lhzgM4q9JdbNg/Gh3t6JPpXna7ZybwBrbKiYXn+yLw922wi/YhL4yIcRi2bE44E
         4BwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t7NCYht/hKPrWnhRNMLRXCGKEG3wZX2G57GLtW79ZFU=;
        b=aNWauIeYZmeaT7UZZOy0taum+HpIkgysdSbDMqAbzR9ItZBzxq0/WgIFJthJgzw812
         UULWJiagcp2iiYfeYeWZHOP3WySi2AVHLdFTJhJhm3ZGN6HNiY76c7jbdRHuZZ6BfgIv
         fnM2j783B7+hl5bk7Pmuh8loRmZbJ6lHWPnlAHjatjFps13HitBbZBnDbBWtUeUXq0Cq
         A7SUW8XHo6ntc6PZ6Q3Tf0ibF7Rr2DTZyFu82ONfQshBBAvCwSut3258bkrk+L+1kKDW
         6OKbaookEDIPACmNFhxEvjMzdEItQvtDFmcP7t2D0epCSmv5ceVJDAeH5iZevj4Norvx
         tiYg==
X-Gm-Message-State: APjAAAUQQEzJ1sg3V7y+q4cU8uSKW9QlO19jYan56IxaHLunD9TRW9ey
        qQgX7chU/VwVm+LRvLXMMAY=
X-Google-Smtp-Source: APXvYqzddGjDuff7Vp2xi5WqasnW92nPbLD8Ep8t9zxxpak2Rn1XZgFmy0HJ6t7RhognCic7QvdmBA==
X-Received: by 2002:aa7:9358:: with SMTP id 24mr24257796pfn.241.1569895310861;
        Mon, 30 Sep 2019 19:01:50 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id j16sm828076pje.6.2019.09.30.19.01.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 19:01:50 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>
References: <20191001013736.25119-1-dsahern@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <89c92628-57ec-72ec-3d05-9c4511e8ee38@gmail.com>
Date:   Mon, 30 Sep 2019 19:01:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191001013736.25119-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/19 6:37 PM, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> Rajendra reported a kernel panic when a link was taken down:
> 
> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
> 
> <snip>
> 
> [ 6870.570501] Call Trace:
> [ 6870.573238] [<ffffffff8efc58c6>] ? ipv6_ifa_notify+0x26/0x40
> [ 6870.579665] [<ffffffff8efc98ec>] ? addrconf_dad_completed+0x4c/0x2c0
> [ 6870.586869] [<ffffffff8efe70c6>] ? ipv6_dev_mc_inc+0x196/0x260
> [ 6870.593491] [<ffffffff8efc9c6a>] ? addrconf_dad_work+0x10a/0x430
> [ 6870.600305] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
> [ 6870.606732] [<ffffffff8ea93a7a>] ? process_one_work+0x18a/0x430
> [ 6870.613449] [<ffffffff8ea93d6d>] ? worker_thread+0x4d/0x490
> [ 6870.619778] [<ffffffff8ea93d20>] ? process_one_work+0x430/0x430
> [ 6870.626495] [<ffffffff8ea99dd9>] ? kthread+0xd9/0xf0
> [ 6870.632145] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
> [ 6870.638573] [<ffffffff8ea99d00>] ? kthread_park+0x60/0x60
> [ 6870.644707] [<ffffffff8f01ae77>] ? ret_from_fork+0x57/0x70
> [ 6870.650936] Code: 31 c0 31 d2 41 b9 20 00 08 02 b9 09 00 00 0
> 
> addrconf_dad_work is kicked to be scheduled when a device is brought
> up. There is a race between addrcond_dad_work getting scheduled and
> taking the rtnl lock and a process taking the link down (under rtnl).
> The latter removes the host route from the inet6_addr as part of
> addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
> to use the host route in ipv6_ifa_notify. If the down event removes
> the host route due to the race to the rtnl, then the BUG listed above
> occurs.
> 
> This scenario does not occur when the ipv6 address is not kept
> (net.ipv6.conf.all.keep_addr_on_down = 0) as addrconf_ifdown sets the
> state of the ifp to DEAD. Handle when the addresses are kept by checking
> IF_READY which is reset by addrconf_ifdown.
> 
> Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
> Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  net/ipv6/addrconf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 6a576ff92c39..e2759ef73b03 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -4032,6 +4032,12 @@ static void addrconf_dad_work(struct work_struct *w)
>  
>  	rtnl_lock();
>  
> +	/* check if device was taken down before this delayed work
> +	 * function could be canceled
> +	 */
> +	if (!(idev->if_flags & IF_READY))
> +		goto out;
> +
>  	spin_lock_bh(&ifp->lock);
>  	if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
>  		action = DAD_BEGIN;
> 


Do we need to keep the test on IF_READY done later in this function ?

If IF_READY can disappear only under RTNL, we might clean this.

(unless addrconf_dad_work() releases rtnl and reacquires it)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c399fbb686c839c525e700f2579b1a9..64e87e26187e983ad5da9f7496993202d63daa06 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4077,7 +4077,7 @@ static void addrconf_dad_work(struct work_struct *w)
                goto out;
 
        write_lock_bh(&idev->lock);
-       if (idev->dead || !(idev->if_flags & IF_READY)) {
+       if (idev->dead) {
                write_unlock_bh(&idev->lock);
                goto out;
        }


