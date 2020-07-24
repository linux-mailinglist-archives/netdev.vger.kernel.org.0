Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A565722BDEF
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGXGKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgGXGKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:10:23 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31905C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:10:23 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 72so3905982ple.0
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BfGDsAaaj+TsFiWwpvcnBC33apYvRm+mH5nKXxR8gks=;
        b=BmyJhTru2nAAoenTOXBhKfjjmcDvXg+wSWRdIKBccL8+LNxzCnNNM9wLJOHhaKUJ8s
         v2GSzlChWqQbKDyN9b9nv9dJjU32a6xUEWzaE+HCgnwT72Kr/aBSsA4wzGwGpuKOOvTw
         XtP/9FhKxSMvwmQTuYE6/DHmfEqki406ppnydRbLrj4LGbGhS8SiOQ9toz06efeJ/BYX
         GvByYchNYYf4cjgt0B1u9laxo/63hoGD3IxHcEAxC8SWC/ECnGqQhdyaK0xy1OZ/g3+P
         JdiwzXYG5pK1ZHlgYdM1/Qj8u3PQ5dtHIAuu6eufN8cjuTpmV9dTCabzKuWz6NtAuNzU
         SsKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BfGDsAaaj+TsFiWwpvcnBC33apYvRm+mH5nKXxR8gks=;
        b=XO1kq5Tk+CFwvn7Te5rgr6lthrb7bKG1wF93nJNJN4TrZAy1DRcY8ZEFtza/uFYmSX
         jM/HyrX8umPG89B0vcMWve+EgsyKJhV35R5ginMow6v3p7j20zgvvV8lLr8Yo1XeMi3A
         dn9s5qVTvF7CLSyWXV0dx8m3lOWwH0GFlad+iwT1oXEPxnsWmqllEWD21d/I545xPwUe
         zwssV/b43pbg0LyO0X/kfGrpgXWE/zTcLzutEgKXtD49PJlaQoz/Qyd4plrhlSyqt+6A
         4fB3jXGIsidBixgLT0p4IH9oaijIe2JeS0+13imycOswU1U2oL4WSD0qcHXXOQeoCp3C
         7qJg==
X-Gm-Message-State: AOAM5308DELUaW/X+scOeXUw6in2GIa03idUSzlJaxOu+pTr/D5f8mPj
        aAUo32Tsgh0ec7NTslYlqHc=
X-Google-Smtp-Source: ABdhPJyZgtLK4RQxloh9MLJN3ZgMyj0DYNyFUi75E0D0s5RiYaWa57EVGwJafkM+rkknDmONPDvA6Q==
X-Received: by 2002:a17:90a:ac06:: with SMTP id o6mr3891281pjq.219.1595571022780;
        Thu, 23 Jul 2020 23:10:22 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y20sm5087090pfo.170.2020.07.23.23.10.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 23:10:22 -0700 (PDT)
Subject: Re: [Patch net] qrtr: orphan skb before queuing in xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20200724045040.20070-1-xiyou.wangcong@gmail.com>
 <590b7621-95bf-1220-f786-783996fd4a4c@gmail.com>
 <CAM_iQpW+TmWjFu=gqDkAVPZ9q6PkJAfMeu87WJ98d-c2PxWoQA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ee7386b1-fcdb-bd2d-fa8d-db87248dd7fd@gmail.com>
Date:   Thu, 23 Jul 2020 23:10:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpW+TmWjFu=gqDkAVPZ9q6PkJAfMeu87WJ98d-c2PxWoQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/20 11:00 PM, Cong Wang wrote:
> On Thu, Jul 23, 2020 at 10:35 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 7/23/20 9:50 PM, Cong Wang wrote:
>>> Similar to tun_net_xmit(), we have to orphan the skb
>>> before queuing it, otherwise we may use the socket when
>>> purging the queue after it is freed by user-space.
>>
>> Which socket ?
> 
> sk->sk_wq points to &sock->wq. The socket is of course from
> qrtr_create().
> 
>>
>> By not calling skb_orphan(skb), this skb should own a reference on skb->sk preventing
>> skb->sk to disappear.
>>
> 
> I said socket, not sock. I believe the socket can be gone while the sock is
> still there.
> 
> 
>> It seems that instead of skb_orphan() here, we could avoid calling skb_set_owner_w() in the first place,
>> because this is confusing.
> 
> Not sure about this, at least tun calls skb_set_owner_w() too. More
> importantly, sock_alloc_send_skb() calls it too. :)
> 

tun is very different : skbs reaching it came come from all over the places, like TCP stack.
Their skb->sk is not pointing to the tun sock.


Here, the skbs are cooked from net/qrtr/qrtr.c locations only.
