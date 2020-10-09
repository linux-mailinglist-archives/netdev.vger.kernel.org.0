Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB741288698
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 12:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387510AbgJIKMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 06:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgJIKMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 06:12:45 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B86C0613D2;
        Fri,  9 Oct 2020 03:12:45 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id x7so2133496eje.8;
        Fri, 09 Oct 2020 03:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Pu6uFYl5g3lWcF1Rf0VrnUrLJTa6VGuUqdl8E16TQmI=;
        b=JIxKJHC35w3/PF+7f04UAQOW8ZrXMCY89C4aZn0BU9wOCIWohsh5nFBNPbceAsv575
         NUTUL6jIkD5JaokEejtHZPzRyCgHo77espaNNIsydVTc29T1Osv0+ZLqfKyny7E717t+
         taqqYZylTX9LbGRW1tSCmHk/wOJBEvzEl4Prdq2hWQf05uB4Gs3Mivn22QdyVZNSO7IF
         k4ruanWe3DRCjzlRhHytK+RMOHhvKc9O+Q5rrbcWN7M5b2pFb8g1Rbh3BQ1BmSvl4eQg
         YlDL6b9DJso2CKzuotE7JFYusQbJ/BDFRzf5/n/FtO6l6RM+Bt+sQea7vgWhM8lJpjLs
         1uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pu6uFYl5g3lWcF1Rf0VrnUrLJTa6VGuUqdl8E16TQmI=;
        b=XKBZbu7RULem7CpcLegvNYijfJ99Co1Zx/5ZSyeORUr0ERKhYoi2UqE5WqJsVV4hCN
         Qz06G3OZesxgTiHM5fjoeLEH/as5fB2CRQohQkJ0SgxVBKaw3oVhkEZEHMfRPVDQHLxq
         kCafui/Qy7QpzimJmrBRfNNRivS396U5v1luk/8Lqu8ZiTWZrpvy9Z9Fqia2hwNDw/2N
         A0vGr+/4KMH97wCtw/LpOvHUoRa60VIwOcD7sH2OH7li+Ks4sCimoyBFlSGjd3NgalM7
         lIl4O0BsjI2MtHcwb8bbEDISQUd7E7ml1WiSv2zXdElyPHt4H6oJ727e7/nOl9jhRDA4
         xuyg==
X-Gm-Message-State: AOAM532uVR+Gk92yHtLQ3yRQU8CwxYyOqq6BrrNz554MjMA/A8ivKsPD
        hNUfMo2w3Id4TE4uDxMAu/c=
X-Google-Smtp-Source: ABdhPJxp66T3ofOaQiKnvkErLduT7emZPOyZINsZU/nAVBl8G5RKHaZy40JF3sEcWbbrqCq6CWTBcg==
X-Received: by 2002:a17:906:bc91:: with SMTP id lv17mr13978607ejb.249.1602238364034;
        Fri, 09 Oct 2020 03:12:44 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id n22sm6012278eji.106.2020.10.09.03.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 03:12:43 -0700 (PDT)
Date:   Fri, 9 Oct 2020 13:12:41 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     John Keeping <john@metanate.com>
Cc:     netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
Message-ID: <20201009101241.qr6blbfyamtuzrwy@skbuf>
References: <20201008162749.860521-1-john@metanate.com>
 <20201008234609.x3iy65g445hmmt73@skbuf>
 <20201009105945.432de706.john@metanate.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009105945.432de706.john@metanate.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 10:59:45AM +0100, John Keeping wrote:
> No, it's not, although I would have saved several days debugging if it
> was!  I backported the lockdep warning to prove that it caught this
> issue.
>
> The evidence it is possible to see on vanilla 5.4.x is:
>
> 	$ trace-cmd report -l
> 	irq/43-e-280     0....2    74.017658: softirq_raise:        vec=3 [action=NET_RX]
>
> Note the missing "d" where this should be "0d...2" to indicate hardirqs
> disabled.

Cool, makes sense.
