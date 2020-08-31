Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67EE257151
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 02:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgHaAuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 20:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgHaAux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 20:50:53 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581BC061573;
        Sun, 30 Aug 2020 17:50:52 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p37so3395546pgl.3;
        Sun, 30 Aug 2020 17:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P3fkGCE9MV+bgXeAL52Ar6IjNkMtiOsJAfknlKWNC7I=;
        b=haTkoNXABq6AAIl9qZEK+W6F5R/Lg01CVLjfnJZ3Wh16Kbq94SAYtZXH+quZv+AXYP
         LYkRZpW0c+CsBpu3gl5EUsIRSEP2mM5mvEZAyMhw4PjH1scn+y9y+/FFKtTUdet8ezNv
         l/ESbWeOvC8Qp5KXH8yNLYEQKq4h2Z+OrmO9Hkqy9nsudTQxw4C+31M7FCyOpf7kXUBF
         XYYb+MRQT6gTUESSD2MY7YpGJ+eME6DEwYgnaSsHQl+bMa2FzmnX2Hg4k+xq8wMPUcif
         liipppEIvNFVpFyY6SWcH5gqXF5VQBJNPd5LPin/eyhMq4lUvEhJAvJpDuw0nLOHsJwc
         Je+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P3fkGCE9MV+bgXeAL52Ar6IjNkMtiOsJAfknlKWNC7I=;
        b=JnIQ1dxBZdDEaWyfUCyumJOr+SOHQCJ+o6zMjCn2IK7E0DP67/xvGr1UOcHFXM9d8s
         BhEWHOAYxbUwMcvKRGyaKKnjBIRF3nAENzEcexnHhjUavyP7zATHMgQEDYNxr8pBZg12
         SybHv1UtzrPaf6kQr7BbDaiqhJRu7W8m2Ur90fee7CZG+urqe/B1szFvntExw3SH25D4
         ZLzP3N1uVDXtAaGEnoc1p7OtLgsZd3Z/flhVAsax1kMResA6pWVYsPza/+iWQkVrKPDk
         jiquWwuG8LhMOKz0ch4sv6f4d5s1E1aeA/IxahtBllleaG8RFms3jxtoOncGI+aGEh/g
         wR4Q==
X-Gm-Message-State: AOAM532sFDlgIhiiML76V7V4ZoT0rjGLswn/Ag+XYSSHKqehKzbtX8A9
        syV2TqZqUSJ2O0YF8JjJDLs=
X-Google-Smtp-Source: ABdhPJz7pB08Q5tKwHplETd6DRJHCKB4pHGl5nZr2XfvpgCq2NqYDssZ/m4WInBya1BxSkPlWvfiAQ==
X-Received: by 2002:a63:7c9:: with SMTP id 192mr6271875pgh.181.1598835052002;
        Sun, 30 Aug 2020 17:50:52 -0700 (PDT)
Received: from thinkpad (104.36.148.139.aurocloud.com. [104.36.148.139])
        by smtp.gmail.com with ESMTPSA id 65sm5747598pfc.218.2020.08.30.17.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 17:50:51 -0700 (PDT)
Date:   Sun, 30 Aug 2020 17:51:33 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] veth: fix memory leak in veth_newlink()
Message-ID: <20200831005133.GA3295@thinkpad>
References: <20200830131336.275844-1-rkovhaev@gmail.com>
 <32e30526-bcc9-1f2f-1250-f36687561fbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32e30526-bcc9-1f2f-1250-f36687561fbb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 31, 2020 at 09:16:32AM +0900, Toshiaki Makita wrote:
> On 2020/08/30 22:13, Rustam Kovhaev wrote:
> > when register_netdevice(dev) fails we should check whether struct
> > veth_rq has been allocated via ndo_init callback and free it, because,
> > depending on the code path, register_netdevice() might not call
> > priv_destructor() callback
> 
> AFAICS, register_netdevice() always goto err_uninit and calls priv_destructor()
> on failure after ndo_init() succeeded.
> So I could not find such a code path.
> Would you elaborate on it?

in net/core/dev.c:9863, where register_netdevice() calls rollback_registered(),
which does not call priv_destructor(), then register_netdevice() returns error
net/core/dev.c:9884

