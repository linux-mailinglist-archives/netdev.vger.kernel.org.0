Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EFE31B038
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 12:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbhBNLaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 06:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNLay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 06:30:54 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9415BC061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:30:14 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id lw17so1751974pjb.0
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 03:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u/qUKS0ZcQSVd1AfSHDHR11WuuwgtPK9IDFDeLwVlxs=;
        b=ZKtDqveq7RZufqgD6hdthrkztYbkLv7Dr/teXNb1HKZKu3BXypzKe45VzDXqyj0Sfy
         6SK9Lm7Z2MaoguN/5irDz/wr3yx9uHK9/GPEok7ZDoOCIMeIMzqSm1R23oP/mejKYlpE
         q/UMh1x8fu7uHSFx+ICYOGd07MtuiAoyxeH8320n225Z5vYq02WzCmraweJCuv2o5CIf
         nhjbAJno4ucS8qtbxcBbyEkzMRAimjsGdmCZE4POAEQtUwH7UUkJ5GN6tit65KO9qMk7
         jZg56WEZrfMUWVM09fMgR8FKS58Ws2t7ZINp6Tal1DTPC8LtcYbgTSp96ynENF/tKmpD
         VUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u/qUKS0ZcQSVd1AfSHDHR11WuuwgtPK9IDFDeLwVlxs=;
        b=eeP/JNDS/5/dmKd+p56DiSxkgLeOs17QrlQoDZr2kJ0hdXzFbdUxXIOEALviyQ7MUj
         f2ZpAk9nX1uTTUIOD2Rv/vVMakrOxK0tujz/TUafYEWEZTpSgRLv0bTUM4inO2Zw8PeQ
         GyVed+tGfsGgRYY6wH1Pv2HmYxz6UsqKuSQOoA5kDSs+63AdPpCnIwUwYb1hd0rOv/hQ
         c+zB5cwMgHheKCIR3S2Yxbc4Url955T4spkh8LQf8Tbzx/uxuGVVfXJoBcolEovhRhoy
         YICxawLsZDZCfY/bipw0L9lSmhctzOqIVQs5Mx+/VsHG8BPlKzJ+y3p9HnCd7PN52cJY
         GgrQ==
X-Gm-Message-State: AOAM532cai41fcbpXbe3VIYBsuQl+jEDomfBlSmBpBmn3Wjb6C5iot4c
        HwxCZjMs91y6BogVwosENEc=
X-Google-Smtp-Source: ABdhPJw/zui9HNngfhxaNe3X5ezELfsroNLfuJG2unvPMPf+cO5hkra9jr3ZP4HD70hgNE3/QDSjmg==
X-Received: by 2002:a17:902:c948:b029:e2:e8f7:abd9 with SMTP id i8-20020a170902c948b02900e2e8f7abd9mr10856360pla.18.1613302214004;
        Sun, 14 Feb 2021 03:30:14 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id u3sm15853998pfm.144.2021.02.14.03.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 03:30:13 -0800 (PST)
Subject: Re: [PATCH net-next v2 3/7] mld: add a new delayed_work,
 mc_delrec_work
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        Marek Lindner <mareklindner@neomailbox.ch>,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, ap420073@gmail.com
References: <20210213175148.28375-1-ap420073@gmail.com>
 <CAM_iQpVrD5623egpEy2BhR66smuEaTLRHgsu9YA_vrMGjacPkg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <921affaf-9fe8-c79f-8ee0-e59e1930d35d@gmail.com>
Date:   Sun, 14 Feb 2021 20:30:08 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVrD5623egpEy2BhR66smuEaTLRHgsu9YA_vrMGjacPkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21. 2. 14. 오전 4:18, Cong Wang wrote:
 > On Sat, Feb 13, 2021 at 9:52 AM Taehee Yoo <ap420073@gmail.com> wrote:
 >>
 >> The goal of mc_delrec_work delayed work is to call mld_clear_delrec().
 >> The mld_clear_delrec() is called under both data path and control path.
 >> So, the context of mld_clear_delrec() can be atomic.
 >> But this function accesses struct ifmcaddr6 and struct ip6_sf_list.
 >> These structures are going to be protected by RTNL.
 >> So, this function should be called in a sleepable context.
 >
 > Hmm, but with this patch mld_clear_delrec() is called asynchronously
 > without waiting, is this a problem? If not, please explain why in your
 > changelog.
 >

The mld_clear_delrec() is called when an mld v1 query is received or an 
interface is down/destroyed.
The purpose of this function is to clear deleted records, which are not 
used when an mld v1 query is received.
So, In the datapath, it has no problem.
Also it increases the refcount of idev so it has no problem when an 
interface is down or destroyed.

I will include this description in the v3 patch.
Thanks!

 > By the way, if you do not use a delay, you can just use regular work.
 >
 > Thanks.
 >
