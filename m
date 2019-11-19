Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55015101EED
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKSJAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:00:23 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:37730 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKSJAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:00:23 -0500
Received: by mail-lf1-f65.google.com with SMTP id b20so16376980lfp.4
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 01:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=JIGXvSCLxOYvrjx3G2WYk6RRN2zbjKDUDVQmj25XDqw=;
        b=mliiZ3G2iaYzzR+LN891/J6HZlFLawcOPxqVGEoN/rMLJk5bOxcvmqiLDsTi/Uah8N
         Nw4Qw5nxHvfDYgVtOUZYrNOOGIZk84d0/f6qmCkCWdRaeEltSJH07abdMv47NR1EXOlL
         a3BCX0rkMIoLjMEyoBjpvvFarI7rw/weS8KMZq5gfZvnqpcuUY+K5ZwkWJHfHeRFMDsw
         J1ayFH5wh1Gs16c0dphLwyCILlprz+R6qvkG/CNG9u4QNH46nB2qyK0h2PtP1fyy+3J8
         Z49wBTX/SYLBVg9/V7xV/71a79TfhDkvpyNR6GqJw80rVPWmbc/r4zxItoLRujSQLW25
         619g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=JIGXvSCLxOYvrjx3G2WYk6RRN2zbjKDUDVQmj25XDqw=;
        b=TkyHC2KTCJwnkVdzZtCUGGWa/MPYnFaz0/GCAHv+DvgPKtzm30DDAnVs5d98s8hyoG
         rXogL3WNlBQMfl8Xr8IcDCKK8DYYW6UoOGp6Mq1zlJmWROF2PXannbOUq87KO32wBvbP
         GLEhjr5VOhcOlM/Dn+NBtKHflyAfkGPhMV+R9ZM3DJ6I96HqqHjhGpJ93RSbH+jJLIdZ
         H1eUM3YY0NkOcJrjcDPbu/Ntep5yqFB1L5PxOQkfegkR0Xn9svCiAr93AbmI/DkQlTRA
         JmZ4GduHGfS1ofdRZx/v8wELtDMVz8MH4JtiyQLEBBB0TFMqPwyDn0FQML1MmY3Fbkp+
         qNaQ==
X-Gm-Message-State: APjAAAWP4OMIvy1AtkkBjtEnPQv36HuJmsCvQOymwWYBCWzjsTdo5hSs
        U8ZsEB4xvLvoffmtzPI+pGBEwA==
X-Google-Smtp-Source: APXvYqw6ZS8NZ2nJBItJ3prQc8kzaCSgs1bWFbm5fxhVu1cVutpkx3x0/pNzOf3eGp5KU/07N19sqA==
X-Received: by 2002:a19:82c4:: with SMTP id e187mr2873483lfd.106.1574154021182;
        Tue, 19 Nov 2019 01:00:21 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id 15sm9389103ljq.62.2019.11.19.01.00.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 01:00:20 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: Re: [PATCH v3] net-sysfs: Fix reference count leak
References: <20191118123246.27618-1-jouni.hogander@unikie.com>
        <20191118132705.GB261521@kroah.com> <87eey4s41t.fsf@unikie.com>
        <20191119075812.GB1858193@kroah.com>
Date:   Tue, 19 Nov 2019 11:00:19 +0200
In-Reply-To: <20191119075812.GB1858193@kroah.com> (Greg Kroah-Hartman's
        message of "Tue, 19 Nov 2019 08:58:12 +0100")
Message-ID: <87a78ss0kc.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Tue, Nov 19, 2019 at 09:45:02AM +0200, Jouni H=C3=B6gander wrote:
>> Do you think better choise would be to remove BUG_ON completely rather
>> than replacing it with WARN_ON?
>
> I don't know this code, and I'm not the maintainer of it, so I don't
> have a strong opinion.  Other than if this was code I was maintaining, I
> would not want it there :)
>
> Anyway, your original fix looks sane to me, and that's probably a good
> thing to just do now and then you can work on these other things.
>
> thanks,
>
> greg k-h

Thank you a lot for your help on this patch.

BR,

Jouni H=C3=B6gander
