Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3330F1034AD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 07:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfKTG7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 01:59:31 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35310 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbfKTG7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 01:59:30 -0500
Received: by mail-lj1-f193.google.com with SMTP id r7so26234933ljg.2
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 22:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=EtYzPJ3xgyfV8PEix2L28b58r2Oi7XfTDsfJqJbKR+g=;
        b=02R2RaYCsWHDix1OmMUyIv+Sdb1ZJ38A77A0gM6YdcxAbkv1sPeYhvPfEzi3k/xDDl
         UOenCtIIZF9y0MCZkaV59ySka82WyR77okJTpislcFTlsWHgnqHp2zdm3CIDNzrbOq/i
         ZLG8uiNw9Ffbv+qMkmv//n1LRRMt+c1j5Sdjp4g1kUoa7LTgYJZclP+ME4oqV30r1AJJ
         O6fHTgBrkpp3WkAMPht7LSBQo1w64Ul+CpRHZTB72OagtFz0YRkTkomRInbI3/8FLhu0
         RTBx2VUd6qp1G6EX7hmTTGbLdPkOlRTcaRvYVzSeIOh8R1SwupXOvFDio2PZlCzKvEIl
         Jw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=EtYzPJ3xgyfV8PEix2L28b58r2Oi7XfTDsfJqJbKR+g=;
        b=o9A77Q0vswOLMqSV3f3tdkOgoMNImTeudW9zLvPFBUXx/QdI6F3qhTPH/7v+ynPB0x
         dNA7iLBX7UCHgrBaEtnBtDV6Ens/h74gNrbM92tbEsKuIMTGV3IBLbabNppXjHPpPCl2
         jLV/6pD4Nospw5sKjfURW4PEw3qXtvpJMEEnZaKq1FKOz/pubAosHbs2oplbDPyrz4wO
         9H8YuzT4TfrX03LXIfLYp/NOaNAZYsQc/kQwrhSddh50v/zOghPzNYQ8PnaA3u2vMBYe
         nDP7o72lWDg3iCcln3Ujp3QLSQHQf3eM3ub1NrM1Egc++Nhq+p7VSg28NETIQJkngoG7
         pvqg==
X-Gm-Message-State: APjAAAVBtQHGoCtEjS3OPB5Y19QMkIiZyYttmTYfBF7Abs4B5667KLF9
        RuwD3zaPX3pjny3l4YjkS9lhfbpl70A=
X-Google-Smtp-Source: APXvYqxUTZfbQxAYmN7JlS+nvet/9h+Ckwg5xjmqWiLGSjlJLucbq5CuP9q90UuxfN0fe0oRSAMRaQ==
X-Received: by 2002:a2e:547:: with SMTP id 68mr1229505ljf.150.1574233168414;
        Tue, 19 Nov 2019 22:59:28 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id m9sm3449524lfj.54.2019.11.19.22.59.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 22:59:27 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: Re: [PATCH] net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
References: <20191119095121.6295-1-jouni.hogander@unikie.com>
        <20191119.171333.624799505921966746.davem@davemloft.net>
Date:   Wed, 20 Nov 2019 08:59:26 +0200
In-Reply-To: <20191119.171333.624799505921966746.davem@davemloft.net> (David
        Miller's message of "Tue, 19 Nov 2019 17:13:33 -0800 (PST)")
Message-ID: <87wobvqbht.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: jouni.hogander@unikie.com
> Date: Tue, 19 Nov 2019 11:51:21 +0200
>
>> kobject_init_and_add takes reference even when it fails.
>
> I see this in the comment above kobject_init_and_add() but not in the
> code.
>
> Where does the implementation of kobject_init_and_add() actually take
> such a reference?

kobject_init_and_add -> kobject_init -> kobject_init_internal -> kref_init

kref_init initializes ref_count as 1.

>
> Did you discover this by code inspection, or by an actual bug that was
> triggered?  If by an actual bug, please provide the OOPS and/or checker
> trace that indicated a leak was happening here.

Originally found it via memory leak identified by Syzkaller. I will
submit new one with memleak dump.

>
> I don't see anything actually wrong here because kobject_init_and_add()
> doesn't actually seem to do what it's comment suggests...

See the code path above.

BR,

Jouni H=C3=B6gander
