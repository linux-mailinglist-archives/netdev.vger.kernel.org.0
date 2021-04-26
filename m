Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5156636B590
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 17:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbhDZPSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 11:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233736AbhDZPSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 11:18:40 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFF9C061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:17:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lt13so18326735pjb.1
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 08:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dqh4dH8aZ6HN+B6a/NbTwQiRYC2u5Akv4+7vt6N7BqI=;
        b=XY9Yv9AWPcZwWKle2oLxy6MXxZYJ/wI3gWfHvn1lwE0JJXaahPaKvpQZfVqimJVczU
         6cKT0NyHZMxVxRYb1j2gl3iw6Tk0aJJSghG2us6p4q5uzGj/Bi7mgOvUX+hqf3MhzQg+
         gTBcuWVt1SUt7oWg50ZtZ1OR0L2iUpJEBqTZ12/nkPhOna7owJ3beyuLuIs3y6kI1/0z
         +V/a4ZdA7XHpDRqjZ4u5iYt6ECEjJ3wudJb3xa4WXtVz2JMzaaRgGQ4XBw4aHI86j7pH
         D+LyTlb4q5HRHj7KWC+tPmNrO2NaYpKzJ1YP7lWKjUMaesuaq1PzEn1tPnB5qQMKro/f
         FqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dqh4dH8aZ6HN+B6a/NbTwQiRYC2u5Akv4+7vt6N7BqI=;
        b=koWDaDTI9W2FIvIWPogO2XnuKuMmSLlYz0qu/8EkVpl70a8XKzIsZf2MEVxc39Nsbh
         5Tmeo/T59sXwa7kjYhNmkHNKYtJ5Zw9QmpnMqfAx3MLJ+OaCMDeUfoib49zihoOZZSn2
         9JDfhOFJnnhwVe+ji5SJGjwip5xZLifz42PTF9iF4fXkHExJ3W+HA73iM/B+G/PiXKZV
         4QgSK8Ezj8eHt1OhklpiqY088e0AZ33qfmqLL2BgCqtdYyE+S0Wlza7rhAAe0l2rXEzo
         KjkCQmzmEzXtX8gRU9vXXIJ9rJ2OlYTN/WqXBOE+AwyLTRZRKgdSOvoKhVST1HZuadA1
         r0lA==
X-Gm-Message-State: AOAM53156OqyUR4ntbYyUCahYI1KAvhXidfFfh1Mu6Vd4MP4yhZ0+X+d
        9AwyZkkMZc73EmnN533i3LM=
X-Google-Smtp-Source: ABdhPJzjB2/a2k1EK1OBw6sXE24xe/04DWLan0d03jv+ZZbEaiLUlLmytXqmukKx0eOwj7yzsb+Olw==
X-Received: by 2002:a17:90a:cb0e:: with SMTP id z14mr3371246pjt.128.1619450278670;
        Mon, 26 Apr 2021 08:17:58 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id a190sm90776pfb.185.2021.04.26.08.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 08:17:58 -0700 (PDT)
Subject: Re: [PATCH net 2/2] net: bridge: fix lockdep multicast_lock false
 positive splat
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        roopa@nvidia.com, ast@kernel.org, andriin@fb.com,
        daniel@iogearbox.net, weiwan@google.com, cong.wang@bytedance.com,
        bjorn@kernel.org, bridge@lists.linux-foundation.org
References: <20210425155742.30057-1-ap420073@gmail.com>
 <20210425155742.30057-3-ap420073@gmail.com>
 <ed54816f-2591-d8a7-61d8-63b7f49852c1@nvidia.com>
 <20210426124806.4zqhtn4wewair4ua@gondor.apana.org.au>
 <1e8cda49-4bc3-6f0b-29f3-97848aab18f0@nvidia.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <68b18d15-d472-3305-4f91-5e61f8b60488@gmail.com>
Date:   Tue, 27 Apr 2021 00:17:52 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1e8cda49-4bc3-6f0b-29f3-97848aab18f0@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/21 10:15 PM, Nikolay Aleksandrov wrote:
 > On 26/04/2021 15:48, Herbert Xu wrote:

Hi Nikolay and Herbert,
Thank you for the reviews!

 >> On Sun, Apr 25, 2021 at 07:45:27PM +0300, Nikolay Aleksandrov wrote:
 >>>
 >>> Ugh.. that's just very ugly. :) The setup you've described above is 
by all means invalid, but
 >>> possible unfortunately. The bridge already checks if it's being 
added as a port to another
 >>> bridge, but not through multiple levels of indirection. These locks 
are completely unrelated
 >>> as they're in very different contexts (different devices).
 >>
 >> Surely we should forbid this? Otherwise what's to stop someone
 >> from creating a loop?
 >>
 >> Cheers,
 >>
 >
 > Indeed that would be best, it's very easy to loop them.
 >

We can make very various interface graphs with master/slave interface types.
So, if we need something to forbid it, I think it should be generic 
code, not only for the bridge module.
