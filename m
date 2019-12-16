Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5B71211BF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfLPR2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:28:20 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726092AbfLPR2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 12:28:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576517298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S+OnBpVV8rY44ew+BfGEOQiPkn4U70SDNIQE2X8a82Y=;
        b=asqKFTtqxzCA+BG79H+rL0dXdgrSOHtLlVSdXC8l5us8KJ4Cmoq6qBCLZjfs4H/JAZAy2g
        LfJZg4wwrQoVW4QEZYKve08ic2fGeyDubU2o7SkyPWSmYxikKJQWHtmkC1499hxWqB3dIl
        eVs2Od9z7Y96OlMS4o3zEhyFa35ZrX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-v1WcVcIaNkSP4kDjcrsa-A-1; Mon, 16 Dec 2019 12:28:17 -0500
X-MC-Unique: v1WcVcIaNkSP4kDjcrsa-A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D65E98017DF;
        Mon, 16 Dec 2019 17:28:15 +0000 (UTC)
Received: from ovpn-118-91.ams2.redhat.com (unknown [10.36.118.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5A155C298;
        Mon, 16 Dec 2019 17:28:14 +0000 (UTC)
Message-ID: <efc70920e3dcdb694ad5791b845f4cf05478b07f.camel@redhat.com>
Subject: Re: [MPTCP] Re: [PATCH net-next 09/11] tcp: Check for filled TCP
 option space before SACK
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, mptcp@lists.01.org
Date:   Mon, 16 Dec 2019 18:28:13 +0100
In-Reply-To: <d5b3a6ed-fb57-e74d-ef63-ebc4ce49e4b7@gmail.com>
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com>
         <20191213230022.28144-10-mathew.j.martineau@linux.intel.com>
         <47545b88-94db-e9cd-2f9f-2c6d665246e2@gmail.com>
         <b9833b748f61c043a2827daee060d4ad4171996e.camel@redhat.com>
         <d5b3a6ed-fb57-e74d-ef63-ebc4ce49e4b7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-12-16 at 08:55 -0800, Eric Dumazet wrote:
> On 12/16/19 4:52 AM, Paolo Abeni wrote:
> > Thank you for the feedback!
> > 
> > Unfortunatelly, the above commit is not enough when MPTCP is enabled,
> > as, without this patch, we can reach the following code:
> > 
> > 		const unsigned int remaining = MAX_TCP_OPTION_SPACE - size;
> > 		opts->num_sack_blocks =
> > 			min_t(unsigned int, eff_sacks,
> > 			      (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
> > 			      TCPOLEN_SACK_PERBLOCK);
> > 
> > with 'size == MAX_TCP_OPTION_SPACE' and num_sack_blocks will be
> > miscalculated. So we need 'fix' but only for MPTCP/when MPTCP is
> > enabled. Still ok for a -net commit?
> > 
> 
> Does it means MPTCP flows can not use SACK at all ? That would be very bad.
> 
> What is the size of MPTCP options ?

MPTCP DSS+ACK+csum is up to 28 bytes, but an MPTCP stream does not need
to attach such option to each packet.

Bare MPTCP ACK are at most 12 bytes, so there is enough room for sack.

The MPTCP specs allow for different opt sizes, because e.g. sequence
numbers can be either 32 or 64 bits. Currently we only implement 64
bits seq.

Paolo


