Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD44C671E44
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjARNnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjARNmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:42:24 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1BEE66CE5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:11:23 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id f12-20020a056602038c00b00704b6f4685dso5043416iov.9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 05:11:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gb9ye5L384z0sJ9lHOgovYJTtmnNnzRSfStsIP9mHp4=;
        b=1JGxfigCHKV8kBLjMS+QEPPLAvS/8uKUmZLN8EMFlFnjiqSTod2Oij9iOueIoz74PX
         0KRDwSGeI08B350ZeGwVLu45gliJZWOTopMXvtKVFqhRF8ugMGp16RB18Or04vvzLUt3
         JpqBaoe8vCuMVEskZfU+4p34LPRJB5VkO/4+tgbIV4qdiQOS7L2cHH2IvYS/VPMwKLE7
         y24cvvQM7nhIJYpav8J9Qu+FjIM+Ap7gYyvwMnuinyVUD+v9NcRzWyfuHq4tLyiwYrar
         eB03/V5cHKBohFnox60CI3jTbWnjtiZr4lJNla94Yv8QQSKujh3R2NKr8t/7PZGuPju/
         ql/w==
X-Gm-Message-State: AFqh2koEX0N8nFB5nIjM1G1VYLyDKW38aVJOmRNOs3/jnOc/ZaaZEQiL
        CcYjgEV7wjUkL+NDnfTMjYEhcaIS61dDqGAyg4TgW5OO4zNr
X-Google-Smtp-Source: AMrXdXuzeXKW4OevNrY1rNZ/gojCg/BXjtv/ERGhG5fJgGg1aitQlfltHaryjNoMWEuTb+ALgiV6PMylnyGQSAMulP7Z+slvC5Qd
MIME-Version: 1.0
X-Received: by 2002:a02:c643:0:b0:38a:c2a7:369d with SMTP id
 k3-20020a02c643000000b0038ac2a7369dmr633850jan.245.1674047483287; Wed, 18 Jan
 2023 05:11:23 -0800 (PST)
Date:   Wed, 18 Jan 2023 05:11:23 -0800
In-Reply-To: <000000000000fbb2d505f27398cb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000941ee205f2898d65@google.com>
Subject: Re: [syzbot] possible deadlock in release_sock
From:   syzbot <syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com>
To:     cong.wang@bytedance.com, davem@davemloft.net, edumazet@google.com,
        eric.dumazet@gmail.com, gnault@redhat.com, jakub@cloudflare.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

syzbot has bisected this issue to:

commit 0b2c59720e65885a394a017d0cf9cab118914682
Author: Cong Wang <cong.wang@bytedance.com>
Date:   Sat Jan 14 03:01:37 2023 +0000

    l2tp: close all race conditions in l2tp_tunnel_register()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15331c61480000
start commit:   87b93b678e95 octeontx2-pf: Avoid use of GFP_KERNEL in atom..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17331c61480000
console output: https://syzkaller.appspot.com/x/log.txt?x=13331c61480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
dashboard link: https://syzkaller.appspot.com/bug?extid=bbd35b345c7cab0d9a08
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1716b3a1480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e57a91480000

Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com
Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
