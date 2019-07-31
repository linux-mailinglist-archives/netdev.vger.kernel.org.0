Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B507D02F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 23:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfGaVmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 17:42:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33585 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfGaVmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 17:42:06 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so1278056pgn.0;
        Wed, 31 Jul 2019 14:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9p9WvHXoxlLbYWbCg+NginBLDGupg9fXAky3S1UEaX4=;
        b=CL3InGugDJjm/WCiKfFJYSXuiQvQaUa8Cuh4AWx+CmFJ+69BClL30PnTnG+L0BaUe3
         0zjl5yLLlOj0THI333BOWDEjai1exXSKfWvoBjgT6EADVpxQJ6pahDUIO7icCnl2P6ID
         D9yzOVtuGXwXjPNHAv7C0mtli6r7+Fz4LUb9BYHuF2XfJa6sttNVubaflp7/lUEGEUfP
         y7KBzaXHuEW7DcIDXp7ntxEWQW6+6LOuv5S8IPzIV0rTHK7rrhVuyxzhWHD7/sJYTh8E
         GTcaPN+Ii6pjEmryTXOVvQ4NF6yB4EQoUstF+3eGMYiBPvv8lTrm1Dff6imj/x34QPD8
         E8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9p9WvHXoxlLbYWbCg+NginBLDGupg9fXAky3S1UEaX4=;
        b=tCs+yHmUBHdXmgYBKiY+H7fsD4wDL0nl6cXXOR7u5b9AhrA4LrYG1SVv9i/bZlu9nP
         lo2WvBHs/JQwva2kZSDMv/vz9Z7qvcX1J5HIQde7EtxH2NFS1E6XlcfisZxyB/domrT6
         cw9NUN7/UDRyEA0dQdXjXWcmtXQAODIJC9s8CJ0wk38t6FjmecbslmxzluFfnx+MFQCI
         KLRm9MwU7dOIfewr7uQVLXqkrVj73D86UFS9mn4MW3qG/tUju9iWJsIvK/gU0K4diCL0
         ccA8gkuIfI3b4OiKu2k9+CI6X+Ok79Skx++hEQaH/SrgHhY3DmMkxblb4luyEpjBGH1y
         T28A==
X-Gm-Message-State: APjAAAVUVB0zkLiYYrm0pT4zFD/yrfTQDr403nTb/zxWvSECQyNINhk9
        Ikw8FQpBe8d8S3EV3pPprYNW2zDU
X-Google-Smtp-Source: APXvYqz0WrTX6sGWLnRtQfzthNqaPcLqG+VLyMyOuA0v9DWEfQ1lM3hZ4vQbFkrfLAiYLiWrNZ8F/g==
X-Received: by 2002:a63:5048:: with SMTP id q8mr114161150pgl.446.1564609325331;
        Wed, 31 Jul 2019 14:42:05 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id o9sm39374330pgv.19.2019.07.31.14.42.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 14:42:04 -0700 (PDT)
Subject: Re: [PATCH net v3] net: ipv6: Fix a bug in ndisc_send_ns when netdev
 only has a global address
To:     Su Yanjun <suyj.fnst@cn.fujitsu.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1564537972-76503-1-git-send-email-suyj.fnst@cn.fujitsu.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d599b296-5122-6b72-8869-5c457c2f9e3c@gmail.com>
Date:   Wed, 31 Jul 2019 15:42:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1564537972-76503-1-git-send-email-suyj.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/19 7:52 PM, Su Yanjun wrote:
> When the egress interface does not have a link local address, it can
> not communicate with other hosts.
> 
> In RFC4861, 7.2.2 says
> "If the source address of the packet prompting the solicitation is the
> same as one of the addresses assigned to the outgoing interface, that
> address SHOULD be placed in the IP Source Address of the outgoing
> solicitation.  Otherwise, any one of the addresses assigned to the
> interface should be used."
> 
> In this patch we try get a global address if we get ll address failed.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
> ---
> Changes since V2:
> 	- Let banned_flags under the scope of its use.
> ---
>  include/net/addrconf.h |  2 ++
>  net/ipv6/addrconf.c    | 34 ++++++++++++++++++++++++++++++++++
>  net/ipv6/ndisc.c       | 10 +++++++---
>  3 files changed, 43 insertions(+), 3 deletions(-)
> 


This change looks fine to me given the RFC reference, so for that part:
Reviewed-by: David Ahern <dsahern@gmail.com>

Bigger picture is the issue Mark raised that a different RFC says all
links should have an LLA, so use of IN6_ADDR_GEN_MODE_NONE means
userspace is expected to create and add the LLA. Lack of an LLA is a
misconfigured system. If that is enforced via some to be developed
patch, then this patch would not be needed.
