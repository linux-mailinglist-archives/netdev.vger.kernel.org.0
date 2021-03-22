Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0FD34360B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 01:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhCVAy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCVAyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 20:54:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2D1C061574;
        Sun, 21 Mar 2021 17:54:11 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id c17so2929711pfn.6;
        Sun, 21 Mar 2021 17:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZqTdh65re5NOM88Bvn/Ypjdea75IBIwk3x5yx/WoBHk=;
        b=mAjRKsiHwBtW0yF3hWXsRMbk6nXYqyDwKcILPuoELgnTAbFFFLJ4l7AfkO5Dy6mC8e
         vTct0XhX3cAlVrolU2tzrlFqgf7DkTXloU3xKURQbKglhtlZ7OFXJx52AfnFZwpvb/X9
         gYlfrTjc58M0cKOQ7R+Ociy/5xKopHigb+fMdf+u4AEjalojcUcnBnJ9oPaJH7RM4+nZ
         36ZUhq1mA4r/n87dHdGc9Vn1zISngvOIYWJAjME4EaeAUs8aj1ffVbbHhg+ZXbVooelq
         LsrIdWCMLt+Oyrob/4zJP53WLSKpvC1SEKqHpaoCeS+yPIKjOcooJR6/S5Ag6Tz+TdVp
         OvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZqTdh65re5NOM88Bvn/Ypjdea75IBIwk3x5yx/WoBHk=;
        b=OiSqiBLB8jnp/3L+rzN5tMTqTXRlVMDzOeamIyiRN/Fv0qpSa4XG5zhk0Wq8tc9ayI
         7aToxEPFZhkHp7pU4Z1haexOytG0ndH01YIvdBKtF8C1bhlex6uDmrBGyrpSNdmJL5OL
         ilO/P+kEJj5WqVuHPL1BhCZsvEbgu0xDJ2yLRghIir8aNSpG/q8LElI09GTyREcP25BS
         eJ3dmrbv0UZ2PHsMwZYt7dRBn/G5Ft9PJOFyydZvKmD6/W7xJ9fUAhABkwb+MHvNZe9/
         v6DwVJbGu1XYIT/fLxt+S/ES0mndLT95twRrahGHZgM+whcIabrIcoCbrB9PlH+JEqto
         HNNQ==
X-Gm-Message-State: AOAM530JFtDol0dY8Kc7Pf+TGKIzHSIEq8qymYC+9ZyXYZfWcg+F0Ked
        uQUQ2PMwPmo/tKbygu/OtAQ=
X-Google-Smtp-Source: ABdhPJw4lpgpAKfGRVTZaPAl07QBplRcpsy2yzbtRBV88WTFH8ZitWQYeVsNFR8P76uyq4NxVdoUCA==
X-Received: by 2002:a62:3706:0:b029:211:3d70:a55a with SMTP id e6-20020a6237060000b02902113d70a55amr16219198pfa.16.1616374450057;
        Sun, 21 Mar 2021 17:54:10 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id i10sm17589687pjm.1.2021.03.21.17.54.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 21 Mar 2021 17:54:09 -0700 (PDT)
Date:   Mon, 22 Mar 2021 08:54:01 +0800
From:   Sieng Piaw Liew <liew.s.piaw@gmail.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     chris.snook@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atl1c: optimize rx loop
Message-ID: <20210322005326.GA24403@DESKTOP-8REGVGF.localdomain>
References: <20210319040447.527-1-liew.s.piaw@gmail.com>
 <20210319041535.GA3441@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319041535.GA3441@1wt.eu>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 05:15:35AM +0100, Willy Tarreau wrote:
> On Fri, Mar 19, 2021 at 12:04:47PM +0800, Sieng Piaw Liew wrote:
> > Remove this trivial bit of inefficiency from the rx receive loop,
> > results in increase of a few Mbps in iperf3. Tested on Intel Core2
> > platform.
> > 
> > Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>
> > ---
> >  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > index 3f65f2b370c5..b995f9a0479c 100644
> > --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> > @@ -1796,9 +1796,7 @@ static void atl1c_clean_rx_irq(struct atl1c_adapter *adapter,
> >  	struct atl1c_recv_ret_status *rrs;
> >  	struct atl1c_buffer *buffer_info;
> >  
> > -	while (1) {
> > -		if (*work_done >= work_to_do)
> > -			break;
> > +	while (*work_done < work_to_do) {
> 
> It should not change anything, or only based on the compiler's optimization
> and should not result in a measurable difference because what it does is
> exactly the same. Have you really compared the compiled output code to
> explain the difference ? I strongly suspect you'll find no difference at
> all.
> 
> Thus for me it's certainly not an optimization, it could be qualified as
> a cleanup to improve code readability however.
> 
> Willy

You're right. Objdump and diff showed no difference.

Regards,
Sieng Piaw
