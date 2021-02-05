Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73731068E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 09:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhBEIWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 03:22:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230497AbhBEIWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 03:22:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612513245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=grp382xUiQkFSEt1gOITw+HbTn/V6dfG+GM5/2RbGpE=;
        b=Fw6bF4yNZX5a4oYo5YaP7n0vtxxZQ6LFYOVHvw6Ucb6PCs7vHcYEJ48D5GmAyLWDRQBaOx
        9LkF/OBDt5vQlnggxfjKDhIHTXJMSXPjK66KqMuxeErNZt/rNAZQGVJqpGeAAulkzyRTmG
        UHJ8S0IofODJTHKcc4ZnawZCprPhooE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-tqDdV1g_OKeJTeSjzZabPA-1; Fri, 05 Feb 2021 03:20:42 -0500
X-MC-Unique: tqDdV1g_OKeJTeSjzZabPA-1
Received: by mail-wr1-f69.google.com with SMTP id x12so4838254wrw.21
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 00:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=grp382xUiQkFSEt1gOITw+HbTn/V6dfG+GM5/2RbGpE=;
        b=TufW53jJnXCuCZbO1EqTFQvNCYJhQZRVBDbtQNnz65Gdo4zJHcj08n580thVtd+8DF
         TZjX9FqRz1wwplcRdmXMkwjtyo6LeqVcohWlob6K5mzPfXWGYYz71BFgeiBaROOLKvn9
         3oNFDLRaESXxEY2cwS6U4N520AUVH9WdfpgOlKmrGelPKzdcztUG+HEB/OZtmCmrrRbU
         3VAo5nQGcg3OEafB6m78yv4xLFi7Sq/ry85perxO00LW0Jz60TWywVtR3GxWR2mD4VmA
         J8jZsgq1khTw9rOl8lW/cvj9Qyvmslfoen1w/5HWOcLxpDJFzZtDT1tDNmvDWw2O7A8n
         OSXw==
X-Gm-Message-State: AOAM531O1lnOGQwRMZJs0aZPMvdUloLRoeDlz7GgB17zYcmWBdE21M/r
        ++aCCJxGg70OxYGbBYWatzziZqZGZVpL3gMyWHKmQ01L0GZ75abD6Tkdlv8r+F0yC7P1+TdK7Jd
        2lFCZlvAGs94zOAY9
X-Received: by 2002:a5d:5255:: with SMTP id k21mr1492833wrc.261.1612513241847;
        Fri, 05 Feb 2021 00:20:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuYXCPx4Uj8uGhZwlSOpSmUBtFTW38kVL1sf+Ly5CSvwouMfD3hvwOOsk2FDeUQKCejZ1f5A==
X-Received: by 2002:a5d:5255:: with SMTP id k21mr1492811wrc.261.1612513241630;
        Fri, 05 Feb 2021 00:20:41 -0800 (PST)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id q24sm7964361wmq.24.2021.02.05.00.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 00:20:41 -0800 (PST)
Date:   Fri, 5 Feb 2021 09:20:38 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Norbert Slusarek <nslusarek@gmx.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, alex.popov@linux.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve locking
Message-ID: <20210205082038.ziaouef3v6hhmjow@steredhat>
References: <trinity-64b93de7-52ac-4127-a29a-1a6dbbb7aeb6-1612474127915@3c-app-gmx-bap39>
 <d801ab6a-639d-579f-2292-9a7a557a593f@gmail.com>
 <trinity-efe6011b-4e34-4b7e-960f-bb78a3e44abd-1612477362851@3c-app-gmx-bap39>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <trinity-efe6011b-4e34-4b7e-960f-bb78a3e44abd-1612477362851@3c-app-gmx-bap39>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 11:22:42PM +0100, Norbert Slusarek wrote:
>> We request Fixes: tag for patches targeting net tree.
>>
>> You could also mention the vsock_connect_timeout()
>> issue was found by a reviewer and give some credits ;)
>
>You're right, Eric Dumazet spotted the locking problem in vsock_cancel_timeout().
>I am not too familiar how I should format my response to include it to the final
>patch message, in case I should specifically format it, just let me know.
>For now:
>

 From Documentation/process/submitting-patches.rst:
"please use the 'Fixes:' tag with the first 12 characters of the SHA-1 
ID, and the one line summary."

>Fixes: 380feae0def7e6a115124a3219c3ec9b654dca32 (vsock: cancel packets when failing to connect)

So this should be :
Fixes: 380feae0def7 ("vsock: cancel packets when failing to connect")

This maybe could apply for the locking issue, but for the NULL pointer 
issue is better to refer to the commit that handled vsk->transport 
pointer dynamically, that is this one:

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")

As I suggested, I think is better to split this patch in two patches 
since we are fixing two issues. This should also simplify to attach the 
proper 'Fixes' tag.

But if you want to send a single patch, I thing the right 'Fixes:' tag 
should be the c0cfa2d8a788, since before this commit, both issues are 
not really exploitable.

>Reported-by: Norbert Slusarek <nslusarek@gmx.net>
>Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
>

Splitting also allows to put the reporter in the right issue he 
reported.

Thanks,
Stefano

