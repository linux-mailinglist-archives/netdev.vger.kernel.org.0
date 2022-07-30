Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61005585B24
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 17:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbiG3Pwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 11:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbiG3Pwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 11:52:34 -0400
Received: from sender-of-o53.zoho.in (sender-of-o53.zoho.in [103.117.158.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26FFB4A3;
        Sat, 30 Jul 2022 08:52:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659196316; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=YlURlAEWwZZDxfCQefkLozeADwMcUOka33Ne9+CUlp9Bb2vrc0hJyFQkcsbffJpckfFmuhCu8SEuzMHNQ1z/Y57N0VHZrjFuUBJZhcpACVuOBLhHDCfPGBCMicgxEa6wsYdFyuynqS8H4Q53eZ085+W2rN6inFU6xd/yDWYpz3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1659196316; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=btUHak4aC7AHbcsohvLeq8y59tKpw5lXk3saZUZchRA=; 
        b=b6mYHse//3Id2udqgxXoOwnoBIjEXRbYbbtuAIFM4pOR2i8448jkfLQ99tkEmhRa4Li07ciqOCcMV/HbjvEvpR7aEC1jNhlLk4+bZKIs+MIzJRWsULQ/2hfzzoRDWXe5RBj2HaxxyjeZa+R3Y/BClgAAlxylDNcm71Bvwh3fzdE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1659196316;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=btUHak4aC7AHbcsohvLeq8y59tKpw5lXk3saZUZchRA=;
        b=uAHwyKWFwNr89AYnV5sr8LgwJZL+c6K5Wzw+xWUZTnV0EA2jGAPzHtMV7Z8VYpps
        B6trckRvDxP56qj65jgM3Oh9u6OK1Qj2YmFLrhwmAmFk61ucyrnZgy1TaXtIyVJuy1p
        wI0RnE5j5KARd4VciVbbtWYnEBYb2fLRfmvtL9Ak=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1659196305433511.22681407777645; Sat, 30 Jul 2022 21:21:45 +0530 (IST)
Date:   Sat, 30 Jul 2022 21:21:45 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Lukas Bulwahn" <lukas.bulwahn@gmail.com>
Cc:     "Johannes Berg" <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "syzbot+6cb476b7c69916a0caca" 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "syzbot+f9acff9bf08a845f225d" 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        "syzbot+9250865a55539d384347" 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <1824fce6ffa.649b18b496010.5533738718445972188@siddh.me>
In-Reply-To: <CAKXUXMzeSLuH31zQDe3Q_1YAvfmFR16ZsfFGmxEMiMQSKcp_Nw@mail.gmail.com>
References: <20220721101018.17902-1-code@siddh.me> <CAKXUXMzeSLuH31zQDe3Q_1YAvfmFR16ZsfFGmxEMiMQSKcp_Nw@mail.gmail.com>
Subject: Re: [RESEND PATCH] net: Fix UAF in ieee80211_scan_rx()
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

Hello Lukas,

Sorry for the late reply.

On Thu, 21 Jul 2022 16:05:01 +0530  Lukas Bulwahn <lukas.bulwahn@gmail.com> wrote:
> Siddh,
> 
> I had a look at the Bug report above. Currently, we do not have any
> syzkaller or C reproducer to confirm that the bug was actually fixed.
> 
> Now, that you have a supposed fix for the issue:
> Can you write a 'stress test' and (qemu) setup script that eventually
> makes that bug trigger (e.g., if we run the stress test for two or
> three days it will eventually trigger)? Then, we can also use that to
> confirm that your patch fixes the issue (beyond the normal sanity code
> review).
> 
> This is certainly something you can do on your side to move this patch
> forward, and other developers with testing infrastructure can pick up
> and confirm your tests and results independently.

I have been intermittently looking about this for the past few days. Since
such test creation is new to me, I am stuck at how to go about calling the
requisite function.

What I have gathered is that I need to use the netlink API or related tool
and issue the scan and recieve commands. Since qemu by default doesn't
have a WiFi interface setup by default, I was looking at simulation and
came across the mac80211_hwsim module. After building the kernel it, I
tried using `iw` command for scanning with the two phy simulated devices,
but I seem to hit a deadend due to not being able to properly use them
for the task at hand.

Do you have any resources or/and examples on such "stress tests"?

> I hope this helps, otherwise you will just need to have some patience.
> 
> Best regards,
> 
> Lukas

Eric had replied to me on the original email soon after, and I have sent
a v2. Though, I still want to see how people go about making the tests,
so any resources for further exploring will be useful.

Thanks,
Siddh
