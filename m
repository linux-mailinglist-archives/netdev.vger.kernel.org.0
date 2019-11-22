Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE5107A0F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 22:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKVVoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 16:44:15 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:39843 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVVoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 16:44:14 -0500
Received: by mail-qv1-f67.google.com with SMTP id v16so3515092qvq.6
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 13:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z4CllH+1qBA86sr1zvIWM3XnX9J23x9PIG/JwimNXgk=;
        b=XFJgmjrlO5aYvd/HYgcv6TyJv8jdj2mBgWwgX1icNhN/2LwxwXewGsp9wWN9VQBvZD
         0a6bbwk2SjJ2QjUosPKx8yMAwo8arjuJFCTCrZ5q3r9LUHHXX8K8Z2LlZQ5cS3dUvNJ9
         SRQrkep7Ro48ksiTvh/JwJEfJSgJfO6jPbff4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z4CllH+1qBA86sr1zvIWM3XnX9J23x9PIG/JwimNXgk=;
        b=bo3XcINLYTYutRwRx8X+pfg1iu9y7HfF0ayedn9yXOD8WCSerocXWFbAnuRCAj4cyj
         MWNAS+OeGgvzMJZYNE9jXHXfpNsLOssU34zAgAfcrCzo6uxOImicx5LaRCYIeQNVsep6
         iFEVRbw2S4arWpgLVhB+5n/rnyahlm+GrTx2bsbGxNFH6digjspmp5iyk8TlS0SQdVSN
         8NE6rprmKjRaz00ocUN0yNXSzNBkF6EYajw+cQ203UIsUWkiRFK3dzIsaOIVMkfjYNzD
         GlcjJtimJE7uSnvbIX93WryKiXkVzamT7TxZ6ocjeHUZiVdk7SxV/pAb2+j2O7n8EqF7
         iPpg==
X-Gm-Message-State: APjAAAUma7WnKnmT5ffh66MrraFkGOCYkA79Wddake5CNzOJ14cX/A8B
        YWSwW2uvOap4LmcOqhG4Oot/JInnc+g=
X-Google-Smtp-Source: APXvYqxtGwO26aOy93s2cIbcUSNELTlmq3m4TO2Tr5I3yP2HxS3O9tXToOQboWCplw5vWk73pC1SIg==
X-Received: by 2002:a0c:cd8b:: with SMTP id v11mr9711505qvm.66.1574459052384;
        Fri, 22 Nov 2019 13:44:12 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b0cf:5043:5811:efe3])
        by smtp.gmail.com with ESMTPSA id d6sm643590qkb.103.2019.11.22.13.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2019 13:44:11 -0800 (PST)
Subject: Re: [PATCH net-next 2/4] sfc: suppress MCDI errors from ARFS
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <a41f9c29-db34-a2e4-1abd-bfe1a33b442e@solarflare.com>
 <d3aeb469-cd78-c6a4-2804-3624fe9f876c@solarflare.com>
From:   David Ahern <dahern@digitalocean.com>
Message-ID: <c64acd8d-9431-1863-7fa1-a1de52f30306@digitalocean.com>
Date:   Fri, 22 Nov 2019 14:44:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d3aeb469-cd78-c6a4-2804-3624fe9f876c@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/19 10:57 AM, Edward Cree wrote:
> In high connection count usage, the NIC's filter table may be filled with
>  sufficiently many ARFS filters that further insertions fail.  As this
>  does not represent a correctness issue, do not log the resulting MCDI
>  errors.  Add a debug-level message under the (by default disabled)
>  rx_status category instead; and take the opportunity to do a little extra
>  expiry work.
> 
> Since there are now multiple workitems able to call __efx_filter_rfs_expire
>  on a given channel, it is possible for them to race and thus pass quotas
>  which, combined, exceed rfs_filter_count.  Thus, don't WARN_ON if we loop
>  all the way around the table with quota left over.
> 
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c |  8 ++++++--
>  drivers/net/ethernet/sfc/rx.c   | 28 ++++++++++++++++++++++++----
>  2 files changed, 30 insertions(+), 6 deletions(-)
> 

Tested-By: David Ahern <dahern@digitalocean.com>


