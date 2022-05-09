Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DE7520729
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiEIV6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbiEIV43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:56:29 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6272D3F59
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 14:50:10 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id l8-20020a056e021aa800b002cf778c63caso5333295ilv.10
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 14:50:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=s2rmpyNyFEujAf+EJYBoIEjX5MtLaffn8+X0o9N5fgE=;
        b=OSsdeIb7E7WRSnQDYIjGioqPTReCevnEOsU+x+rY4+Gq9Zc/ii1C16G0Zss3d6Q8Uz
         9tMwWXXxRmuYD4NzgUtOsGB6igDH/assPkYWOEScYgW0wv7mKRx8JvoiR133CxG/C5C1
         H1hCo5ofVtFIOWSNyfDDQlpP4B9dErzOq9lcoHq3BqUC/EhxMQ381xpzMkdIQPVn8+63
         BB3sh5+A3GUMfj27+vvxUPVTZ7AUxxXKSqOtrBRLZFyAKPqBRnVZEaT0NrbZpeNImx/X
         6y0nQys9m6u1YPceXs5rbkcLCpMbbprdT5/65Hq9aluQNA4uXdeCIpRA4IHj41itzr1M
         P0Gg==
X-Gm-Message-State: AOAM531EhjJHurnFsph89lREsRgfcAxU0SjubuAfTn0DzNgTl5bbwdQe
        e+2htacq9a9pUjV1D+9pZJNeCPo/eGiCchPZvM7hh0pv2emy
X-Google-Smtp-Source: ABdhPJwBVtl04Ej8XUy6iLjBCkDUNPExpqGoo3a5jGV8ypU3eIqqfYkoQPwIMtXgmETBrBFu7BHvBe/1eA2T9oXxg64g8WR0pnz3
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214b:b0:2cf:21fa:cce6 with SMTP id
 d11-20020a056e02214b00b002cf21facce6mr7280704ilv.160.1652133010262; Mon, 09
 May 2022 14:50:10 -0700 (PDT)
Date:   Mon, 09 May 2022 14:50:10 -0700
In-Reply-To: <00000000000029572505de968021@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000032d06e05de9b3136@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in bio_poll
From:   syzbot <syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net, hch@lst.de,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        ming.lei@redhat.com, netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has bisected this issue to:

commit 0f38d76646157357fcfa02f50575ea044830c494
Author: Christoph Hellwig <hch@lst.de>
Date:   Tue Oct 12 10:40:45 2021 +0000

    blk-mq: cleanup blk_mq_submit_bio

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12506f7ef00000
start commit:   c5eb0a61238d Linux 5.18-rc6
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11506f7ef00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16506f7ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78013caa620443d6
dashboard link: https://syzkaller.appspot.com/bug?extid=99938118dfd9e1b0741a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1484cbc1f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10c7026cf00000

Reported-by: syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com
Fixes: 0f38d7664615 ("blk-mq: cleanup blk_mq_submit_bio")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
