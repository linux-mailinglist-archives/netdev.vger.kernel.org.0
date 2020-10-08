Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249CE287E4B
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 23:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgJHVrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 17:47:17 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51445 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgJHVrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 17:47:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id d81so7895182wmc.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 14:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4B4g5hnbYWCHTDGBt86zrmzrjJpiFz12L3VKQD20aX8=;
        b=t12klNIe0HhnofvS9TP4Q62OgvbU1ANN37MUgkn61OcWqO1Dqgjer3BF37ZByKC67a
         SDigg8EbIbVsDTTfICg3sDl6JaPB12szz3aMn4r97kjTGMr6HfZH65kRYaVQ8+OzFj51
         BppROaS9njyCo5/j/mJ85If9CIBXHZSovcgRZVJ3ly0Jr9s5MtELh+9bLHrL2+JU911Q
         k8I8nRatd4Sb2PHLns60X50sFnuuBtc9Zq8I3pO1dyN9T87qxGdlDFRUtKISkQfI3Sln
         JKp8RiQaRhkkRd+CVY58GAY35XHTy5DB+eB4pC5HUKZwJviBLS0lWsyOlRDD5BuFKt5E
         PAdQ==
X-Gm-Message-State: AOAM532MbLkxIt54fdiI4Ba+F8+tVR/0g7IhGfiUSzaKldNe93r/aKMK
        93rzqq9yhx+EjgZsrXyqkcE=
X-Google-Smtp-Source: ABdhPJweb0AWlp+iJvel5XjIhpIx9b7T7KLxeoFA3eZ14P9KaeqhKR+LY6wZnxr/eyncYTZCUlNwMA==
X-Received: by 2002:a1c:ed09:: with SMTP id l9mr11026420wmh.89.1602193634896;
        Thu, 08 Oct 2020 14:47:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:68d6:3fd5:5a8b:9959? ([2601:647:4802:9070:68d6:3fd5:5a8b:9959])
        by smtp.gmail.com with ESMTPSA id c132sm8810656wmf.25.2020.10.08.14.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 14:47:14 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 02/10] net: Introduce direct data
 placement tcp offload
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-3-borisp@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ab791897-6398-f38e-c2a6-f54c5ca5e1c5@grimberg.me>
Date:   Thu, 8 Oct 2020 14:47:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200930162010.21610-3-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> + * tcp_ddp.h
> + *	Author:	Boris Pismenny <borisp@mellanox.com>
> + *	Copyright (C) 2020 Mellanox Technologies.
> + */
> +#ifndef _TCP_DDP_H
> +#define _TCP_DDP_H
> +
> +#include <linux/blkdev.h>

Why is blkdev.h needed?

> +#include <linux/netdevice.h>
> +#include <net/inet_connection_sock.h>
> +#include <net/sock.h>
> +
> +/* limits returned by the offload driver, zero means don't care */
> +struct tcp_ddp_limits {
> +	int	 max_ddp_sgl_len;
> +};
> +
> +enum tcp_ddp_type {
> +	TCP_DDP_NVME = 1,
> +};
> +
> +struct tcp_ddp_config {
> +	enum tcp_ddp_type    type;
> +	unsigned char        buf[];

A little kdoc may help here as its not exactly clear what is
buf used for (at this point at least)...

> +};
> +
> +struct nvme_tcp_config {

struct nvme_tcp_ddp_config

> +	struct tcp_ddp_config   cfg;
> +
> +	u16			pfv;
> +	u8			cpda;
> +	u8			dgst;
> +	int			queue_size;
> +	int			queue_id;
> +	int			io_cpu;
> +};
> +

Other than that this looks good to me.
