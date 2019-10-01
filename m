Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6796CC2BDC
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 04:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729356AbfJACXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 22:23:51 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41220 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfJACXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 22:23:51 -0400
Received: by mail-pg1-f196.google.com with SMTP id s1so8539768pgv.8
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 19:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Anw5zJ41A1EoxG0c8NgDJMgV7VrVwV8uZBEQ12L92m0=;
        b=deFprPW2gr3v3n/e7SuhPrFtl44UyKWIIqzUK9wNcx1c0pwIqrpsB6QLjVzYvU/8as
         Nq5mPjsQ6XHjTWK8kp0yvAgJnnzLs6UIh/1lOzwNXgp1fDtSDsfZ+8yqhdGMivswiVcX
         4L5iy4GSEmrmUQWhnE1TdwDO+fvXapGiMCu3ZrWESTU9aGZZlnvoXQsqafokP5cF7rWx
         S1rxdjj7eAleRCNC3qM8IqeQiitP7vgaicf/K+wduLBqo7bI+aNzZ5mpzyhQxgxFIDSF
         tIYlQurP1wY1gJZpwduFF2T1Qh6xB3RAXLhfbeV98o8Bgd2MSq8EVSgqHofZDSlHHBKZ
         CDdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Anw5zJ41A1EoxG0c8NgDJMgV7VrVwV8uZBEQ12L92m0=;
        b=qZGUjGu36KukjOE32cyfJ2scxMtJIHDHVJJBV6x1n7GkISzAb1jjKOXslUXJlWCiVW
         cLeKFEIf6bquNRnm13ZBzYADNv7HPuPSNlJuLEGiX2FsNwsNk7fxK8sdlRGYPGwfGtwa
         Gv73+9PWV67fxlNa7Ks5oNlgLIgDrOAhyn9G1l6gHi9hegvT3WOo9K4zTWhWOBEsHGoD
         h7c8tXjJzNdrFfL/db05Xfx/MIbr4mzWZJyyCKT5h1bDE1SM+5ZVol1q9qpbWkjCHTmD
         Y+wBoIDcu0IYNjvtHmioz6q0iOp1lQJKOG0bU3kB4TBueWT/H7tvZttbim0e+x8qbmZk
         JJqg==
X-Gm-Message-State: APjAAAXDXMSfo8yGiKnizJL9M6gcwVc9yYpAwVHOeLnT/3Hn6+uhDX3y
        4qwi2xer1QpzvHSQkhp81CwtLEN1qDs=
X-Google-Smtp-Source: APXvYqyDemh/9uDAiaDMruWDzkVD9wauIqr2Z40JG7hmYUlJwBlouKZnW/wWQIvkO3eBkE4/OFbclA==
X-Received: by 2002:a63:f915:: with SMTP id h21mr544859pgi.269.1569896626098;
        Mon, 30 Sep 2019 19:23:46 -0700 (PDT)
Received: from [172.27.227.182] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id x11sm1068910pja.3.2019.09.30.19.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Sep 2019 19:23:44 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
References: <20191001013736.25119-1-dsahern@kernel.org>
 <89c92628-57ec-72ec-3d05-9c4511e8ee38@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <57eab627-8cc5-4834-a865-1970a290821a@gmail.com>
