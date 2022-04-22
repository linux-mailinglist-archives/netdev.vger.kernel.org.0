Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8B450C01F
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 21:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiDVTG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 15:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiDVTGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 15:06:16 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EDD183271
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:55:19 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id q9-20020a056e02106900b002cbc8d479eeso4924903ilj.1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 11:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=SW7d9SQV8ry87PsdVWpwkJKv15ZwuogCuWjTqDpXCOs=;
        b=SBFC5YSzxPkhSUOT46p6jGsDMv1cLsnzzw5p34qdIDSqGtNGbCtoacxaQnS1QfwrTk
         gqMVYFEECd/Vfhuk4A7ecpp5Jl8s4JEB9fwT5zOrDDnQK+eKm5+lUqz6Nwd23sstyd8P
         e/kXsBVLvC7OgcdNW/JyRKoQD7D6Bc22Zoxz4aK+L9+vUB1AX+pr6M9jUbGTn+Txn+WW
         fWc0unZIDoWNQIRMqAZ+Q3wHLid5iXBurNZgg4w9MslQiPzOHxYYqwhLjdZw4RENT7AP
         DqYeFYbxdisFrC7UEMPJPwmQwr7kXhpc4Y0oTsFrHXD5hNlJtPnFtA6VChoUhyMQ393v
         hUMA==
X-Gm-Message-State: AOAM532jyEncQtz1mogtqZPPEIovuh+L09rJ/A8x3yAzHxB+DAxHFxHE
        mlDYex/EBYWDFhomJ+BbCRDa2ZFKAOsxuiAMDNvd+LAJXQmn
X-Google-Smtp-Source: ABdhPJzpcaxVT7ae5c/OrtdmL1gderEJn20oa971shuXRjgHIybvnhbBnELrASUvsLmPnZE7qyOWwVK2wIG0wS0Lt5aGrJzx2a80
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a62:b0:2cc:5634:763e with SMTP id
 w2-20020a056e021a6200b002cc5634763emr2550900ilv.68.1650653590752; Fri, 22 Apr
 2022 11:53:10 -0700 (PDT)
Date:   Fri, 22 Apr 2022 11:53:10 -0700
In-Reply-To: <00000000000033acbf05d1a969aa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ec946105dd42bcd6@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in bpf
From:   syzbot <syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        jiri@nvidia.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, leonro@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 0708a0afe291bdfe1386d74d5ec1f0c27e8b9168
Author: Daniel Borkmann <daniel@iogearbox.net>
Date:   Fri Mar 4 14:26:32 2022 +0000

    mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1499c6fcf00000
start commit:   1d5a47424040 sfc: The RX page_ring is optional
git tree:       net
kernel config:  https://syzkaller.appspot.com/x/.config?x=1a86c22260afac2f
dashboard link: https://syzkaller.appspot.com/bug?extid=cecf5b7071a0dfb76530
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=176738e7b00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13b4508db00000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm: Consider __GFP_NOWARN flag for oversized kvmalloc() calls

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
