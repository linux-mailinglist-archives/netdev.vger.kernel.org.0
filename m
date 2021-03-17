Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E8933EC58
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhCQJMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhCQJMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:12:09 -0400
X-Greylist: delayed 462 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 Mar 2021 02:12:08 PDT
Received: from ellomb.netlib.re (unknown [IPv6:2001:912:1480:10::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282F2C06174A;
        Wed, 17 Mar 2021 02:12:08 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by ellomb.netlib.re (Postfix) with ESMTPA id 97BAC5339E9E;
        Wed, 17 Mar 2021 09:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mildred.fr; s=dkim;
        t=1615971860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UDa0V4BMdmF12UM5cFG8Qs2U8MRsw1yqXPlMZldWCMM=;
        b=IU/76do0dZc4zirdLHgU4diZj16mFsfS700C4UhA+Q0zvyu4DL4GKkJvtLKckomeJWLWdl
        x+7Up6PH0HjjSOgM1wth3WmcbGzeHSEf/GU21qGq4gU8XjRGW4wQqdZtD3QnvCt98B4Ust
        bXXSqhCZMwy18oHnOv1WyDosTSYMc1A=
To:     bpf <bpf@vger.kernel.org>
From:   =?UTF-8?Q?Shanti_Lombard_n=c3=a9e_Bouchez-Mongard=c3=a9?= 
        <shanti@mildred.fr>
Subject: Design for sk_lookup helper function in context of sk_lookup hook
Cc:     netdev@vger.kernel.org, alexei.starovoitov@gmail.com, kafai@fb.com
Message-ID: <0eba7cd7-aa87-26a0-9431-686365d515f2@mildred.fr>
Date:   Wed, 17 Mar 2021 10:04:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=mildred.fr;
        s=dkim; t=1615971860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=UDa0V4BMdmF12UM5cFG8Qs2U8MRsw1yqXPlMZldWCMM=;
        b=K221AylZvjQd+yyDvBOhJr+h3H8sziYb7IOfKgdHYCrZZOpCOT84cHvck8j7xO7RLP/19I
        xYmeCs80FSElT7HXwePIi35wN/ZS9BaBZSjqVZVGQUYVl7/wbUk832msOWZpd32tkpo/HO
        6qoRshq67SaqdGobYt/g/SZtmtzLztg=
ARC-Seal: i=1; s=dkim; d=mildred.fr; t=1615971860; a=rsa-sha256; cv=none;
        b=ebxdQgE4EVouwWLSs8M0MI9sAGL+z9pgX1TZXRlkC9x5fHOihkm/A8/uzpLRYbmE3bzIIt
        vz2IoXy/EcGtTB/2mZf1CmVhBJ4cb1Z7vHWSgcvUU17H4oIFLh+VCQXsL/1+07KVIxvY83
        IYci4wdnxv3IDbr1PtT7uOrGd0OUY+I=
ARC-Authentication-Results: i=1;
        ellomb.netlib.re;
        auth=pass smtp.auth=mildred@mildred.fr smtp.mailfrom=shanti@mildred.fr
Authentication-Results: ellomb.netlib.re;
        auth=pass smtp.auth=mildred@mildred.fr smtp.mailfrom=shanti@mildred.fr
X-Spamd-Bar: /
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello everyone,

Background discussion: 
https://lore.kernel.org/bpf/CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com/

In a previous e-mail I was explaining that sk_lookup BPF programs had no 
way to lookup existing sockets in kernel space. The sockets have to be 
provided by userspace, and the userspace has to find a way to get them 
and update them, which in some circumstances can be difficult. I'm 
working on a patch to make socket lookup available to BPF programs in 
the context of the sk_lookup hook.

There is also two helper function bpf_sk_lokup_tcp and bpf_sk_lookup_udp 
which exists but are not available in the context of sk_lookup hooks. 
Making them available in this context is not very difficult (just 
configure it in net/core/filter.c) but those helpers will call back BPF 
code as part of the socket lookup potentially causing an infinite loop. 
We need to find a way to perform socket lookup but disable the BPF hook 
while doing so.

Around all this, I have a few design questions :

Q1: How do we prevent socket lookup from triggering BPF sk_lookup 
causing a loop?

- Solution A: We add a flag to the existing inet_lookup exported 
function (and similarly for inet6, udp4 and udp6). The 
INET_LOOKUP_SKIP_BPF_SK_LOOKUP flag, when set, would prevent BPF 
sk_lookup from happening. It also requires modifying every location 
making use of those functions.

- Solution B: We export a new symbol in inet_hashtables, a wrapper 
around static function inet_lhash2_lookup for inet4 and similar 
functions for inet6 and udp4/6. Looking up specific IP/port and if not 
found looking up for INADDR_ANY could be done in the helper function in 
net/core/filters.c or in the BPF program.

Q2: Should we reuse the bpf_sk_lokup_tcp and bpf_sk_lookup_udp helper 
functions or create new ones?

For solution A above, the helper functions can be reused almose 
identically, just adding a flag or boolean argument to tell if we are in 
a sk_lookup program or not. In solution B is preferred, them perhaps it 
would make sense to expose the new raw lookup function created, and the 
BPF program would be responsible for falling back to INADDR_ANY if the 
specific socket is not found. It adds more power to the BPF program in 
this case but requires to create a new helper function.

I was going with Solution A abd identical function names, but as I am 
touching the code it seems that maybe solution B with a new helper 
function could be better. I'm open to ideas.

Thank you.

PS: please include me in replies if you are responding only to the 
netdev mailing list as I'm not part of it. I'm subscribed to bpf.

