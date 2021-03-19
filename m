Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F13422D2
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 18:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhCSRFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 13:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhCSRF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 13:05:29 -0400
Received: from ellomb.netlib.re (unknown [IPv6:2001:912:1480:10::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155A9C06174A;
        Fri, 19 Mar 2021 10:05:29 -0700 (PDT)
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by ellomb.netlib.re (Postfix) with ESMTPA id A8183538EC02;
        Fri, 19 Mar 2021 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mildred.fr; s=dkim;
        t=1616173522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPO41eAFWQvK10icXPYiGfaOquv/ADh3PO0meiNNJHY=;
        b=U6IfQoy+aPtlTvr7kTZ9DyAwnizOr72YErxDDfHxtAguKanwc+UAASuqfWhLpsIAQiU7TR
        yeXal7lGWcco645fnYf38HTznGoFbbqFs2tUBkCLFRjuYNq+O14DisZ/nlQkQvdS/RLiTQ
        OeVR7d8BY4MyvKdIw0j5/HiU4fSsvP4=
Subject: Re: Design for sk_lookup helper function in context of sk_lookup hook
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, netdev@vger.kernel.org,
        alexei.starovoitov@gmail.com
References: <0eba7cd7-aa87-26a0-9431-686365d515f2@mildred.fr>
 <20210319165546.6dbiki7es7uhdayw@kafai-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Shanti_Lombard_n=c3=a9e_Bouchez-Mongard=c3=a9?= 
        <mildred@mildred.fr>
Message-ID: <a707be4e-9101-78dd-4ed0-5556c5fa143e@mildred.fr>
Date:   Fri, 19 Mar 2021 18:05:20 +0100
MIME-Version: 1.0
In-Reply-To: <20210319165546.6dbiki7es7uhdayw@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=mildred.fr;
        s=dkim; t=1616173522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPO41eAFWQvK10icXPYiGfaOquv/ADh3PO0meiNNJHY=;
        b=BKahAgPWACUo3At7qgzPuR1kaNAvkuEpc3nOhCMIVRCq0xy0kOhgTVjHK9DSZhv48Di4ng
        3P9SHVOA4cfsz4x28N0qlCatHw9CVhVIvWnpt1y4bBUActR+DD+KAmX6fbDBYUm+qe2og/
        hFCE8gaCWnR+KyVHizzlZc7sNmIZ1Sk=
ARC-Seal: i=1; s=dkim; d=mildred.fr; t=1616173522; a=rsa-sha256; cv=none;
        b=aDU8abmheIaa+xCfAC54qc7R4Ijx3sabYwjobVzXrB5au7yKuapr9cfF4DlnSv0smLIyaa
        nWOYm+ZxsT5jUzgMKfLfX6epM06HZmj3ldh0uJDK5TrFW0GcPR/LeW0fVggihA5w0wffei
        5s4aVRuCFBP768Im/MQITzWHzog7hzs=
ARC-Authentication-Results: i=1;
        ellomb.netlib.re;
        auth=pass smtp.auth=mildred@mildred.fr smtp.mailfrom=mildred@mildred.fr
Authentication-Results: ellomb.netlib.re;
        auth=pass smtp.auth=mildred@mildred.fr smtp.mailfrom=mildred@mildred.fr
X-Spamd-Bar: /
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 19/03/2021 à 17:55, Martin KaFai Lau a écrit :
> On Wed, Mar 17, 2021 at 10:04:18AM +0100, Shanti Lombard née Bouchez-Mongardé wrote:
>> Q1: How do we prevent socket lookup from triggering BPF sk_lookup causing a
>> loop?
> The bpf_sk_lookup_(tcp|udp) will be called from the BPF_PROG_TYPE_SK_LOOKUP program?

Yes, the idea is to allow the BPF program to redirect incoming 
connections for 0.0.0.0:1234 to a specific IP address such as 
127.0.12.34:1234 or any other combinaison with a binding not done based 
on a predefined socket file descriptor but based on a listening IP 
address for a socket.

See linked discussion in the original message

>> - Solution A: We add a flag to the existing inet_lookup exported function
>> (and similarly for inet6, udp4 and udp6). The INET_LOOKUP_SKIP_BPF_SK_LOOKUP
>> flag, when set, would prevent BPF sk_lookup from happening. It also requires
>> modifying every location making use of those functions.
>>
>> - Solution B: We export a new symbol in inet_hashtables, a wrapper around
>> static function inet_lhash2_lookup for inet4 and similar functions for inet6
>> and udp4/6. Looking up specific IP/port and if not found looking up for
>> INADDR_ANY could be done in the helper function in net/core/filters.c or in
>> the BPF program.
>>
>> Q2: Should we reuse the bpf_sk_lokup_tcp and bpf_sk_lookup_udp helper
>> functions or create new ones?
> If the args passing to the bpf_sk_lookup_(tcp|udp) is the same,
> it makes sense to reuse the same BPF_FUNC_sk_lookup_*.
> The actual helper implementation could be different though.
> Look at bpf_xdp_sk_lookup_tcp_proto and bpf_sk_lookup_tcp_proto.

I was thinking that perhaps a different helper method which would take 
IPPROTO_TCP or IPPROTO_UDP parameter would be better suited. it would 
avoid BPF code such as :

     switch(ctx->protocol){
         case IPPROTO_TCP:
             sk = bpf_sk_lookup_tcp(ctx, &tuple, tuple_size, -1, 0);
             break;
         case IPPROTO_UDP:
             sk = bpf_sk_lookup_udp(ctx, &tuple, tuple_size, -1, 0);
             break;
         default:
             return SK_PASS;
     }

But then there is the limit of 5 arguments, isn't it, so perhaps the 
_tcp/_udp functions are not such a bad idea after all.

I saw already that the same helper functions could be given different 
implementations. And if there is no way to have more than 5 arguments 
then this is probably better to reuse the same helper function name and 
signature.

Thank you


