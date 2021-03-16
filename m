Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC4833DA64
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 18:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbhCPRNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 13:13:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239187AbhCPRMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 13:12:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615914768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tghCewAv/5TZkioT4Y6D980NcsprT/vqIHOwxO6DNv8=;
        b=GkrR92jX4+rSfPB23VhI8TXT3CFyVkTnDyJ0B+o1GgeiEUdgeTvn/u2yaMfwCFnUXxcIJd
        bPeNioFoqGO1bPIEfxtU3gR7G4ifTVfABWpd7+64JJN7ibxpM7fkZEsffas5KjB57HGQpk
        3bJvNq1Y3g9injuzKp97mHbFpTwgffw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-sg5M3lc9NVKrs2xQ8AntYQ-1; Tue, 16 Mar 2021 13:12:46 -0400
X-MC-Unique: sg5M3lc9NVKrs2xQ8AntYQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C29A3800FF0;
        Tue, 16 Mar 2021 17:12:44 +0000 (UTC)
Received: from horizon.localdomain (ovpn-120-13.rdu2.redhat.com [10.10.120.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F6475D9DC;
        Tue, 16 Mar 2021 17:12:44 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id ED6D8C0081; Tue, 16 Mar 2021 14:12:41 -0300 (-03)
Date:   Tue, 16 Mar 2021 14:12:41 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH net] net/sched: cls_flower: fix only mask bit check in
 the validate_ct_state
Message-ID: <YFDnCeQOrOKiQdV9@horizon.localdomain>
References: <1615880657-10364-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615880657-10364-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Mar 16, 2021 at 03:44:17PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The ct_state validate should not only check the mask bit and also
> check the state bit.
> For the +new+est case example, The 'new' and 'est' bits should be
> set in both state_mask and state flags. Or the -new-est case also
> will be reject by kernel.

Please mention why +trk-new-est is expected.

> 
> Fixes: 	1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules")
> Fixes: 	3aed8b63336c ("net/sched: cls_flower: validate ct_state for invalid and reply flags")

checkpatch.pl doesn't complain but I'm not sure if a tab is allowed here, btw.

> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/sched/cls_flower.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index d097b5c..92659e1 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -1401,31 +1401,37 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>  	return 0;
>  }
>  
> -static int fl_validate_ct_state(u16 state, struct nlattr *tb,
> +static int fl_validate_ct_state(u16 state_mask, u16 state,
> +				struct nlattr *tb,

The key/mask ordering is becoming messy in flower.
As this function gets called from fl_set_key_ct, please lets keep what was used
there: key, mask. Seems it's still the dominant one.
  static int fl_set_key_ct(struct nlattr **tb,
                           struct flow_dissector_key_ct *key,
                           struct flow_dissector_key_ct *mask,

On a similar note, I'm wondering if it worth just doing:
	u16 effective = state & state_mask;
To avoid this many checks below against key and mask simultaneously.

>  				struct netlink_ext_ack *extack)
>  {
> -	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> +	if (state_mask && !(state_mask & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
>  		NL_SET_ERR_MSG_ATTR(extack, tb,
>  				    "no trk, so no other flag can be set");
>  		return -EINVAL;
>  	}
>  
> -	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	if (state_mask & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	    state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	    state_mask & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED &&
>  	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
>  		NL_SET_ERR_MSG_ATTR(extack, tb,
>  				    "new and est are mutually exclusive");
>  		return -EINVAL;
>  	}
>  
> -	if (state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
> -	    state & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
> +	if (state_mask & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
> +	    state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
> +	    state_mask & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
>  		      TCA_FLOWER_KEY_CT_FLAGS_INVALID)) {

An indent adjust here is welcomed.

Thanks,
Marcelo

>  		NL_SET_ERR_MSG_ATTR(extack, tb,
>  				    "when inv is set, only trk may be set");
>  		return -EINVAL;
>  	}
>  
> -	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	if (state_mask & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	    state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	    state_mask & TCA_FLOWER_KEY_CT_FLAGS_REPLY &&
>  	    state & TCA_FLOWER_KEY_CT_FLAGS_REPLY) {
>  		NL_SET_ERR_MSG_ATTR(extack, tb,
>  				    "new and rpl are mutually exclusive");
> @@ -1451,7 +1457,7 @@ static int fl_set_key_ct(struct nlattr **tb,
>  			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
>  			       sizeof(key->ct_state));
>  
> -		err = fl_validate_ct_state(mask->ct_state,
> +		err = fl_validate_ct_state(mask->ct_state, key->ct_state,
>  					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
>  					   extack);
>  		if (err)
> -- 
> 1.8.3.1
> 

