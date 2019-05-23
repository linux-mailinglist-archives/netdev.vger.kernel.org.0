Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84CA28284
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfEWQRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730899AbfEWQRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 12:17:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 505A663162;
        Thu, 23 May 2019 16:17:12 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25738414B;
        Thu, 23 May 2019 16:17:08 +0000 (UTC)
Date:   Thu, 23 May 2019 18:17:04 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: pmtu: Simplify cleanup and
 namespace names
Message-ID: <20190523181704.0e3b6926@redhat.com>
In-Reply-To: <8b642166-e0f9-cfb7-8e19-5a46f58549b6@gmail.com>
References: <20190522191106.15789-1-dsahern@kernel.org>
        <20190523095817.45ca9cae@redhat.com>
        <8b642166-e0f9-cfb7-8e19-5a46f58549b6@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 23 May 2019 16:17:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 09:41:59 -0600
David Ahern <dsahern@gmail.com> wrote:

> I have been using the namespace override for a while now. I did consider
> impacts to the above, but my thinking is this: exceptions are per FIB
> entry (per fib6_nh with my latest patch set, but point still holds), FIB
> entries are per FIB table, FIB tables are per network namespace. Running
> multiple pmtu.sh sessions in parallel can not trigger an interdependent
> bug because of that separation. The cleanup within a namespace teardown
> (reference count leaks) should not be affected.

I see, I guess it makes sense.

> Now that we have good set of functional tests, we do need more complex
> tests but those will still be contained within the namespace separation.
> If you look at my current patch set on the list I add an icmp_redirect
> test script. It actually does redirect, verify, mtu on top of redirect,
> verify and then resets and inverts the order - going after an exception
> entry with an update for both use cases.
> 
> For the pmtu script, perhaps the next step is something as simple as
> configuring the setup and routing once and then run all of the
> individual tests (or multiple of them) to generate multiple exceptions
> within a single FIB table and then tests to generate multiple exceptions
> with different addresses per entry.

I think, especially given your new icmp_redirect test script, that
another sensible next step would be turning the setup part in pmtu.sh
into some kind of library (also including the VRF setup) that could be
sourced from both scripts. Right now, that looks like a lot of
duplication.

-- 
Stefano
