Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55CDF296AA4
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 09:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375950AbgJWHup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 03:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374813AbgJWHup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 03:50:45 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E020EC0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 00:50:44 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l15so453391wmi.3
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 00:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4oABfubuy9rJdffezMc5U2Sgyccmm6kFm5R8Q0Ln3KU=;
        b=KkP3uQtoHLnNBNLbx0YL85D1j6jXtma25BYZ2T7qxLAvC9OUChO+purYX7Uq5O3ISG
         DdHd3Gu4thKzbS7Hcf+NlgcNyoay8UV6MldHmIjJKNYt6tipSItmYw1xX8LddO5P33sb
         6fnnj0/vhoLGgZgrN3Sfy9iBiewECf2cjgIHpuYyfGBJ70R0O1ZrWg+BDu387xd6AV70
         5y4sddqwHM36pmZ7ez4jjDLjT8ZKqEC3Jt12KJGhM6nxmoTtTjMqTZnooNFDFSMIb71Y
         8Fn6+6bUeUCEz2kL8zz85+YWHJyhuJEMaBwqs4geQ2AmsneImlvuf9fV1y/0GQjLq7iI
         wIeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4oABfubuy9rJdffezMc5U2Sgyccmm6kFm5R8Q0Ln3KU=;
        b=K3J6sKxo8H+oS4KZ5K1POFZAEUqKtux7xTrpJpE8xZZCWZyTUtepWDWvRLNDpNo7/o
         GfU9vBPcGjtCj99GFA//KpVmMe33oxB13RXcyNBOtn3OpWvNArl/PxlG8mXp6KH7QTXW
         vEqO5XQrn2m5pu9sx6BT7UmyL+fRAqxgJ5OELsjif53dY0F//WY8yiEodbk3k/LhRzL6
         bIHEKIRVR8E6Jm1SLIXBTjHoHeZikeW2ukx4WvmN1KVlCX4CKUD7mA+yD4M+vq1oZaDY
         Q3xxYqFGPS0NHk4k+UBrxdpljaNQ9FKkjMAGjS5NteIy1lKZGA6A8KcWmoCikmpzB/hZ
         XidA==
X-Gm-Message-State: AOAM530jZaGmd5du9tDEK5H9jyy6AZ6fZM9wCpIrqB9gCerthviCsWt1
        EKGMBwS/UE0JdhPr+qsyfEM=
X-Google-Smtp-Source: ABdhPJydCOnz8Dt4TawfY2hlg6gNhwBBAp7XoNU1h3SdDngHaBjgjyu8q7M92EXRNRflUA74bgWMrQ==
X-Received: by 2002:a1c:a5c4:: with SMTP id o187mr938575wme.171.1603439443716;
        Fri, 23 Oct 2020 00:50:43 -0700 (PDT)
Received: from [192.168.1.11] ([213.57.108.142])
        by smtp.gmail.com with ESMTPSA id f139sm1628447wme.47.2020.10.23.00.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 00:50:41 -0700 (PDT)
Subject: Re: [PATCH net-next RFC v1 02/10] net: Introduce direct data
 placement tcp offload
To:     Sagi Grimberg <sagi@grimberg.me>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     Yoray Zack <yorayz@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>,
        Boris Pismenny <borisp@nvidia.com>
References: <20200930162010.21610-1-borisp@mellanox.com>
 <20200930162010.21610-3-borisp@mellanox.com>
 <ab791897-6398-f38e-c2a6-f54c5ca5e1c5@grimberg.me>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <c5ad9021-9f44-9ed3-8e41-90a4d561d637@gmail.com>
Date:   Sun, 11 Oct 2020 17:44:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ab791897-6398-f38e-c2a6-f54c5ca5e1c5@grimberg.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/10/2020 0:47, Sagi Grimberg wrote:
>> + * tcp_ddp.h
>> + *	Author:	Boris Pismenny <borisp@mellanox.com>
>> + *	Copyright (C) 2020 Mellanox Technologies.
>> + */
>> +#ifndef _TCP_DDP_H
>> +#define _TCP_DDP_H
>> +
>> +#include <linux/blkdev.h>
> Why is blkdev.h needed?

That's a lefotover from a previous iteration over this code. I'll remove it for the next patch.

>
>> +#include <linux/netdevice.h>
>> +#include <net/inet_connection_sock.h>
>> +#include <net/sock.h>
>> +
>> +/* limits returned by the offload driver, zero means don't care */
>> +struct tcp_ddp_limits {
>> +	int	 max_ddp_sgl_len;
>> +};
>> +
>> +enum tcp_ddp_type {
>> +	TCP_DDP_NVME = 1,
>> +};
>> +
>> +struct tcp_ddp_config {
>> +	enum tcp_ddp_type    type;
>> +	unsigned char        buf[];
> A little kdoc may help here as its not exactly clear what is
> buf used for (at this point at least)...

Will add.

>> +};
>> +
>> +struct nvme_tcp_config {
> struct nvme_tcp_ddp_config

Sure.

>> +	struct tcp_ddp_config   cfg;
>> +
>> +	u16			pfv;
>> +	u8			cpda;
>> +	u8			dgst;
>> +	int			queue_size;
>> +	int			queue_id;
>> +	int			io_cpu;
>> +};
>> +
> Other than that this looks good to me.
Thanks Sagi!
