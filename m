Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 176D159CFE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 15:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfF1NgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 09:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59054 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbfF1NgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 09:36:06 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ACBAE3DDB6;
        Fri, 28 Jun 2019 13:36:05 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFBA31001284;
        Fri, 28 Jun 2019 13:35:54 +0000 (UTC)
Date:   Fri, 28 Jun 2019 15:35:52 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net,
        maciejromanfijalkowski@gmail.com, brouer@redhat.com
Subject: Re: [PATCH 3/3, net-next] net: netsec: add XDP support
Message-ID: <20190628153552.78a8c5ad@carbon>
In-Reply-To: <1561718355-13919-4-git-send-email-ilias.apalodimas@linaro.org>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-4-git-send-email-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 28 Jun 2019 13:36:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 13:39:15 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> +static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct net_device *dev = priv->ndev;
> +	struct bpf_prog *old_prog;
> +
> +	/* For now just support only the usual MTU sized frames */
> +	if (prog && dev->mtu > 1500) {
> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (netif_running(dev))
> +		netsec_netdev_stop(dev);
> +
> +	/* Detach old prog, if any */
> +	old_prog = xchg(&priv->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	if (netif_running(dev))
> +		netsec_netdev_open(dev);

Shouldn't the if-statement be if (!netif_running(dev))

> +
> +	return 0;
> +}



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
