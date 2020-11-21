Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39FB2BBF4F
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 14:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgKUNhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 08:37:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgKUNhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 08:37:09 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACE4C0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 05:37:07 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id x17so11392913ybr.8
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 05:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hW+tDMcroBnYjVio+hhjus4Lc01NoQdNAIz2e/PH8bE=;
        b=HnhelNFUSiMq00wIF6Xs+BuzF9tAL4Hyqx6FmE2Qs2nKx0ekYAvWDJRQBOECqce2p9
         jFygS0EBt0dgqjVB5MGie63Wk28z3ohWHO9jAEH6pw1QNEFIuSnqQPwGPkGtzDOZE+CO
         Ukh0G2BlgtNnU4E9xw92CffuxZijak+3MGRRCeg5z5/9qHsxpVeMa/zF7MP1yRUd4dHt
         trTCUqRbhv8p0jcloO4k2rJtSSPd//QQwzLppkkgRSvGZhFbJjTcyiQ9PgT27WzNe5mJ
         RqKRBUNq4N2Puy6HV6sqTRscgPBMRCg17BZn/z2sz91Rp0AVNWUB3e4R8Ym8M2x7sGM2
         +Utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hW+tDMcroBnYjVio+hhjus4Lc01NoQdNAIz2e/PH8bE=;
        b=a2mFQxT+EqLohIcX8dk8ojKilUfsC4WSWvCGgmgRfvutPCLfX5SG19LBk0VlgiypIW
         2L//KrCSRPejU/GLTkMw9Vbh9zbwoM8NyQpYOlT5Hddh28DThU3zrDEig6Pbz8wr/ddr
         CeRe9kpXBj04RhZFZdRuP3myzIRx5AmayQQjAg1xXHtV6U4wabPlMw1KXcWI9teXL2u+
         mpQbH3wCK5HnF7Kfo/kiMt8OJXMMwWcU6p+Mz07qhuEk/xvB4ZncNDQECqoYuWzpc1+u
         xq544b+0d5NKRGrAePZ6RAQmYslUQTXXfAOVIp/tZQLH1Jn7MrbVH773+i1J5sjR8eoI
         6UcQ==
X-Gm-Message-State: AOAM531Z+FCrqDbRCXchYTZtIXiuCr46nHpTsbQVhAavm7GWNhHasvRc
        iyzNS96Z/eAdR4lbdT4Mr3cMpfp7fw1K0s/PUldqM0JJCHc=
X-Google-Smtp-Source: ABdhPJxfACPVKowP0RxW20RtWN1Wr03kpFpJwW/uY9rSRwZRn/CkpnG73HYr7SIckCgVF+ejRKFE6K7av9FinNi3uTk=
X-Received: by 2002:a25:d90:: with SMTP id 138mr24173938ybn.179.1605965826485;
 Sat, 21 Nov 2020 05:37:06 -0800 (PST)
MIME-Version: 1.0
From:   James Courtier-Dutton <james.dutton@gmail.com>
Date:   Sat, 21 Nov 2020 13:36:30 +0000
Message-ID: <CAAMvbhFQ_70+OcqofakqrO52PTDy-+401cQ3vYfCT0o_j6yKFA@mail.gmail.com>
Subject: SO_REUSEADDR compatibility problems
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The use case I am struggling with is the use of a Windows program
running in wine that is sending and receiving UDP packets.
This particular windows program uses SO_REUSEADDR socket option and
opens two sockets. Lets call the first one socket A, and the second
one Socket B.

The SO_REUSEADDR from the Windows application is translated by "wine" into a
SO_REUSEADDR in Linux.
Unfortunately the behaviour of these is different between Windows and
Linux so the Windows application fails to run on Linux under wine.
1 ) On windows:
All received unicast UDP packets will arrive on the first opened
socket. Thus on socket A.
2) On Linux:
All received unicast UDP packets will arrive on the last opened
socket. Thus on socket B.

The problem is that this windows program only expects to receive
unicast UDP packets on socket A, and thus it sees no packets.

There are no currently existing socket options in Linux that would
permit wine to simulate the Windows behaviour.
And thus, the reason I am asking the question here.
Please can we add an extra socket option to the Linux socket options
such that we can get wine to simulate Windows correctly. I.e. behave
like (1) above.
Now wine is pretty good at simulating most things Windows throws at
it, but socket options is not one of them yet.
Also note, that (1) is actually more secure than (2) because it
prevents other applications with the same UserID from hijacking the
socket.
Although (2) is more helpful in more gracefully handling some error edge cases.

Suggested new option name:  SO_REUSEADDR_WS

Kind Regards

James
