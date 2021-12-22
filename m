Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A7D47D4E5
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 17:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhLVQKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 11:10:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43438 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234238AbhLVQKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 11:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640189435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSO/frr+yiJfn8XpssQknCjCYorZHXgFUrngudXM3qo=;
        b=LHR4Ho8g8cafRd91HNp89xSFQG1LFmFC5/1p4W/W6QPCE3MnimO3h1b4Iy2nQiju0+EWsw
        JehSghBWOwEzBvOFtwi6UyUj09OGnWMRmh5J1gIIbMc3YDZ90C96asbNpykw5WYTwWoSrH
        TM+pSoJ9RpuvGaDvlV8vXovbWdm6BoI=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-2EMtEeHRM2eIQJ826DdYRQ-1; Wed, 22 Dec 2021 11:10:34 -0500
X-MC-Unique: 2EMtEeHRM2eIQJ826DdYRQ-1
Received: by mail-qv1-f71.google.com with SMTP id 13-20020a0562140d0d00b00411590233e8so2389903qvh.15
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 08:10:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cSO/frr+yiJfn8XpssQknCjCYorZHXgFUrngudXM3qo=;
        b=wrm0ukcXIAg4vgLilAcIJU0+nvvdVagbIkaoQK4sJb2ZS+XDWjxpzcudUF6SU0MFvh
         RSypkPVbDNR8fAxPagDFZakjndQOp2rBIkAba10B5Prx4at1kbLVCK9P7ERXLzL6RaR+
         oGsPI0xO/Zi7o2YBen7a+9zddL5920JFmtmSzHmeGYNjuX3IUD8Sx0Q534C97uqgFJBU
         TXshYh8ldI7ArAvSkwXTwbKe9e8aCg9stdOJgZOWNR3pOf+Qf88Cd5KNyyYNM4mn/yhA
         uVWUUWlpm3Ad9ryFN7ejMMFcVg5cCMN9pchCUy0HMKqDWVxYv3LueVQjZOS5YKNJbUz0
         FsFQ==
X-Gm-Message-State: AOAM531zJm0LxpVqomrBxPwGlia+eEo3/FLXevqPqhhERp+hmpzXs2XB
        b89qtRAjVrMlkHrUU6bG5Pc9IJTdjrq4ssTFzcTUBETdYeMt4IE9EDuIEn8kMHi1pmLUHhoGC5w
        qz9kNgCvgpz8cQKP3
X-Received: by 2002:a05:6214:1c84:: with SMTP id ib4mr3092071qvb.76.1640189433442;
        Wed, 22 Dec 2021 08:10:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGEGSIDaw+VdXwpMQa4cQEWHZB+eG/WW3RLlt43u/9ipkg72epSBrb8LFoVn+8RbDIEUyKVA==
X-Received: by 2002:a05:6214:1c84:: with SMTP id ib4mr3092048qvb.76.1640189433149;
        Wed, 22 Dec 2021 08:10:33 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-225-60.dyn.eolo.it. [146.241.225.60])
        by smtp.gmail.com with ESMTPSA id u10sm2165725qkp.104.2021.12.22.08.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 08:10:32 -0800 (PST)
Message-ID: <20210d650ebf79c8989365d1e426f814dbd61716.camel@redhat.com>
Subject: Re: [PATCH net] veth: ensure skb entering GRO are not cloned.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Ignat Korchagin <ignat@cloudflare.com>
Date:   Wed, 22 Dec 2021 17:10:30 +0100
In-Reply-To: <CANn89iKDA4TMpQeQoxicd8rkph5+Am2iuoSDETvFn03CiQQV3g@mail.gmail.com>
References: <26109603287b4d21545bec125e43b218b545b746.1640111022.git.pabeni@redhat.com>
         <CANn89iKpiQzW1UnsQSYzULJ8d-QHsy7Wz=NtgvVXBqh-iuNptQ@mail.gmail.com>
         <dad55584ad20723f1579475a09ef7b3a3607e087.camel@redhat.com>
         <CANn89iKDA4TMpQeQoxicd8rkph5+Am2iuoSDETvFn03CiQQV3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-22 at 03:58 -0800, Eric Dumazet wrote:
> On Wed, Dec 22, 2021 at 3:06 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > I thought about something similar, but I overlooked possible OoO or
> > behaviour changes when a packet socket is attached to the paired device
> > (as it would disable GRO).
> 
> Have you tried a pskb_expand_head() instead of a full copy ?
> Perhaps that would be enough, and keep all packets going through GRO to
> make sure OOO is covered.

Indeed it looks like it's enough. I'll do some more testing and I'll
send a v2 using pskb_expand_head().

Many thanks!

Paolo

