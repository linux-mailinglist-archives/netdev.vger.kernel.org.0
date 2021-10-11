Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FC942966C
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 20:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbhJKSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 14:06:48 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:51830 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJKSGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 14:06:45 -0400
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 5B7DA200CCF6;
        Mon, 11 Oct 2021 20:04:42 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 5B7DA200CCF6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1633975482;
        bh=lJv2kvvePcZguGAstcULyW2UVXh5EG9tzaCBp4mIYcI=;
        h=From:To:Cc:Subject:Date:From;
        b=HL0cbZKoNqzcPVEjKj0UTqvd0FIdFbRK5p2juy6QvCDD1c5xkFVAwPFI82U4gSthP
         VWkZ4UrFkVBj71zrMoTPTjGF2gCEcrG0/BRf9xuhS4jn6tEq5osU6GcfU8VmBoJ0jB
         AmnDjEgtQ6m+VplpHM6QcsnEXEUkH/5GHkDOh8hBA4yjs9AeXDFITRTk4KUeoeBuND
         fZf+jx06wgrqDgVqIwUQv7FQdGZ0k5jic03lLcDx3a8nEILkzAC/iF3cPykUGHtKjH
         54c5ETm6HkEE1KjYop2OYdDpXzbBugVL7OfdgMko9yIzIgkZRFr5RUV+y8lOmWYdSO
         gPpjf9D3sprWA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, justin.iurman@uliege.be
Subject: [PATCH net 0/2] Correct the IOAM behavior for undefined trace type bits
Date:   Mon, 11 Oct 2021 20:04:10 +0200
Message-Id: <20211011180412.22781-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(@Jakub @David: there will be a conflict for #2 when merging net->net-next, due
to commit [1]. The conflict is only 5-10 lines for #2 (#1 should be fine) inside
the file tools/testing/selftests/net/ioam6.sh, so quite short though possibly
ugly. Sorry for that, I didn't expect to post this one... Had I known, I'd have
made the opposite.)

Modify both the input and output behaviors regarding the trace type when one of
the undefined bits is set. The goal is to keep the interoperability when new
fields (aka new bits inside the range 12-21) will be defined.

The draft [2] says the following:
---------------------------------------------------------------
"Bit 12-21  Undefined.  These values are available for future
       assignment in the IOAM Trace-Type Registry (Section 8.2).
       Every future node data field corresponding to one of
       these bits MUST be 4-octets long.  An IOAM encapsulating
       node MUST set the value of each undefined bit to 0.  If
       an IOAM transit node receives a packet with one or more
       of these bits set to 1, it MUST either:

       1.  Add corresponding node data filled with the reserved
           value 0xFFFFFFFF, after the node data fields for the
           IOAM-Trace-Type bits defined above, such that the
           total node data added by this node in units of
           4-octets is equal to NodeLen, or

       2.  Not add any node data fields to the packet, even for
           the IOAM-Trace-Type bits defined above."
---------------------------------------------------------------

The output behavior has been modified to respect the fact that "an IOAM encap
node MUST set the value of each undefined bit to 0" (i.e., undefined bits can't
be set anymore).

As for the input behavior, current implementation is based on the second choice
(i.e., "not add any data fields to the packet [...]"). With this solution, any
interoperability is lost (i.e., if a new bit is defined, then an "old" kernel
implementation wouldn't fill IOAM data when such new bit is set inside the trace
type).

The input behavior is therefore relaxed and these undefined bits are now allowed
to be set. It is only possible thanks to the sentence "every future node data
field corresponding to one of these bits MUST be 4-octets long". Indeed, the
default empty value (the one for 4-octet fields) is inserted whenever an
undefined bit is set.

  [1] cfbe9b002109621bf9a282a4a24f9415ef14b57b
  [2] https://datatracker.ietf.org/doc/html/draft-ietf-ippm-ioam-data#section-5.4.1

Justin Iurman (2):
  ipv6: ioam: move the check for undefined bits
  selftests: net: modify IOAM tests for undef bits

 net/ipv6/ioam6.c                           |  70 ++++++++-
 net/ipv6/ioam6_iptunnel.c                  |   6 +-
 tools/testing/selftests/net/ioam6.sh       |  26 +++-
 tools/testing/selftests/net/ioam6_parser.c | 164 ++++++++-------------
 4 files changed, 148 insertions(+), 118 deletions(-)

-- 
2.25.1

