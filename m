Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0C2159AE0
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 22:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgBKVBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 16:01:45 -0500
Received: from mga04.intel.com ([192.55.52.120]:28261 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgBKVBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 16:01:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 13:01:45 -0800
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="226631418"
Received: from ahduyck-desk1.jf.intel.com ([10.7.198.76])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 13:01:44 -0800
Message-ID: <142527b01cfab091b2715d093f75fc1c1c4aa939.camel@linux.intel.com>
Subject: Re: Question related to GSO6 checksum magic
From:   Alexander Duyck <alexander.h.duyck@linux.intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 11 Feb 2020 13:01:44 -0800
In-Reply-To: <29eb3035-1777-8b9a-c744-f2996fc5fae1@gmail.com>
References: <29eb3035-1777-8b9a-c744-f2996fc5fae1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-02-11 at 20:48 +0100, Heiner Kallweit wrote:
> Few network drivers like Intel e1000e or r8169 have the following in the
> GSO6 tx path:
> 
> ipv6_hdr(skb)->payload_len = 0;
> tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
> 				       &ipv6_hdr(skb)->daddr,
> 				       0, IPPROTO_TCP, 0);
> (partially also w/o the payload_len assignment)
> 
> This sounds like we should factor it out to a helper.
> The code however leaves few questions to me, but I'm not familiar enough
> with the net core low-level details to answer them:
> 
> - This code is used in a number of drivers, so is it something that
>   should be moved to the core? If yes, where would it belong to?
> 
> - Is clearing payload_len needed? IOW, can it be a problem if drivers
>   miss this?
> 
> Thanks, Heiner

The hardware is expecting the TCP header to contain the partial checksum
minus the length. It does this because it reuses the value when it
computes the checksum for the header of outgoing TCP frames and it will
add the payload length as it is segmenting the frames.

An alternative approach would be to pull the original checksum value out
and simply do the checksum math to subtract the length from it. If I am
not mistaken there are some drivers that take that approach for some of
the headers.

- Alex

