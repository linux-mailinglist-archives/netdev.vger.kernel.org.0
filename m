Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C25D633D21
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiKVNIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbiKVNIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:08:16 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D986B13F42
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:08:13 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id v81so15739024oie.5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PHdNKmlcjkg2lgDyUCzsk4zF+bSsaA8CvP7Z8C5Ntfs=;
        b=iWHh/0QsAlIrmph2zH5KkHHWmVB+lAuyTJDFaTwsQKKQ6kYAi5u3CGc6oRU/pbss4s
         NoBsRfmESEVIMLWtvwLxz8OMRok5smSpDdJU70odhpuXZ2+2WOvvde+O3Yn4ujL0xK1e
         ptmYhKCFkGXh4MdsdCQ3BOoj7A1/7AZ7keAYRrF6pALvWzgA9chOqkBqXM0BsBPj5+Ru
         VIQVI/+rRjdxit1u1O0W4/y5aQXGpipSQKxHs34Sj9dhElE/6GNGb/Ew9D3z+R5TPJWA
         aCgDDLmyM0dtQ22g2ugzKnZbVL3Q56lrlehf4k/XpERBVGMLXtndnQsmXFOLpJEqpc4v
         lrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PHdNKmlcjkg2lgDyUCzsk4zF+bSsaA8CvP7Z8C5Ntfs=;
        b=6dgs2TYL95nywhOplcQ7Flm8ImJcwfJDVVF9Lw1ZOr7MIZggF6Cb5UgkgiAKTuq4nT
         UQMdsupsS4ee8gKE1DPUTTvavB/6OiTHaV2NolSBXFw8LOCqwF6j0ra2Tqt/cXwTbHsi
         GysygrX0Rl8n3tcJ5Zu8oQYR82/df4Vuvkms43biDeAi9r1NAps1oqoSUFlPDwj0l71h
         i4ITNNi1GiY8mZUNR/WoAHqha/MCuHSMDLOH97ls5WgDu5oX8akTKdB9+7jdFyELlLoi
         fAfQz00AefnRlkK0wsRlUfsloq8iNvOpaOd8AKApMetIeEREpCre9WujsSOZjUN2+KgF
         AHkw==
X-Gm-Message-State: ANoB5pkRGU+aBbt3F4Kbj6uvr7h+yc17wtD/0bTCeKaDk7al8RJSUtLd
        bz3fQFoyn1fMyZPwWkIfFOIhXCcXbYYTHbtLzokFwg==
X-Google-Smtp-Source: AA0mqf7O8EbcvIICZ1wvQGc+043V699dQjAI5kcIWFwcnnz8xO6pyIeOkAjptekQTY4kbR+JxJK0Sn0fRqK2gq7enKk=
X-Received: by 2002:a05:6808:1115:b0:359:cb71:328b with SMTP id
 e21-20020a056808111500b00359cb71328bmr11136834oih.282.1669122493010; Tue, 22
 Nov 2022 05:08:13 -0800 (PST)
MIME-Version: 1.0
References: <000000000000cceef005ed659943@google.com> <000000000000b63a2805ed90289d@google.com>
In-Reply-To: <000000000000b63a2805ed90289d@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 22 Nov 2022 14:08:02 +0100
Message-ID: <CACT4Y+bbU1_NFP995Gd2btvwUZdNe0t7kw+vzzuXvqFTDm5seA@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in virtual_nci_close
To:     syzbot <syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com>
Cc:     bongsu.jeon@samsung.com, clement.perrochaud@nxp.com,
        davem@davemloft.net, hdanton@sina.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, michael.thalmeier@hale.at,
        netdev@vger.kernel.org, r.baldyga@samsung.com,
        robert.dolca@intel.com, sameo@linux.intel.com, shikha.singh@st.com,
        syzkaller-bugs@googlegroups.com, thierry.escande@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 at 06:58, syzbot
<syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this issue to:
>
> commit e624e6c3e777fb3dfed036b9da4d433aee3608a5
> Author: Bongsu Jeon <bongsu.jeon@samsung.com>
> Date:   Wed Jan 27 13:08:28 2021 +0000
>
>     nfc: Add a virtual nci device driver
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1093fb59880000
> start commit:   094226ad94f4 Linux 6.1-rc5
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1293fb59880000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1493fb59880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7d516a992a8757b5
> dashboard link: https://syzkaller.appspot.com/bug?extid=8040d16d30c215f821de
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1360e2f1880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a95659880000
>
> Reported-by: syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com
> Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

#syz fix: NFC: nci: Allow to create multiple virtual nci devices
