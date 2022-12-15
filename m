Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF8664D7DD
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 09:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLOIiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 03:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLOIiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 03:38:21 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A588221E3A
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 00:38:19 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id bg10so13195967wmb.1
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 00:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp5dgQ+KrAXtaDXnmH+hgIgyuiOZdMItxtBMeH5X92U=;
        b=2GBNMml41SRnA+uTSEL6Ynfl0xs9QYyNhntQ0pVdqVmZee3SiXY3BhzFDSK7U3k7rV
         S2cT1ocTnWtgeJSnUSYnTeUn87Wx03J9+fgkFbakK7rs7i/mqhBCOZmXAiZghkwx6dHO
         oVlriJTM+uY57DuLelLhUTBUf/0MjzQGzhci5YUNJ4x14/rUKOlivoV0rXyv1cZtH0h2
         YIIPRFrmviktnfHKyDmB6Y2GOr/bZJF4KZVDsWk+rNAmSY3AnuiVPYaSLyeMFWqA9oN4
         8WeixXcgcoxeGc6LITPXoSHb8sxWQ/IQ8wGmJfEcjOj5g8vaJhAbVVCp+WBMP/okFtxJ
         tlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gp5dgQ+KrAXtaDXnmH+hgIgyuiOZdMItxtBMeH5X92U=;
        b=iskuS7ZYJzPHZB1xOlMM6ymwK8y8bdm4iuNqZ7DG428orZVnSI8HdmQXxCjHRuK5K5
         Cmpiv77S/QfKzWnHXidPjeRBpe1zDDeI/H0WXI6AgOLLKg43fW5bOavwqpKmp/vnJoUX
         oy/9huIu4WM3jAMJvwzUa+v/QE/IX4+29PTOHdDkcIZHvROaFI8sSDM+40WQ/lZEa6vk
         Rw6liido79ML2/xPs36z6jd+x9Iq/yuA3SPmlxglkvZfyXXxKEGYyvOCH4HACWgvH3gd
         vw9f3lPppHbV/qU/rteC+p2YCiOiFh3MOp/dblH0vWPpr8J8n/ei87uRkY10bgWntB4a
         gMZg==
X-Gm-Message-State: ANoB5pntYnGhetuGK++3wxBCl8eMLSvpM/1UxPqtZ6kpr7FqoDb8thfm
        qTGHTcWhEpXQgJfMMUDZ+jvHUw==
X-Google-Smtp-Source: AA0mqf4UZVM4yVbRpiMg0t/0x2Un++XfcRfnsvn7nK62mjI+6WqQ78XtRcOWjOAmkPDXD1QJoD0ivA==
X-Received: by 2002:a05:600c:3549:b0:3c6:e61e:ae8c with SMTP id i9-20020a05600c354900b003c6e61eae8cmr28188109wmq.28.1671093498117;
        Thu, 15 Dec 2022 00:38:18 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id j9-20020a05600c190900b003b4cba4ef71sm6126877wmq.41.2022.12.15.00.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 00:38:17 -0800 (PST)
Date:   Thu, 15 Dec 2022 09:38:15 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@nvidia.com
Subject: Re: [PATCH net 1/3] devlink: hold region lock when flushing snapshots
Message-ID: <Y5rc94kpwfvdVL/q@nanopsycho>
References: <20221215020102.1619685-1-kuba@kernel.org>
 <20221215020102.1619685-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215020102.1619685-2-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 03:01:00AM CET, kuba@kernel.org wrote:
>Netdevsim triggers a splat on reload, when it destroys regions
>with snapshots pending:
>
>  WARNING: CPU: 1 PID: 787 at net/core/devlink.c:6291 devlink_region_snapshot_del+0x12e/0x140
>  CPU: 1 PID: 787 Comm: devlink Not tainted 6.1.0-07460-g7ae9888d6e1c #580
>  RIP: 0010:devlink_region_snapshot_del+0x12e/0x140
>  Call Trace:
>   <TASK>
>   devl_region_destroy+0x70/0x140
>   nsim_dev_reload_down+0x2f/0x60 [netdevsim]
>   devlink_reload+0x1f7/0x360
>   devlink_nl_cmd_reload+0x6ce/0x860
>   genl_family_rcv_msg_doit.isra.0+0x145/0x1c0
>
>This is the locking assert in devlink_region_snapshot_del(),
>we're supposed to be holding the region->snapshot_lock here.
>
>Fixes: 2dec18ad826f ("net: devlink: remove region snapshots list dependency on devlink->lock")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Ooup.

Thanks for the fix.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
