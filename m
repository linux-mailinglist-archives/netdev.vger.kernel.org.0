Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29384277D4
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 09:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbhJIHHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 03:07:30 -0400
Received: from albireo.enyo.de ([37.24.231.21]:42072 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhJIHH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 03:07:27 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Oct 2021 03:07:27 EDT
Received: from [172.17.203.2] (port=33837 helo=deneb.enyo.de)
        by albireo.enyo.de ([172.17.140.2]) with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mZ6L9-0008IF-KG; Sat, 09 Oct 2021 07:00:15 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.94.2)
        (envelope-from <fw@deneb.enyo.de>)
        id 1mZ6H5-000KtO-B1; Sat, 09 Oct 2021 08:56:03 +0200
From:   Florian Weimer <fw@deneb.enyo.de>
To:     "Cufi, Carles" <Carles.Cufi@nordicsemi.no>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jukka.rissanen@linux.intel.com" <jukka.rissanen@linux.intel.com>,
        "johan.hedberg@intel.com" <johan.hedberg@intel.com>,
        "Lubos, Robert" <Robert.Lubos@nordicsemi.no>,
        "Bursztyka, Tomasz" <tomasz.bursztyka@intel.com>,
        "linux-toolchains@vger.kernel.org" <linux-toolchains@vger.kernel.org>
Subject: Re: Non-packed structures in IP headers
References: <AS8PR05MB78952FE7E8D82245D309DEBCE7AA9@AS8PR05MB7895.eurprd05.prod.outlook.com>
        <87bl48v74v.fsf@oldenburg.str.redhat.com>
        <DB9PR05MB7898339C06B9317EBAB13437E7AE9@DB9PR05MB7898.eurprd05.prod.outlook.com>
Date:   Sat, 09 Oct 2021 08:56:03 +0200
In-Reply-To: <DB9PR05MB7898339C06B9317EBAB13437E7AE9@DB9PR05MB7898.eurprd05.prod.outlook.com>
        (Carles Cufi's message of "Mon, 4 Oct 2021 10:30:34 +0000")
Message-ID: <875yu6bsak.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Carles Cufi:

>> * Carles Cufi:
>> 
>> > I was looking through the structures for IPv{4,6} packet headers and
>> > noticed that several of those that seem to be used to parse a packet
>> > directly from the wire are not declared as packed. This surprised me
>> > because, although I did find that provisions are made so that the
>> > alignment of the structure, it is still technically possible for the
>> > compiler to inject padding bytes inside those structures, since AFAIK
>> > the C standard makes no guarantees about padding unless it's
>> > instructed to pack the structure.
>> 
>> The C standards do not make such guarantees, but the platform ABI
>> standards describe struct layout and ensure that there is no padding.
>> Linux relies on that not just for networking, but also for the userspace
>> ABI, support for separately compiled kernel modules, and in other places.
>
> That makes sense, but aren't ABI standards different for every
> architecture? For example, I checked the Arm AAPCS[1] and it states:
>
> "The size of an aggregate shall be the smallest multiple of its
> alignment that is sufficient to hold all of its members."
>
> Which, unless I am reading this wrong, means that the compiler would
> indeed insert padding if the size of the IP headers structs was not
> a multiple of 4. In this particular case, the struct sizes for the
> IP headers are 20 and 40 bytes respectively, so there will be no
> padding inserted. But I only checked a single architecture's ABI (or
> Procedure Call Standard) documentation, is this true for all archs?

For structure layout in memory, there is a large overlap between ABIs.
There is divergence around long long (which is easily avoided by
adding padding manually), and potentially bit fileds (but I haven't
looked at that).

Things only get weird for pass-by-value structs and unions and return
types.
