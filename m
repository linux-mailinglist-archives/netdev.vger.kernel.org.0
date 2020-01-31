Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E06314F115
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgAaRJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:09:06 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:40347 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgAaRJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 12:09:06 -0500
Received: by mail-yw1-f65.google.com with SMTP id i126so5385756ywe.7
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 09:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TWSU5DCjy0FzPulQ5vCJe9Q7q9veeI/AGIoH1Pgxbn0=;
        b=iuHcr9bFTbYJ1OzjvgnqOIqK6hAjjFf9JnKaser/TUpmYTmmjOs4RiEgVX6o55lpYu
         6ziBiSZE9Lwe6Ibm4XdixDbzLbXArXv4gdvYAzmqz4EWry289a3PVrdS8ZD22Y1FITQd
         C1taauCF8Yy59yFD0+X5zIKWlx2gkPH6dPbNHTl292pD++MsB+M4XQGZNvdtUL5ZYTAK
         8NtoiHSPa/AAPau5Rf0cJL8AaiCsGWT7fPXnLxXl87IfHd8Xknz2OdU5kjKittnvONV2
         bnrT3OO0yr5naiRBVXxP1H4/SJb6CKd2GlHtc9cN7lV3qp7Qnhg92smQHD+Se3aL/bNx
         SxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TWSU5DCjy0FzPulQ5vCJe9Q7q9veeI/AGIoH1Pgxbn0=;
        b=MKe/zGmKjQm84LVfm1bhG2byjofnl3np+QqIRVbRxDF3GRU075df87+D5xMQ+LXShB
         4mHRhRxdYGw72QTmBLa6tsnyXKGzme9vwLfhvwjfIEeR8kXLRrXHLnSyiNzQrQicQxqY
         SGmChY4hGHvAt4gGued2V28IlAmy5LbBnhzP6IIF1XIpXWzusVCh1Iz3nXyiwFiv8n+/
         PjyHVcGfU6lEwEAgXw5ClE7kC27xngh12j4kmLGg6203fGQy56yw9iw/e0RuYK7tJc3B
         2+t7uJkWwk1njFDwwFd0s8y9n0Wf2IIvSh+WlQ4yS7vC0iftm9qJdPtJNc7xyTbqp2Og
         yygQ==
X-Gm-Message-State: APjAAAVBTYANoCGltBXJL+mc/wgLVzaAc2eEgUPIf7FcBPUzYQ67Zl2T
        qbhTUR2oi0vmAUW/d61P+4GJChYnMVqPZ2Q8LoVKmA==
X-Google-Smtp-Source: APXvYqzbvttA/MTUE16UgjkuFNSqYUYXrB/W7pmeUElKGGNw3odxPmA+9odWuJJgHy7OOkYO9yT6+lv+4eaI2NIwh+0=
X-Received: by 2002:a25:cfd8:: with SMTP id f207mr665984ybg.408.1580490544982;
 Fri, 31 Jan 2020 09:09:04 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iJjZdoTKnnHNAByp7euDWo0aW9bL8ngw78vx4z7pwBJiw@mail.gmail.com>
 <20200131170508.21323-1-sjpark@amazon.com>
In-Reply-To: <20200131170508.21323-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Jan 2020 09:08:53 -0800
Message-ID: <CANn89iLr2iXjcRjmVpsGAtPFvya948pXHUBzK3=j078P3bQuZg@mail.gmail.com>
Subject: Re: Re: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous
 ACK is received
To:     sjpark@amazon.com
Cc:     David Miller <davem@davemloft.net>, Shuah Khan <shuah@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, sj38.park@gmail.com,
        aams@amazon.com, SeongJae Park <sjpark@amazon.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 9:05 AM <sjpark@amazon.com> wrote:
> Oh, then I will use 'tcsk->icsk_retransmits' instead of 'tp->total_retrans', in
> next spin.  May I also ask you to Cc me for your 'tp->total_retrans' fix patch?
>

Sure, but I usually send my patches to netdev@

Please subscribe to the list if you want to get a copy of all TCP
patches in the future.
