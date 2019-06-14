Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB05D45D46
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 14:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfFNM72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 08:59:28 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39874 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfFNM71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 08:59:27 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so996660pls.6;
        Fri, 14 Jun 2019 05:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MQjiqrlFAdKol+khhCuvHUzI6XoeO3twrfahHKAoOkA=;
        b=iKJCDROoSpEOWeB6BVk1a+gvmvcorZg2HExhdgiuNwu9sezEbA6h/j02SjI7sQ0w/A
         fzPtmAGtpNRAisPtcbxQYvTysdsmU+csbUX8FnWg+OXPeb56ldpXCVWUzB1OqDrhc0wu
         RUu7TjxK8qDlk2nEBPwpzY0+bGFB5vz02DelDIPWU43YICpFHrka4BPik1DT7Q3t9Bcb
         WRYl8BMq5UHeqa8dctpyEEL6eQMrs40lZHqoFAPRkBphA+kjhoSED4cVbuiyUn64hU1h
         uHGZjAfrLjhffU0k9gAhDrVnlukV7y+3wKIvD3GNWISau1POnxVsx241MwsBi2xBpSfG
         3/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MQjiqrlFAdKol+khhCuvHUzI6XoeO3twrfahHKAoOkA=;
        b=CjEdOCHJBFMkiLIUTsaegsKXht8OmDrFILyzVZVMMrs5c4LeyZppBSFTQFeCPEVZzs
         r03mDPGBl1E2Z3HjY2wHA5Serb9NTzF0r0p2M6k37iptFr/6rHF2lVdruoHELTPz1HzF
         yBa+Ifx/IVmyKfBtY3ZrXhn9DkJKK3E/MV/LpLT9uqUUcwDjewjd5ybNnpCeza4pWNs+
         QEHvnnAsflGpmhdt/nOGhfoRLgunYOPEo6vHBUqHaGfW2qiUB5+MLfp1TmWGBSKzgkNU
         MNgDKbLWYdm3fkWCCLFmbjOC0r4hcd6kLy2wS+Yv+3RqNnuDonpR/L4IFUTkmAwqvFOy
         jhDA==
X-Gm-Message-State: APjAAAXuV/zHCR2klXzSiJzZpn0CVWZd1dipKWtZ7FQycqPn5AMKBO37
        KY5Du8g336Oax1E98Wo66b8=
X-Google-Smtp-Source: APXvYqwaZu8yA4W1fCKXREFQZM8zcDc5q7wcLFDysf7br0pNm6awleuZe8uxPvzXnP5dCEyvXMUDuw==
X-Received: by 2002:a17:902:2aa8:: with SMTP id j37mr51040563plb.316.1560517167161;
        Fri, 14 Jun 2019 05:59:27 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-240-142.s42.a013.ap.plala.or.jp. [223.218.240.142])
        by smtp.googlemail.com with ESMTPSA id d6sm2685781pgv.4.2019.06.14.05.59.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 05:59:26 -0700 (PDT)
Subject: Re: [PATCH bpf 1/3] devmap: Fix premature entry free on destroying
 map
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
 <20190614082015.23336-2-toshiaki.makita1@gmail.com> <877e9octre.fsf@toke.dk>
 <87sgscbc5d.fsf@toke.dk>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <fb895684-c863-e580-f36a-30722c480b41@gmail.com>
Date:   Fri, 14 Jun 2019 21:59:20 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87sgscbc5d.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/06/14 (金) 21:10:38, Toke Høiland-Jørgensen wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> writes:
> 
>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>
>>> dev_map_free() waits for flush_needed bitmap to be empty in order to
>>> ensure all flush operations have completed before freeing its entries.
>>> However the corresponding clear_bit() was called before using the
>>> entries, so the entries could be used after free.
>>>
>>> All access to the entries needs to be done before clearing the bit.
>>> It seems commit a5e2da6e9787 ("bpf: netdev is never null in
>>> __dev_map_flush") accidentally changed the clear_bit() and memory access
>>> order.
>>>
>>> Note that the problem happens only in __dev_map_flush(), not in
>>> dev_map_flush_old(). dev_map_flush_old() is called only after nulling
>>> out the corresponding netdev_map entry, so dev_map_free() never frees
>>> the entry thus no such race happens there.
>>>
>>> Fixes: a5e2da6e9787 ("bpf: netdev is never null in __dev_map_flush")
>>> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>>
>> I recently posted a patch[0] that gets rid of the bitmap entirely, so I
>> think you can drop this one...
> 
> Alternatively, since this entire series should probably go to stable, I
> can respin mine on top of it?

Indeed conflict will happen, as this is for 'bpf' not 'bpf-next'. Sorry 
for disturbing your work. I'm also not sure how to proceed in this case.

Toshiaki Makita
