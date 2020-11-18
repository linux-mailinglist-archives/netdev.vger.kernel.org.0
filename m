Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECA552B82AE
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgKRRHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:07:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727312AbgKRRHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:07:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605719250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NdNmVhxUL+qsjlMu7MBgepNggunU41E/mqKsIBpVtwM=;
        b=bHPPLzjH1fQ+tggM19rP4DfpXDWMUbilirC6mYqk6mhEMqYODa/6ChEO+LnZMC2IW9bGLG
        aXayjPcwfE3y7z93SvIc68P4YUPYIYHsTj4ZvzKe6v+lAMD7zNvQZthHXA5pRcOP9SXJxY
        6nRblaHMVDrytfivU0zhETzymwJfLfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-_B3r3OoxOt2aQ0BPEHa0SQ-1; Wed, 18 Nov 2020 12:07:28 -0500
X-MC-Unique: _B3r3OoxOt2aQ0BPEHa0SQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4338164098;
        Wed, 18 Nov 2020 17:07:26 +0000 (UTC)
Received: from [10.40.195.8] (unknown [10.40.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4F535D9CA;
        Wed, 18 Nov 2020 17:07:23 +0000 (UTC)
Message-ID: <be2382dca0d817a4b5ac5b9820307ec82ce30c96.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: act_mpls: ensure LSE is pullable before
 reading it
From:   Davide Caratti <dcaratti@redhat.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, gnault@redhat.com
In-Reply-To: <20201118164719.GL3913@localhost.localdomain>
References: <e14a44135817430fc69b3c624895f8584a560975.1605716949.git.dcaratti@redhat.com>
         <20201118164719.GL3913@localhost.localdomain>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 18 Nov 2020 18:07:22 +0100
MIME-Version: 1.0
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 13:47 -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Nov 18, 2020 at 05:36:52PM +0100, Davide Caratti wrote:
> 
> Hi,
> 
> >  	case TCA_MPLS_ACT_MODIFY:
> > +		if (!pskb_may_pull(skb,
> > +				   skb_network_offset(skb) + sizeof(new_lse)))
> > +			goto drop;
> >  		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
> >  		if (skb_mpls_update_lse(skb, new_lse))
> >  			goto drop;
> 
> Seems TCA_MPLS_ACT_DEC_TTL is also affected. skb_mpls_dec_ttl() will
> also call mpls_hdr(skb) without this check.
> 
>   Marcelo
> 
... yes, correct; and at a first glance, also set_mpls() in
openvswitch/action.c has the same (theoretical) issue. I will follow-up
with other 2 patches, ok?

thanks!
-- 
davide

