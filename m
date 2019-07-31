Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B987D141
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfGaWkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:40:07 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37224 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfGaWkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:40:07 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so46326149wrr.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 15:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mfhsqc0xEWQd66BFU0M2p3Go+hte74AED6AOyPt5Bek=;
        b=hkPWTHKisbyoJ6Qp+q1em+N6EHGZjrb6kjcwFpOGNd2Ce0dirGPPb9TvPKP0U5ILBd
         b/FQbGxtmwIC7nyqo+pooZ4VZjbEzCJ43MRmlMocIRxrlestb6t7DvGgKlsDcXMtM1f3
         wuVdeK48DJaxYQYADAEbjW19VaIA9JgHzeCNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mfhsqc0xEWQd66BFU0M2p3Go+hte74AED6AOyPt5Bek=;
        b=aiBNfbdbKDYyRK81HtFzmoZ5E8vQ1ZEPDyZTIDA911r1JYWJtSDypWqpewqBsayi4c
         hNT2kibcsKOtlF84J08MOdWPGdx//KVSQDcvHZY598Zc5A81hNw6Xq+es88EcziaaxLI
         5I+o9DDYfMpck2ETA9JSTuwyIpbHSahmG/qWuVfUPlT6JfOWahlQY8QIBSLGLMiIwaVp
         +S9zT3o0d52AnafefpNO/WI2IJZs1tzlbdu3myIcZigopy0KkxyKhJ3dqczDSB3x60Kb
         AL+8c2j+nxFJQ3KHpOJUCStIIuKd2xuK3+0M4yiJalSdJmID/GjguJm//p2ghBCbWEWp
         4Ymg==
X-Gm-Message-State: APjAAAWvwxUuMm4q8xoUxET/c6TRFGG3oBFWubvBbeDez4ng8HnqHEMM
        jWRhPYazCOL1lVvSFFeX9SgV5w==
X-Google-Smtp-Source: APXvYqx2aHClGbT+5UXps9NR1/Yv3rHEoSR4XVpmjGTQNo17EBxhvjxo8MS23xbszQlRJQuvg0v8+A==
X-Received: by 2002:a5d:6408:: with SMTP id z8mr119638806wru.246.1564612805810;
        Wed, 31 Jul 2019 15:40:05 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o7sm60551463wmf.43.2019.07.31.15.40.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 15:40:05 -0700 (PDT)
Subject: Re: [PATCH net v2] net: bridge: move vlan init/deinit to
 NETDEV_REGISTER/UNREGISTER
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
References: <20190731183623.20127-1-nikolay@cumulusnetworks.com>
 <20190731223736.18856-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <319fda43-195d-2b92-7f62-7e273c084a29@cumulusnetworks.com>
Date:   Thu, 1 Aug 2019 01:40:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190731223736.18856-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/08/2019 01:37, Nikolay Aleksandrov wrote:
> Most of the bridge device's vlan init bugs come from the fact that it's
> done in the wrong place, way too early in ndo_init() before the device is
> even assigned an ifindex. That makes error handling harder, especially for
> older kernels which don't have bridge ndo_uninit callback. It also
> introduces another bug when the bridge's dev_addr is added as fdb in the
> the initial default pvid on vlan initialization, the fdb notification has
> ifindex/NDA_MASTER both equal to 0 (see example below) which really
> makes no sense for user-space[0]. Usually user-space software would ignore
> such entries, but they are actually valid and will eventually have all
> necessary attributes. I chose to change the order because this can be
> backported to all kernels even pre-ndo_uninit ones without many changes
> and it keeps init/deinit symmetric. As a bonus this allows us to keep
> the vlan init/deinit entirely in br_vlan.c and remove those exports.
> It makes much more sense to send a notification *after* the device has
> registered and has a proper ifindex allocated rather than before when
> there's a chance that the registration might still fail.
> 
> For the demonstration below a small change to iproute2 for printing all fdb
> notifications is added, because it contained a workaround not to show
> entries with ifindex == 0.
> Command executed while monitoring: $ ip l add br0 type bridge
> Before (both ifindex and master == 0):
> $ bridge monitor fdb
> 36:7e:8a:b3:56:ba dev * vlan 1 master * permanent
> 
> After (proper br0 ifindex):
> $ bridge monitor fdb
> e6:2a:ae:7a:b7:48 dev br0 vlan 1 master br0 permanent
> 
> v2: on error in br_vlan_init set br->vlgrp to NULL
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204389
> 
> Reported-by: michael-dev <michael-dev@fami-braun.de>
> Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
> I tried a few different approaches to resolve this but they were all
> unsuitable for some kernels, this approach can go to stables easily
> and IMO is the way this had to be done from the start. Alternatively
> we could move only the br_vlan_add and pair it with a br_vlan_del of
> default_pvid on the same events, but I don't think it hurts to move
> the whole init/deinit there as it'd help older stable releases as well.
> 
> I also tested the br_vlan_init error handling after the move by always
> returning errors from all over it. Since errors at NETDEV_REGISTER cause
> NETDEV_UNREGISTER we can deinit vlans properly for all cases regardless
> why it happened (e.g. device destruction or init error).
> 
>  net/bridge/br.c         |  5 ++++-
>  net/bridge/br_device.c  | 10 ----------
>  net/bridge/br_private.h | 19 ++++---------------
>  net/bridge/br_vlan.c    | 25 ++++++++++++++++++-------
>  4 files changed, 26 insertions(+), 33 deletions(-)
> 

Aargh, I apologize for the noise, this is the wrong v2 patch...
Will send the correct one as v3 in a moment.

