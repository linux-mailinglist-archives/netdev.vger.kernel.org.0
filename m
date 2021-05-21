Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E2F38D157
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 00:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhEUWXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 18:23:31 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:51898 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhEUWXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 18:23:30 -0400
Received: by mail-wm1-f54.google.com with SMTP id u133so11858851wmg.1
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 15:22:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XDt95SaculVsp4vsoMBJK73v+t7PC6clJ8dXMDb8GZE=;
        b=lEmV8mn+WC1nmlsJMyK7fnkeHpXKbLzUUrjaERh1E+au00N3WdZyyHH2sPsT8vMx13
         tW20XmKlA+fpvu5TvlXwJRMhq9u9/aIJLfi4Oxz7yf59x5aSkGzC3ioWE6895zzc+ADi
         aZd9N9FJXb8AIie0UXD/nGnFCv3rGTwVx1zg+W0vFzI4A8Bg7xmWAIkiWrC2rs9utnbD
         pvLFLH3lYeWYEfond7LvXw2NZ66bavwFPEWPgNThd/qyYLvIqNuiHEtTF5s0Vj+JdQn5
         imGQEMDdhD3tL3FfXVfjseu3zn44pHDx+dst92eEXvYooN+Pv4tsLWZAkawS45ORYt9Q
         Ig7A==
X-Gm-Message-State: AOAM532lRgSFPblkKYtWzWyvPq42tP7xEgiiw1NYOxA5yChdPDOTMR8T
        D0Hy9AVAeoTIi1YU7g6ofMs=
X-Google-Smtp-Source: ABdhPJwKPPI94ijzomJLiw/z0WvZWW4cX9Vs4h6CzSTXuSIpUb7Rpgj42vphbyv4ZCDxgKEYHXWfOw==
X-Received: by 2002:a1c:3184:: with SMTP id x126mr10845737wmx.52.1621635724975;
        Fri, 21 May 2021 15:22:04 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:66b2:1988:438b:4253? ([2601:647:4802:9070:66b2:1988:438b:4253])
        by smtp.gmail.com with ESMTPSA id i1sm3430737wrp.51.2021.05.21.15.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 15:22:04 -0700 (PDT)
Subject: Re: [RFC PATCH v5 03/27] nvme-tcp-offload: Add device scan
 implementation
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, davem@davemloft.net,
        kuba@kernel.org, hch@lst.de, axboe@fb.com, kbusch@kernel.org
Cc:     aelior@marvell.com, mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, malin1024@gmail.com,
        Dean Balandin <dbalandin@marvell.com>
References: <20210519111340.20613-1-smalin@marvell.com>
 <20210519111340.20613-4-smalin@marvell.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <e986c505-b81a-36ab-6366-35d5fbc193e1@grimberg.me>
