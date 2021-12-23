Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86BA47E989
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 23:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238216AbhLWW2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 17:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245309AbhLWW21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 17:28:27 -0500
X-Greylist: delayed 1419 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Dec 2021 14:28:02 PST
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A16CC061759
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 14:28:02 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1n0WC7-0004zr-7f
        for netdev@vger.kernel.org; Thu, 23 Dec 2021 23:04:15 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1n0WBR-000mJe-SA
        for netdev@vger.kernel.org;
        Thu, 23 Dec 2021 23:03:33 +0100
Date:   Thu, 23 Dec 2021 23:03:33 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     netdev@vger.kernel.org
Subject: ip xfrm delete / deleteall not able to delete SAs
Message-ID: <YcTyNRqYdBGoEYid@nataraja>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm observing some quite strange behaviour and am wondering what is going
on...

So I have a single SA in the kernel (5.14.16, iproute 5.15.0):

--------------------------------------------------
$ sudo ip xfrm state
src 6.6.6.6 dst 5.5.5.5
        proto esp spi 0x00000000 reqid 2325 mode transport
        replay-window 32 
        auth-trunc hmac(sha1)  96
        enc ecb(cipher_null) 
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 6.6.6.6/32 dst 5.5.5.5/32 sport 2222 dport 1111 
--------------------------------------------------

Then I try to delete it individually and fail

--------------------------------------------------
$ sudo ip xfrm state delete src 6.6.6.6 dst 5.5.5.5 proto esp spi 0
RTNETLINK answers: No such process
--------------------------------------------------

Then I try deleteall and it also fails

--------------------------------------------------
$ sudo ip xfrm state deleteall
Failed to send delete-all request
: No such process
--------------------------------------------------

And finally, the SA still exists:

--------------------------------------------------
$ sudo ip xfrm state
src 6.6.6.6 dst 5.5.5.5
        proto esp spi 0x00000000 reqid 2325 mode transport
        replay-window 32
        auth-trunc hmac(sha1)  96
        enc ecb(cipher_null)
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 6.6.6.6/32 dst 5.5.5.5/32 sport 2222 dport 1111
--------------------------------------------------

The SA is not removed and re-added, there is no automagic other process
running for that.  'ip xfrm monitor' doesn't show any changes at all when
the 'delete' or the 'deleteall' is running.

Flushing via 'ip xfrm state flush' works, but that is sort-of beyond the
point:  Of course I need to be able to selectively delete SAs at runtime
without flushing the entire database.

Selective deletion and deleteall of policies works as expected.  Just SAs
exhibit the strange behavior described above.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
