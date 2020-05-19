Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE531D8E31
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 05:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgESDZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 23:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgESDZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 23:25:52 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53A8C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 20:25:51 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g185so13068107qke.7
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 20:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Cic/REAFbq7j09lhrSsXMQMAv+KapwnRr21p1kpzPs=;
        b=TmyKYYkP7DZpTOuvjdThicrXu/PRHVbYCfUt0Ad/Vcmfhyp8FEtYZIWoQYAuE1CQZF
         dJsJWO3yIu2Zl0mKNmcDQtO3kxzmaM+cSp8NQ/UICA5Ca+OA+vQVzrYhOjDbc9PO9mSO
         NoN5JHuSYiywgNfqjsAGq3Q0w9mvMoOMoRB2FKRhW8L8ZFgRcS71iT7AMp0Pg15Gd8XN
         auEe5UD6j/RDscqEyiXHrVcTl+TyaMsoa0ybq4KZd4Ywdf2UmA6i/GunQg8KnTh7Giao
         co+DjKwIaChowOCvNnUXzJonPDEyOGQiDZO8oVb9vBcpF8UiWCeP0dKFj2cfwldqdupr
         NPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Cic/REAFbq7j09lhrSsXMQMAv+KapwnRr21p1kpzPs=;
        b=hV14a3au0gF7OgRxwzkEg62N+hA27Ggo9dcaLhIEOZc8lKX8DWGxV4rilK9UR0FHTA
         3o9LezFtl5GLPCzvrn9496Hbz0WjIuzVzTZUv+vdeNXwzvOLUezlQZe5uZEUDZsoF9uv
         H3wMFYn/KNnVHjzGhUQq0sPlL3h865PqVgefPV71p/Tb33dK31CuEIN3EhCUhZuK72il
         A+3NOCzZ1TzVdqsIOE14yB1n9/jPpmP5uPioy3oqv+LvQSHlPN20+2N5+tmI67vGaJCA
         ZgfqzjN15A8xJSFT5HNjj42dk7NITVMHY/t10Luaoxkl9as9Bv/PPd0/rm9Q/RbcPi0T
         /eMg==
X-Gm-Message-State: AOAM532L1giwZbhlba4ZccuKI5BdPZ7N2JlgvRzTiFe35sx5wUEzbz5/
        h7ivV8bdH1++pdxx+2mFCng=
X-Google-Smtp-Source: ABdhPJwBJOONJW07FwAEdcq6Ui4zjkSIf0VPDHhXrHlALVk8jRQCNh77AWbOUqrke6guW8BuE7KDwg==
X-Received: by 2002:a37:6345:: with SMTP id x66mr18404397qkb.472.1589858750979;
        Mon, 18 May 2020 20:25:50 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id z25sm11169060qtj.75.2020.05.18.20.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 20:25:50 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] nexthop: dereference nh only once in
 nexthop_select_path
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-2-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ecd765d8-4e83-dd20-5d71-8c4bb7b30639@gmail.com>
Date:   Mon, 18 May 2020 21:25:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589854474-26854-2-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 8:14 PM, Roopa Prabhu wrote:
> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> 
> the ->nh pointer might become suddenly null while we're selecting the
> path and we may dereference it. Dereference it only once in the
> beginning and use that if it's not null, we rely on the refcounting and
> rcu to protect against use-after-free. (This is needed for later
> vxlan patches that exposes the problem)
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  net/ipv4/nexthop.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

Should this be a bug fix? Any chance the route path can hit it?
