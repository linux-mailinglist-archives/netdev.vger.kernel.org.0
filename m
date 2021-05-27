Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26ACE392F38
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhE0NSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:18:16 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:47318 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235996AbhE0NSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 09:18:15 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPS id BE65C200E2DC;
        Thu, 27 May 2021 15:16:17 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be BE65C200E2DC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622121377;
        bh=YXRz8lwsQCWnbaQEKbiQmlhJx56c9Iy4ULfcXHomTE4=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=k5Pumlh8EJeW0jLkrygftehGcfa/mqX+gz9WsVGjE29TiAIQeGj+uVCYOmGZtj9EV
         v2dzwBQ/W7sKR08xtPzqb5w0+J1oZC0ySYQKOcM+jFkH2qVprzMMj8Z0U82GM7trnk
         AfKh6oBNBMx84rmPUVcfipoDs/iI/hdgXCkZLQN2qCY03ve1TZyll4DhkLywZAtaz1
         nVBI4SMqYlhgDxaubYhz4hDYn2A1aOMRgqMfaqZMnMrJvh9bcUV0VEPk/e0qgVyEOf
         Y3hw/84AtSRBXXJw2+P477MwTyc0aknBDz9o8OmjCjQDNNDqd6cSEOzypVG6AAC+hM
         ML5/iYUa2bDBA==
Received: from localhost (localhost [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id ACC116008D758;
        Thu, 27 May 2021 15:16:17 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HW7L2o_z63bL; Thu, 27 May 2021 15:16:17 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 95ADC6008D377;
        Thu, 27 May 2021 15:16:17 +0200 (CEST)
Date:   Thu, 27 May 2021 15:16:17 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tom@herbertland.com
Message-ID: <310609804.30155335.1622121377545.JavaMail.zimbra@uliege.be>
In-Reply-To: <20210526173402.28ce9ef0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210526171640.9722-1-justin.iurman@uliege.be> <20210526171640.9722-5-justin.iurman@uliege.be> <20210526173402.28ce9ef0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RESEND PATCH net-next v3 4/5] ipv6: ioam: Support for IOAM
 injection with lwtunnels
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [81.240.24.148]
X-Mailer: Zimbra 8.8.15_GA_4018 (ZimbraWebClient - FF88 (Linux)/8.8.15_GA_4026)
Thread-Topic: ipv6: ioam: Support for IOAM injection with lwtunnels
Thread-Index: 0EERLKwjPAWeB0A1YambVKNda3eQAQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, 26 May 2021 19:16:39 +0200 Justin Iurman wrote:
>> Add support for the IOAM inline insertion (only for the host-to-host use case)
>> which is per-route configured with lightweight tunnels. The target is iproute2
>> and the patch is ready. It will be posted as soon as this patchset is merged.
>> Here is an overview:
>> 
>> $ ip -6 ro ad fc00::1/128 encap ioam6 trace type 0x800000 ns 1 size 12 dev eth0
>> 
>> This example configures an IOAM Pre-allocated Trace option attached to the
>> fc00::1/128 prefix. The IOAM namespace (ns) is 1, the size of the pre-allocated
>> trace data block is 12 octets (size) and only the first IOAM data (bit 0:
>> hop_limit + node id) is included in the trace (type) represented as a bitfield.
>> 
>> The reason why the in-transit (IPv6-in-IPv6 encapsulation) use case is not
>> implemented is explained on the patchset cover.
>> 
>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> 
> Please address the warnings from checkpatch --strict on this patches.

My mistake, I'll do that.

> For all patches please make sure you don't use static inline in C
> files, and let the compiler decide what to inline by itself.

Will do as well.

>> +	if (trace->type.bit0) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit1) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit2) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit3) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit4) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit5) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit6) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit7) trace->nodelen += sizeof(__be32) / 4;
>> +	if (trace->type.bit8) trace->nodelen += sizeof(__be64) / 4;
>> +	if (trace->type.bit9) trace->nodelen += sizeof(__be64) / 4;
>> +	if (trace->type.bit10) trace->nodelen += sizeof(__be64) / 4;
>> +	if (trace->type.bit11) trace->nodelen += sizeof(__be32) / 4;
> 
> Seems simpler to do:
> 
>	nodelen += hweight16(field & MASK1) * (sizeof(__be32) / 4);
> 	nodelen += hweight16(field & MASK2) * (sizeof(__be64) / 4);

Indeed, I didn't know this macro. Will post a rev ASAP. Thanks Jakub for the feedback, I appreciate.

Justin
