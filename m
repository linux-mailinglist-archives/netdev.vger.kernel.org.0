Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7662D313ECD
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhBHTWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:22:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:38862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236176AbhBHTWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80EC364E8B;
        Mon,  8 Feb 2021 19:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612812109;
        bh=HEkPzVSkry8E9YDKVHLo7X6ed7LXeRyARAZV4hqq6HQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pQ+LAvyfo3pc6leD328KjW0jMnSRIHbLQHHEsIXPkhm1StrQ9U1WjjdFIIOSrQ+te
         PDdEjhoTCWPdrnQ9q/AumcxKSQkTsMZfYh08xR0DI9eVgNTGAjt2q5wEhV0RtIQ/KJ
         DiQGODGQbuCHT5Y/xvvGRJ768ozNBCziG5BPdwodzQXaBtG9xPh4+y4WJoV1w40VKN
         s2+FUlXGgbsPliPPZ9UwJt3iPQE/Dv8nWHn2zaFxplWePfjqdZ3eZO3wFMQhkDBzRg
         QoQoF4QhqBz4gRJt91/OaKIew1RT8BKdT/3Kgqpceljw3NMdDHHeU33MQthmUe/fTf
         nHw5H8jijVHgw==
Date:   Mon, 8 Feb 2021 11:21:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>
Cc:     wenxu@ucloud.cn, jhs@mojatatu.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v4] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210208112148.2d8d6d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208185705.GE2953@horizon.localdomain>
References: <1612674803-7912-1-git-send-email-wenxu@ucloud.cn>
        <20210208185705.GE2953@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 15:57:05 -0300 Marcelo Ricardo Leitner wrote:
> On Sun, Feb 07, 2021 at 01:13:23PM +0800, wenxu@ucloud.cn wrote:
> > --- a/net/sched/cls_flower.c
> > +++ b/net/sched/cls_flower.c
> > @@ -30,6 +30,11 @@
> >  
> >  #include <uapi/linux/netfilter/nf_conntrack_common.h>
> >  
> > +#define TCA_FLOWER_KEY_CT_FLAGS_MASK (TCA_FLOWER_KEY_CT_FLAGS_NEW | \
> > +				      TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED | \
> > +				      TCA_FLOWER_KEY_CT_FLAGS_RELATED | \
> > +				      TCA_FLOWER_KEY_CT_FLAGS_TRACKED)
> > +  
> 
> I know Jakub had said the calculations for _MASK were complicated, but
> seeing this, they seem worth, otherwise we have to manually maintain
> this duplicated list of entries here.
> 
> Maybe add just the __TCA_FLOWER_KEY_CT_FLAGS_MAX to the enum, and do
> the calcs here? (to avoid having them in uapi)

IDK, MAX feels rather weird for a bitfield. Someone would have to do no
testing at all to miss extending the mask.

If you strongly prefer to keep the MAX definition let's at least move
the mask definition out of the uAPI.

> >  struct fl_flow_key {
> >  	struct flow_dissector_key_meta meta;
> >  	struct flow_dissector_key_control control;
