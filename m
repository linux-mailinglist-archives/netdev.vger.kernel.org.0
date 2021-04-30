Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93EB0370021
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhD3SF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhD3SFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:05:25 -0400
Received: from mail.as397444.net (mail.as397444.net [IPv6:2620:6e:a000:dead:beef:15:bad:f00d])
        by lindbergh.monkeyblade.net (Postfix) with UTF8SMTPS id 3CFE6C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 11:04:36 -0700 (PDT)
Received: by mail.as397444.net (Postfix) with UTF8SMTPSA id ED152560F27;
        Fri, 30 Apr 2021 18:04:34 +0000 (UTC)
X-DKIM-Note: Keys used to sign are likely public at https://as397444.net/dkim/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mattcorallo.com;
        s=1619804463; t=1619805875;
        bh=mFJeWBQ+m/iHru+MxuTAG3KIYRmtlS5/vzSEyKJAV7k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=q5iednsrYZGxMtocQD0PgF0ewA2uPu77vBPStkGSXDt1PlJXESBg22f+kIWZLk/VG
         ITyyC1GvPllmyjBpq4tjeM1r/F58CSLN+ptttf3ofK/b26C9ClfGggxfbC5Xban7Ih
         BZM/zx0F9CpdorpXf9P7ECWTUlr6m4TBMFCCB/avoaS62MLk1TnWXlNjXHaqH2odNS
         M5MmHFRNaHUB5F1yUGOuugDCUMY+qREnqQbYMjraRsA7DkXgnyaFi+MiJnm+MPBIbd
         jDpAONfI042c3K5TYjnpA33ZOQFH86T5TquK36hZ+/ziiN8UmA8jAg6V1Ob1kTq323
         +kv1wERt4NluQ==
Message-ID: <f7d0a759-a8ab-2524-4939-095544d12913@bluematt.me>
Date:   Fri, 30 Apr 2021 14:04:34 -0400
MIME-Version: 1.0
Subject: Re: [PATCH net-next] Reduce IP_FRAG_TIME fragment-reassembly timeout
 to 1s, from 30s
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Keyu Man <kman001@ucr.edu>
References: <d840ddcf-07a6-a838-abf8-b1d85446138e@bluematt.me>
 <CANn89i+L2DuD2+EMHzwZ=qYYKo1A9gw=nTTmh20GV_o9ADxe2Q@mail.gmail.com>
 <0cb19f7e-a9b3-58f8-6119-0736010f1326@bluematt.me>
 <20210428141319.GA7645@1wt.eu>
 <055d0512-216c-9661-9dd4-007c46049265@bluematt.me>
 <CANn89iKfGhNYJVpj4T2MLkomkwPsYWyOof+COVvNFsfVfb7CRQ@mail.gmail.com>
 <64829c98-e4eb-6725-0fee-dc3c6681506f@bluematt.me>
 <1baf048d-18e8-3e0c-feee-a01b381b0168@bluematt.me>
 <CANn89iKJDUQuXBueuZWdi17LgFW3yb4LUsH3hzY08+ytJ9QgeA@mail.gmail.com>
 <c8ad9235-5436-8418-69a9-6c525fd254a4@bluematt.me>
 <CANn89iKJmbr_otzWrC19q5A_gGVRjMKso46=vT6=B9vUC5kgqA@mail.gmail.com>
 <df6fdff3-f307-c631-44e7-15fda817662f@bluematt.me>
From:   Matt Corallo <netdev-list@mattcorallo.com>
In-Reply-To: <df6fdff3-f307-c631-44e7-15fda817662f@bluematt.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/21 13:53, Matt Corallo wrote:
> 
> Buffer bloat exists, but so do networks that will happily drop 1Mbps of packets. The first has always been true, the 
> second only more recently has become more and more common (both due to network speed and application behavior).

It may be worth noting, to further highlight the tradeoffs made here - that, given a constant amount of memory allocated 
for fragment reassembly, *under* estimating the timeout will result in only loss of some % of packets which were 
reordered in excess of the timeout, whereas *over* estimating the timeout results in complete blackhole for up to the 
timeout in the face of material packet loss.

This asymmetry is why I suggested possibly random eviction could be useful as a different set of trade-offs, but I'm 
certainly not qualified to make that determination.

Thanks again for your time and consideration,
Matt
