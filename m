Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DAC676342
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 04:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjAUDLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 22:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjAUDLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 22:11:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C9A30D9;
        Fri, 20 Jan 2023 19:11:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64E9662173;
        Sat, 21 Jan 2023 03:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DB8C433D2;
        Sat, 21 Jan 2023 03:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674270688;
        bh=0Ahj2+lLhgamHf1JuTMBQvTGpUhCziAO+zN7cZlAgC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=svDoaH82a7e6lBsakjnsprasdriJYV5fpwVBhgA/gbE6g9PX1jrqMkqnFVWV7TwLk
         X3Zeg0eteiYeAmcW4hC0VOug9SlqzDWNvm0xxa7emc/RqzNyHkGxro9Yv+DK/dv1Ri
         92r02by2ezsn9dkkE1vsIGlmQ2alDPRKEKLcRaJF8d6O1sRXl57GRf/59sf7GwUGxz
         /Uj2zP+lYxnaRJlyta7+8tVJHeov8gTyUjH/Ewrzo9Wokruj0T9189gPaHDK4fqetZ
         grpMZy67/YX6VoTXviUDO0rdd9cLS3fi7NjGkVRaBYBNCeRi2en3IgVg4BSN8S74w9
         TFu08XGxYEbYw==
Date:   Fri, 20 Jan 2023 19:11:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, niklas.soderlund@corigine.com
Subject: Re: [PATCH bpf-next 1/7] netdev-genl: create a simple family for
 netdev stuff
Message-ID: <20230120191126.06c9d514@kernel.org>
In-Reply-To: <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
References: <cover.1674234430.git.lorenzo@kernel.org>
        <272fa19f57de2d14e9666b4cd9b1ae8a61a94807.1674234430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Jan 2023 18:16:50 +0100 Lorenzo Bianconi wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> Add a Netlink spec-compatible family for netdevs.
> This is a very simple implementation without much
> thought going into it.
> 
> It allows us to reap all the benefits of Netlink specs,
> one can use the generic client to issue the commands:
> 
>   $ ./gen.py --spec netdev.yaml --do dev_get --json='{"ifindex": 2}'
>   {'ifindex': 2, 'xdp-features': 31}
> 
>   $ ./gen.py --spec netdev.yaml --dump dev_get
>   [{'ifindex': 1, 'xdp-features': 0}, {'ifindex': 2, 'xdp-features': 31}]

In the meantime I added support for rendering enums in Python.
So you can show names in the example. eg:

$ ./cli.py --spec netdev.yaml --dump dev_get 
[{'ifindex': 1, 'xdp-features': set()},
 {'ifindex': 2,
  'xdp-features': {'ndo-xmit', 'pass', 'redirect', 'aborted', 'drop'}},
 {'ifindex': 3, 'xdp-features': {'rx-sg'}}]

> the generic python library does not have flags-by-name
> support, yet, but we also don't have to carry strings
> in the messages, as user space can get the names from
> the spec.
> 
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Co-developed-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/netlink/specs/netdev.yaml |  72 ++++++++++

FWIW I'm not 100% sure if we should scope the family to all of netdev
or just xdp. Same for the name of the op, should we call the op dev_get
or dev_xdp_get..

> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> new file mode 100644
> index 000000000000..254fc336d469
> --- /dev/null
> +++ b/include/uapi/linux/netdev.h
> @@ -0,0 +1,66 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/* Do not edit directly, auto-generated from: */

Like this line says, you can't hand edit this file.
Next time someone adds an attribute all your changes will be wiped.

> +/*	Documentation/netlink/specs/netdev.yaml */
> +/* YNL-GEN uapi header */
> +
> +#ifndef _UAPI_LINUX_NETDEV_H
> +#define _UAPI_LINUX_NETDEV_H
> +
> +#define NETDEV_FAMILY_NAME	"netdev"
> +#define NETDEV_FAMILY_VERSION	1
> +
> +enum netdev_xdp_act {
> +	NETDEV_XDP_ACT_ABORTED_BIT,
> +	NETDEV_XDP_ACT_DROP_BIT,
> +	NETDEV_XDP_ACT_PASS_BIT,
> +	NETDEV_XDP_ACT_TX_BIT,
> +	NETDEV_XDP_ACT_REDIRECT_BIT,
> +	NETDEV_XDP_ACT_NDO_XMIT_BIT,
> +	NETDEV_XDP_ACT_XSK_ZEROCOPY_BIT,
> +	NETDEV_XDP_ACT_HW_OFFLOAD_BIT,
> +	NETDEV_XDP_ACT_RX_SG_BIT,
> +	NETDEV_XDP_ACT_NDO_XMIT_SG_BIT

You need to add -bit to all the enum names in the yaml if you want 
to have _BIT in the name here.

> +};
> +
> +#define NETDEV_XDP_ACT_ABORTED		BIT(NETDEV_XDP_ACT_ABORTED_BIT)
> +#define NETDEV_XDP_ACT_DROP		BIT(NETDEV_XDP_ACT_DROP_BIT)
> +#define NETDEV_XDP_ACT_PASS		BIT(NETDEV_XDP_ACT_PASS_BIT)
> +#define NETDEV_XDP_ACT_TX		BIT(NETDEV_XDP_ACT_TX_BIT)
> +#define NETDEV_XDP_ACT_REDIRECT		BIT(NETDEV_XDP_ACT_REDIRECT_BIT)
> +#define NETDEV_XDP_ACT_NDO_XMIT		BIT(NETDEV_XDP_ACT_NDO_XMIT_BIT)
> +#define NETDEV_XDP_ACT_XSK_ZEROCOPY	BIT(NETDEV_XDP_ACT_XSK_ZEROCOPY_BIT)
> +#define NETDEV_XDP_ACT_HW_OFFLOAD	BIT(NETDEV_XDP_ACT_HW_OFFLOAD_BIT)
> +#define NETDEV_XDP_ACT_RX_SG		BIT(NETDEV_XDP_ACT_RX_SG_BIT)
> +#define NETDEV_XDP_ACT_NDO_XMIT_SG	BIT(NETDEV_XDP_ACT_NDO_XMIT_SG_BIT)
> +
> +#define NETDEV_XDP_ACT_BASIC		(NETDEV_XDP_ACT_DROP |	\
> +					 NETDEV_XDP_ACT_PASS |	\
> +					 NETDEV_XDP_ACT_TX |	\
> +					 NETDEV_XDP_ACT_ABORTED)
> +#define NETDEV_XDP_ACT_FULL		(NETDEV_XDP_ACT_BASIC |	\
> +					 NETDEV_XDP_ACT_REDIRECT)
> +#define NETDEV_XDP_ACT_ZC		(NETDEV_XDP_ACT_FULL |	\
> +					 NETDEV_XDP_ACT_XSK_ZEROCOPY)

These defines don't belong in uAPI. Especially the use of BIT().

> +			if (err < 0)
> +				break;
> +cont:
> +			idx++;
> +		}
> +	}
> +
> +	rtnl_unlock();
> +
> +	if (err != -EMSGSIZE)
> +		return err;
> +
> +	cb->args[1] = idx;
> +	cb->args[0] = h;
> +	cb->seq = net->dev_base_seq;
> +	nl_dump_check_consistent(cb, nlmsg_hdr(skb));

I think that this line can be dropped.

> +	return skb->len;
> +}
