Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 954743E391D
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 07:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhHHFf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 01:35:59 -0400
Received: from mail.rptsys.com ([23.155.224.45]:11822 "EHLO mail.rptsys.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHFf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 01:35:59 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 6F60037B2E12D6
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 00:35:40 -0500 (CDT)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id Aw7xidEnHS_X for <netdev@vger.kernel.org>;
        Sun,  8 Aug 2021 00:35:40 -0500 (CDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id F035237B2E12D3
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 00:35:39 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com F035237B2E12D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1628400940; bh=ePUimur8HvcXO6dMcut4cEuJRyfQBlPu0du9yQcQfIo=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=g6c2qgu4hAUf4hke5OlL5QtwkStdxkI9m9okt2b37u6M/uKjQowfENFt/zxxvnFKO
         SdVhOgEhH/+rsQptI0YVuNgLwwk7N7w1SnvPApKFqYzqlAqfaHZQ3/8nk6Dxb30AX/
         Ukl0Un5wUJq1G6YBoLT7WKBKoXUIuwtZFJHJ3Fv4=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id InYEbe7TXY8K for <netdev@vger.kernel.org>;
        Sun,  8 Aug 2021 00:35:39 -0500 (CDT)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id D262937B2E12D0
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 00:35:39 -0500 (CDT)
Date:   Sun, 8 Aug 2021 00:35:38 -0500 (CDT)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     netdev <netdev@vger.kernel.org>
Message-ID: <697798023.725799.1628400938735.JavaMail.zimbra@raptorengineeringinc.com>
In-Reply-To: <1361477129.691401.1628386637818.JavaMail.zimbra@raptorengineeringinc.com>
References: <1361477129.691401.1628386637818.JavaMail.zimbra@raptorengineeringinc.com>
Subject: Re: Very slow macsec transfers on OpenPOWER hardware
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC83 (Linux)/8.5.0_GA_3042)
Thread-Topic: Very slow macsec transfers on OpenPOWER hardware
Thread-Index: tZJc0/GNcMYowbTaaxPE9MwS/MNKJz9D7ai3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quick update:

1.) Disabling encryption actually relieves the load on the softirq handler entirely, but the throughput remains abysmal with extremely high load in the gf128mul_lle function.

2.) Bizarrely, unloading the vmx_crypto (POWER accelerated crypto) module *tripled* the throughput, although 400MB/s is still a long way away from the Gbps range we should be in.

----- Original Message -----
> From: "Timothy Pearson" <tpearson@raptorengineering.com>
> To: "netdev" <netdev@vger.kernel.org>
> Sent: Saturday, August 7, 2021 8:37:17 PM
> Subject: Very slow macsec transfers on OpenPOWER hardware

> I'm seeing an extreme performance issue with macsec on OpenPOWER (ppc64le)
> hardware, both with and without encryption.  The base systems are identical
> POWER9-based hosts with Intel 10Gbe Ethernet adapters; the base link validates
> at 9.9Gbps but the macsec link maxes out at around 250Mbps without encryption
> and only 170Mbps with encryption.
> 
> Ordinarily I'd suspect a cipher module isn't loaded, but the results without
> encryption seem to point somewhere else.  In both cases the softirq load is
> extremely high (100% pegged on one CPU core).
> 
> Any debugging tips are appreciated -- I can't imagine a 100-fold performance
> reduction over the native link is correct. ;)
> 
> Thanks!
