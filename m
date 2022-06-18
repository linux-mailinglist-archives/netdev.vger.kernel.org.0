Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BC355044A
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 13:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiFRLtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 07:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiFRLsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 07:48:31 -0400
X-Greylist: delayed 437 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 18 Jun 2022 04:48:30 PDT
Received: from relay05.pair.com (relay05.pair.com [216.92.24.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0E31C135;
        Sat, 18 Jun 2022 04:48:30 -0700 (PDT)
Received: from orac.inputplus.co.uk (unknown [84.51.159.244])
        by relay05.pair.com (Postfix) with ESMTP id 84EB51A2879;
        Sat, 18 Jun 2022 07:41:12 -0400 (EDT)
Received: from orac.inputplus.co.uk (orac.inputplus.co.uk [IPv6:::1])
        by orac.inputplus.co.uk (Postfix) with ESMTP id 61EC71F981;
        Sat, 18 Jun 2022 12:41:11 +0100 (BST)
To:     Nate Karstens <nate.karstens@garmin.com>
cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] Implement close-on-fork
From:   Ralph Corderoy <ralph@inputplus.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
In-reply-to: <20200515152321.9280-1-nate.karstens@garmin.com>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
Date:   Sat, 18 Jun 2022 12:41:11 +0100
Message-Id: <20220618114111.61EC71F981@orac.inputplus.co.uk>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nate,

> One manifestation of this is a race conditions in system(), which
> (depending on the implementation) is non-atomic in that it first calls
> a fork() and then an exec().

The need for O_CLOFORK might be made more clear by looking at a
long-standing Go issue, i.e. unrelated to system(3), which was started
in 2017 by Russ Cox when he summed up the current race-condition
behaviour of trying to execve(2) a newly created file:
https://github.com/golang/go/issues/22315.  I raised it on linux-kernel
in 2017, https://marc.info/?l=linux-kernel&m=150834137201488, and linked
to a proposed patch from 2011, ‘[PATCH] fs: add FD_CLOFORK and
O_CLOFORK’ by Changli Gao.  As I said, long-standing.

The Go issue is worth a read.  Russ wondered ‘What would Java do’ only
to find that Java already had an issue open for the same problem since
2014.

I think the kernel is the place to fix the problem, just as with
FD_CLOEXEC/O_CLOEXEC.  Ian Lance Taylor says on the Go issue that it
looks like ‘Solaris and macOS and OpenBSD have O_CLOFORK already.
Hopefully it will catch on further’.

-- 
Cheers, Ralph.
