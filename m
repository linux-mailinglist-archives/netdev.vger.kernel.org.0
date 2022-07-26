Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0F75812FC
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 14:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiGZMRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 08:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbiGZMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 08:17:52 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C29CAE5F;
        Tue, 26 Jul 2022 05:17:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1658837831; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=DwvStKCMX7XoSZbjyoswQoy4twyd44xhM49CK5T8sZq0ysHOuMdHO4gEucz21a+caA0AUUfMpjRLtcrLsZRG8h8J/+STMIB5fpYYq0xypc+ki3wyJOf18uTj1zi6G0xZUgjrQE0fXQPIKTdW5P/8XWaHUmDqTVsnYZHzIw5tNwY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1658837831; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=18GXarUQ3jL1O2RMagJvrp6VQJVu7m+DREZ1/MUGIKE=; 
        b=ZTDAh/jHJfjZlzakiKGVEgaNoU2l59n863+h41BvGV/RSPSEN95p0lAoyrTIRGo9k3PFGX2vls1Fw85SUtFcOYfRWRe3L9oCIHvCdyGM2w6L7J8WLPeMMEHlyAyLqjWO2tH7KuIseNlAgjw91Oz3WJJDmKuzWYFwyYeKaE11NhI=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1658837831;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=18GXarUQ3jL1O2RMagJvrp6VQJVu7m+DREZ1/MUGIKE=;
        b=nUa2GObIJsbmqiwdL3ub9h03vWog6RC7JII2RTx/fKCgQ8v8ELiwY0Ngrgqh8GYR
        AwGzeXfwiyF9Gpbp7HRRmdSlI+lIwdoSY744F7S6JMSRnnQXiPZ4DWC+JbbLkZAL1lg
        SZ//HSLlFEaFW/Y6g0NP+HJGgkFgQyXE8dOlQzOE=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 165883781910727.618496178340138; Tue, 26 Jul 2022 17:46:59 +0530 (IST)
Date:   Tue, 26 Jul 2022 17:46:59 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Eric Dumazet" <edumazet@google.com>
Cc:     "Johannes Berg" <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Message-ID: <1823a705ed0.2c95d162772051.7830246635749918178@siddh.me>
In-Reply-To: <CANn89iLN27NWA7Stkr4ODp6V-Q-3em0dJ2JixDMNcNY7Ap5muA@mail.gmail.com>
References: <20220701145423.53208-1-code@siddh.me> <CANn89iLN27NWA7Stkr4ODp6V-Q-3em0dJ2JixDMNcNY7Ap5muA@mail.gmail.com>
Subject: Re: [PATCH] net: Fix UAF in ieee80211_scan_rx()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 15:37:16 +0530  Eric Dumazet <edumazet@google.com> wrote:
> Note: this is slightly racy.
> 
> You are supposed to follow this order in this situation.
> 
> 1) Clear the pointer
> 
> Then:
> 
> 2) wait an rcu grace period (synchronize_rcu()) or use call_rcu()/kfree_rcu().
>  

Noted. Due to rcu_dereference() used to get scan_req, null ptr dereference
cannot happen. That had completely missed my eyes, sorry for that.

I will send a v2.

Thanks,
Siddh
