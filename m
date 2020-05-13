Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A6C1D19AA
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730547AbgEMPmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgEMPmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:42:00 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918EFC061A0C;
        Wed, 13 May 2020 08:42:00 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s69so2985294pjb.4;
        Wed, 13 May 2020 08:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iq35YePewEa8ED7IqVR9gS2BMFUT0ig3s9tj0BUPUcQ=;
        b=ieTRI6FuCux0OifkzpdQlTunNsAYWgMyOtjsNW/ZhRul32jkkIelPY6QeVVV6f7wwD
         PQ6bcELtieGYN6L/tzcyjbYI+7OlicLN3ReTAk/U2BZWyf1MZ5poue7qbIzKVnV0Ty81
         QnCT/ArcAzhDp6VqryWWR0whHh2frFqu20mNIh/bslyfPwzcbQ9zShCwLpwbYoLu9hcT
         jZahI2n5YHrHJmzhPEHL7GBVTAL+EiPlTmVZWPObG4116b4tsESFR9+ZyaB8P0NGU7A3
         qmct3zccyZHRJL64N2SIZqXL1gASDDUefCvITRKVUs3a/MmV9smpgHghKdxMvq+2PSIi
         FIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iq35YePewEa8ED7IqVR9gS2BMFUT0ig3s9tj0BUPUcQ=;
        b=X/ttQBUp/pG2jtcbkRMmq8QDUGFrPBpS4EqcZG9z0m3gk/WQxb1BEVImHoQbe2mV6D
         1euh7rqtSveKP6TdOUNGy0u9eFa/IZkmYI0wgqypgifb/5XRu/+B1CRqwtT8L7sAFrF7
         mli+qMgd1IYtCqxVKKNDZ7TZAGMze8rPsZvm7E4WadEnJwi5FWITWquJF3ZGNJw7JAd1
         WdKUheYCHQjTgZPD2n/Fq7loycWyVTfcNdsVYEvaeg9bh2IDsP+AC7YJWwICG3RPVVBR
         sm4bDpSlIpeP7x+lxrXwf9pqJlJTkAKGC88bCQbOTlKxlK92/pFaT4motvDjNHBPDpqR
         68SQ==
X-Gm-Message-State: AGi0Pub4aTHuoWN3FWfsauITBcGS2eUUdzBw0JmZhxayMBM8AllDDBg+
        vpmbVELaon0TbQbr3/9MBEhRXPxk
X-Google-Smtp-Source: APiQypJtjGAgUxWc18UTekCQxQaol0kuHHTgFFi06kdvAAY6aK6sIZrDAaGezDMWnEKe+7c4s5DsJg==
X-Received: by 2002:a17:902:47:: with SMTP id 65mr23609024pla.54.1589384519662;
        Wed, 13 May 2020 08:41:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k24sm14949802pfk.134.2020.05.13.08.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 08:41:59 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: cleanly handle kernel vs user buffers for
 ->msg_control
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511115913.1420836-1-hch@lst.de>
 <20200511115913.1420836-4-hch@lst.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c88897b9-7afb-a6f6-08f1-5aaa36631a25@gmail.com>
Date:   Wed, 13 May 2020 08:41:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200511115913.1420836-4-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 4:59 AM, Christoph Hellwig wrote:
> The msg_control field in struct msghdr can either contain a user
> pointer when used with the recvmsg system call, or a kernel pointer
> when used with sendmsg.  To complicate things further kernel_recvmsg
> can stuff a kernel pointer in and then use set_fs to make the uaccess
> helpers accept it.
> 
> Replace it with a union of a kernel pointer msg_control field, and
> a user pointer msg_control_user one, and allow kernel_recvmsg operate
> on a proper kernel pointer using a bitfield to override the normal
> choice of a user pointer for recvmsg.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/socket.h | 12 ++++++++++-
>  net/compat.c           |  5 +++--
>  net/core/scm.c         | 49 ++++++++++++++++++++++++------------------
>  net/ipv4/ip_sockglue.c |  3 ++-
>  net/socket.c           | 22 ++++++-------------
>  5 files changed, 50 insertions(+), 41 deletions(-)
> 
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 4cc64d611cf49..04d2bc97f497d 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -50,7 +50,17 @@ struct msghdr {
>  	void		*msg_name;	/* ptr to socket address structure */
>  	int		msg_namelen;	/* size of socket address structure */
>  	struct iov_iter	msg_iter;	/* data */
> -	void		*msg_control;	/* ancillary data */
> +
> +	/*
> +	 * Ancillary data. msg_control_user is the user buffer used for the
> +	 * recv* side when msg_control_is_user is set, msg_control is the kernel
> +	 * buffer used for all other cases.
> +	 */
> +	union {
> +		void		*msg_control;
> +		void __user	*msg_control_user;
> +	};
> +	bool		msg_control_is_user : 1;

Adding a field in this structure seems dangerous.

Some users of 'struct msghdr '  define their own struct on the stack,
and are unaware of this new mandatory field.

This bit contains garbage, crashes are likely to happen ?

Look at IPV6_2292PKTOPTIONS for example.


