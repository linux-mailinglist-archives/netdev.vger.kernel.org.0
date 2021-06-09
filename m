Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA0E3A1751
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbhFIOfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:35:18 -0400
Received: from mail.satchell.net ([99.65.194.97]:46590 "EHLO mail.satchell.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237156AbhFIOfQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 10:35:16 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2021 10:35:16 EDT
Received: from c7-i5.satchell.net (unknown [10.1.1.36])
        by mail.satchell.net (Postfix) with ESMTP id 997D7601EF
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 07:26:03 -0700 (PDT)
Reply-To: list@satchell.net
To:     netdev@vger.kernel.org
From:   Stephen Satchell <list@satchell.net>
Subject: Proposed addition to sysctl rp_filter documentation
Message-ID: <ff98f7eb-e21b-b765-f7a0-9c7126043118@satchell.net>
Date:   Wed, 9 Jun 2021 07:26:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been trying to find a definitive description how the IPv4 rp_filter 
actually works in detail, and found nothing in searching around.  There 
are hints here and there, but nothing that spells out how the filter 
works.  So I obeyed the mantra "Use the source, Luke" and dived in. 
This proposal is a distillation of what I found and believe to be 
accurate about how rp_filter works.

I appreciate a review by the people who are deep in the weeds.

After receiving comments, I plan to submit an appropriate page

After looking at the source that appears to implement rp_filter
     linux/net/ipv4/fib_frontend.c
I believe that I now understand the tests rp_filter performs to
validate the source address when net.ipv4.conf.*.rp_filter is
set to one or two for a given interface.  I have also reviewed
the commit history for fib_frontend.c to better understand the
evolution of the code.

Does the new paragraph I have written accurately reflect what
happens?

Description of rp_filter from
https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
--------------------------------------------------------------------
rp_filter - INTEGER
	0 - No source validation.
	1 - Strict mode as defined in RFC3704 Strict Reverse Path
	    Each incoming packet is tested against the FIB and if the
	    interface is not the best reverse path the packet check will
	    fail. By default failed packets are discarded.
	2 - Loose mode as defined in RFC3704 Loose Reverse Path
	    Each incoming packet's source address is also tested against
	    the FIB and if the source address is not reachable via any
	    interface the packet check will fail.

	[*proposed-addition]
	
	Current recommended practice in RFC3704 is to enable strict mode
	to prevent IP spoofing from DDos attacks. If using asymmetric
	routing or other complicated routing, then loose mode is
	recommended.

	The max value from conf/{all,interface}/rp_filter is used
	when doing source validation on the {interface}.

	Default value is 0. Note that some distributions enable it
	in startup scripts.
--------------------------------------------------------------------

Recommended addition where marked with "[*proposed-addition]":
     rp_filter will examine the source address of an incoming IP
     packet by performing an FIB lookup.  In loose mode (value 2),
     the packet is rejected if the source address is neither
     UNICAST nor LOCAL(when interface allows) nor IPSEC.  For
     strict mode (value 1) the interface indicated by the FIB table
     entry must also match the interface on which the packet arrived.
