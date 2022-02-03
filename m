Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727894A8206
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 11:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349974AbiBCKB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 05:01:59 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:53416 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240750AbiBCKB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 05:01:58 -0500
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id 4396D200F802;
        Thu,  3 Feb 2022 11:01:56 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 4396D200F802
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1643882516;
        bh=DL3SlfENiaGEPjEqBA7fcl+Ti+j2Sw8xhUfgB8JmKe4=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=UwCE48SQXXFPCwm9qlgj7BfdV2zRZ/y6mnxQE4BoWrn+IhEXgSQkFJ9uJ3aZZaPo1
         r0rbJTno7TlY7Fgg93qgea5pu7yS9kQsGuITni6bWpl1of2VPvx3co3ZPmPdOShkRz
         EPRTcxHyrlqdMM8MsLY4nu2k85uPHp1VKCloDTIKIQy3lZUngr3fPwUJoM5cbq1y6R
         2RryewDE9MG/kCm8+/K9ku0MLMzAv/5KtroKswQc/ReDiRFASeLkTvBl6JXCKpSSvd
         m2zzDBuNyb+bdh5m6ggBtQdOjU7IOf8yjo9VQdCXkcdId72R8luCYYd49YsKGKKfkc
         ystcEwAaI1nsg==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 2EE9060224572;
        Thu,  3 Feb 2022 11:01:56 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h6gNDQH2Y27w; Thu,  3 Feb 2022 11:01:56 +0100 (CET)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 05A796016F395;
        Thu,  3 Feb 2022 11:01:56 +0100 (CET)
Date:   Thu, 3 Feb 2022 11:01:55 +0100 (CET)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Message-ID: <1603413387.15401325.1643882515850.JavaMail.zimbra@uliege.be>
In-Reply-To: <387b6b6e-3813-60b1-51f2-33ce45aeaf47@gmail.com>
References: <20220202142554.9691-1-justin.iurman@uliege.be> <387b6b6e-3813-60b1-51f2-33ce45aeaf47@gmail.com>
Subject: Re: [PATCH net-next v2 0/2] Support for the IOAM insertion
 frequency
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF96 (Linux)/8.8.15_GA_4026)
Thread-Topic: Support for the IOAM insertion frequency
Thread-Index: wTf6LYIqacrYAFcj9oko0Mpy+De1RQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Feb 3, 2022, at 4:47 AM, David Ahern dsahern@gmail.com wrote:
>> v2:
>>  - signed -> unsigned (for "k" and "n")
>>  - keep binary compatibility by moving "k" and "n" at the end of uapi
>> 
>> The insertion frequency is represented as "k/n", meaning IOAM will be
>> added to {k} packets over {n} packets, with 0 < k <= n and 1 <= {k,n} <=
>> 1000000. Therefore, it provides the following percentages of insertion
>> frequency: [0.0001% (min) ... 100% (max)].
>> 
>> Not only this solution allows an operator to apply dynamic frequencies
>> based on the current traffic load, but it also provides some
>> flexibility, i.e., by distinguishing similar cases (e.g., "1/2" and
>> "2/4").
>> 
>> "1/2" = Y N Y N Y N Y N ...
>> "2/4" = Y Y N N Y Y N N ...
>> 
> 
> what's the thought process behind this kind of sampling? K consecutive
> packets in a row with the trace; N-K consecutive packets without it.

Flexibility. Long story short, it was initially designed with a fixed
"k" (i.e., k=1) so that operators could set the IOAM insertion frequency
to "1/n" (i.e., inject IOAM every n packets). Available frequencies were
100% ("1/1"), 50% ("1/2"), 33% ("1/3"), 25% ("1/4"), etc. By introducing
a non-fixed "k", we wanted to provide flexibility and accuracy to
operators, because you never know... They could require to inject IOAM
in 75% of their traffic, or want to differentiate "1/2" and "2/4", or
whatever). So you can see it as an improved feature of the "1/n" base
frequency. Whether it'll be useful or not, well, I don't know. Again, it
all depends on operators' needs.
