Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EC93D2BB6
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhGVR04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 13:26:56 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:41155 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhGVR0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 13:26:55 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id CE3E1200E7A8;
        Thu, 22 Jul 2021 20:07:28 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be CE3E1200E7A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626977248;
        bh=r1mr54/S9UFs8uw+5huhvI99uEwPWKeXcD+MX/szleE=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=evRQ7klhScexRxBPH2Yj/zmBRQo0NRsEQYre9tGTg381y4fKr3lEAyLokw3EO5ixn
         /1daTfVOtkQRBwN7T93QO4aSmhPxPDyXgLw2LuK/vw1Z+p+e6BY5ydnQmVNBHZr/lY
         OqiQ9AwDVhDfO49CjxuS3mhBdeYVif3W5ubC3Scc0HQamIkz6aU37scJZkyjFSAva5
         Uj4SoMl67jmoxXS/0U30M/kXrufygAHoy/eDaIYjlseK5+q5veGrsyizxRRYIpvT10
         prv28HmdqWkklTKNfg/gc9Bduy9mfV69CCLsFOVXaZSy8nhGpv+vZZ7Vwco41IWOjz
         yY17pOe1PyCXw==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id C3ECD602255BB;
        Thu, 22 Jul 2021 20:07:28 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id R8vU5vEgwInA; Thu, 22 Jul 2021 20:07:28 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id AE48E6008D842;
        Thu, 22 Jul 2021 20:07:28 +0200 (CEST)
Date:   Thu, 22 Jul 2021 20:07:28 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <651934762.25015210.1626977248685.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210722075504.1793321-1-matthieu.baerts@tessares.net>
References: <20210722075504.1793321-1-matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next] ipv6: fix "'ioam6_if_id_max' defined but not
 used" warn
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF90 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: fix "'ioam6_if_id_max' defined but not used" warn
Thread-Index: CGhQJN0HUiWTUsG/AVTlpMGjMqBoIw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When compiling without CONFIG_SYSCTL, this warning appears:
> 
>  net/ipv6/addrconf.c:99:12: error: 'ioam6_if_id_max' defined but not used
>  [-Werror=unused-variable]
>     99 | static u32 ioam6_if_id_max = U16_MAX;
>        |            ^~~~~~~~~~~~~~~
>  cc1: all warnings being treated as errors
> 
> Simply moving the declaration of this variable under ...
> 
>  #ifdef CONFIG_SYSCTL
> 
> ... with other similar variables fixes the issue.
> 
> Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> ---
> 
> Notes:
>    Please note that this 'ioam6_if_id_max' variable could certainly be
>    declared as 'const' like some others used as limits for sysctl knobs.
>    But here, this patch focuses on fixing the warning reported by GCC.
> 
> net/ipv6/addrconf.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index 1802287977f1..db0a89810f28 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -96,8 +96,6 @@
> #define IPV6_MAX_STRLEN \
> 	sizeof("ffff:ffff:ffff:ffff:ffff:ffff:255.255.255.255")
> 
> -static u32 ioam6_if_id_max = U16_MAX;
> -
> static inline u32 cstamp_delta(unsigned long cstamp)
> {
> 	return (cstamp - INITIAL_JIFFIES) * 100UL / HZ;
> @@ -6550,6 +6548,7 @@ static int addrconf_sysctl_disable_policy(struct ctl_table
> *ctl, int write,
> 
> static int minus_one = -1;
> static const int two_five_five = 255;
> +static u32 ioam6_if_id_max = U16_MAX;
> 
> static const struct ctl_table addrconf_sysctl[] = {
> 	{
> --
> 2.31.1

Good catch, thanks for the patch.
