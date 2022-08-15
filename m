Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC701592A56
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiHOHZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 03:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiHOHZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 03:25:28 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D326140;
        Mon, 15 Aug 2022 00:25:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660548287; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=VRmmUHogCbfEV/Z47CYgjlmBymsGM0W+eG+hMXeZrxfmQ7WHdDChY/cSLTQHeZ1Bg+9JpYS2v0BOky/TwnpSKklKxNAkeSLySLFQ72eOR8HSa5fwV26GN65RWzWZhg2byMGAUsd42tU0QmaT48Syt2+xakgns4Su6XRUHrddW3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660548287; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=rFmN3Fcn03jyf5Yrgmq83ESGhPMfT3i8FmCTj6/USo8=; 
        b=Hysf8rXPv/lic1u7ZDbKAkqAKr2sbyld0Bsjyfd6x02S5zpPOD2WWdz4Sz+OYjSCr/UIjixYmaNHnnp5hLAme9na/S/+6TOneunqpaonoaR143LRe7stk6qzAiCm5yU93ZlH+U1nmY6VVZN0hvcsH0WVYYDfETAPCpVP5mVeAWI=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660548287;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=rFmN3Fcn03jyf5Yrgmq83ESGhPMfT3i8FmCTj6/USo8=;
        b=EMEpgejqJTujORMBx5/tvo5dKhYkjBqVfkGyDFM0EAjgPenELLPUSXOk7tD1SC3s
        q2r4Uu0l+gUkql+ClhNXkzNNcFu1Jm+h7Lp/5kohAX8/cgPsdSEzEXtSFqTe0CAl4IZ
        WKNyC/0L4tVZ3tRySIeH/BnlIgWBtViFT2VBb8BA=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660548274922861.5813875926336; Mon, 15 Aug 2022 12:54:34 +0530 (IST)
Date:   Mon, 15 Aug 2022 12:54:34 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "johannes berg" <johannes@sipsolutions.net>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "jakub kicinski" <kuba@kernel.org>,
        "paolo abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "stable" <stable@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "syzbot+b6c9fe29aefe68e4ad34" 
        <syzbot+b6c9fe29aefe68e4ad34@syzkaller.appspotmail.com>
Message-ID: <182a063dacf.3f3632f6236592.5537187165122273734@siddh.me>
In-Reply-To: <Yvnu/WT1Z+K36UwW@kroah.com>
References: <20220814151512.9985-1-code@siddh.me> <Yvnu/WT1Z+K36UwW@kroah.com>
Subject: Re: [PATCH] wifi: mac80211: Don't finalize CSA in IBSS mode if
 state is disconnected
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 12:30:13 +0530  Greg KH  wrote:
> Please no blank line before your signed-off-by line or the tools will
> not like it.

Oh okay, noted.

> And did sysbot verify that this change solved the problem?

Syzbot was failing to boot for reasons unrelated to the patch.
I tried testing three times, and every time the boot was failing.
It was taking more than 5 hours for syzbot to pick up the patch
from pending state every time, so I now posted it.

You can look at the syzkaller group page here:
https://groups.google.com/g/syzkaller-bugs/c/bGZwWS4Q3ek/m/dQ3pdAVSAAAJ
(Pardon the atrocious HTML email at the end, I used a mobile app
to email and forgot it doesn't send in plaintext.)

I have locally tested this with the reproducer syzbot gave.

Thanks,
Siddh
