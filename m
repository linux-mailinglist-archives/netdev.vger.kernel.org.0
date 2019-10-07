Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1321CE692
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 17:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfJGPH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 11:07:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46478 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729006AbfJGPH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 11:07:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id q24so6984080plr.13;
        Mon, 07 Oct 2019 08:07:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbPZuGAfLWMaq3j8WbGywGIkXIN0Ck08+QYBW1nmgok=;
        b=t74ohUnF7FfB+6x17n6jGgBXSRJgqOgGHN6ejFp2fqMbEzmesC3sz/ZlvtCbJVAW3I
         X73uAEZfM5bip83WW/71GmE2ns4mat0QOVnsbyK1hD9Y/KInyjW1I1ydqdDEVkpJt38Z
         eoCrPzUPoBCY7ud10msMyjCVAdTpDUd6exiHUEWPlITQD09U1GYBm8qYFpaNOx4HkCGz
         wUt8lLiZds03HUY1HkDn5D+lw/ZwL6s+mSGP+BoX6nQxmCqAzclClRfVvK8agTr8UltO
         dwGLDXiY6nT/vjwflIXRb5beE6sV/S/OSwFsThJVSJM7QPDO4X09jyUbIhi7qqM5RDdy
         G9jQ==
X-Gm-Message-State: APjAAAUGdNOiFApB6a7mBGI3V0+yoCkjM8JyoAnwlKsH9KSd0yiy1GmK
        7HMGbDmWj6drRRe20/zd+coKbhcY
X-Google-Smtp-Source: APXvYqzQmn9eU1boev5aUTEGTEkjhHnbDVl5QfT1q7g4j7qozTS+XO963+7GIv5AsRsqo6xfFqiGYg==
X-Received: by 2002:a17:902:a98a:: with SMTP id bh10mr29817780plb.343.1570460877167;
        Mon, 07 Oct 2019 08:07:57 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z12sm20572446pfj.41.2019.10.07.08.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Oct 2019 08:07:56 -0700 (PDT)
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c0105196-b0e4-854e-88ff-40f5ba2d4105@acm.org>
Date:   Mon, 7 Oct 2019 08:07:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191007135933.12483-3-leon@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/19 6:59 AM, Leon Romanovsky wrote:
>   /*
> - * Check if the device might use memory registration.  This is currently only
> - * true for iWarp devices. In the future we can hopefully fine tune this based
> - * on HCA driver input.
> + * Check if the device might use memory registration. This is currently
> + * true for iWarp devices and devices that have optimized SGL registration
> + * logic.
>    */

The following sentence in the above comment looks confusing to me: 
"Check if the device might use memory registration." That sentence 
suggests that the HCA decides whether or not to use memory registration. 
Isn't it the RDMA R/W code that decides whether or not to use memory 
registration?

> + * For RDMA READs we must use MRs on iWarp and can optionaly use them as an
> + * optimaztion otherwise.  Additionally we have a debug option to force usage
> + * of MRs to help testing this code path.

You may want to change "optionaly" into "optionally" and "optimaztion" 
into "optimization".

>   static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
>   		enum dma_data_direction dir, int dma_nents)
>   {
> -	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
> -		return true;
> +	if (dir == DMA_FROM_DEVICE) {
> +		if (rdma_protocol_iwarp(dev, port_num))
> +			return true;
> +		if (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)
> +			return true;
> +	}
>   	if (unlikely(rdma_rw_force_mr))
>   		return true;
>   	return false;

Should this function be renamed? The function name suggests if this 
function returns 'true' that using memory registration is mandatory. My 
understanding is if this function returns true for the mlx5 HCA that 
using memory registration improves performance but is not mandatory.

Thanks,

Bart.
