Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9354E7B81
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbiCYVvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiCYVvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:51:46 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7DA15AAF8;
        Fri, 25 Mar 2022 14:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=60OMP8UDGCo2v151LkV47kmUGiZyavD4SmhjdQ5wwUk=;
        t=1648245011; x=1649454611; b=wYVrZW7EwtB7mSEvSZ48TSGqoD9G9nav/Xj/aVH2Ib2yAce
        RX3J3RP/52Q90qv9LiY0KlobTo7jU2A3uKwLgY7YVBfMKk67kDCdAlRb1ongtxJB3dTI34es2MB4q
        T+/x5KQUFAPox6K1T7gOFW8Ubd0U8p5ucJU9HS3z1b2XqWGjwtVl79gq1D8nscdcPrcnCUw3WnAyV
        Qy0a+pjITCur8Q6jWf9Jul+EiOUsWRX22l//PcxSYTlVhTP7AHHYy/KQdKgr5ZhJirry2OaFXr/+j
        xAtAUCZ+3Ie0J83VsU9ZXluK8GIvzQ/G2OgqBOOQtb2Qu8Ovb0G0iNzHbQnIqjiA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrop-000WYJ-N0;
        Fri, 25 Mar 2022 22:50:03 +0100
Message-ID: <b01ce2cb79ca3a22a9ca54e481d4a6b0420afff2.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date:   Fri, 25 Mar 2022 22:50:02 +0100
In-Reply-To: <20220325144839.7110fc8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <0000000000009e9b7105da6d1779@google.com>
         <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
         <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
         <YjpGlRvcg72zNo8s@google.com>
         <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
         <Yjzpo3TfZxtKPMAG@google.com>
         <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
         <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
         <20220325134040.0d98835b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <46b8555d4cded50bc5573fd9b7dd444021317a6b.camel@sipsolutions.net>
         <20220325144839.7110fc8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Fri, 2022-03-25 at 14:48 -0700, Jakub Kicinski wrote:
> > 
> > > The WARN_ON() you suggested up front make perfect sense to me.
> > > You can also take the definition of net_unlink_todo() out of
> > > netdevice.h while at it because o_0  
> > 
> > Heh indeed, what?
> 
> To be clear - I just meant that it's declaring a static variable in 
> a header, so I doubt that it'll do the right thing unless it's only
> called from one compilation unit.

Right, it's odd. I just made a patch (will send in a minute) moving the
entire block to dev.c, which is the only user of any of it.

> > Ah, no. This isn't about locking in this case, it's literally about
> > ensuring that free_netdev() has been called in netdev_run_todo()?
> 
> Yup, multiple contexts sitting independently in netdev_run_todo() and
> chewing on netdevs is slightly different. destructors of those netdevs
> could be pointing at memory of a module being unloaded.

Right, thanks.

johannes
