Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE6D397A99
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 21:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhFATVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 15:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhFATVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 15:21:38 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A23C061574
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 12:19:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 11so3922605plk.12
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 12:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wa3tfZkQDm9TvrFXBZKWvxHdH+rOnl8AA6gAmq+Y2uM=;
        b=CYG5wL1m+hCUv7NGyL8Px1fwffuroKyA9gqy5GOPvLkphf7CjzplzTJ19fSryAdE4R
         f2A2IhQAFxuyCKISyCs8zLzitEbGgQNVEuChC8k+xLlZBoEiu9iJzXj6GFmycwfsZrxF
         XUBXttcIy07v84XPj08DmBxZekJq03S95PkO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wa3tfZkQDm9TvrFXBZKWvxHdH+rOnl8AA6gAmq+Y2uM=;
        b=OrGRw97DhPNe+/4rVnFUNCukMAUfa203tP5mt9BT6lsW/vMej3Dc5j7tCgxXrFewGe
         8m0lF9LyT2ezycvERy+99VUrV4a8b4I4nrMejgU895+CnLN1HOnyzq+RuIVAjvb30TLA
         JTuo5jCZQrI9KsFdWEyVSLlhCe8KCGsw5fvHRjS5ZW0dm8HCCM9oUaQM+cmycrgHQYMI
         AryrClap7E7mYY3YfOWCeJtDJ+n3GmUs+G1CUtkK7thQvIDC5KEo8Yc941I75qeCC9Ok
         X/+fAdrOg8NFfh0dQ6vNAQuo2RlFtjmm1R6vzn2+HJJ+ruPH0sOQofP+Ouw9RVm2go5g
         mRcA==
X-Gm-Message-State: AOAM530MN/7zhnwpHvCQnMYbq0qX6+64Z3UcgKpMIlwfKKAYlq+B2+Zq
        V7IZ9aiFD+D6DO+O0ca974Cf8A==
X-Google-Smtp-Source: ABdhPJysqN3oMZZG8qhK3KubBfIOYsd0zeYnnq+4hXl13bxXx0uESRScyJhRv4+mAdyWJvMCLRGBwQ==
X-Received: by 2002:a17:90b:1c0a:: with SMTP id oc10mr13444939pjb.7.1622575196225;
        Tue, 01 Jun 2021 12:19:56 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n6sm15455368pgm.79.2021.06.01.12.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 12:19:55 -0700 (PDT)
Date:   Tue, 1 Jun 2021 12:19:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] net: axienet: Fix fall-through warning for Clang
Message-ID: <202106011219.3B06ABBF@keescook>
References: <20210528195831.GA39131@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528195831.GA39131@embeddedor>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 02:58:31PM -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding a fallthrough statement instead of just
> letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
