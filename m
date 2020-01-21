Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09721445EE
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgAUU3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:29:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33574 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgAUU3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 15:29:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id d139so2860619wmd.0
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 12:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4v06OcVu6AWGAgREkUN+nJOIVq296IIoZLXUePQ8oZc=;
        b=XrBNnqp79Hr/DOZDtYgis7af+OtRIktTWNbtDXG8Y3/Qb8GRB3slWN5aPD9R7pTrKH
         JBnhybcpF1QDwrQadEzEW2ochphAXfVTSrRSEQouPnd0SbFrgughr7vA4JaBSnGSvqHG
         ICHqKKYVbqVzzNqFxuuHSutNnHmbBzCGww49E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4v06OcVu6AWGAgREkUN+nJOIVq296IIoZLXUePQ8oZc=;
        b=B3XW+9nl6VSP3vees/CMqrfDhEj7kml6NNTequDy9MqDRdHpSTLZBG/nMdLXb4zEkC
         WxQWSgy1K35kNorEnec1yqzVkghcUyofSEuo3M4wffSHI/9kv28Jxvhp2KYMrOGQF6Wr
         FRaDUd/qgytxJX367Jh+95+EOOTLhxsASUZOhbIzVq0Z2yfvMZC4flwbmzRTU6eTFEDA
         ZnhtFlUv1DcCSMbGJWE5GR5fN89apXUzMansQbPSDkt1mXmuitxmRdGsSQkFiQt5Flqd
         kC1N947BYM3bGyXX5wIBrnZVXsN5JTxY+oHggYOa4V0/hnrCMXJEF5pHbJ5C8ooPP23s
         jtdQ==
X-Gm-Message-State: APjAAAURJEQfYDUgAqejR6N4k1ZOaFWfj0mlgj5NUwYT622e2Q/1gIpQ
        56o9CfOgKqBz0KFpoTiyDFulhA==
X-Google-Smtp-Source: APXvYqzXKlscNyzgyDBzjygHPG9zXc5qiNK6Ib4TKhvYN1HXHb/DAgBd7X6W185JcEtce4e4RPF1Ow==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr193695wmg.92.1579638557788;
        Tue, 21 Jan 2020 12:29:17 -0800 (PST)
Received: from localhost ([2620:10d:c092:180::1:db6c])
        by smtp.gmail.com with ESMTPSA id z187sm775841wme.16.2020.01.21.12.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 12:29:17 -0800 (PST)
Date:   Tue, 21 Jan 2020 20:29:16 +0000
From:   Chris Down <chris@chrisdown.name>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH] bpf: btf: Always output invariant hit in pahole DWARF to
 BTF transform
Message-ID: <20200121202916.GA204956@chrisdown.name>
References: <20200121150431.GA240246@chrisdown.name>
 <CAEf4BzZj4PEamHktYLHqHrau0_pkr_q-J85MPCzFbe7mtLQ_+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAEf4BzZj4PEamHktYLHqHrau0_pkr_q-J85MPCzFbe7mtLQ_+Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko writes:
>> --- a/scripts/link-vmlinux.sh
>> +++ b/scripts/link-vmlinux.sh
>> @@ -108,13 +108,15 @@ gen_btf()
>>         local bin_arch
>>
>>         if ! [ -x "$(command -v ${PAHOLE})" ]; then
>> -               info "BTF" "${1}: pahole (${PAHOLE}) is not available"
>> +               printf 'BTF: %s: pahole (%s) is not available\n' \
>> +                       "${1}" "${PAHOLE}" >&2
>
>any reason not to use echo instead of printf? would be more minimal change

I generally avoid using echo because it has a bunch of portability gotchas 
which printf mostly doesn't have. If you'd prefer echo, that's fine though, 
just let me know and I can send v2.
