Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2078E3C4A24
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 12:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbhGLGsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 02:48:54 -0400
Received: from relay.sw.ru ([185.231.240.75]:60354 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236933AbhGLGrz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Aq0ET5YTdm1rWPpNSi7B0UtAwwipZjr7vSxwvu8q6+A=; b=DVMWWJtSkNLQF/ICmSU
        bW047YV+ka+RNu6XiOdkh7P0ExSAGs6n9Pa20Fl9wfyvD9BCG+gEt5xveo7GX/LsC+s961T1Bt+2r
        EjHknLjKwndyNObMzC3GBbJpCOGgmIgzL0YaSPMWSKaKkZcwiPdlAg9ZprTpWRQrg+M9Z10QOkg=;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1m2pgX-003ew1-9p; Mon, 12 Jul 2021 09:44:57 +0300
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH IPV6 v3 0/1] ipv6: allocate enough headroom in
 ip6_finish_output2()
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
Message-ID: <a2470406-786a-542e-6286-43ffbb97f9cb@virtuozzo.com>
Date:   Mon, 12 Jul 2021 09:44:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <74e90fba-df9f-5078-13de-41df54d2b257@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently Syzkaller found one more issue on RHEL7-based OpenVz kernels.
During its investigation I've found that upstream is affected too. 

TEE target send sbk with small headroom into another interface which requires
an increased headroom.

ipv4 handles this problem in ip_finish_output2() and creates new skb with enough headroom,
though ip6_finish_output2() lacks this logic.

Suzkaller created C reproducer, it can be found in v1 cover-letter 
https://lkml.org/lkml/2021/7/7/467

v3 changes:
 now I think it's better to separate bugfix itself and creation of new helper.
 now bugfix does not create new inline function. Unlike from v1 it creates new skb
 only when it is necessary, i.e. for shared skb only.
 In case of failure it updates IPSTATS_MIB_OUTDISCARDS counter
 Patch set with new helper will be sent separately.

v2 changes: 
 new helper was created and used in ip6_finish_output2 and in ip6_xmit()
 small refactoring in changed functions: commonly used dereferences was replaced by variables

Vasily Averin (1):
  ipv6: allocate enough headroom in ip6_finish_output2()

 net/ipv6/ip6_output.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

-- 
1.8.3.1

