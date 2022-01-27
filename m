Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75E249E1BA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 12:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbiA0L5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 06:57:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:62047 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241124AbiA0L5A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 06:57:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643284620; x=1674820620;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=DWnN5z/3/Ka4kDGpL0eM48NBXFbTbVUtYTk1y+OcQGI=;
  b=enWi5wMmFl+1raU23meBjeRcXq5Q1PQOOuqO+y7ezGU0cC2FtCwExeHA
   gNsZcF/BFx7oiqrrvLDomQFypw2q3EMXNX4zCDq3tQ104dYDuZ0O77d8z
   Kfy68d23+wPX3tLGzk02UcGSXfap8oJDzzvH6J5ka0bp7ZkNuIz/lWtfC
   /wbeyEh+lUZtawJq5fZApOFlD6dN+7GbzAOFBTig0+Z8FwsrYS0PZ2ga4
   DY4goLRF6hIqaJKzjjHaqKP3gQ0Naeju3CXt5rBCLgWb6SjxGmwVrCFVD
   WZv7sW+bXciewFQOUgO5jsIJn2vj/89JZ+17GsTV1NqciQVxkaHOQCOXY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="230403147"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="230403147"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 03:56:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="535620931"
Received: from shochwel-mobl.ger.corp.intel.com ([10.249.44.153])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 03:56:54 -0800
Date:   Thu, 27 Jan 2022 13:56:52 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 06/13] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
In-Reply-To: <20220114010627.21104-7-ricardo.martinez@linux.intel.com>
Message-ID: <7f50bddd-194-711c-1072-df6d2793@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-7-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> 
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.
> 
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---


> +		memcpy(skb_put(skb_ccci, actual_len), skb->data + i * (txq_mtu - CCCI_H_ELEN),
> +		       actual_len);

Use skb_put_data().

> +		t7xx_port_proxy_set_seq_num(port_private, ccci_h);
> +
> +		ret = t7xx_port_send_skb_to_md(port_private, skb_ccci, true);
> +		if (ret) {
> +			dev_err(port_private->dev, "Write error on %s port, %d\n",
> +				port_static->name, ret);
> +			dev_kfree_skb_any(skb_ccci);

Free first.

> +static void t7xx_port_wwan_uninit(struct t7xx_port *port)
> +{
> +	if (port->wwan_port) {
> +		if (port->chn_crt_stat) {
...
> +     if (port->chn_crt_stat != port->chan_enable)
...
> +     if (port->chn_crt_stat != port->chan_enable)

I don't see anything that would ever make chn_crt_stat true.

> +struct port_ops wwan_sub_port_ops = {
> +	.init = &t7xx_port_wwan_init,
> +	.recv_skb = &t7xx_port_wwan_recv_skb,
> +	.uninit = &t7xx_port_wwan_uninit,
> +	.enable_chl = &t7xx_port_wwan_enable_chl,
> +	.disable_chl = &t7xx_port_wwan_disable_chl,
> +	.md_state_notify = &t7xx_port_wwan_md_state_notify,

Drop & from these (in all patches).


-- 
 i.

