Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F164C35E28B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346559AbhDMPVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346552AbhDMPVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:21:10 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C666AC061756;
        Tue, 13 Apr 2021 08:20:50 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id d15so5223734qkc.9;
        Tue, 13 Apr 2021 08:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qCzCnYr3+785S76q01Q/UXckp8I3YkeIwVVNFc/YH5M=;
        b=g3rAJOjjRkKXa8uh49lSVVH/mQz/fKZoW9IhSPi0jr5PoZeflJNTxdmaNGW09UDcQW
         JpFChJhCMHGQ/6xp8DOYecWiIS9fEyB6+Us1LCbI1iYnRZudZdYblSwCbGelX1C+XlFq
         joJYavZoVD3N1rXYMmtPTukucVBYsF56+Kwzi4IMbdUEk2g0jLzxSUK5j45wiYUYEbXe
         lVR34K8WQQouphJuhWdmiYvCUb5KJCiVcP+IQ1VXc35UbB0NGotwQZ+ZloXXT2uNfgIl
         tRfntLjMR51nvAgVFSIG7+GwLdydWH3vT3ZsLiCJv0JfnJhXtreILaLaIzYHcVyPSy/z
         MGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qCzCnYr3+785S76q01Q/UXckp8I3YkeIwVVNFc/YH5M=;
        b=sf7s+mY1dzZlU3Aeoale3TCCtZkp4/oOxaG0iuCiWqZifWBx2OYnJhu6UtXJB/+Trd
         oGo3ibvDOSt2TXahlagmGtSRcDDCsjQxJmq4zV2Rv6q3HqLo8NEMfUptzOCNnL1NZ7hA
         zyIDvHxWGR0v1Zvm0TcdyIT4uSm2KR3JP8sfNp0PXvPV5MsNfT1MgzIuR5mljKYomZjQ
         ccB5716rl2DqllL/L+EdV6nVWkF3Q7G+5yQ7oETg8R3IA+oR84t+kZPl52gq/07ksqQy
         AZLxzLqeIfsNRmQPmvKdLZ4I06qgwHQPLr8I7C9BL66pRSJv3MJ2kiy3H4XfThPiFFkw
         fCBA==
X-Gm-Message-State: AOAM5323hm7d9kQpjIiSkEGS1rstULiGVFkvGvJEXSW3ONTmSISRe8uA
        zGavKaCxgrPiuo1aadgYZLY=
X-Google-Smtp-Source: ABdhPJyAocGXCuLriRpyEOCNRK4K9tbznGt6OQntKCBXIpjbof/p/bvMr+DN2HRLFgq0NPnEKVKqMQ==
X-Received: by 2002:a37:6f41:: with SMTP id k62mr25738832qkc.262.1618327249995;
        Tue, 13 Apr 2021 08:20:49 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:7670:f294:e7fa:2bfe:b930])
        by smtp.gmail.com with ESMTPSA id m3sm7259613qkn.65.2021.04.13.08.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 08:20:49 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 2AFFAC0784; Tue, 13 Apr 2021 12:20:47 -0300 (-03)
Date:   Tue, 13 Apr 2021 12:20:47 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Or Cohen <orcohen@paloaltonetworks.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org, lucien.xin@gmail.com,
        nmarkus@paloaltonetworks.com
Subject: Re: [PATCH] net/sctp: fix race condition in sctp_destroy_sock
Message-ID: <YHW2zwdoDLVRPB/6@horizon.localdomain>
References: <20210413093153.27281-1-orcohen@paloaltonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413093153.27281-1-orcohen@paloaltonetworks.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 12:31:53PM +0300, Or Cohen wrote:
> +++ b/net/sctp/socket.c
> @@ -1520,11 +1520,9 @@ static void sctp_close(struct sock *sk, long timeout)
>  
>  	/* Supposedly, no process has access to the socket, but
>  	 * the net layers still may.
> -	 * Also, sctp_destroy_sock() needs to be called with addr_wq_lock
> -	 * held and that should be grabbed before socket lock.
>  	 */

Please also update the following comment in sctp_init_sock():
          /* Nothing can fail after this block, otherwise
           * sctp_destroy_sock() will be called without addr_wq_lock held
           */

Other than this, LGTM. Thanks.

  Marcelo
