Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CC73AFBFF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 06:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhFVEg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 00:36:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229574AbhFVEg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 00:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624336482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aE3wlTlpL8cW4Wk82CWtgLFgWv1ffw9LupUcnp+Fg9g=;
        b=SwVC0ZipnAayrozvSQi5KGmmIaaGn1fQZXxZvPTgtnnkBPEz/Kwq4RvyGNhcCLDro+jpK7
        Sg2ySFjJZLNCohG+dG8yqG7+d586eijRG//4kZ3w4a7jsx1C4FzovROUmgjfd4ueziWTlb
        jk40ZSdRnpasMCtQcLdOuwIXldNrbLc=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-Ee1f_6amPmy1Qbkv_y2s3A-1; Tue, 22 Jun 2021 00:34:39 -0400
X-MC-Unique: Ee1f_6amPmy1Qbkv_y2s3A-1
Received: by mail-pg1-f198.google.com with SMTP id 4-20020a6315440000b029022154a87a57so13021221pgv.13
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 21:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=aE3wlTlpL8cW4Wk82CWtgLFgWv1ffw9LupUcnp+Fg9g=;
        b=CETSnDuyVE7ikoacoQxzDlsaTUnruPIXRs0KMQ6oC9kCZQjhvSzyZV4DTffJQEtq0j
         Kh6WduDX5sGII5cGsfEGEsYNc9UpleF0FiEXidJSW75oRLUGZzTU161vdR4a6FjKVBxx
         dzsH6pMSnLZSYv5Vucn/RIVfsckG8fIanOkCjNPBDBsnIxMFosWTDm0wJab97qML9AlX
         KQDGA54dp3eu2YrjQSrpYuR9bwlOB+7GN/zlFCUioxDjnKlUsjXjYwmV5alRrtxOKaoQ
         34PKLzrfaYS2dy2yLyBpuLoOh7kFjd6fTojPh9NLSb4Hhzw47ahKktXln+Rk+rSD/Qbd
         2WAQ==
X-Gm-Message-State: AOAM533FJHIM8YIa45R6gZAXcboVOPSaafCxM1exlljiLrWJkMHD9fOi
        Eq6XrIPAUQGEyLQQlCL+c4HdCFRmy0uCkdnjgpk3AV0Jx3ASdcJu0yAOLCGo2ouQ4ZoLDMabaZt
        jYAtEc/1C3ltmYy0q
X-Received: by 2002:a17:902:ed55:b029:123:d5ab:b38b with SMTP id y21-20020a170902ed55b0290123d5abb38bmr11072413plb.71.1624336478837;
        Mon, 21 Jun 2021 21:34:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfmlV9p6YqV8umMRJaScWs9mPEZNI/Fqo52NQRp4CC4x6Zg55eoW7iGyVG0Nablb+/bbtczw==
X-Received: by 2002:a17:902:ed55:b029:123:d5ab:b38b with SMTP id y21-20020a170902ed55b0290123d5abb38bmr11072398plb.71.1624336478669;
        Mon, 21 Jun 2021 21:34:38 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nv1sm733205pjb.43.2021.06.21.21.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 21:34:38 -0700 (PDT)
Subject: Re: [PATCH] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>,
        netdev <netdev@vger.kernel.org>
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <e832b356-ffc2-8bca-f5d9-75e8b98cfcf2@redhat.com>
 <2cbe878845eb2a1e3803b3340263ea14436fe053.camel@infradead.org>
 <2433592d2b26deec33336dd3e83acfd273b0cf30.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <649c2d72-68f9-d0a6-10ed-51c45d0dd6be@redhat.com>
Date:   Tue, 22 Jun 2021 12:34:35 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <2433592d2b26deec33336dd3e83acfd273b0cf30.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/21 下午10:50, David Woodhouse 写道:
> On Mon, 2021-06-21 at 11:52 +0100, David Woodhouse wrote:
>> Firstly, I don't think I can set IFF_VNET_HDR on the tun device after
>> opening it. So my model of "open the tun device, then *see* if we can
>> use vhost to accelerate it" doesn't work.
>>
>> I tried setting VHOST_NET_F_VIRTIO_NET_HDR in the vhost features
>> instead, but that gives me a weird failure mode where it drops around
>> half the incoming packets, and I haven't yet worked out why.
> FWIW that problem also goes away if I set TUNSNDBUF and avoid the XDP
> data path.


That looks a workaround.

Thanks


