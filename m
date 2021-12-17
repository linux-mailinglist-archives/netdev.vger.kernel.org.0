Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957AA479330
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbhLQRzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:55:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231484AbhLQRzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 12:55:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639763748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HytMPrUuu50Os66ijVCnUpKvjuAjloMtur9VWK7cTMA=;
        b=BlDWD6W9cMbyp66XYwpDP7CWVuEs9ZpuxG7fSkdpm6TBfsADPss5MIN/g+MiYiRtneDp0S
        KoiF2YlRAYSP1O7aXkH6euIAWgqvP4oesncv+ogDm30OTdl1jb8uiPoQYCr+KhFqg1DeMO
        V0uStaU3uv9kadigwxMwcTKP7A1+yVo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-282--hnXmoH3MqiguIMa4Z0emQ-1; Fri, 17 Dec 2021 12:55:47 -0500
X-MC-Unique: -hnXmoH3MqiguIMa4Z0emQ-1
Received: by mail-qv1-f70.google.com with SMTP id a7-20020a056214062700b00410c76282c3so3403445qvx.4
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 09:55:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HytMPrUuu50Os66ijVCnUpKvjuAjloMtur9VWK7cTMA=;
        b=qlfd8EtXaC7iS6mrJV92/16VCqFSptGJRv1Nh9sGmXd8KOqhvh0HpBaY1xll1852He
         hVrcNXWqCzU0uttTVVPVjlCX6kZs8BYUlkIred+7aJ16Ua8ArRelGtFTYyq5ZVYl2e6j
         GU+WCALvu6YNjdbJxw6GDdbv1KJiurzFUXeTvE0REYFBSdWWOmHNDPkzyInuCi+ftQZ8
         mO+H3i0B0vFvvhvfab45Ga9EZo1cONOTStYwh3e2HquTUqIzL2eB9UWg3KFnUbvmJg0J
         vtLSw1N5DMHoZzGJQE7TJkDxxdGEYR4YHv5C7N61VER8u/HsvhjKlA0opS51a79/sA5/
         cstg==
X-Gm-Message-State: AOAM531MZMmL51ykyMxCzN3tBFMDCcsIYgrZKxaylCsL/599TF6Qv5S6
        tGm3OK0AME9kJptaAXcpZ3m2Xs8uafhoLrjPplm0MbM9ng44cEhn+KOMDOs9lxU2IDhtVsto6/m
        4H9x+vFODc6npfKSu
X-Received: by 2002:a05:620a:450a:: with SMTP id t10mr305245qkp.637.1639763746775;
        Fri, 17 Dec 2021 09:55:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwrPtWdnFcBl5rI7/hZKLp3ChJMrHTfdT3/PHIDzs5fEGch9ch1siRlpsPOj7AHGMU8hVyTHw==
X-Received: by 2002:a05:620a:450a:: with SMTP id t10mr305226qkp.637.1639763746350;
        Fri, 17 Dec 2021 09:55:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 16sm7851665qty.2.2021.12.17.09.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 09:55:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E73CA1802E8; Fri, 17 Dec 2021 18:55:43 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using
 new dscp_t type
In-Reply-To: <20211215164826.GA3426@pc-1.home>
References: <cover.1638814614.git.gnault@redhat.com>
 <87k0g8yr9w.fsf@toke.dk> <20211215164826.GA3426@pc-1.home>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 17 Dec 2021 18:55:43 +0100
Message-ID: <87czlvazfk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> > Note that there's no equivalent of patch 3 for IPv6 (ip route), since
>> > the tos/dsfield option is silently ignored for IPv6 routes.
>> 
>> Shouldn't we just start rejecting them, like for v4?
>
> I had some thoughs about that, but didn't talk about them in the cover
> letter since I felt there was already enough edge cases to discuss, and
> this one wasn't directly related to this series (the problem is there
> regardless of this RFC).
>
> So, on the one hand, we have this old policy of ignoring unknown
> netlink attributes, so it looks consistent to also ignore unused
> structure fields.
>
> On the other hand, ignoring rtm_tos leads to a different behaviour than
> what was requested. So it certainly makes sense to at least warn the
> user. But a hard fail may break existing programs that don't clear
> rtm_tos by mistake.
>
> I'm not too sure which approach is better.

So I guess you could argue that those applications were broken in the
first place, and so an explicit reject would only expose this? Do you
know of any applications that actually *function* while doing what you
describe?

One thought could be to add the rejection but be prepared to back it out
if it does turn out (during the -rc phase) that it breaks something?

-Toke

