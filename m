Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96B74C2B39
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 02:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfJAAPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 20:15:01 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:38989 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731887AbfJAAPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 20:15:01 -0400
Received: by mail-pf1-f181.google.com with SMTP id v4so6582928pff.6
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 17:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7K/Bnrak7x1G6HDogFEegtkUmkk51yKyyxVEqO0ywqc=;
        b=j+JXI9w2YGjhRhbkTD7JI2XzTFlCl/uHN2w6zZJ/7Mf0QvBGjOfpzvzVR8kVgTZpMw
         /3ufQlrBHhXVdPZwu8mqcYh+6Ld5AhRSV4/VJRXJJSMP/EFobuwxZgtPOrhXE2VP+EWG
         olX5kLcjJH5Ye/jxlX+20sAC0eb8WRsdl0HwtJgeQNYb7miLF+AZc8YV7mCgWNZ/T2Tg
         Hob3yPq1iWkqIe/7USGXZD9MiwPlOMVEYTVtJ/jZ5k0+Hyovo3ZYEnRO1Ls6D8nG4W8c
         z+PDMHySoC98KWEFBj1fUOfsLuQ4IOHEzx12fL/IPZRQyT0IalWfECqKZBzElCHNEJXr
         sEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7K/Bnrak7x1G6HDogFEegtkUmkk51yKyyxVEqO0ywqc=;
        b=s70ZYKkGh+kNFVXFKZmxfNK5ALUj2BJ2D3RvwQQ1Ej3gbu0P6NsQPNcl3VWAB6+bmV
         ZaZgSQ5RKba77w2W51YLf9o5AmNSBn/7MeHtgkwPQeLsPR/faZzwfNx0gIJLrPpJrBdg
         Or+jSwZqHTjoqGc+ojV+2ExXOp3VdXuU7qpHXnb+YQqnx6Hj7i7/gV7C+4QIDFfLbNlu
         8RcjmyEkOmC3FjysayBi/IjcBceNCKv5YVrSC0TlXcG2znvXqliqAc35Kg7sT0O6NEM3
         WK0MA72vTZbSe4bP5EF6vDUzzsvw8EGlbZhFWldr0kbej3hcJdl5YfhVxQpZGqYNYFJx
         no/Q==
X-Gm-Message-State: APjAAAWGHwapf1ZJYQS7hkKpywOvmsWhU8r+SicmkbX97+gEfPBAi3w5
        5IASeSTTV3mOBbrO4y7U9BpZhRY8
X-Google-Smtp-Source: APXvYqzZH8l2vtEA++PXQKimWVYfL/IvSbB0+VoFJaVKS+uXiK9hspT0FlkRPuRgQxONuf7axLoJVg==
X-Received: by 2002:aa7:9f43:: with SMTP id h3mr24768467pfr.215.1569888898749;
        Mon, 30 Sep 2019 17:14:58 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id c125sm13611619pfa.107.2019.09.30.17.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 17:14:58 -0700 (PDT)
Subject: Re: BUG: sk_backlog.len can overestimate
To:     John Ousterhout <ouster@cs.stanford.edu>, netdev@vger.kernel.org
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com>
Date:   Mon, 30 Sep 2019 17:14:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/19 4:58 PM, John Ousterhout wrote:
> As of 4.16.10, it appears to me that sk->sk_backlog_len does not
> provide an accurate estimate of backlog length; this reduces the
> usefulness of the "limit" argument to sk_add_backlog.
> 
> The problem is that, under heavy load, sk->sk_backlog_len can grow
> arbitrarily large, even though the actual amount of data in the
> backlog is small. This happens because __release_sock doesn't reset
> the backlog length until it gets completely caught up. Under heavy
> load, new packets can be arriving continuously  into the backlog
> (which increases sk_backlog.len) while other packets are being
> serviced. This can go on forever, so sk_backlog.len never gets reset
> and it can become arbitrarily large.

Certainly not.

It can not grow arbitrarily large, unless a backport gone wrong maybe.

> 
> Because of this, the "limit" argument to sk_add_backlog may not be
> useful, since it could result in packets being discarded even though
> the backlog is not very large.
> 


You will have to study git log/history for the details, the limit _is_ useful,
and we reset the limit in __release_sock() only when _safe_.

Assuming you talk about TCP, then I suggest you use a more recent kernel.

linux-5.0 got coalescing in the backlog queue, which helped quite a bit.
