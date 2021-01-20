Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82E2FC7A5
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbhATCSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:18:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbhATCRy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:17:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CA552245C;
        Wed, 20 Jan 2021 02:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611109034;
        bh=tzBRI2iJqo9Fxtv0cbrzLs20Vy92BRbkv584AvZjLko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cv+mfRRcsnT4towJsQZiceljfbpfCHnyH35v7Wp6Y6YaQpE9DwvU0dJATGr//52Zh
         7AjlP5lU0BMdvqaTTGJ0xca65nj4Ttc6x5PVnqGG2JC/F+ynF6iSHbDp3hj0lhH3rI
         TcNZS4t4vgVG0jg2bsZ4rj0AA54zrJ72VfLkkBsrWIRIgReOJHlKVXsJ2OL0t+22Yj
         LMustdP47F0s3O1hnvt+1CK5jepcMkzA48k4/w8A0rdkSOZ0nmlhL8Sxf8jmecxEeY
         wmquEIZZRd5qVCCw+AbgStqpnfhV3SQXqmVignf3tT11JmGatgHL7yFm8Sgw0nvQO2
         ttURDrx/ES82Q==
Date:   Tue, 19 Jan 2021 18:17:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net-next v2 1/8] ethtool: Add support for configuring
 frame preemption
Message-ID: <20210119181712.18f0ee24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119004028.2809425-2-vinicius.gomes@intel.com>
References: <20210119004028.2809425-1-vinicius.gomes@intel.com>
        <20210119004028.2809425-2-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 16:40:21 -0800 Vinicius Costa Gomes wrote:
> +  ====================================  ======  ==========================
> +  ``ETHTOOL_A_CHANNELS_HEADER``         nested  request header

ETHTOOL_A_PREEMPT_HEADER

> +  ====================================  ======  ==========================
> +
> +Kernel response contents:
> +
> +  =====================================  ======  ==========================
> +  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header

here as well

> +  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
> +  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
> +  =====================================  ======  ==========================
> +
> +``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE`` configures the minimum non-final
> +fragment size that the receiver device supports.
> +
> +PREEMPT_SET
> +============
> +
> +Sets frame preemption parameters.
> +
> +Request contents:
> +
> +  =====================================  ======  ==========================
> +  ``ETHTOOL_A_CHANNELS_HEADER``          nested  reply header

and here

> +  ``ETHTOOL_A_PREEMPT_ENABLED``          u8      frame preemption enabled
> +  ``ETHTOOL_A_PREEMPT_ADD_FRAG_SIZE``    u32     Min additional frag size
> +  =====================================  ======  ==========================

> +struct netlink_ext_ack;

Let's move it all the way to the top, right after header includes, so
we don't have to move it again.

> +/**
> + * Convert from a Frame Preemption Additional Fragment size in bytes
> + * to a multiplier. The multiplier is defined as:
> + *	"A 2-bit integer value used to indicate the minimum size of
> + *	non-final fragments supported by the receiver on the given port
> + *	associated with the local System. This value is expressed in units
> + *	of 64 octets of additional fragment length."
> + *	Equivalent to `30.14.1.7 aMACMergeAddFragSize` from the IEEE 802.3-2018
> + *	standard.

Please double check the correct format for kdoc:

https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html

This comment should also be next to the definition of the function, 
not in the header.

> + * @frag_size: minimum non-final fragment size in bytes
> + *
> + * Returns the multiplier.
> + */
> +u8 ethtool_frag_size_to_mult(u32 frag_size);
