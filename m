Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 775DB2CCAEF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgLCAQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgLCAQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:16:27 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D083CC0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 16:15:41 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t8so95234pfg.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 16:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rd3TK0a9w3YIAYqMFqh7QmkZAGj7fNxcabvz3bLYqww=;
        b=Hx1TpgEN7PhxWdUPTISe3qOc7WrQtDEx+qFNnOQjbDmcO+u+xdC1Vqx807cSBZDwmd
         +G6BIhg8Hi9RGekkvDo2Ball2/T1gmC9o6R1lQnImz9ALCTzml37s9ADsJ/jp5a/kynH
         vM+Eiv7Cwo/vgsrFwlRKSPkRY+VWLhA5Uw7F+M8M3CjHWUk3I0yEPuRPe5ZCocvUX/6i
         8tdJRn0b7cvEv8xhLhZV7h2mMEiBqj7UsBCgELsh1zxlrA61QLfpol/7MnEbeGBmz8Fg
         3KT6vf4oebAb/5RMqEZpb4cE4aacTnkj2sjgoYc6I0v8E5uuHyN43+0ZrFeNiSv6N5Pk
         ky7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rd3TK0a9w3YIAYqMFqh7QmkZAGj7fNxcabvz3bLYqww=;
        b=HF9Qo92b5mxmjCQIfnsMhtePNDqDRQoMqt4xYAKZpurikmupVMtK6Wg4iRXTvEKs5S
         c/wKKe4kADVD7dsCERMwKTc4QXk0WvX7rob+ANIR5KtIfRWJ+0G5z9idAnw+HY8/ghb1
         mfGstbvVWHg6yQmdNiWAUw8qhJ08mQY5g2zr+ijOul8wBA3FNHiqsEBDaQVF+FBl1wiy
         uuBJYWI9bwkZUPIcP0JCk0zMoaelwa+o4vOM4vgBsbmLEi/QE8K2mDuHQK8lVWG0OYCc
         EL0keK93SmRSk1rRlrSsDNm+V4qNJpe0KFyCegl///wS9ecvbFQtS01sKA1raL8/asrP
         AsTA==
X-Gm-Message-State: AOAM530tSmIYmRrRwAugDbwagUjn20rRJFxUE0RG5VmVDK8WykrnvvA6
        R/wJGFSQhOyYLXdFFq041Ln9VQ==
X-Google-Smtp-Source: ABdhPJzRJMb9ZFcFRxfqwkvEd4IpAdWMwWGUXXn5JzD9qbH9ZoUu3h46R/A0geq1QV7Boo+ISVXwqw==
X-Received: by 2002:a63:1943:: with SMTP id 3mr706641pgz.312.1606954541374;
        Wed, 02 Dec 2020 16:15:41 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a21sm59201pjq.37.2020.12.02.16.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 16:15:41 -0800 (PST)
Date:   Wed, 2 Dec 2020 16:15:27 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, arjunroy@google.com,
        edumazet@google.com, soheil@google.com
Subject: Re: [net-next v2 1/8] net-zerocopy: Copy straggler unaligned data
 for TCP Rx. zerocopy.
Message-ID: <20201202161527.51fcdcd7@hermes.local>
In-Reply-To: <20201202220945.911116-2-arjunroy.kdev@gmail.com>
References: <20201202220945.911116-1-arjunroy.kdev@gmail.com>
        <20201202220945.911116-2-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 14:09:38 -0800
Arjun Roy <arjunroy.kdev@gmail.com> wrote:

> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index cfcb10b75483..62db78b9c1a0 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -349,5 +349,7 @@ struct tcp_zerocopy_receive {
>  	__u32 recv_skip_hint;	/* out: amount of bytes to skip */
>  	__u32 inq; /* out: amount of bytes in read queue */
>  	__s32 err; /* out: socket error */
> +	__u64 copybuf_address;	/* in: copybuf address (small reads) */
> +	__s32 copybuf_len; /* in/out: copybuf bytes avail/used or error */
>  };
>  #endif /* _UAPI_LINUX_TCP_H */

You can't safely grow the size of a userspace API without handling the
case of older applications.  Logic in setsockopt() would have to handle
both old and new sizes of the structure.
