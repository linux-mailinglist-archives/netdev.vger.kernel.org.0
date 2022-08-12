Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B06659124A
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 16:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238432AbiHLOd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 10:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiHLOd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 10:33:56 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9A0A406F;
        Fri, 12 Aug 2022 07:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660314797; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=ZsPeTBwCvtjfBth8vCDZ73XUlW82+n2II13ffIl313k1+oOYiENtHB9UVPUFiUH7/nlK4XZFKluKR0d9y5YWaPv646IhMo1/sVmoVRIB3FEN4J3h7Dsh3CM7nsGQ8WSh3Xwia0qaWVzyuH7XvNy61XI9ZB0LxGmDUH8MwCtIJy8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660314797; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dumJYXz+P7lT1DPflB6oGqlatTwRRoJ0LNEvMWFK+Lc=; 
        b=FiZ9xtbApy4datR1Ci/1lkexOq5Ep6P1qVUCJzPRp11JDSa3uq9aHYz9mlzp0AzFWiqTNWo+TWbKcbfpOUUY8bkllsYytUWedSDC2z2bDiD0oOLTy46PXHp+ey4u+hUemHYfz7Fqp461prmdddCj+Zqugl+OlF2enx1nwhu/Fqg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660314797;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=dumJYXz+P7lT1DPflB6oGqlatTwRRoJ0LNEvMWFK+Lc=;
        b=CV76Upvi9tklgyTLuwhoGmyhL+YvwHD62NLAPtXIeXioCiczbg5LLWx2beUVNX7t
        bqvFXs5cL3Y7+FqQyT2EjKeUaeaaV2F7KUtQ2ufvyxfKujAXub4ezVjuTlldBXXE5dU
        UXUdsOZIf9kTOwYO5TtmrlgBTj4prl8cs/KiYuHQ=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 166031478558942.555014497664615; Fri, 12 Aug 2022 20:03:05 +0530 (IST)
Date:   Fri, 12 Aug 2022 20:03:05 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "johannes berg" <johannes@sipsolutions.net>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "jakub kicinski" <kuba@kernel.org>,
        "paolo abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "syzbot+6cb476b7c69916a0caca" 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "syzbot+f9acff9bf08a845f225d" 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        "syzbot+9250865a55539d384347" 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <18292791718.88f48d22175003.6675210189148271554@siddh.me>
In-Reply-To: <YvZEfnjGIpH6XjsD@kroah.com>
References: <20220726123921.29664-1-code@siddh.me>
 <18291779771.584fa6ab156295.3990923778713440655@siddh.me> <YvZEfnjGIpH6XjsD@kroah.com>
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

On Fri, 12 Aug 2022 17:45:58 +0530  Greg KH  wrote:
> The merge window is for new features to be added, bugfixes can be merged
> at any point in time, but most maintainers close their trees until after
> the merge window is closed before accepting new fixes, like this one.
> 
> So just relax, wait another week or so, and if there's no response,
> resend it then.
> 

Okay, sure.

> Personally, this patch seems very incorrect, but hey, I'm not the wifi
> subsystem maintainer :)

Why do you think so?

Thanks,
Siddh
