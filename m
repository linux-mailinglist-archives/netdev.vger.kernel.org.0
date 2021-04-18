Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEF736386A
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 01:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhDRXDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 19:03:50 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:35633 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbhDRXDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 19:03:49 -0400
Received: by mail-pg1-f169.google.com with SMTP id q10so22945835pgj.2;
        Sun, 18 Apr 2021 16:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2pbgAZAAd737lyZ5qqTUDuQSwoGEzsEQ6O218gt7uwI=;
        b=YjovkHb+QCx1p5jumGPxRjxe0OqKooCOygebRQ4sJj0LfH9Wzp7HEy1sOP0MOOJZpK
         oT+VMRzl6NKADB6n4mINpBh6RT2YaMvHqjcpMkCaliiSRrE/1aebzWJ4QGqd4ZpEbImn
         DB9cbez3nIltUOZmzKzhvtxvUg44iWvwHzSbfEi/2aUxZ/NsTp8pt87UqYcAzj07caXA
         3JoHwYNwy3ifVDMgzA2UUH3QWGpMUBDdbXJ5OXT9KJuNI09pwmD7XIhr469X4C+vnxJV
         bLsPUbOB+uGD2h3WBMz2e7yT/RlGkmR623gA71RZH87tcU75duraOVtypEqel6g3iVGq
         LTKA==
X-Gm-Message-State: AOAM533IeM2/iO1OdSr62cE+9oAAf+q0gKG2Z04QW9ndMSpEkohrEy7k
        BwrRacYzMpcpsrLsRXg95mIHZJ1TMmE=
X-Google-Smtp-Source: ABdhPJxRmoJO9/4GzoOEqUZM8HagxnNbt11YNrkRwqcJHBDb+pk1VLXjxQHgzVOxzuGVuzE/LicX0g==
X-Received: by 2002:a62:3246:0:b029:224:6c6f:b3f2 with SMTP id y67-20020a6232460000b02902246c6fb3f2mr17177062pfy.68.1618787000841;
        Sun, 18 Apr 2021 16:03:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:93db:a33:19a8:2126? ([2601:647:4000:d7:93db:a33:19a8:2126])
        by smtp.gmail.com with ESMTPSA id t19sm5078216pgv.75.2021.04.18.16.03.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 16:03:20 -0700 (PDT)
Subject: Re: [PATCH 1/2] workqueue: Have 'alloc_workqueue()' like macros
 accept a format specifier
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>, tj@kernel.org,
        jiangshanlai@gmail.com, saeedm@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, Tejun Heo <tj@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
 <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <042f5fff-5faf-f3c5-0819-b8c8d766ede6@acm.org>
Date:   Sun, 18 Apr 2021 16:03:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <ae88f6c2c613d17bc1a56692cfa4f960dbc723d2.1618780558.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/21 2:26 PM, Christophe JAILLET wrote:
> Improve 'create_workqueue', 'create_freezable_workqueue' and
> 'create_singlethread_workqueue' so that they accept a format
> specifier and a variable number of arguments.
> 
> This will put these macros more in line with 'alloc_ordered_workqueue' and
> the underlying 'alloc_workqueue()' function.
> 
> This will also allow further code simplification.

Please Cc Tejun for workqueue changes since he maintains the workqueue code.

> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index d15a7730ee18..145e756ff315 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -425,13 +425,13 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>  	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED |		\
>  			__WQ_ORDERED_EXPLICIT | (flags), 1, ##args)
>  
> -#define create_workqueue(name)						\
> -	alloc_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, 1, (name))
> -#define create_freezable_workqueue(name)				\
> -	alloc_workqueue("%s", __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND |	\
> -			WQ_MEM_RECLAIM, 1, (name))
> -#define create_singlethread_workqueue(name)				\
> -	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
> +#define create_workqueue(fmt, args...)					\
> +	alloc_workqueue(fmt, __WQ_LEGACY | WQ_MEM_RECLAIM, 1, ##args)
> +#define create_freezable_workqueue(fmt, args...)			\
> +	alloc_workqueue(fmt, __WQ_LEGACY | WQ_FREEZABLE | WQ_UNBOUND |	\
> +			WQ_MEM_RECLAIM, 1, ##args)
> +#define create_singlethread_workqueue(fmt, args...)			\
> +	alloc_ordered_workqueue(fmt, __WQ_LEGACY | WQ_MEM_RECLAIM, ##args)
>  
>  extern void destroy_workqueue(struct workqueue_struct *wq);
>  
> 

