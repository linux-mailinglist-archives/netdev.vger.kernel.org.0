Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35FE595753
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiHPJ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiHPJ63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:58:29 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CC46F549
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:53:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660639964; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=bBQz/4sKlLICMgbpZQBlxJ4ZpV0UELPxP+kG+s5aNdRnBGGP9HtWC9K9JhNTK9oLNFz1jm90QSEdgyAQ2LytI1A9fxxlVx2F3lEdMFKLNfH3MA7PrhxZUfsnc+4MTQ0kgFWZfGne2OrxkXB5+bGb9rjJCx3J+q7Qbt3zD3jy+jc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660639964; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=IgzfXa929JbnTFKwJvpgWOiZxryBGnSfK2GVAMJkbgM=; 
        b=SsLnPMgAdLBZpaqQ/+3uq9JDYYt2oWd8IntLdbjH2KARzzzFEIBBfJqtlKoPWVedKUt14CNfJYstPAjElUZdBADOPRUVVIDfOS6ossUGgylV+FXSkDKrtJmfPYyvEFo06Rz14OrDS8Bo6orK/UwHsRMBKUrXfFZo/xAbH6BnYfE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660639964;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=IgzfXa929JbnTFKwJvpgWOiZxryBGnSfK2GVAMJkbgM=;
        b=mDbyrzOEt6NsXcLWJhF+qdtYrjYSAkd49rJVKuRmwiSyj7WppdcYL0Nj0FGaW2om
        5QSg2dhJKksD4u9xNqiNWwHuOkQ96QkJ3Dk3TM+wHocGz+x4xfMnTq152AlCi/YDZ8W
        SUbyEgiXFx0HvNf9Uy2cxIM3UMeVyj0GrPa4ZbVg=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660639952099625.7238247365526; Tue, 16 Aug 2022 14:22:32 +0530 (IST)
Date:   Tue, 16 Aug 2022 14:22:32 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Johannes Berg" <johannes@sipsolutions.net>
Cc:     "jakub kicinski" <kuba@kernel.org>,
        "greg kh" <gregkh@linuxfoundation.org>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "paolo abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <182a5dabcc5.36efd4946461.1649818863091410857@siddh.me>
In-Reply-To: <18fd9b89d45aedc1504d0cbd299ffb289ae96438.camel@sipsolutions.net>
References: <20220726123921.29664-1-code@siddh.me>
         <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
         <YvZEfnjGIpH6XjsD@kroah.com>
         <18292791718.88f48d22175003.6675210189148271554@siddh.me>
         <YvZxfpY4JUqvsOG5@kroah.com>
         <18292e1dcd8.2359a549180213.8185874405406307019@siddh.me>
         <20220812122509.281f0536@kernel.org>
         <182980137c6.5665bf61226802.3084448395277966678@siddh.me>
         <20220815094722.3c275087@kernel.org> <18fd9b89d45aedc1504d0cbd299ffb289ae96438.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
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

On Tue, 16 Aug 2022 01:28:24 +0530  Johannes Berg  wrote:
> Sorry everyone, I always thought "this looks odd" and then never got
> around to taking a closer look.
> 
> So yeah, I still think this looks odd - cfg80211 doesn't really know
> anything about how mac80211 might be doing something with RCU to protect
> the pointer.
> 
> The patch also leaves the NULL-ing in mac80211 (that is how we reach it)
> broken wrt. the kfree_rcu() since it doesn't happen _before_, and the
> pointer in rdev isn't how this is reached through RCU (it's not even
> __rcu annotated).
> 

Thanks for the critical review.

> I think it might be conceptually better, though not faster, to do
> something like https://p.sipsolutions.net/1d23837f455dc4c2.txt which
> ensures that from mac80211's POV it can no longer be reached before we
> call cfg80211_scan_done().
> 
> Yeah, that's slower, but scanning is still a relatively infrequent (and
> slow anyway) operation, and this way we can stick to "this is not used
> once you call cfg80211_scan_done()" which just makes much more sense?
> 
> johannes
> 

Agreed, that looks like a good way to go about.

Thanks,
Siddh
