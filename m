Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2933D9F3
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhCPQ60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236908AbhCPQ54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 12:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A9065090;
        Tue, 16 Mar 2021 16:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615913876;
        bh=oxhuGO9b1SmSrAYbPEuOOfQaG9uzRwMfD3xsq1qzXws=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cRpbiydlKZLhHHFcdU75i4o/HEUPHpQXJT7ShulfH3OE20GqAnmkMuAiq2+wN4J2F
         BHpNe3gj6B+dE2DVwOkv+QNkx26cJYQfQSr/tfcAeXkKWLkNmrLz/tFWF4VLjSdi/Q
         iy34v8F67nqhwVb7KJepb1ntxu89uBIljlHOt1As/o6zTHd+q7zncCc2UsWmUeH6sP
         LNBsBtPS7Bh77GbRiyQbsgX7AXdNg3LgCXnf2JvJFOrtkPtsAPftmUaV9/JSY2cwjy
         nNBQNpoFlrZ3Le0ix1yM/EirVl7LE9pl0L4Ky4SPaD+hQtqIRlzZK1JjICtSJbW+Pt
         PC647UWDJqDvQ==
Date:   Tue, 16 Mar 2021 09:57:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     mleitner@redhat.com, netdev@vger.kernel.org, jhs@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH net] net/sched: cls_flower: fix only mask bit check in
 the validate_ct_state
Message-ID: <20210316095755.65882158@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615880657-10364-1-git-send-email-wenxu@ucloud.cn>
References: <1615880657-10364-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 15:44:17 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The ct_state validate should not only check the mask bit and also
> check the state bit.
> For the +new+est case example, The 'new' and 'est' bits should be
> set in both state_mask and state flags. Or the -new-est case also
> will be reject by kernel.
> 
> Fixes: 	1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules")
> Fixes: 	3aed8b63336c ("net/sched: cls_flower: validate ct_state for invalid and reply flags")
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

bitwise and operator chains well, BTW, so this could be written as:

	if (state & state_mask & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
	    state & state_mask & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {

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

nit: this needs to be realigned after opening bracket has moved

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

