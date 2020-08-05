Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E207723D193
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 22:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgHEUCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 16:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726914AbgHEQii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:38:38 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515ABC008686;
        Wed,  5 Aug 2020 09:38:14 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id h7so42227406qkk.7;
        Wed, 05 Aug 2020 09:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OWOcCu/RdgXsCBIctAyPQWwmqwK81xNeRORnBnjCneQ=;
        b=tW1knKDE62tuWn5yeakMwnGIfDvIy8Nk4xLrt9d+xlZ0YyDTp0hfdO9t95joJp7vvZ
         Rr+5fj2ioRVHlNbtjNL9uFziyTfkS9m6bSrOaXsRADXi8VDgAZphegvBa9lTyhmpC/BW
         3brEgbOSY0tWjPyGmMovwukn4TBmQXaupVQCUTorMzToFKmuldYaJEJRmJ6fIqatSImu
         nrmyVVaeqG9e2xCRnc7TEKtNfrYGHD5YPJTs5cC4OyePzM+7V5j2mI+sMDtN7CvRgPe7
         0G+RF71204I3OsNCTMT6/vujlrH+z8AiuY8nIiy3121EPJta/NA+nf0LmKffr5fAn3+f
         oCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OWOcCu/RdgXsCBIctAyPQWwmqwK81xNeRORnBnjCneQ=;
        b=MuQJ+FNog2cqg8YGFPNfWOUHVxu3XZQTSxC5c+2TLBAXf9tNoBCAdbjcVTz1UaACRa
         JLuKpjJhKjgHdhNvyGP0rwcoZPv1a6kPOBM3CP36GJmaWkDosorg93koOyMghwsrZYM/
         OAU0A3HAQi4Z8NGM5IlOk74VjseXj1vw2C5S3WuUuHQId7XrvRtZK+pRl9BnluozkheU
         OGakoXAWwFqQozUKIobzHJrFy0Abm6iuhk1ageCmTZ70K3qNXXRFIKUYDTMoXF5ZdxEw
         5AGY0fXBTmva5xGv1VGfzGgjUiqrik5edV0daAah77btC43zF9izyVBVNFLjfzOuZ/B/
         7CIg==
X-Gm-Message-State: AOAM533zXkxnDg1IOm3lfay89ed31IK/uGas9ERJlL+Dbhf48nWI7MQv
        qS1AcopUu/LE2gm7aYU71qz5SD+s
X-Google-Smtp-Source: ABdhPJzHbvC24LEDffg8OVD0lvzzuhVVCTLwMO+4l6PPbH7YR9RHVzxjr31PzE59EaiGa3a5E15XEw==
X-Received: by 2002:a37:68c1:: with SMTP id d184mr4174354qkc.62.1596645493547;
        Wed, 05 Aug 2020 09:38:13 -0700 (PDT)
Received: from [10.254.6.29] ([162.243.188.133])
        by smtp.googlemail.com with ESMTPSA id k5sm2516784qtu.2.2020.08.05.09.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 09:38:12 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 2/3] bpf: Add helper to do forwarding lookups
 in kernel FDB table
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, bpf@vger.kernel.org
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com>
 <1596170660-5582-3-git-send-email-komachi.yoshiki@gmail.com>
 <5970d82b-3bb9-c78f-c53a-8a1c95a1fad7@gmail.com>
 <F99B20F3-4F88-4AFC-9DF8-B32EFD417785@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e92455ce-3a3f-7c52-1388-da40e8ceefd0@gmail.com>
Date:   Wed, 5 Aug 2020 10:38:10 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <F99B20F3-4F88-4AFC-9DF8-B32EFD417785@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/4/20 5:27 AM, Yoshiki Komachi wrote:
> 
> I guess that no build errors will occur because the API is allowed when
> CONFIG_BRIDGE is enabled.
> 
> I successfully build my kernel applying this patch, and I don’t receive any
> messages from build robots for now.

If CONFIG_BRIDGE is a module, build should fail: filter.c is built-in
trying to access a symbol from module.
