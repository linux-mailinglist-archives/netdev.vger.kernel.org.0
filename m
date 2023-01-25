Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA0167A8CF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjAYCds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAYCdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:33:47 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF464FAD3;
        Tue, 24 Jan 2023 18:33:44 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id d6-20020a056830138600b0068585c52f86so10374147otq.4;
        Tue, 24 Jan 2023 18:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yvS/osoXoyuM5QQs9Bhw9Oc0kNTSAYIFAoEjAactrnI=;
        b=W4cszxis8qy6UraFHhoya3JNW4HuN33BdirHvHZg9UjnAFdRSyUz3YzThAGg9LHL5D
         +Of0jOmaOLFf7B9/jaYAb1jGUtXYyq0vgb2P1dyiaWj6W2XnvX7j/pjwEanUIZnzbMzf
         hiezT7Lc1g4iqeQkBTwHzg7ouNw5lhf9pah9P/fgVstpHeNAt3bps6+eSQskwHTihr+a
         +7qOxOfWz2SSvJOKYRkvnr4tcX6twLfExEvdUgzJ01rFCr1Y02SAZpyMN51G2TOOv9j/
         1HWPqz5+fM4YqBKJ31+zBdzd4WhNtyj2dBvEuhG4TZKUIIrsOzxKQuH+F0IgatCARP9R
         9p8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvS/osoXoyuM5QQs9Bhw9Oc0kNTSAYIFAoEjAactrnI=;
        b=43Dq5rTgiGhWTQKPYSmaKzyXw2CJkpREJgmuplk7Pi3NJTeshiv4JeHg6sU6AT1Ma6
         yKtcYwvrIPKwuc1ASYaNqqgGwIq7XH957UetEgSpP+p2BgdjFPQYBaTsAmnjBOrGXvrA
         jXZP3FVwlvqGwBglmAEexchcxeFZ+7qxHNav0jm5xBtDHng/h/ZA3HzU08SIchlC/IT+
         ZxHmHr3n+AQxzzAyrhz0CIHEwC7QqzAXymq/LeQRWwrd2SaoK366hvU0eu5X02M+R9he
         t1JOdM7SFHHXKuTwaX1QZeRYOjR8Z9uFoOvUzcxU+81nyv5XzQHdYd42fyRCsmgAxw3z
         mpag==
X-Gm-Message-State: AFqh2ko9Li5JYbZ2LNYXdendk7JbI5C189IWFrtZWNJBKTt/D0dprVVy
        Euau473qFUlaAT7ERsRaO6A=
X-Google-Smtp-Source: AMrXdXv/rQPtIIMhnuQ5GyyvhVPq1ZQW0HQl/nM8A60EWZC7lfNAvjBC3btCNzAjo1/nHksF+KKTcw==
X-Received: by 2002:a05:6830:61a:b0:685:e5d6:7539 with SMTP id w26-20020a056830061a00b00685e5d67539mr18033257oti.25.1674614023813;
        Tue, 24 Jan 2023 18:33:43 -0800 (PST)
Received: from t14s.localdomain ([177.220.174.102])
        by smtp.gmail.com with ESMTPSA id 22-20020a9d0316000000b006864b75be16sm1664479otv.19.2023.01.24.18.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 18:33:43 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 076044AF042; Tue, 24 Jan 2023 23:33:40 -0300 (-03)
Date:   Tue, 24 Jan 2023 23:33:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>
Subject: Re: [PATCH net] sctp: fail if no bound addresses can be used for a
 given scope
Message-ID: <Y9CVBJV2B4MhEXab@t14s.localdomain>
References: <9fcd182f1099f86c6661f3717f63712ddd1c676c.1674496737.git.marcelo.leitner@gmail.com>
 <20230124181416.6218adb7@kernel.org>
 <Y9CUPsuuYgdr/g+s@t14s.localdomain>
 <20230124183211.14b73da5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124183211.14b73da5@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 06:32:11PM -0800, Jakub Kicinski wrote:
> On Tue, 24 Jan 2023 23:30:22 -0300 Marcelo Ricardo Leitner wrote:
> > Lost in Narnia again, I suppose. :)
> 
> :D
> 
> > Ok, I had forgot it, but now checking, it predates git.
> > What should I have used in this case again please? Perhaps just:
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> Yup, just slap the initial commit ID on it. Let me add when applying.

Ok. Thanks!
