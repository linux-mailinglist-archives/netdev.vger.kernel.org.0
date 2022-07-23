Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18E057F022
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 17:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiGWPlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 11:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGWPlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 11:41:14 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384051EC7E
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 08:41:12 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t3so9028140edd.0
        for <netdev@vger.kernel.org>; Sat, 23 Jul 2022 08:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uH0fRA9QgP1SgBU0AbRb25SmklZdBXjQZVKS7So7Ado=;
        b=ukc16NFxICockWPXpdPuQ+hW1e2ve6MC1H+jsD/FuDgPS82jvIAKzIVJqdwsSfQ+jg
         GR5c9pt7k+CI5g+OKF2y3xnTAdyJsOWiMmdbWrkX3ChR6rmdxUQoNPhGhuXitqbm72BI
         X9UJLq+s91p5BvxVWCQdSjOK7WKKFIHVWqPIgYAP8AwFmAA7oMSoB19FY7Hg0Bomvho1
         s4BJR7ZBfeXKhDD6dcd3YJBXgrYoRE0y0xPgg0SHA5+H4TqJoU+xbD4xE3IftSIJ9N+R
         TwKmWPhoJUkv4IdmKdQVIYCz6JYnDXqzcThDghyPkJoUsr5Ig2OBmR0efoenQQjlPBsQ
         oxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uH0fRA9QgP1SgBU0AbRb25SmklZdBXjQZVKS7So7Ado=;
        b=ROfJCx4Nu3MiHRhEGKX/tbX15pGiXSg+/68wsbTFur3guoo+IFJcUzm2e2lxdnC8um
         G5nucyEUrcSeSni9oHpLwVpEXTZZv3g/7i/0HUMPsGlN5b662RdKmgVUcTUOXwKK0woP
         vAmudW0BUzsjnI8xN9oj5OhdIc3uOOQdh2VWYops0OTMz0j8KPo66UExJ44jBysVIrkR
         BjyoRSmooV1mwaAp15Uu9NtKDdZnkxDtuZa3X6NapX7+gM+Uvq03H7/eLMepDOPugS2F
         FfPJ8MmuJYUX8tueSSP0eeay8FzpyTDJ3AZ14MsSlmeexisA4BhjoMLyv93180AXAPiB
         9WcQ==
X-Gm-Message-State: AJIora86qJIFxsa/l+5YbHjS0esSrqqOdX1Yfp1ymquDDHzavY6CKQP7
        Ql9EJW3S2wHioWqEGC47F6k95A==
X-Google-Smtp-Source: AGRyM1sSMl49BvxItQNSZeOMwEpPqUCDj2Gl77dZULSIjpxwCz1vjkBXA6fA04l1bV6hDW1nx2zpgw==
X-Received: by 2002:aa7:d6da:0:b0:43b:a05c:cf74 with SMTP id x26-20020aa7d6da000000b0043ba05ccf74mr4763042edr.392.1658590870580;
        Sat, 23 Jul 2022 08:41:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v15-20020a17090606cf00b0072b810897desm3181762ejb.105.2022.07.23.08.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jul 2022 08:41:09 -0700 (PDT)
Date:   Sat, 23 Jul 2022 17:41:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 01/11] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YtwWlOVl4fyrz24D@nanopsycho>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-2-jiri@resnulli.us>
 <20220720174953.707bcfa9@kernel.org>
 <YtrHOewPlQ0xOwM8@nanopsycho>
 <20220722112348.75fb5ccc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722112348.75fb5ccc@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 22, 2022 at 08:23:48PM CEST, kuba@kernel.org wrote:
>On Fri, 22 Jul 2022 17:50:17 +0200 Jiri Pirko wrote:
>> >Plus we need to be more careful about the unregistering order, I
>> >believe the correct ordering is:
>> >
>> >	clear_unmark()
>> >	put()
>> >	wait()
>> >	notify()
>> >
>> >but I believe we'll run afoul of Leon's notification suppression.
>> >So I guess notify() has to go before clear_unmark(), but we should
>> >unmark before we wait otherwise we could live lock (once the mutex 
>> >is really gone, I mean).  
>> 
>> Kuba, could you elaborate a bit more about the live lock problem here?
>
>Once the devlink_mutex lock is gone - (unprivileged) user space dumping
>devlink objects could prevent any de-registration from happening
>because it can keep the reference of the instance up. So we should mark
>the instance as not REGISTERED first, then go to wait.

Yeah, that is what I thought. I resolved it as you wrote. I removed the
WARN_ON from devlink_notify(). It is really not good for anything
anyway.


>
>Pretty theoretical, I guess, but I wanted to mention it in case you can
>figure out a solution along the way :S I don't think it's a blocker
>right now since we still have the mutex.

Got it.
