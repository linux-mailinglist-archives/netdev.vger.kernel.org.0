Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B71C302955
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731198AbhAYRv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731004AbhAYRu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:50:56 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFF7C061A2B
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 09:50:08 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1l4603-0005MA-W0; Mon, 25 Jan 2021 18:50:04 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1l45rP-001yMp-9a; Mon, 25 Jan 2021 18:41:07 +0100
Date:   Mon, 25 Jan 2021 18:41:07 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     netdev@vger.kernel.org, pbshelar@fb.com, kuba@kernel.org,
        pablo@netfilter.org
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
Message-ID: <YA8Cs3SD1zeR2JWz@nataraja>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
 <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonas,

thanks for your detailed analysis and review of the changes.  To me, they
once again show that the original patch was merged too quickly, without
a detailed review by people with strong GTP background.

On Sun, Jan 24, 2021 at 03:21:21PM +0100, Jonas Bonn wrote:
> struct gtpu_metadata {
>         __u8    ver;
>         __u8    flags;
>         __u8    type;
> };
> 
> Here ver is the version of the metadata structure itself, which is fine.
> 'flags' corresponds to the 3 flag bits of GTP header's first byte:  E, S,
> and PN.
> 'type' corresponds to the 'message type' field of the GTP header.

One more comment on the 'type': Of how much use is it?  After all, the
GTP-U kernel driver only handles a single message type at all (G-PDU /
255 - the only message type that encapsulates user IP data), while all
other message types are always processed in userland via the UDP socket.

Side-note: 3GPP TS 29.060 lists 5 other message types that can happen in
GTP-U:
* Echo Request
* Echo Response
* Error Indication
* Supported Extension Headers Notification
* End Marker

It would be interesting to understand how the new flow-based tunnel would
treat those, if those 

> The 'control header' (strange name) example below allows the flags to be
> set; however, setting these flags alone is insufficient because each one
> indicates the presence of additional fields in the header and there's
> nothing in the code to account for that.

Full ACK from my side here.  Setting arbitrary bits in the GTP flags without
then actually encoding the required additional bits that those flags require
will produce broken packets.  IMHO, the GTP driver should never do that.

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
