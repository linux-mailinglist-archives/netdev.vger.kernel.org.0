Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 137A01651B3
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 22:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgBSVdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 16:33:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43344 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbgBSVdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 16:33:31 -0500
Received: by mail-wr1-f65.google.com with SMTP id r11so2245465wrq.10
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 13:33:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yDc3+2LTXdeT4DFS6yiHXemjisG4SKrPsn7wcWKNyc0=;
        b=cYcZaCltkuSpbD/WoHJZ+CIv9gG+julOvJ1jka7rOBCY5GMl9cks8jtPmd4v6WArov
         1mHzdIUClTgGLHl2fqzIiUqoBc8skRZLZ8VCXOzUhSxYUtPRmmsLAY/U0BJ56qUcmUmH
         RCcTREkweJYOkTucwK/nzuiNGNow0+L6tS9qQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yDc3+2LTXdeT4DFS6yiHXemjisG4SKrPsn7wcWKNyc0=;
        b=ityZZDqbgZNgb42rs7JSx1zcEeN+IgRoul8A1rh6KST149WvF1X6rc5DfikanTHQ8J
         mzin8WwmS0juKhLEYLg60kglmVY1CAKbys5228BMulk9aIgI3k12EMXjLsfM/DFWT7/e
         dKVGWE9rdtCTsCo/Z7GHu/DGp3DeQRnd5hTrV2Q+xNVQHHbAZymfbWzwexNWyyw2FMUk
         jA4G0upLzWdEYtWIU4rgtA+g9FF6DrY0qkLwk2KNPEokjaiQAaNCDWypqZTUe58VoaCb
         trij+B3ZWfMHt8zFtQrwn8tNXSh3R8AI3bjoskLzNySXrp1lwlX0YpqzwllXIzau4e7P
         sd3Q==
X-Gm-Message-State: APjAAAWfdzveilcQvd+P5SiGCOHOud+5XkDmAcAm+ipWK0VzbNLkfsMi
        pQxZ6zzJPQfHlJhMkxND0JbLoQ==
X-Google-Smtp-Source: APXvYqxO0pamPxMf/8ILBFlAvOSGJ6ULjaU2B+PG28ryNIhHvKKg9F63tlUJbqWykPnAHbIThnz+8g==
X-Received: by 2002:adf:90e1:: with SMTP id i88mr39007634wri.95.1582148009688;
        Wed, 19 Feb 2020 13:33:29 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id h13sm1626791wrw.54.2020.02.19.13.33.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 13:33:29 -0800 (PST)
Subject: Re: [PATCH] cfg80211: Pass lockdep expression to RCU lists
To:     Johannes Berg <johannes@sipsolutions.net>,
        Amol Grover <frextrite@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20200219091102.10709-1-frextrite@gmail.com>
 <ff8a005c68e512cb3f338b7381853e6b3a3ab293.camel@sipsolutions.net>
 <407d6295-6990-4ef6-7d36-e08a942607c8@broadcom.com>
 <855dec1f598d8b43400089cd0c5a7ac9b3533fc7.camel@sipsolutions.net>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <795b0dd6-23e7-8780-7cde-cf309f08109f@broadcom.com>
Date:   Wed, 19 Feb 2020 22:33:29 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <855dec1f598d8b43400089cd0c5a7ac9b3533fc7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/2020 10:29 PM, Johannes Berg wrote:
> On Wed, 2020-02-19 at 22:27 +0100, Arend Van Spriel wrote:
>> On 2/19/2020 10:13 AM, Johannes Berg wrote:
>>> On Wed, 2020-02-19 at 14:41 +0530, Amol Grover wrote:
>>>>    
>>>> -	WARN_ON_ONCE(!rcu_read_lock_held() && !lockdep_rtnl_is_held());
>>>> -
>>>> -	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list) {
>>>> +	list_for_each_entry_rcu(pos, &rdev->sched_scan_req_list, list,
>>>> +				lockdep_rtnl_is_held()) {
>>>
>>> Huh, I didn't even know you _could_ do that :)
>>
>> Me neither ;-). Above you are removing the WARN_ON_ONCE() entirely.
>> Would it not be good to keep the WARN_ON_ONCE() with only the
>> !rcu_read_lock_held() check.
> 
> Not needed, the macro expansion will already contain
> rcu_read_lock_any_held() just like in all the other cases where you pass
> a lockdep condition to RCU helpers.

Ah, yes. I see it in __list_check_rcu().

Thanks,
Arend
