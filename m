Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98307361F2A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 13:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242890AbhDPLwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 07:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241860AbhDPLws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 07:52:48 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B38CC061756
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 04:52:23 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id c195so29765158ybf.9
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 04:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2vz42B7vuTbsvVQdHSateTk0s/D/Mbwa+UMuHciq4Es=;
        b=BsHsa+vGvjZZtG+gOhSljUl+/LiRDBeouXZ0q7SKs8m3rco08ivmoY0F8jozZhv2Ap
         zrWVpIq97JgJHKm24haVD9WDDmkTchKabmdFBHwNE3mfOCv0S6vZ0qHWulhy1PKnGmRr
         A2zSRrlMKBlG9h8vz8PcSBUqn6fy+TPtBOL0pkBU6UkkO2FhnUA1iotxmPmU6085qiS6
         stK0w3hAAgBC4o/hVBXtXm32FYTJ86Kz5sMzRmJfC7q9L1TDhegvEP0+xshX4hK/RwH0
         /NLxy6UUGobWOILPiswXThUszVwNMRU1x/m+RpoeCMJNrIsXDCt+oKqVT9IWNNAyVmDh
         SRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vz42B7vuTbsvVQdHSateTk0s/D/Mbwa+UMuHciq4Es=;
        b=SQvx39c3HtJ72mkP7plqgmkctDq+ZuUhYhCnAMpswF36eTVB/MhLJu7czC6loCjez0
         vzMpSDLEFMrUZ2c2RnX2IpeinByQjMdODeNVOuInIzNPD3Ij4NM1a3qXbf2SBt0fO96p
         rhcxS1X6YhFM8ew/mvJ05LXUTR3ZilK6i5ux8lClFdHpQaT0xdg3LM96d3UWz3uchFlJ
         Aya5rupvx5Z9htNIXjxd1+EG2C2fHpxNLsjAt5NiY95j8vyWbKahL6Rzc4yl/3MiZ3fO
         OcVgnCeGWu8QqE4Wj9jwAZkrkPawMwtbMjn42mzDWb0K5m6KA68T49pUlqFBkTPUMVbz
         8HaQ==
X-Gm-Message-State: AOAM532o4nP+WGIgXlhfUL8aKGQxr709HYxHAmiwUxbfA+S/Jf4tXNjC
        CQRQPPNDI9HBVE4P29ZpXRusTVdg4Rrp+/CZ4jP3jFrPTqTH6Ifn
X-Google-Smtp-Source: ABdhPJwMc3IYpbggr5soL8jipuekAOlTDaRJhEju30Xi8ZfvrtM9uHyQQhUJ1ytNaIDoQUGNmEDUWpuxS7dp8U0xqnE=
X-Received: by 2002:a25:4244:: with SMTP id p65mr11362573yba.452.1618573941910;
 Fri, 16 Apr 2021 04:52:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210416105142.38149-1-zhaoya.gaius@bytedance.com>
In-Reply-To: <20210416105142.38149-1-zhaoya.gaius@bytedance.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 16 Apr 2021 13:52:10 +0200
Message-ID: <CANn89iJ5-4u98sGXt6oH5ZbWGFcYCy3T-B+qktvm3-cMkFQXKA@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix silent loss when syncookie is trigered
To:     zhaoya.gaius@bytedance.com
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:52 PM zhaoya <zhaoya.gaius@bytedance.com> wrote:
>
> When syncookie is triggered, since $MSSID is spliced into cookie and
> the legal index of msstab  is 0,1,2,3, this gives client 3 bytes
> of freedom, resulting in at most 3 bytes of silent loss.
>
> C ------------seq=12345-------------> S
> C <------seq=cookie/ack=12346-------- S S generated the cookie
>                                         [RFC4987 Appendix A]
> C ---seq=123456/ack=cookie+1-->X      S The first byte was loss.
> C -----seq=123457/ack=cookie+1------> S The second byte was received and
>                                         cookie-check was still okay and
>                                         handshake was finished.
> C <--------seq=.../ack=12348--------- S acknowledge the second byte.


I think this has been discussed in the past :
https://kognitio.com/blog/syn-cookies-ate-my-dog-breaking-tcp-on-linux/

If I remember well, this can not be fixed "easily"

I suspect you are trading one minor issue with another (which is
considered more practical these days)
Have you tried what happens if the server receives an out-of-order
packet after the SYN & SYN-ACK ?
The answer is : RST packet is sent, killing the session.

That is the reason why sseq is not part of the hash key.

In practice, secure connexions are using a setup phase where more than
3 bytes are sent in the first packet.
We recommend using secure protocols over TCP. (prefer HTTPS over HTTP,
SSL over plaintext)

Your change would severely impair servers under DDOS ability to really
establish flows.

Now, if your patch is protected by a sysctl so that admins can choose
the preferred behavior, then why not...
