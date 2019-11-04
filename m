Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D42EE43C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfKDPuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:50:32 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:45417 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDPub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 10:50:31 -0500
Received: by mail-il1-f195.google.com with SMTP id o18so3060708ils.12
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 07:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5vMIIb9M9A7ASj9sjwC139C8xCLsA60IbicYMg7De9g=;
        b=myxbvVeYEjSycriKYTZhRwTL6n7ogHU0K7zFcO/jJD38u9eoZVnC6Xa19/Zav6TAV+
         RL33+1TjIyzLS+tSXfNQR/kP1yVxYWCrveKZUeGULCSnWVh4tapqKI8/pAET9nvJWPL0
         dsuFf2cn11PAVf8QhJ4+1IBtmqunNZEyAOPwLGTqIfKXPyrpIYYVCUqEOEPTemSb49LB
         mdiHAnSyAPsqNQaH8kzm1keGwUJgCC+8eZNV+iaYq9qixu+bqC/Uf1hZCU0haKXvylFD
         E5FYZE4aR1hEktTGbpSBy9JwcpZprG7WkycpDJBPLUPZaB6D9eYjcii8XYIVphEKSxAV
         UDqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5vMIIb9M9A7ASj9sjwC139C8xCLsA60IbicYMg7De9g=;
        b=taAGTWgukOwMSbk5RnqrWVOvtwvWyZrquJlX2VgL1ahUZo7YyZ0Ke3LHsUo70pe3wt
         4SpG0AU9dFovbhkoaTUygyNdcdbigPC4ZiaV63xI2hbayFDlPkMr1BVHeHG3LrIxzzpt
         Tkmp0D5NVCDRb8fGcVdMN00CXArSZNoV7hw93PyfC3SpVKrMlRqH68eK2gWZWowDN4Ux
         44X+Cysva+tbCzfm7UlgB7Eki6ko1WfT/mynRxAj+UJ3hd779OnYBPdvcH/Ojb5W+/qI
         jx5/fhgDPVVfNnzDMX31W48yLBtrNyYNfQ+i7zg3p38DvF8raKcmq335jOL+UltzbYSu
         R1bQ==
X-Gm-Message-State: APjAAAV4awMV8DQNlL7+f+zHDyWpJ1wCIpP86xJkVsGJglTgrXf/WVl7
        LxRaIEfSMpDgHOILSnybwAY6ryY5zmDBiTc8IBe+UytbmAg=
X-Google-Smtp-Source: APXvYqySuBm4OgBGq/IH+eIP9+k93fE0PnFlfsYcVHxJ/odGLS4Cxh6baZOqn1rHXzVI32MZrQ+Ve7FXIosIDZcNV20=
X-Received: by 2002:a92:ba1b:: with SMTP id o27mr29531429ili.269.1572882630505;
 Mon, 04 Nov 2019 07:50:30 -0800 (PST)
MIME-Version: 1.0
References: <20191101173219.18631-1-edumazet@google.com> <20191101.145923.2168876543627475825.davem@davemloft.net>
 <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com>
In-Reply-To: <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 4 Nov 2019 07:50:16 -0800
Message-ID: <CANn89iJUVcpbknBsKn5aJLhJP6DkhErZBcEh3P_uwGs4ZJbMYQ@mail.gmail.com>
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
To:     Thiemo Nagel <tnagel@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 4, 2019 at 7:24 AM Thiemo Nagel <tnagel@google.com> wrote:
>
> Thanks a lot, Eric!
>
> Grepping through the source, it seems to me there are two more
> occurrences of jiffies in inet_id:
>
> https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L120
> https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L419
>

Indeed.

The one in dccp_v4_connect() has been handled in my patch.
I missed it in dccp_v4_request_recv_sock()

Thanks.

> Kind regards,
> Thiemo
