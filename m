Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDE81A792C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 13:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390821AbgDNLM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 07:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728734AbgDNLMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 07:12:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A42C061A0C;
        Tue, 14 Apr 2020 04:12:17 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jOIxX-00Gpsu-6e; Tue, 14 Apr 2020 12:38:27 +0200
Message-ID: <ed2b00dfda5b6ce46a2c2a33093ee56f77af6a8f.camel@sipsolutions.net>
Subject: Re: WARNING in hwsim_new_radio_nl
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com>,
        davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Date:   Tue, 14 Apr 2020 12:38:22 +0200
In-Reply-To: <000000000000cb517b05a32c917b@google.com> (sfid-20200413_160506_506947_12BA215F)
References: <000000000000cb517b05a32c917b@google.com>
         (sfid-20200413_160506_506947_12BA215F)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi syzbot keepers,

On Mon, 2020-04-13 at 07:05 -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit 01cacb00b35cb62b139f07d5f84bcf0eeda8eff6
> Author: Paolo Abeni <pabeni@redhat.com>
> Date:   Fri Mar 27 21:48:51 2020 +0000
> 
>     mptcp: add netlink-based PM
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10225bb3e00000

This is, fairly obviously, incorrect. Same with the bisection for
6693adf1698864d21734, which is really the same underlying problem as
this one (though at a different code site).

However, it stands out that this was bisected to a commit that adds a
new generic netlink family in both cases.

This makes sense - the reproducer identifies the family by *number*, but
that number isn't stable, generic netlink families should be identified
by *name*.

Perhaps somehow syzbot could be taught that, so that the bisection is
stable across kernels with different generic netlink families
registered?

Alternatively, we _could_ add some kind of stable ID mode, but I'm not
sure we really want to ... since that would mean people start hardcoding
IDs?

johannes

