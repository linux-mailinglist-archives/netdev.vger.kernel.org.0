Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319DB33F665
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhCQROx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:14:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231134AbhCQRO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 13:14:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616001268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zgDf8/f0T6Z9b6Xhet7bGn/DNFzIjkiigD2F7Oi40CE=;
        b=CEZX8Sf2zRFSj/pHnHxiRrLi65a6YBzIAnaNnvhE/ceD2sAlxhOTEA54F1WhKiqmEc2Hu0
        CNSGncdF69O9EYdFdapTPgYZOtir4l6i+Yl1WoB9xAtFQ+4nejLyX4RiknbTXFFmJbrQqi
        c8KkYmRtQS2pjI6oi97C0Rd2SyHOFfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-7unjRQ25PA6d5uy41toEEw-1; Wed, 17 Mar 2021 13:14:26 -0400
X-MC-Unique: 7unjRQ25PA6d5uy41toEEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E60F801817;
        Wed, 17 Mar 2021 17:14:25 +0000 (UTC)
Received: from horizon.localdomain (ovpn-120-13.rdu2.redhat.com [10.10.120.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE93810016F8;
        Wed, 17 Mar 2021 17:14:24 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 538D6C009B; Wed, 17 Mar 2021 14:14:22 -0300 (-03)
Date:   Wed, 17 Mar 2021 14:14:22 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH net v2] net/sched: cls_flower: fix only mask bit check in
 the validate_ct_state
Message-ID: <YFI47uLmNKCrVhgv@horizon.localdomain>
References: <1615953763-23824-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615953763-23824-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 12:02:43PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The ct_state validate should not only check the mask bit and also
> check mask_bit & key_bit..
> For the +new+est case example, The 'new' and 'est' bits should be
> set in both state_mask and state flags. Or the -new-est case also
> will be reject by kernel.
> When Openvswitch with two flows
> ct_state=+trk+new,action=commit,forward
> ct_state=+trk+est,action=forward
> 
> A packet go through the kernel  and the contrack state is invalid,
> The ct_state will be +trk-inv. Upcall to the ovs-vswitchd, the
> finally dp action will be drop with -new-est+trk.
> 
> Fixes: 1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules")
> Fixes: 3aed8b63336c ("net/sched: cls_flower: validate ct_state for invalid and reply flags")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/sched/cls_flower.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index d097b5c..c69a4ba 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -1451,7 +1451,7 @@ static int fl_set_key_ct(struct nlattr **tb,
>  			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
>  			       sizeof(key->ct_state));
>  
> -		err = fl_validate_ct_state(mask->ct_state,
> +		err = fl_validate_ct_state(key->ct_state & mask->ct_state,

Or that, yes. The thing I was wondering on this is if it would be a
problem to have something like
key = trk,inv
mask = trk,new,est,inv
because in essence, this is +trk+inv-new-est, and it's worrying about
bits that shouldn't be considered if +inv is there.
I don't see a reason for it to be that restrictive, though, and it
will work as expected.

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

>  					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
>  					   extack);
>  		if (err)
> -- 
> 1.8.3.1
> 

