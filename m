Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD413AE52
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729033AbgANQEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:04:37 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42008 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728929AbgANQEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:04:37 -0500
Received: by mail-lj1-f194.google.com with SMTP id y4so14957599ljj.9
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=+H+H6Ga+4JFtfT6TfTdJtyZwGfO1XdaI77oQLwOJulY=;
        b=deg2iFB69XUcAU6WSbn2FDLcD4JbNZC8FeTdY1N7SHc8F/It16Ab+J8641ymR9dFw8
         EIO+oDjPtirFwV+5vC7Qb2ywRg44+k0Rb08OBS6hQwYo0w/97u9nUeU2lSrH1qD69rU3
         wP5vAZ7XLShcQpOz5D51mSzfo474ecm9BTSKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=+H+H6Ga+4JFtfT6TfTdJtyZwGfO1XdaI77oQLwOJulY=;
        b=J1HBg3eKbxrceWb7E4cqWlLhcP98qkAkXsxGQAjr3fA74/WqqHRic4rpOtWRNEEk1I
         VyvNkfira1m2/sltMBWG0QPyUobwIz2T0TLBGPeU/N6PB2snPFZbgsF4MMsZjhyHcXvv
         epN1MEy1bOlAvbU1Qe/zpOjBv82TA/5rkHVBAVJCe1fzC+RZ5p2oOWIrNiJk/iEAP2FU
         5juRWvkNuQRh55phwgXs24zvYNvxw2iRXZHMKCyhBRHhP7fuKphabiBuYz48dzqpBu16
         3msWgPI/sn7GuuGm5YoF90Y8oJ9R3NZLKEEoxPdJ8o/vdbE1MmjcKHY38jpO5+e0uCXY
         E6fQ==
X-Gm-Message-State: APjAAAXR2i+MlI94y/OmYv+/lu4eJduX5tRYpHiQ+Jgt9eHxnOb3UCDR
        X6SuiE4BNxCeHolSRZ/aG/bF7w==
X-Google-Smtp-Source: APXvYqwD4F55xjnZNU6JSUcx2EG/xlvr4BzRiJ6a4V/9cTyEHEcnLJSGmOGvKH7l4QK52zzwWGd4Nw==
X-Received: by 2002:a2e:9510:: with SMTP id f16mr14642612ljh.249.1579017875217;
        Tue, 14 Jan 2020 08:04:35 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id t27sm7827251ljd.26.2020.01.14.08.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 08:04:34 -0800 (PST)
References: <20200110105027.257877-1-jakub@cloudflare.com> <20200110105027.257877-4-jakub@cloudflare.com> <20200113201456.t5apbcjdqdr6by5t@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 03/11] net, sk_msg: Clear sk_user_data pointer on clone if tagged
In-reply-to: <20200113201456.t5apbcjdqdr6by5t@kafai-mbp.dhcp.thefacebook.com>
Date:   Tue, 14 Jan 2020 17:04:33 +0100
Message-ID: <87a76qrpm6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 09:15 PM CET, Martin Lau wrote:
> On Fri, Jan 10, 2020 at 11:50:19AM +0100, Jakub Sitnicki wrote:
>> sk_user_data can hold a pointer to an object that is not intended to be
>> shared between the parent socket and the child that gets a pointer copy on
>> clone. This is the case when sk_user_data points at reference-counted
>> object, like struct sk_psock.
>> 
>> One way to resolve it is to tag the pointer with a no-copy flag by
>> repurposing its lowest bit. Based on the bit-flag value we clear the child
>> sk_user_data pointer after cloning the parent socket.
> LGTM.  One nit, WARN_ON_ONCE should be enough for all the cases if they
> would ever happen.  Having continuous splat on the same thing is not
> necessary useful while it could be quite distributing for people
> capture/log them.

Will switch to WARN_ON_ONCE in v3. Thanks for the review!

>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

