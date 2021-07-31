Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152AD3DC822
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 22:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhGaUbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 16:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229560AbhGaUbE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 16:31:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 443E660E09;
        Sat, 31 Jul 2021 20:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627763457;
        bh=66QtAShc7VIevIPQeozjmro+dtz929C8X+1cefYhXGw=;
        h=Date:From:To:Subject:From;
        b=jpXy4eLhxc9H4eLj4+CqqB5SRG2ItW5x24+sX0mpl9fNrJKHFFrsWZnyBWYEZII2y
         HbFtfCjLdZz+pkpd3JfcX9dVoO43CPCqA+52PfsPVO3TwfZS67AahueS5JpaPTbgNh
         gvsh561xO5gntoAgdovJfezk6oYcUZXc/Dvb6rDDXpgx6fvlRXxLOX5LnMpeXpuEf9
         rdiSufOq4kUNnIaumz+8zLmQG4WKP+2nD/3reZ3L3nQDKq0cN/VvijyKkeeeRJktjo
         5wvbobi6JxmS9XvEZojYhJdMkAO41JkpdA5J99AVdqlTvobTc/cvVovAquWuwyGPIm
         hPhWJ8e74jXyg==
Received: by pali.im (Postfix)
        id B1A91941; Sat, 31 Jul 2021 22:30:54 +0200 (CEST)
Date:   Sat, 31 Jul 2021 22:30:54 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: How to find out name or id of newly created interface
Message-ID: <20210731203054.72mw3rbgcjuqbf4j@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

Via rtnetlink API (RTM_NEWLINK/NLM_F_CREATE) it is possible to create a
new network interface without specifying neither interface name nor id.
This will let kernel to choose some interface name which does not
conflicts with any already existing network interface. So seems like
ideal way if I do not care about interface names. But at some stage it
is needed to "configure" interface and for this action it is required to
know interface id or name (as some ioctls use interface name instead of
id).

And now I would like to know, how to race-free find out interface name
(or id) of this newly created interface?

Response to RTM_NEWLINK/NLM_F_CREATE packet from kernel contains only
buffer with struct nlmsgerr where is just error number (zero for
success) without any additional information.

I can send another rtnetlink packet to request list of all existing
network interfaces and expect that the interface with the highest id was
that one which was created. But it is racy as another process may
meanwhile create another network interface or it may delete this my
newly created one, prior I send this followup packet.
