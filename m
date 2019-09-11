Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16935AFBB8
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbfIKLru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:47:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52501 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfIKLru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 07:47:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id t17so3088616wmi.2
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 04:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RF+6w8BJcyQhZZWo174dSXXOeAF1v3olKAAmugo7tj4=;
        b=KuyTIfsz9A6MBK6sODHfelrdKTXSN7fX6ZHZRRXdB+m5OJXywMHRHVtkk/QTh6aqNs
         w2XCxBq0BMTl/252G4axdh4iyvu9AXohoVpS9a+kwtZ7vsGljed+rulpU+diZN6mp3Kj
         FDIcGiTsoCqL5ZcuA01CXJ1y0FD25TrhpRAYFR1uyRl1W1qwxdlPGm5AMm/CwnrsZdSI
         MxQoIH0oDxJsrvb0nYEctPAs5f4Nk0mEVaKcN3LZB2F8se2FY4mDzn5VKqcWKonUSSK4
         scoJ3/GVUsrDJP+TfOadGY5gbvMFCZ73UxHKfz3A6mW51TuqGODO/75W5K5i2Job7GdX
         Xwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RF+6w8BJcyQhZZWo174dSXXOeAF1v3olKAAmugo7tj4=;
        b=kEInRJMdOtOo1G6b7dmlmtkDtc9r13kqTndr53qsvf76ulpeaFwOJPO1eWZJ7Att8z
         pn5enjPu5JXGp5I82qx2bd1pUG28C3jFRx2/MntBlacfpZo8b37NB7uhdsCST0/1sKes
         xF/SI47gnTnrolZozmzLI9kV1ip7zJ/oFDIUdJdUbb2XKfBNc8ma0lJNhKxijl8W1Hiy
         b2wM1DXNvzdV1Yew245R7ENXErW+5367keedogtPXNLvEyYDUunIGDsOjsX/WVVzYNIR
         KvaCyCC/meZ3RTePXxnvDJbmYLh8J4A5novPDXSyIFkIhagptswUX2GEerqK65pSM/nq
         4ukg==
X-Gm-Message-State: APjAAAVf+W5+239PwgQZMj+NJx5tNpSpQxWguHtxzH/S6yi+yIfipHG9
        VtUqEHEw9kEy7i3bbB4Q+az7iiQfgvT7FQ==
X-Google-Smtp-Source: APXvYqwQz67eGvoyNHU17g/7JMrpKQMdKr+vr6pmoOHWcYLHX3/QTLHd4jrlLw4E6FyekUAXjtrWmw==
X-Received: by 2002:a1c:a697:: with SMTP id p145mr3231474wme.24.1568202466815;
        Wed, 11 Sep 2019 04:47:46 -0700 (PDT)
Received: from [192.168.6.83] ([148.69.85.38])
        by smtp.gmail.com with ESMTPSA id h7sm2854326wmb.34.2019.09.11.04.47.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 04:47:46 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next] ipv6: Don't use dst gateway directly in
 ip6_confirm_neigh()
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Guillaume Nault <gnault@redhat.com>, Julian Anastasov <ja@ssi.bg>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
References: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <7f1f373d-4153-0e3f-7710-341fe2f02db7@6wind.com>
Date:   Wed, 11 Sep 2019 13:47:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <938b711c35ce3fa2b6f057cc23919e897a1e5c2b.1568061608.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 09/09/2019 à 22:44, Stefano Brivio a écrit :
> This is the equivalent of commit 2c6b55f45d53 ("ipv6: fix neighbour
> resolution with raw socket") for ip6_confirm_neigh(): we can send a
> packet with MSG_CONFIRM on a raw socket for a connected route, so the
> gateway would be :: here, and we should pick the next hop using
> rt6_nexthop() instead.
> 
> This was found by code review and, to the best of my knowledge, doesn't
> actually fix a practical issue: the destination address from the packet
> is not considered while confirming a neighbour, as ip6_confirm_neigh()
> calls choose_neigh_daddr() without passing the packet, so there are no
> similar issues as the one fixed by said commit.
> 
> A possible source of issues with the existing implementation might come
> from the fact that, if we have a cached dst, we won't consider it,
> while rt6_nexthop() takes care of that. I might just not be creative
> enough to find a practical problem here: the only way to affect this
> with cached routes is to have one coming from an ICMPv6 redirect, but
> if the next hop is a directly connected host, there should be no
> topology for which a redirect applies here, and tests with redirected
> routes show no differences for MSG_CONFIRM (and MSG_PROBE) packets on
> raw sockets destined to a directly connected host.
> 
> However, directly using the dst gateway here is not consistent anymore
> with neighbour resolution, and, in general, as we want the next hop,
> using rt6_nexthop() looks like the only sane way to fetch it.
> 
> Reported-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
