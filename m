Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266DB37C048
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbhELOhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhELOhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:37:32 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577FEC061574;
        Wed, 12 May 2021 07:36:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id z4so1035160pgb.9;
        Wed, 12 May 2021 07:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XHFz1AUQhthLuyvfQKtlXX4LXpuG6vLo1bOCg3QrkZo=;
        b=i3jOyKghni2mQg2K/X/IR88r7IcfCS8INVVrMqoxLyE1rPleaduJBw1+ATBAZTby1P
         dWGFP+0kNHb3/lWVqoEjj5z9rycG0aZrKEHQ0QrY/Uy9zf9emgiswJe6orAOiK/t1D2i
         kSimYL2ccc879rHI09fh8ISqRMj0/rwdVUn+/Hhsblbpdfjvgj2Hlh00BQ/tnHd39SkD
         rBRaAwF+/wwM6sFqo/v3qubmHFV7nsGcv6vMXkRc9kq4xH4UhM2GEkA22R0VGgr3se+9
         f0M0m+NIPn8axjVvk6chnWeMnm7TET4hXfHL5Q8MOIzhiYJP8unIVCyv3ZbwRbLkDxm6
         c63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XHFz1AUQhthLuyvfQKtlXX4LXpuG6vLo1bOCg3QrkZo=;
        b=FSql0+/UHL6ZP6zl6WrFB7B0ymL0xxvaQ03XeYdOx9UURQg3Nh2aQ2KvC2fhaKNQiG
         eweBUl4VzcXiFL39VBwrJqh/H8iQKyoiLyHWAPnM1QZfmNR8WGfslTPtLe9Y7WSLmZr+
         9jS48aDJteNdHcZ0+WVBzKneqh7+3tJ9ivDI+MDjmt3nfUOt7f1df0JbCd24PBp9/Bor
         SW4Bi9SDKXyQb39TLMubZc05gWcfB+5IHq/8TRYKRI2Ko8rIH1JyjLqn/D30ii4COzDt
         HIqpsw9J6xbMURlcevxI48BRCzqCJEnJUZj1qXkIZCQRS/P8752iLlYb5NB5NQUhhTYq
         4T4g==
X-Gm-Message-State: AOAM530xIdhi9V56ZipDc/+UoJyF1vBLNECL8nlrYxktY5qodHhclKdn
        Uuhn7YGnxQ+roQyR4h41tb6cOpJnBtE=
X-Google-Smtp-Source: ABdhPJwXt5MUPOJxBxkQ4TLe4aHkfOhSH4/gqUZPbBzXWoXM4fTjycA+2Ql6UXm7XJIB4CyN+gotJA==
X-Received: by 2002:aa7:955b:0:b029:28e:a874:d0c2 with SMTP id w27-20020aa7955b0000b029028ea874d0c2mr35349909pfq.66.1620830183906;
        Wed, 12 May 2021 07:36:23 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z3sm101998pfe.78.2021.05.12.07.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:36:22 -0700 (PDT)
Date:   Wed, 12 May 2021 07:36:20 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kuba@kernel.org, jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ptp: ocp: Fix a resource leak in an error handling path
Message-ID: <20210512143620.GE27051@hoboy.vegasvil.org>
References: <141cd7dc7b44385ead176b1d0eb139573b47f110.1620818043.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <141cd7dc7b44385ead176b1d0eb139573b47f110.1620818043.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 01:15:29PM +0200, Christophe JAILLET wrote:
> If an error occurs after a successful 'pci_ioremap_bar()' call, it must be
> undone by a corresponding 'pci_iounmap()' call, as already done in the
> remove function.
> 
> Fixes: a7e1abad13f3 ("ptp: Add clock driver for the OpenCompute TimeCard.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Richard Cochran <richardcochran@gmail.com>