Date:   Mon, 30 Sep 2019 20:23:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <89c92628-57ec-72ec-3d05-9c4511e8ee38@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/19 8:01 PM, Eric Dumazet wrote:
> 
> 
> On 9/30/19 6:37 PM, David Ahern wrote:
>> From: David Ahern <dsahern@gmail.com>
>>
>> Rajendra reported a kernel panic when a link was taken down:
>>
>> [ 6870.263084] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
>> [ 6870.271856] IP: [<ffffffff8efc5764>] __ipv6_ifa_notify+0x154/0x290
>>
>> <snip>
>>
>> [ 6870.570501] Call Trace:
>> [ 6870.573238] [<ffffffff8efc58c6>] ? ipv6_ifa_notify+0x26/0x40
>> [ 6870.579665] [<ffffffff8efc98ec>] ? addrconf_dad_completed+0x4c/0x2c0
>> [ 6870.586869] [<ffffffff8efe70c6>] ? ipv6_dev_mc_inc+0x196/0x260
>> [ 6870.593491] [<ffffffff8efc9c6a>] ? addrconf_dad_work+0x10a/0x430
>> [ 6870.600305] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
>> [ 6870.606732] [<ffffffff8ea93a7a>] ? process_one_work+0x18a/0x430
>> [ 6870.613449] [<ffffffff8ea93d6d>] ? worker_thread+0x4d/0x490
>> [ 6870.619778] [<ffffffff8ea93d20>] ? process_one_work+0x430/0x430
>> [ 6870.626495] [<ffffffff8ea99dd9>] ? kthread+0xd9/0xf0
>> [ 6870.632145] [<ffffffff8f01ade4>] ? __switch_to_asm+0x34/0x70
>> [ 6870.638573] [<ffffffff8ea99d00>] ? kthread_park+0x60/0x60
>> [ 6870.644707] [<ffffffff8f01ae77>] ? ret_from_fork+0x57/0x70
>> [ 6870.650936] Code: 31 c0 31 d2 41 b9 20 00 08 02 b9 09 00 00 0
>>
>> addrconf_dad_work is kicked to be scheduled when a device is brought
>> up. There is a race between addrcond_dad_work getting scheduled and
>> taking the rtnl lock and a process taking the link down (under rtnl).
>> The latter removes the host route from the inet6_addr as part of
>> addrconf_ifdown which is run for NETDEV_DOWN. The former attempts
>> to use the host route in ipv6_ifa_notify. If the down event removes
>> the host route due to the race to the rtnl, then the BUG listed above
>> occurs.
>>
>> This scenario does not occur when the ipv6 address is not kept
>> (net.ipv6.conf.all.keep_addr_on_down = 0) as addrconf_ifdown sets the
>> state of the ifp to DEAD. Handle when the addresses are kept by checking
>> IF_READY which is reset by addrconf_ifdown.
>>
>> Fixes: f1705ec197e7 ("net: ipv6: Make address flushing on ifdown optional")
>> Reported-by: Rajendra Dendukuri <rajendra.dendukuri@broadcom.com>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>>  net/ipv6/addrconf.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
>> index 6a576ff92c39..e2759ef73b03 100644
>> --- a/net/ipv6/addrconf.c
>> +++ b/net/ipv6/addrconf.c
>> @@ -4032,6 +4032,12 @@ static void addrconf_dad_work(struct work_struct *w)
>>  
>>  	rtnl_lock();
>>  
>> +	/* check if device was taken down before this delayed work
>> +	 * function could be canceled
>> +	 */
>> +	if (!(idev->if_flags & IF_READY))
>> +		goto out;
>> +
>>  	spin_lock_bh(&ifp->lock);
>>  	if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
>>  		action = DAD_BEGIN;
>>
> 
> 
> Do we need to keep the test on IF_READY done later in this function ?
> 
> If IF_READY can disappear only under RTNL, we might clean this.
> 
> (unless addrconf_dad_work() releases rtnl and reacquires it)

Unless I am missing something none of the functions called by dad_work
release the rtnl, but your comment did have me second guessing the locking.

The interesting cases for changing the idev flag are addrconf_notify
(NETDEV_UP and NETDEV_CHANGE) and addrconf_ifdown (reset the flag). The
former does not have the idev lock - only rtnl. The latter has both.
Checking the flag is inconsistent with respect to locks.

As for your suggestion, the 'dead' flag is set only under rtnl in
addrconf_ifdown and it means the device is getting removed (or IPv6 is
disabled). Based on that I think the existing:

	if (idev->dead || !(idev->if_flags & IF_READY))
		goto out;

can be moved to right after the rtnl_lock in addrconf_dad_work in place
of the above change, so the end result is:


diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c39..dd3be06d5a06 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4032,6 +4032,12 @@ static void addrconf_dad_work(struct work_struct *w)

        rtnl_lock();

+       /* check if device was taken down before this delayed work
+        * function could be canceled
+        */
+       if (idev->dead || !(idev->if_flags & IF_READY))
+               goto out;
+
        spin_lock_bh(&ifp->lock);
        if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
                action = DAD_BEGIN;
@@ -4077,11 +4083,6 @@ static void addrconf_dad_work(struct work_struct *w)
                goto out;

        write_lock_bh(&idev->lock);
-       if (idev->dead || !(idev->if_flags & IF_READY)) {
-               write_unlock_bh(&idev->lock);
-               goto out;
-       }
-
        spin_lock(&ifp->lock);
        if (ifp->state == INET6_IFADDR_STATE_DEAD) {
                spin_unlock(&ifp->lock);


agree?
