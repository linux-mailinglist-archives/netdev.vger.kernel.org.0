Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A02DA20E3E
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbfEPRv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbfEPRv5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 13:51:57 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 242B4301E12F;
        Thu, 16 May 2019 17:51:57 +0000 (UTC)
Received: from localhost (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B6A75D968;
        Thu, 16 May 2019 17:51:55 +0000 (UTC)
Date:   Thu, 16 May 2019 19:51:40 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net] selftests: pmtu.sh: Remove quotes around commands
 in setup_xfrm
Message-ID: <20190516195140.158e602f@redhat.com>
In-Reply-To: <20190516174131.19473-1-dsahern@kernel.org>
References: <20190516174131.19473-1-dsahern@kernel.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 16 May 2019 17:51:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 10:41:31 -0700
David Ahern <dsahern@kernel.org> wrote:

> From: David Ahern <dsahern@gmail.com>
> 
> The first command in setup_xfrm is failing resulting in the test getting
> skipped:
> 
> + ip netns exec ns-B ip -6 xfrm state add src fd00:1::a dst fd00:1::b spi 0x1000 proto esp aead 'rfc4106(gcm(aes))' 0x0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f 128 mode tunnel
> + out=RTNETLINK answers: Function not implemented

Thanks for fixing this, I ran into this issue right today and I was
about to send a patch too. For the record, the quotes went all the way
into xfrm_alg_name_match():

	name: 'rfc4106(gcm(aes))'
	entry->name: rfc4106(gcm(aes))

My solution was to remove the single quotes around 'rfc4106(gcm(aes))',
but I just checked yours and it also works on bash and dash, so I don't
really have a preference.

> ...
>   xfrm6 not supported
> TEST: vti6: PMTU exceptions                                         [SKIP]
>   xfrm4 not supported
> TEST: vti4: PMTU exceptions                                         [SKIP]
> ...
> 
> The setup command started failing when the run_cmd option was added.
> Removing the quotes fixes the problem:
> ...
> TEST: vti6: PMTU exceptions                                         [ OK ]
> TEST: vti4: PMTU exceptions                                         [ OK ]
> ...
> 
> Fixes: 56490b623aa0 ("selftests: Add debugging options to pmtu.sh")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Reviewed-and-tested-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano
