Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8879E15D4FE
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 10:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgBNJuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 04:50:35 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41772 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgBNJuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 04:50:35 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so10159741wrw.8
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 01:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mD2YmEK4gCSV3hnc/dY0/Jzo5HOdOyl1iKFO3KoNy+U=;
        b=RjNuaZUdXhPBsWNoILkrFF7l09xgcK0K0Fqkd8FzVv2CsyJsN9HB9wCKho9mmXuR0v
         4WdtxhzvRO04TScUXvVE7WAmTg5ekpAoDcnYjunfb4DtgOIiYyP5NTbcvdWk2fRzCYrM
         CdDgCSBNSCs3GvXYO/UoOmLNm/gy+ovdR4udBX54dAGexQGt7ulWw3BkLZ/7hvLUaOzA
         Rv4ggce+fAn0nMhMT50JebQs0fMmBzooqsyCjoyNR6EO6O5FO4q1LsAoSlBb7GSrBr7u
         NUawy2iZMz6PKTB9/IMEhakRbENaM13T64kb0oMikzkymLwaKG8NxsIAgMqn9BWzEn3d
         +23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mD2YmEK4gCSV3hnc/dY0/Jzo5HOdOyl1iKFO3KoNy+U=;
        b=YTqDYP2b2EmZO3cU5wdNJ9ssI/QkfQ+OQ1NM8dEExEHSHgJvYIhAvEqIZbJBHC4fAT
         u8t2vZaarsAZPZsZLyZQhXdn1uzi8Hv2mzWRRIA85X9D3f4JCiRKwR+K1YSOTX2OM3cu
         0AKrtNSsJUANpRQ66nQMKrhOSUrApY+qvBJgUfGrXgpKnNOKI0ppcoJQ7OBDUPCOWSIJ
         UpphuE5s0joPCVC6bYtLE2pxoNEpWqwqLptX5DWykHISWu95V+BN6vz9B5UuQrdJjCgF
         trJncwhMrogUwvOiHGtUQWFl2upkU0BCFcOiVtPR9FY/2QFAXAZRikoDM0tOEF4RtVK2
         u3OA==
X-Gm-Message-State: APjAAAVfJjzgPej80qqVXGoFi9nd/AJuoy8BcNjFILjj7YpoYqy7JS4e
        gSn12TkLMqJtZEHT6PufNutSySsnz/0=
X-Google-Smtp-Source: APXvYqyWaTLqFI33tla3YHVDRK253otcw/QrO9xEl+FmnlcscWzMlrXzY2DwbYKQZQtD/oo+Fu2B7Q==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr3088787wrp.63.1581673832540;
        Fri, 14 Feb 2020 01:50:32 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:7cb8:8eea:bf1c:ed6? ([2a01:e0a:410:bb00:7cb8:8eea:bf1c:ed6])
        by smtp.gmail.com with ESMTPSA id s23sm6524540wra.15.2020.02.14.01.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 01:50:31 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v5 net] net, ip6_tunnel: enhance tunnel locate with link
 check
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <cf5ef569-1742-a22f-ec7d-f987287e12fb@6wind.com>
 <20200213171922.510172-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <13b0e28f-136f-0a16-8900-784afcad549d@6wind.com>
Date:   Fri, 14 Feb 2020 10:50:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200213171922.510172-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 13/02/2020 à 18:19, William Dauchy a écrit :
> With ipip, it is possible to create an extra interface explicitly
> attached to a given physical interface:
> 
>   # ip link show tunl0
>   4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ipip 0.0.0.0 brd 0.0.0.0
>   # ip link add tunl1 type ipip dev eth0
>   # ip link show tunl1
>   6: tunl1@eth0: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ipip 0.0.0.0 brd 0.0.0.0
> 
> But it is not possible with ip6tnl:
> 
>   # ip link show ip6tnl0
>   5: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>       link/tunnel6 :: brd ::
>   # ip link add ip6tnl1 type ip6tnl dev eth0
>   RTNETLINK answers: File exists
> 
> This patch aims to make it possible by adding link comparaison in both
> tunnel locate and lookup functions; we also modify mtu calculation when
> attached to an interface with a lower mtu.
> 
> This permits to make use of x-netns communication by moving the newly
> created tunnel in a given netns.
> 
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
