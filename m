Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA75067B5FB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbjAYPbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbjAYPbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:31:23 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7AC59E78
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:31:20 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id z8-20020a056e02088800b0030c247efc7dso12670220ils.15
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:31:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=udHQk+LlTsImsgasQumCY8J2ntYLpL4el7t+VlKTCIE=;
        b=J2uz+B1LIUdtcBOux+V3vgFfQO7gz2S7crH0FQ6WF0iBQU7l6bRK1pwge4xDVt5Gmg
         RDUIJQeDj9MCL7HVB6C/K4zrb21H5JjG3GSyhJDOc9qbStzT1HaMfCBF+XXtYAgep6oK
         lsaIOUdnXygeRU0wE/gr/A2AbWCHYaR3hxEnMcGfz3dQcOMFzJgiUgKJGAmHZCr2TKxt
         olBpUgMiKQTKqNeWMh1NO2wvJBaX+SZeDu235JpGSb74H3qfc+gqUtB7HQpCf8iN6Cpl
         LhV3EJOGk/9EnD3bYsbpr3T+GBLtI6bpNyPyuPzc5wMOCOnf/fE74P5Q9Q/zkbb8fkgM
         s6Vw==
X-Gm-Message-State: AFqh2kqZmWK0o3rCrYzF7vQw+/MLtNjuxfzi1Tn4pc9nHUzw0ZOsmQze
        al8VpmguFrUk4Qu7Z40neoE4eBdjrKkL+qsnHhVdcApvNOcH
X-Google-Smtp-Source: AMrXdXvYuyCeKloGvGCiyTGOeSFAIYlP8RvM+qa/Pn+pUN3KSGjpHp6QfR1gEUZNgdL27egar00ZoXEcvv5hg5cc0eOGQiRY5LDo
MIME-Version: 1.0
X-Received: by 2002:a02:c88d:0:b0:3a3:2315:cb3b with SMTP id
 m13-20020a02c88d000000b003a32315cb3bmr3706135jao.206.1674660679405; Wed, 25
 Jan 2023 07:31:19 -0800 (PST)
Date:   Wed, 25 Jan 2023 07:31:19 -0800
In-Reply-To: <0000000000005d4f3205b9ab95f4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ea5ad205f31852e8@google.com>
Subject: Re: [syzbot] WARNING in pskb_expand_head
From:   syzbot <syzbot+a1c17e56a8a62294c714@syzkaller.appspotmail.com>
To:     alexanderduyck@fb.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, pabeni@redhat.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, willemb@google.com, yhs@fb.com
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

commit dbae2b062824fc2d35ae2d5df2f500626c758e80
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Wed Sep 28 08:43:09 2022 +0000

    net: skb: introduce and use a single page frag cache

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16a58035480000
start commit:   bf682942cd26 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b68d4454cd7c7d91
dashboard link: https://syzkaller.appspot.com/bug?extid=a1c17e56a8a62294c714
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b18438880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120c9038880000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: net: skb: introduce and use a single page frag cache

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
