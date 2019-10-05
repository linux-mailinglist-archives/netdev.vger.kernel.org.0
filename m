Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68871CC961
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 12:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfJEKcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 06:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54422 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfJEKcW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 06:32:22 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 03463C057E9A
        for <netdev@vger.kernel.org>; Sat,  5 Oct 2019 10:32:22 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id e1so981710lfb.12
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 03:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xEOpG4bsmUSfRZlD4oRk66x9TPyoiZQEqXQbP3ed//Q=;
        b=Go/ZCFUAoFbx2haQ9HRD2nMqpKrV24+TI/QMBvPwnXhwylpD7LWizGNKRTQKGAjjMD
         K4EogrmK7xY5sSnhaHOlMTbgzdFzAdzEObNaUXWVnHu0AcBO7NSXXBdzRfhePL9EZM/i
         5SHxzSilTgeMa6Gc4RF2n+TiaA9WBkLNOOkHiFUjmmXid50lsso2O8hqs6PsfGLWDMYt
         HSI7EODoAiwOQwboz6J+f5eRznSlysU0VJfmZdZg6t1mK7QBCArbTI4rN9BVhJ/dtatC
         s+9cWx5QyvK9IPRcfSJBQfmzqk29MhKm2M3tpJCpLP7gS3DdeLcLZ4BNV5MtLqHCb5rE
         VE1Q==
X-Gm-Message-State: APjAAAUkxDZGcXqrN2VcJ5vMGLN1eDhxEDgO31XLLVpEebmdcBwZIbd8
        cvpa3l3sYd7OaNdxfwa1X7jR725hja8d/Zs0zhJ+JXdpix/s3JFIMrgBPYkgqj3DgwvxzrgOXeu
        qD2dH1VOQlHeeTvKd
X-Received: by 2002:a2e:8603:: with SMTP id a3mr12269765lji.98.1570271540584;
        Sat, 05 Oct 2019 03:32:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwf0fExKtOtQdIInSG5yC6hGt3qpaIrZZdE3x9boKQMuMNpjHjXDiNStm8X3U55Q5ZLPaqueA==
X-Received: by 2002:a2e:8603:: with SMTP id a3mr12269752lji.98.1570271540379;
        Sat, 05 Oct 2019 03:32:20 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k7sm1736706lja.19.2019.10.05.03.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 03:32:19 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D646018063D; Sat,  5 Oct 2019 12:32:18 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/5] bpf: Support injecting chain calls into BPF programs on load
In-Reply-To: <20191004161715.2dc7cbd9@cakuba.hsd1.ca.comcast.net>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1> <157020976144.1824887.10249946730258092768.stgit@alrua-x1> <20191004161715.2dc7cbd9@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 05 Oct 2019 12:32:18 +0200
Message-ID: <877e5jo53h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 5b9d22338606..753abfb78c13 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -383,6 +383,7 @@ struct bpf_prog_aux {
>>  	struct list_head ksym_lnode;
>>  	const struct bpf_prog_ops *ops;
>>  	struct bpf_map **used_maps;
>> +	struct bpf_array *chain_progs;
>>  	struct bpf_prog *prog;
>>  	struct user_struct *user;
>>  	u64 load_time; /* ns since boottime */
>> @@ -443,6 +444,7 @@ struct bpf_array {
>>  
>>  #define BPF_COMPLEXITY_LIMIT_INSNS      1000000 /* yes. 1M insns */
>>  #define MAX_TAIL_CALL_CNT 32
>> +#define BPF_NUM_CHAIN_SLOTS 8
>
> This could be user arg? Also the behaviour of mapping could be user
> controlled? Perhaps even users could pass the snippet to map the
> return code to the location, one day?

(Forgot to reply to this point).

Yeah, we could make it user-configurable. Or just dynamically increase
the size of the array if we run out. Or do something different with
linked list, as I alluded to in the other reply :)

-Toke
