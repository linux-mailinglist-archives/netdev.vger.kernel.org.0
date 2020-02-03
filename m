Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D47B150F43
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgBCSUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:20:35 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40073 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgBCSUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:20:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id k25so8236812pgt.7
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 10:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xYaMX13Lpg26+cMEriN2lo885jko91UPKe0BLsD49fc=;
        b=cFa4jZ0Maqd3bkSaGhDMN0ARQpvXDWyeBHGP8mV9eOsyafOgZ3yCKppCq+YZdXH1EJ
         aeVM+B/Ry4PFNs/6QeuqYRVr6YibG/9JQRTZERD2Cben/kXiU/MmZ9/Mv4NMpz/khqfZ
         lcJZ4a1RKt3g3VKOg+7qdclMF+t0m+de22srySsuHg1ROeUXouPuHPiwvyhhPtsPMWsj
         yl3nORqDnRCDdSG2XVLz361+EI9p2Z2b4tHwCz3CUfiJ4veKENR/A0dbdpUM16K0FJXD
         EpWJnGDoecj1DzJJAybpOzZ8PdDT10hFZa+hle0EcnpLszc1sWWTQUX+ldEJhfpg6adw
         /y6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xYaMX13Lpg26+cMEriN2lo885jko91UPKe0BLsD49fc=;
        b=Qt7a2UyMLm1TNJ4d6iLcrAiKBiPpBvYrsBjnuZTb7IrUmAZ1Yhh1m5OlHbvbQhYq0h
         hgSdIYyQhoo4KvQ6oIm96FtsPTG5CELrKxbvscx7lqRwpOiqniIqV7+VrnPvh99Bg+IR
         HtYI0Ud+IDmwJS4XV1fP3SLLAUYSinoOims5bxMTSXKrdIy7LC/ci+R7pTYEOF2UrldV
         ZImlFrw+R+lkpgx5OeMSd4E3chnP9GcyWuQaiTUv/xzOzJIxdZmDZ6xx3QPMt5WaaoZk
         6+cy/hqaBAk+6YpAXW9/pkYY7ebxQt6iSjeQDRNIKMd6DdfXjFlgU1nXypmRYTrGU4wi
         XchA==
X-Gm-Message-State: APjAAAUQG8BowG6OESdYsyNfK8BsextzfYhKU7rEO39XXVjgjUh/S6ug
        vbEkDMl6gXwTFa7XTxSkFME=
X-Google-Smtp-Source: APXvYqyfqUDg4YPI6HQ3+mec00YINQIcfgA2Rfid5AdGIXg0iGNQRX99a6lqodz9O+B6BPJpZGPf+g==
X-Received: by 2002:a63:1d1a:: with SMTP id d26mr25096960pgd.98.1580754034382;
        Mon, 03 Feb 2020 10:20:34 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id j8sm153172pjb.4.2020.02.03.10.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 10:20:33 -0800 (PST)
Subject: Re: [PATCH net] wireguard: fix use-after-free in
 root_remove_peer_lists
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
References: <20200203171951.222257-1-edumazet@google.com>
 <CAHmME9r3bROD=jAH-598_DU_RUxQECiqC6sw=spdQvHQiiwf=g@mail.gmail.com>
 <efaa70a3-5c71-3cc0-ffe4-e8401d598992@gmail.com>
Message-ID: <ba618605-ec50-085d-c854-f65290473c1c@gmail.com>
Date:   Mon, 3 Feb 2020 10:20:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <efaa70a3-5c71-3cc0-ffe4-e8401d598992@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/3/20 10:17 AM, Eric Dumazet wrote:
> 
> 
> On 2/3/20 9:29 AM, Jason A. Donenfeld wrote:
>> Hi Eric,
>>
>> On Mon, Feb 3, 2020 at 6:19 PM Eric Dumazet <edumazet@google.com> wrote:
>>> diff --git a/drivers/net/wireguard/allowedips.c b/drivers/net/wireguard/allowedips.c
>>> index 121d9ea0f13584f801ab895753e936c0a12f0028..3725e9cd85f4f2797afd59f42af454acc107aa9a 100644
>>> --- a/drivers/net/wireguard/allowedips.c
>>> +++ b/drivers/net/wireguard/allowedips.c
>>> @@ -263,6 +263,7 @@ static int add(struct allowedips_node __rcu **trie, u8 bits, const u8 *key,
>>>         } else {
>>>                 node = kzalloc(sizeof(*node), GFP_KERNEL);
>>>                 if (unlikely(!node)) {
>>> +                       list_del(&newnode->peer_list);
>>>                         kfree(newnode);
>>>                         return -ENOMEM;
>>>                 }
>>> --
>>> 2.25.0.341.g760bfbb309-goog
>>
>> Thanks, nice catch. I remember switching that code over to using the
>> peer_list somewhat recently and embarrassed I missed this. Glad to see
>> WireGuard is hooked up to syzkaller.
>>
> 
> I will let you work on a lockdep issue that syzbot found :)
> 

BTW wireguard@lists.zx2c4.com  seems to be a moderated list...

You might document this.

diff --git a/MAINTAINERS b/MAINTAINERS
index 0ae68fb8d38f167ae4a4b8ab49e27946393641e5..890d1f3e698e4c2475eadcd4a462768391328dd7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18040,7 +18040,7 @@ M:      Jason A. Donenfeld <Jason@zx2c4.com>
 S:     Maintained
 F:     drivers/net/wireguard/
 F:     tools/testing/selftests/wireguard/
-L:     wireguard@lists.zx2c4.com
+L:     wireguard@lists.zx2c4.com (moderated for non-subscribers)
 L:     netdev@vger.kernel.org
 
 WISTRON LAPTOP BUTTON DRIVER

