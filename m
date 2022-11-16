Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCA962B306
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 06:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiKPF6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 00:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKPF6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 00:58:19 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A39E2229D
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:58:18 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id bx19-20020a056602419300b006bcbf3b91fdso8264167iob.13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 21:58:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YWvo2jzqIvuQGsdWFUrnJDvcO8++2ictjA/IpetI45E=;
        b=Ci6Kbxg+ZaP8TDiu1/xbTC4FDRcQ4tHC9h7Pl9UVAnFmSQh3XZorz9PJOqkLwoSNOS
         Ojoiqr+J0GH7SV6J9y8yWQJJeBmXY8tFy6HqhYCi9jcOKNfQKiaXTKqu4ivR6uzwLa4Z
         ghdHtMZCvQj7gbovIJ6f08WjtUODPlCaKhyuNqShU5YtmbLe708ijKAvFyTU5dQ7FXoh
         bAocjM7Ipemovg7m5eZHYuFRpIL1OYhkyi/xvnRLf9W6DHleMchBspKVxU4U9VnbJWxj
         JLKf6Xn7SOulFtFGPXXsEV/qDyRLVTic3DimH8azsh+HQmenrmv2mc/yQ5whApxOIDNU
         wJ5w==
X-Gm-Message-State: ANoB5pmgyn2kHRIaM9N0wn0sLMgqLXPQN6AhAeT7WWEGzDOn9HKDPIJt
        RljpxJ1nZbdspbyXtHnXaDFGpYs7g6+L3Ybu+/C+QReDzMBv
X-Google-Smtp-Source: AA0mqf4eQ+jC+4kQp1fyoHwTeHCiA+2rGPTxKMj9hH+QL4+iJxL3kVD4fiZufqI/RC4CBO/Wqdo1BP9YRy3HaayfCg5kppIlBpH+
MIME-Version: 1.0
X-Received: by 2002:a02:3408:0:b0:373:d769:bc14 with SMTP id
 x8-20020a023408000000b00373d769bc14mr10172237jae.264.1668578297655; Tue, 15
 Nov 2022 21:58:17 -0800 (PST)
Date:   Tue, 15 Nov 2022 21:58:17 -0800
In-Reply-To: <000000000000cceef005ed659943@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b63a2805ed90289d@google.com>
Subject: Re: [syzbot] possible deadlock in virtual_nci_close
From:   syzbot <syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com>
To:     bongsu.jeon@samsung.com, clement.perrochaud@nxp.com,
        davem@davemloft.net, dvyukov@google.com, hdanton@sina.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, michael.thalmeier@hale.at,
        netdev@vger.kernel.org, r.baldyga@samsung.com,
        robert.dolca@intel.com, sameo@linux.intel.com, shikha.singh@st.com,
        syzkaller-bugs@googlegroups.com, thierry.escande@linux.intel.com
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

commit e624e6c3e777fb3dfed036b9da4d433aee3608a5
Author: Bongsu Jeon <bongsu.jeon@samsung.com>
Date:   Wed Jan 27 13:08:28 2021 +0000

    nfc: Add a virtual nci device driver

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1093fb59880000
start commit:   094226ad94f4 Linux 6.1-rc5
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1293fb59880000
console output: https://syzkaller.appspot.com/x/log.txt?x=1493fb59880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7d516a992a8757b5
dashboard link: https://syzkaller.appspot.com/bug?extid=8040d16d30c215f821de
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1360e2f1880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a95659880000

Reported-by: syzbot+8040d16d30c215f821de@syzkaller.appspotmail.com
Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
