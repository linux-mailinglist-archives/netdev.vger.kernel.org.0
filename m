Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3B216F67B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 05:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgBZEb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 23:31:26 -0500
Received: from mail-qt1-f177.google.com ([209.85.160.177]:43843 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgBZEbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 23:31:25 -0500
Received: by mail-qt1-f177.google.com with SMTP id g21so1330842qtq.10
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 20:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5CXIQRjZTedVqCmNOi+Dxt7pOP76b8VisHbYcWUsdww=;
        b=NaryFR6suxbpAeJCUJR5NXvKnz0hz6Hj0tJoLbqoaFcAK07L7DOBJ81WaNPGVXMANI
         pEWcay6d7OPusDHYgwKPNJb9IeHKHKfKBizeauKyc0EgbK+k8t8TNoN0gI6heJVg8NFk
         oF5zaXLx03Aa7r5hC/c2BcjYyzsgefRdnXjUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5CXIQRjZTedVqCmNOi+Dxt7pOP76b8VisHbYcWUsdww=;
        b=CMLjab84JYJqEZmLWBxDm2zTmkbZvkrsVCt+5Cebd4i9G3X9NYwbR2AjLzBaCs7SjJ
         3i9MxEIXtiB306Qk15WE0XIvKBvKoQvjNvB2EZOXYikV+76QR59A+vzSxZr+PIOU08e0
         5bkSBAViSz33UlXl1Hd8SA7bT0JScaMCRSRMRxU5TrsDcFEge2HIKgtb+zugqmIQXEOu
         +I/vCf3/cSpUy868SWEysdJU46t3+RiqyZJJ+yvY2zZQ1PTbppc0U95paph+dR2nGRu6
         TJhaUYIwmHDINbkFmdCD/bL0Ilutf47pYZr3YXqEleZqU/yt4AclIFh8ldJQFZFzdAS0
         s+ZQ==
X-Gm-Message-State: APjAAAUyrbEN8QiiSvrUxY+BthCbGa+4yUwQbNAZe9t/ZsJbDPwmSNuR
        OI8CLhFvArIK11rwIRMgjQ5AlBZYtW0q3Q97
X-Google-Smtp-Source: APXvYqz+XMOoqu8bDaGm8GEHvWOAQb+6hPfKg5GR45SG0GGvu9rVMokGSB5d3nTG9371c8BP4msy7A==
X-Received: by 2002:aed:3b3d:: with SMTP id p58mr412727qte.204.1582691484570;
        Tue, 25 Feb 2020 20:31:24 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:e4f3:14fb:fa99:757f? ([2601:282:803:7700:e4f3:14fb:fa99:757f])
        by smtp.gmail.com with ESMTPSA id u26sm485923qkk.18.2020.02.25.20.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 20:31:23 -0800 (PST)
Subject: Re: virtio_net: can change MTU after installing program
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7df5bb7f-ea69-7673-642b-f174e45a1e64@digitalocean.com>
 <07bb0ad3-c3e9-4a23-6e75-c3df6a557dcf@redhat.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <bcd3721e-5938-d12d-d0e6-b53d337ff7ff@digitalocean.com>
Date:   Tue, 25 Feb 2020 21:31:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <07bb0ad3-c3e9-4a23-6e75-c3df6a557dcf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/20 9:02 PM, Jason Wang wrote:
>>
>> The simple solution causes a user visible change with 'ip -d li sh' by
>> showing a changing max mtu, but the ndo has a poor user experience in
>> that it just fails EINVAL (their is no extack) which is confusing since,
>> for example, 8192 is a totally legit MTU. Changing the max does return a
>> nice extack message.
> 
> 
> Or for simplicity, just forbid changing MTU when program is installed?

My preference is to show the reduced max MTU when a program is
installed. Allows the mtu to be increased to the max XDP allows for the
device.
