Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7F2A4CD8
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgKCRaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCRaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:30:10 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E82C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:30:09 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id k3so25311677ejj.10
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WCLr1NcOcb3nGONEyUolkVCU02HBtDkANd61Ptf8MKg=;
        b=AlCP2CRzU/5D4BuA682nevGOv3ydL5HSVD/EgiFQnf7W/JOOGTpLYlm/boxkStHtwx
         abRldHrrzWy2Q6hl0uHuPZvZej79zMkxE+gSsx2giJPoPmmdEVC4Bram3eobKkf7MH31
         MyElV2vSLs5ACi6yJ2O9ozm+rRG0ZtXxISPn+Ce41ESnbJ4EdpROfp9a7j/gZW/BubyV
         RguIOMrDBZrwzc/F2ZGFd4/RhVLgm1EuNWWukJSQdB4lWH1mmzodu2su16sA/G0wk2Ua
         UMw7CC0wZJWoTFLw7BudL2VziTKBKkL4zwcKzysdgJ2ssjyGsObG1Bh3bP92YhR43Lq4
         zYHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WCLr1NcOcb3nGONEyUolkVCU02HBtDkANd61Ptf8MKg=;
        b=dHl8VgRhZ0o0ZgNW4OHghY+IrIzmvdy+s824cduRuAHYLxp7SXLfN/GcovL10LZMMM
         c2GltTvbzdKYNLpt2o6qAH5tosiIJ4Uu0HSHZDTlEZ+RQwl8L2U4HrdyV+T/zK7PI8hG
         ihE4qLTxVGcdUH0rDB7WSHWN3RzHmCxw1KlJYtMhRKV/zbw2QJ4THbj2sqf6VswtnrMm
         tMcFcyYuptMN1B6aDldb2CqY/8KI0vYgjRDIQqbXmkxqBEvshAaBSCHFVjYdYBmpgdrP
         I8rsZOrfOpkjiKfot/kOCihDcacUJsGw0VsnPF00Ko940hFMrIufTuGh5ub0vcQ/Jz+d
         Am+A==
X-Gm-Message-State: AOAM530nWbqWV4NI6e+UnlOskISP69j28Sa45EuF8/OLKRlTkD4+XYLK
        /6DW+dQXAP0x9oNeS8CfLBOq+H6tTqI=
X-Google-Smtp-Source: ABdhPJxTfk1SllBBEPEvt4bWsxLx3NIPsFrke8TQUVDA6lOJXiOea5tcOwiib7AAd4WB57I+MIjD5g==
X-Received: by 2002:a17:906:3294:: with SMTP id 20mr20833385ejw.322.1604424608579;
        Tue, 03 Nov 2020 09:30:08 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m2sm4532669eds.35.2020.11.03.09.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 09:30:08 -0800 (PST)
Date:   Tue, 3 Nov 2020 19:30:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net v2 1/2] gianfar: Replace skb_realloc_headroom with
 skb_cow_head for PTP
Message-ID: <20201103173007.23ttgm3rpmbletee@skbuf>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
 <20201029081057.8506-1-claudiu.manoil@nxp.com>
 <20201103161319.wisvmjbdqhju6vyh@skbuf>
 <20201103083050.100b2568@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB6754C8F6D12318EF1DD0CA2B96110@AM0PR04MB6754.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 05:18:25PM +0000, Claudiu Manoil wrote:
> It's either the dev_kfree_skb_any from the dma mapping error path or the one
> from skb_cow_head()'s error path.  A confirmation would help indeed.

It says "consume", not "kfree", which in my mind would make it point
towards the only caller of consume_skb from the gianfar driver, i.e. the
dev_consume_skb_any that you just added.
