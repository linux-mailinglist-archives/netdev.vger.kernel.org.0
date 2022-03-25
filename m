Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15E4E72BA
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 13:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358417AbiCYMIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 08:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358984AbiCYMIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 08:08:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399A5D4C9B;
        Fri, 25 Mar 2022 05:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=fP/8PQ4xnA23zU/Y+mSJsOAiECeSmsobNh7IzRsv2+I=;
        t=1648209999; x=1649419599; b=u5KBK0LyqOXDV66G1HOp/l3f24t1TItYCTHqohUjh4ZgyzE
        3BJCPFkoDxTY8dNfYl/Ig/v0ifVdnM9p5qcq0GzwKdTpApbIh8hpUWMVxsOwIRjZZpFI5BMtP+MuY
        kMb8q3cnGuZhdWAMLd2hRSW9gDWF6W4WyVrCWSYhLhRCJsWNX98/6+rw/7hc9HsH1LmU/wqDL4fpI
        29c4trnay7SdxY8jTKsyaUuT1v1lFYZlQfUv4xx3743ftbKUtWup53u5IH8sFprl0SB2zkbSwRJ3m
        mlBmDQYavZ0EI0aVmYZ74pqWBCQ3AOwMAIUpQYMRztDNAs3NC2yBdDbArA9+ZV4w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXii6-000JlI-1F;
        Fri, 25 Mar 2022 13:06:30 +0100
Message-ID: <ae0180ae4e73bb32d8f20662b6d9d6a3ead52b95.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 25 Mar 2022 13:06:28 +0100
In-Reply-To: <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
References: <0000000000009e9b7105da6d1779@google.com>
         <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
         <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
         <YjpGlRvcg72zNo8s@google.com>
         <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
         <Yjzpo3TfZxtKPMAG@google.com>
         <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-25 at 13:04 +0100, Johannes Berg wrote:
> 
> So we can avoid the potential deadlock in cfg80211 in a few ways:
> 
>  1) export rtnl_lock_unregistering_all() or maybe a variant after
>     refactoring the two versions, to allow cfg80211 to use it, that way
>     netdev_run_todo() can never have a non-empty todo list
> 
>  2) export __rtnl_unlock() so cfg80211 can avoid running
>     netdev_run_todo() in the unlock, personally I like this less because
>     it might encourage random drivers to use it
> 
>  3) completely rework cfg80211's locking, adding a separate mutex for
>     the wiphy list so we don't need to acquire the RTNL at all here
>     (unless the ops need it, but there's no issue if we don't drop it),
>     something like https://p.sipsolutions.net/27d08e1f5881a793.txt
> 

Note that none of these actually let you do what you wanted - that is
acquiring the RTNL in the vendor op itself.

johannes
