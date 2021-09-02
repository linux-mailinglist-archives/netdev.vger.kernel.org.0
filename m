Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5383FF153
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346223AbhIBQ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:27:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235934AbhIBQ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630599990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ac8kYAedvMbpCDMJNz7WcA7klkjbd/VRKdd8BwA7jsw=;
        b=OBgwZIOusoE+81vBeMAxw9Z+1gr/Yo2cBK4oCbTUT963f4enG+DdbgZ5lj0cQrTes6DOtq
        tsmDln5lo7dyRZte2ref1XTZfu2MX4hcXeoHIRNfnXYatmzN0SGulDb4IrSCl2ZYGnuMBe
        pPrx2hrFJ1kSiNqOXDAKI3Nxe1DFc0c=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-NkQvC8KWPD2TPeRbveiRHg-1; Thu, 02 Sep 2021 12:26:29 -0400
X-MC-Unique: NkQvC8KWPD2TPeRbveiRHg-1
Received: by mail-ed1-f69.google.com with SMTP id d25-20020a056402517900b003c7225c36c2so1237628ede.3
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 09:26:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ac8kYAedvMbpCDMJNz7WcA7klkjbd/VRKdd8BwA7jsw=;
        b=Zmhp+ccsb/+FGUEQZMqdP8dZxo9W3Uge+GLnKt9QDBhNNZRyWxcU9/+BKwVsWEHSET
         OC/p4W9HXc6V3zvv/lFUD8igedJiXF4rMKeBksjikShJ7mqpwHWwX1CHSyyFROzseSrH
         F4HpsRgbbn3oEQrdOT7SEg9CWD+4YIk4TpN62i2osa84nKV9NbKOmgRkTysMzPp0kbTO
         tlB64KI4qMRLEOBM4tGSJqKhv83iYlE6/n3cPxrrSimAU7ZGAdaSdFdXycHQ7JMG/MHv
         O/3ecxRMzwbNVx0GCbSOPNWByELszHK/uO98867dLQHklXm2nF/vlr2b9p6gtjcg92+A
         o1jg==
X-Gm-Message-State: AOAM531fJ338w7syMeISpDf/o6nDBrJfKOInOuwhnFbfSIvG1V+bHk1q
        mSANbtD4Y/4rCYfSif3WmQhPejS1wQku0H/A+v8Nb+9p6vo/z2OJxHdOsTof2wu9ZKR5cwrIc5K
        srj2vSg33bgTnXSEd
X-Received: by 2002:a17:906:d1d1:: with SMTP id bs17mr4560406ejb.198.1630599987644;
        Thu, 02 Sep 2021 09:26:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyluie7thMHBOxkhpwcIZgyOR2wpOHSgqI0JoSnmxC7CmPRGdZT/Hm2z8vESQeFG7u03d4PJQ==
X-Received: by 2002:a17:906:d1d1:: with SMTP id bs17mr4560288ejb.198.1630599986024;
        Thu, 02 Sep 2021 09:26:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id mb14sm1422229ejb.81.2021.09.02.09.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:26:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BC9BF1800EB; Thu,  2 Sep 2021 18:26:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Xiumei Mu <xmu@redhat.com>, Paolo Abeni <pabeni@redhat.com>,
        wireguard@lists.zx2c4.com
Subject: Re: [PATCH net] wireguard: remove peer cache in netns_pre_exit
In-Reply-To: <YS+GX/Y85bch4gMU@zx2c4.com>
References: <20210901122904.9094-1-liuhangbin@gmail.com>
 <YS+GX/Y85bch4gMU@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 02 Sep 2021 18:26:23 +0200
Message-ID: <877dfzt040.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> Hi Hangbin,
>
> Thanks for the patch and especially for the test. While I see that
> you've pointed to a real problem, I don't think that this particular way
> of fixing it is correct, because it will cause issues for userspace that
> expects to be able to read back the list of peers for, for example,
> keeping track of the latest endpoint addresses or rx/tx transfer
> quantities.
>
> I think the real solution here is to simply clear the endpoint src cache
> and consequently the dst_cache. This is slightly complicated by the fact
> that dst_cache releases dsts lazily, so I needed to add a little utility
> function for that, but that was pretty easy to do.
>
> Can you take a look at the below patch and let me know if it works for
> you and passes other testing you and Toke might be doing with it? (Also,
> please CC the wireguard mailing list in addition to netdev next time?)
> If the patch looks good to you and works well, I'll include it in the
> next series of wireguard patches I send back out to netdev. I'm back
> from travels next week and will begin working on the next series then.

Ran this through the same series of tests as the previous patch, and
indeed it also seems to resolve the issue, so feel free to add:

Tested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

-Toke

