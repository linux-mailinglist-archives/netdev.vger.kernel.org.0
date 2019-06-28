Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA75A13C
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 18:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfF1QpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 12:45:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47548 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfF1Qo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 12:44:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F210A14E03B20;
        Fri, 28 Jun 2019 09:44:58 -0700 (PDT)
Date:   Fri, 28 Jun 2019 09:44:57 -0700 (PDT)
Message-Id: <20190628.094457.246058762133976195.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, maciejromanfijalkowski@gmail.com
Subject: Re: [PATCH 3/3, net-next] net: netsec: add XDP support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190628153552.78a8c5ad@carbon>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-4-git-send-email-ilias.apalodimas@linaro.org>
        <20190628153552.78a8c5ad@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Jun 2019 09:44:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Fri, 28 Jun 2019 15:35:52 +0200

> On Fri, 28 Jun 2019 13:39:15 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
>> +static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
>> +			    struct netlink_ext_ack *extack)
>> +{
>> +	struct net_device *dev = priv->ndev;
>> +	struct bpf_prog *old_prog;
>> +
>> +	/* For now just support only the usual MTU sized frames */
>> +	if (prog && dev->mtu > 1500) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	if (netif_running(dev))
>> +		netsec_netdev_stop(dev);
>> +
>> +	/* Detach old prog, if any */
>> +	old_prog = xchg(&priv->xdp_prog, prog);
>> +	if (old_prog)
>> +		bpf_prog_put(old_prog);
>> +
>> +	if (netif_running(dev))
>> +		netsec_netdev_open(dev);
> 
> Shouldn't the if-statement be if (!netif_running(dev))

Hmmm, does netsec_netdev_stop() clear the running flag?  That just
runs the driver internal routine and doesn't update IFF_UP et
al. which the core networking would do.