Date:   Fri, 21 May 2021 15:22:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210519111340.20613-4-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/21 4:13 AM, Shai Malin wrote:
> From: Dean Balandin <dbalandin@marvell.com>
> 
> As part of create_ctrl(), it scans the registered devices and calls
> the claim_dev op on each of them, to find the first devices that matches
> the connection params. Once the correct devices is found (claim_dev
> returns true), we raise the refcnt of that device and return that device
> as the device to be used for ctrl currently being created.
> 
> Acked-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Dean Balandin <dbalandin@marvell.com>
> Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
> Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> ---
>   drivers/nvme/host/tcp-offload.c | 94 +++++++++++++++++++++++++++++++++
>   1 file changed, 94 insertions(+)
> 
> diff --git a/drivers/nvme/host/tcp-offload.c b/drivers/nvme/host/tcp-offload.c
> index 711232eba339..aa7cc239abf2 100644
> --- a/drivers/nvme/host/tcp-offload.c
> +++ b/drivers/nvme/host/tcp-offload.c
> @@ -13,6 +13,11 @@
>   static LIST_HEAD(nvme_tcp_ofld_devices);
>   static DECLARE_RWSEM(nvme_tcp_ofld_devices_rwsem);
>   
> +static inline struct nvme_tcp_ofld_ctrl *to_tcp_ofld_ctrl(struct nvme_ctrl *nctrl)
> +{
> +	return container_of(nctrl, struct nvme_tcp_ofld_ctrl, nctrl);
> +}
> +
>   /**
>    * nvme_tcp_ofld_register_dev() - NVMeTCP Offload Library registration
>    * function.
> @@ -98,6 +103,94 @@ void nvme_tcp_ofld_req_done(struct nvme_tcp_ofld_req *req,
>   	/* Placeholder - complete request with/without error */
>   }
>   
> +struct nvme_tcp_ofld_dev *
> +nvme_tcp_ofld_lookup_dev(struct nvme_tcp_ofld_ctrl *ctrl)
> +{
> +	struct nvme_tcp_ofld_dev *dev;
> +
> +	down_read(&nvme_tcp_ofld_devices_rwsem);
> +	list_for_each_entry(dev, &nvme_tcp_ofld_devices, entry) {
> +		if (dev->ops->claim_dev(dev, &ctrl->conn_params)) {
> +			/* Increase driver refcnt */
> +			if (!try_module_get(dev->ops->module)) {

This means that every controller will take a long-lived reference on the
module? Why?

> +				pr_err("try_module_get failed\n");
> +				dev = NULL;
> +			}
> +
> +			goto out;
> +		}
> +	}
> +
> +	dev = NULL;
> +out:
> +	up_read(&nvme_tcp_ofld_devices_rwsem);
> +
> +	return dev;
> +}
> +
> +static int nvme_tcp_ofld_setup_ctrl(struct nvme_ctrl *nctrl, bool new)
> +{
> +	/* Placeholder - validates inputs and creates admin and IO queues */
> +
> +	return 0;
> +}
> +
> +static struct nvme_ctrl *
> +nvme_tcp_ofld_create_ctrl(struct device *ndev, struct nvmf_ctrl_options *opts)
> +{
> +	struct nvme_tcp_ofld_ctrl *ctrl;
> +	struct nvme_tcp_ofld_dev *dev;
> +	struct nvme_ctrl *nctrl;
> +	int rc = 0;
> +
> +	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
> +	if (!ctrl)
> +		return ERR_PTR(-ENOMEM);
> +
> +	nctrl = &ctrl->nctrl;
> +
> +	/* Init nvme_tcp_ofld_ctrl and nvme_ctrl params based on received opts */
> +
> +	/* Find device that can reach the dest addr */
> +	dev = nvme_tcp_ofld_lookup_dev(ctrl);
> +	if (!dev) {
> +		pr_info("no device found for addr %s:%s.\n",
> +			opts->traddr, opts->trsvcid);
> +		rc = -EINVAL;
> +		goto out_free_ctrl;
> +	}
> +
> +	ctrl->dev = dev;
> +
> +	if (ctrl->dev->ops->max_hw_sectors)
> +		nctrl->max_hw_sectors = ctrl->dev->ops->max_hw_sectors;
> +	if (ctrl->dev->ops->max_segments)
> +		nctrl->max_segments = ctrl->dev->ops->max_segments;
> +
> +	/* Init queues */
> +
> +	/* Call nvme_init_ctrl */
> +
> +	rc = ctrl->dev->ops->setup_ctrl(ctrl, true);
> +	if (rc)
> +		goto out_module_put;

goto module_put without an explicit module_get is confusing.

> +
> +	rc = nvme_tcp_ofld_setup_ctrl(nctrl, true);
> +	if (rc)
> +		goto out_uninit_ctrl;

ops->setup_ctrl and then call to nvme_tcp_ofld_setup_ctrl?
Looks weird, why are these separated?

> +
> +	return nctrl;
> +
> +out_uninit_ctrl:
> +	ctrl->dev->ops->release_ctrl(ctrl);
> +out_module_put:
> +	module_put(dev->ops->module);
> +out_free_ctrl:
> +	kfree(ctrl);
> +
> +	return ERR_PTR(rc);
> +}
> +
>   static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
>   	.name		= "tcp_offload",
>   	.module		= THIS_MODULE,
> @@ -107,6 +200,7 @@ static struct nvmf_transport_ops nvme_tcp_ofld_transport = {
>   			  NVMF_OPT_RECONNECT_DELAY | NVMF_OPT_HDR_DIGEST |
>   			  NVMF_OPT_DATA_DIGEST | NVMF_OPT_NR_POLL_QUEUES |
>   			  NVMF_OPT_TOS,
> +	.create_ctrl	= nvme_tcp_ofld_create_ctrl,
>   };
>   
>   static int __init nvme_tcp_ofld_init_module(void)
> 
