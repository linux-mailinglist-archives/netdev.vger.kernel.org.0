Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7219966001B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjAFMSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjAFMSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:18:25 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE1A736DA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:18:24 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a30so936286pfr.6
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:18:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ptXOrC+Dvw9rpK3vgbn5BZFbQi4xFwSctHFnYUozeLM=;
        b=1pQj22aEs9YRCl7pN5yEC/GqUvqQZdGnwVv8NAoE+Ysg1E3SrwuW+63fNSN4jd6Tyc
         OwylFZwnb2/EotodzogOBivQtOP3wLDfxaV6V9sFBK8+b753Vo175V0PVztw7+Ohff0D
         T7DirN/WtYwDQghnJsE11uaOVDsFgmh6DeWUhl4oq52z7ArigoXJVTnkguvtravG8kyc
         VZyzv7d7dJLhC7sc4t+Yp55/6Bi9l2vXbivLBthcpJCiTqQHEMbPOhc3xskRdGh4eIFk
         ot27gtyZso0qXkVbyguXyPI+DsWaKO9TyyXvioOjruoxR3y5HRQWem6eSGRmXZyJBb9s
         Ft7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptXOrC+Dvw9rpK3vgbn5BZFbQi4xFwSctHFnYUozeLM=;
        b=yi7md7U97KY1v0II3uUpyBIWhlw7hrGdYx5fgC7WPV6lihvOcEnQNcm0st2fCe9zod
         VwiTBL244JliHDS6vShVnlfEowZbutUQ3yyiB9MjArzzN7tjMio+IIzS7YT4kXK41BIO
         T1hz1+X47eoRXyNktVraTc70cmknudWszPL/eBm80gg4oCEzOx9CPQvRnAjJ4/XeJIcv
         w2InO+kWxNw4ptaxKz1i2PR05n3RZm2u5OKQtmbgxJT+iUDIdA20g5xR+qfg6YNxz2kK
         rGxmHNepuPxXPzdvfy4U5LFH+u8nNqEN6d6tB9GXHisbfsRl5lOAOecKHJuB0JxNUYc0
         TI8w==
X-Gm-Message-State: AFqh2ko+ypmIdRV9xKDOHNDCK8YToAWEv8/T8UWqGlXLq8pcVsL5q9u1
        rpcXW5yQBtah6uUS5XPNjjPu3A==
X-Google-Smtp-Source: AMrXdXshG2xKs+YDQXIX80nnbUyee0Tw9MtO9cHimN9NPKUFdOIwmvOS8dy4ZHLqORtgTc7Y9Xy+jw==
X-Received: by 2002:aa7:828c:0:b0:57f:eb31:c306 with SMTP id s12-20020aa7828c000000b0057feb31c306mr48960279pfm.1.1673007504244;
        Fri, 06 Jan 2023 04:18:24 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id w66-20020a627b45000000b00582bdaab584sm1001885pfc.81.2023.01.06.04.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:18:23 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:18:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 3/9] devlink: protect devlink->dev by the
 instance lock
Message-ID: <Y7gRjN/yVZRKPwbh@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-4-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:33:56AM CET, kuba@kernel.org wrote:
>devlink->dev is assumed to be always valid as long as any
>outstanding reference to the devlink instance exists.
>
>In prep for weakening of the references take the instance lock.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
