Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A762430D5F9
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhBCJNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:13:06 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:54895 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233230AbhBCJKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 04:10:42 -0500
Received: by mail-wm1-f47.google.com with SMTP id w4so3433340wmi.4
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 01:10:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIkMvk5fpP11LMmqzTDCQwFaHl4fPOWxWWNgSZyfsm4=;
        b=YXipVHW041ccdPVSCJdYQdXStiEVoqlfBzIgjfngqpaYiO8O+YeSEcCdjXMNn2EkRK
         5cIP5SE9fMLpVzmeNHVbQYEPN6++DhIdz6ygTR4YqMvw2HLRO/5X8IEnD+QTHULG8/zY
         UzSl1qJOLu0wJ0I7EXX4OelgN6x+rtngEcRhKKKXT4Zr33LY8RiG4B8tl4YGvfKj6KD+
         nfML8SbkjiqoWgP6eAvw/Za7ajyjzD+/cGLNcCXNKpomkZacvSG40G5FpgMPXSzn4OAk
         23yqI65rxP+W/POiwhQcuwRH6MmMlfzr9qJ7hQGHRs37cReUbisL8E15xyvF47kFDv4V
         PT5g==
X-Gm-Message-State: AOAM531CriKZFODFkbkPv91XJcJ6BFMTTCwDiSg4hhNMm/tRnZA/CgdD
        6QylqvqXbR6HTjzjxp2kPcE=
X-Google-Smtp-Source: ABdhPJxpuFjQy8/emxvC0hNLUySLUdOkBItSo0a2kIJhYBKWP2sbWk5DJj2LPDp/lOWfTKqYlPuWDw==
X-Received: by 2002:a1c:2311:: with SMTP id j17mr1847680wmj.38.1612343399190;
        Wed, 03 Feb 2021 01:09:59 -0800 (PST)
Received: from ?IPv6:2601:647:4802:9070:819b:e1e8:19a6:9008? ([2601:647:4802:9070:819b:e1e8:19a6:9008])
        by smtp.gmail.com with ESMTPSA id o124sm1929593wmb.5.2021.02.03.01.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 01:09:58 -0800 (PST)
Subject: Re: [PATCH v3 net-next 09/21] nvme-tcp: Deal with netdevice DOWN
 events
To:     Boris Pismenny <borisp@mellanox.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        hch@lst.de, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
 <20210201100509.27351-10-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <c864eb96-18ea-21dd-3ef3-15ca908c5959@grimberg.me>
Date:   Wed, 3 Feb 2021 01:09:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201100509.27351-10-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> @@ -2930,6 +2931,27 @@ static struct nvme_ctrl *nvme_tcp_create_ctrl(struct device *dev,
>   	return ERR_PTR(ret);
>   }
>   
> +static int nvme_tcp_netdev_event(struct notifier_block *this,
> +				 unsigned long event, void *ptr)
> +{
> +	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
> +	struct nvme_tcp_ctrl *ctrl;
> +
> +	switch (event) {
> +	case NETDEV_GOING_DOWN:
> +		mutex_lock(&nvme_tcp_ctrl_mutex);
> +		list_for_each_entry(ctrl, &nvme_tcp_ctrl_list, list) {
> +			if (ndev != ctrl->offloading_netdev)
> +				continue;
> +			nvme_tcp_error_recovery(&ctrl->ctrl);
> +		}
> +		mutex_unlock(&nvme_tcp_ctrl_mutex);
> +		flush_workqueue(nvme_reset_wq);
> +		/* we assume that the going down part of error recovery is over */

Maybe phrase it as:
/*
  * The associated controllers teardown has completed, ddp contexts
  * were also torn down so we should be safe to continue...
  */
