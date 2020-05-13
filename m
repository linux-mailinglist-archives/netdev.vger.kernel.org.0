Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4E1D1F67
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390755AbgEMTii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:38:38 -0400
Received: from mail.efficios.com ([167.114.26.124]:36782 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732626AbgEMTih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:38:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id E56E42BD8E7;
        Wed, 13 May 2020 15:38:35 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id EdVF3ZjFOAPe; Wed, 13 May 2020 15:38:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 9B7E32BD8E6;
        Wed, 13 May 2020 15:38:35 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 9B7E32BD8E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1589398715;
        bh=W7Fi27HMs3xcXMs3/c0ZIWP7wGZIeXMC5xcLnPV/8NU=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=j0p6SIqoQm7EwhaBLW+kWxlRbeZrU/USPnDxeLJz/XUDkN/KAQBUK0gQHsleCgnhU
         CAxECLTsUlEhpDybEy8bCmNp0Rk7cUqJaPCVrfA1Atze+6n+rtNQwUmc9whg+cwSIC
         kfMPSA8d+5Rgumnrg+Lw12o1+XiTaNcONDVWhmpBDzrSVghKDxBlhA9DogDmTmdZP2
         5MRwDVGV/NjcXAJZ13KUpQ45WA78iI/V36rsqcUDviTNRayCd2dwt+qjQ0QPv8Th31
         0cmOJAZMBXLRBel60VLJuahfEt7/Si7GofIIw8ixbzuIC9uWJirsWtYqxMKy7+EEG2
         Q6SH0cnUVd+yA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id iN0qKPAMr3wt; Wed, 13 May 2020 15:38:35 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 8CBEF2BD939;
        Wed, 13 May 2020 15:38:35 -0400 (EDT)
Date:   Wed, 13 May 2020 15:38:35 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Message-ID: <341326348.19635.1589398715534.JavaMail.zimbra@efficios.com>
Subject: [regression] TC_MD5SIG on established sockets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3928 (ZimbraWebClient - FF76 (Linux)/8.8.15_GA_3928)
Thread-Index: VOzrMcTkJnQRmnFkM79HnTFxDREPXw==
Thread-Topic: TC_MD5SIG on established sockets
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am reporting a regression with respect to use of TCP_MD5SIG/TCP_MD5SIG_EXT
on established sockets. It is observed by a customer.

This issue is introduced by this commit:

commit 721230326891 "tcp: md5: reject TCP_MD5SIG or TCP_MD5SIG_EXT on established sockets"

The intent of this commit appears to be to fix a use of uninitialized value in
tcp_parse_options(). The change introduced by this commit is to disallow setting
the TCP_MD5SIG{,_EXT} socket options on an established socket.

The justification for this change appears in the commit message:

   "I believe this was caused by a TCP_MD5SIG being set on live
    flow.
    
    This is highly unexpected, since TCP option space is limited.
    
    For instance, presence of TCP MD5 option automatically disables
    TCP TimeStamp option at SYN/SYNACK time, which we can not do
    once flow has been established.
    
    Really, adding/deleting an MD5 key only makes sense on sockets
    in CLOSE or LISTEN state."

However, reading through RFC2385 [1], this justification does not appear
correct. Quoting to the RFC:

   "This password never appears in the connection stream, and the actual
    form of the password is up to the application. It could even change
    during the lifetime of a particular connection so long as this change
    was synchronized on both ends"

The paragraph above clearly underlines that changing the MD5 signature of
a live TCP socket is allowed.

I also do not understand why it would be invalid to transition an established
TCP socket from no-MD5 to MD5, or transition from MD5 to no-MD5. Quoting the
RFC:

  "The total header size is also an issue.  The TCP header specifies
   where segment data starts with a 4-bit field which gives the total
   size of the header (including options) in 32-byte words.  This means
   that the total size of the header plus option must be less than or
   equal to 60 bytes -- this leaves 40 bytes for options."

The paragraph above seems to be the only indication that some TCP options
cannot be combined on a given TCP socket: if the resulting header size does
not fit. However, I do not see anything in the specification preventing any
of the following use-cases on an established TCP socket:

- Transition from no-MD5 to MD5,
- Transition from MD5 to no-MD5,
- Changing the MD5 key associated with a socket.

As long as the resulting combination of options does not exceed the available
header space.

Can we please fix this KASAN report in a way that does not break user-space
applications expectations about Linux' implementation of RFC2385 ?

Thanks,

Mathieu

[1] RFC2385: https://tools.ietf.org/html/rfc2385

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
