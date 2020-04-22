Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162371B475B
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgDVOdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:33:01 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57460 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725935AbgDVOdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 10:33:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 659B38EE19C;
        Wed, 22 Apr 2020 07:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587565978;
        bh=M6gdDcbuW+flffcj7MyeO+/4m9VT7LtFOrK/yRp2scQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WrO5XdhMaAlNqj3XroFFwRez3dqb7oiOPLPHX+STuA7bKkQXrqzCXeilgs2vj62a8
         dtN7T5MWew9GQ5rEfY3QG2jfw0MOZBCAFJlqWm5balqonOlZMl8LgK+o1HHZ9yL/RJ
         P7q+a4hsvlPez4qWuCoGEOS2WFTgBuelCsScuJJc=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ne34ZMO5wtea; Wed, 22 Apr 2020 07:32:58 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id CC09D8EE0CE;
        Wed, 22 Apr 2020 07:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587565977;
        bh=M6gdDcbuW+flffcj7MyeO+/4m9VT7LtFOrK/yRp2scQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aAZ5k2GjVbhrgCgDYq1cHevIi1wz2C1YDR0Di2NdAIIxxOPJgzetvPaxqQm67/dYG
         86owFnqs87t+/+AP5VxJwVX3igQ/oLPNgJMsTtVpgYHpb3YGP/du4FoU7UbDGe5Pio
         X+J541MSFakK8AyKXdxMyDl6K4CCsOgkMu6rgb3k=
Message-ID: <1587565975.3485.5.camel@HansenPartnership.com>
Subject: Re: Implement close-on-fork
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Changli Gao <xiaosuo@gmail.com>
Date:   Wed, 22 Apr 2020 07:32:55 -0700
In-Reply-To: <20200420071548.62112-1-nate.karstens@garmin.com>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-20 at 02:15 -0500, Nate Karstens wrote:
> Series of 4 patches to implement close-on-fork. Tests have been
> published to https://github.com/nkarstens/ltp/tree/close-on-fork.
> 
> close-on-fork addresses race conditions in system(), which
> (depending on the implementation) is non-atomic in that it
> first calls a fork() and then an exec().

Why is this a problem?  I get that there's a time between fork and exec
when you have open file descriptors, but they should still be running
in the binary context of the programme that called fork, i.e. under
your control.  The security problems don't seem to occur until you exec
some random binary, which close on exec covers.  So what problem would
close on fork fix?

> This functionality was approved by the Austin Common Standards
> Revision Group for inclusion in the next revision of the POSIX
> standard (see issue 1318 in the Austin Group Defect Tracker).

URL?  Does this standard give a reason why the functionality might be
useful.

James

