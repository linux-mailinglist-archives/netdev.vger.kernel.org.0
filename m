Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F051A312019
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhBFUwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:52:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229529AbhBFUwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:52:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1032264DD9;
        Sat,  6 Feb 2021 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612644682;
        bh=QXzXocad7OEM7KXmeipPBabltK3goLGrey1uddwragk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mqch+l4Rw8LZuTxXL3pelwT8FrCfAINZmcTmaKm/tJdrAhG5kQxoQdxtKbelC4EMK
         T7CAqPvi/oX+I3Z9SG/MBgdEcJONZnp421gY9wsETkzG98NClehaB/w0Ln+0GAxEAa
         vggC5HgmwXDwuemPERmWuAAMeHP4UxK7/RgANaJreHjHjMtAKHc+YFBqgsWl5BWrHD
         5xnOu0UkAisWwsBl00TUAAvdIF32fGTW0csWXjK/810GB/qoYJ0hniMVMlcieC9x1d
         /qUqaUg2TC+lp5GHSkjxjkcsh1jluQkOCkMUivgf89f4Mfv0A6eIzS104W2Hs3eCA4
         MWrHmMCmkUlHw==
Date:   Sat, 6 Feb 2021 12:51:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu@ucloud.cn
Cc:     mleitner@redhat.com, netdev@vger.kernel.org, jhs@mojatatu.com
Subject: Re: [PATCH net v3] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210206125121.18e19eaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612508850-11577-1-git-send-email-wenxu@ucloud.cn>
References: <1612508850-11577-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 15:07:30 +0800 wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Reject the unsupported and invalid ct_state flags of cls flower rules.
> 
> Fixes: e0ace68af2ac ("net/sched: cls_flower: Add matching on conntrack info")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: using NLA_POLICY_MASK and NL_SET_ERR_MSG_ATTR
> 
>  include/uapi/linux/pkt_cls.h |  7 +++++++
>  net/sched/cls_flower.c       | 33 ++++++++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index ee95f42..77df582 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -591,8 +591,15 @@ enum {
>  	TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED = 1 << 1, /* Part of an existing connection. */
>  	TCA_FLOWER_KEY_CT_FLAGS_RELATED = 1 << 2, /* Related to an established connection. */
>  	TCA_FLOWER_KEY_CT_FLAGS_TRACKED = 1 << 3, /* Conntrack has occurred. */
> +
> +	__TCA_FLOWER_KEY_CT_FLAGS_MAX,
>  };
>  
> +#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
> +		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
> +#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
> +		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)

This calculation is rather complicated, sorry I missed this the first
time around. And I don't think it needs to be in the uAPI.

>  enum {
>  	TCA_FLOWER_KEY_ENC_OPTS_UNSPEC,
>  	TCA_FLOWER_KEY_ENC_OPTS_GENEVE, /* Nested
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index 84f9325..4aebf4e 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -30,6 +30,9 @@
>  
>  #include <uapi/linux/netfilter/nf_conntrack_common.h>

We can add a define here:

#define TCA_FLOWER_KEY_CT_FLAGS_MASK (TCA_FLOWER_KEY_CT_FLAGS_NEW | \
				       TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED
				       ...

> +#define TCA_FLOWER_KEY_CT_STATE_MASK_TYPE \
> +			NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK)

nit: using a define for policy is also uncommon AFAIK..

>  struct fl_flow_key {
>  	struct flow_dissector_key_meta meta;
>  	struct flow_dissector_key_control control;
> @@ -687,7 +690,7 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
>  	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
>  	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
>  	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
> -	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
> +	[TCA_FLOWER_KEY_CT_STATE_MASK]	= TCA_FLOWER_KEY_CT_STATE_MASK_TYPE,

.. if the line would be long just go to the next one:

	[TCA_FLOWER_KEY_CT_STATE_MASK]	= 
		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK)

>  	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },

