Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54044E7DEC
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiCYUXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCYUXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:23:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1480C5DA69;
        Fri, 25 Mar 2022 13:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=b5wJQQ7YqCa3aFhJqIL39US+IJSbvv4VXqtaGEmA6ik=;
        t=1648239685; x=1649449285; b=CXFnQ8EcqIPxkIZDl6uyj8xPm1TCgANxFC5vmJMRmEWlEim
        zD7Mp0BhY9R79BpE9noxVMnq12N/vFVsqQXQqll877EK9buQnWPJg4I+qkO8n/wRxkBcUt29e+ttQ
        DOpMvboK5z2JSvdTqjAcEgrjJ21naFa75Y8Yg+162bhOhHlmW1/YTFtV1JrjWKiqx5Q8pEL9xXZKz
        HzofRBD+2TlvuyhuTXK5EQiTbqPXh7YAzcgA9RrsngnWvAb/S1HTx4YQngVHNQFGQkmIR5ZgmcBS9
        Crpq8b79thPjsJEOS8DGPiEqqdxNubU1eyVgR7XfILisUl3W6I0jISQzm1yyGpvw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXqQq-000UKo-TY;
        Fri, 25 Mar 2022 21:21:12 +0100
Message-ID: <ae6ebb34ba100fa8e17cc7eb187b7cfdf7a20a56.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     William McVicker <willmcvicker@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 25 Mar 2022 21:21:11 +0100
In-Reply-To: <Yj4FFIXi//ivQC3X@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
         <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
         <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
         <YjpGlRvcg72zNo8s@google.com>
         <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
         <Yjzpo3TfZxtKPMAG@google.com>
         <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
         <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
         <Yj4FFIXi//ivQC3X@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-25 at 18:08 +0000, William McVicker wrote:
> 
> I'm able to reproduce this issue pretty easily with a Pixel 6 when I add
> support to allow vendor commands to request for the RTNL. 
> 

Hm, wait, which of the two issues?

> For this case, I just
> delay unlocking the RTNL until nl80211_vendor_cmds() at which point I check the
> flags to see if I should unlock before calling doit(). That allows me to run my
> tests again and hit this issue. I imagine that I could hit this issue without
> any changes if I re-work my vendor ops to not need the RTNL.

What are the vendor ops doing though?

If they're actually unregistering a netdev - which I believe you
mentioned earlier - then that's quite clearly going to cause an issue,
if you unlock RTNL while the wiphy mutex is still held.

If not, then I don't see right now how you'd be able to trigger any
issue here at all.

The original issue - that you rtnl_lock() yourself while the wiphy mutex
is held - can't happen anymore with your rework I guess.


johannes
