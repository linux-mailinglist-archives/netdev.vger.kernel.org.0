Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC521E32DA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392017AbgEZWqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:46:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389755AbgEZWqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:46:10 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FDBB206D5;
        Tue, 26 May 2020 22:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590533169;
        bh=4VoXxRVTE3aUe4DriyuaiIDULO39iyZazGY56WATyv0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cb0Eibk505H8ZxcbbJZVkrpORxeYQZmf0ZrrYrbipHCaqg7YlUb/TTqp3zb7BDBWx
         Vi3vWmeo/d8/1jYP09Qb9Qnrw7t31w6GKTFZQHx5ws1SHsoWDVhXP6qbMItUDJmsKI
         RQx1zpkIVOc62sRLCh+zvSjnS0HpLl+lGyK1HzSg=
Date:   Tue, 26 May 2020 15:46:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, davem@davemloft.net, michael.chan@broadcom.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
Message-ID: <20200526154606.6a2be01f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200526145815.6415-1-mcgrof@kernel.org>
References: <20200526145815.6415-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 14:58:07 +0000 Luis Chamberlain wrote:
> To those new on CC -- this is intended to be a simple generic interface
> to the kernel to annotate when the firwmare has crashed leaving the
> driver or system in a questionable state, in the worst case requiring
> full system reboot. This series is first addressing only a few
> networking patches, however, I already have an idea of where such
> firmware crashes happen across the tree. The goal with this series then
> is to first introduce the simple framework, and only if that moves
> forward will I continue to chug on with the rest of the drivers /
> subsystems.
> 
> This is *not* a networking specific problem only.
> 
> This v3 augments the last series by introducing the uevent for panic
> events, one of them is during tainting. The uvent mechanism is
> independent from any of this firmware taint mechanism. I've also
> addressed Jessica Yu's feedback. Given I've extended the patches a bit
> with other minor cleanup which checkpatch.pl complains over, and since
> this infrastructure is still being discussed, I've trimmed the patch
> series size to only cover drivers for which I've received an Acked-by
> from the respective driver maintainer, or where we have bug reports to
> support such dire situations on the driver such as ath10k.
> 
> During the last v2 it was discussed that we should instead use devlink
> for this work, however the initial RFC patches produced by Jakub
> Kicinski [0] shows how devlink is networking specific, and the intent
> behind this series is to produce simple helpers which can be used by *any*
> device driver, for any subsystem, not just networking. Subsystem
> specific infrastructure to help address firwmare crashes may still make
> sense, however that does not mean we *don't* need something even more
> generic regardless of the subsystem the issue happens on. Since uevents
> for taints are exposed, we now expose these through uapi as well, and
> that was something which eventually had to happen given that the current
> scheme of relying on sensible character representations for each taint
> will not scale beyond the alphabet.

Nacked-by: Jakub Kicinski <kuba@kernel.org>
