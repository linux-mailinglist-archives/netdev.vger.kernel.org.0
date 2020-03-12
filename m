Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEC9183959
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgCLTTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:19:12 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38795 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgCLTTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:19:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id n13so4031827lfh.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 12:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=WZJ/UKGJUnzZUZHFhn84tR/g32XaGlJEI3MHt5Z8Nn8=;
        b=mBpPOCvSe6zKETPnxnt3S42VROkdiMzgVKmxn6ukTFrJKhlFmp7ef4WkruH5Azq4dU
         GCCHNhgS7iB7bVSOMoWSdPr/PT9Mz94w+Tlw8yk8vC7vGGpyMUaWlg9LrAeMbLRT+Vmu
         ETrxyhPs0aI4L9ws9XWHdRhH+PZw0BRC4MALE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=WZJ/UKGJUnzZUZHFhn84tR/g32XaGlJEI3MHt5Z8Nn8=;
        b=XDzJWhHdpq86QnAYv6JPd2unPkm8LPoGd0AcnUPPNLwosr1gFOCCN9rbDdui/TwltI
         IcdgntiYpjpNFBNkG5ANEh7qkhvY6I+TOaSk3J8QchlEHQshK5A1Bgf2kdM/DhQ0jMZN
         7WX8k8xoq3SnsP5v5YqyMdzmLZVf27h8tVZMQqKojmIXzYCw+1iPyaO3DzmNos9xjhT4
         x1AUs7tU1DiQfkmJuXgMBJLt484IB7ZOvw80v6WuCrjXKT4owWzXCYbZVmh5oUnGIDab
         HH/7Yz6R3XHmqPW7U8rzOX9hgdtnQz5OS7g2gFb553lDJX/08WPu0XTGsLPaufHsCSwC
         MQ1Q==
X-Gm-Message-State: ANhLgQ1aShb/MhkIb1bpAHsN6Vxl3ej+lnjDJSnUjlcB50SYJHzAb7Qn
        BrHxNQNrKoP9bdy7yhahpwJqfVvnABp9yA==
X-Google-Smtp-Source: ADFU+vslvkZJQicskGyaq5JSHRIWZL6R1eXeD4uDnmxkx9t5iogJCoowPxvArsbTJxcGSid8S/YqAQ==
X-Received: by 2002:a19:4354:: with SMTP id m20mr2147831lfj.166.1584040748325;
        Thu, 12 Mar 2020 12:19:08 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id c22sm8155707lfm.25.2020.03.12.12.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 12:19:07 -0700 (PDT)
References: <20200312171105.533690-1-jakub@cloudflare.com> <CAEf4BzbsDMbmury9Z-+j=egsfJf4uKxsu0Fsdr4YpP1FgvBiiQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix spurious failures in accept due to EAGAIN
In-reply-to: <CAEf4BzbsDMbmury9Z-+j=egsfJf4uKxsu0Fsdr4YpP1FgvBiiQ@mail.gmail.com>
Date:   Thu, 12 Mar 2020 20:19:06 +0100
Message-ID: <87pndhxtxx.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 06:57 PM CET, Andrii Nakryiko wrote:
> On Thu, Mar 12, 2020 at 10:11 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Andrii Nakryiko reports that sockmap_listen test suite is frequently
>> failing due to accept() calls erroring out with EAGAIN:
>>
>>   ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
>>   connect_accept_thread:FAIL:733
>>
>> This is because we are needlessly putting the listening TCP sockets in
>> non-blocking mode.
>>
>> Fix it by using the default blocking mode in all tests in this suite.
>>
>> Fixes: 44d28be2b8d4 ("selftests/bpf: Tests for sockmap/sockhash holding listening sockets")
>> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>
> Thanks for looking into this. Can you please verify that test
> successfully fails (not hangs) when, say, network is down (do `ip link
> set lo down` before running test?). The reason I'm asking is that I
> just fixed a problem in tcp_rtt selftest, in which accept() would
> block forever, even if listening socket was closed.

Right, good point. We don't want tests hanging. Let me rework it.

[...]
