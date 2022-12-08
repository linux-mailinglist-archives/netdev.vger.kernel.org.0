Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0AC6647179
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiLHOUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiLHOUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:20:33 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7662D83E97
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 06:20:31 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b2so4374643eja.7
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 06:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wpXZQ3SCN8rxh33mlDY3m3vsYY7cRWXxQsqC4V1e3G0=;
        b=qd7npxRoDDEp0UolFk9at6Dsu8sEKA2yUKPbKv8/oEQye1lz9UCgosYYmJRv+Nzl0Q
         NMg4ecAsnAYD2oQTEk0XRcKjqDPV9Cv8d0pyX/Wx1AcWj87vUoCYhxeg4/uNkHbetC4g
         kUyHI7E4ALgqQHCIPLzbKFGFKC5Ngf2cGgQPwHWQ8qJUbwVTNaIztdAr9KtS5oGsJ2lY
         a3TqDj8srKGR0Vlaz5iQ23hfcZfoqwtR/hVe8A+r2TEDYt1pQAKjbg1uKl+ZFw3ix8Iq
         ImdrksDjUG54C9bRjEpUlT4xpP6YkF9mISUQH5/A4vn8ffM6prTm736HqIRZWrtwLKnD
         o7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpXZQ3SCN8rxh33mlDY3m3vsYY7cRWXxQsqC4V1e3G0=;
        b=R8g9a5GJJJ0acR5V/8jdIcLNisb8HgHgBmZk8jHmFJA9Ef+7rq33rxi6cfmb3HiKUy
         nRbm4FGt6y2HfRFLZFBP08sf3d/SvAN5HT+BdMaJICeNpltx7zvCYDHFyRgsV0eA5864
         ISzmFuoeN9rkhYbCbdKfozhA6I8+Nc1howAPjRUxd8x00AWuCxCYwIyoV2yzXyLRDoyl
         czzNua8gg/GuUun5aW40s+1uWFr8x0Hi2Vdc6N9H6VEnrNzKnMVqaITNLdE8IGCyHnhu
         KLJRIKNxJG9rIFQW4qSnP24sLd4oY+Z3R89IVi+9qDvNiRMFT70LYw1sBLqMNbcy22ID
         rGdw==
X-Gm-Message-State: ANoB5pnVIaGbhJjJGpfDIl16dANgV6xSsDhusvXffsCA6X1/O2BvG/IN
        5LJ1OrA63fUa+jhRIm7XsiM=
X-Google-Smtp-Source: AA0mqf4f+7TgvXV2/y+oHve/uI4xVxR0lv/EVCmBVDaG8S0B61kDb3MZKOn54BDWU4t09dvQBSBIOg==
X-Received: by 2002:a50:ff0a:0:b0:46b:1231:3858 with SMTP id a10-20020a50ff0a000000b0046b12313858mr2040946edu.40.1670509229243;
        Thu, 08 Dec 2022 06:20:29 -0800 (PST)
Received: from skbuf ([188.26.185.87])
        by smtp.gmail.com with ESMTPSA id d36-20020a056402402400b004585eba4baesm3448190eda.80.2022.12.08.06.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 06:20:28 -0800 (PST)
Date:   Thu, 8 Dec 2022 16:20:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-switch: Fix memory leak in
 dpaa2_switch_acl_entry_add() and dpaa2_switch_acl_entry_remove()
Message-ID: <20221208142026.gxc4nvsejduoeirz@skbuf>
References: <20221205061515.115012-1-yuancan@huawei.com>
 <20221207115537.zf2ikns77bxyt74m@skbuf>
 <0d769f50-bbd1-4291-c3c0-29527b40fb98@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d769f50-bbd1-4291-c3c0-29527b40fb98@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 09:51:45AM +0800, Yuan Can wrote:
> Nice! Thanks for the suggestion, as the patch has been merged, let me send
> another patch to do this job.

The patch was merged at the same time as I was writing my reply.

Since the patch went to the "net.git" tree where only bug fixes are
accepted, any further rework would have to go to "net-next.git".
A resynchronization (merge net into net-next) takes place weekly, one
should take place later today or tomorrow, I think. So if you're going
to send a follow-up patch, I'd wait until "net-next" contains your
change.

That being said, it's not all that critical to follow up with another
patch. I simply hadn't noticed your patch was merged, but it does the
job as well, just not in the same style as the rest of these 2 functions.
