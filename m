Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B7862EB61
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 02:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240226AbiKRB4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 20:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234802AbiKRB4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 20:56:22 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AC1742CC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:56:20 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id w27-20020a05660205db00b006dbce8dc263so1897939iox.16
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 17:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pvNabL4h/jw3vWWl8UrKWU7ECeSF3aiv4l/7+Kwbb8=;
        b=vNs52V9wxopFgZf7pKED+SepkgnLVdyAif4zRultCiPvrzo48L4sWw+1mUpf/8Qllg
         YA/1jtRv/eYP/H78UhzJkuK5e5bG545832GwgLKSQ+kT2vmGlRLvrKW1qKYt6X0iZQzF
         7JjcvAHEuXfW+QVMyGjAPbcD3usdAXd3L8g2gg+/gK4zevRkZKXnM4Dr4JHUC99c709h
         PwHjm43mi17lUh6fyR2cMszQQL6oAy2Sn68LmqDPvh0zzPw54mmldCaLtDhi1vBOyTKr
         0iRvzQZcBQ776Wy1EeyZ/M0lEvhsPjrgzMwsiBC9GbzRNO8diawbz2kSeyaRPQ5kxTht
         uwGA==
X-Gm-Message-State: ANoB5plvYs0IGZd2uNv3Es6zdQJ82eQuqqVWp4QiDvWwTri3xRnl1RDc
        o4c4dDV3mFO/oxvJIqIn9t5sRmUMx7YMr7/ok4x2oHpcYJyA
X-Google-Smtp-Source: AA0mqf45hbckZ2aQOX7ek+n7IrRm+TLARFS5k7Cpgc/J3eoK5JGyghNN8Zz2xGtvDMZWQ5eFrzyaERPuVNbmpR8na1Tlmn82UWtD
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3e15:b0:374:53a:a5bf with SMTP id
 co21-20020a0566383e1500b00374053aa5bfmr2275103jab.77.1668736579920; Thu, 17
 Nov 2022 17:56:19 -0800 (PST)
Date:   Thu, 17 Nov 2022 17:56:19 -0800
In-Reply-To: <0000000000004e78ec05eda79749@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011ec5105edb50386@google.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in static_key_slow_inc
From:   syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        frederic@kernel.org, gnault@redhat.com, jacob.e.keller@intel.com,
        jakub@cloudflare.com, jiri@nvidia.com, johannes@sipsolutions.net,
        juri.lelli@redhat.com, kirill.shutemov@linux.intel.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com, pabeni@redhat.com, paul@paul-moore.com,
        peterz@infradead.org, razor@blackwall.org,
        sathyanarayanan.kuppuswamy@linux.intel.com, steven.price@arm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        tparkin@katalix.com
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

commit b68777d54fac21fc833ec26ea1a2a84f975ab035
Author: Jakub Sitnicki <jakub@cloudflare.com>
Date:   Mon Nov 14 19:16:19 2022 +0000

    l2tp: Serialize access to sk_user_data with sk_callback_lock

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1600bb49880000
start commit:   064bc7312bd0 netdevsim: Fix memory leak of nsim_dev->fa_co..
git tree:       net
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1500bb49880000
console output: https://syzkaller.appspot.com/x/log.txt?x=1100bb49880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a33ac7bbc22a8c35
dashboard link: https://syzkaller.appspot.com/bug?extid=703d9e154b3b58277261
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cd2f79880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109e1695880000

Reported-by: syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com
Fixes: b68777d54fac ("l2tp: Serialize access to sk_user_data with sk_callback_lock")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
