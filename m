Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F0C56A1B5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 14:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiGGMAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbiGGMAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 08:00:30 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50855564D2;
        Thu,  7 Jul 2022 05:00:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1657195193; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=UXI3yFQQYQvAHbcwU47b2aV4XPVAOEmMMlZDYyLASHbsDrCE5eX9BYx9CQLwZCa1w5FA55qJKDendi/Q1QzoIsDk2PuqtHlEZmvuX15YaXhoRVo97G2MgOStTUrI7wn/c3EQ+EtMmbdQc6OnDDers1RSnKW3aSUskKZce1MMBpQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1657195193; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9oIIAaHxLVDhvrlkTzyijBA4VZ4czewxEi1HFtBUOug=; 
        b=Zo2xUH1iOtOefPSmYk0R9mLo7SNeXJoY3enHcHi/BfaabMulQlKyM4FPaTs8k9HA//uucsMzonvLgm2V0vfylypzJJqFWa8jr5R+elmh4eL6f6OZnV1PEG8Kp4PZ9jd4L1ItoFp82qGOCH1qsVM3QiI5FxTAOmpS+g+dUqEaryQ=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1657195193;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9oIIAaHxLVDhvrlkTzyijBA4VZ4czewxEi1HFtBUOug=;
        b=hwnc2GD2S72yhNd+NMB/+XXsMH1iMdOo2ao2ky7s4lHQaSwHhwhBx8lfrARdu7Wa
        RvrhAU86lvXXIJ8e7JjhdYC1E9m7Garllc9b8Nad20DVzzYPHSGHkEcTtfaKdTF0mHm
        LeBDy5Jx95cQxV4OJKMpj5jFumgmc1e6XrMNtw4s=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1657195180973536.7531988269672; Thu, 7 Jul 2022 17:29:40 +0530 (IST)
Date:   Thu, 07 Jul 2022 17:29:40 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "Johannes Berg" <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <181d887b398.167dab1d11045.9186448565104273580@siddh.me>
In-Reply-To: <YsbIoB5KTqdRva6g@kroah.com>
References: <20220701145423.53208-1-code@siddh.me>
 <181d8729017.4900485b8578.8329491601163367716@siddh.me> <YsbIoB5KTqdRva6g@kroah.com>
Subject: Re: Ping: [PATCH] net: Fix UAF in ieee80211_scan_rx()
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

On Thu, 07 Jul 2022 17:20:56 +0530  Greg KH <gregkh@linuxfoundation.org> wrote
> On Thu, Jul 07, 2022 at 05:06:35PM +0530, Siddh Raman Pant via Linux-kernel-mentees wrote:
> > Ping?
> 
> context-less pings, on a patch that was sent less than 1 week ago, are
> usually not a good idea.  Normally wait for 2 weeks and then resend if
> you have not heard anything back.
> 
> good luck!
> 
> greg k-h

Sorry, I never intended to disturb anyone.

Thanks for informing,
Siddh
