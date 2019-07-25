Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB6074B98
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 12:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfGYKcX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jul 2019 06:32:23 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39267 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfGYKcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 06:32:23 -0400
Received: by mail-ed1-f68.google.com with SMTP id m10so49751355edv.6
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 03:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/2un5ksNrOd10yWYzJ8gOyQ2g8NBHaIsKwiZaAjygcc=;
        b=TLgg37Bfkv0phRo1UgzlTNjukmNSRGYjN31ou6TWgw/XO3q7nRzgCH9HvFDNNzMao8
         MnyiPhIVqvgpSkVTiGrwt5TayE7lcEYlYT6jAsPE5RGjA3t5cuTQJq7zHoIlLZ1D5bvM
         gyKX8MMNaOv+y4g9mVJ5LKoZR0rEnyRIQlbGGu/hW3l62NRG59XFgJUtmId8CAcAsD6R
         udicQiKUcpWMRRumEjm40vDwKxUE7BI5GMY2Sa9OLMR/SlJ5FY6slETm00KpYxlEapS9
         Oqk31YVpKTEVxZOr+qlYt4WBw/GzfwdTXdq97Th2QEHf8X3WHyl3SiuT728ftRtwMQIw
         cCcA==
X-Gm-Message-State: APjAAAVELWD91HA9aSzuIMEI4yZeRp5T4GvNEE66Fy0ROsbb6e4Ykrmg
        z6hWsNgq4aYR8dFiq4fkzJrDog==
X-Google-Smtp-Source: APXvYqx7XnnoK4r/GcQMuYy8KyuSv23OlOq6UgmoTAlmbCjpkveGxJ0B1ApxdHZGeL61F+UV7aU3sw==
X-Received: by 2002:a50:91e5:: with SMTP id h34mr74727947eda.72.1564050741359;
        Thu, 25 Jul 2019 03:32:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id b15sm13785613edb.46.2019.07.25.03.32.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 03:32:20 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 49B1D1800C5; Thu, 25 Jul 2019 12:32:19 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Yonghong Song <yhs@fb.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v4 3/6] xdp: Add devmap_hash map type for looking up devices by hashed index
In-Reply-To: <20190725100717.0c4e8265@carbon>
References: <156379636786.12332.17776973951938230698.stgit@alrua-x1> <156379636866.12332.6546616116016146789.stgit@alrua-x1> <20190725100717.0c4e8265@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Jul 2019 12:32:19 +0200
Message-ID: <87muh2z9os.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 22 Jul 2019 13:52:48 +0200
> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>
>> +static inline struct hlist_head *dev_map_index_hash(struct bpf_dtab *dtab,
>> +						    int idx)
>> +{
>> +	return &dtab->dev_index_head[idx & (NETDEV_HASHENTRIES - 1)];
>> +}
>
> It is good for performance that our "hash" function is simply an AND
> operation on the idx.  We want to keep it this way.
>
> I don't like that you are using NETDEV_HASHENTRIES, because the BPF map
> infrastructure already have a way to specify the map size (struct
> bpf_map_def .max_entries).  BUT for performance reasons, to keep the
> AND operation, we would need to round up the hash-array size to nearest
> power of 2 (or reject if user didn't specify a power of 2, if we want
> to "expose" this limit to users).

But do we really want the number of hash buckets to be equal to the max
number of entries? The values are not likely to be evenly distributed,
so we'll end up with big buckets if the number is small, meaning we'll
blow performance on walking long lists in each bucket.

Also, if the size is dynamic the size needs to be loaded from memory
instead of being a compile-time constant, which will presumably hurt
performance (though not sure by how much)?

-Toke
