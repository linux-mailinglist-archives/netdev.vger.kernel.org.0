Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BD5C420A
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 22:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfJAUxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 16:53:12 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:34648 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfJAUxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 16:53:12 -0400
Received: by mail-pf1-f180.google.com with SMTP id b128so8967319pfa.1
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 13:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q5tkH36kuwwnrWU10TuXYBpNyDtmx/BnfoulQT3Lfc8=;
        b=meOs8PVkxH1PrVlZjI7E2hRMVWOq4GPJ7ro8cJgsIyGoWwG/GTZPZviTJ0JJBPkvL+
         agBDA6WRuhMUpZ/v0fCBEtqMWWSmVFeVe+mCFBpBMeVFBASTRz9+7Rmx6kvFP1v6YkB1
         RJQgCEs3Rs4ity1m/vJkHQxH1ExxLbEodtQjqwyy3o9DNqyiKEHTMB1wjNC0Hm/cqobO
         IzOeIbVjOooK9VpOVQ872hkwtZd5xFoWf39chaH86B5kMao5dA60kNPL2CqVoF91HUL1
         lJRZIT7K//LoD40BTei5EFjztTNkD5FMNr8vtUUDWrvaqhEgYJizsfLqWs3E18WZdDBy
         AHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q5tkH36kuwwnrWU10TuXYBpNyDtmx/BnfoulQT3Lfc8=;
        b=pZYH1nwDReqsV4F72h8L6+mkGNtheSagLlqg8bLJBj4Kdf1F2CVVjrvmwWJ4S8aKdu
         JX9u8WIj8KbTwa+J5S4hVsVAPyMm2hXI8bQKboya9bo4i6GHaejzNShYKzVmOIbeVPlM
         t3dLVQmyZUMxjUuQCDrKTBvfdGQ0NWvynMZwQ7FwpnVluXla7ePvUx6DzGLdwVnmLoYV
         S40m6iuiOiGWIsDt6s0RE3Kvma01ce4JDsxPl0h+wNfU//+dADzJC+1GdRrgXjTZK69C
         5HJD/CF2L5HRO4cZu/SdgxazEKbPAt36ZOKlcltOBJigiDTTtDsBZYiklKkXmBCWQLRx
         CCXw==
X-Gm-Message-State: APjAAAU9c9ECJqPrhyCKg4MouDPjbcwNjbVwbm8qvS9MkrVSfGl8e53Q
        xo/DSx9sfjRUTI/753cYWFQqIW0X
X-Google-Smtp-Source: APXvYqxTpkbR6GjZZAPl9Or0SdmtuV0mDvfa1ZIDJhLdgVA4HoYsqgdwUPvPwb7fN+gePn3u37ZIrw==
X-Received: by 2002:aa7:9081:: with SMTP id i1mr299872pfa.148.1569963191117;
        Tue, 01 Oct 2019 13:53:11 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id v3sm21834013pfn.18.2019.10.01.13.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 13:53:10 -0700 (PDT)
Subject: Re: BUG: sk_backlog.len can overestimate
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     netdev@vger.kernel.org
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com>
 <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
 <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
 <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com>
 <CAGXJAmzHvKzKb1wzxtZK_KCu-pEQghznM4qmfzYmWeWR1CaJ7Q@mail.gmail.com>
 <47fef079-635d-483e-b530-943b2a55fc22@gmail.com>
 <CAGXJAmy7PTZOcwRz-mSiZJkEL4sJKWhkE8kisUZp8M=V1BBA3g@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f572890a-ca31-e01a-e370-c8b3e3b51f5b@gmail.com>
Date:   Tue, 1 Oct 2019 13:53:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGXJAmy7PTZOcwRz-mSiZJkEL4sJKWhkE8kisUZp8M=V1BBA3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/19 1:45 PM, John Ousterhout wrote:

> 
> But this isn't really about socket resource limits (though that is
> conflated in the implementation); it's about limiting the time spent
> in a single call to __release_sock, no?

The proxy used is memory usage, not time usage.

cond_resched() or a preemptible kernel makes anything based on time flaky,
you probably do not want to play with a time limit...



