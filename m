Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156BADC09C
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633040AbfJRJKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:10:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35345 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390299AbfJRJKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:10:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id n124so1628242wmf.0;
        Fri, 18 Oct 2019 02:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tvcmzGhLeZkxuf9ToVdncFXWo0QaAaf8aWbn5IRZGzA=;
        b=ShHdKxh0asbe71PboVz42EC1qtiQ+dMApLvaWlZnHqJKcY3NGtDUi3fVSUs9xpczog
         lfhBXxnMKN/muwgmZ7/W8ym/UOmNNQUEne0PoFV/y+vQBmXwCNRJL7E8rvERb3d6lyMg
         vUoM1MFtA0Lq6hjxmWp7TvkMOjIf8JsfK1TGPM7IWSJ4DFo2R9fpB76p+0GMUncj+pGD
         c77mWq5FwQDDW3R+SN96FVLS7pa2MwEd/qLb5HSqKW7uIBxmPa2fIVxLejqP9/Rfru/q
         qg4Clav0uTBbULjzHOy1Mk5xGcJqNuLjvmqceFZmGFfP287uEYzZRQLEtAnrkNq0GasR
         C78Q==
X-Gm-Message-State: APjAAAXWevCykF9TjaMkBmyAq/yNtFNnVz7/7eRaWx3K2a8t3FAmyZpk
        cAhRpDovuMTEqjYJHRh4MUQ=
X-Google-Smtp-Source: APXvYqziqZLR4vn4LyxCRSuWOYI9Qs0YPzQPmqLEKV0ZESE6R24Eq9bGX8+MRAg6L7/ls7/y22o9Uw==
X-Received: by 2002:a1c:6389:: with SMTP id x131mr6613679wmb.55.1571389829353;
        Fri, 18 Oct 2019 02:10:29 -0700 (PDT)
Received: from debian (19.142.6.51.dyn.plus.net. [51.6.142.19])
        by smtp.gmail.com with ESMTPSA id l11sm4782010wmh.34.2019.10.18.02.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 02:10:28 -0700 (PDT)
Date:   Fri, 18 Oct 2019 10:10:26 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: [PATCH] xen/netback: fix error path of xenvif_connect_data()
Message-ID: <20191018091026.fu4gykxx2mmbdfk3@debian>
References: <20191018074549.4778-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018074549.4778-1-jgross@suse.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 09:45:49AM +0200, Juergen Gross wrote:
> xenvif_connect_data() calls module_put() in case of error. This is
> wrong as there is no related module_get().
> 
> Remove the superfluous module_put().
> 
> Fixes: 279f438e36c0a7 ("xen-netback: Don't destroy the netdev until the vif is shut down")
> Cc: <stable@vger.kernel.org> # 3.12
> Signed-off-by: Juergen Gross <jgross@suse.com>
> Reviewed-by: Paul Durrant <paul@xen.org>

Reviewed-by: Wei Liu <wei.liu@kernel.org>

> ---
>  drivers/net/xen-netback/interface.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 240f762b3749..103ed00775eb 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -719,7 +719,6 @@ int xenvif_connect_data(struct xenvif_queue *queue,
>  	xenvif_unmap_frontend_data_rings(queue);
>  	netif_napi_del(&queue->napi);
>  err:
> -	module_put(THIS_MODULE);
>  	return err;
>  }
>  
> -- 
> 2.16.4
> 
