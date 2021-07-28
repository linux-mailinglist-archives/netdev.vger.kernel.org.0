Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF423D8CAF
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhG1LYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbhG1LYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 07:24:06 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED4C0613C1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 04:24:04 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id l4so2658473ljq.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 04:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Wg+3/RRWhlXAdTdGrz6ZDOoqwDjAalfDgSMGfZRFy7c=;
        b=MqB2oQJrWErl4M3jysGVniDJ4xARTYUEk892vt+CXTsOghQBHfw+ROqpA+FWeMfNAw
         99HiHQl9pgCodpNZVcjBeusKVj1g8kcdEIy/ZsV7LY738G0Iid6EaBW2zhaAmZdiUtKc
         pOnrw2np1M0KCLNrhvFVpkrx8b6JNzJx5ukHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wg+3/RRWhlXAdTdGrz6ZDOoqwDjAalfDgSMGfZRFy7c=;
        b=BeOfu4G8lMbjwK714R+6Gme5JFpJPzPqETbwIzT90cz9q0jTPYt1EQUPUdrMMs98ij
         8bowbA3sd0r/o9oD9axiKdjRzZOIfj7rwB6BUblmfb2i6osPcisGc3Kiq/V7ECIfCNV/
         llPQwr7DHOhZ+35VYMioCnFMWWF0+XvdLC4PjPrJ7Q+6khz7I1H/bUOON3TtMVxJKF6m
         iaVffTk/QLhzUG5r0pzXQqooK5l6pOS1+WCzw47+nZidTihGf5WaP4c7UrY+bXzLLfJ+
         45k9esNHBfLcGk0r2gV9KMYoRZiu1hQzQe3FSt8ROeEqW8MweFeGqCFm3+PedgoLhnaX
         W8OQ==
X-Gm-Message-State: AOAM5303nRr/Nc3XRYgFN4eDrE9jEd1oPt0FblKSLiCKds40YwKl702H
        j4e7zc92Kt0W8rHuWLs6CZAV5A==
X-Google-Smtp-Source: ABdhPJzbJpuLwTQcj/uhUJ1FDab/S8wsNFZGfZq+HhHIgh+eTtqaebX9Ee+tEB7aFHczhnUT7I/eLg==
X-Received: by 2002:a05:651c:124f:: with SMTP id h15mr18566268ljh.4.1627471443108;
        Wed, 28 Jul 2021 04:24:03 -0700 (PDT)
Received: from [172.16.11.1] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id f14sm494569ljj.116.2021.07.28.04.24.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 04:24:02 -0700 (PDT)
Subject: Re: [PATCH 62/64] netlink: Avoid false-positive memcpy() warning
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>
Cc:     linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-63-keescook@chromium.org> <YQDv+oG7ok0T1L+r@kroah.com>
From:   Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <d7251d92-150b-5346-6237-52afc154bb00@rasmusvillemoes.dk>
Date:   Wed, 28 Jul 2021 13:24:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQDv+oG7ok0T1L+r@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/2021 07.49, Greg Kroah-Hartman wrote:
> On Tue, Jul 27, 2021 at 01:58:53PM -0700, Kees Cook wrote:
>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>> field bounds checking for memcpy(), memmove(), and memset(), avoid
>> intentionally writing across neighboring fields.
>>
>> Add a flexible array member to mark the end of struct nlmsghdr, and
>> split the memcpy() to avoid false positive memcpy() warning:
>>
>> memcpy: detected field-spanning write (size 32) of single field (size 16)
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  include/uapi/linux/netlink.h | 1 +
>>  net/netlink/af_netlink.c     | 4 +++-
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
>> index 4c0cde075c27..ddeaa748df5e 100644
>> --- a/include/uapi/linux/netlink.h
>> +++ b/include/uapi/linux/netlink.h
>> @@ -47,6 +47,7 @@ struct nlmsghdr {
>>  	__u16		nlmsg_flags;	/* Additional flags */
>>  	__u32		nlmsg_seq;	/* Sequence number */
>>  	__u32		nlmsg_pid;	/* Sending process port ID */
>> +	__u8		contents[];
> 
> Is this ok to change a public, userspace visable, structure?

At least it should keep using a nlmsg_ prefix for consistency and reduce
risk of collision with somebody having defined an object-like contents
macro. But there's no guarantees in any case, of course.

Rasmus
